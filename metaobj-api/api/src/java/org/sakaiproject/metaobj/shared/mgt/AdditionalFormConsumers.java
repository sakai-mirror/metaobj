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

import java.util.List;
import java.util.Iterator;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Mar 12, 2007
 * Time: 10:24:09 AM
 * To change this template use File | Settings | File Templates.
 */
public class AdditionalFormConsumers {
   private List additionalConsumers;
   private StructuredArtifactDefinitionManager manager;

   public List getAdditionalConsumers() {
      return additionalConsumers;
   }

   public void setAdditionalConsumers(List additionalConsumers) {
      this.additionalConsumers = additionalConsumers;
   }

   public StructuredArtifactDefinitionManager getManager() {
      return manager;
   }

   public void setManager(StructuredArtifactDefinitionManager manager) {
      this.manager = manager;
   }

   public void init() {
      for (Iterator<FormConsumer> i = getAdditionalConsumers().iterator();i.hasNext();) {
         getManager().addConsumer(i.next());
      }
   }
}
