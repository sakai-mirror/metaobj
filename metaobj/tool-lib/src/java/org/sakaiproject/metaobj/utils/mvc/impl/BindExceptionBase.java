/**********************************************************************************
 * $URL: https://source.sakaiproject.org/svn/trunk/sakai/admin-tools/su/src/java/org/sakaiproject/tool/su/SuTool.java $
 * $Id: SuTool.java 6970 2006-03-23 23:25:04Z zach.thomas@txstate.edu $
 ***********************************************************************************
 *
 * Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
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

package org.sakaiproject.metaobj.utils.mvc.impl;

import org.springframework.beans.BeanWrapper;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;

import java.util.Map;

public class BindExceptionBase extends BindException {

   private BeanWrapper wrapper = null;

   public BindExceptionBase(Object target, String name) {
      super(target, name);
   }

   protected BeanWrapper getBeanWrapper() {
      if (wrapper == null) {
         if (getTarget() instanceof Map) {
            wrapper = new MapWrapper(getTarget());
         }
         else {
            wrapper = new MixedBeanWrapper(getTarget());
         }
      }
      return wrapper;
   }

   public String[] resolveMessageCodes(String errorCode, String field) {
      String fixedField = fixedField(field);
      Class fieldType = this.getBeanWrapper().getPropertyType(fixedField);
      if (fieldType == null) {
         fieldType = String.class;
      }
      return this.getMessageCodesResolver().resolveMessageCodes(errorCode,
            this.getObjectName(), fixedField, fieldType);
   }

   public void rejectValue(String field, String errorCode, Object[] errorArgs, String defaultMessage) {
      String fixedField = fixedField(field);
      Object newVal = getBeanWrapper().getPropertyValue(fixedField);
      if (newVal == null) {
         newVal = "";
      }
      FieldError fe = new FieldError(this.getObjectName(), fixedField, newVal, false,
            resolveMessageCodes(errorCode, field), errorArgs, defaultMessage);
      addError(fe);
   }


}
