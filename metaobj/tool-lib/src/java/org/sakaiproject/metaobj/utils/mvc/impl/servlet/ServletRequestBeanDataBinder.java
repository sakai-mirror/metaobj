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

package org.sakaiproject.metaobj.utils.mvc.impl.servlet;

import org.sakaiproject.metaobj.utils.mvc.impl.BindExceptionBase;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.validation.BindException;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.ServletRequestParameterPropertyValues;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.ServletRequest;

public class ServletRequestBeanDataBinder extends ServletRequestDataBinder {
   public ServletRequestBeanDataBinder(Object o, String s) {
      super(o, s);
   }

   public void bind(ServletRequest request) {
      // bind normal HTTP parameters
      bind(new ServletRequestParameterPropertyValues(request));

      // bind multipart files
      if (request instanceof MultipartHttpServletRequest) {
         MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
         bind(new MutablePropertyValues(multipartRequest.getFileMap()));
      }
   }

   protected BindException createErrors(Object target, String name) {
      return new BindExceptionBase(target, name);
   }
}
