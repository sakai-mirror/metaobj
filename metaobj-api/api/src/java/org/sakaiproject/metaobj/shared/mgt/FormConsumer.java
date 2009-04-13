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

package org.sakaiproject.metaobj.shared.mgt;

import java.util.Collection;

import org.sakaiproject.metaobj.shared.model.FormConsumptionDetail;
import org.sakaiproject.metaobj.shared.model.Id;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Mar 12, 2007
 * Time: 10:20:36 AM
 * To change this template use File | Settings | File Templates.
 */
public interface FormConsumer {

   public boolean checkFormConsumption(Id formId);
   
   /**
    * Return a Collection of FormConsumptionDetail objects for all of the found usages of the passed form type
    * @param formId
    * @return
    */
   public Collection<FormConsumptionDetail> getFormConsumptionDetails(Id formId);

}
