<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:sakaifn="org.sakaiproject.metaobj.utils.xml.XsltFunctions"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xhtml="http://www.w3.org/1999/xhtml"
   xmlns:osp="http://www.osportfolio.org/OspML"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">

   <!-- todo UI -->
   <xsl:template name="complexElement-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:call-template name="produce-label">
         <xsl:with-param name="currentSchemaNode" select="."/>
      </xsl:call-template>
      <table class="chefFlatListViewTable">
         <thead>
            <tr>
               <th scope="col">Action</th>
               <th scope="col">
               </th>
            </tr>
         </thead>
         <tbody>
            <xsl:for-each select="$currentParent/node()[$name=name()]">
               <xsl:call-template name="subListRow">
                  <xsl:with-param name="index" select="position() - 1"/>
                  <xsl:with-param name="fieldName" select="$name"/>
                  <xsl:with-param name="dataNode" select="."/>
               </xsl:call-template>
            </xsl:for-each>
         </tbody>
      </table>
      <div class="chefButtonRow">
         <input type="submit" name="addButton" alignment="center" value="Add New">
            <xsl:attribute name="onClick">this.form.childPath.value='<xsl:value-of select="$name"/>';return true</xsl:attribute>
         </input>
      </div>
   </xsl:template>

   <!-- todo: length restrictions -->
   <xsl:template name="shortText-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="$currentSchemaNode"/>
         </xsl:call-template>
         <input type="text">
            <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="$currentNode"/></xsl:attribute>
         </input>
      </div>
   </xsl:template>

   <xsl:template name="select-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="$currentSchemaNode"/>
         </xsl:call-template>
         <select>
            <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
               <option>
                  <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                  <xsl:if test="$currentNode = @value">
                     <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="@value"/>
               </option>
            </xsl:for-each>
         </select>
      </div>
   </xsl:template>

   <xsl:template name="richText-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="$currentSchemaNode"/>
         </xsl:call-template>
         <table><tr><td>
            <textarea rows="30" cols="80"><xsl:attribute
               name="id"><xsl:value-of select="$name"/></xsl:attribute><xsl:attribute
               name="name"><xsl:value-of select="$name"/></xsl:attribute><xsl:choose><xsl:when
               test="string($currentNode) = ''"><xsl:text disable-output-escaping="yes">&amp;nbsp;
               </xsl:text></xsl:when><xsl:otherwise><xsl:value-of
               select="$currentNode" disable-output-escaping="yes"/></xsl:otherwise></xsl:choose></textarea>
            <xsl:if test="string($currentNode) = ''">
               <script language="JavaScript" type="text/javascript">
                  document.forms[0].<xsl:value-of select="$name"/>.value=""
               </script>
            </xsl:if>
            <xsl:value-of select="sakaifn:getRichTextScript($name, $currentSchemaNode)"
                          disable-output-escaping="yes"/>
         </td></tr></table>
      </div>
   </xsl:template>

   <xsl:template name="longText-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="$currentSchemaNode"/>
         </xsl:call-template>
         <textarea rows="4" cols="60"><xsl:attribute
            name="id"><xsl:value-of select="$name"/></xsl:attribute><xsl:attribute
            name="name"><xsl:value-of select="$name"/></xsl:attribute><xsl:choose><xsl:when
            test="string($currentNode) = ''"><xsl:text disable-output-escaping="yes">&amp;nbsp;
            </xsl:text></xsl:when><xsl:otherwise><xsl:value-of
            select="$currentNode" disable-output-escaping="yes"/></xsl:otherwise></xsl:choose></textarea>
         <xsl:if test="string($currentNode) = ''">
            <script language="JavaScript" type="text/javascript">
               document.forms[0].<xsl:value-of select="$name"/>.value=""
            </script>
         </xsl:if>
      </div>
   </xsl:template>

   <xsl:template name="checkBox-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="$currentSchemaNode"/>
         </xsl:call-template>
         <xsl:call-template name="checkbox-widget">
            <xsl:with-param name="name" select="$name"/>
            <xsl:with-param name="currentNode" select="$currentNode"/>            
         </xsl:call-template>
      </div>
   </xsl:template>

   <xsl:template name="checkbox-widget">
      <xsl:param name="name"/>
      <xsl:param name="currentNode"/>
      <input type="checkbox" value="true">
         <xsl:attribute name="name"><xsl:value-of select="$name"/>_checkbox</xsl:attribute>
         <xsl:if test="$currentNode = 'true'">
            <xsl:attribute name="checked"/>
         </xsl:if>
         <xsl:attribute name="onChange">form['<xsl:value-of
            select="$name"/>'].value=this.checked</xsl:attribute>
      </input>
      <input type="hidden">
         <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
         <xsl:attribute name="value"><xsl:value-of select="$currentNode"/></xsl:attribute>
      </input>
   </xsl:template>

   <!-- todo UI -->
   <xsl:template name="fileHelper-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="$currentSchemaNode"/>
         </xsl:call-template>

         <xsl:for-each select="$currentParent/node()[$name=name()]">
            <input type="hidden">
               <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
               <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
            </input>
            <a target="_new">
               <xsl:attribute name="href"><xsl:value-of select="sakaifn:getReferenceUrl(.)"/></xsl:attribute>
               <xsl:value-of select="sakaifn:getReferenceName(.)"/>
            </a>
         </xsl:for-each>

         <a>
            <xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of
               select="$name"/>';document.forms[0].fileHelper.value='true';document.forms[0].onsubmit();document.forms[0].submit();</xsl:attribute>
            Manage Attachment(s)
         </a>
      </div>
   </xsl:template>

   <xsl:template name="date-field">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="$currentSchemaNode/@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="$currentSchemaNode"/>
         </xsl:call-template>
         <xsl:comment>date field</xsl:comment>
         <xsl:call-template name="calendar-widget">
            <xsl:with-param name="schemaNode" select="$currentSchemaNode"/>
            <xsl:with-param name="dataNode" select="$currentNode"/>
         </xsl:call-template>
      </div>
   </xsl:template>

   <xsl:template name="calendar-widget">
      <xsl:param name="schemaNode"/>
      <xsl:param name="dataNode"/>
      <xsl:variable name="year" select="sakaifn:dateField($dataNode, 1, 'date')"/>
      <xsl:variable name="currentYear" select="sakaifn:dateField(sakaifn:currentDate(), 1, 'date')"/>
      <xsl:variable name="month" select="sakaifn:dateField($dataNode, 2, 'date') + 1"/>
      <xsl:variable name="day" select="sakaifn:dateField($dataNode, 5, 'date')"/>
      <xsl:variable name="fieldId" select="generate-id()"/>

      <i>mm/dd/yyyy</i>
      <input type="text" size="10">
         <xsl:attribute name="name"><xsl:value-of select="$schemaNode/@name"/>.fullDate</xsl:attribute>
         <xsl:attribute name="id"><xsl:value-of select="$schemaNode/@name"/></xsl:attribute>
         <xsl:attribute name="value"><xsl:if test="$year > -1"
            ><xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>/<xsl:value-of select="$year"
            /></xsl:if></xsl:attribute>
      </input>
      <img width="16" height="16" style="cursor:pointer;" border="0"
           src="/sakai-jsf-resource/inputDate/images/calendar.gif">
         <xsl:attribute name="alt"><xsl:value-of select="sakaifn:getMessage('messages', 'date_pick_alt')" /></xsl:attribute>
         <xsl:attribute name="onclick"
            >javascript:var cal<xsl:value-of select="$fieldId"/> = new calendar2(document.getElementById('<xsl:value-of select="$schemaNode/@name"/>'));cal<xsl:value-of select="$fieldId"/>.year_scroll = true;cal<xsl:value-of select="$fieldId"/>.time_comp = false;cal<xsl:value-of select="$fieldId"/>.popup('','/sakai-jsf-resource/inputDate/')</xsl:attribute>
      </img>

   </xsl:template>

   <xsl:template name="month-option">
      <xsl:param name="selectedMonth"/>
      <xsl:param name="month"/>
      <xsl:param name="monthName"/>
      <option>
         <xsl:attribute name="value"><xsl:value-of select="$month"/></xsl:attribute>
         <xsl:if test="$month = $selectedMonth"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>
         <xsl:value-of select="sakaifn:getMessage('messages', $monthName)" />
      </option>
   </xsl:template>

   <xsl:template name="produce-label">
      <xsl:param name="currentSchemaNode"/>
      <label>
         <xsl:attribute name="for"><xsl:value-of select="@name"/></xsl:attribute>
         <xsl:choose>
            <xsl:when test="$currentSchemaNode/xs:annotation/xs:documentation[@source='sakai.label']">
               <xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='sakai.label']"/>
            </xsl:when>
            <xsl:when test="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']">
               <xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="$currentSchemaNode">
                  <xsl:value-of select="@name"/>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </label>
   </xsl:template>

   <xsl:template name="produce-metadata">
      <div class="shorttext indnt1">
         <label>Created</label>
         <xsl:value-of select="/formView/formData/artifact/metaData/repositoryNode/created"/>
      </div>
      <div class="shorttext indnt1">
         <label>Modified</label>
         <xsl:value-of select="/formView/formData/artifact/metaData/repositoryNode/modified"/>
      </div>
   </xsl:template>

   <xsl:template name="produce-fields">
      <xsl:param name="currentSchemaNode"/>
      <xsl:param name="currentNode"/>
      <xsl:param name="rootNode"/>
      <xsl:for-each select="$currentSchemaNode/children">
         <xsl:apply-templates select="@*|node()">
            <xsl:with-param name="currentParent" select="$currentNode"/>
            <xsl:with-param name="rootNode" select="'false'"/>
         </xsl:apply-templates>
      </xsl:for-each>
      <xsl:if test="$rootNode='true' and /formView/formData/artifact/metaData">
         <xsl:call-template name="produce-metadata"/>
      </xsl:if>
   </xsl:template>

   <xsl:template name="subListRow">
      <xsl:param name="index"/>
      <xsl:param name="fieldName"/>
      <xsl:param name="dataNode"/>
      <tr>
         <td>
            <a>
               <xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of
                  select="$fieldName"/>';document.forms[0].editButton.value='Edit';document.forms[0].removeButton.value='';document.forms[0].childIndex.value='<xsl:value-of
                  select="$index"/>';document.forms[0].onsubmit();document.forms[0].submit();</xsl:attribute>
               edit
            </a>
            <a>
               <xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of
                  select="$fieldName"/>';document.forms[0].removeButton.value='Remove';document.forms[0].editButton.value='';document.forms[0].childIndex.value='<xsl:value-of
                  select="$index"/>';document.forms[0].onsubmit();document.forms[0].submit();</xsl:attribute>
               remove
            </a>
         </td>
         <td>
            <xsl:value-of select="$dataNode"/>
         </td>
      </tr>
   </xsl:template>

</xsl:stylesheet>