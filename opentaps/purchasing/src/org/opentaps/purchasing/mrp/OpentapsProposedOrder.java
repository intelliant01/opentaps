/*
 * Copyright (c) opentaps Group LLC
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

/*******************************************************************************
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *******************************************************************************/

/* This file is partially based on an OFBIZ file and has been modified by Open Source Strategies, Inc. */

package org.opentaps.purchasing.mrp;


import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Map;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.manufacturing.bom.BOMTree;
import org.ofbiz.manufacturing.mrp.MrpServices;
import org.ofbiz.manufacturing.mrp.ProposedOrder;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;

/**
 * Proposed Order Object generated by the MRP process or other re-Order process.
 * Note: this class only extend <code>ProposedOrder</code> to add support for the PENDING_INTERNAL_REQ requirements.
 */
public class OpentapsProposedOrder extends ProposedOrder {

    private static final String MODULE = OpentapsProposedOrder.class.getName();

    private boolean createPendingManufacturingRequirements;

    /**
     * Creates a new <code>OpentapsProposedOrder</code> instance.
     *
     * @param product a <code>GenericValue</code> value
     * @param facilityId a <code>String</code> value
     * @param manufacturingFacilityId a <code>String</code> value
     * @param isBuilt a <code>boolean</code> value
     * @param requiredByDate a <code>Timestamp</code> value
     * @param quantity a <code>BigDecimal</code> value
     * @param createPendingManufacturingRequirements a <code>boolean</code> value
     */
    public OpentapsProposedOrder(GenericValue product, String facilityId, String manufacturingFacilityId, boolean isBuilt, Timestamp requiredByDate, BigDecimal quantity, boolean createPendingManufacturingRequirements) {
        super(product, facilityId, manufacturingFacilityId, isBuilt, requiredByDate, quantity);
        this.createPendingManufacturingRequirements = createPendingManufacturingRequirements;
    }

    /**
     * Creates a ProposedOrder in the Requirement Entity calling the createRequirement service.
     * This method overrides the default ofbiz implementation to support creating Pending Manufacturing Requirements.
     *
     * @param ctx The DispatchContext used to call service to create the Requirement Entity record.
     * @param userLogin the user login <code>GenericValue</code> used to call the service
     * @return the requirementId
     */
    @SuppressWarnings("unchecked")
    @Override
    public String create(DispatchContext ctx, GenericValue userLogin) {

        /// -- All of the code hear is from org.ofbiz.manufacturing.mrp.ProposedOrder, except the indicated block -- ///

        if ("WIP".equals(product.getString("productTypeId"))) {
            // No requirements for Work In Process products
            return null;
        }

        LocalDispatcher dispatcher = ctx.getDispatcher();
        GenericDelegator delegator = ctx.getDelegator();
        Map parameters = UtilMisc.toMap("userLogin", userLogin);

        // if product is built get the requirement start date from the BOM
        if (isBuilt) {
            try {
                BOMTree tree = new BOMTree(productId, "MANUF_COMPONENT", null, BOMTree.EXPLOSION_MANUFACTURING, delegator, dispatcher, userLogin);
                tree.setRootQuantity(quantity);
                tree.print(new ArrayList());
                requirementStartDate = tree.getRoot().getStartDate(manufacturingFacilityId, requiredByDate, true);
            } catch (Exception e) {
                Debug.logError(e, "Error : computing the requirement start date. " + e.getMessage(), MODULE);
            }
        }
        parameters.put("productId", productId);
        parameters.put("statusId", "REQ_PROPOSED");
        parameters.put("requiredByDate", requiredByDate);
        parameters.put("requirementStartDate", requirementStartDate);
        parameters.put("quantity", quantity);
        // if product is built, create a manufacturing requirement, else a product requirement (order)
        if (isBuilt) {
            parameters.put("facilityId", manufacturingFacilityId);
            /// -- Customization here: support for the flag createPendingManufacturingRequirements, if set we create PENDING_INTERNAL_REQ instead of INTERNAL_REQUIREMENT -- ///
            if (createPendingManufacturingRequirements) {
                parameters.put("requirementTypeId", "PENDING_INTERNAL_REQ");
            } else {
                parameters.put("requirementTypeId", "INTERNAL_REQUIREMENT");
            }
        } else {
            parameters.put("facilityId", facilityId);
            parameters.put("requirementTypeId", "PRODUCT_REQUIREMENT");
        }

        if (mrpName != null) {
            parameters.put("description", "MRP_" + mrpName);
        } else {
            parameters.put("description", "Automatically generated by MRP");
        }

        try {
            Map result = dispatcher.runSync("createRequirement", parameters);
            return (String) result.get("requirementId");
        } catch (GenericServiceException e) {
            Debug.logError(e, "Error : createRequirement with parameters = " + parameters + "--" + e.getMessage(), MODULE);
            MrpServices.logMrpError(/* mrpId */ null, productId, "Error creating requirement", delegator);
            return null;
        }
    }

}
