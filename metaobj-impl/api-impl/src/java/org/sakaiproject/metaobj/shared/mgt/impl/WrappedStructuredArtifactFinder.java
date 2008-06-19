/*******************************************************************************
 * $URL$
 * $Id$
 * **********************************************************************************
 *
 *  Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
 *
 *  Licensed under the Educational Community License, Version 1.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.opensource.org/licenses/ecl1.php
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 ******************************************************************************/

package org.sakaiproject.metaobj.shared.mgt.impl;

import org.sakaiproject.content.api.ContentHostingService;
import org.sakaiproject.content.api.ContentResource;
import org.sakaiproject.metaobj.shared.mgt.AgentManager;
import org.sakaiproject.metaobj.shared.mgt.IdManager;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.ContentResourceArtifact;
import org.sakaiproject.metaobj.shared.model.MimeType;
import org.sakaiproject.entity.api.ResourceProperties;
import org.sakaiproject.thread_local.cover.ThreadLocalManager;

import java.util.Collection;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Dec 11, 2006
 * Time: 8:48:47 AM
 * To change this template use File | Settings | File Templates.
 */
public class WrappedStructuredArtifactFinder  extends FileArtifactFinder {

   private ContentHostingService contentHostingService;
   private AgentManager agentManager;
   private IdManager idManager;
   private int finderPageSize = 1000;
   private final static String CACHE_KEY = "WRAPPED_STRUCTURED_ARTIFACT_FINDER_CACHE";

   public Collection findByOwnerAndType(Id owner, String type) {
      // store first call in threadlocal and do the filtering ourselves, see SAK-13791
      List artifactCache = (List) ThreadLocalManager.get(CACHE_KEY);
      if (artifactCache == null) {
         artifactCache = getContentHostingService().findResources(null,
               null, null);
         ThreadLocalManager.set(CACHE_KEY, artifactCache);
      }
      List artifacts = filterArtifacts(new ArrayList(artifactCache), type);
      Collection returned = new ArrayList();

      for (Iterator i = artifacts.iterator(); i.hasNext();) {
         ContentResource resource = (ContentResource) i.next();
         Agent resourceOwner = getAgentManager().getAgent(resource.getProperties().getProperty(ResourceProperties.PROP_CREATOR));
         Id resourceId = getIdManager().getId(getContentHostingService().getUuid(resource.getId()));
         returned.add(new ContentResourceArtifact(resource, resourceId, resourceOwner));
      }

      return returned;
   }

   protected List filterArtifacts(List artifacts, String type) {
      for (Iterator i = artifacts.iterator(); i.hasNext();) {
         ContentResource resource = (ContentResource) i.next();
         String currentType = resource.getProperties().getProperty(ResourceProperties.PROP_STRUCTOBJ_TYPE);
         String mimeType = resource.getProperties().getProperty(ResourceProperties.PROP_CONTENT_TYPE);

         if (type != null && !type.equals(ResourceProperties.FILE_TYPE)) {
            // process StructuredObject type
            if (currentType == null) {
               i.remove();
            } else if (!currentType.equals(type)) {
               i.remove();
            }
         } else if (currentType != null && type.equals(ResourceProperties.FILE_TYPE)) {
            // this one is a structured object, get rid of it
            i.remove();
         }
      }

      return artifacts;
   }
      
   public Collection findByOwnerAndType(Id owner, String type, MimeType mimeType) {
      return null;
   }

   public Collection findByOwner(Id owner) {
      return null;
   }

   public Collection findByWorksiteAndType(Id worksiteId, String type) {
      return null;
   }

   public Collection findByWorksite(Id worksiteId) {
      return null;
   }

   public Collection findByType(String type) {
      return null;
   }

   public boolean getLoadArtifacts() {
      return false;
   }

   public void setLoadArtifacts(boolean loadArtifacts) {

   }

   public ContentHostingService getContentHostingService() {
      return contentHostingService;
   }

   public void setContentHostingService(ContentHostingService contentHostingService) {
      this.contentHostingService = contentHostingService;
   }

   public AgentManager getAgentManager() {
      return agentManager;
   }

   public void setAgentManager(AgentManager agentManager) {
      this.agentManager = agentManager;
   }

   public IdManager getIdManager() {
      return idManager;
   }

   public void setIdManager(IdManager idManager) {
      this.idManager = idManager;
   }

   /**
    * @return the finderPageSize
    */
   public int getFinderPageSize() {
      return finderPageSize;
   }

   /**
    * @param finderPageSize the finderPageSize to set
    */
   public void setFinderPageSize(int finderPageSize) {
      this.finderPageSize = finderPageSize;
   }
}
