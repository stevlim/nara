<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
var objPWDListDT;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	IONPay.Auth.Init("${AUTH_CD}");
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
	$("#btnSearch").on("click", function(){
		if($("#searchFlg").val() == 2 ){
			$("#id").text("VID");
		}else{
			$("#id").text("MID");
		}
			fnSelectPWDList();
	});
}

function fnSetDDLB() {
    $("#frmSearch #searchFlg").html("<c:out value='${searchFlg}' escapeXml='false' />");
}

function fnChgSel(){
	if($("#searchFlg").val() == "none"){
		$("#search").val("");
		$("#search").disabled = true;
	}else{
		$("#search").disabled = false;
		$("#search").focus();
	}
}

function fnSelectPWDList() {
	if (typeof objPWDListDT == "undefined") {
		objPWDListDT = IONPay.Ajax.CreateDataTable("#tbPWDList", true, {
	        url: "/businessMgmt/pwdDel/selectPWDList.do",
	        data: function() {	
	            return $("#frmSearch").serializeObject();
	        },
       	 	columns: [
				{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NO} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  $("#frmSearch #searchFlg").val() == "2" ? data.VID : data.MID} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.U_ID} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  "<button type='button' class='btn btn-primary btn-cons' onClick='fnChangeEmp(\""+data.U_ID+"\");'><spring:message code='IMS_PW_DE_11'/> </button>"} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  $("#frmSearch #searchFlg").val() != "2" ?"<button type='button' class='btn btn-primary btn-cons' onClick='fnChangeCcPw(\""+data.MID+"\");'><spring:message code='IMS_PW_DE_11'/> </button>" : "" } }
            ]
	    }, true);
	} else {
		objPWDListDT.clearPipeline();
		objPWDListDT.ajax.reload();
	}
	IONPay.Utils.fnShowSearchArea();
	IONPay.Utils.fnHideSearchOptionArea();
}
//회원사 비번 초기화
function fnChangeEmp(uid){
	arrParameter["uid"] = uid;

	strCallUrl   = "/businessMgmt/pwdDel/updatePwdInit.do";
    strCallBack  = "fnChangeEmpRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);	
}
function fnChangeEmpRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("초기화 "+objJson.resultMessage);
	}else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
//결제취소 비번 초기화
function fnChangeCcPw(mid){
	if(!confirm("해당 MID 거래취소 비밀번호를 미설정으로 초기화 하시겠습니까?")){
		return;
	}else{
		arrParameter["mid"] = mid;
		arrParameter["worker"] = strWorker;
		strCallUrl   = "/businessMgmt/pwdDel/updateChangeCcPw.do";
	    strCallBack  = "fnChangeEmpRet";
	    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);	
	}
	
}
</script>

        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.BUSINESSMGMT_MERCHANTMGMT_TITLE }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_PW_DE_07'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <div class="row form-row" style="padding:0 0 10px 0;">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_PW_DE_08'/></label>
                                            <div class="input-with-icon  right">
                                                <i class=""></i>
                                                <select name="searchFlg"  onchange="fnChgSel();"  id="searchFlg" class="select2 form-control">
                                           		</select>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"  style="color:white;"><spring:message code='IMS_PW_DE_08'/></label>
                                            <input type="text" id="txtSearch" name="txtSearch"   maxlength="100" class="form-control">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"  ><spring:message code='IMS_PW_DE_10'/></button>                                                
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END VIEW OPTION AREA -->
                <!-- BEGIN SEARCH LIST AREA -->
                <div id="div_search" class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_IM_0032'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>                        
                            <div class="grid-body no-border" >
                                <div id="div_searchResult" style="display:none;">                               
                                    <div class="grid simple ">
                                        <div class="grid-body ">
                                            <table class="table" id="tbPWDList" style="width:100%">
                                                <thead>
                                                    <tr>
                                                    	<th>NO</th>                                                        
                                                        <th><spring:message code='IMS_PW_DE_01'/></th>
                                                        <th><spring:message code='IMS_PW_DE_02'/></th>
                                                        <th id="id"><spring:message code='IMS_PW_DE_03'/></th>
                                                        <th><spring:message code='IMS_PW_DE_04'/></th>
                                                        <th><spring:message code='IMS_PW_DE_05'/></th>
                                                        <th><spring:message code='IMS_PW_DE_06'/></th>
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
                <!-- END SEARCH LIST AREA -->
           </div>   
           <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->