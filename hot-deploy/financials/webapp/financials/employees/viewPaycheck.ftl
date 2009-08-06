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

<#if paycheck?has_content>

	<#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasUpdatePermission)>
	  <#assign stateChangeLinks = "<a href='setPaycheckStatus?statusId=PMNT_SENT&paymentId="+paycheck.paymentId+"' class='buttontext'>" + uiLabelMap.FinancialsPaymentStatusToSent + "</a>" />
	  <#assign stateChangeLinks = stateChangeLinks?default("") +  "<a href='setPaycheckStatus?statusId=PMNT_CANCELLED&paymentId="+paycheck.paymentId+"' class='buttontext'>" + uiLabelMap.FinancialsPaymentStatusToCanceled + "</a>" />
	<#elseif (paycheck.statusId == "PMNT_SENT") && (hasUpdatePermission)>
	  <#assign stateChangeLinks = "<a href='setPaycheckStatus?statusId=PMNT_VOID&paymentId="+paycheck.paymentId+"' class='buttontext'>" + uiLabelMap.FinancialsPaymentVoidPayment + "</a>">
	</#if>

	<!-- Paycheck Header -->
	<div class="screenlet">
	  <div class="screenlet-header">
	    <div style="float: right;">
	      <#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasCreatePermission)>
	        <a href="<@ofbizUrl>createPaycheckForm?paymentTypeId=${paycheck.paymentTypeId}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonCreateNew}</a>
	      </#if>
	      <#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasUpdatePermission)>
	        <a href="<@ofbizUrl>editPaycheckForm?paymentId=${paycheck.paymentId}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonEdit}</a>
	      </#if>      
	      ${stateChangeLinks?if_exists}      
	      <#if paycheck.statusId != "PMNT_CANCELLED" && paycheck.statusId != "PMNT_VOID" && paycheck.statusId != "PMNT_SENT">
	        <a href="<@ofbizUrl>viewPaycheck.pdf?paymentId=${paycheck.paymentId}</@ofbizUrl>" class="buttontext">${uiLabelMap.AccountingPrintAsCheck}</a>
	      </#if>
	    </div>
	    <div class="boxhead">${uiLabelMap.FinancialsPaycheck} ${uiLabelMap.OrderNbr}${paycheck.paymentId}</div>    
	  </div>
	
	  <div class="screenlet-body">
	    <table border="0" cellpadding="2" cellspacing="0" width="100%">
			<@inputHidden name="paymentId" value="${paycheck.paymentId}"/>        
		    <@displayRow title=uiLabelMap.CommonStatus text=paycheck.getRelatedOneCache("StatusItem").get("description", "FinancialsEntityLabel", locale) />        	  
		    <@displayRow title=uiLabelMap.FinancialsPaycheckType text=paycheck.getRelatedOneCache("PaymentType").get("description", "FinancialsEntityLabel", locale)/>
		    <@displayRow title=uiLabelMap.FinancialsPayToParty text=paycheck.partyIdTo />
		    <@displayRow title=uiLabelMap.AccountingPaymentMethod text=paycheck.paymentMethodId />
		    <@displayDateRow title=uiLabelMap.AccountingEffectiveDate date=paycheck.effectiveDate />
		    <@displayRow title=uiLabelMap.CommonComments text=paycheck.comments?if_exists />
		    <@displayRow title=uiLabelMap.FinancialsPaymentRefNum text=paycheck.paymentRefNum?if_exists />        
	    </table>
	  </div>
	</div>

	<!-- list gross amount, net pay and witholdings -->
	<div class="screenlet">
	<table class="listTable">
	  <tbody>
	      <tr class="boxtop">
	      <td class="boxhead" width='5%'</td>
	      <td class="boxhead" width='50%'>${uiLabelMap.FinancialsPaycheckAndWitholdings}</td>
	      <td class="boxhead" width='20%'>${uiLabelMap.FinancialsPayToParty}</td>
	      <#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasUpdatePermission)>
	      <td class="boxhead" width='15%'>${uiLabelMap.CommonAmount}</td>
	      <td width=10%'>&nbsp;</td>
	      <#else>
	      <td class="boxhead" width=25%'>${uiLabelMap.CommonAmount}</td>
	      </#if>
	    </tr>	
	
	    <!-- list paycheck gross amount -->
        <tr class="viewManyTR2">
          <#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasUpdatePermission)>
            <form method="post" action="<@ofbizUrl>updatePaycheck</@ofbizUrl>" name="updatePaycheckGrossAmount">
              <@inputHidden name="paymentId" value="${paycheck.paymentId}"/>
              <@displayCell text="" />
              <@displayCell text=uiLabelMap.FinancialsGrossAmount style="font-weight: bold;"/>
              <@displayCell text="" />
			  <@inputCurrencyCell name="amount" currencyName="currencyUomId" default=paycheck.amount defaultCurrencyUomId=paycheck.currencyUomId/>
			  <#--              
              <@inputTextCell name="amount" default=paycheck.amount?default("EMPTY") size="6" />
              -->
              <@displayLinkCell href="javascript:document.updatePaycheckGrossAmount.submit()" class="buttontext" text="${uiLabelMap.CommonUpdate}"/>
	        </form>
          <#else>
            <@displayCell text="" blockClass="tabletextright" />
            <@displayCell text=uiLabelMap.FinancialsGrossAmount style="white-space: nowrap; font-weight: bold;" />
            <@displayCell text="" />
            <td><@displayCurrency amount=paycheck.amount?default(0.00) currencyUomId=paycheck.currencyUomId class="tableheadtext"/></td>
          </#if>
         </tr>	

        <!-- list witholdings -->	
		<#if witholdings.size() != 0>
		    <#assign displayItemSeqId = 1><#-- This used to display item seq id as 1, 2, 3, 4, 5 rather than 00001, 00002, 00003 -->
		    <#list witholdings as item>
		      <#if (item_index % 2) == 0><#assign rowStyle = "viewManyTR1"/><#else><#assign rowStyle = "viewManyTR2"/></#if>
		      <tr class="${rowStyle}">
		        <#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasUpdatePermission)>
		          <form method="post" action="<@ofbizUrl>updatePaycheckItem</@ofbizUrl>" name="updatePaycheckWitholding_o_${item_index}">
		            <@inputHidden name="organizationPartyId" value="${paycheck.partyIdFrom}"/>			          
		            <@inputHidden name="paymentId" value="${item.paymentId}"/>
		            <@inputHidden name="paycheckItemSeqId" value="${item.paycheckItemSeqId}"/>
		            <@displayCell text=displayItemSeqId />
		            <@displayCell text=item.typeDescription />
		            <@inputLookupCell name="partyId" default=item.partyId lookup="LookupPartyName" form="updatePaycheckWitholding_o_${item_index}" size="10" />
		            <@inputTextCell name="amount" default=item.amount?default("EMPTY") size="6"/>
		            <@displayLinkCell href="javascript:document.updatePaycheckWitholding_o_${item_index}.submit()" class="buttontext" text="${uiLabelMap.CommonUpdate}"/>
		          </form>
		        <#else>
		          <@displayCell text=displayItemSeqId blockClass="tabletextright" />
		          <@displayCell text=item.typeDescription style="white-space: nowrap" />
		          <@displayCell text=item.witholdingPartyName />
		          <td><@displayCurrency amount=item.amount?default(0.00) currencyUomId=paycheck.currencyUomId /></td>
		        </#if>
		      </tr>
		      <#assign displayItemSeqId = displayItemSeqId + 1 />
		    </#list>
	    </#if>
	    
		<!-- paycheck net amount -->
		<#if rowStyle="viewManyTR1"><#assign rowStyle = "viewManyTR2"/><#else><#assign rowStyle = "viewManyTR1"/></#if>
        <tr class="${rowStyle}" style="border-top: 1px solid black;">
          <@displayCell text="" blockClass="tabletextright" />
          <@displayCell text=uiLabelMap.FinancialsNetPay style="white-space: nowrap; font-weight: bold;" />
          <@displayCell text="" />
          <td><@displayCurrency amount=netAmount?default(0.00) currencyUomId=paycheck.currencyUomId class="tableheadtext"/></td>
          <@displayCell text="" />
        </tr>		
	  </tbody>
	</table>
	</div>	
	
	<!-- list the paycheck expenses -->
	<#if expenses.size() != 0>
		<div class="screenlet">
		<table class="listTable">
		  <tbody>
		  
		      <tr class="boxtop">
		      <td class="boxhead" width='5%'</td>
		      <td class="boxhead" width='50%'>${uiLabelMap.FinancialsPaycheckExpenses}</td>
		      <td class="boxhead" width='20%'>${uiLabelMap.FinancialsPayToParty}</td>
		      <#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasUpdatePermission)>
		      <td class="boxhead" width='15%'>${uiLabelMap.CommonAmount}</td>
		      <td width=10%'>&nbsp;</td>
		      <#else>
		      <td class="boxhead" width=25%'>${uiLabelMap.CommonAmount}</td>
		      </#if>
		    </tr>
		
		    <#assign displayItemSeqId = 1><#-- This used to display item seq id as 1, 2, 3, 4, 5 rather than 00001, 00002, 00003 -->
		
		    <#list expenses as item>
		      <#if (item_index % 2) == 0><#assign rowStyle = "viewManyTR2"/><#else><#assign rowStyle = "viewManyTR1"/></#if>
		      <tr class="${rowStyle}">
		        <#if (paycheck.statusId == "PMNT_NOT_PAID") && (hasUpdatePermission)>
		          <form method="post" action="<@ofbizUrl>updatePaycheckItem</@ofbizUrl>" name="updatePaycheckExpense_o_${item_index}">
		            <@inputHidden name="organizationPartyId" value="${paycheck.partyIdFrom}"/>			          
		            <@inputHidden name="paymentId" value="${item.paymentId}"/>
		            <@inputHidden name="paycheckItemSeqId" value="${item.paycheckItemSeqId}"/>
		            <@displayCell text=displayItemSeqId />
		            <@displayCell text=item.typeDescription style="white-space: nowrap;" />
		            <@inputLookupCell name="partyId" default=item.partyId lookup="LookupPartyName" form="updatePaycheckExpense_o_${item_index}" size="10" />
		            <@inputTextCell name="amount" default=item.amount?default("EMPTY") size="6"/>
		            <@displayLinkCell href="javascript:document.updatePaycheckExpense_o_${item_index}.submit()" class="buttontext" text="${uiLabelMap.CommonUpdate}"/>
		          </form>
		        <#else>
		          <@displayCell text=displayItemSeqId blockClass="tabletextright" />
		          <@displayCell text=item.typeDescription style="white-space: nowrap;" />
		          <@displayCell text=item.expensePartyName />
		          <td><@displayCurrency amount=item.amount?default(0.00) currencyUomId=paycheck.currencyUomId /></td>
		        </#if>
		      </tr>
		      <#assign displayItemSeqId = displayItemSeqId + 1 />
		    </#list>
		
		  </tbody>
		</table>
		</div>
	</#if>
	
</#if>






