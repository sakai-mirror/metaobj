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

package org.sakaiproject.metaobj.utils.xml;

import org.sakaiproject.content.api.ContentHostingService;
import org.sakaiproject.content.api.ContentResource;
import org.sakaiproject.exception.PermissionException;
import org.sakaiproject.exception.IdUnusedException;
import org.sakaiproject.exception.TypeException;
import org.sakaiproject.exception.ServerOverloadException;

import javax.xml.transform.URIResolver;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamSource;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Nov 7, 2006
 * Time: 10:45:51 AM
 * To change this template use File | Settings | File Templates.
 */
public class ResourceUriResolver implements URIResolver {

   private ContentHostingService contentHostingService = null;

   public Source resolve(String string, String string1) throws TransformerException {
      try {
         ContentResource resource = getContentHostingService().getResource(string);
         return new StreamSource(resource.streamContent(),
            "jar:file:sakai-metaobj-api-dev.jar!" +
               "/org/sakaiproject/metaobj/shared/control/");
      } catch (PermissionException e) {
         throw new TransformerException(e);
      } catch (IdUnusedException e) {
         throw new TransformerException(e);
      } catch (TypeException e) {
         throw new TransformerException(e);
      } catch (ServerOverloadException e) {
         throw new TransformerException(e);
      }
   }

   public ContentHostingService getContentHostingService() {
      return contentHostingService;
   }

   public void setContentHostingService(ContentHostingService contentHostingService) {
      this.contentHostingService = contentHostingService;
   }

}
