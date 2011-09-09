<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<jsp:useBean id="msgs" class="org.sakaiproject.util.ResourceLoader" scope="request">
   <jsp:setProperty name="msgs" property="baseName" value="messages"/>
</jsp:useBean>
<c:if test="${empty bean.id}">
<form method="POST" action="addStructuredArtifactDefinition.osp">
</c:if>

<c:if test="${!empty bean.id}">
<form method="POST" action="editStructuredArtifactDefinition.osp">
</c:if>
<osp:form/>

<spring:bind path="bean.id">
<input type="hidden" name="<c:out value="${status.expression}"/>" id="<c:out value="${status.expression}"/>" value="<c:out value="${status.value}"/>" />
</spring:bind>


<c:if test="${empty bean.id}">
<h3>
<c:out value="${msgs.title_addForm}"/>
</h3>
<p class="instruction">
<c:out value="${msgs.instructions_selectXSD}"/>
</p>
<p class="instruction">
<c:out value="${msgs.instructions_requiredItems}"/>
</p>
</c:if>
<c:if test="${!empty bean.id}">
<h3>
<c:out value="${msgs.title_editForm}"/>
</h3>
<p class="instruction">
<c:out value="${msgs.instructions_pleaseEdit}"/>
</p>
<p class="instruction">
<c:out value="${msgs.instructions_requiredItems}"/>
</p>
</c:if>


<spring:hasBindErrors name="bean">
	  <div class="validation"><c:out value="${msgs.error_submission}"/></div>
</spring:hasBindErrors>


<p class="shorttext">
<spring:bind path="bean.description">
<span class="reqStar">*</span><label for="<c:out value="${status.expression}"/>-id"><c:out value="${msgs.label_name}"/></label>
<input type="text" name="<c:out value="${status.expression}"/>" id="<c:out value="${status.expression}"/>-id"  value="<c:out value="${status.value}"/>"/>
<c:if test="${status.errorMessage != ''}">
<span class="alertMessage">
	<c:out value="${status.errorMessage}"/>
</span>
</c:if>
</spring:bind>
</p>

<p class="shorttext">
<c:if test="${empty bean.id}"><span class="reqStar">*</span></c:if>
<label for=""><c:out value="${msgs.label_schemaFile}"/></label>
<spring:bind path="bean.schemaFileName">
<input type="text" id="<c:out value="${status.expression}"/>" name="<c:out value="${status.expression}"/>"
      disabled="true" value="<c:out value="${status.value}" />" />
</spring:bind>
<spring:bind path="bean.schemaFile">
<input type="hidden" name="<c:out value="${status.expression}"/>" id="<c:out value="${status.expression}"/>"
      value="<c:out value="${status.value}"/>" />
<a href="#"
   onclick="document.forms[0]['filePickerAction'].value='pickSchema';
      document.forms[0]['filePickerFrom'].value='<spring:message
         code="filePickerMessage.pickSchema" />';
      document.forms[0].submit();return false;">
<c:out value="${msgs.text_selectXSD}"/></a>

<c:if test="${status.errorMessage != ''}">
<span class="alertMessage">
	<c:out value="${status.errorMessage}"/>
</span>
</c:if>
</spring:bind>
</p>

<p class="shorttext">
<spring:bind path="bean.documentRoot">
<label for="<c:out value="${status.expression}" />"><c:out value="${msgs.label_documentRoot}"/></label>
<select name="<c:out value="${status.expression}" />" id="<c:out value="${status.expression}" />">
<c:forEach var="element" items="${elements}" varStatus="status">
<option value="<c:out value="${element}"/>"><c:out value="${element}"/></option>
</c:forEach>
</select>
</spring:bind>
</p>

<p class="longtext">
<spring:bind path="bean.instruction">
<label class="block"><c:out value="${msgs.label_Instructions}"/></label>
<c:if test="${status.errorMessage != ''}">
<span class="alertMessage">
	<c:out value="${status.errorMessage}"/>
</span>
</c:if>
<table><tr>
<td>
<textarea id="<c:out value="${status.expression}"/>" name="<c:out value="${status.expression}"/>" cols="80" rows="25"><c:out value="${status.value}"/></textarea>
</td>
</tr></table>
<osp:richTextWrapper textAreaId="${status.expression}" />
</spring:bind>
</p>

<spring:bind path="bean.systemOnly">
   <div class="checkbox indnt1">
      <input type="checkbox" name="<c:out value="${status.expression}"/>" value="true"  id="<c:out value="${status.expression}"/>-id" 
        <c:if test="${status.value}">checked</c:if> />
      <label for="<c:out value="${status.expression}"/>-id"><c:out value="${msgs.label_hiddenForm}"/></legend>
   </div>
</spring:bind>

<h4><c:out value="${msgs.header_advancedOptions}"/></h4>
<p class="shorttext">
<label for=""><c:out value="${msgs.label_altCreateFile}"/></label>
<spring:bind path="bean.alternateCreateXsltName">
<input type="text" id="<c:out value="${status.expression}"/>" name="<c:out value="${status.expression}"/>"
      disabled="true" value="<c:out value="${status.value}" />" />
</spring:bind>
<spring:bind path="bean.alternateCreateXslt">
<input type="hidden" name="<c:out value="${status.expression}"/>" id="<c:out value="${status.expression}"/>"
      value="<c:out value="${status.value}"/>" />

<a href="#"
   onclick="document.forms[0]['filePickerAction'].value='pickAltCreate';
      document.forms[0]['filePickerFrom'].value='<spring:message
         code="filePickerMessage.pickAltCreateXsl" />';
      document.forms[0].submit();return false;">
<c:out value="${msgs.text_selectAltCreateXsl}"/></a>
<c:if test="${status.errorMessage != ''}">
<span class="alertMessage">
	<c:out value="${status.errorMessage}"/>
</span>
</c:if>

</spring:bind>
</p>

<p class="shorttext">
<label for=""><c:out value="${msgs.label_altViewFile}"/></label>
<spring:bind path="bean.alternateViewXsltName">
<input type="text" id="<c:out value="${status.expression}"/>" name="<c:out value="${status.expression}"/>"
      disabled="true" value="<c:out value="${status.value}" />" />
</spring:bind>
<spring:bind path="bean.alternateViewXslt">
<input type="hidden" name="<c:out value="${status.expression}"/>" id="<c:out value="${status.expression}"/>"
      value="<c:out value="${status.value}"/>" />
<a href="#"
   onclick="document.forms[0]['filePickerAction'].value='pickAltView';
      document.forms[0]['filePickerFrom'].value='<spring:message
         code="filePickerMessage.pickAltViewXsl" />';
      document.forms[0].submit();return false;">
<c:out value="${msgs.text_selectAltViewXsl}"/></a>
<c:if test="${status.errorMessage != ''}">
<span class="alertMessage">
	<c:out value="${status.errorMessage}"/>
</span>
</c:if>
</spring:bind>
</p>

<p class="act">
<c:if test="${empty bean.id}">
<input name="action" type="submit" class="active" value='<c:out value="${msgs.button_save}"/>'/>
</c:if>

<c:if test="${!empty bean.id}">
<input name="action" type="submit" class="active" value='<c:out value="${msgs.button_saveEdit}"/>' accesskey="s"/>
</c:if>
<input type="button" value='<c:out value="${msgs.button_preview}"/>' onclick="document.forms[0]['previewAction'].value='preview';
      document.forms[0].submit();return false;" accesskey="v">

<input name="previewAction" id="previewAction" type="hidden" value="" class="skip"/>
<input name="action" id="action" type="hidden" value="" class="skip"/>
<input name="filePickerAction" id="filePickerAction" type="hidden" value="" class="skip"/>
<input name="filePickerFrom" id="filePickerFrom" type="hidden" value="" class="skip"/>
<input type="button" value="<fmt:message key="button_cancel"/>" onclick="window.document.location='<osp:url value="listStructuredArtifactDefinitions.osp"/>'" accesskey="x" >
</p>

</form>

