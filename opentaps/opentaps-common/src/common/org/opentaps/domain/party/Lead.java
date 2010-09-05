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
package org.opentaps.domain.party;

import org.opentaps.base.entities.PartySupplementalData;
import org.opentaps.foundation.repository.RepositoryException;

/**
 * Domain class for CRMSFA lead.
 */
public class Lead extends Party {

    /**
     * Default constructor.
     */
    public Lead() {
        super();
    }

    /**
     * Gets a lead company name.
     * @return company name from related <code>PartySupplementalEntity</code>
     * @throws RepositoryException
     */
    public String getCompanyName() throws RepositoryException {
        PartySupplementalData supplementalData = getPartySupplementalData();
        return supplementalData != null ? supplementalData.getCompanyName() : null;
    }
}
