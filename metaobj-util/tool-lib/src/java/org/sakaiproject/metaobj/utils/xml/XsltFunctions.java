package org.sakaiproject.metaobj.utils.xml;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.sakaiproject.component.cover.ServerConfigurationService;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Nov 20, 2006
 * Time: 8:27:06 AM
 * To change this template use File | Settings | File Templates.
 */
public class XsltFunctions {

   public static String getRichTextScript(String textBoxId, Node schemaElement) {

      String script = "";

      String editor = ServerConfigurationService.getString("wysiwyg.editor");
      String twinpeaks = ServerConfigurationService.getString("wysiwyg.twinpeaks");

      if (editor.equalsIgnoreCase("FCKeditor")) {
         script += "\t<script type=\"text/javascript\" language=\"JavaScript\">\n" +
            "\n" +
            "\tfunction chef_setupformattedtextarea(textarea_id)\n" +
            "\t{\n" +
            "        \tvar oFCKeditor = new FCKeditor(textarea_id);\n" +
            "\t\toFCKeditor.BasePath = \"/library/editor/FCKeditor/\";\n" +
            "\n" +
            "                var courseId = \"/group/PortfolioAdmin/\";\n" +
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
      else if (editor.equalsIgnoreCase("HTMLArea")) {
         script += "\t<script type=\"text/javascript\" language=\"JavaScript\">\n" +
            "\tvar _editor_url = \"/library/editor/HTMLArea/\"\n" +
            "\tvar _editor_lang = \"en\";\n" +
            "</script>\n" +
            "\t<script type=\"text/javascript\" language=\"JavaScript\" src=\"/library/editor/HTMLArea/htmlarea.js\">\n" +
            "\t</script>\n" +
            "\t<script type=\"text/javascript\" language=\"JavaScript\" src=\"/library/editor/HTMLArea/sakai_editor.js\">\n" +
            "\t</script>\n" +
            "";   
      }

      script +=
         "\t<script type=\"text/javascript\" defer=\"1\">chef_setupformattedtextarea('"+textBoxId+"');</script>";

      return script;
   }

}
