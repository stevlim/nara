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
	<meta content="" name="description" />
	<meta content="" name="author" />
	<!-- BEGIN PLUGIN CSS -->
    <%-- <link rel="stylesheet" type="text/css" media="screen" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/pace/pace-theme-flash.css" /> --%>
    <!-- END PLUGIN CSS -->
    <!-- BEGIN CORE CSS FRAMEWORK -->
    <%-- <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrapv3/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrapv3/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/font-awesome/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/animate.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-scrollbar/jquery.scrollbar.css"/>
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/login.css" /> --%>
    <!-- END CORE CSS FRAMEWORK -->
    <!-- BEGIN CSS TEMPLATE -->
    <%-- <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/responsive.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/custom-icon-set.css" />
    
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/login-style.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/login-google-style.css" /> --%>
    
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/login/global.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/login/jquery.datetimepicker.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/login/private.css" />
    
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/element/element.css" />
    
    <!-- END CSS TEMPLATE -->
    <!-- BEGIN CORE JS FRAMEWORK-->
    <%-- <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery-1.11.3.min.js"></script> --%>
    <!-- END CORE JS FRAMEWORK-->
    <!-- BEGIN I18N JS --> 
    <%-- <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.i18n.properties-min-1.0.9.js"></script> --%>
    <!-- END I18N JS -->
    <!-- BEGIN IMS MSG JS --> 
    <%-- <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/IONPayMSG.IMS.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script> --%>
    <!-- END IMS MSG JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/js/nara/element/element.js"></script>
    
</head>
<%-- <body class="error-body no-top" style="background-image: url(//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Images/loginBg.jpg); background-repeat:no-repeat; background-position:center;">    --%>
<body>
    <tiles:insertAttribute name="BODY" />

    <!-- BEGIN MODAL -->    
    <button id="btnModalMsg" data-toggle="modal" data-target="#alertModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="modalMsg" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <br>
                    <i class="fa fa-warning fa-3x"></i>
                    <h4 id="modalMsg" class="semi-bold"></h4>                    
                    <br>
                </div>                
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>            
                </div>
            </div>      
        </div>
    </div>    
    <!-- END MODAL -->
    
    <!-- BEGIN AJAX LOADER -->
    <div id="divPageBlock" style="display:none;">
        <img src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Images/ajax_loader_02.gif">
    </div>
    <!-- END AJAX LOADER -->
    
    <!-- BEGIN CSRF TOKEN -->
    <input type="hidden" id="<c:out value="${CommonConstants.IMS_ID_CSRF}"/>">
    <!-- END CSRF TOKEN -->
    
    <!-- BEGIN CORE JS FRAMEWORK-->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.js"></script> 
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap/js/bootstrap.min.js"></script> 
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/breakpoints.js"></script> 
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-unveil/jquery.unveil.min.js"></script>
    <!-- END CORE JS FRAMEWORK -->
    <!-- BEGIN IONPAY CORE JS FRAMEWORK-->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.ajax-retry.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/IONPay.IMS.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script>
    <!-- END IONPAY CORE JS FRAMEWORK-->
    <!-- BEGIN PAGE LEVEL JS -->    
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-block-ui/jqueryblockui.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-scrollbar/jquery.scrollbar.min.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-validation/js/jquery.validate.min.js"></script>
    <!-- END PAGE LEVEL PLUGINS -->
    <!-- BEGIN CORE TEMPLATE JS --> 
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/js/core.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script> 
    <!-- END CORE TEMPLATE JS -->
</body>
</html>