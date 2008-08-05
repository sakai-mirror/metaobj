/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright 2005, 2006 Sakai Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at
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

package org.sakaiproject.metaobj.utils.mvc.intf;

import org.apache.velocity.app.VelocityEngine;

/**
 * Created by IntelliJ IDEA.
 * User: John Ellis
 * Date: Jul 29, 2005
 * Time: 3:07:36 PM
 * To change this template use File | Settings | File Templates.
 */
public interface VelocityEngineFactory {
   VelocityEngine getVelocityEngine();
}
