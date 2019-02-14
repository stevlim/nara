<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
var objNoticeMgmtListDT;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	fnInitEvent();
	fnSetDDLB();
	
});

function fnInitEvent() {
	$("#btnSearch").on("click", function() {
		fnNoticeMgmtListDT();
	});
	$("#btnRegist").on("click", function() {
		$("#div_frm").css("display","block");
		if($("#editMode").val() == "insert"){
			$("#frmEdit #div_status").css("display", "none");
		}
		
	});
	$("#btnEdit").on("click", function() {		
		if (!$("#frmEdit").valid()) {
			  return;
		}
		var flg = $("#frmEdit #editMode").val();
		if($("#frmEdit #division").val() == ""){
			IONPay.Msg.fnAlert("구분을 선택해 주세요.");
			$("#frmEdit #division").focus();
			 return;
		}
		if($("#frmEdit #notiLocation").val() == ""){
			IONPay.Msg.fnAlert("게시위치를 선택해 주세요.");
			$("#frmEdit #notiLocation").focus();
			 return;
		}
		if($("#frmEdit #TITLE").val() == ""){
			IONPay.Msg.fnAlert("제목을 입력해 주세요.");
			$("#frmEdit #TITLE").focus();
			 return;
		}
		if($("#frmEdit #MEMO_EDITOR").val() == ""){
			IONPay.Msg.fnAlert("내용을 입력해 주세요.");
			$("#frmEdit #MEMO_EDITOR").focus();
			 return;
		}
		if($("#frmEdit #register").val() == ""){
			IONPay.Msg.fnAlert("등록자를 입력해 주세요.");
			$("#frmEdit #register").focus();
			 return;
		}
		fnEditNoticeMgmt(flg);
	});
$("#btnUpdate").on("click", function() {		
	$("#div_frm").css("display","none");
	$("#div_update_frm").css("display","block");
		if (!$("#frmUpdateEdit").valid()) {
			  return;
		}
		var flg = $("#frmUpdateEdit #editMode").val();
		if($("#frmUpdateEdit #division").val() == ""){
			IONPay.Msg.fnAlert("구분을 선택해 주세요.");
			$("#frmUpdateEdit #division").focus();
			 return;
		}
		if($("#frmUpdateEdit #notiLocation").val() == ""){
			IONPay.Msg.fnAlert("게시위치를 선택해 주세요.");
			$("#frmUpdateEdit #notiLocation").focus();
			 return;
		}
		if($("#frmUpdateEdit #TITLE").val() == ""){
			IONPay.Msg.fnAlert("제목을 입력해 주세요.");
			$("#frmUpdateEdit #TITLE").focus();
			 return;
		}
		if($("#frmUpdateEdit #MEMO_EDITOR").val() == ""){
			IONPay.Msg.fnAlert("내용을 입력해 주세요.");
			$("#frmUpdateEdit #MEMO_EDITOR").focus();
			 return;
		}
		if($("#frmUpdateEdit #register").val() == ""){
			IONPay.Msg.fnAlert("등록자를 입력해 주세요.");
			$("#frmUpdateEdit #register").focus();
			 return;
		}
		
		fnEditNoticeMgmt(flg);
	});
}

function fnSetDDLB() {
	$("#frmEdit select[name=division]").html("<c:out value='${notiDivision}' escapeXml='false' />");
	$("#frmEdit select[name=notiLocation]").html("<c:out value='${notiLocation}' escapeXml='false' />");
	$("#frmUpdateEdit select[name=division]").html("<c:out value='${notiDivision}' escapeXml='false' />");
	$("#frmUpdateEdit select[name=notiLocation]").html("<c:out value='${notiLocation}' escapeXml='false' />");
	$("#frmSearch select[name=BOARD_TYPE]").html("<c:out value='${BOARD_TYPE}' escapeXml='false' />");
	$("#frmSearch select[name=BOARD_CHANNEL]").html("<c:out value='${BOARD_CHANNEL}' escapeXml='false' />");
}

/**------------------------------------------------------------
* 공지사항 리스트 조회
------------------------------------------------------------*/
function fnNoticeMgmtListDT() {
	var $FROM_DT = $("#txtFromDate");
    var $TO_DT   = $("#txtToDate");
    
	var intFromDT = Number(IONPay.Utils.fnConvertDateFormat($FROM_DT.val()));
    var intToDT   = Number(IONPay.Utils.fnConvertDateFormat($TO_DT.val()));
        
    if (intFromDT > intToDT) {
        IONPay.Msg.fnAlert(gMessage('IMS_BM_NM_0011'));
        return;
    }
    
    if (!IONPay.Utils.fnCheckSearchRange($("#txtFromDate"), $("#txtToDate"), "3")) {
        return;
   	}
   	if (typeof objNoticeMgmtListDT == "undefined") {
   		objNoticeMgmtListDT = IONPay.Ajax.CreateDataTable("#tbNoticeMgmtList", true, {
   	        url: "/businessMgmt/noticeMgmt/selectNoticeMgmtList.do",
   	        data: function() {	
   	            return $("#frmSearch").serializeObject();
   	        },
       	 	columns: [
				{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.SEQ} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.NOTI_CD1} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.NOTI_TRG_CD1} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.TITLE} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REG_DT} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.WORKER} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.NOTI_ST_CD1 } },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  "<button type='button' class='btn btn-primary btn-cons' onClick='fnSelectNoticeMgmt(\""+data.SEQ+"\", \"update\");'><spring:message code='IMS_MM_MM_0002'/> </button>"} }
            ]
   	    }, true);
   	} else {
   		objNoticeMgmtListDT.clearPipeline();
   		objNoticeMgmtListDT.ajax.reload();
   	}
   	IONPay.Utils.fnShowSearchArea();
   	IONPay.Utils.fnHideSearchOptionArea();
}
function fnViewFull(viewNo){
	//modal
	strModalID = "modalViewDetail";
	arrParameter["seq"] = viewNo;
    strCallUrl   = "/businessMgmt/noticeMgmt/selectNoticeMgmt.do";
    strCallBack  = "fnModalNoticeDetail";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnModalNoticeDetail(objJson){
	if(objJson.resultCode == 0){
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage)
	}
}
/**------------------------------------------------------------
* 공지사항 등록/수정
------------------------------------------------------------*/
var map = new Map();
function fnEditNoticeMgmt(flg) {
	if(flg=="insert"){
		if ($.trim($("#frmEdit #MEMO_EDITOR").val()) == "")
		{
			IONPay.Msg.fnAlert(gMessage('IMS_BM_NM_0012'));
		}
		else
		{
			map.set("flg", flg);
		    arrParameter = $("#frmEdit").serializeObject();
	     
		    strCallUrl  = "/businessMgmt/noticeMgmt/insertNoticeMgmt.do";
		    strCallBack = "fnEditNoticeMgmtRet";
		     
		    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
		}
	}else{
		if ($.trim($("#frmEdit #MEMO_EDITOR").val()) == "")
		{
			IONPay.Msg.fnAlert(gMessage('IMS_BM_NM_0012'));
		}
		else
		{
			map.set("flg", flg);
			arrParameter = $("#frmEdit").serializeObject();
			arrParameter["seq"] = $("#frmEdit #SEQ_NO").val();			
		    strCallUrl  = "/businessMgmt/noticeMgmt/updateNoticeMgmt.do";
		    strCallBack = "fnEditNoticeMgmtRet";
		     
		    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
		}
	}
}

function fnEditNoticeMgmtRet(objJson) {
	if (objJson.resultCode == 0) {
		if(objJson.data.result >0){ 
			IONPay.Msg.fnAlert("success");
			var objSeq = objJson.data.seq;
			var flg = map.get("flg");
			//fnSelectNoticeMgmt(objSeq, flg);
			IONPay.Utils.fnClearHideForm();
			//fnNoticeMgmtListDT();
		}else{
			IONPay.Msg.fnAlert("fail");
		}
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}

/**------------------------------------------------------------
* 공지사항 게시물 조회
------------------------------------------------------------*/
function fnSelectNoticeMgmt(seq, flg) {
	arrParameter["seq"] = seq;
    strCallUrl  = "/businessMgmt/noticeMgmt/selectNoticeMgmt.do";
	
    if(flg == "update"){
    	strCallBack = "fnSelectNoticeMgmtRet";
	}else if(flg == "insert"){
		strCallBack = "fnSelectNoticeMgmtRet";
	}
     
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSelectNoticeMgmtRet(objJson) {
	if (objJson.resultCode == 0) {
		IONPay.Utils.fnClearShowForm();
		$("#frmEdit #division").select2("val", objJson.rowData.NOTI_ST_CD);
		$("#frmEdit #notiLocation").select2("val", objJson.rowData.NOTI_TRG_CD);
		$("#frmEdit #TITLE").val(objJson.rowData.TITLE);
		$("#frmEdit textarea[name=MEMO_EDITOR]").data("wysihtml5").editor.setValue(objJson.rowData.BODY);
		
		//$("#STATUS").select2("val", objJson.rowData.STATUS);
		
		if($("#editMode").val() == "modify"){
			$("#frmEdit #div_status").css("display", "block");
			var str = "";
			str += "<select id='selectStatus' name='selectStatus' class='select2 form-control'><option value='1' ";
			if(objJson.rowData.NOTI_ST_CD == "1" || objJson.rowData.NOTI_ST_CD=="2"){
				str += "selected";
			}
			str += " > 공지 </option> <option value='3 '";
			if(objJson.rowData.NOTI_ST_CD == "3" || objJson.rowData.NOTI_ST_CD=="99"){
				str += "selected ";
			}
			str += "> 중지 </option> </select>"
			
			$("#frmEdit #status").html(str);
		}else if($("#editMode").val == "insert"){
			$("#frmEdit #div_status").css("display", "none");
		}
		$("#frmEdit #register").val(objJson.rowData.WORKER);
		$("#frmEdit #SEQ_NO").val(objJson.rowData.SEQ);
		IONPay.Utils.fnJumpToPageTop();
		$("#frmEdit").valid();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}
function fnSelectUpdateNoticeMgmtRet(objJson) {
	if (objJson.resultCode == 0) {
		IONPay.Utils.fnClearShowUpdateForm();
		$("#div_frm").css("display","none");
		$("#div_update_frm").css("display","block");
		$("#frmUpdateEdit #division").select2("val", objJson.rowData.NOTI_ST_CD);
		$("#frmUpdateEdit #notiLocation").select2("val", objJson.rowData.NOTI_TRG_CD);
		$("#frmUpdateEdit #TITLE").val(objJson.rowData.TITLE);
		$("#frmUpdateEdit #MEMO_EDITOR").data("wysihtml5").editor.setValue(objJson.rowData.BODY);
		
		$("#frmUpdateEdit #div_status").css("display", "block");
		var str = "";
		str += "<select id='selectStatus' name='selectStatus' class='select2 form-control'><option value='1' ";
		if(objJson.rowData.NOTI_ST_CD == "1" || objJson.rowData.NOTI_ST_CD=="2"){
			str += "selected";
		}
		str += " > 공지 </option> <option value='3 '";
		if(objJson.rowData.NOTI_ST_CD == "3" || objJson.rowData.NOTI_ST_CD=="99"){
			str += "selected ";
		}
		str += "> 중지 </option> </select>"
		
		$("#frmUpdateEdit #status").html(str);
		$("#frmUpdateEdit #register").val(objJson.rowData.WORKER);
		$("#frmUpdateEdit #SEQ_NO").val(objJson.rowData.SEQ);
		IONPay.Utils.fnJumpToPageTop();
		$("#frmUpdateEdit").valid();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);
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
                <!-- BEGIN PAGE FORM -->
                <div id="div_frm" class="row" style="display:none;">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Regist</span></h4>
                                <div class="tools"> <a href="javascript:;" class="remove"></a></div>
                            </div>
                            <form id="frmEdit">
                            <div class="grid-body no-border">
                                <input type="hidden" id="editMode" value="insert" />
                                <input type="hidden" id="SEQ_NO" />
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0013'/></label>
                                        <div class="input-with-icon  right">
	                                        <i class=""></i>
	                                       <select  name="division" id="division"  class="select2 form-control">
	                                       </select>
	                                    </div>
                                    </div>                                    
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0014'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select  name="notiLocation" id="notiLocation"  class="select2 form-control">
	                                       </select>
                                        </div>
                                    </div>	
                                    <div class="col-md-6">
                                    </div>
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-6">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0015'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="TITLE" name="TITLE" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                    </div>     
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0016'/></label>
                                        <textarea id="MEMO_EDITOR" name="MEMO_EDITOR" class="form-control" style="height:400px;"></textarea>
							        </div>
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0018'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="register" name="register" maxlength="10"class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-4" style="display: none;" id="div_status">
                                    	<label class="form-label"><spring:message code='IMS_BIM_BM_0078'/></label>
                                        <div class="input-with-icon  right" id="status" >
                                            <i class=""></i>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                    </div>   
                                </div>
                            </div>
                            <div class="grid-body no-border">
                                <div class="row form-row">
                                    <div class="col-md-12">
                                        <p class="pull-right">
                                            <button type="button" id="btnEdit" class="btn btn-danger auth-all">저장</button>
                                            <button type="button" id="btnEditCancel" class="btn btn-default">취소</button>
                                        </p>
                                    </div>
                                </div>
                            </div>                          
                            </form>
                        </div>
                    </div>
                </div>                
                <!-- END PAGE FORM -->
                <!-- BEGIN PAGE FORM -->
                <div id="div_update_frm" class="row" style="display:none;">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Regist</span></h4>
                                <div class="tools"> <a href="javascript:;" class="remove"></a></div>
                            </div>
                            <form id="frmUpdateEdit">
                            <div class="grid-body no-border">
                                <input type="hidden" id="editMode" value="update" />
                                <input type="hidden" id="SEQ_NO" />
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0013'/></label>
                                        <div class="input-with-icon  right">
	                                        <i class=""></i>
	                                       <select  name="division" id="division"  class="select2 form-control">
	                                       </select>
	                                    </div>
                                    </div>                                    
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0014'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select  name="notiLocation" id="notiLocation"  class="select2 form-control">
	                                       </select>
                                        </div>
                                    </div>	
                                    <div class="col-md-6">
                                    </div>
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-6">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0015'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="TITLE" name="TITLE" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                    </div>     
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0016'/></label>
                                        <textarea id="MEMO_EDITOR" name="MEMO_EDITOR" class="form-control" style="height:400px;"></textarea>
							        </div>
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0018'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="register" name="register"  maxlength="10" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-4" style="display: none;" id="div_status">
                                    	<label class="form-label"><spring:message code='IMS_BIM_BM_0078'/></label>
                                        <div class="input-with-icon  right" id="status" >
                                            <i class=""></i>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                    </div>     
                                </div>
                            </div>
                            <div class="grid-body no-border">
                                <div class="row form-row">
                                    <div class="col-md-12">
                                        <p class="pull-right">
                                            <button type="button" id="btnUpdate" class="btn btn-danger auth-all">Update</button>
                                            <button type="button" id="btnEditCancel" class="btn btn-default">Cancel</button>
                                        </p>
                                    </div>
                                </div>
                            </div>                          
                            </form>
                        </div>
                    </div>
                </div>                
                <!-- END PAGE FORM -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_NM_0019'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
	                                <div class="row form-row" style="padding:0 0 10px 0;">                                    
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_NM_0013'/></label>
                                            <select id="BOARD_TYPE" name="BOARD_TYPE" class="select2 form-control">                                             
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_NM_0014'/></label>
                                            <div class="input-with-icon  right">
                                                <i class=""></i>
                                                <select id="BOARD_CHANNEL" name="BOARD_CHANNEL" data-placeholder="" class="select2 form-control">
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                        </div>	                                    
	                                </div>                                
	                                <div class="row form-row" >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_NM_0020'/></label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="txtFromDate" name="txtFromDate" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                           <label class="form-label">&nbsp;</label>
                                           <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                               <input type="text" id="txtToDate" name="txtToDate" class="form-control">
                                               <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                                           </div>
                                        </div>
                                        <div id="divSearchDateType4" class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0021'/></button>                                       
                                            <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0022'/></button>
                                            <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0023'/></button>
                                            <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0024'/></button>                                            
                                            <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0025'/></button>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_NM_0026'/></button>                                            
                                                <button type="button" id="btnRegist" class="btn btn-primary auth-all btn-cons"><spring:message code='IMS_BM_NM_0027'/></button>
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
	                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_NM_0028'/></h4>
	                            <div class="tools"><a href="javascript:;" class="collapse"></a></div>
	                        </div>                        
	                        <div class="grid-body no-border" >
	                            <div id="div_searchResult" style="display:none;">	                            
	                                <div class="grid simple ">
	                                    <div class="grid-body ">
	                                        <table class="table" id="tbNoticeMgmtList" style="width:100%">
	                                            <thead>
													<tr>
													    <th>NO</th>
													    <th><spring:message code='IMS_BM_NM_0013'/></th>
													    <th><spring:message code='IMS_BM_NM_0014'/></th>
													    <th><spring:message code='IMS_BM_NM_0015'/></th>
													    <th><spring:message code='IMS_BM_NM_0020'/></th>
													    <th><spring:message code='IMS_BM_NM_0018'/></th>
													    <th><spring:message code='IMS_BM_NM_0017'/></th>
													    <th><spring:message code='IMS_MM_MM_0002'/></th>
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
