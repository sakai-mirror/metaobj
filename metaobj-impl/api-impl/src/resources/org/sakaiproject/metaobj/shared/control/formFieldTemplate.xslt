<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:sakaifn="org.sakaiproject.metaobj.utils.xml.XsltFunctions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:osp="http://www.osportfolio.org/OspML" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!-- todo UI -->
	<xsl:template name="complexElement-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:choose>
			<xsl:when test="$currentParent/node()[$name=name()]">
				<table class="listHier lines nolines" cellpadding="0" cellspacing="0" style="width:50%">
					<thead>
						<tr>
							<th scope="col">
								<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']" />
							</th>
							<th scope="col" />
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$currentParent/node()[$name=name()]">
							<xsl:call-template name="subListRow">
								<xsl:with-param name="index" select="position() - 1" />
								<xsl:with-param name="fieldName" select="$name" />
								<xsl:with-param name="dataNode" select="." />
							</xsl:call-template>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="produce-label">
					<xsl:with-param name="currentSchemaNode" select="." />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<div class="act">
			<input type="submit" name="addButton" alignment="center" value="Add New" onClick="this.form.childPath.value='{$name}';return true" />
		</div>
	</xsl:template>
	<!-- todo: length restrictions -->
	<xsl:template name="shortText-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<div>
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">shorttext required</xsl:attribute>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">shorttext</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<input type="text" id="{$name}" name="{$name}" value="{$currentNode}" />
		</div>
	</xsl:template>
	<xsl:template name="select-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<div>
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">shorttext required</xsl:attribute>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">shorttext</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<select id="{$name}" name="{$name}">
				<xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
					<option value="{@value}">
						<xsl:if test="$currentNode = @value">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@value" />
					</option>
				</xsl:for-each>
			</select>
		</div>
	</xsl:template>
	<xsl:template name="richText-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<div>
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">longtext required</xsl:attribute>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">longtext</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
				<xsl:with-param name="nodeType">longtext</xsl:with-param>
			</xsl:call-template>
			<table>
				<tr>
					<td>
						<textarea rows="30" cols="80" id="{$name}" name="{$name}">
							<xsl:choose>
								<xsl:when test="string($currentNode) = ''">
									<xsl:text disable-output-escaping="yes">&amp;nbsp;
               </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$currentNode" disable-output-escaping="yes" />
								</xsl:otherwise>
							</xsl:choose>
						</textarea>
						<xsl:if test="string($currentNode) = ''">
							<script language="JavaScript" type="text/javascript"> document.forms[0].<xsl:value-of select="$name" />.value="" </script>
						</xsl:if>
						<xsl:value-of select="sakaifn:getRichTextScript($name, $currentSchemaNode)" disable-output-escaping="yes" />
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template name="longText-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<div>
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">longtext required</xsl:attribute>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">longtext</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="nodeType">longtext</xsl:with-param>
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<textarea rows="4" cols="60" id="{$name}" name="{$name}">
				<xsl:choose>
					<xsl:when test="string($currentNode) = ''" />
					<xsl:otherwise>
						<xsl:value-of select="$currentNode" disable-output-escaping="yes" />
					</xsl:otherwise>
				</xsl:choose>
			</textarea>
		</div>
	</xsl:template>
	<xsl:template name="checkBox-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<div class="checkbox labelindnt">
			<xsl:call-template name="checkbox-widget">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="currentNode" select="$currentNode" />
			</xsl:call-template>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="checkbox-widget">
		<xsl:param name="name" />
		<xsl:param name="currentNode" />
		<input type="checkbox" value="true" id="{$name}" name="{$name}_checkbox">
			<xsl:if test="$currentNode = 'true'">
				<xsl:attribute name="checked" />checked</xsl:if>
			<xsl:attribute name="onChange">form['<xsl:value-of select="$name" />'].value=this.checked </xsl:attribute>
		</input>
		<input type="hidden" name="{$name}" value="{$currentNode}" />
	</xsl:template>
	<!-- todo UI -->
	<xsl:template name="fileHelper-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<div class="shorttext">
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<input id="{$name}" type="button" onclick="javascript:document.forms[0].childPath.value='{$name}';document.forms[0].fileHelper.value='true';document.forms[0].onsubmit();document.forms[0].submit();" title="sakaifn:getMessage('messages', 'manage_attachments'_title)" value="sakaifn:getMessage('messages', 'manage_attachments')">
				<xsl:attribute name="title">
					<xsl:value-of select="sakaifn:getMessage('messages', 'manage_attachments_title')" />
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:value-of select="sakaifn:getMessage('messages', 'manage_attachments')" />
				</xsl:attribute>
			</input>
			<xsl:if test="$currentParent/node()[$name=name()]">
				<ul class="attachList labelindnt" style="clear:both">
					<xsl:for-each select="$currentParent/node()[$name=name()]">
						<li>
							<!--todo: need a mimetype lookup to generate the icon -->
							<img src="/library/image/sakai/attachments.gif" />
							<input type="hidden" name="{$name}" value="{.}" />
							<a target="_blank">
								<xsl:attribute name="href">
									<xsl:value-of select="sakaifn:getReferenceUrl(.)" />
								</xsl:attribute>
								<xsl:value-of select="sakaifn:getReferenceName(.)" />
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="date-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<div class="shorttext">
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">shorttext required</xsl:attribute>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">shorttext</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<xsl:comment>date field</xsl:comment>
			<xsl:call-template name="calendar-widget">
				<xsl:with-param name="schemaNode" select="$currentSchemaNode" />
				<xsl:with-param name="dataNode" select="$currentNode" />
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="calendar-widget">
		<xsl:param name="schemaNode" />
		<xsl:param name="dataNode" />
		<xsl:variable name="year" select="sakaifn:dateField($dataNode, 1, 'date')" />
		<xsl:variable name="currentYear" select="sakaifn:dateField(sakaifn:currentDate(), 1, 'date')" />
		<xsl:variable name="month" select="sakaifn:dateField($dataNode, 2, 'date') + 1" />
		<xsl:variable name="day" select="sakaifn:dateField($dataNode, 5, 'date')" />
		<xsl:variable name="fieldId" select="generate-id()" />
		<input type="text" size="10" title="mm/dd/yyyy" name="{$schemaNode/@name}.fullDate" id="{$schemaNode/@name}">
			<xsl:attribute name="value">
				<xsl:if test="$year > -1"><xsl:value-of select="$month" />/<xsl:value-of select="$day" />/<xsl:value-of select="$year" /></xsl:if>
			</xsl:attribute>
		</input>
		<img width="16" height="16" style="cursor:pointer;" border="0" src="/sakai-jsf-resource/inputDate/images/calendar.gif">
			<xsl:attribute name="alt">
				<xsl:value-of select="sakaifn:getMessage('messages', 'date_pick_alt')" />
			</xsl:attribute>
			<xsl:attribute name="onclick">javascript:var cal<xsl:value-of select="$fieldId" /> = new calendar2(document.getElementById('<xsl:value-of select="$schemaNode/@name" />'));cal<xsl:value-of select="$fieldId" />.year_scroll = true;cal<xsl:value-of select="$fieldId" />.time_comp = false;cal<xsl:value-of select="$fieldId" />.popup('','/sakai-jsf-resource/inputDate/')</xsl:attribute>
		</img>
	</xsl:template>
	<xsl:template name="month-option">
		<xsl:param name="selectedMonth" />
		<xsl:param name="month" />
		<xsl:param name="monthName" />
		<option value="{$month}">
			<xsl:if test="$month = $selectedMonth">
				<xsl:attribute name="selected">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="sakaifn:getMessage('messages', $monthName)" />
		</option>
	</xsl:template>
	<xsl:template name="produce-label">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="nodeType" />
		<label for="{@name}">
			<xsl:if test="$nodeType='longtext'">
				<xsl:attribute name="class">block</xsl:attribute>
			</xsl:if>
			<!--output the ospi.descripion as a title in a link (using nicetitle)  -->
			<xsl:choose>
				<xsl:when test="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.description']/text()">
					<a class="nt">
						<xsl:attribute name="title">
							<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.description']" />
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$currentSchemaNode/xs:annotation/xs:documentation[@source='sakai.label']">
								<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='sakai.label']" />
							</xsl:when>
							<xsl:when test="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']">
								<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$currentSchemaNode">
									<xsl:value-of select="@name" />
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$currentSchemaNode/xs:annotation/xs:documentation[@source='sakai.label']">
							<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='sakai.label']" />
						</xsl:when>
						<xsl:when test="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']">
							<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$currentSchemaNode">
								<xsl:value-of select="@name" />
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</label>
	</xsl:template>
	<xsl:template name="produce-metadata">
		<xsl:if test="/formView/formData/artifact/metaData/repositoryNode/created">
			<table class="itemSummary">
				<tr>
					<th> Created </th>
					<td>
						<xsl:value-of select="/formView/formData/artifact/metaData/repositoryNode/created" />
					</td>
				</tr>
				<xsl:if test="/formView/formData/artifact/metaData/repositoryNode/modified">
					<tr>
						<th> Modified </th>
						<td>
							<xsl:value-of select="/formView/formData/artifact/metaData/repositoryNode/modified" />
						</td>
					</tr>
				</xsl:if>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template name="produce-fields">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentNode" />
		<xsl:param name="rootNode" />
		<xsl:for-each select="$currentSchemaNode/children">
			<xsl:apply-templates select="@*|node()">
				<xsl:with-param name="currentParent" select="$currentNode" />
				<xsl:with-param name="rootNode" select="'false'" />
			</xsl:apply-templates>
		</xsl:for-each>
		<xsl:if test="$rootNode='true' and /formView/formData/artifact/metaData">
			<xsl:call-template name="produce-metadata" />
		</xsl:if>
	</xsl:template>
	<xsl:template name="subListRow">
		<xsl:param name="index" />
		<xsl:param name="fieldName" />
		<xsl:param name="dataNode" />
		<tr>
			<td>
				<!--todo:(gsilver) render just the first child element value and hope that it is representative-->
				<xsl:value-of select="$dataNode" />
			</td>
			<td class="itemAction">
				<a>
					<xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of select="$fieldName" />';document.forms[0].editButton.value='Edit';document.forms[0].removeButton.value='';document.forms[0].childIndex.value='<xsl:value-of select="$index" />';document.forms[0].onsubmit();document.forms[0].submit();</xsl:attribute> edit </a> | <a>
					<xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of select="$fieldName" />';document.forms[0].removeButton.value='Remove';document.forms[0].editButton.value='';document.forms[0].childIndex.value='<xsl:value-of select="$index" />';document.forms[0].onsubmit();document.forms[0].submit();</xsl:attribute> remove </a>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
