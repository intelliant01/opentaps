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

<@import location="component://opentaps-common/webapp/common/includes/lib/opentapsFormMacros.ftl"/>

<form method="post"  action=""  class="basic-form" onSubmit="javascript:submitFormDisableSubmits(this)" name="ViewGatewayResponseRelations">
    <table cellspacing="0">
        <tr>
            <@displayCell text="${uiLabelMap.OrderOrderId}" blockClass="label" style="font-size: 100%;"/>
            <@displayLinkCell href="orderview?orderId=${orderId}" text=orderId/>
        </tr>
        <tr>
            <@displayCell text="${uiLabelMap.CrmOrderPaymentPreferenceId}" blockClass="label" style="font-size: 100%;"/>
            <@displayCell text=orderPaymentPreferenceId/>
        </tr>
    </table>
</form>
