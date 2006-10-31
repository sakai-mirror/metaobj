package org.sakaiproject.metaobj.shared.control;

import org.springframework.web.servlet.view.xslt.AbstractXsltView;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.validation.Errors;
import org.springframework.validation.ObjectError;
import org.springframework.validation.FieldError;
import org.jdom.transform.JDOMSource;
import org.jdom.Element;
import org.jdom.Document;
import org.sakaiproject.content.api.ResourceEditingHelper;
import org.sakaiproject.metaobj.shared.mgt.StructuredArtifactDefinitionManager;
import org.sakaiproject.metaobj.shared.model.Artifact;
import org.sakaiproject.component.cover.ComponentManager;
import org.sakaiproject.tool.api.ToolSession;
import org.sakaiproject.tool.cover.SessionManager;
import org.sakaiproject.util.ResourceLoader;

import javax.xml.transform.Source;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.List;
import java.util.Iterator;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Oct 30, 2006
 * Time: 10:10:42 AM
 * To change this template use File | Settings | File Templates.
 */
public class XsltArtifactView extends AbstractXsltView {

   private ResourceLoader resourceLoader = new ResourceLoader();
   private String bundleLocation;

   protected Source createXsltSource(Map map, String string, HttpServletRequest httpServletRequest,
                                     HttpServletResponse httpServletResponse) throws Exception {

      WebApplicationContext context = getWebApplicationContext();
      ToolSession toolSession = SessionManager.getCurrentToolSession();
      Artifact artifact = (Artifact) map.get("bean");

      Element root = getStructuredArtifactDefinitionManager().createFormViewXml(
         artifact, null);

      Errors errors = (Errors) map.get("org.springframework.validation.BindException.bean");
      if (errors.hasErrors()) {
         Element errorsElement = new Element("errors");

         List errorsList = errors.getAllErrors();

         for (Iterator i=errorsList.iterator();i.hasNext();) {
            Element errorElement = new Element("error");
            ObjectError error = (ObjectError) i.next();
            if (error instanceof FieldError) {
               FieldError fieldError = (FieldError) error;
               errorElement.setAttribute("field", fieldError.getField());
               Element rejectedValue = new Element("rejectedValue");
               rejectedValue.addContent(fieldError.getRejectedValue().toString());
               errorElement.addContent(rejectedValue);
            }
            Element message = new Element("message");
            message.addContent(context.getMessage(error, getResourceLoader().getLocale()));
            errorElement.addContent(message);
            errorsElement.addContent(errorElement);
         }

         root.addContent(errorsElement);
      }

      if (toolSession.getAttribute(ResourceEditingHelper.CUSTOM_CSS) != null) {
         Element uri = new Element("uri");
         uri.setText((String) toolSession.getAttribute(ResourceEditingHelper.CUSTOM_CSS));
         root.getChild("css").addContent(uri);
      }

      Document doc = new Document(root);
      return new JDOMSource(doc);
   }

   protected StructuredArtifactDefinitionManager getStructuredArtifactDefinitionManager() {
      return (StructuredArtifactDefinitionManager)
         ComponentManager.get("structuredArtifactDefinitionManager");
   }

   public String getBundleLocation() {
      return bundleLocation;
   }

   public void setBundleLocation(String bundleLocation) {
      this.bundleLocation = bundleLocation;
      setResourceLoader(new ResourceLoader(bundleLocation));
   }

   public ResourceLoader getResourceLoader() {
      return resourceLoader;
   }

   public void setResourceLoader(ResourceLoader resourceLoader) {
      this.resourceLoader = resourceLoader;
   }

}
