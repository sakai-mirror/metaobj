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

package org.sakaiproject.metaobj.registry;

import org.sakaiproject.content.util.BaseInteractionAction;
import org.sakaiproject.content.api.ContentEntity;
import org.sakaiproject.content.api.ResourceToolAction;
import org.sakaiproject.metaobj.shared.mgt.StructuredArtifactDefinitionManager;

import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Feb 5, 2007
 * Time: 10:27:01 AM
 * To change this template use File | Settings | File Templates.
 */
public class CreateFormInteractionAction extends BaseInteractionAction {

   private StructuredArtifactDefinitionManager structuredArtifactDefinitionManager;

   public CreateFormInteractionAction(StructuredArtifactDefinitionManager structuredArtifactDefinitionManager,
                                      String id, ActionType actionType, String typeId,
                                      String helperId, List requiredPropertyKeys) {
      super(id, actionType, typeId, helperId, requiredPropertyKeys);
      this.structuredArtifactDefinitionManager = structuredArtifactDefinitionManager;
   }

   /* (non-Javadoc)
     * @see org.sakaiproject.content.api.ResourceToolAction#available(java.lang.String)
     */
   public boolean available(ContentEntity entity) {
      return getStructuredArtifactDefinitionManager().hasHomes();
   }

   public StructuredArtifactDefinitionManager getStructuredArtifactDefinitionManager() {
      return structuredArtifactDefinitionManager;
   }

   public void setStructuredArtifactDefinitionManager(StructuredArtifactDefinitionManager structuredArtifactDefinitionManager) {
      this.structuredArtifactDefinitionManager = structuredArtifactDefinitionManager;
   }
}
