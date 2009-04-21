/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2007, 2008 The Sakai Foundation
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

package org.sakaiproject.metaobj.utils.mvc.impl;

import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.beans.BeanWrapper;

import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Jun 10, 2007
 * Time: 6:40:55 PM
 * To change this template use File | Settings | File Templates.
 */
public class CustomBeanPropertyBindingResult extends BeanPropertyBindingResult {

   public CustomBeanPropertyBindingResult(Object target, String objectName) {
      super(target, objectName);
   }

   /**
    * Create a new {@link org.springframework.beans.BeanWrapper} for the underlying target object.
    *
    * @see #getTarget()
    */
   protected BeanWrapper createBeanWrapper() {
      if (getTarget() instanceof Map) {
         return new MapWrapper(getTarget());
      }
      else {
         return new MixedBeanWrapper(getTarget());
      }
   }

}
