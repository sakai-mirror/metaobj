<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:sakaifn="org.sakaiproject.metaobj.utils.xml.XsltFunctions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:osp="http://www.osportfolio.org/OspML" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!-- todo: final i18n pass -->
	<xsl:template name="complexElement-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="maxOccurs" select="$currentSchemaNode/@maxOccurs" />
		<xsl:variable name="currentCount" select="count($currentParent/node()[$name=name()])" />
		<xsl:comment>
			<xsl:value-of select="$currentCount" />
		</xsl:comment>
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<xsl:choose>
			<xsl:when test="$currentParent/node()[$name=name()]">
				<table class="listHier lines nolines" cellpadding="0" cellspacing="0" style="width:50%">
					<thead>
						<tr>
							<th scope="col">
								<xsl:call-template name="produce-label">
									<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
								</xsl:call-template>
								<!--
								<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.label']" />
								-->
							</th>
							<th scope="col">
								<div style="float:right">
									<input type="submit" name="addButton" id="{$name}" alignment="center" value="Add New" onClick="this.form.childPath.value='{$name}';return true">
										<xsl:if test="$maxOccurs != -1 and $currentCount >= $maxOccurs">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</input>
								</div>
							</th>
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
				<table class="listHier lines nolines" cellpadding="0" cellspacing="0" style="width:50%">
					<thead>
						<tr>
							<th scope="col">
								<xsl:if test="@minOccurs='1'">
									<span class="reqStar">*</span>
								</xsl:if>
								<xsl:call-template name="produce-label">
									<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
								</xsl:call-template>
							</th>
							<th scope="col">
								<div style="float:right">
									<input type="submit" name="addButton" alignment="center" value="Add New" onClick="this.form.childPath.value='{$name}';return true">
										<xsl:if test="$maxOccurs != -1 and $currentCount >= $maxOccurs">
											<xsl:attribute name="disabled">true</xsl:attribute>
										</xsl:if>
									</input>
								</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td />
							<td />
						</tr>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not(@maxOccurs='1')">
			<div id="{$name}-hidden-fields" class="skipthis">
				<input id="{$name}-count" type="text" value="1" />
				<input id="{$name}-max" type="text" value="{@maxOccurs}" />
			</div>
		</xsl:if>
	</xsl:template>
	<!--produce an input type text element -->
	<xsl:template name="shortText-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<!-- render some explanatory text associated with this input if documentation/@source=ospi.inlinedescription has a text node-->
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div id="{$name}-node">
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">shorttext required</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">shorttext required validFail</xsl:attribute>
					</xsl:if>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">shorttext</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">shorttext validFail</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<input type="text" id="{$name}" name="{$name}" value="{$currentNode}">
				<!--calculate value of maxlength attribute, if absent set to 50, provide a title attribute with this value for the tooltip -->
				<xsl:choose>
					<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value">
						<xsl:attribute name="maxLength">
							<xsl:value-of select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value" />
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value" />
							<xsl:text> </xsl:text>
							<xsl:value-of select="sakaifn:getMessage('messages', 'max_chars')" />
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="maxLength"> 50 </xsl:attribute>
						<xsl:attribute name="title">
							<xsl:text> 50 </xsl:text>
							<xsl:value-of select="sakaifn:getMessage('messages', 'max_chars')" />
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</input>
			<!-- if @maxOccurs is not 1, then it is either a discreet number or unbounded, so add a link that will clone the node in the DOM
                -->
			<xsl:if test="not(@maxOccurs='1')">
				<a href="javascript:addItem('{$name}-node','{$name}');" class="addEl" id="{$name}-addlink">
					<xsl:attribute name="title">
						<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
					</xsl:attribute>
					<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
				</a>
				<div class="instruction" style="display:inline" id="{$name}-disp">
					<xsl:text> </xsl:text>
				</div>
			</xsl:if>
		</div>
		<!-- render hidden fields to aid the cloning -->
		<xsl:if test="not(@maxOccurs='1')">
			<div id="{$name}-hidden-fields" class="skipthis">
				<input id="{$name}-count" type="text" value="1" />
				<input id="{$name}-max" type="text" value="{@maxOccurs}" />
			</div>
		</xsl:if>
	</xsl:template>
	<!-- produce text type input on editing, the operations were so different that a different template seemed required for sanity's sake
		 might collapse both later -->
	<xsl:template name="shortText-field-edit">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:variable name="count" select="count($currentParent//node()[$name=name()])" />
		<xsl:choose>
			<!-- if there are no values for this named element then the user did not fill them out while creating - so call the "create" template then -->
			<xsl:when test="$count='0'">
				<xsl:call-template name="shortText-field">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
					<xsl:with-param name="currentParent" select="$currentParent" />
					<xsl:with-param name="rootNode" select="$rootNode" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- render some inline text if documentation/@source=ospi.inlinedescription -->
				<xsl:call-template name="produce-inline">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<!-- cycle through all the data nodes that have this name, rendering input groups that  can be required, cloned, deleted, have a label, or inlined description -->
		<xsl:for-each select="$currentParent/node()[$name=name()]">
			<div>
				<!-- the id attribute will be used by javascript -->
				<xsl:attribute name="id">
					<xsl:choose>
						<xsl:when test="position()='1'">
							<xsl:value-of select="name()" />-node</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()" />-<xsl:value-of select="position()" />-node</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@minOccurs='1'">
						<xsl:attribute name="class">shorttext required</xsl:attribute>
						<span class="reqStar">*</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">shorttext</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<!-- call template that will produce the label in edit mode -->
				<xsl:call-template name="produce-label-edit">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
					<xsl:with-param name="sep">-</xsl:with-param>
					<xsl:with-param name="num" select="position()" />
				</xsl:call-template>
				<input type="text" name="{$name}" value="{.}">
					<xsl:attribute name="id">
						<xsl:value-of select="name()" />-<xsl:value-of select="position()" />
					</xsl:attribute>
					<!-- same maxlength calculations as previous template -->
					<xsl:choose>
						<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value">
							<xsl:attribute name="maxLength">
								<xsl:value-of select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value" />
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value" />
								<xsl:text> </xsl:text>
								<xsl:value-of select="sakaifn:getMessage('messages', 'max_chars')" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="maxLength"> 50 </xsl:attribute>
							<xsl:attribute name="title">
								<xsl:text>50 </xsl:text>
								<xsl:value-of select="sakaifn:getMessage('messages', 'max_chars')" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
				<xsl:if test="not($currentSchemaNode/@maxOccurs='1')">
					<!-- calculate if this is an original node that can be cloned, an original node that has been cloned up to the max or a cloned node that can be deleted and render the appropriate links -->
					<xsl:choose>
						<xsl:when test="position() = '1'">
							<xsl:choose>
								<xsl:when test="$currentSchemaNode/@maxOccurs=$count">
									<a id="{$name}-addlink" class="addEl-inact">
										<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
									</a>
									<div class="instruction" style="display:inline" id="{$name}-disp">
										<xsl:text> </xsl:text>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<a href="javascript:addItem('{$name}-node','{$name}');" class="addEl" id="{$name}-addlink">
										<xsl:attribute name="title">
											<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
										</xsl:attribute>
										<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
									</a>
									<div class="instruction" style="display:inline" id="{$name}-disp">
										<xsl:text> </xsl:text>
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<a href="javascript:removeItem('{$name}-{position()}-node','{$name}');" class="deleteEl" id="{$name}-addlink">
								<xsl:attribute name="title">
									<xsl:value-of select="sakaifn:getMessage('messages', 'delete_form_element')" />
								</xsl:attribute>
								<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</div>
			<!-- hidden fields (hidden via css only for debugging now) to help in cloning action -->
			<xsl:if test="(not($currentSchemaNode/@maxOccurs='1') and (position()=$currentSchemaNode/@maxOccurs))">
				<div id="{$name}-hidden-fields" class="skipthis">
					<input id="{$name}-count" type="text" value="{$count}" />
					<input id="{$name}-max" type="text" value="{$currentSchemaNode/@maxOccurs}" />
				</div>
			</xsl:if>
			<xsl:if test="$currentSchemaNode/@maxOccurs='-1' and position()=$count">
				<div id="{$name}-hidden-fields" class="skipthis">
					<input id="{$name}-count" type="text" value="{$count}" />
					<input id="{$name}-max" type="text" value="{$currentSchemaNode/@maxOccurs}" />
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- same in most respects as shorttext element except  1) cannot be cloned, 2) cannot be required (there is always a default) - so create and edit templates are one and the same.
		todo: required work
		-->
	<xsl:template name="select-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<!-- this variable in com with maxOccurs' value controls the xhtml expression of this element (radiogroup, checkboxgroup, single select, multiple select) -->
		<xsl:variable name="htmldeterm">4</xsl:variable>
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div id="{$name}-node">
			<xsl:choose>
				<xsl:when test="@maxOccurs='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt;= $htmldeterm">
					<!-- this will resolve as a radio group control -->
					<fieldset class="osp-radcheck">
						<xsl:if test="//formView/errors/error[@field=$name]">
							<xsl:attribute name="class">osp-radcheck validFail</xsl:attribute>
						</xsl:if>
						<legend>
							<xsl:if test="@minOccurs='1'">
								<span class="reqStar">*</span>
							</xsl:if>
							<xsl:call-template name="produce-label">
								<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
							</xsl:call-template>
						</legend>
						<xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
							<div class="checkbox">
								<input id="{$name}-{position()}" name="{$name}" value="{@value}" type="radio">
									<xsl:if test="$currentNode = @value">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="{$name}-{position()}">
									<xsl:value-of select="@value" />
								</label>
							</div>
						</xsl:for-each>
					</fieldset>
				</xsl:when>
				<xsl:when test="@maxOccurs='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &gt; $htmldeterm">
					<!-- this will resolve as a single select control-->
					<xsl:choose>
						<xsl:when test="@minOccurs='1'">
							<xsl:attribute name="class">shorttext required</xsl:attribute>
							<xsl:if test="//formView/errors/error[@field=$name]">
								<xsl:attribute name="class">shorttext required validFail</xsl:attribute>
							</xsl:if>
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
				</xsl:when>
				<xsl:when test="@maxOccurs !='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt;= $htmldeterm">
					<!-- this will resolve as a checkbox group control -->
					<fieldset class="osp-radcheck">
						<xsl:if test="//formView/errors/error[@field=$name]">
							<xsl:attribute name="class">osp-radcheck validFail</xsl:attribute>
						</xsl:if>
						<legend>
							<xsl:if test="@minOccurs='1'">
								<span class="reqStar">*</span>
							</xsl:if>
							<xsl:call-template name="produce-label">
								<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
							</xsl:call-template>
						</legend>
						<xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
							<div class="checkbox">
								<input id="{$name}-{position()}" name="{$name}" value="{@value}" type="checkbox">
									<xsl:if test="$currentNode = @value">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="{$name}-{position()}">
									<xsl:value-of select="@value" />
								</label>
							</div>
						</xsl:for-each>
					</fieldset>
				</xsl:when>
				<xsl:when test="@maxOccurs !='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &gt; $htmldeterm">
					<!-- this will resolve as a multiple select control -->
					<xsl:choose>
						<xsl:when test="@minOccurs='1'">
							<xsl:attribute name="class">shorttext required</xsl:attribute>
							<xsl:if test="//formView/errors/error[@field=$name]">
								<xsl:attribute name="class">shorttext required validFail</xsl:attribute>
							</xsl:if>
							<span class="reqStar">*</span>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">shorttext</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="produce-label">
						<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
					</xsl:call-template>
					<select id="{$name}" name="{$name}" multiple="multiple">
						<xsl:attribute name="size">
							<xsl:choose>
								<!-- some crude calculations to determine the select visible row count -->
								<xsl:when test="count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt; 10">5</xsl:when>
								<xsl:when test="count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt; 20">10</xsl:when>
								<xsl:otherwise>15</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
							<option value="{@value}">
								<xsl:if test="$currentNode = @value">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="@value" />
							</option>
						</xsl:for-each>
					</select>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template name="select-field-edit">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<!-- this variable controls the xhtml expression of this element (ratio, checkbox, single select, multiple select) -->
		<xsl:variable name="htmldeterm">4</xsl:variable>
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div id="{$name}-node">
			<xsl:choose>
				<xsl:when test="@maxOccurs='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt;= $htmldeterm">
					<fieldset class="osp-radcheck">
						<legend>
							<xsl:call-template name="produce-label">
								<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
							</xsl:call-template>
						</legend>
						<xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
							<div class="checkbox">
								<input id="{$name}-{position()}" name="{$name}" value="{@value}" type="radio">
									<xsl:if test="$currentNode = @value">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="{$name}-{position()}">
									<xsl:value-of select="@value" />
								</label>
							</div>
						</xsl:for-each>
					</fieldset>
				</xsl:when>
				<xsl:when test="@maxOccurs='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &gt; $htmldeterm">
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
				</xsl:when>
				<xsl:when test="@maxOccurs !='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt;= $htmldeterm">
					<fieldset class="osp-radcheck">
						<legend>
							<xsl:call-template name="produce-label">
								<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
							</xsl:call-template>
						</legend>
						<xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
							<div class="checkbox">
								<input id="{$name}-{position()}" name="{$name}" value="{@value}" type="checkbox">
									<xsl:if test="$currentNode = @value">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<label for="{$name}-{position()}">
									<xsl:value-of select="@value" />
								</label>
							</div>
						</xsl:for-each>
					</fieldset>
				</xsl:when>
				<xsl:when test="@maxOccurs !='1' and count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &gt; $htmldeterm">
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
					<select id="{$name}" name="{$name}" multiple="multiple">
						<xsl:attribute name="size">
							<xsl:choose>
								<xsl:when test="count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt; 10">5</xsl:when>
								<xsl:when test="count($currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration) &lt; 20">10</xsl:when>
								<xsl:otherwise>15</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:for-each select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:enumeration">
							<option value="{@value}">
								<xsl:if test="$currentNode = @value">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="@value" />
							</option>
						</xsl:for-each>
					</select>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
	<!-- same in most respects as shorttext element except  cannot be cloned -->
	<xsl:template name="richText-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div id="{$name}">
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">longtext required</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">longtext required validFail</xsl:attribute>
					</xsl:if>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">longtext</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">longtext validFail</xsl:attribute>
					</xsl:if>
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
						<xsl:if test="@maxOccurs='-1'">
							<a href="javascript:addItem('{$name}parent');" class="addEl">
								<xsl:attribute name="title">
									<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
								</xsl:attribute>
								<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
							</a>
							<input type="hidden" id="{$name}parenthid" value="0" />
						</xsl:if>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<!-- renders a textarea, similar in most respects to the shorttext element, except where noted below in comments -->
	<xsl:template name="longText-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="thisname" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div id="{$name}-node">
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">longtext required</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">longtext required validFail</xsl:attribute>
					</xsl:if>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">longtext</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">longtext validFail</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<!-- passing a nodeType param to the label producing template creates a label with the css class "block" so that it renders label and textarea in 2 separate lines -->
			<xsl:call-template name="produce-label">
				<xsl:with-param name="nodeType">longtext</xsl:with-param>
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<!-- maxlength expressed as a title attribute as in shorttext, no default maxlength, however, and some rough calculations for rendered sized of the textarea based on the maxLength value -->
			<textarea id="{$name}" name="{$name}">
				<xsl:if test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value">
					<xsl:attribute name="title">
						<xsl:value-of select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="sakaifn:getMessage('messages', 'max_chars')" />
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &lt; 600">
							<xsl:attribute name="rows">3</xsl:attribute>
							<xsl:attribute name="cols">45</xsl:attribute>
						</xsl:when>
						<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &lt; 800">
							<xsl:attribute name="rows">5</xsl:attribute>
							<xsl:attribute name="cols">45</xsl:attribute>
						</xsl:when>
						<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &lt; 1000">
							<xsl:attribute name="rows">7</xsl:attribute>
							<xsl:attribute name="cols">45</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="rows">9</xsl:attribute>
							<xsl:attribute name="cols">45</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="string($currentNode) = ''" />
					<xsl:otherwise>
						<xsl:value-of select="$currentNode" disable-output-escaping="yes" />
					</xsl:otherwise>
				</xsl:choose>
			</textarea>
			<xsl:if test="not(@maxOccurs='1')">
				<a href="javascript:addItem('{$name}-node','{$name}');" class="addEl" id="{$name}-addlink">
					<xsl:attribute name="title">
						<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
					</xsl:attribute>
					<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
				</a>
				<div class="instruction" style="display:inline" id="{$name}-disp">
					<xsl:text> </xsl:text>
				</div>
			</xsl:if>
		</div>
		<xsl:if test="not(@maxOccurs='1')">
			<div id="{$name}-hidden-fields" class="skipthis">
				<input id="{$name}-count" type="text" value="1" />
				<input id="{$name}-max" type="text" value="{@maxOccurs}" />
			</div>
		</xsl:if>
	</xsl:template>
	<!-- same considerations as in the shorttext edit template -->
	<xsl:template name="longText-field-edit">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:variable name="count" select="count($currentParent//node()[$name=name()])" />
		<xsl:choose>
			<xsl:when test="$count='0'">
				<xsl:call-template name="longText-field">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
					<xsl:with-param name="currentParent" select="$currentParent" />
					<xsl:with-param name="rootNode" select="$rootNode" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="produce-inline">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:for-each select="$currentParent/node()[$name=name()]">
			<div>
				<xsl:attribute name="id">
					<xsl:choose>
						<xsl:when test="position()='1'">
							<xsl:value-of select="name()" />-node</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()" />-<xsl:value-of select="position()" />-node</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@minOccurs='1'">
						<xsl:attribute name="class">longtext required</xsl:attribute>
						<span class="reqStar">*</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">longtext</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="produce-label-edit">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
					<xsl:with-param name="sep">-</xsl:with-param>
					<xsl:with-param name="nodeType">longtext</xsl:with-param>
					<xsl:with-param name="num" select="position()" />
				</xsl:call-template>
				<textarea name="{$name}">
					<xsl:attribute name="id">
						<xsl:value-of select="name()" />-<xsl:value-of select="position()" />
					</xsl:attribute>
					<xsl:if test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value">
						<xsl:attribute name="title">
							<xsl:value-of select="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value" />
							<xsl:text> </xsl:text>
							<xsl:value-of select="sakaifn:getMessage('messages', 'max_chars')" />
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &lt; 600">
								<xsl:attribute name="rows">3</xsl:attribute>
								<xsl:attribute name="cols">45</xsl:attribute>
							</xsl:when>
							<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &lt; 800">
								<xsl:attribute name="rows">5</xsl:attribute>
								<xsl:attribute name="cols">45</xsl:attribute>
							</xsl:when>
							<xsl:when test="$currentSchemaNode/xs:simpleType/xs:restriction[@base='xs:string']/xs:maxLength/@value &lt; 1000">
								<xsl:attribute name="rows">7</xsl:attribute>
								<xsl:attribute name="cols">45</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="rows">9</xsl:attribute>
								<xsl:attribute name="cols">45</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="string($currentNode) = ''" />
						<xsl:otherwise>
							<xsl:value-of select="." disable-output-escaping="yes" />
						</xsl:otherwise>
					</xsl:choose>
				</textarea>
				<xsl:if test="not($currentSchemaNode/@maxOccurs='1')">
					<xsl:choose>
						<xsl:when test="position() = '1'">
							<xsl:choose>
								<xsl:when test="$currentSchemaNode/@maxOccurs=$count">
									<a id="{$name}-addlink" class="addEl-inact">
										<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
									</a>
									<div class="instruction" style="display:inline" id="{$name}-disp">
										<xsl:text> </xsl:text>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<a href="javascript:addItem('{$name}-node','{$name}');" class="addEl" id="{$name}-addlink">
										<xsl:attribute name="title">
											<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
										</xsl:attribute>
										<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
									</a>
									<div class="instruction" style="display:inline" id="{$name}-disp">
										<xsl:text> </xsl:text>
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<a href="javascript:removeItem('{$name}-{position()}-node','{$name}');" class="deleteEl" id="{$name}-addlink">
								<xsl:attribute name="title">
									<xsl:value-of select="sakaifn:getMessage('messages', 'delete_form_element')" />
								</xsl:attribute>
								<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</div>
			<!-- need to test here if this is the first node of the bunch -->
			<xsl:if test="(not($currentSchemaNode/@maxOccurs='1') and (position()=$currentSchemaNode/@maxOccurs))">
				<div id="{$name}-hidden-fields" class="skipthis">
					<input id="{$name}-count" type="text" value="{$count}" />
					<input id="{$name}-max" type="text" value="{$currentSchemaNode/@maxOccurs}" />
				</div>
			</xsl:if>
			<xsl:if test="$currentSchemaNode/@maxOccurs='-1' and position()=$count">
				<div id="{$name}-hidden-fields" class="skipthis">
					<input id="{$name}-count" type="text" value="{$count}" />
					<input id="{$name}-max" type="text" value="{$currentSchemaNode/@maxOccurs}" />
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="checkBox-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div class="checkbox indnt1" id="{$name}parent">
			<xsl:if test="@minOccurs='1'">
				<xsl:attribute name="class">checkbox required indnt1</xsl:attribute>
				<xsl:if test="//formView/errors/error[@field=$name]">
					<xsl:attribute name="class">checkbox required indnt1 validFail</xsl:attribute>
				</xsl:if>
				<span class="reqStar">*</span>
			</xsl:if>
			<xsl:call-template name="checkbox-widget">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="currentNode" select="$currentNode" />
			</xsl:call-template>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<xsl:if test="@maxOccurs='-1'">
				<a href="javascript:addItem('{$name}parent');" class="addEl">
					<xsl:attribute name="title">
						<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
					</xsl:attribute>
					<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
				</a>
				<input type="hidden" id="{$name}parenthid" value="0" />
			</xsl:if>
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
	<!-- simple template, maxOccurs happens as a parameter used by the filepicker helper application -->
	<xsl:template name="fileHelper-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div>
			<div class="shorttext" id="{$name}parent">
				<xsl:if test="@minOccurs='1'">
					<xsl:attribute name="class">shorttext required</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">shorttext required validFail</xsl:attribute>
					</xsl:if>
					<span class="reqStar">*</span>
				</xsl:if>
				<xsl:call-template name="produce-label">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
				</xsl:call-template>
				<input id="{$name}" type="button" onclick="javascript:document.forms[0].childPath.value='{$name}';document.forms[0].fileHelper.value='true';document.forms[0].onsubmit();document.forms[0].submit();" title="sakaifn:getMessage('messages', 'manage_attachments_title')" value="sakaifn:getMessage('messages', 'manage_attachments')">
					<!--TODO: need to set the onclick attribute to pass a parameter to the filepicker allowing more files to be added or not after limit is reached 
					- and how many files can be added total (the filepicker understands this parameter)
					
					paremeter can  be set when invoking the FilePicker by defining an attribute in
					tool-session as described in the javadocs for FilePickerHelper.
					FILE_PICKER_MAX_ATTACHMENTS :
					
					http://source.sakaiproject.org/release/2.3.0/javadoc/org/sakaiproject/
					content/api/FilePickerHelper.html#FILE_PICKER_MAX_ATTACHMENTS
					
					- the parameter would be the initial maxOccurs on first use, or (maxOccurs -  count($currentParent/node()[$name=name()])  if count < maxOccurs)
				-->
					<xsl:attribute name="title">
						<xsl:value-of select="sakaifn:getMessage('messages', 'manage_attachments_title')" />
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="sakaifn:getMessage('messages', 'manage_attachments')" />
					</xsl:attribute>
				</input>
				<!-- if there are attachments already, render these as a list, more ui refinement needed -->
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
		</div>
		<!-- todo: remove this test if not needed -->
		<xsl:if test="not(@maxOccurs='1')">
			<div id="{$name}-hidden-fields" class="skipthis">
				<input id="{$name}-count" type="text" value="1" />
				<input id="{$name}-max" type="text" value="{@maxOccurs}" />
			</div>
		</xsl:if>
	</xsl:template>
	<!-- similar to shorttext except as noted -->
	<xsl:template name="date-field">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:call-template name="produce-inline">
			<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
		</xsl:call-template>
		<div class="shorttext" id="{$name}-node">
			<xsl:choose>
				<xsl:when test="@minOccurs='1'">
					<xsl:attribute name="class">shorttext required</xsl:attribute>
					<xsl:if test="//formView/errors/error[@field=$name]">
						<xsl:attribute name="class">shorttext required validFail</xsl:attribute>
					</xsl:if>
					<span class="reqStar">*</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">shorttext</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="produce-label">
				<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
			</xsl:call-template>
			<!-- calls a template that will produce a link to the calendar popup -->
			<xsl:call-template name="calendar-widget">
				<xsl:with-param name="schemaNode" select="$currentSchemaNode" />
				<xsl:with-param name="dataNode" select="$currentNode" />
			</xsl:call-template>
			<!-- if it can be cloned, render a link to do so -->
			<xsl:if test="not(@maxOccurs='1')">
				<a href="javascript:addItem('{$name}-node','{$name}');" class="addEl" id="{$name}-addlink">
					<xsl:attribute name="title">
						<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
					</xsl:attribute>
					<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
				</a>
				<div class="instruction" style="display:inline" id="{$name}-disp">
					<xsl:text> </xsl:text>
				</div>
			</xsl:if>
		</div>
		<xsl:if test="not(@maxOccurs='1')">
			<div id="{$name}-hidden-fields" class="skipthis">
				<input id="{$name}-count" type="text" value="1" />
				<input id="{$name}-max" type="text" value="{@maxOccurs}" />
			</div>
		</xsl:if>
	</xsl:template>
	<!-- as with the shorttext and longtext templates, the edit mode was different enough that it gets its own template -->
	<xsl:template name="date-field-edit">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="currentParent" />
		<xsl:param name="rootNode" />
		<xsl:variable name="name" select="$currentSchemaNode/@name" />
		<xsl:variable name="currentNode" select="$currentParent/node()[$name=name()]" />
		<xsl:variable name="count" select="count($currentParent//node()[$name=name()])" />
		<xsl:choose>
			<!-- this element was not filled out on create, so does not exist in the data, so call original create template -->
			<xsl:when test="$count='0'">
				<xsl:call-template name="date-field">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
					<xsl:with-param name="currentParent" select="$currentParent" />
					<xsl:with-param name="rootNode" select="$rootNode" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="produce-inline">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<!--calendar popup needs a unique id to call it - create the unique id here and used it with increments for each element in this cloned collection -->
		<xsl:variable name="fieldId" select="generate-id()" />
		<xsl:for-each select="$currentParent/node()[$name=name()]">
			<div>
				<xsl:attribute name="id">
					<xsl:choose>
						<xsl:when test="position()='1'">
							<xsl:value-of select="name()" />-node</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()" />-<xsl:value-of select="position()" />-node</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@minOccurs='1'">
						<xsl:attribute name="class">shorttext required</xsl:attribute>
						<span class="reqStar">*</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">shorttext</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="produce-label-edit">
					<xsl:with-param name="currentSchemaNode" select="$currentSchemaNode" />
					<xsl:with-param name="sep">-</xsl:with-param>
					<xsl:with-param name="num" select="position()" />
				</xsl:call-template>
				<!-- as with the create version of this template - call a template that will render the click link for the calendar popup. Complications: need to pass the value, the number in the clone sequence, as well as the unique id -->
				<xsl:call-template name="calendar-widget-edit">
					<xsl:with-param name="schemaNode" select="$currentSchemaNode" />
					<xsl:with-param name="dataNode" select="$currentNode" />
					<xsl:with-param name="val" select="." />
					<xsl:with-param name="num" select="position()" />
					<xsl:with-param name="fieldIdclone" select="$fieldId" />
				</xsl:call-template>
				<!-- same as in shorttext, should really templatize this -->
				<xsl:if test="not($currentSchemaNode/@maxOccurs='1')">
					<xsl:choose>
						<xsl:when test="position() = '1'">
							<xsl:choose>
								<xsl:when test="$currentSchemaNode/@maxOccurs=$count">
									<a id="{$name}-addlink" class="addEl-inact">
										<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
									</a>
									<div class="instruction" style="display:inline" id="{$name}-disp">
										<xsl:text> </xsl:text>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<a href="javascript:addItem('{$name}-node','{$name}');" class="addEl" id="{$name}-addlink">
										<xsl:attribute name="title">
											<xsl:value-of select="sakaifn:getMessage('messages', 'add_form_element')" />
										</xsl:attribute>
										<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
									</a>
									<div class="instruction" style="display:inline" id="{$name}-disp">
										<xsl:text> </xsl:text>
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<a href="javascript:removeItem('{$name}-{position()}-node','{$name}');" class="deleteEl" id="{$name}-addlink">
								<xsl:attribute name="title">
									<xsl:value-of select="sakaifn:getMessage('messages', 'delete_form_element')" />
								</xsl:attribute>
								<img src="/sakai-metaobj-tool/img/blank.gif" alt="" />
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</div>
			<xsl:if test="(not($currentSchemaNode/@maxOccurs='1') and (position()=$currentSchemaNode/@maxOccurs))">
				<div id="{$name}-hidden-fields" class="skipthis">
					<input id="{$name}-count" type="text" value="{$count}" />
					<input id="{$name}-max" type="text" value="{$currentSchemaNode/@maxOccurs}" />
				</div>
			</xsl:if>
			<xsl:if test="$currentSchemaNode/@maxOccurs='-1' and position()=$count">
				<div id="{$name}-hidden-fields" class="skipthis">
					<input id="{$name}-count" type="text" value="{$count}" />
					<input id="{$name}-max" type="text" value="{$currentSchemaNode/@maxOccurs}" />
				</div>
			</xsl:if>
		</xsl:for-each>
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
		<!-- hidden field to hold the value of the unique id the calendar needs, and use it by increment to call the calendar in the context of any cloned nodes -->
		<input type="hidden" value="{$fieldId}" id="{$schemaNode/@name}-dateWId" />
		<!-- since there are two links to the right of the input  put some space between them to avoid confusion -->
		<xsl:text>&#xa0;</xsl:text>
		<img width="16" height="16" style="cursor:pointer;" border="0" src="/sakai-jsf-resource/inputDate/images/calendar.gif">
			<xsl:attribute name="alt">
				<xsl:value-of select="sakaifn:getMessage('messages', 'date_pick_alt')" />
			</xsl:attribute>
			<xsl:attribute name="onclick">javascript:var cal<xsl:value-of select="$fieldId" /> = new calendar2(document.getElementById('<xsl:value-of select="$schemaNode/@name" />'));cal<xsl:value-of select="$fieldId" />.year_scroll = true;cal<xsl:value-of select="$fieldId" />.time_comp = false;cal<xsl:value-of select="$fieldId" />.popup('','/sakai-jsf-resource/inputDate/')</xsl:attribute>
		</img>
		<!-- since there are two links to the right of the input  put some space between them to avoid confusion -->
		<xsl:text>&#xa0;&#xa0;</xsl:text>
	</xsl:template>
	<xsl:template name="calendar-widget-edit">
		<xsl:param name="schemaNode" />
		<xsl:param name="dataNode" />
		<xsl:param name="num" />
		<xsl:param name="val" />
		<xsl:param name="fieldIdclone" />
		<xsl:variable name="year" select="sakaifn:dateField($dataNode, 1, 'date')" />
		<xsl:variable name="currentYear" select="sakaifn:dateField(sakaifn:currentDate(), 1, 'date')" />
		<xsl:variable name="month" select="sakaifn:dateField($dataNode, 2, 'date') + 1" />
		<xsl:variable name="day" select="sakaifn:dateField($dataNode, 5, 'date')" />
		<input type="text" size="10" title="mm/dd/yyyy" name="{$schemaNode/@name}.fullDate">
			<xsl:attribute name="id">
				<xsl:value-of select="$schemaNode/@name" />
				<xsl:value-of select="position()" />
			</xsl:attribute>
			<xsl:attribute name="value">
				<!-- TODO: this one does not work for editing so call template instead  for now till better thing done-->
				<!-- <xsl:if test="$year > -1"><xsl:value-of select="$month" />/<xsl:value-of select="$day" />/<xsl:value-of select="$year" /></xsl:if> -->
				<xsl:call-template name="dateformat">
					<xsl:with-param name="date" select="$val" />
					<xsl:with-param name="format">mm/dd/yy</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</input>
		<input type="hidden" value="" id="{$schemaNode/@name}-dateWId" />
		<xsl:text>&#xa0;</xsl:text>
		<img width="16" height="16" style="cursor:pointer;" border="0" src="/sakai-jsf-resource/inputDate/images/calendar.gif">
			<xsl:attribute name="alt">
				<xsl:value-of select="sakaifn:getMessage('messages', 'date_pick_alt')" />
			</xsl:attribute>
			<xsl:attribute name="onclick">javascript:var cal<xsl:value-of select="$fieldIdclone" /><xsl:value-of select="$num" /> = new calendar2(document.getElementById('<xsl:value-of select="$schemaNode/@name" /><xsl:value-of select="$num" />'));cal<xsl:value-of select="$fieldIdclone" /><xsl:value-of select="$num" />.year_scroll = true;cal<xsl:value-of select="$fieldIdclone" /><xsl:value-of select="$num" />.time_comp = false;cal<xsl:value-of select="$fieldIdclone" /><xsl:value-of select="$num" />.popup('','/sakai-jsf-resource/inputDate/')</xsl:attribute>
		</img>
		<xsl:text>&#xa0;&#xa0;</xsl:text>
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
		<xsl:param name="sep" />
		<xsl:param name="num" />
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
	<xsl:template name="produce-label-edit">
		<xsl:param name="currentSchemaNode" />
		<xsl:param name="nodeType" />
		<xsl:param name="sep" />
		<xsl:param name="num" />
		<label for="{$currentSchemaNode/@name}{$sep}{$num}">
			<xsl:if test="$nodeType='longtext'">
				<xsl:attribute name="class">block</xsl:attribute>
			</xsl:if>
			<!--output the ospi.descripion as a title in a link (using nicetitle)  -->
			<xsl:choose>
				<xsl:when test="($currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.description']/text() and $num='1')">
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
	<!--output the documentation/@source=ospi.inlinedescripion as text block *above* the element -->
	<xsl:template name="produce-inline">
		<xsl:param name="currentSchemaNode" />
		<xsl:if test="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.inlinedescription']/text()">
			<p class="instruction clear highlightPanel">
				<xsl:value-of select="$currentSchemaNode/xs:annotation/xs:documentation[@source='ospi.inlinedescription']" />
			</p>
		</xsl:if>
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
	<!-- for each subform filled out render a row in the table opened in complexElementField -->
	<xsl:template name="subListRow">
		<xsl:param name="index" />
		<xsl:param name="fieldName" />
		<xsl:param name="dataNode" />
		<tr>
			<td>
				<!--todo:for now render just the first child element value and hope that it is representative
					do this as a text for the value in the schema of a <xs:documentation source="ospi.key">nodename</xs:documentation>
					if it exists, retrieve that from the data, otherwise  just the first one
				-->
				<xsl:value-of select="$dataNode/*[1]" />
			</td>
			<td class="itemAction">
				<a>
					<xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of select="$fieldName" />';document.forms[0].editButton.value='Edit';document.forms[0].removeButton.value='';document.forms[0].childIndex.value='<xsl:value-of select="$index" />';document.forms[0].onsubmit();document.forms[0].submit();</xsl:attribute> edit </a> | <a>
					<xsl:attribute name="href">javascript:document.forms[0].childPath.value='<xsl:value-of select="$fieldName" />';document.forms[0].removeButton.value='Remove';document.forms[0].editButton.value='';document.forms[0].childIndex.value='<xsl:value-of select="$index" />';document.forms[0].onsubmit();document.forms[0].submit();</xsl:attribute> remove </a>
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
</xsl:stylesheet>
