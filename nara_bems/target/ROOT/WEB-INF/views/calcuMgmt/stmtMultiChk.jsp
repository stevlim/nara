<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strStmtFlg2 = "<c:out value='${SETT_AUTH_FLG2}' escapeXml='false' />";
var objAgentStmtInquiry;
var strType;
$(document).ready(function(){
    fnSetDDLB();
	fnInitEvent();
});

// function fnSetValidate(){
// 	 var arrValidate = {
//              FORMID   : "frmModalReg",
//              VARIABLE : {                    
//             	selCD1 	: {required: true},
// 				selCD2 	: {required: true},
// 	 			amt 	: {required: true},
// 	 			payDt	: {required: true},
// 	 			desc	: {required: true}
//                }
// 	 	}
//  	IONPay.Utils.fnSetValidate(arrValidate);
// }

function fnInitEvent() {
	$("#div_search").hide();
	$("#selCD2").html("<option value='ALL' selected>모두</option>");
	
	var toMon = getToMon();
	$("#modalReg #payDt").val(dateLMaskOn(toMon));
	var year = getToDate("Y");
	var month = getToDate("M");
	$("#frmSearch #frYear").val(year).attr("selected", "selected");
	$("#frmSearch #frMon").val("01").attr("selected", "selected");
	$("#frmSearch #toYear").val(year).attr("selected", "selected");
	$("#frmSearch #toMon").val(month).attr("selected", "selected");

	$("#btnSearch").on("click", function() {
    	$("#div_search").show(200);
    	strType = "SEARCH";
    	fnSelectAgentRemainAmt();
    	fnSearchList(strType);
    });
	$("#btnExcel").on("click", function() {
		strType="EXCEL";
		fnSearchList(strType);
    });
    $("#btnRegist").on("click", function() {
    	IONPay.Utils.fnClearForm("frmModalReg");
    	$("#div_search").hide(200);
    	$("body").addClass("breakpoint-1024 pace-done modal-open ");
    	$("#modalReg").modal();
   	});
}
function fnSetDDLB(){
	$("select[name=frYear]").html("<c:out value='${YEAR}' escapeXml='false' />");
	$("select[name=frMon]").html("<c:out value='${MONTH}' escapeXml='false' />");
	$("select[name=toYear]").html("<c:out value='${YEAR}' escapeXml='false' />");
	$("select[name=toMon]").html("<c:out value='${MONTH}' escapeXml='false' />");
	$("select[name=selCD1]").html("<c:out value='${LstCardCode}' escapeXml='false' />");
	$("#modalReg select[name=selCD1]").html("<c:out value='${LstCardCode1}' escapeXml='false' />");
	$("#modalReg select[name=selCD2]").html("<c:out value='${DEFAULT_CD2}' escapeXml='false' />");
	$("#modalUpd select[name=selCD1]").html("<c:out value='${LstCardCode1}' escapeXml='false' />");
	$("#modalUpd select[name=selCD2]").html("<c:out value='${DEFAULT_CD2}' escapeXml='false' />");
}

function fnSelCD(cd){
	arrParameter["code1"] = cd;
    strCallUrl   = "/calcuMgmt/agencyStmtMgmt/selectCode2List.do";
    strCallBack  = "fnSelCdRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelCdRet(objJson){
	if(objJson.resultCode == 0){
		if(objJson.typeList.length == 0 ){
			$("#selCD2").html("<option value='ALL' selected>모두</option>");
		}else{
			$("#selCD2").html(objJson.typeList);
			$('#selCD2').select2("val", "ALL");
		}
		$("#modalReg select[name=selCD2]").html(objJson.typeList);
		$("#modalReg select[name=selCD2] option[value='ALL']").remove();
		$('#modalReg select[name=selCD2]').select2("val", "01");
	}else{
		IONPay.Msg.fnAlert("fail");
	}
}
function fnSave(){
	if($("#modalReg #extraId").val().length < 10){
// 		$("#modalReg #extraId").focus();
		IONPay.Msg.fnAlertWithModal("정산ID를 입력하세요", "modalReg");
		return;
	}
	if($("#modalReg #amt").val().length < 1){
		IONPay.Msg.fnAlertWithModal("금액을 입력하세요", "modalReg");
// 		$("#modalReg #amt").focus();
		return;
	}
	if($("#modalReg #payDt").val().length < 7){
		IONPay.Msg.fnAlertWithModal("지급월을 입력하세요", "modalReg");
// 		$("#modalReg #payDt").focus();
		return;
	}
	var frMon = dateLMaskOff($("#modalReg #payDt").val());
	var toMon = getToMon();
	if(frMon < toMon){
		IONPay.Msg.fnAlertWithModal("지급월은 현재월 이전일 수 없습니다.", "modalReg");
// 		$("#modalReg #payDt").focus();
      	return;
	}
	arrParameter = $("#frmModalReg").serializeObject();
	arrParameter["worker"] = strWorker;
	arrParameter["amt"] = IONPay.Utils.fnDelComma($("#frmModalReg #amt").val());
	
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/insertAgentResrEtc.do";
	strCallBack  = "fnSaveRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSaveRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#modalReg").modal("hide");
		$("#modalUpd").modal("hide");
		IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "modalReg");
	}else{
		IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "modalReg");
	}
}
function fnReqModify(resrCl, seq, amt, dt, vid, resrReason, setSeq, desc){
	//modalfrmModalUpd
	IONPay.Utils.fnClearForm("frmModalUpd");
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalUpd").modal();
	$("#modalUpd #extraId").val(vid);
	$("#modalUpd #amt").val(amt);
	$("#modalUpd #payDt").val(dateLMaskOn(dt));
	$("#modalUpd select[name=selCD1]").select2("val", resrCl);
	$("#modalUpd select[name=selCD2]").select2("val", resrReason);
	$("#modalUpd input[name=oldExtraId]").val(vid);
	$("#modalUpd input[name=oldAmt]").val(amt);
	$("#modalUpd input[name=payDt]").val(dt);
	$("#modalUpd input[name=oldSelCD1]").val(resrCl);
	$("#modalUpd input[name=oldSelCD2]").val(resrReason);
	$("#modalUpd input[name=oldSeq]").val(seq);
	$("#modalUpd input[name=oldSetSeq]").val(setSeq);
	$("#modalUpd input[name=desc]").val(desc);
	
}
function fnModify(){
	if($("#modalUpd #extraId").val().length < 10){
		IONPay.Msg.fnAlertWithModal("정산ID를 입력하세요", "modalReg");
		$("#modalUpd #extraId").focus();
		return;
	}
	if($("#modalUpd #amt").val().length < 1){
		IONPay.Msg.fnAlertWithModal("금액을 입력하세요", "modalReg");
		$("#modalUpd #amt").focus();
		return;
	}
	if($("#modalUpd #payDt").val().length < 7){
		IONPay.Msg.fnAlertWithModal("지급월을 입력하세요", "modalReg");
		$("#modalUpd #payDt").focus();
		return;
	}
	var frMon = dateLMaskOff($("#modalUpd #payDt").val());
	var toMon = getToMon();
	if(frMon < toMon){
		IONPay.Msg.fnAlertWithModal("지급월은 현재월 이전일 수 없습니다.", "modalReg");
		$("#modalUpd #payDt").focus();
      	return;
	}
	if(confirm("수정하시겠습니까?")){
		arrParameter = $("#frmModalUpd").serializeObject();
		arrParameter["worker"] = strWorker;
		arrParameter["amt"] = IONPay.Utils.fnDelComma($("#frmModalUpd #amt").val());
		strCallUrl   = "/calcuMgmt/agencyStmtMgmt/updateAgentResrEtc.do";
		strCallBack  = "fnSaveRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}
function fnReqDel(resrCl, seq, amt){
	if(confirm("정말로 삭제하시겠습니까?")){
		arrParameter["resrCl"] = resrCl;
		arrParameter["seq"] = seq;
		arrParameter["amt"] = amt;
		strCallUrl   = "/calcuMgmt/agencyStmtMgmt/deleteAgentResrExtra.do";
		strCallBack  = "fnReqDelRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}
function fnReqDelRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("삭제되었습니다.");
		fnSearchList("SEARCH");
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnSearchList(strType){
	if(strType == "SEARCH"){
		if (typeof objAgentStmtInquiry == "undefined") {
			objAgentStmtInquiry  = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
	        url: "/calcuMgmt/agencyStmtMgmt/selectAgentResrEtcList.do",
	        data: function() {	
	            return $("#frmSearch").serializeObject();
	        },
	        columns: [
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RESR_DT==null?"":IONPay.Utils.fnStringToMonthDateFormat(data.RESR_DT)} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ID==null?"":data.ID} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.VGRP_NM==null?"":data.VGRP_NM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NO==null?"":data.CO_NO} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RESR_TYPE_NM==null?"":data.RESR_TYPE_NM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RESR_REASON==null?"":data.RESR_REASON_NM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RESR_AMT==null?"":IONPay.Utils.fnAddComma(data.RESR_AMT)} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REMAIN_AMT==null?"":IONPay.Utils.fnAddComma(data.REMAIN_AMT)} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RESR_DESC==null?"":data.RESR_DESC} },
	             { "class" : "columnc all",         "data" : null, "render": 
            	 	function(data){
            	 		var str = "";
            	 		if(strStmtFlg2 == "1"){
            	 			if(data.DP_FLG=="2" && data.PROC_FLG=="X"){
	            	 			return "<button type='button' onclick='fnReqModify(\""+data.RESR_TYPE+"\",\""+data.SEQ+"\",\""+data.RESR_AMT+"\",\""+data.RESR_DT+"\",\""+data.ID+"\",\""+data.RESR_REASON+"\",\""+data.RESR_SET_SEQ+"\",\""+data.RESR_DESC+"\");' class='btn btn-primary btn-cons'><spring:message code='IMS_BIM_HM_0002'/></button>";  
            	 			}else{
            	 				return "";
            	 			}
            	 		}else{
	            	 		return "권한없음";  
            	 		}
            	 	} 
	             },
	             { "class" : "columnc all",         "data" : null, "render": 
            	 	function(data){
            	 			if(strStmtFlg2 == "1"){
            	 				if(data.DP_FLG=="2" && data.PROC_FLG=="X"){
	            	 				return "<button type='button'  onclick='fnReqDel(\""+data.RESR_TYPE+"\",\""+data.SEQ+"\",\""+data.RESR_AMT+"\");'  class='btn btn-primary btn-cons'><spring:message code='IMS_BM_AM_0013'/></button>";
            	 				}else{
            	 					return "";
            	 				}
            	 			}else{
	            	 			return "권한없음";  
            	 			}
	             		}
	             	}
	            ]
		    }, true);
			
		} else {
			objAgentStmtInquiry.clearPipeline();
			objAgentStmtInquiry.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();
		IONPay.Utils.fnHideSearchOptionArea();
	}
	else{
		var $objFrmData = $("#frmSearch").serializeObject();
        
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/agencyStmtMgmt/selectAgentResrEtcListExcel.do");
	}    
}
//대리점정산 보류 금액 조회 
function fnSelectAgentRemainAmt() {
	arrParameter = $("#frmSearch").serializeObject();
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/selectAgentResrRemainAmt.do";
	strCallBack  = "fnSelectAgentRemainAmtRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectAgentRemainAmtRet(objJson){
	if(objJson.resultCode == 0 ){
			$("#remainAmt").html(objJson.REMAIN_AMT);
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
</script>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">       
            <div class="content">                
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.AGENCY_SETTLEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0122'/></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0058'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <div class="row form-row"   >
                                    	<div class="col-md-2" >
                                   			<label class="form-label"><spring:message code="IMS_BIM_BM_0631"/></label>
                                   			<select id="frYear" name="frYear"  style="width: 80%;" class="select2 form-control">
                              				</select>
                              				<span style="float: right;margin: -8% 8%; "><spring:message code="DDLB_0091" /></span>
                          				</div>
                          				<div class="col-md-2" >
                                   			<label class="form-label">&nbsp;</label>
                                   			<select id="frMon"name="frMon"  style="width: 80%;"class="select2 form-control">
                                       		</select>
                                       		<span style="float: right; margin: -8% 8%;"><spring:message code="IMS_BIM_BM_0628" /></span>
                          				</div>
                          				<div class="col-md-1" >
                          					<label class="form-label">&nbsp;</label>
                          					<span style="margin-left: -15%;">~</span>
                          				</div>
                          				<div class="col-md-2"   style="margin-left: -5%;">
                                   			<label class="form-label">&nbsp;</label>
                                   			<select id="toYear" name="toYear"  style="width: 80%;" class="select2 form-control">
                              				</select>
                              				<span style="float: right;margin: -8% 8%; "><spring:message code="DDLB_0091" /></span>
                          				</div>
                 				         <div class="col-md-2" >
                                   			<label class="form-label">&nbsp;</label>
                                   			<select id="toMon"name="toMon"  style="width: 80%;"class="select2 form-control">
                                       		</select>
                                       		<span style="float: right; margin: -8% 8%;"><spring:message code="IMS_BIM_BM_0628" /></span>
                          				</div>
                      				</div>
                      				<div class="row form-row" style="padding:10px 0 0 0;" >
                      					<div class="col-md-3" >
                      						<label class="form-label"><spring:message code="DDLB_0139" /></label>
                      						<input type="text" id="vid" name="vid" maxlength="10" class="form-control"  >
                      					</div>
                      					<div class="col-md-9" ></div>
                  					</div>
                  					<div class="row form-row" style="padding:10px 0 0 0;" >
                  						<div class="col-md-2" >
                      						<label class="form-label"><spring:message code="IMS_BIM_BM_0101" /></label>
                      						<select id="selCD1" name="selCD1" onchange='fnSelCD(this.value);' 	  class="select2 form-control" ></select>
                   						</div>
                   						<div class="col-md-2" >
                   							<label class="form-label">&nbsp;</label>
                      						<select id="selCD2" name="selCD2"  class="select2 form-control" ></select>
                   						</div>
                   						<div class="col-md-4" ></div>
                   						<div class="col-md-4" >
                   							<label class="form-label">&nbsp;</label>
                   							<button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_CCS_0005'/></button>
                          					<button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
                          					<button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code='IMS_SM_SRM_0053'/></button>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <div id="div_searchResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="" class="table" style="width:50%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0582'/></th>
                                                     <td id="remainAmt" style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'></td>
                                                 </tr>
                                            	</thead>
                                            </table>
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0565'/></th>
                                                     <th ><spring:message code='DDLB_0139'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0418'/></th>
                                                     <th ><spring:message code='IMS_BIM_MM_0054'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0579'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0580'/></th>  
			                                         <th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0009'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0007'/></th>
                                                     <th ><spring:message code='IMS_AM_MM_0003'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0322'/></th>
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
    	<!-- END CONTAINER -->
<!-- BEGIN MODAL -->
    
		<div class="modal fade" id="modalReg"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0600"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		            <form id="frmModalReg" id="frmModalReg">
		                <div class="row form-row">
		                    <table class="table" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0579"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<select id="selCD1" name="selCD1" onchange='fnSelCD(this.value);' 	 class="select2 form-control">
                                       		</select>
                                   		</td>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0580"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<select id="selCD2" name="selCD2"  class="select2 form-control">
                                       		</select>
                                   		</td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="DDLB_0139"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<input type="text" id="extraId" name="extraId" maxlength="10" class="form-control" >
                               			</td>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0131"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<input type="text" id="amt" name="amt" maxlength="13" class="form-control"  onkeyup="javascript:setSignalMaskOn(this);" >
                               			</td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0627"/></th>
                                		<td style='text-align:center; background-color:#FAFAFA;' colspan="3" > 
                                			<input type="text" id="payDt" name="payDt" maxlength="7" class="form-control"  onkeyup="fnReplaceDate(this);" style="width: 30%;">
                               			</td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_SM_SRM_0007"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' colspan="3" >
                                			<input type="text" id="desc" name="desc" maxlength="100" class="form-control"  style="width:50%;" >
                               			</td>
                                	</tr>
                                 </thead>
                           </table>
                         </div>
                       </form>  
	            	</div>
		            <div class="modal-footer">
		            	<button type="button" class="btn btn-default"  onclick="fnSave();"	><spring:message code="IMS_BIM_BM_0138"/></button>
		                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="IMS_BIM_BM_0175"/></button>
		            </div>
	            </div>
	        </div>
	    </div>
  	
	<!-- END MODAL -->
	<!-- BEGIN MODAL -->
		<div class="modal fade" id="modalUpd"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0600"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		            	<form id="frmModalUpd">
			                <div class="row form-row">
			                	<input type="hidden" name="oldSeq" value=""/>
			                	<input type="hidden" name="oldSetSeq" value=""/>
			                	<input type="hidden" name="oldExtraId" value=""/>
			                	<input type="hidden" name="oldAmt" value=""/>
	                      		<input type="hidden" name="oldSelCD1" value=""/>
	                      		<input type="hidden" name="oldSelCD2" value=""/>
			                    <table class="table" style="width:100%; border:1px solid #ddd;">
	                                <thead >
	                                	<tr>
	                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0579"/></th>
	                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
	                                			<select id="selCD1" name="selCD1" onchange='fnSelCD(this.value);' 	 class="select2 form-control">
	                                       		</select>
	                                   		</td>
	                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0580"/></th>
	                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
	                                			<select id="selCD2" name="selCD2"  class="select2 form-control">
	                                       		</select>
	                                   		</td>
	                                	</tr>
	                                	<tr>
	                                		<th class="th_verticleLine"><spring:message code="DDLB_0139"/></th>
	                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
	                                			<input type="text" id="extraId" name="extraId" maxlength="10" class="form-control" >
	                               			</td>
	                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0131"/></th>
	                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
	                                			<input type="text" id="amt" name="amt" maxlength="13" class="form-control"  onkeyup="javascript:setSignalMaskOn(this);" >
	                               			</td>
	                                	</tr>
	                                	<tr>
	                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0627"/></th>
	                                		<td style='text-align:center; background-color:#FAFAFA;' colspan="3" > 
	                                			<input type="text" id="payDt" name="payDt" maxlength="7" class="form-control"  onkeyup="fnReplaceDate(this);" style="width: 30%;">
	                               			</td>
	                                	</tr>
	                                	<tr>
	                                		<th class="th_verticleLine"><spring:message code="IMS_SM_SRM_0007"/></th>
	                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' colspan="3" >
	                                			<input type="text" id="desc" name="desc" maxlength="100" class="form-control"  style="width:50%;" >
	                               			</td>
	                                	</tr>
	                                 </thead>
	                           </table>
	                         </div>
                         </form>
	            	</div>
		            <div class="modal-footer">
		            	<button type="button" class="btn btn-default"  onclick="fnModify();"	><spring:message code="IMS_BIM_BM_0138"/></button>
		                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="IMS_BIM_BM_0175"/></button>
		            </div>
	            </div>
	        </div>
	    </div>
	<!-- END MODAL -->