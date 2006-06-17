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

package org.sakaiproject.metaobj.shared.control.tag;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyContent;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.taglibs.standard.lang.support.ExpressionEvaluatorManager;
import org.apache.taglibs.standard.tag.common.core.Util;
import org.apache.taglibs.standard.tag.common.fmt.MessageSupport;
import org.apache.taglibs.standard.tag.el.fmt.MessageTag;
import org.sakaiproject.metaobj.shared.model.OspException;

public class Message extends MessageTag {
   protected final transient Log logger = LogFactory.getLog(getClass());

   private String text = null;
   private String localVar = null;
   private int localScope = PageContext.PAGE_SCOPE;  // 'scope' attribute


   // Releases any resources we may have (or inherit)
   public void release() {
      localScope = PageContext.PAGE_SCOPE;
      text = null;
      localVar = null;
      super.release();
   }

   public void setScope(String scope) {
      super.setScope(scope);
      localScope = Util.getScope(scope);
   }

   public void setVar(String var) {
      super.setVar(var);
      localVar = var;
   }

   public int doEndTag() throws JspException {

      BodyContent content = null;

      if (localVar == null) {
         content = pageContext.pushBody();
      }

      int returnVal = super.doEndTag();

      if (localVar != null) {
         String varValue = (String) pageContext.getAttribute(localVar, localScope);
         if (varValue.startsWith(MessageSupport.UNDEFINED_KEY) &&
               varValue.endsWith(MessageSupport.UNDEFINED_KEY) &&
               text != null) {
            varValue = (String) ExpressionEvaluatorManager.evaluate("text", text, String.class, this, pageContext);
            pageContext.setAttribute(localVar, varValue, localScope);
         }
      }
      else {
         String contentValue = content.getString();
         contentValue = content.getString();
         if (contentValue.startsWith(MessageSupport.UNDEFINED_KEY) &&
               contentValue.endsWith(MessageSupport.UNDEFINED_KEY) &&
               text != null) {
            contentValue = (String) ExpressionEvaluatorManager.evaluate("text", text, String.class, this, pageContext);
         }

         pageContext.popBody();

         try {
            pageContext.getOut().print(contentValue);
         }
         catch (IOException ex) {
            throw new OspException("", ex);
         }
      }

      return returnVal;
   }


   public String getText() {
      return text;
   }

   public void setText(String text) {
      this.text = text;
   }
}
