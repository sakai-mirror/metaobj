/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2004, 2005, 2006, 2008 The Sakai Foundation
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

package org.sakaiproject.metaobj.shared.mgt.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.sakaiproject.site.api.Site;
import org.sakaiproject.content.api.ContentHostingService;
import org.sakaiproject.content.api.ContentResource;
import org.sakaiproject.entity.api.ResourceProperties;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.exception.PermissionException;
import org.sakaiproject.exception.TypeException;
import org.sakaiproject.metaobj.shared.ArtifactFinder;
import org.sakaiproject.metaobj.shared.mgt.AgentManager;
import org.sakaiproject.metaobj.shared.mgt.IdManager;
import org.sakaiproject.metaobj.shared.mgt.ReadableObjectHome;
import org.sakaiproject.metaobj.shared.model.Agent;
import org.sakaiproject.metaobj.shared.model.Artifact;
import org.sakaiproject.metaobj.shared.model.ContentResourceArtifact;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.metaobj.shared.model.MimeType;
import org.sakaiproject.site.cover.SiteService;
import org.sakaiproject.metaobj.worksite.mgt.WorksiteManager;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Aug 17, 2005
 * Time: 2:08:27 PM
 * To change this template use File | Settings | File Templates.
 */
public class FileArtifactFinder implements ArtifactFinder {

   private ContentHostingService contentHostingService;
   private AgentManager agentManager;
   private IdManager idManager;
   private ReadableObjectHome contentResourceHome = null;
   private WorksiteManager worksiteManager;
   
   private static Log log = LogFactory.getLog(FileArtifactFinder.class);

   public Collection findByOwnerAndType(Id owner, String type) {
      return findByOwnerAndType(owner, type, null);
   }

   public Collection findBySharedOwnerAndType(List ownerList, String type) {
      return findBySharedOwnerAndType(ownerList, type, null);
   }

   /** Return collection of files owned by specified user and of the specified mime type.
    **/
   public Collection findByOwnerAndType(Id owner, String type, MimeType mimeType) {
      String primaryMimeType = null;
      String subMimeType = null;

      if (mimeType != null) {
         primaryMimeType = mimeType.getPrimaryType();
         subMimeType = mimeType.getSubType();
      }

      List artifacts = getContentHostingService().findResources(ResourceProperties.FILE_TYPE,
            primaryMimeType, subMimeType);

      Collection returned = new ArrayList();

      for (Iterator i = artifacts.iterator(); i.hasNext();) {
         ContentResource resource = (ContentResource) i.next();
         //FIXME: Refactor to avoid double trips to AgentManager on every artifact -- Agent user type gives performance hits
         Agent resourceOwner = getAgentManager().getAgent(resource.getProperties().getProperty(ResourceProperties.PROP_CREATOR));
         if (owner == null || owner.equals(resourceOwner.getId())) {
             Artifact resourceArtifact = createArtifact(resource);
             returned.add(resourceArtifact);
         }
      }

      return returned;
   }
   

	/** Return collection of file owned by specified users and of the specified mime type.
	 ** Only My Workspace(s) and current site are searched.
	 **/
	public Collection findBySharedOwnerAndType(List ownerList, String type, MimeType mimeType) {
	
		Set<String> siteIds = new TreeSet();
														 
		// use current worksite
		Id worksiteId = worksiteManager.getCurrentWorksiteId();
		siteIds.add( worksiteId.getValue() );
		
		// find all user MyWorkspace sites
		for (Iterator it = ownerList.iterator(); it.hasNext();) 
		{
			try
			{
				String ownerid = ((Agent)it.next()).getId().getValue();
				Site site = SiteService.getSite(SiteService.getUserSiteId(ownerid) );
				siteIds.add( site.getId() );
			}
			catch (Exception e)
			{
				log.info("findBySharedOwnerAndType: "+e.toString());
			}
		}		 
	
		String primaryMimeType = null;
		String subMimeType = null;

		if (mimeType != null) {
			primaryMimeType = mimeType.getPrimaryType();
			subMimeType = mimeType.getSubType();
		}

		List artifacts = getContentHostingService().findResources(ResourceProperties.FILE_TYPE,
																					 primaryMimeType, subMimeType, siteIds);

      Collection returned = new ArrayList();

		for (Iterator i = artifacts.iterator(); i.hasNext();) {
			ContentResource resource = (ContentResource) i.next();
			Artifact resourceArtifact = createArtifact(resource);
			returned.add(resourceArtifact);
		}

      return returned;
	}
	
   protected Artifact createArtifact(ContentResource resource, Id artifactId) {
	   Agent resourceOwner = getAgentManager().getAgent(resource.getProperties().getProperty(ResourceProperties.PROP_CREATOR));
	   ContentResourceArtifact resourceArtifact = new ContentResourceArtifact(resource, artifactId, resourceOwner);
	   resourceArtifact.setHome(getContentResourceHome());
	   return resourceArtifact;
   }

   protected Artifact createArtifact(ContentResource resource) {
	   Id artifactId = getIdManager().getId(getContentHostingService().getUuid(resource.getId()));	   
	   return createArtifact(resource, artifactId);
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

   public Artifact load(Id artifactId) {
      String resourceId = getContentHostingService().resolveUuid(artifactId.getValue());

      if (resourceId == null) {
         return null;
      }

      try {
         ContentResource resource = getContentHostingService().getResource(resourceId);
         Artifact returned = createArtifact(resource, artifactId);
         return returned;
      }
      catch (PermissionException e) {
         throw new RuntimeException(e);
      }
      catch (IdUnusedException e) {
         throw new RuntimeException(e);
      }
      catch (TypeException e) {
         throw new RuntimeException(e);
      }
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

   public ReadableObjectHome getContentResourceHome() {
      return contentResourceHome;
   }

   public void setContentResourceHome(ReadableObjectHome contentResourceHome) {
      this.contentResourceHome = contentResourceHome;
   }

   public void setWorksiteManager(WorksiteManager worksiteManager) {
      this.worksiteManager = worksiteManager;
   }

}
