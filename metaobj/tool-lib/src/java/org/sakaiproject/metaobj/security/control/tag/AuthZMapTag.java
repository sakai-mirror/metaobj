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

package org.sakaiproject.metaobj.security.control.tag;

import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.sakaiproject.component.cover.ComponentManager;
import org.sakaiproject.metaobj.security.AuthorizationFacade;
import org.sakaiproject.metaobj.security.model.AuthZMap;
import org.sakaiproject.metaobj.shared.mgt.IdManager;
import org.sakaiproject.metaobj.shared.model.Id;
import org.sakaiproject.tool.cover.ToolManager;

public class AuthZMapTag extends TagSupport {

   private Id qualifier;
   private boolean useSite;
   private String prefix;
   private String var;
   private int scope;

   protected final transient Log logger = LogFactory.getLog(getClass());

   public AuthZMapTag() {
      init();
   }

   /**
    * Default processing of the start tag, returning SKIP_BODY.
    *
    * @return SKIP_BODY
    * @throws javax.servlet.jsp.JspException if an error occurs while processing this tag
    * @see javax.servlet.jsp.tagext.Tag#doStartTag()
    */

   public int doStartTag() throws JspException {
      Map authz = new AuthZMap(getAuthzFacade(), getPrefix(), evaluateQualifier());

      pageContext.setAttribute(getVar(), authz, getScope());

      return super.doStartTag();
   }

   /**
    * Release state.
    *
    * @see javax.servlet.jsp.tagext.Tag#release()
    */

   public void release() {
      super.release();
      init();
   }

   protected AuthorizationFacade getAuthzFacade() {
      return (AuthorizationFacade) ComponentManager.getInstance().get("org.sakaiproject.metaobj.security.AuthorizationFacade");
   }

   public String getPrefix() {
      return prefix;
   }

   public void setPrefix(String prefix) {
      this.prefix = prefix;
   }

   public Id evaluateQualifier() throws JspException {
      if (isUseSite()) {
         qualifier = getIdManager().getId(ToolManager.getCurrentPlacement().getContext());
      }
      else if (qualifier == null) {
         qualifier = getIdManager().getId(ToolManager.getCurrentPlacement().getId());
      }      
      return qualifier;
   }

   public void setQualifier(Id qualifier) {
      this.qualifier = qualifier;
   }

   public int getScope() {
      return scope;
   }

   public String getVar() {
      return var;
   }

   public void setVar(String var) {
      this.var = var;
   }

   public void setScope(String scope) {
      if (scope.equalsIgnoreCase("page")) {
         this.scope = PageContext.PAGE_SCOPE;
      }
      else if (scope.equalsIgnoreCase("request")) {
         this.scope = PageContext.REQUEST_SCOPE;
      }
      else if (scope.equalsIgnoreCase("session")) {
         this.scope = PageContext.SESSION_SCOPE;
      }
      else if (scope.equalsIgnoreCase("application")) {
         this.scope = PageContext.APPLICATION_SCOPE;
      }

      // TODO: Add error handling?  Needs direction from spec.
   }

   // initializes internal state
   protected void init() {
      var = "can";
      scope = PageContext.PAGE_SCOPE;
      setUseSite(false);
   }

   protected IdManager getIdManager() {
      return (IdManager) ComponentManager.getInstance().get("idManager");
   }

   public boolean isUseSite() {
      return useSite;
   }

   public void setUseSite(boolean useSite) {
      this.useSite = useSite;
   }

}
