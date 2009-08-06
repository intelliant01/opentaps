<#--
 * Copyright (c) 2009 - 2009 Open Source Strategies, Inc.
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

<#assign mustBalanceSelectValues = {"Y": uiLabelMap.CommonYes, "N": uiLabelMap.CommonNo} />

<@sectionHeader title=uiLabelMap.FinancialsAccountingTagsPostingChecks />
<div class="screenlet-body">
  <form method="post" action="<@ofbizUrl>updateAccountingTagPostingCheck</@ofbizUrl>" name="updateAccountingTagPostingCheck">
    <@inputHidden name="organizationPartyId" value=organizationPartyId />
    <table class="listTable" style="border:0">
      <tr class="listTableHeader">
        <@displayCell text="" />
        <@displayCell text=uiLabelMap.FinancialsAccountingTagsMustBalance />
        <@displayCell text="" />
        <@displayCell text=uiLabelMap.FinancialsAccountingTagsMustBalance />
        <@displayCell text="" />
        <@displayCell text=uiLabelMap.FinancialsAccountingTagsMustBalance />
      </tr>
      <#-- layout 3 columns -->
      <#list 1..10 as i>
        <#if (i % 3) == 1>
          <tr class="${tableRowClass(i % 6)}">
        </#if>
        <#assign typeId = "enumTypeId" + i />
        <@displayTitleCell title=i />
        <@inputSelectHashCell name="tagEnum${i}MustBalance" default=(postingCheck.get("tagEnum${i}MustBalance"))!"N" hash=mustBalanceSelectValues />
        <#if (i % 3) == 0>
          </tr>
        </#if>
      </#list>
      <@inputSubmitRow title=uiLabelMap.CommonUpdate />
    </table>
  </form>
</div>
