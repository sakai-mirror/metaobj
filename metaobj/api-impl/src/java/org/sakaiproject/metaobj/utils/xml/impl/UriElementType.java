/**********************************************************************************
 * $URL$
 * $Id$
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

package org.sakaiproject.metaobj.utils.xml.impl;

import org.jdom.Element;
import org.jdom.Namespace;
import org.sakaiproject.metaobj.utils.xml.NormalizationException;
import org.sakaiproject.metaobj.utils.xml.SchemaNode;

import java.net.URI;
import java.net.URISyntaxException;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Jan 25, 2006
 * Time: 10:33:36 AM
 * To change this template use File | Settings | File Templates.
 */
public class UriElementType extends BaseElementType {

   public UriElementType(String typeName, Element schemaElement, SchemaNode parentNode, Namespace xsdNamespace) {
      super(typeName, schemaElement, parentNode, xsdNamespace);
   }

   public Class getObjectType() {
      return URI.class;
   }

   public Object getActualNormalizedValue(String value) {
      try {
         return new URI(value);
      }
      catch (URISyntaxException e) {
         throw new NormalizationException("Invalid URI", NormalizationException.INVALID_URI, new Object[]{value});
      }
   }

   public String getSchemaNormalizedValue(String value) throws NormalizationException {
      try {
         return new URI(value).toString();
      }
      catch (URISyntaxException e) {
         throw new NormalizationException("Invalid URI", NormalizationException.INVALID_URI, new Object[]{value});
      }
   }

   public String getSchemaNormalizedValue(Object value) throws NormalizationException {
      if (value != null) {
         return ((URI) value).toString();
      }
      else {
         return null;
      }
   }

}
