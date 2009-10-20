/*
 * Copyright (c) 2006 - 2009 Open Source Strategies, Inc.
 *
 * Opentaps is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Opentaps is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Opentaps.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.opentaps.tests.framework;

import java.math.BigDecimal;

import org.ofbiz.base.util.Debug;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.opentaps.tests.OpentapsTestCase;

/**
 * Tests known race conditions in the code.
 */
public class RaceConditionTests extends OpentapsTestCase {

    private static final String MODULE = RaceConditionTests.class.getName();

    /**
     * Tests the GenericDelegator.setNextSubSeqId() method for a race condition that causes pk violations.
     * Notably occurs in minilang services that use the make-next-seq-id directive.  One known entity with
     * issues is InventoryItemDetail, for which we'll create one in different threads for WG-1111.
     * @exception Exception if an error occurs
     */
    public void testNextSubSeqIdForInventoryItem() throws Exception {

        // first create a fresh inventory item
        String inventoryItemId = delegator.getNextSeqId("InventoryItem");

        GenericValue inventoryItem = delegator.makeValue("InventoryItem");
        inventoryItem.put("inventoryItemId", inventoryItemId);
        inventoryItem.put("productId", "WG-1111");
        inventoryItem.put("inventoryItemTypeId", "NON_SERIAL_INV_ITEM");
        inventoryItem.put("ownerPartyId", "Company");
        inventoryItem.put("facilityId", "WebStoreWarehouse");
        inventoryItem.put("unitCost", new BigDecimal("22.0"));
        inventoryItem.put("currencyUomId", "USD");
        inventoryItem.create();

        // create our special thread objects, which suspend themselves right after calling setNextSubSeqId
        InventoryItemThread t1 = new InventoryItemThread(inventoryItemId);
        InventoryItemThread t2 = new InventoryItemThread(inventoryItemId);
        t1.start();
        t2.start();

        // wait until the seqIds have been set
        while (t1.isSettingSeqId()) { Thread.sleep(1000); Debug.logInfo("Waiting for InventoryItemThread 1 ...", MODULE); }
        while (t2.isSettingSeqId()) { Thread.sleep(1000); Debug.logInfo("Waiting for InventoryItemThread 2 ...", MODULE); }

        // see if the creation of inventoryItemDetailSeqId was successful
        assertNotNull("Failed to create inventoryItemDetailSeqId via delegator.setNextSubSeqId in thread 1", t1.inventoryItemDetailSeqId);
        assertNotNull("Failed to create inventoryItemDetailSeqId via delegator.setNextSubSeqId in thread 2", t2.inventoryItemDetailSeqId);

        // start up t1 again to create the entity
        t1.resumeTest();

        // wait for it to finish
        while (!t1.isFinished()) {
            Thread.sleep(1000); Debug.logInfo("Waiting for InventoryItemThread 1 (2) ...", MODULE);
        }

        // if we were not successful, then fail with the exception
        if (!t1.success) {
            if (t1.e != null) {
                throw t1.e;
            }
            fail("Thread 1 did not succeed as expected for unknown reason.  No exception thrown.");
        }

        // now run the next thread, which should hold a conflicting PK and see if it crashes
        t2.resumeTest();
        while (!t2.isFinished()) {
            Thread.sleep(1000); Debug.logInfo("Waiting for InventoryItemThread 2 (2) ...", MODULE);
        }
        if (!t2.success) {
            if (t2.e == null) {
                fail("Thread 2 did not succeed as expected for unknown reason.  No exception thrown.");
            }
            if (t2.e instanceof GenericEntityException) {
                fail("GenericEntityExeption encountered, this is probably a race condition.  Check if following message contains PK violation on inventoryItemDetailSeqId:\n " + t2.e.getMessage());
            } else {
                throw t2.e;
            }
        }
    }

    /**
     * Special thread object to force a conflict in getting the next inventoryItemDetailSeqId.
     */
    class InventoryItemThread extends Thread {
        protected String inventoryItemId;
        protected boolean halted = true;
        protected boolean finished = false;
        protected boolean settingSeqId = true;

        public boolean success = false;
        public Exception e = null;
        public String inventoryItemDetailSeqId = null;

        public InventoryItemThread(String inventoryItemId) {
            this.inventoryItemId = inventoryItemId;
        }

        public boolean isSettingSeqId() { return settingSeqId; }
        public boolean isFinished() { return finished; }
        public void resumeTest() { synchronized (this) { halted = false; } }

        @Override public void run() {
            GenericValue detail = delegator.makeValue("InventoryItemDetail");
            detail.put("inventoryItemId", inventoryItemId);
            detail.put("quantityOnHandDiff", BigDecimal.ONE);
            detail.put("availableToPromiseDiff", BigDecimal.ONE);

            // get the next sub seq id using standard sequence
            inventoryItemDetailSeqId = delegator.getNextSeqId("InventoryItemDetail");
            detail.put("inventoryItemDetailSeqId", inventoryItemDetailSeqId);
            settingSeqId = false;

            // sleep until we're told to resume
            while (halted) {
                try {
                    sleep(100);
                } catch (InterruptedException ie) {
                    this.e = ie;
                    finished = true;
                    return;
                }
            }

            // create and if we get an exception (pk violation is what we're looking for) then the case fails
            try {
                detail.create();
            } catch (GenericEntityException ge) {
                this.e = ge;
                finished = true;
                return;
            }

            finished = true;
            success = true;
        }
    }

}
