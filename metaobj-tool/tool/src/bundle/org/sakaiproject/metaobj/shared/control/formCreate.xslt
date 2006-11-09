<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xhtml="http://www.w3.org/1999/xhtml"
   xmlns:osp="http://www.osportfolio.org/OspML"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">

   <!--xsl:template match="formView">
      <formView>
            <xsl:copy-of select="*"></xsl:copy-of>
      </formView>
   </xsl:template-->

   <xsl:param name="panelId"/>
   <xsl:param name="subForm"/>
   <xsl:output method="html" version="4.0" cdata-section-elements="textarea"
      encoding="iso-8859-1" indent="yes"/>

   <xsl:template match="formView">


      <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
         <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <meta http-equiv="Content-Style-Type" content="text/css"/>
            <title>Resources</title>
            <xsl:for-each select="css/uri">
               <link type="text/css" rel="stylesheet" media="all">
                  <xsl:attribute name="href">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </link>
            </xsl:for-each>
            <script type="text/javascript" language="JavaScript" src="/library/js/headscripts.js"></script>
         </head>
         <body>
            <xsl:attribute name="onLoad">setMainFrameHeight('<xsl:value-of
               select="$panelId"/>');setFocus(focus_path);</xsl:attribute>
            <div class="portletBody">
               <p class="instruction">
                  <xsl:value-of disable-output-escaping="yes" select="formData/artifact/schema/instructions"/>
               </p>
               <xsl:for-each select="/formView/errors/error">
                  <div class="alertMessage">
                     <xsl:value-of select="message"/>
                  </div>
               </xsl:for-each>
               <form method="post">
                  Display Name:
                  <xsl:choose>
                     <xsl:when test="$subForm = 'true'">
                        <xsl:value-of select="formData/artifact/metaData/displayName"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <input type="text" name="displayName" size="50" maxlength="1024">
                           <xsl:attribute name="value">
                              <xsl:value-of select="formData/artifact/metaData/displayName"/>
                           </xsl:attribute>
                        </input>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:apply-templates select="formData/artifact/schema/element">
                     <xsl:with-param name="currentParent" select="formData/artifact/structuredData"/>
                     <xsl:with-param name="rootNode" select="'true'"/>
                  </xsl:apply-templates>

                  <input type="hidden" name="childPath" value=""/>
                  <input type="hidden" name="childIndex" value=""/>
                  <input type="hidden" name="editButton" value="" />
                  <input type="hidden" name="removeButton" value="" />
                  <div>
                     <!-- todo i18n -->
                     <xsl:choose>
                        <xsl:when test="$subForm = 'true'">
                           <input type="submit" name="updateNestedButton" alignment="center" value="Update"/>
                           <input type="submit" name="cancelNestedButton" value="Cancel" />
                        </xsl:when>
                        <xsl:otherwise>
                           <input type="submit" name="submitButton" alignment="center" value="Save"/>
                           <input type="submit" name="cancel" value="Cancel"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </div>
               </form>
            </div>
         </body>
      </html>
   </xsl:template>

   <!-- todo provide specail handling templates for
   certain element types -->

   <xsl:template match="element[children]">
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <xsl:if test="$rootNode = 'true'">
         <xsl:call-template name="produce-fields">
            <xsl:with-param name="currentSchemaNode" select="."/>
            <xsl:with-param name="currentNode" select="$currentNode"/>
            <xsl:with-param name="rootNode" select="$rootNode"/>
         </xsl:call-template>
      </xsl:if>
      <xsl:if test="$rootNode='false'">
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
      </xsl:if>
   </xsl:template>

   <xsl:template match="element[@type = 'xs:date']">
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="."/>
         </xsl:call-template>
         <xsl:comment>date field</xsl:comment>
         <!--input type="text">
            <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="$currentNode"/></xsl:attribute>
         </input-->
      </div>
   </xsl:template>

   <xsl:template match="element[@type = 'xs:boolean']">
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="."/>
         </xsl:call-template>
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
      </div>
   </xsl:template>

   <xsl:template match="element[xs:annotation/xs:documentation
      [@source='ospi.isRichText' or @source='sakai.isRichText'] = 'true']">
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="."/>
         </xsl:call-template>
         <xsl:comment>rich text placeholder</xsl:comment>
      </div>
   </xsl:template>

   <xsl:template match="element[@type = 'xs:anyURI']">
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="."/>
         </xsl:call-template>
         <xsl:comment>anyUri</xsl:comment>
      </div>
   </xsl:template>

   <xsl:template match="element">
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="."/>
         </xsl:call-template>
         <input type="text">
            <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="$currentNode"/></xsl:attribute>
         </input>
      </div>
   </xsl:template>

   <xsl:template match="element[xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength[@value>999]]">
      <xsl:param name="currentParent"/>
      <xsl:param name="rootNode"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]"/>
      <div class="shorttext indnt1">
         <xsl:call-template name="produce-label">
            <xsl:with-param name="currentSchemaNode" select="."/>
         </xsl:call-template>
         <textarea rows="4" cols="60"><xsl:attribute
            name="name"><xsl:value-of select="$name"/></xsl:attribute><xsl:value-of
            select="$currentNode"/></textarea>
      </div>
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
                  select="$index"/>';document.forms[0].submit();</xsl:attribute>
               edit
            </a>
            <a>
               <xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of
                  select="$fieldName"/>';document.forms[0].removeButton.value='Remove';document.forms[0].editButton.value='';document.forms[0].childIndex.value='<xsl:value-of
                  select="$index"/>';document.forms[0].submit();</xsl:attribute>
               remove
            </a>
         </td>
         <td>
            <xsl:value-of select="$dataNode"/>
         </td>
      </tr>
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

</xsl:stylesheet>
