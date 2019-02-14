<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="commonPageLibrary.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
    fnSetPWValidate();
    
    $("#frmpw .form-control").on("keydown", function(event) {
        if (event.which == 13 && $("#frmpw").valid()) {
            fnChangePasswordProc();
        }
    });
    
    $("#btnChangePW").on("click", function() {
        if (!$("#frmpw").valid()) {
            return;
        }
        
        fnChangePasswordProc();
    });
    
    $("#main-menu-wrapper ul li[id^='menu_li'] a i").each(function(intIndex){
        var arrIconName = ["fa fa-tachometer"
                          ,"fa fa-exchange"
                          ,"fa fa-calendar"
                          ,"fa fa-credit-card"
                          ,"fa fa-money"
                          ,"fa fa-desktop"
                          ,"fa fa-users"
                          ,"fa fa-shield"
                          ,"fa fa-bar-chart-o"
                          ,"fa fa-user"
                          ,"fa fa-comment"];
        if(typeof arrIconName[intIndex] != "undefined"){
            $(this).attr("class",arrIconName[intIndex]);
        } else {
            $(this).attr("class","fa fa-folder-o");
        }
    });
});

function fnSetPWValidate() {
    var arrValidate = {
                FORMID   : "frmpw",
                VARIABLE : {
                    CURPSWD   : {minlength:6, maxlength: 20, required: true},                   
                    NEWPSWD   : {minlength:6, maxlength: 20, notEqualTo: "#CURPSWD", required: true, passwordCheck:true, pwCheckConsecChars:true },
                    RENEWPSWD : {minlength:6, maxlength: 20, equalTo: "#NEWPSWD", required: true, passwordCheck:true, pwCheckConsecChars:true }
                    }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

function fnShowChangePassword() {
    $("body").addClass("breakpoint-1024 pace-done modal-open ");
    $('#btnModalPW').click();
}

function fnChangePasswordProc() {   
    arrParameter = {
               "CURPSWD" : $("#CURPSWD").val(),
               "NEWPSWD" : $("#NEWPSWD").val()
               };
    
    strCallUrl  = "/logInPasswordChangeProc.do";
    strCallBack = "fnChangePasswordProcRet";
    
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);    
}

function fnChangePasswordProcRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnFrmReset("frmpw");        
        IONPay.Msg.fnAlertWithModal(gMessage('IMS_COM_LNB_0001'), "PWModal", false);     
    } else {        
        IONPay.Utils.fnFrmReset("frmpw");
        IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "PWModal", true);
    }
}
</script>
    
    <!-- BEGIN CONTAINER -->
    <div class="page-container row">
        <!-- BEGIN SIDEBAR -->
        <div class="page-sidebar" id="main-menu">    
            <div class="page-sidebar-wrapper scrollbar-dynamic" id="main-menu-wrapper">            
                <!-- BEGIN SIDEBAR MENU -->      
                <ul>
                    <li id="menu_li_dashboard" class=''><a href="/home/dashboard/dashboard.do"><i class="" id="<c:out value="menu_i_dashboard"/>"></i><span class="title">DashBoard</span></a></li>
                    <c:set var="isSub1" value="false" />
                    <c:set var="isSub2" value="false" />
                    <c:set var="isSub3" value="false" />   
                    <c:set var="menuList" value="<%=session.getAttribute(CommonConstants.IMS_SESSION_MENU_KEY)%>" />                
                    <c:forEach var="menu" items='${menuList}' varStatus="status">
                       <%-- <c:out value="${menuList[status.index].DEPTH}"></c:out>
                       <c:out value="${menuList[status.index+1].DEPTH}"></c:out>
                       <c:out value="${status.last}"></c:out> --%>
                       <c:choose>
                           <c:when test="${menu.DEPTH eq '1'}">
                           		<c:if test="${not status.first and not status.last and (menuList[status.index-1].DEPTH ne '1')}">
	                            	<c:if test="${isSub1 == true}">
	                            		<c:set var="isSub1" value="false" />
	                               	   </ul>
	                               	   </li>
	                               	</c:if>
	                               	<c:if test="${isSub2 == true}">
	                            		<c:set var="isSub2" value="false" />
	                               	   </ul>
	                               	   </li>
	                               	</c:if>
	                               	<c:if test="${isSub3 == true}">
	                            		<c:set var="isSub3" value="false" />
	                               	   </ul>
	                               	   </li>
	                               	</c:if>
	                           </c:if>
                               <c:choose>
                               	   <c:when test="${not status.last and (menuList[status.index+1].DEPTH eq menu.DEPTH)}">
                               <li id="<c:out value="menu_li_${menu.DEPTH}_${status.index}"/>" class='<c:if test="${menu.MENU_GRP_NO eq MENU}">active open</c:if>'><a href="#"><i class="" id="<c:out value="menu_i_${menu.DEPTH}_${status.index}"/>"></i><span class="title"><spring:message code='${menu.MENU_NM }'/></span> <span id="<c:out value="menu_span_${menu.DEPTH}_${status.index}"/>" class="arrow"></span></a>
                               </li>	   
                               	   </c:when>
	                               <c:when test="${not status.last and (menuList[status.index+1].DEPTH ne menu.DEPTH)}">
	                               <c:set var="isSub1" value="true" />
                               <li id="<c:out value="menu_li_${menu.DEPTH}_${status.index}"/>" class='<c:if test="${menu.MENU_GRP_NO eq MENU}">active open</c:if>'><a href="#"><i class="" id="<c:out value="menu_i_${menu.DEPTH}_${status.index}"/>"></i><span class="title"><spring:message code='${menu.MENU_NM }'/></span> <span id="<c:out value="menu_span_${menu.DEPTH}_${status.index}"/>" class="arrow"></span></a>
	                                   <ul class="sub-menu">
	                               </c:when>
	                           </c:choose>
                           </c:when>                           
                           <c:when test="${menu.DEPTH eq '2'}">
                           		<c:if test="${menuList[status.index].MENU_NM eq  'IMS_MENU_SUB_0033'}">
                           		<c:set var="isSub2" value="true" />
	                               	   <li class="<c:if test="${menu.MENU_GRP_NO eq MENU and menu.MENU_NO eq SUBMENU}">active</c:if>"><a href="${menu.MENU_LINK }"/><spring:message code='${menu.MENU_NM }'/></a>
                           		</c:if>
	                           <c:if test="${not status.first and not status.last and (menuList[status.index-1].DEPTH ne '2')}">
	                               	<c:if test="${isSub2 == true}">
	                            		<c:set var="isSub2" value="false" />
	                               	   </ul>
	                               	   </li>
	                               	</c:if>
	                           </c:if>
                               <c:choose>
                               	   <c:when test="${not status.last and (menuList[status.index+1].DEPTH eq menu.DEPTH)}">
                               <li class="<c:if test="${menu.MENU_GRP_NO eq MENU and menu.MENU_NO eq SUBMENU}">active</c:if>"><a href="${menu.MENU_LINK }"/><spring:message code='${menu.MENU_NM }'/></a>
                               </li>	   
                               	   </c:when>
	                               <c:when test="${not status.last and (menuList[status.index+1].DEPTH > menu.DEPTH)}">
	                               <c:set var="isSub2" value="true" />
                               <li class="<c:if test="${menu.MENU_GRP_NO eq MENU and menu.MENU_NO eq SUBMENU}">active</c:if>"><a href="${menu.MENU_LINK }"/><spring:message code='${menu.MENU_NM }'/></a>
	                                   <ul class="sub-menu">
	                               </c:when>
	                               <c:when test="${not status.last and (menuList[status.index+1].DEPTH <= menu.DEPTH)}">
                               <li class="<c:if test="${menu.MENU_GRP_NO eq MENU and menu.MENU_NO eq SUBMENU}">active</c:if>"><a href="${menu.MENU_LINK }"/><spring:message code='${menu.MENU_NM }'/></a>
                               </li>	   
	                               </c:when>
	                           </c:choose>
                           </c:when>
                           <c:when test="${menu.DEPTH eq '3'}">
	                           <c:if test="${not status.first and not status.last and (menuList[status.index-1].DEPTH ne '3')}">
	                               	<c:if test="${isSub3 == true}">
	                            		<c:set var="isSub3" value="false" />
	                               	   </ul>
	                               	   </li>
	                               	</c:if>
	                           </c:if>
                               <c:choose>
                               	   <c:when test="${not status.last and (menuList[status.index+1].DEPTH eq menu.DEPTH)}">
                               <li class="<c:if test="${menu.MENU_GRP_NO eq MENU and menu.MENU_NO eq SUBMENU}">active</c:if>"><a href="${menu.MENU_LINK }"/><spring:message code='${menu.MENU_NM }'/></a>
                               </li>	   
                               	   </c:when>
	                               <c:when test="${not status.last and (menuList[status.index+1].DEPTH > menu.DEPTH)}">
	                               <c:set var="isSub3" value="true" />
                               <li class="<c:if test="${menu.MENU_GRP_NO eq MENU and menu.MENU_NO eq SUBMENU}">active</c:if>"><a href="${menu.MENU_LINK }"/><spring:message code='${menu.MENU_NM }'/></a>
	                                   <ul class="sub-menu">
	                               </c:when>
	                               <c:when test="${not status.last and (menuList[status.index+1].DEPTH <= menu.DEPTH)}">
                               <li class="<c:if test="${menu.MENU_GRP_NO eq MENU and menu.MENU_NO eq SUBMENU}">active</c:if>"><a href="${menu.MENU_LINK }"/><spring:message code='${menu.MENU_NM }'/></a>
                               </li>	   
	                               </c:when>
	                           </c:choose>
                           </c:when>
                       </c:choose>
                    </c:forEach>
                        </ul>                        
                    </li>                    
                </ul>
                <!-- END SIDEBAR MENU -->
            </div>
        </div>
        <a href="#" class="scrollup">Scroll</a>
        <!-- END SIDEBAR -->        
        <!-- BEGIN CHANGE PASSWORD MODAL -->
        <button id="btnModalPW" data-toggle="modal" data-target="#PWModal" style="width:0px; height:0px; display:none;"></button>
        <div class="modal fade" id="PWModal" tabindex="-1" role="dialog" aria-labelledby="modalPW" aria-hidden="true">
            <div class="modal-dialog">
            <form id="frmpw">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw');">×</button>
                        <br>
                        <i class="fa fa-unlock-alt fa-2x"></i>
                        <h4 id="modalPW" class="semi-bold"><spring:message code='IMS_COM_LNB_0002'/></h4>
                        <br>
                    </div>                
                    <div class="modal-body">                    
                        <div class="row form-row">
                            <div class="col-md-12">
                                <div class="input-with-icon  right">
                                    <i class=""></i>
                                    <input class="form-control" type="password" id="CURPSWD" name="CURPSWD" placeholder="<spring:message code='IMS_COM_LNB_0003'/>" maxlength=64">
                                </div>
                            </div>                  
                        </div>
                        <div class="row form-row">
                            <div class="col-md-12">
                                <div class="input-with-icon  right">
                                    <i class=""></i>
                                    <input class="form-control" type="password" id="NEWPSWD" name="NEWPSWD" placeholder="<spring:message code='IMS_COM_LNB_0004'/>" maxlength=64">
                                </div>
                            </div>
                        </div>
                        <div class="row form-row">
                            <div class="col-md-12">
                                <div class="input-with-icon  right">
                                    <i class=""></i>
                                    <input class="form-control" type="password" id="RENEWPSWD" name="RENEWPSWD" placeholder="<spring:message code='IMS_COM_LNB_0005'/>" maxlength=64">                               
                                </div>
                            </div>                  
                        </div>                  
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnChangePW" class="btn btn-danger">저장</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw');">취소</button>
                    </div>
                </div>
            </form>
            </div>
        </div>
        <!-- END CHANGE PASSWORD MODAL -->