/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2007, 2008 The Sakai Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.osedu.org/licenses/ECL-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **********************************************************************************/

package org.sakaiproject.metaobj.shared.control;

import org.sakaiproject.site.api.Site;

import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Mar 26, 2007
 * Time: 9:57:57 AM
 * To change this template use File | Settings | File Templates.
 */
public class SiteHomeWrapper implements Comparable {

   private Site site;
   private List homes;

   public SiteHomeWrapper(Site site, List homes) {
      this.site = site;
      this.homes = homes;
   }

   public Site getSite() {
      return site;
   }

   public void setSite(Site site) {
      this.site = site;
   }

   public List getHomes() {
      return homes;
   }

   public void setHomes(List homes) {
      this.homes = homes;
   }

   public int compareTo(Object o) {
      return site.getTitle().compareTo(((SiteHomeWrapper)o).getSite().getTitle());
   }
}
