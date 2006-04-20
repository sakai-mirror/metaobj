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

import org.sakaiproject.metaobj.shared.SharedFunctionConstants;
import org.sakaiproject.metaobj.shared.model.PersistenceException;
import org.sakaiproject.metaobj.shared.model.StructuredArtifactDefinitionBean;
import org.sakaiproject.metaobj.utils.mvc.intf.LoadObjectController;
import org.springframework.validation.Errors;

import java.util.Map;

public class EditStructuredArtifactDefinitionController extends AddStructuredArtifactDefinitionController implements LoadObjectController {
   //private ArtifactFinderManager artifactFinderManager;

//TODO removed reference to ArtifactFinderManager
   public Object fillBackingObject(Object incomingModel, Map request, Map session, Map application) throws Exception {
      if (session.get(SAD_SESSION_TAG) != null) {
         return session.remove(SAD_SESSION_TAG);
      }

      StructuredArtifactDefinitionBean home = (StructuredArtifactDefinitionBean) incomingModel;
      home = getStructuredArtifactDefinitionManager().loadHome(home.getId());
      return home;
   }

   protected void save(StructuredArtifactDefinitionBean sad, Errors errors) {
      //check to see if you have edit permissions
      checkPermission(SharedFunctionConstants.EDIT_ARTIFACT_DEF);

      //TODO verify user is system admin, if editting global SAD

      /*
      todo this should all be done on the server
      // check only if new xsd has been submitted
      if (sad.getSchemaFile() != null){

         String type = sad.getType().getId().getValue();
         ArtifactFinder artifactFinder = getArtifactFinderManager().getArtifactFinderByType(type);
         Collection artifacts = artifactFinder.findByType(type);
         StructuredArtifactValidator validator = new StructuredArtifactValidator();

         // validate every artifact against new xsd to determine
         // whether or not an xsl conversion file is necessary
         for (Iterator i = artifacts.iterator(); i.hasNext();) {
            Object obj = i.next();
            if (obj instanceof StructuredArtifact) {
               StructuredArtifact artifact = (StructuredArtifact)obj;
               artifact.setHome(sad);
               Errors artifactErrors = new BindExceptionBase(artifact, "bean");
               validator.validate(artifact, artifactErrors);
               if (artifactErrors.getErrorCount() > 0){
                  if (sad.getXslConversionFileId() == null ||
                        sad.getXslConversionFileId().getValue().length() == 0) {

                     errors.rejectValue("xslConversionFileId",
                           "xsl file required to convert existing artifacts",
                           "xsl file required to convert existing artifacts");

                     for (Iterator x=artifactErrors.getAllErrors().iterator();x.hasNext();){
                        ObjectError error = (ObjectError) x.next();
                        logger.error(error.toString());
                        errors.rejectValue("xslConversionFileId",error.toString(),error.toString());
                     }

                     return;

                  } else {
                     sad.setRequiresXslFile(true);
                     break;
                  }
               }
            }
         }
      }
      */

      try {
         getStructuredArtifactDefinitionManager().save(sad);
      }
      catch (PersistenceException e) {
         errors.rejectValue(e.getField(), e.getErrorCode(), e.getErrorInfo(),
               e.getDefaultMessage());
      }
   }

   //public ArtifactFinderManager getArtifactFinderManager() {
   //   return artifactFinderManager;
   //}

   //public void setArtifactFinderManager(ArtifactFinderManager artifactFinderManager) {
   //   this.artifactFinderManager = artifactFinderManager;
   //}
}
