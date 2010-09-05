<#--
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
-->

<@import location="component://opentaps-common/webapp/common/includes/lib/opentapsFormMacros.ftl"/>

<#if originFacility?exists && originFacility.facilityId = parameters.facilityId>
<#assign outboundLinks><a href="<@ofbizUrl>ShipmentBarCode.pdf?shipmentId=${parameters.shipmentId}</@ofbizUrl>" target="_blank" class="subMenuButton">${uiLabelMap.WarehouseBarCode}</a><a href="<@ofbizUrl>PackingSlip.pdf?shipmentId=${parameters.shipmentId}</@ofbizUrl>" target="_blank" class="subMenuButton">${uiLabelMap.ProductPackingSlip}</a></#assign>
</#if>

<@sectionHeader title=uiLabelMap.OrderShipmentInformation>
      <div class="subMenuBar"><a href="<@ofbizUrl>EditShipment?shipmentId=${parameters.shipmentId}</@ofbizUrl>" class="subMenuButton">${uiLabelMap.CommonEdit}</a>${outboundLinks?if_exists}</div>
</@sectionHeader>
