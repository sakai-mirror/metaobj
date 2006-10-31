/*
 * The Open Source Portfolio Initiative Software is Licensed under the Educational Community License Version 1.0:
 *
 * This Educational Community License (the "License") applies to any original work of authorship
 * (the "Original Work") whose owner (the "Licensor") has placed the following notice immediately
 * following the copyright notice for the Original Work:
 *
 * Copyright (c) 2004 Trustees of Indiana University and r-smart Corporation
 *
 * This Original Work, including software, source code, documents, or other related items, is being
 * provided by the copyright holder(s) subject to the terms of the Educational Community License.
 * By obtaining, using and/or copying this Original Work, you agree that you have read, understand,
 * and will comply with the following terms and conditions of the Educational Community License:
 *
 * Permission to use, copy, modify, merge, publish, distribute, and sublicense this Original Work and
 * its documentation, with or without modification, for any purpose, and without fee or royalty to the
 * copyright holder(s) is hereby granted, provided that you include the following on ALL copies of the
 * Original Work or portions thereof, including modifications or derivatives, that you make:
 *
 * - The full text of the Educational Community License in a location viewable to users of the
 * redistributed or derivative work.
 *
 * - Any pre-existing intellectual property disclaimers, notices, or terms and conditions.
 *
 * - Notice of any changes or modifications to the Original Work, including the date the changes were made.
 *
 * - Any modifications of the Original Work must be distributed in such a manner as to avoid any confusion
 *  with the Original Work of the copyright holders.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * The name and trademarks of copyright holder(s) may NOT be used in advertising or publicity pertaining
 * to the Original or Derivative Works without specific, written prior permission. Title to copyright
 * in the Original Work and any associated documentation will at all times remain with the copyright holders.
 *
 * $Header: /root/osp/src/portfolio/org/theospi/portfolio/shared/control/XmlControllerBase.java,v 1.8 2005/08/29 18:24:53 jellis Exp $
 * $Revision$
 * $Date$
 */
package org.sakaiproject.metaobj.shared.control;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;
import org.sakaiproject.metaobj.shared.model.StructuredArtifact;
import org.sakaiproject.metaobj.shared.model.ElementBean;
import org.sakaiproject.metaobj.shared.model.ElementListBean;
import org.sakaiproject.metaobj.shared.mgt.HomeFactory;
import org.sakaiproject.content.api.ResourceEditingHelper;

import java.util.Hashtable;
import java.util.Map;
import java.util.StringTokenizer;

public class XmlControllerBase {
   protected final Log logger = LogFactory.getLog(getClass());
   private HomeFactory homeFactory;
   private XmlValidator validator = null;

   protected ModelAndView handleNonSubmit(ElementBean bean, Map request,
                                  Map session, Map application, Errors errors) {
      EditedArtifactStorage sessionBean = (EditedArtifactStorage)session.get(
         EditedArtifactStorage.EDITED_ARTIFACT_STORAGE_SESSION_KEY);

      if (sessionBean == null) {
         StructuredArtifact artifact = (StructuredArtifact)bean;
         sessionBean = new EditedArtifactStorage(artifact.getCurrentSchema(),
            artifact);
         session.put(EditedArtifactStorage.EDITED_ARTIFACT_STORAGE_SESSION_KEY,
            sessionBean);
      }

      boolean isRoot = false;

      if ((request.get("editButton") != null &&
         request.get("editButton").toString().length() > 0)||
         request.get("addButton") != null) {
         handleEditAdd(bean, sessionBean, request, session, application, errors);
      }
      else if (request.get("removeButton") != null &&
         request.get("removeButton").toString().length() > 0) {
         handleRemove(bean, sessionBean, request, session, application, errors);
      }
      else if (request.get("cancelNestedButton") != null) {
         sessionBean.popCurrentElement(true);
         sessionBean.popCurrentPath();
         isRoot = (sessionBean.getCurrentElement() instanceof StructuredArtifact);
      }
      else if (request.get("updateNestedButton") != null) {
         getValidator().validate(sessionBean.getCurrentElement(), errors, true);
         if (errors.hasErrors()) {
            return null;
         }
         sessionBean.popCurrentElement();
         sessionBean.popCurrentPath();
         isRoot = (sessionBean.getCurrentElement() instanceof StructuredArtifact);
      }

      Map map = new Hashtable();

      map.put(EditedArtifactStorage.STORED_ARTIFACT_FLAG,
         "true");

      map.put("artifactType", getSchemaName(session));
      if (request.get("parentId") != null) {
         map.put("parentId", getParentId(request));
      }
      return new ModelAndView("subList", map);
   }

   protected void handleRemove(ElementBean bean, EditedArtifactStorage sessionBean, Map request,
                               Map session, Map application, Errors errors) {
      ElementListBean parentList = findList(bean, (String)request.get("childPath"));
      int removeIndex = Integer.parseInt((String)request.get("childIndex"));
      parentList.remove(removeIndex);
   }

   protected void handleEditAdd(ElementBean bean, EditedArtifactStorage sessionBean, Map request,
                                Map session, Map application, Errors errors) {
      // find the individual element in question
      ElementListBean parentList = findList(bean, (String)request.get("childPath"));
      ElementBean newBean = null;

      if (request.get("editButton") != null &&
         request.get("editButton").toString().length() > 0) {
         int index = Integer.parseInt((String)request.get("childIndex"));
         newBean = (ElementBean)parentList.get(index);
      }
      else if (request.get("addButton") != null) {
         newBean = parentList.createBlank();
      }

      sessionBean.pushCurrentElement(newBean);
      sessionBean.pushCurrentPath((String)request.get("childPath"));

      if (request.get("addButton") != null) {
         parentList.add(newBean);
      }

   }

   protected ElementListBean findList(ElementBean bean, String path) {
      StringTokenizer tok = new StringTokenizer(path, ".");
      ElementBean current = bean;

      while (tok.hasMoreTokens()) {
         Object obj = current.get(tok.nextToken());
         if (obj instanceof ElementBean) {
            current = (ElementBean)obj;
         }
         else if (obj instanceof ElementListBean) {
            return (ElementListBean)obj;
         }
      }

      return null;
   }

   protected String getSchemaName(Map session) {
      Object schemaName = session.get(ResourceEditingHelper.CREATE_SUB_TYPE);

      if (schemaName instanceof String) {
         return (String)schemaName;
      }
      else if (schemaName instanceof String[]) {
         return ((String[])schemaName)[0];
      }
      else {
         return schemaName.toString();
      }
   }

   protected String getParentId(Map request) {
      Object parentId = request.get("parentId");

      if (parentId instanceof String) {
         return (String)parentId;
      }
      else if (parentId instanceof String[]) {
         return ((String[])parentId)[0];
      }
      else {
         return parentId.toString();
      }
   }

   public HomeFactory getHomeFactory() {
      return homeFactory;
   }

   public void setHomeFactory(HomeFactory homeFactory) {
      this.homeFactory = homeFactory;
   }

   public XmlValidator getValidator() {
      return validator;
   }

   public void setValidator(XmlValidator validator) {
      this.validator = validator;
   }

   public boolean isCancel(Map request) {
      return request.get("cancelNestedButton") != null;
   }

   public ModelAndView processCancel(Map request, Map session, Map application,
                                     Object command, Errors errors) throws Exception {
      return handleNonSubmit((ElementBean)command, request, session, application, errors);
   }

}
