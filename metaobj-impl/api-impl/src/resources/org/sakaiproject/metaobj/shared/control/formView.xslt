<?xml version="1.0" encoding="utf-8"?>
<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ~ $URL: https://source.sakaiproject.org/svn/metaobj/trunk/metaobj-util/tool-lib/src/java/org/sakaiproject/metaobj/shared/control/AbstractStructuredArtifactDefinitionController.java $
  ~ $Id: AbstractStructuredArtifactDefinitionController.java 14230 2006-09-05 18:02:51Z chmaurer@iupui.edu $
  ~ **********************************************************************************
  ~
  ~  Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
  ~
  ~  Licensed under the Educational Community License, Version 1.0 (the "License");
  ~  you may not use this file except in compliance with the License.
  ~  You may obtain a copy of the License at
  ~
  ~       http://www.opensource.org/licenses/ecl1.php
  ~
  ~  Unless required by applicable law or agreed to in writing, software
  ~  distributed under the License is distributed on an "AS IS" BASIS,
  ~  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~  See the License for the specific language governing permissions and
  ~  limitations under the License.
  ~
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:osp="http://www.osportfolio.org/OspML" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sakaifn="org.sakaiproject.metaobj.utils.xml.XsltFunctions">
	<!--xsl:template match="formView">
      <formView>
            <xsl:copy-of select="*"></xsl:copy-of>
      </formView>
   </xsl:template-->
	<xsl:template match="formView">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<meta http-equiv="Content-Style-Type" content="text/css" />
				<title>
					<xsl:value-of select="formData/artifact/metaData/displayName" />
				</title>
				<script type="text/javascript" language="JavaScript" src="/library/js/headscripts.js"> // empty
					block </script>
				<xsl:for-each select="css/uri">
					<link type="text/css" rel="stylesheet" media="all">
						<xsl:attribute name="href">
							<xsl:value-of select="." />
						</xsl:attribute>
					</link>
				</xsl:for-each>
			</head>
			<body>
				<!-- todo: need to load js programatically - where are forms used? below will work if headscrips.js is linked to and the form is inside an iframe -->
				<!-- <xsl:attribute name="onload">if(window.frameElement) setMainFrameHeight(window.frameElement.id);</xsl:attribute> -->
				<div class="portletBody">
					<h3>
						<xsl:value-of select="formData/artifact/metaData/displayName" />
					</h3>
					<p class="instruction">
						<xsl:value-of disable-output-escaping="yes" select="formData/artifact/schema/instructions" />
					</p>
					<xsl:apply-templates select="formData/artifact/schema/element">
						<xsl:with-param name="currentParent" select="formData/artifact/structuredData" />
						<xsl:with-param name="rootNode" select="'true'" />
					</xsl:apply-templates>
					<xsl:if test="returnUrl">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="returnUrl" />
							</xsl:attribute> Back </a>
					</xsl:if>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="element">
		<xsl:param name="currentParent" />
		<xsl:param name="nodetype" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:choose>
			<xsl:when test="children">
				<xsl:if test="$rootNode = 'true'">
					<xsl:call-template name="produce-fields">
						<xsl:with-param name="currentSchemaNode" select="." />
						<xsl:with-param name="currentNode" select="$currentNode" />
						<xsl:with-param name="rootNode" select="$rootNode" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$rootNode='false'">
					<!-- we have a subform datanode at hand -->
					<tr>
						<th colspan="2">
							<xsl:call-template name="produce-label">
								<xsl:with-param name="currentSchemaNode" select="." />
							</xsl:call-template>
							<xsl:if test="count($currentParent//node()[$name=name()]) > 1">
								<span class="textPanelFooter"> (<xsl:value-of select="count($currentParent//node()[$name=name()])" /> items)</span>
							</xsl:if>
						</th>
					</tr>
					<tr>
						<td colspan="2">
							<div class="indnt1">
								<xsl:call-template name="produce-fields-subform">
									<xsl:with-param name="currentSchemaNode" select="." />
									<xsl:with-param name="currentNode" select="$currentNode" />
									<xsl:with-param name="rootNode" select="$rootNode" />
								</xsl:call-template>
							</div>
						</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- just an element -->
				<xsl:variable name="count" select="count($currentParent//node()[$name=name()])" />
				<xsl:variable name="elementtype">
					<!-- find out element type -->
					<xsl:choose>
						<xsl:when test="xs:simpleType/xs:restriction/@base='xs:boolean'">boolean</xsl:when>
						<xsl:when test="xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &lt; 109">shorttext</xsl:when>
						<xsl:when test="xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &gt;= 109">
							<xsl:choose>
								<xsl:when test="xs:annotation/xs:documentation[@source='ospi.isRichText']='true'">richtext</xsl:when>
								<xsl:otherwise>longtext</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="xs:simpleType/xs:restriction/@base='xs:date'">date</xsl:when>
						<xsl:when test="xs:simpleType/xs:restriction/@base='xs:anyURI'">file</xsl:when>
						<xsl:when test="xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">select</xsl:when>
						<xsl:otherwise>? </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$elementtype='longtext' or $elementtype='richtext'">
						<!-- element data could be large - put it label and content in the same column -->
						<tr>
							<td colspan="2">
								<h4><xsl:value-of select="$elementtype" /> - <xsl:call-template name="produce-label">
										<xsl:with-param name="currentSchemaNode" select="." />
									</xsl:call-template>
									<xsl:if test="$count !=1">
										<!--18-->
										<span class="textPanelFooter"> (<xsl:value-of select="$count" /> items)</span>
									</xsl:if>
								</h4>
								<xsl:for-each select="$currentParent/node()[$name=name()]">
									<div class="textPanel" style="margin-top:0">
										<xsl:choose>
											<xsl:when test="$elementtype='richtext'">
												<xsl:value-of disable-output-escaping="yes" select="$currentNode" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$currentNode" />
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<!-- a 2 column display -->
						<tr>
							<th style="white-space: nowrap">
								<xsl:call-template name="produce-label">
									<xsl:with-param name="currentSchemaNode" select="." />
								</xsl:call-template>
								<xsl:if test="$count !=1">
									<!-- if more than one element clone, tell user how many -->
									<!-- todo: i18N -->
									<div class="textPanelFooter">(<xsl:value-of select="$count" /> items)</div>
								</xsl:if>
							</th>
							<td>
								<xsl:choose>
									<xsl:when test="$elementtype='file'">
										<ul class="attachList" style="margin:0">
											<xsl:for-each select="$currentParent/node()[$name=name()]">
												<li>
													<img src="/library/image/sakai/attachments.gif" />
													<xsl:text> </xsl:text>
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="sakaifn:getReferenceUrl(.)" />
														</xsl:attribute>
														<xsl:value-of select="sakaifn:getReferenceName(.)" />
													</a>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:when test="$elementtype='date'">
										<xsl:for-each select="$currentParent/node()[$name=name()]">
											<div class="textPanel" style="margin-top:0">
												<xsl:call-template name="dateformat">
													<xsl:with-param name="date" select="." />
													<xsl:with-param name="format">mm/dd/yy</xsl:with-param>
												</xsl:call-template>
											</div>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="$elementtype='select'">
										<!-- output all choices and selection? -->
										<!--<ul class="textPanel" style="margin-top:0">
											<xsl:for-each select="xs:simpleType/xs:restriction/xs:enumeration">
												<li >
													<xsl:choose>
														<xsl:when test="@value=$currentParent/node()[$name=name()]">
															<img src="/library/image/sakai/checkon.gif" />
															<xsl:value-of select="@value" />
														</xsl:when>
														<xsl:otherwise>
															<img src="/library/image/sakai/checkoff.gif" />
															<xsl:value-of select="@value" />
														</xsl:otherwise>
													</xsl:choose>. </li>
											</xsl:for-each>
										</ul>
											-->
										<!--output just the selection -->
										<xsl:for-each select="$currentParent/node()[$name=name()]">
											<div class="textPanel" style="margin-top:0">
												<xsl:value-of select="." />
											</div>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="$elementtype='boolean'">
										<!-- need to test to see if ='true' and if so, render the check image, but cannot seem to save a boolean value -->
										<img src="/library/image/sakai/checkon.gif" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="$currentParent/node()[$name=name()]">
											<div class="textPanel" style="margin-top:0">
												<xsl:value-of select="." />
											</div>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="produce-label">
		<xsl:param name="currentSchemaNode" />
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
	</xsl:template>
	<xsl:template name="produce-fields">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentNode" />
		<xsl:param name="rootNode" />
		<table class="itemSummary">
			<xsl:for-each select="$currentSchemaNode/children">
				<xsl:apply-templates select="@*|node()">
					<xsl:with-param name="currentParent" select="$currentNode" />
					<xsl:with-param name="rootNode" select="'false'" />
					<xsl:with-param name="nodetype">
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
			<xsl:if test="$rootNode='true'">
				<xsl:call-template name="produce-metadata" />
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template name="produce-metadata">
		<tr class="textPanelFooter">
			<th> Created </th>
			<td>
				<xsl:value-of select="/formView/formData/artifact/metaData/repositoryNode/created" />
			</td>
		</tr>
		<tr class="textPanelFooter">
			<th> Modified </th>
			<td>
				<xsl:value-of select="/formView/formData/artifact/metaData/repositoryNode/modified" />
			</td>
		</tr>
	</xsl:template>
	<!-- a crutch - since the date in datefields comes in on edit in a specific format, massage it here to render in any format. This template called with a "format" parameter which is not used but could be -->
	<xsl:template name="dateformat">
		<xsl:param name="date" />
		<xsl:param name="format" />
		<xsl:variable name="year" select="substring-before($date,'-')" />
		<xsl:variable name="rest" select="substring-after($date,'-')" />
		<xsl:variable name="month" select="substring-before($rest,'-')" />
		<xsl:variable name="day" select="substring-after($rest,'-')" />
		<xsl:value-of select="$month" />/<xsl:value-of select="$day" />/<xsl:value-of select="$year" />
	</xsl:template>
	<xsl:template name="produce-fields-subform">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentNode" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<!-- need to probe - figure if there are longtext, or richtext nodes or even subforms - if so, produce a vertically stacked collection - bellow for small stuff -->
		<!-- 5 shortext nodes - make it horizontal -->
		<!-- more than 5 or mixed long, short - stack them up -->
		<!-- or do so per node - probe schema -->
		<table border="0" cellpadding="0" cellspacing="0">
			<!-- rows mode -->
			<!--			
			<xsl:attribute name="class">listHier lines nolines textPanelFooter</xsl:attribute>
			<xsl:attribute name="style">margin:.5em</xsl:attribute>
			<xsl:for-each select="$currentNode">
				<xsl:if test="position() =1">
					<tr>
						<th />
						<xsl:for-each select="$currentSchemaNode/children/element">
							<xsl:sort select="@name" />
							<th>
								<xsl:value-of select="xs:annotation/xs:documentation[@source='ospi.label']" />
							</th>
						</xsl:for-each>
					</tr>
				</xsl:if>
				<tr>
					<td>
						<xsl:value-of select="position()" />
					</td>
					<xsl:for-each select="*">
						<xsl:sort select="name()" />
						<td>
							<xsl:value-of select="." />
						</td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
			-->
			<!-- columns mode -->
			<xsl:attribute name="class">itemSummary textPanelFooter</xsl:attribute>
			<xsl:for-each select="$currentNode">
				<xsl:for-each select="*">
					<xsl:if test="$currentSchemaNode/children/element/@name=name()">
						<tr>
							<th>
								<xsl:variable name="nameholder" select="name()" />
								<xsl:value-of select="$currentSchemaNode/children/element[@name=$nameholder]/xs:annotation/xs:documentation[@source='ospi.label']" />
							</th>
							<td>
								<xsl:value-of select="." />
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
				<tr>
					<td />
					<td />
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
