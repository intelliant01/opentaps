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
<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<#-- This file has been modified by Open Source Strategies, Inc. -->


<#macro paginationControls>
  <#assign viewIndexMax = Static["java.lang.Math"].ceil((listSize - 1)?double / viewSize?double)/>
  <#if (viewIndexMax?int gt 0)>
    <div class="product-prevnext">
      <#-- Start Page Select Drop-Down -->
      <select name="pageSelect" class="inputBox" onchange="window.location=this[this.selectedIndex].value;">
        <option value="#">${uiLabelMap.CommonPage} ${viewIndex?int} ${uiLabelMap.CommonOf} ${viewIndexMax + 1}</option>
        <#list 0..viewIndexMax as curViewNum>
          <option value="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int + 1}</@ofbizUrl>">${uiLabelMap.CommonGotoPage} ${curViewNum + 1}</option>
        </#list>
      </select>
      <#-- End Page Select Drop-Down -->
      <#if (viewIndex?int gt 1)>
        <a href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int - 1}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonPrevious}</a> |
      </#if>
      <#if ((listSize?int - viewSize?int) gt 0)>
        <span>${lowIndex} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</span>
      </#if>
      <#if highIndex?int lt listSize?int>
        | <a href="<@ofbizUrl>category/~category_id=${productCategoryId}/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int + 1}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonNext}</a>
      </#if>
    </div>
  </#if>
  <div class="cleaner">&nbsp;</div>
</#macro>

<#if productCategory?exists>
  <div class="screenlet-body">
    <div class="product-header">
      <#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME")?if_exists/>
      <#assign categoryDescription = categoryContentWrapper.get("DESCRIPTION")?if_exists/>
      <#if categoryName?has_content>
        <div class="head1">${categoryName}</div>
      </#if>
      <#if categoryDescription?has_content>
        <div class="head2">${categoryDescription}</div>
      </#if>
      <#if hasQuantities?exists>
        <form method="post" action="<@ofbizUrl>addCategoryDefaults<#if requestAttributes._CURRENT_VIEW_?exists>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="thecategoryform" style="margin: 0;">
          <input type="hidden" name="add_category_id" value="${productCategory.productCategoryId}"/>
          <#if requestParameters.product_id?exists><input type="hidden" name="product_id" value="${requestParameters.product_id}"/></#if>
          <#if requestParameters.category_id?exists><input type="hidden" name="category_id" value="${requestParameters.category_id}"/></#if>
          <#if requestParameters.VIEW_INDEX?exists><input type="hidden" name="VIEW_INDEX" value="${requestParameters.VIEW_INDEX}"/></#if>
          <#if requestParameters.SEARCH_STRING?exists><input type="hidden" name="SEARCH_STRING" value="${requestParameters.SEARCH_STRING}"/></#if>
          <#if requestParameters.SEARCH_CATEGORY_ID?exists><input type="hidden" name="SEARCH_CATEGORY_ID" value="${requestParameters.SEARCH_CATEGORY_ID}"/></#if>
          <a href="javascript:document.thecategoryform.submit()" class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.ProductAddProductsUsingDefaultQuantities}</span></a>
        </form>
      </#if>
      <#assign longDescription = categoryContentWrapper.get("LONG_DESCRIPTION")?if_exists/>
      <#assign categoryImageUrl = categoryContentWrapper.get("CATEGORY_IMAGE_URL")?if_exists/>
      <#if categoryImageUrl?string?has_content || longDescription?has_content>
        <div>
          <#if categoryImageUrl?string?has_content>
            <#assign height=100/>
            <img src="<@ofbizContentUrl>${categoryImageUrl}</@ofbizContentUrl>" vspace="5" hspace="5" border="1" height="${height}" align="left"/>
          </#if>
          <#if longDescription?has_content>
            ${longDescription}
          </#if>
        </div>
      </#if>
      <#if searchInCategory?default("Y") == "Y">
        <a href="<@ofbizUrl>advancedsearch?SEARCH_CATEGORY_ID=${productCategory.productCategoryId}</@ofbizUrl>" class="buttontext">${uiLabelMap.ProductSearchInCategory}</a>
      </#if>
    </div>
</#if>

<#if productCategoryLinkScreen?has_content && productCategoryLinks?has_content>
    <div class="productcategorylink-container">
        <#list productCategoryLinks as productCategoryLink>
            ${setRequestAttribute("productCategoryLink",productCategoryLink)}
            ${screens.render(productCategoryLinkScreen)}
        </#list>
    </div>
</#if>

<#if productCategoryMembers?has_content>
    <@paginationControls/>
  </div> <#-- screenlet-body -->
      <#assign numCol = numCol?default(1)>
      <#assign numCol = numCol?number>
      <#assign tabCol = 1>
      <div
      <#if categoryImageUrl?string?has_content>
        style="position: relative; margin-top: ${height}px;"
      </#if>
      class="productsummary-container<#if (numCol?int > 1)> matrix</#if>">
      <#if (numCol?int gt 1)>
        <table>
      </#if>
        <#list productCategoryMembers as productCategoryMember>
          <#if (numCol?int == 1)>
            ${setRequestAttribute("optProductId", productCategoryMember.productId)}
            ${setRequestAttribute("productCategoryMember", productCategoryMember)}
            ${setRequestAttribute("listIndex", productCategoryMember_index)}
            ${screens.render(productsummaryScreen)}
          <#else>
              <#if (tabCol?int = 1)><tr></#if>
                  <td>
                      ${setRequestAttribute("optProductId", productCategoryMember.productId)}
                      ${setRequestAttribute("productCategoryMember", productCategoryMember)}
                      ${setRequestAttribute("listIndex", productCategoryMember_index)}
                      ${screens.render(productsummaryScreen)}
                  </td>
              <#if (tabCol?int = numCol)></tr></#if>
              <#assign tabCol = tabCol+1><#if (tabCol?int gt numCol)><#assign tabCol = 1></#if>
           </#if>
        </#list>
      <#if (numCol?int gt 1)>
        </table>
      </#if>
      </div>
    <@paginationControls/>
<#else>
  </div> <#-- screenlet-body -->
    <hr/>
    <div>${uiLabelMap.ProductNoProductsInThisCategory}</div>
</#if>
