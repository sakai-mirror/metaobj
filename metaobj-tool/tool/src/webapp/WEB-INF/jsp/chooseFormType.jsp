<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<fmt:setLocale value="${locale}"/>
<fmt:setBundle basename = "messages"/>

<form method="POST">

   <select name="formId" >
      <c:forEach var="form" items="${formList}" varStatus="loopCount">
         <option value="<c:out value="${form.id}"/>">
            <c:out value="${form.description}"/></option>
      </c:forEach>
   </select>

   <input type="submit" value="submit"/>
   <input type="submit" value="cancel" onclick="this.form.canceling.value='true'"/>
   <input type="hidden" value="" name="canceling"/>

</form>