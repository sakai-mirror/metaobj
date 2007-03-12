package org.sakaiproject.metaobj.shared.mgt;

import org.sakaiproject.metaobj.shared.model.Id;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Mar 12, 2007
 * Time: 10:20:36 AM
 * To change this template use File | Settings | File Templates.
 */
public interface FormConsumer {

   public boolean checkFormConsumption(Id formId);

}
