<#--
 * Copyright (c) 2009 Open Source Strategies, Inc.
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
<#if viewPreferences?has_content && viewPreferences.MY_OR_TEAM_OPPS?has_content> 
    <@gwtWidget id=findOpportunityWidget class="subSectionBlock" viewPref="${viewPreferences.MY_OR_TEAM_OPPS}"/>
<#elseif findOpportunityWidget?has_content && "myOpportunities" == findOrderWidget> 
    <!-- using MY_VALUE as default viewPref -->    
    <@gwtWidget id=findOpportunityWidget class="subSectionBlock" viewPref="MY_VALUES"/>    
<#else>
    <@gwtWidget id=findOpportunityWidget class="subSectionBlock"/>
</#if>