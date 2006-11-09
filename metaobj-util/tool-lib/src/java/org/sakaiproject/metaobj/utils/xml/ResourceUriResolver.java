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
            "jar:file:/Users/johnellis/devel/3rdParty/sakai2.2-apache/shared/lib/sakai-metaobj-api-dev.jar!" +
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
