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

package org.sakaiproject.metaobj.security.impl;

import org.sakaiproject.authz.api.SecurityAdvisor;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Jul 9, 2007
 * Time: 8:21:18 AM
 * To change this template use File | Settings | File Templates.
 */
public class AllowAllSecurityAdvisor implements SecurityAdvisor {

   /**
    * Can the current session user perform the requested function on the referenced Entity?
    *
    * @param userId    The user id.
    * @param function  The lock id string.
    * @param reference The resource reference string.
    * @return ALLOWED or NOT_ALLOWED if the advisor can answer that the user can or cannot, or PASS if the advisor cannot answer.
    */
   public SecurityAdvice isAllowed(String userId, String function, String reference) {
      return SecurityAdvice.ALLOWED;
   }
}
