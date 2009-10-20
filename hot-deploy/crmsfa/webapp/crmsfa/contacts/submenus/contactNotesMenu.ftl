<#--
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
-->
<#-- Copyright (c) 2005-2006 Open Source Strategies, Inc. -->

<#-- TODO: this can be refactored for all note creation (put in includes/, use ${uri} to call) -->
<div class="subSectionHeader">
    <div class="subSectionTitle">${uiLabelMap.CrmNotes}</div>
    <#if hasUpdatePermission?exists>
    <div class="subMenuBar"><a class="subMenuButton" href="createContactNoteForm?partyId=${partySummary.partyId}">${uiLabelMap.CrmCreateNew}</a></div>
    </#if>
</div>
