/**********************************************************************************
* $URL$
* $Id$
***********************************************************************************
*
* Copyright (c) 2007 The Sakai Foundation.
*
* Licensed under the Educational Community License, Version 1.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.opensource.org/licenses/ecl1.php
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
**********************************************************************************/

/**
 * 
 */
package org.sakaiproject.metaobj.shared.model;

import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.site.cover.SiteService;

/**
 * @author chrismaurer
 *
 */
public class FormConsumptionDetail {

   private String formDefId;
   private String detail1;
   private String detail2;
   private String detail3;
   private String detail4;
   private String siteId;
   private String siteName;
   
   public FormConsumptionDetail() {
      
   }
   public FormConsumptionDetail(Id formDefId, Id siteId) {
      this(formDefId.getValue(), siteId.getValue());
   }
   public FormConsumptionDetail(Id formDefId, String siteId) {
      this(formDefId.getValue(), siteId);
   }
   public FormConsumptionDetail(String formDefId, String siteId) {
      this(formDefId, siteId, null, null, null, null);
   }
   public FormConsumptionDetail(Id formDefId, Id siteId, String detail1) {
      this(formDefId.getValue(), siteId.getValue(), detail1);
   }
   public FormConsumptionDetail(Id formDefId, String siteId, String detail1) {
      this(formDefId.getValue(), siteId, detail1);
   }
   public FormConsumptionDetail(String formDefId, String siteId, String detail1) {
      this(formDefId, siteId, detail1, null, null, null);
   }
   public FormConsumptionDetail(Id formDefId, Id siteId, String detail1, String detail2) {
      this(formDefId.getValue(), siteId.getValue(), detail1, detail2);
   }
   public FormConsumptionDetail(Id formDefId, String siteId, String detail1, String detail2) {
      this(formDefId.getValue(), siteId, detail1, detail2);
   }
   public FormConsumptionDetail(String formDefId, String siteId, String detail1, String detail2) {
      this(formDefId, siteId, detail1, detail2, null, null);
   }
   public FormConsumptionDetail(Id formDefId, Id siteId, String detail1, String detail2, String detail3) {
      this(formDefId.getValue(), siteId.getValue(), detail1, detail2, detail3);
   }
   public FormConsumptionDetail(Id formDefId, String siteId, String detail1, String detail2, String detail3) {
      this(formDefId.getValue(), siteId, detail1, detail2, detail3);
   }
   public FormConsumptionDetail(String formDefId, String siteId, String detail1, String detail2, String detail3) {
      this(formDefId, siteId, detail1, detail2, detail3, null);
   }
   public FormConsumptionDetail(Id formDefId, Id siteId, String detail1, String detail2, String detail3, String detail4) {
      this(formDefId.getValue(), siteId.getValue(), detail1, detail2, detail3, detail4);
   }
   public FormConsumptionDetail(Id formDefId, String siteId, String detail1, String detail2, String detail3, String detail4) {
      this(formDefId.getValue(), siteId, detail1, detail2, detail3, detail4);
   }
   public FormConsumptionDetail(String formDefId, Id siteId, String detail1, String detail2, String detail3, String detail4) {
      this(formDefId, siteId.getValue(), detail1, detail2, detail3, detail4);
   }
   
   public FormConsumptionDetail(String formDefId, String siteId, String detail1, String detail2, String detail3, String detail4) {
      this.formDefId = formDefId;
      this.detail1 = detail1;
      this.detail2 = detail2;
      this.detail3 = detail3;
      this.detail4 = detail4;
      this.siteId = siteId;
      try {
         this.siteName = SiteService.getSite(siteId).getTitle();
      } catch (IdUnusedException e) {
         this.siteName = siteId;
      }
      
   }

   /**
    * @return the formDefId
    */
   public String getFormDefId() {
      return formDefId;
   }

   /**
    * @param formDefId the formDefId to set
    */
   public void setFormDefId(String formDefId) {
      this.formDefId = formDefId;
   }

   /**
    * @return the siteId
    */
   public String getSiteId() {
      return siteId;
   }

   /**
    * @param siteId the siteId to set
    */
   public void setSiteId(String siteId) {
      this.siteId = siteId;
   }

   /**
    * @return the siteName
    */
   public String getSiteName() {
      return siteName;
   }

   /**
    * @param siteName the siteName to set
    */
   public void setSiteName(String siteName) {
      this.siteName = siteName;
   }

   /**
    * @return the detail1
    */
   public String getDetail1() {
      return detail1;
   }

   /**
    * @param detail1 the detail1 to set
    */
   public void setDetail1(String detail1) {
      this.detail1 = detail1;
   }

   /**
    * @return the detail2
    */
   public String getDetail2() {
      return detail2;
   }

   /**
    * @param detail2 the detail2 to set
    */
   public void setDetail2(String detail2) {
      this.detail2 = detail2;
   }

   /**
    * @return the detail3
    */
   public String getDetail3() {
      return detail3;
   }

   /**
    * @param detail3 the detail3 to set
    */
   public void setDetail3(String detail3) {
      this.detail3 = detail3;
   }

   /**
    * @return the detail4
    */
   public String getDetail4() {
      return detail4;
   }

   /**
    * @param detail4 the detail4 to set
    */
   public void setDetail4(String detail4) {
      this.detail4 = detail4;
   }
   
   
}
