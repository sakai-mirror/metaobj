/**********************************************************************************
 * $URL:$
 * $Id:$
 ***********************************************************************************
 *
 * Copyright (c) 2008 The Sakai Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **********************************************************************************/

package org.sakaiproject.metaobj.security;

import org.sakaiproject.authz.api.SecurityAdvisor;

import java.util.Map;
import java.util.List;
import java.util.Iterator;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Jul 20, 2007
 * Time: 11:14:13 AM
 * To change this template use File | Settings | File Templates.
 */
public class AllowChildrenMapSecurityAdvisor extends AllowMapSecurityAdvisor {

   public AllowChildrenMapSecurityAdvisor(Map allowedReferences) {
      super(allowedReferences);
   }

   public AllowChildrenMapSecurityAdvisor(String function, List references) {
      super(function, references);
   }

   public AllowChildrenMapSecurityAdvisor(String function, String reference) {
      super(function, reference);
   }

   public SecurityAdvice isAllowed(String userId, String function, String reference) {
      List refs = (List)getAllowedReferences().get(function);
      if (refs != null) {

         for (Iterator<String> i=refs.iterator();i.hasNext();) {
            if (reference.startsWith(i.next())) {
               return SecurityAdvice.ALLOWED;
            }
         }
      }

      return SecurityAdvice.PASS;
   }
}
