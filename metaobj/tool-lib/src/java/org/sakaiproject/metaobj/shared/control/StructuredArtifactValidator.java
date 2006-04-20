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

package org.sakaiproject.metaobj.shared.control;

import org.sakaiproject.metaobj.shared.model.ElementBean;
import org.springframework.validation.Errors;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: May 19, 2004
 * Time: 3:31:16 PM
 * To change this template use File | Settings | File Templates.
 */
public class StructuredArtifactValidator extends XmlValidator {


   public boolean supports(Class clazz) {
      if (super.supports(clazz)) {
         return true;
      }
      //return (StructuredArtifact.class.isAssignableFrom(clazz));
      return true;
   }

   public void validate(Object obj, Errors errors) {
      validateInternal(obj, errors);
      super.validate(obj, errors);
   }

   protected void validateInternal(Object obj, Errors errors) {
//      if (obj instanceof StructuredArtifact) {
//         StructuredArtifact artifact = (StructuredArtifact) obj;
//
//         if (artifact.getDisplayName() == null ||
//            artifact.getDisplayName().length() == 0) {
//            errors.rejectValue("displayName", "required value {0}", new Object[]{"displayName"},
//               "required value displayName");
//         }
//      }
   }

   public void validate(Object obj, Errors errors, boolean checkListNumbers) {
      validateInternal(obj, errors);
      super.validate(obj, errors, checkListNumbers);
   }

   protected void validateDisplayName(ElementBean elementBean, Errors errors) {
//      if (elementBean instanceof StructuredArtifact) {
//
//         String displayName = (String)elementBean.get("displayName");
//
//         if (getFileNameValidator() != null && displayName != null) {
//            if (!getFileNameValidator().validFileName(displayName)) {
//               errors.rejectValue("displayName", "Invalid display name {0}",
//                  new Object[]{displayName},
//                  MessageFormat.format("Invalid display name {0}", new Object[]{displayName}));
//            }
//         }
//      }
   }
}
