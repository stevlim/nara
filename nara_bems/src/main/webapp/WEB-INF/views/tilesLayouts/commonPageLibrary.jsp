<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form"%>

<%@ page import="egov.linkpay.ims.common.common.CommonConstants" %>
<%@ page import="egov.linkpay.ims.common.common.CommonMessage" %>
<%@ page import="egov.linkpay.ims.common.common.CommonUtils" %>

<c:set var="date"          value="<%=new java.util.Date()%>"/>
<c:set var="language_code" value="<%=session.getAttribute(CommonConstants.IMS_SESSION_LANGUAGE_KEY)%>"/>

