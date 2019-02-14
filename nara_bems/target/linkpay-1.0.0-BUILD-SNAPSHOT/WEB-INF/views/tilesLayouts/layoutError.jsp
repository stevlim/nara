<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ include file="commonPageLibrary.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title><c:out value="${CommonMessage.BROWSER_TITLE }"/></title>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <meta charset="utf-8" />    
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- BEGIN CORE CSS FRAMEWORK -->
	<link type="text/css" rel="stylesheet" media="screen" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/pace/pace-theme-flash.css" />
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrapv3/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrapv3/css/bootstrap-theme.min.css" />
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/font-awesome/css/font-awesome.css" />
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/animate.min.css" />
	<!-- END CORE CSS FRAMEWORK -->
	<!-- BEGIN CSS TEMPLATE -->
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/style.css" />
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/responsive.css" />
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/custom-icon-set.css" />
	<!-- END CSS TEMPLATE -->
	<!-- BEGIN CORE JS FRAMEWORK-->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery-1.11.3.min.js"></script>
    <!-- END CORE JS FRAMEWORK-->    
</head>
<body class="error-body no-top">
    <tiles:insertAttribute name="BODY" />
    
    <!-- BEGIN CSRF TOKEN -->
    <input type="hidden" id="<c:out value="${CommonConstants.IMS_ID_CSRF}"/>">
    <!-- END CSRF TOKEN -->
    
    <!-- BEGIN CORE JS FRAMEWORK-->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.js"></script> 
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap/js/bootstrap.min.js"></script> 
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/breakpoints.js"></script> 
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-unveil/jquery.unveil.min.js"></script>
    <!-- END CORE JS FRAMEWORK -->    
    <!-- BEGIN PAGE LEVEL JS -->            
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-scrollbar/jquery.scrollbar.min.js"></script>    
    <!-- END PAGE LEVEL PLUGINS -->    
</body>
</html>