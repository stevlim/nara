<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strStmtFlg = "<c:out value='${SETT_AUTH_FLG2}' escapeXml='false' />";
var objListInquriy;

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();

});

function fnInitEvent() {
	$("#div_search").hide();
	$("#selCD2").html("<option value='ALL'>모두</option>");

   	$("select[name=division]").on("change", function(){
   		if($.trim(this.value)=="ALL"){
   			$("#id").val("");
   			$("#frmSearch #id").attr("readonly", true);
   		}else{
   			$("#frmSearch #id").attr("readonly", false);
   		}
   	});

    $("#btnSearch").on("click", function() {
    	if($("#division").val() != "ALL" && $("#id").val().length < 10){
    		IONPay.Msg.fnAlert('10자의 처리 ID를 입력하세요');
    		$("#id").focus();
    		return;
    	}
    	$("#div_search").show(200);
    	fnSelectAmtChk();
    	fnSelectListInquriy("SEARCH");
    });
    $("#btnExcel").on("click", function() {
    	fnSelectListInquriy("EXCEL");
    });
    $("#btnRegist").on("click", function() {
    	$("body").addClass("breakpoint-1024 pace-done modal-open ");
    	$("#modalReg").modal();
    	$('#frmModalReg input[name="extraId"]').val("");
    	$('#frmModalReg input[name="amt"]').val("");
    	$('#frmModalReg input[name="offId"]').val("");
    	$('#frmModalReg input[name="desc"]').val("");
   	});

}
function fnSetDDLB(){
	$("select[name=division]").html("<c:out value='${division}' escapeXml='false' />");
	$("select[name=selCD1]").html("<c:out value='${LstCardCode}' escapeXml='false' />");

	$("#modalReg select[name=selCD1]").html("<c:out value='${LstCardCode1}' escapeXml='false' />");

	$("#modalReg select[name=selCD2]").html("<c:out value='${typeList1}' escapeXml='false' />");
}
function fnSelCD(cd){

	arrParameter["code1"] = cd;
    strCallUrl   = "/calcuMgmt/reportMgmt/selectCode2List.do";
    strCallBack  = "fnSelCdRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelCdRet(objJson){
	if(objJson.resultCode == 0){
		$("#selCD2").html(objJson.typeList);
		$("#modalReg select[name=selCD2]").html(objJson.typeList1);
	}else{
		IONPay.Msg.fnAlert("fail");
	}
}
function fnSave(){
	if($("input[name=extraId]").val() < 10){
		IONPay.Msg.fnAlert("정산ID를 입력하세요");
		$("input[name=extraId]").focus();
	    return;
	}
	if($("input[name=amt]").val() < 10){
		IONPay.Msg.fnAlert("금액을 입력하세요");
		$("input[name=amt]").focus();
	    return;
	}
	if($("input[name=payDt]").val() < 10){
		IONPay.Msg.fnAlert("지급일자를 입력하세요");
		$("input[name=payDt]").focus();
	    return;
	}
	var inDay =$("input[name=payDt]").val().split("-");
	var fromDay = inDay[2]+inDay[1]+inDay[0];
	var toDay = fnToDay();
	if(fromDay  < toDay) {
	   	 IONPay.Msg.fnAlert('지급일자는 당일 이전은 불가능합니다.\n다시 입력해주세요.');
	   	$("input[name=payDt]").focus();
	  	 return;
	}

	if(confirm('저장 하시겠습니까?') == false){
		return
	}else{
		fnRegistResr();
	}

}
//보류/해제/별도가감 등록
function fnRegistResr() {
	arrParameter = $("#frmModalReg").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/reportMgmt/insertResr.do";
	strCallBack  = "fnRegistResrRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnRegistResrRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalReg").modal("hide");
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
//보류잔액 조회
function fnSelectAmtChk() {
	arrParameter = $("#frmSearch").serializeObject();
	strCallUrl   = "/calcuMgmt/reportMgmt/selectAmtChk.do";
	strCallBack  = "fnSelectAmtChkRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectAmtChkRet(objJson){
	if(objJson.resultCode == 0 ){
		var remainAmt = objJson.amt;
		$("#div_searchResult #remainAmt").html(remainAmt);
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnSelectListInquriy(strType){
	if(strType == "SEARCH"){
	   	if (typeof objListInquriy == "undefined") {
	   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbResrListSearch", true, {
	               url: "/calcuMgmt/reportMgmt/selectResrList.do",
	               data: function() {
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.RESR_DT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CO_NM==null?"":data.CO_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ID==null?"":data.ID} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_TYPE_NM==null?"":data.RESR_TYPE_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_REASON==null?"":data.RESR_REASON} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_AMT==null?"":IONPay.Utils.fnAddComma(data.RESR_AMT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REMAIN_AMT==null?"":IONPay.Utils.fnAddComma(data.REMAIN_AMT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_DESC==null?"":data.RESR_DESC} },
					   { "class" : "columnc all", 			"data" : null, "render":
						   function(data){
						   		if(strStmtFlg == "1"){
						   			if((data.DP_FLG==null?"":data.DP_FLG ) == "2" && (data.PROC_FLG==null?"":data.PROC_FLG)=="X"){
								   		return "<button type='button' class='btn btn-primary btn-cons'><spring:message code='IMS_AM_MM_0003'/></button>"
						   			}else{
						   				return "권한없음";
						   			}
						   		}else{
						   			return "권한없음";
						   		}
						   	}
					   },
	                   { "class" : "columnc all", 			"data" : null, "render":
	                	   function(data){
		                	   if(strStmtFlg == "1"){
		                		   if((data.DP_FLG==null?"":data.DP_FLG ) == "2" && (data.PROC_FLG==null?"":data.PROC_FLG)=="X"){
			                	   		return "<button type='button' class='btn btn-primary btn-cons'><spring:message code='IMS_AM_MM_0004'/></button>"
						   			}else{
						   				return "권한없음";
						   			}
						   		}else{
						   			return "권한없음";
						   		}
	               	   		}
	                   }
	               ]
	       }, true);
	    } else {
	       objListInquriy.clearPipeline();
	       objListInquriy.ajax.reload();
	    }

		IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/reportMgmt/selectResrListExcel.do");
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.REPORT_CREATION }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0105'/></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_MENU_SUB_0105'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <div class="row form-row"   >
		                                <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_PW_DE_08" /></label>
                                        	<select id="division" name="division"   class="select2 form-control">
                                       		</select>
	                                    </div>
	                                    <div class="col-md-3" >
											<label class="form-label">&nbsp;</label>
                                        	<input type="text" id="id" name="id" maxlength="10" class="form-control"  >
	                                    </div>
                                        <div class="col-md-6"></div>
                                    </div>
                                    <div class="row form-row"   >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0565'/></label>
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding" >
                                                <input type="text" id=txtFromDate name="txtFromDate" class="form-control">
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
                                        <div id="divSearchDateType4" class="col-md-4">
	                                        <label class="form-label">&nbsp;</label>
	                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>
	                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
	                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
	                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
	                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
	                                    </div>
	                                    <div class="col-md-2"></div>
                                    </div>
                                    <div class="row form-row"   >
		                                <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_SM_SRM_0056" /></label>
                                        	<select id="selCD1" name="selCD1" onchange='fnSelCD(this.value);'  class="select2 form-control">
                                       		</select>
	                                    </div>
	                                    <div class="col-md-3" >
											<label class="form-label">&nbsp;</label>
                                        	<select id="selCD2" name="selCD2"  style="display:block;" class="select2 form-control">
                                       		</select>
	                                    </div>
                                        <div class="col-md-3"></div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_CCS_0005'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
				                                  <button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BIR_0019'/></button>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <div id="div_searchResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbAmtInfo" class="table" style="width:50%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0582'/></th>
                                                     <td id="remainAmt" style='text-align:center; border:1px solid #ddd; '></td>
                                                 </tr>
                                            	</thead>
                                            </table>
                                           	<label><spring:message code='IMS_BIM_BM_0578'/></label>
                                            <table id="tbResrListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0565'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0194'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0579'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0580'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0009'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0007'/></th>
                                                     <th ><spring:message code='IMS_AM_MM_0003'/></th>
                                                     <th ><spring:message code='IMS_AM_MM_0004'/></th>
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
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    	<!-- END CONTAINER -->
<!-- BEGIN MODAL -->
    <form id="frmModalReg">
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
		                <div class="row form-row">
		                    <table class="table" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0579"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<select name="selCD1"  onchange='fnSelCD(this.value);'  class="select2 form-control">
                                       		</select>
                                   		</td>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0580"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<select name="selCD2"  class="select2 form-control">
                                       		</select>
                                   		</td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0597"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<input type="text" id="extraId" name="extraId" maxlength="10" class="form-control" >
                               			</td>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0131"/></th>
                                		<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                			<input type="text" id="amt" name="amt" maxlength="13" class="form-control"  onkeyup="javascript:setSignalMaskOn(this);" >
                               			</td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0598"/></th>
                                		<td style='text-align:center; background-color:#FAFAFA;'>
                                			<input type="text" id="offId" name="offId" maxlength="10" class="form-control" >
                               			</td>
                                		<td class="th_verticleLine" colspan="2" style='text-align:left; background-color:#FAFAFA;'>
                                			<spring:message code="IMS_BIM_BM_0599"/>
                               			</td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0400"/></th>
                                		<td style='text-align:center;  border:1px solid #ddd; background-color:#FAFAFA;' colspan="3" >
                                			<div class="input-append success date col-md-10 col-lg-10 no-padding" style="width:40%;">
                                               <input type="text" id="payDt" name="payDt" class="form-control">
                                               <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                                           </div>
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
	            	</div>
		            <div class="modal-footer">
		            	<button type="button" class="btn btn-default"  onclick="fnSave();"	><spring:message code="IMS_BIM_BM_0138"/></button>
		                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="IMS_BIM_BM_0175"/></button>
		            </div>
	            </div>
	        </div>
	    </div>
  	</form>
	<!-- END MODAL -->