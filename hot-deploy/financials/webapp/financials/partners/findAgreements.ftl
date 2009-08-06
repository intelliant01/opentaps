<#--
 * Copyright (c) 2006 - 2009 Open Source Strategies, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the Honest Public License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * Honest Public License for more details.
 *
 * You should have received a copy of the Honest Public License
 * along with this program; if not, write to Funambol,
 * 643 Bair Island Road, Suite 305 - Redwood City, CA 94063, USA
-->

<@import location="component://opentaps-common/webapp/common/includes/lib/opentapsFormMacros.ftl"/>

<div class="subSectionBlock">
    <form method="post" action="<@ofbizUrl>findPartnerAgreements</@ofbizUrl>" name="findPartnerForm" style="margin: 0pt;">
        <@inputHidden name="performFind" value="Y"/>
        <#if agreementTypeId?has_content>
            <@inputHidden name="agreementTypeId" value="${agreementTypeId}"/>
        </#if>
        <#if partyIdFrom?has_content>
            <@inputHidden name="partyIdFrom" value="${partyIdFrom}"/>
        </#if>
        <#if roleTypeIdFrom?has_content>
            <@inputHidden name="roleTypeIdFrom" value="${roleTypeIdFrom}"/>
        </#if>
        <#if roleTypeIdTo?has_content>
            <@inputHidden name="roleTypeIdTo" value="${roleTypeIdTo}"/>
        </#if>
        <#if parameters.partyId?has_content>
            <#assign partyIdTo = parameters.partyId/>
        </#if>
        <table class="twoColumnForm">
            <@inputSelectRow title="${uiLabelMap.OpentapsPartner}" name="partyIdTo" list=partners required=false key="partyId" ; option>
              ${option.groupName} (${option.partyId})
            </@inputSelectRow>
            <@inputSelectRow name="statusId" list=statuses?default([]) title="${uiLabelMap.CommonStatus}" required=false ; option>
            	${option.get("description", locale)}
            </@inputSelectRow>
            <@inputSubmitRow title="${uiLabelMap.CommonFind}"/>
        </table>
    </form>
</div>
