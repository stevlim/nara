<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="commonPageLibrary.jsp" %>

<script type="text/javascript">
function fnSetLanguage(strLanguageCode) {   
    arrParameter = {
               "LANGUAGE_CODE" : strLanguageCode
               };
    
    strCallUrl  = "/logInSessionLanguage.do";
    strCallBack = "fnSetLanguageRet";
    
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);    
}

function fnSetLanguageRet(objJson) {
    if (objJson.resultCode == 0) {
        location.reload();
    } else {                
        IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}
</script>
<style>
	@media (min-width: 980px) {div.pull-right > ul.mycustom{display : none; z-index:2; position: absolute;}}
</style>
    
    <!-- BEGIN HEADER -->
    <div class="header navbar navbar-inverse ">
    <!-- BEGIN TOP NAVIGATION BAR -->
    <div class="navbar-inner">
        <div class="header-seperation">
        <ul class="nav pull-left notifcation-center" id="main-menu-toggle-wrapper" style="display:none">
            <li class="dropdown">
                <a id="main-menu-toggle" href="#main-menu" class=""><div class="iconset top-menu-toggle-white"></div></a>
            </li>
      </ul>
      
      <!-- BEGIN LOGO -->
      <a href="/home/dashboard/dashboard.do">
      	<div class="page-title" style="text-align:center; padding-top:10px;">
   			<h3 style="color:#ffffff; width:60%"><c:out value="${CommonMessage.GNB_TITLE }"/></h3>
      		<div class="pull-right">
      			<ul class="nav quick-section mycustom" style="margin-top:0px;">
	                <li class="quicklinks"> 
	                    <a data-toggle="dropdown" class="dropdown-toggle  pull-right " href="#" id="user-options"><div class="iconset top-settings-dark "></div></a>
	                    <ul class="dropdown-menu  pull-right" role="menu" aria-labelledby="user-options">
	                        <li>
	                            <a href="javascript:fnSetLanguage('en');"><c:choose><c:when test="${language_code eq 'en' }"><i class="fa fa-eye"></i></c:when><c:otherwise><i class="fa fa-eye" style="visibility:hidden;"></i></c:otherwise></c:choose>&nbsp;&nbsp;English</a>
	                            <a href="javascript:fnSetLanguage('ko');"><c:choose><c:when test="${language_code eq 'ko' }"><i class="fa fa-eye"></i></c:when><c:otherwise><i class="fa fa-eye" style="visibility:hidden;"></i></c:otherwise></c:choose>&nbsp;&nbsp;Korean</a>
	                        </li>
	                        <li class="divider"></li>
	                        <li><a href="javascript:fnShowChangePassword();"><i class="fa fa-unlock-alt"></i>&nbsp;&nbsp;Change Password</a></li>
	                        <li class="divider"></li>
	                        <li><a href="<c:out value="${CommonConstants.LOGOUT_URL }"/>"><i class="fa fa-power-off"></i>&nbsp;&nbsp;Log Out</a></li>
	                    </ul>
	                </li>
	            </ul>
      		</div>
      	</div>
      </a>
      <!-- END LOGO -->
<%--        --%>
    </div>
    
    
    
    <!-- END RESPONSIVE MENU TOGGLER -->
    <div class="header-quick-nav">
        <!-- BEGIN TOP NAVIGATION MENU -->
        <div class="pull-left">
            <ul class="nav quick-section">
                <li class="quicklinks"> 
                    <a href="#" class="" id="layout-condensed-toggle"><div class="iconset top-menu-toggle-dark"></div></a> 
                </li>
            </ul>
        </div>
		<!-- END TOP NAVIGATION MENU -->
		<!-- BEGIN CHAT TOGGLER -->
        <div class="pull-right">
            <div class="chat-toggler">
                <div class="profile-pic"><!-- <img src="" data-src-retina="" width="35" height="35" /> --></div>
                <div class="user-details">                    
                    <div class="username"><span class="semi-bold text-white"><%=CommonUtils.getSessionInfo(session, "USR_ID")%></span></div>
                </div>
            </div>
            <ul class="nav quick-section ">
                <li class="quicklinks"> 
                    <a data-toggle="dropdown" class="dropdown-toggle  pull-right " href="#" id="user-options"><div class="iconset top-settings-dark "></div></a>
                    <ul class="dropdown-menu  pull-right" role="menu" aria-labelledby="user-options">
                        <li>
                            <a href="javascript:fnSetLanguage('en');"><c:choose><c:when test="${language_code eq 'en' }"><i class="fa fa-eye"></i></c:when><c:otherwise><i class="fa fa-eye" style="visibility:hidden;"></i></c:otherwise></c:choose>&nbsp;&nbsp;English</a>
                            <a href="javascript:fnSetLanguage('ko');"><c:choose><c:when test="${language_code eq 'ko' }"><i class="fa fa-eye"></i></c:when><c:otherwise><i class="fa fa-eye" style="visibility:hidden;"></i></c:otherwise></c:choose>&nbsp;&nbsp;Korean</a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="javascript:fnShowChangePassword();"><i class="fa fa-unlock-alt"></i>&nbsp;&nbsp;Change Password</a></li>
                        <li class="divider"></li>
                        <li><a href="<c:out value="${CommonConstants.LOGOUT_URL }"/>"><i class="fa fa-power-off"></i>&nbsp;&nbsp;Log Out</a></li>
                    </ul>
                </li>
            </ul>        
        </div>
        <!-- END CHAT TOGGLER -->        
    </div>
    <!-- END TOP NAVIGATION MENU -->
  </div>
  <!-- END TOP NAVIGATION BAR -->
</div>
<!-- END HEADER -->