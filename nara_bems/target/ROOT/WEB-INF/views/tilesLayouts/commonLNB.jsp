<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="commonPageLibrary.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
    fnSetPWValidate();
    fnMenuHoverEvent();
    fnGetMenuList();
    fnAnchorEventPrevent();
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
function fnMenuHoverEvent(){
	$(".sidenav").mouseover(function(){
		var icon = $(this).find("i");
		var menu = $(this).find("span");
		icon.addClass("menu-active").addClass("special");
		menu.addClass("menu-active");
	});
	$(".sidenav").mouseout(function(){
		var icon = $(this).find("i");
		var menu = $(this).find("span");
		icon.removeClass("menu-active").removeClass("special");
		menu.removeClass("menu-active");
	});
}
function fnClickMenuDepth1(selector){
	var id = "#" + $(selector).attr("id");
	var menu = $(id + ' .title').text().trim();
	var openMenu = "";
	var currentTopValue = $(id).position().top;
	
	switch(menu){
		case "Admin"://case "권한관리":
			$("#user").hide();
			openMenu = "#authority";
			break;
		//case "정산":
		case "회원사정보":	
			$("#user").hide();
			openMenu = "#calcu";
			break;
		case "운영관리":
			$("#user").hide();
			openMenu = "#oper";
			break;
		//case "영업관리":
		case "결제관리":	
			$("#user").hide();
			openMenu = "#business";
			break;
		//case "거래관리":
		case "고객지원":	
			$("#user").hide();
			openMenu = "#payment";
			break;
		//case "기준정보":
		case "입금관리":	
			$("#user").hide();
			openMenu = "#baseinfo";
			break;
		case "RM":
			$("#user").hide();
			openMenu = "#rm-approval";
			break;
		case "통계":
			$("#user").hide();
			openMenu = "#total";
			break;
		case "다국어관리":
			openMenu = "#message";
			$("#user").hide();
			break;
		/* case $("#login_id").val:
			openMenu = "#user";
			$("#user").show();
			break; */	
		default:
			$("#user").show();
			openMenu = "#user";
	}
	
	var status = $(openMenu).data("current");
	
	if(status == 0){
		$(openMenu).css({
			"opacity": "1",
			"visibility": "visible",
			"top" : currentTopValue
		});
	}else{
		$(openMenu).data("current", "0");
		$(openMenu).css({
			"opacity": "0",
			"visibility": "hidden"
		});
	}
	// 다른 메뉴 클릭시 기존메뉴창 hidden
	$("#depth2 > ul").each(function(index){
		var $this = $(this);
		//if((openMenu != ("#" + $this.attr("id"))) && (Number($this.data("current")) == 1)){
		if(openMenu != ("#" + $this.attr("id"))){	
			$this.data("current", "0");
			$this.css({
				"opacity": "0",
				"visibility": "hidden"
			});
		}
	});
}
function fnClickMenuDepth2(selector){
	var $selMenu = $(selector);
	var isClicked = $selMenu.data("isClicked");
	// 클릭메뉴 표시
	if(!Number(isClicked)){
		$selMenu.data("isClicked", "1");
		$selMenu.addClass("clicked");
		$selMenu.find('span').removeClass("menu-hidden");
	}else{
		$selMenu.data("isClicked", "0");
		$selMenu.removeClass("clicked");
		$selMenu.find('span').addClass("menu-hidden");
	}
	
	var openMenu = "#" + $selMenu.find("ul").attr("id");
	
	var status = $(openMenu).data("current");
	var currentTopValue = $(openMenu).position().top;
	if(status == 0){
		$(openMenu).data("current", "1");
		$(openMenu).css({
			"opacity": "1",
			"visibility": "visible",
			"top" : currentTopValue-30
		});
	}else{
		$(openMenu).data("current", "0");
		$(openMenu).css({
			"opacity": "0",
			"visibility": "hidden",
			"top" : currentTopValue+30
		});
	}
	// 다른 메뉴 클릭시 기존메뉴창 hidden, 기존메뉴 선택됐을때의 css클래스 제거
	$("#depth2 ul[id^='MENU_NO']").each(function(){
		var $this = $(this);
		var $parent = $this.parent();	// 제거할 clicked 메뉴(li)
		var top = $this.position().top;
		if((openMenu != ("#" + $this.attr("id"))) && (Number($this.data("current")) == 1)){
			$parent.data("isClicked", "0");
			$parent.removeClass("clicked");
			$parent.find('span').addClass("menu-hidden");
			$this.data("current", "0");
			$this.css({
				"opacity": "0",
				"visibility": "hidden",
				"top": top+30
			});
		}
	});

}
// a href="#"일 때 맨위로 스크롤 올라가는 현상 제거
function fnAnchorEventPrevent(){
	$("#depth2 a").click(function(event){
		var link = $(this).attr("href");
		if(link == "#"){
			event.preventDefault();
		}
	});
}
// LNB DEPTH2, DEPTH3 메뉴 그리는 함수
function fnGetMenuList(){
	var jsonStr = '${sessionScope.menuList}';
	var menuList = JSON.parse(jsonStr);
	// DEPTH = 2
	var authorityMgmtHTML = "";	// 권한
	var calcuMgmtHTML = "";		// 정산
	var operMgmtHTML = "";		// 운영
	var businessMgmtHTML = "";	// 영업
	var paymentMgmtHTML = "";	// 결제
	var baseinfoMgmtHTML = "";	// 기본정보
	var rmApprovalHTML = "";	// RM
	var totalMgmtHTML = "";		// 통계
	var messageMgmtHTML = "";	// 다국어

	// DEPTH = 3
	var authorityMgmtDepth3HTML = "";	// 권한
	var calcuMgmtDepth3HTML = "";		// 정산
	var operMgmtDepth3HTML = "";		// 운영
	var businessMgmtDepth3HTML = "";	// 영업
	var paymentMgmtDepth3HTML = "";	// 결제
	var baseinfoMgmtDepth3HTML = "";	// 기본정보
	var rmApprovalDepth3HTML = "";	// RM
	var totalMgmtDepth3HTML = "";		// 통계
	var messageMgmtDepth3HTML = "";	// 다국어

	// 중메뉴 그리기
	menuList.forEach(function(val, index){
		if(val.DEPTH == 1 || val.STATUS == "0"){
			return;
		}
		else if(val.DEPTH == 2 && val.STATUS == "1"){
			// 권한 > Admin
			if(val.MENU_GRP_NO == 37){
				if(val.MENU_LINK != "#"){
					authorityMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">";
					authorityMgmtHTML += gMessage(val.MENU_NM);
					authorityMgmtHTML += "</a></li>";
				}else{
					authorityMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					authorityMgmtHTML += gMessage(val.MENU_NM);
					authorityMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					authorityMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#authority").html(authorityMgmtHTML);
				
			}
			
			// 정산
			else if(val.MENU_GRP_NO == 30) {	
				if(val.MENU_LINK != "#"){
					calcuMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">";
					calcuMgmtHTML += gMessage(val.MENU_NM);
					calcuMgmtHTML += "</a></li>";
				}else{
					calcuMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					calcuMgmtHTML += gMessage(val.MENU_NM);
					calcuMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					calcuMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#calcu").html(calcuMgmtHTML);
			}
			// 운영
			else if(val.MENU_GRP_NO == 25) {
				if(val.MENU_LINK != "#"){
					operMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">";
					operMgmtHTML += gMessage(val.MENU_NM);
					operMgmtHTML += "</a></li>";
				}else{
					operMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					operMgmtHTML += gMessage(val.MENU_NM);
					operMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					operMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#oper").html(operMgmtHTML);
			}
			// 영업
			else if(val.MENU_GRP_NO == 26) {
				if(val.MENU_LINK != "#"){
					businessMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">";
					businessMgmtHTML += gMessage(val.MENU_NM);
					businessMgmtHTML += "</a></li>";
				}else{
					businessMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					businessMgmtHTML += gMessage(val.MENU_NM);
					businessMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					businessMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#business").html(businessMgmtHTML);
			}
			// 결제
			else if(val.MENU_GRP_NO == 29) {
				if(val.MENU_LINK != "#"){
					paymentMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">";
					paymentMgmtHTML += gMessage(val.MENU_NM);
					paymentMgmtHTML += "</a></li>";
				}else{
					paymentMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					paymentMgmtHTML += gMessage(val.MENU_NM);
					paymentMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					paymentMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#payment").html(paymentMgmtHTML);
			}
			// 기본정보
			else if(val.MENU_GRP_NO == 28) {
				if(val.MENU_LINK != "#"){
					baseinfoMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">"
					baseinfoMgmtHTML += gMessage(val.MENU_NM)
					baseinfoMgmtHTML += "</a></li>";
				}else{
					baseinfoMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>"
					baseinfoMgmtHTML += gMessage(val.MENU_NM)
					baseinfoMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>"
					baseinfoMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#baseinfo").html(baseinfoMgmtHTML);
			}
			// RM
			else if(val.MENU_GRP_NO == 99) {
				if(val.MENU_LINK != "#"){
					rmApprovalHTML += "<li><a href="+ val.MENU_LINK+ ">";
					rmApprovalHTML += gMessage(val.MENU_NM);
					rmApprovalHTML += "</a></li>";
				}else{
					rmApprovalHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					rmApprovalHTML += gMessage(val.MENU_NM);
					rmApprovalHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					rmApprovalHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#rm-approval").html(rmApprovalHTML);
			}
			// 통계
			else if(val.MENU_GRP_NO == 98) {
				if(val.MENU_LINK != "#"){
					totalMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">";
					totalMgmtHTML += gMessage(val.MENU_NM);
					totalMgmtHTML += "</a></li>";
				}else{
					totalMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					totalMgmtHTML += gMessage(val.MENU_NM);
					totalMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					totalMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#total").html(totalMgmtHTML);
			}
			// 다국어
			/* else if(val.MENU_GRP_NO == 97) {
				if(val.MENU_LINK != "#"){
					messageMgmtHTML += "<li><a href="+ val.MENU_LINK+ ">";
					messageMgmtHTML += gMessage(val.MENU_NM);
					messageMgmtHTML += "</a></li>";
				}else{
					messageMgmtHTML += "<li onclick='fnClickMenuDepth2(this)' data-isClicked='0'><a href='#'>";
					messageMgmtHTML += gMessage(val.MENU_NM);
					messageMgmtHTML += "</a><span class='menu-hidden select-menu'>&gt;</span>";
					messageMgmtHTML += "<ul id='MENU_NO_" + val.MENU_NO + "' data-current='0'></ul></li>";
				}
				$("#message").html(messageMgmtHTML);
			} */
		}
	});

	// 소메뉴 그리기
	menuList.forEach(function(val, index){
		if(val.DEPTH == 3 && val.STATUS == "1"){
			var depth3DOM = $("#MENU_NO_" + val.PARENT_MENU_NO);
			var nextMenu = menuList[index+1];
			// 권한 > Admin
			if(val.MENU_GRP_NO == 37){
				authorityMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				authorityMgmtDepth3HTML += gMessage(val.MENU_NM);
				authorityMgmtDepth3HTML += "</a></li>";
			}
			// 정산
			else if(val.MENU_GRP_NO == 30) {
				calcuMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				calcuMgmtDepth3HTML += gMessage(val.MENU_NM);
				calcuMgmtDepth3HTML += "</a></li>";
			}
			// 운영
			else if(val.MENU_GRP_NO == 35) {
				operMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				operMgmtDepth3HTML += gMessage(val.MENU_NM);
				operMgmtDepth3HTML += "</a></li>";
			}
			// 영업
			else if(val.MENU_GRP_NO == 26) {
				businessMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				businessMgmtDepth3HTML += gMessage(val.MENU_NM);
				businessMgmtDepth3HTML += "</a></li>";
			}
			// 결제
			else if(val.MENU_GRP_NO == 29) {
				paymentMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				paymentMgmtDepth3HTML += gMessage(val.MENU_NM);
				paymentMgmtDepth3HTML += "</a></li>";
			}
			// 기본정보
			else if(val.MENU_GRP_NO == 28) {
				baseinfoMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				baseinfoMgmtDepth3HTML += gMessage(val.MENU_NM);
				baseinfoMgmtDepth3HTML += "</a></li>";

			}
			// RM
			else if(val.MENU_GRP_NO == 99) {
				rmApprovalDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				rmApprovalDepth3HTML += gMessage(val.MENU_NM);
				rmApprovalDepth3HTML += "</a></li>";
			}
			// 통계
			else if(val.MENU_GRP_NO == 98) {
				totalMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				totalMgmtDepth3HTML += gMessage(val.MENU_NM);
				totalMgmtDepth3HTML += "</a></li>";
			}
			// 다국어
			/* else if(val.MENU_GRP_NO == 97) {
				messageMgmtDepth3HTML += "<li><a href="+ val.MENU_LINK+ ">";
				messageMgmtDepth3HTML += gMessage(val.MENU_NM);
				messageMgmtDepth3HTML += "</a></li>";
			} */
			// 메뉴 그리기
			if(nextMenu != undefined){
				if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 37) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 37)){
					depth3DOM.html(authorityMgmtDepth3HTML);
					authorityMgmtDepth3HTML = "";
				}else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 30) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 30)){	
					depth3DOM.html(calcuMgmtDepth3HTML);
					calcuMgmtDepth3HTML = "";
				}else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 35) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 35)){
					depth3DOM.html(operMgmtDepth3HTML);
					operMgmtDepth3HTML = "";
				}else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 26) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 26)){
					depth3DOM.html(businessMgmtDepth3HTML);
					businessMgmtDepth3HTML = "";
				}else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 29) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 29)){
					depth3DOM.html(paymentMgmtDepth3HTML);
					paymentMgmtDepth3HTML = "";
				}else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 28) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 28)){
					depth3DOM.html(baseinfoMgmtDepth3HTML);
					baseinfoMgmtDepth3HTML = "";
				}else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 99) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 99)){
					depth3DOM.html(rmApprovalDepth3HTML);
					rmApprovalDepth3HTML = "";
				
				// 12 > 11
				}else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 98) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 98)){
					depth3DOM.html(totalMgmtDepth3HTML);
					totalMgmtDepth3HTML = "";
				}/* else if((nextMenu.PARENT_MENU_NO == 0 && val.MENU_GRP_NO == 97) || (nextMenu.MENU_NO == 0 && val.MENU_GRP_NO == 97)){
					depth3DOM.html(messageMgmtDepth3HTML);
					messageMgmtDepth3HTML = "";
				} */
			}
		}
	});
}
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
    fnClickMenuDepth1('user');
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
	<input type="hidden" id="login_id" value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>" />
    <!-- BEGIN CONTAINER -->
    <div class="page-container row">
        <!-- BEGIN SIDEBAR -->
        <div class="page-sidebar" id="main-menu">
            <div class="page-sidebar-wrapper scrollbar-dynamic" id="main-menu-wrapper">
                <!-- BEGIN SIDEBAR MENU -->
                <ul>
                	<li>
                		<a href="/home/dashboard/dashboard.do" id="linkpay-logo">
                			<img src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/img/linkpay-logo-lnb.png" alt="" />
                		</a>
                	</li>
                	<li id="user-menu" onclick="javascript:fnClickMenuDepth1(this); return false;">
                		<a href="#">
                			<i class="fa fa-user-circle"></i>
		                    <span class="title"><%=CommonUtils.getSessionInfo(session, "USR_ID")%></span>
                		</a>
                	</li>
                    <li id="menu_li_dashboard" class='sidenav'>
	                    <a href="/home/dashboard/dashboard.do">
		                    <i class="" id="<c:out value="menu_i_dashboard"/>"></i>
		                    <span class="title">DashBoard</span>
	                    </a>
                    </li>
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
                               <li id="<c:out value="menu_li_${menu.DEPTH}_${status.index}"/>" class='sidenav' onclick="fnClickMenuDepth1(this); return false;"><a href="#"><i class="" id="<c:out value="menu_i_${menu.DEPTH}_${status.index}"/>"></i><span class="title"><spring:message code='${menu.MENU_NM }'/></span> <span id="<c:out value="menu_span_${menu.DEPTH}_${status.index}"/>"></span></a>
                               </li>
                               	   </c:when>
	                               <c:when test="${not status.last and (menuList[status.index+1].DEPTH ne menu.DEPTH)}">
	                               <c:set var="isSub1" value="true" />
                               <li id="<c:out value="menu_li_${menu.DEPTH}_${status.index}"/>" class='sidenav' onclick="fnClickMenuDepth1(this); return false;"><a href="#"><i class="" id="<c:out value="menu_i_${menu.DEPTH}_${status.index}"/>"></i><span class="title"><spring:message code='${menu.MENU_NM }'/></span> <span id="<c:out value="menu_span_${menu.DEPTH}_${status.index}"/>"></span></a>
	                                   <ul class="sub-menu">
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
        <ul id="user" data-current="0">
        	<%-- <li>
        		<a href="javascript:fnSetLanguage('en');"><c:choose><c:when test="${language_code eq 'en' }"><i class="fa fa-eye"></i></c:when><c:otherwise><i class="fa fa-eye" style="visibility:hidden;"></i></c:otherwise></c:choose>&nbsp;&nbsp;English</a>
        	</li>
        	<li>
        		<a href="javascript:fnSetLanguage('ko');"><c:choose><c:when test="${language_code eq 'ko' }"><i class="fa fa-eye"></i></c:when><c:otherwise><i class="fa fa-eye" style="visibility:hidden;"></i></c:otherwise></c:choose>&nbsp;&nbsp;Korean</a>
        	</li>
            <li><a href="javascript:fnShowChangePassword();"><i class="fa fa-unlock-alt"></i>&nbsp;&nbsp;Change Password</a></li> --%>
            <li><a href="<c:out value='/logOut.do'/>"><i class="fa fa-power-off"></i>&nbsp;&nbsp;Log Out</a></li>
            <%-- <li><a href="<c:out value='${CommonConstants.LOGOUT_URL }'/>"><i class="fa fa-power-off"></i>&nbsp;&nbsp;Log Out</a></li> --%>
        </ul>
        <div id="depth2">
	        <ul id="authority" data-current="0"></ul>
	        <ul id="calcu" data-current="0"></ul>
	        <ul id="oper" data-current="0"></ul>
	        <ul id="business" data-current="0"></ul>
	        <ul id="payment" data-current="0"></ul>
	        <ul id="baseinfo" data-current="0"></ul>
	        <ul id="rm-approval" data-current="0"></ul>
	        <ul id="total" data-current="0"></ul>
	        <ul id="message" data-current="0"></ul>
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