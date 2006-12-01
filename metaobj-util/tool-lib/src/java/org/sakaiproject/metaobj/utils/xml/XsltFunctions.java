package org.sakaiproject.metaobj.utils.xml;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.sakaiproject.component.cover.ServerConfigurationService;
import org.sakaiproject.content.cover.ContentHostingService;
import org.sakaiproject.tool.cover.ToolManager;
import org.sakaiproject.util.Xml;
import org.sakaiproject.util.ResourceLoader;
import org.sakaiproject.entity.api.Reference;
import org.sakaiproject.entity.cover.EntityManager;

import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.Hashtable;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.Format;
import java.text.SimpleDateFormat;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Nov 20, 2006
 * Time: 8:27:06 AM
 * To change this template use File | Settings | File Templates.
 */
public class XsltFunctions {

   private static final String DATE_FORMAT = "yyyy-MM-dd";
   private static final String TIME_FORMAT = "HH:mm:ss.SSSZ";
   private static final String DATE_TIME_FORMAT = DATE_FORMAT + "'T'" +
         TIME_FORMAT;

   private static final Format dateTimeFormat = new SimpleDateFormat(DATE_TIME_FORMAT);
   private static final Format dateFormat = new SimpleDateFormat(DATE_FORMAT);
   private static final Format timeFormat = new SimpleDateFormat(TIME_FORMAT);

   private static Map<String, ResourceLoader> resourceLoaders = new Hashtable<String, ResourceLoader>();

   public static String getRichTextScript(String textBoxId, Node schemaElement) {

      String script = "";

      String editor = ServerConfigurationService.getString("wysiwyg.editor");
      String twinpeaks = ServerConfigurationService.getString("wysiwyg.twinpeaks");
      String collectionId = ContentHostingService.getSiteCollection(ToolManager.getCurrentPlacement().getContext());

      if (editor.equalsIgnoreCase("FCKeditor")) {
         script += "\t<script type=\"text/javascript\" language=\"JavaScript\">\n" +
            "\n" +
            "\tfunction chef_setupformattedtextarea(textarea_id)\n" +
            "\t{\n" +
            "        \tvar oFCKeditor = new FCKeditor(textarea_id);\n" +
            "\t\toFCKeditor.BasePath = \"/library/editor/FCKeditor/\";\n" +
            "\n" +
            "                var courseId = \"" + collectionId + "\";\n" +
            "\n" +
            "                oFCKeditor.Config['ImageBrowserURL'] = oFCKeditor.BasePath + \"editor/filemanager/browser/default/browser.html?Connector=/sakai-fck-connector/web/editor/filemanager/browser/default/connectors/jsp/connector&Type=Image&CurrentFolder=\" + courseId;\n" +
            "                oFCKeditor.Config['LinkBrowserURL'] = oFCKeditor.BasePath + \"editor/filemanager/browser/default/browser.html?Connector=/sakai-fck-connector/web/editor/filemanager/browser/default/connectors/jsp/connector&Type=Link&CurrentFolder=\" + courseId;\n" +
            "                oFCKeditor.Config['FlashBrowserURL'] = oFCKeditor.BasePath + \"editor/filemanager/browser/default/browser.html?Connector=/sakai-fck-connector/web/editor/filemanager/browser/default/connectors/jsp/connector&Type=Flash&CurrentFolder=\" + courseId;\n" +
            "                oFCKeditor.Config['ImageUploadURL'] = oFCKeditor.BasePath + \"/sakai-fck-connector/web/editor/filemanager/browser/default/connectors/jsp/connector?Type=Image&Command=QuickUpload&Type=Image&CurrentFolder=\" + courseId;\n" +
            "                oFCKeditor.Config['FlashUploadURL'] = oFCKeditor.BasePath + \"/sakai-fck-connector/web/editor/filemanager/browser/default/connectors/jsp/connector?Type=Flash&Command=QuickUpload&Type=Flash&CurrentFolder=\" + courseId;\n" +
            "                oFCKeditor.Config['LinkUploadURL'] = oFCKeditor.BasePath + \"/sakai-fck-connector/web/editor/filemanager/browser/default/connectors/jsp/connector?Type=File&Command=QuickUpload&Type=Link&CurrentFolder=\" + courseId;\n" +
            "\t\toFCKeditor.Width  = \"600\" ;\n" +
            "\t\toFCKeditor.Height = \"400\" ;\n" +
            "                oFCKeditor.Config['CustomConfigurationsPath'] = \"/library/editor/FCKeditor/config.js\";\n" +
            "    \t\toFCKeditor.ReplaceTextarea() ;\n" +
            "\t}\n" +
            "\t\n" +
            "</script>\n" +
            "\n" +
            "\n" +
            "\n";
      }
      else {
         script += "\t<script type=\"text/javascript\" language=\"JavaScript\">\n" +
            "\tvar _editor_url = \"/library/editor/"+editor+"\"\n" +
            "\tvar _editor_lang = \"en\";\n" +
            "</script>\n" +
            "\t<script type=\"text/javascript\" language=\"JavaScript\" src=\"/library/editor/"+editor+"/htmlarea.js\">\n" +
            "\t</script>\n" +
            "\t<script type=\"text/javascript\" language=\"JavaScript\" src=\"/library/editor/"+editor+"/sakai_editor";
         if (twinpeaks != null && twinpeaks.equalsIgnoreCase("true")) {
            script += "_twinpeaks";
         }

         script += ".js\">\n" +
            "\t</script>\n" +
            "";
      }

      script +=
         "\t<script type=\"text/javascript\" defer=\"1\">chef_setupformattedtextarea('"+textBoxId+"');</script>";

      return script;
   }

   public static long dateField(String date, int field, String type) {
      Format useFormat = dateTimeFormat;
      if (type.equalsIgnoreCase("date")) {
         useFormat = dateFormat;
      }
      else if (type.equals("time")) {
         useFormat = timeFormat;
      }

      Date dateObject = null;
      if (date == null || date.equals("")) {
         return -1;
      }
      else {
         try {
            dateObject = (Date) useFormat.parseObject(date);
         } catch (ParseException e) {
            throw new RuntimeException(e);
         }
      }
      Calendar cal = Calendar.getInstance();
      cal.setTime(dateObject);
      return cal.get(field);
   }

   public static NodeList loopCounter(int start, int end) {
      Document doc = Xml.createDocument();

      Element parent = doc.createElement("parent");

      for (int i=start;i<=end;i++) {
         Element data = doc.createElement("data");
         data.appendChild(doc.createTextNode(i + ""));
         parent.appendChild(data);
      }

      return parent.getElementsByTagName("data");
   }

   public static String currentDate() {
      return dateFormat.format(new Date());
   }

   public static String getMessage(String loaderKey, String key) {
      ResourceLoader loader = getLoader(loaderKey);

      return (String) loader.get(key);
   }

   public static ResourceLoader getLoader(String loaderKey) {
      ResourceLoader loader = resourceLoaders.get(loaderKey);

      if (loader == null) {
         loader = new ResourceLoader(loaderKey);
         registerLoader(loaderKey, loader);
      }
      return loader;
   }

   public static void registerLoader(String key, ResourceLoader loader) {
      resourceLoaders.put(key, loader);
   }

   public static String getReferenceName(String idString) {
      String refString = ContentHostingService.getReference(idString);
      Reference ref = EntityManager.newReference(refString);
      String prop = ref.getEntity().getProperties().getNamePropDisplayName();
      return ref.getEntity().getProperties().getProperty(prop);
   }

   public static String getReferenceUrl(String idString) {
      String refString = ContentHostingService.getReference(idString);
      Reference ref = EntityManager.newReference(refString);
      return ref.getUrl();
   }

}
