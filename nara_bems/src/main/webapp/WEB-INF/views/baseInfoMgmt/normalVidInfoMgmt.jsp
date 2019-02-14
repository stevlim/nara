<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objInquiryApprove;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var map = new Map();
var typeChk; 
$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
    
    $("#btnSearch").click();
});

function fnSetDDLB() {
	$("#notiEncoding").html("<c:out value='${ENCODING_TYPE}' escapeXml='false' />");
	$("#normalBankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
}

function fnInit(){
}

function fnInitEvent() {	 
	$("#btnSearch").on("click", function(){
		fnSelectBaseInfo();
    });
}

function fnSelectBaseInfo(){
	arrParameter = $("#frmSearch").serializeObject();
	
	/* arrParameter["MER_VAL"]    = '2';
	arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
	arrParameter["MER_TYPE"]    = "ALL"; */
	
	//strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectBaseInfo.do";
	strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/selectNormalVidInfo.do";
	strCallBack  = "fnSelectBaseInfoRet";
	
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

//조회된 데이터 화면에 뿌리기
function fnSelectBaseInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.midInfo != null){
			if(objJson.midInfo.length > 0 ){
				
				$("#normalVID").text(objJson.midInfo[0].VID);
				$("#normalVNm").text(objJson.midInfo[0].VGRP_NM);
				$("#normalCoNo").text(objJson.midInfo[0].CO_NO);
				$("#normalRepNm").text(objJson.midInfo[0].REP_NM);
				$("#normalBsKind").text(objJson.midInfo[0].BS_KIND);
				$("#normalGdKind").text(objJson.midInfo[0].GD_KIND);
				$("#normalEmail").val(objJson.midInfo[0].EMAIL);
				
				var useType = "";
				
				if(objJson.midInfo[0].USE_TYPE == "0") {
					useType = $("#normalStatusChk0").val();
				}else if(objJson.midInfo[0].USE_TYPE == "1") {
					useType = $("#normalStatusChk1").val();
				}else if(objJson.midInfo[0].USE_TYPE == "2") {
					useType = $("#normalStatusChk2").val();
				}else {}
				
				$("#normalStatusChk").text(useType);
				$("#normalAddress1").val(objJson.midInfo[0].POST_NO);
				$("#normalAddress2").val(objJson.midInfo[0].ADDR_NO1);
				$("#normalAddress3").val(objJson.midInfo[0].ADDR_NO2);

				$("#normalBankCd").select2("val", objJson.midInfo[0].BANK_CD);
				$("#normalVaNo").val(objJson.midInfo[0].ACCNT_NO);
				$("#normalVaNm").val(objJson.midInfo[0].ACCNT_NM);
				$("#normalSettleCycle").select2("val", objJson.midInfo[0].STMT_CYCLE_CD);
				$("#normalRegCashPer").val(objJson.midInfo[0].RSHARE_RATE);
				
				$("#settMinCashPer").text(objJson.midInfo[0].MIN_CASH_PER + "%");
				$("#settProfitSharPer").text(objJson.midInfo[0].PROFIT_SHARE_PER + "%");
				$("#settSaveDt").text(IONPay.Utils.fnStringToDateFormat(objJson.midInfo[0].SAVE_DT));
				
				
				
			}
		}
        IONPay.Utils.fnJumpToPageTop();
	}else{
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}

function fnUpdateNormalInfo() {
	var clearReqChk = confirm("일반정보를 저장 하시겠습니까?");
	
	if(clearReqChk == true) {
		arrParameter = $("#normalInfo").serializeObject();
		arrParameter["WORKER"] = $("#WORKER").val();
		/* arrParameter["TID"] = tid;
		arrParameter["TRX_STAT_CD"] = trxStatCd; */
		
		strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/updateNormalVidInfo.do";
		strCallBack  = "fnClearUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}else {
		return;
	}
}

function fnEtcCancelPwRegist() {
	var clearReqChk = confirm("거래취소 비밀번호를 저장 하시겠습니까?");
	
	if(clearReqChk == true) {
		if($("#etcPw").val() != $("#etcRePw").val()) {
			alert("비밀번호 입력이 맞지 않습니다.");
			return;
		}
		
		if($("#etcPw").val().length!=6 || $("#etcRePw").val().length!=6) {
			alert("비밀번호는 6자리 입니다.");
			return;
		}
		
		arrParameter = $("#etcInfo").serializeObject();
		arrParameter["WORKER"] = $("#WORKER").val();
		
		strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/updateCancelTransPw.do";
		strCallBack  = "fnClearUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}else {
		return;
	}
}

function fnUpdateNormalTelInfo() {
	var clearReqChk = confirm("담당자 연락처를 저장 하시겠습니까?");
	
	if(clearReqChk == true) {
		arrParameter = $("#telInfo").serializeObject();
		arrParameter["WORKER"] = $("#WORKER").val();
		/* arrParameter["TID"] = tid;
		arrParameter["TRX_STAT_CD"] = trxStatCd; */
		
		strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/updateNormalTelInfo.do";
		strCallBack  = "fnClearUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}else {
		return;
	}
}

function fnNotiRegist() {
	var clearReqChk = confirm("결제 통보 정보를 저장 하시겠습니까?");
	
	if(clearReqChk == true) {
		arrParameter = $("#notiInfo").serializeObject();
		arrParameter["WORKER"] = $("#WORKER").val();
		/* arrParameter["TID"] = tid;
		arrParameter["TRX_STAT_CD"] = trxStatCd; */
		
		strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/updateNotiTransInfo.do";
		strCallBack  = "fnClearUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}else {
		return;
	}
}

function fnClearUpdateRet(objJson){
	if (objJson.resultCode == 0) {
		IONPay.Msg.fnAlert("저장 완료되었습니다.");
        IONPay.Utils.fnJumpToPageTop();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
	
	//$("#btnSearch").click();
}

</script>
<style>
.checkbox_center label::after {
  left:1px;
}
</style>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <!-- BEGIN PAGE -->         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><c:out value="${MENU_SUBMENU_TITLE }" /></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                
                <!-- BEGIN VIEW OPTION AREA -->
                <div class = "row">
                	<div class = "col-md-12">
                		<div class = "grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_TV_TH_0050" /></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                            <input type="hidden" id="directMerchant" value="<spring:message code="DDLB_0140" />">
                            <input type="hidden" id="notDirectMerchant" value="<spring:message code="DDLB_0141" />">
                            	<form id = "frmSearch" name = "frmsearch">
                            		
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
                            			<div class = "col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_TV_TH_0051" /></label> 
                            				<select id = "MER_SEARCH" name = "MER_SEARCH" class = "select2 form-control">
                            					<option value="<c:out value="${MID }" />"><c:out value="${MID }" /></option>
                            				</select>
                            			</div>
	                                    <div class="col-md-6">
                                            <label class="form-label">&nbsp;</label>
                                            <div style="padding-left: 10%">
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_TV_TH_0053" /></button>
                                            </div>
                                        </div>
                            		</div>  
                            	</form>
                            </div>
                		</div>
                	</div>
                </div>
                <!-- END VIEW OPTION AREA -->
                
                <!-- BEGIN Information VIEW AREA -->
                <div id="midRegInfo"  >
                	<input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
	            
                 
               <!-- END Information VIEW AREA -->  
                <!-- BEGIN Other Information VIEW AREA -->
	                <form id="normalInfo" name="normalInfo">
                	
                	<!-- vid 일반정보 start -->
                    <div class = "row" id = "Information">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_BM_0047" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="vidInformationCollapse" class="collapse"></a></div>
       		                 </div>
       		                 <div class="grid-body">
       		                 <!-- START VID NORMAL VIEW AREA -->
	                         	<div class="row" id="normaltVInfo">
	                         		<table class="table" id="tbNomalVidInfo"  style="width:100%;">
		                                <tbody>
		                                	<tr>
			                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0139" /></td>
			                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px" colspan="9">
													<div class="form-inline" style="margin:0;padding:0;">
														<div id="normalVID" name="normalVID" class="form-group" style="margin:0;padding:0;float:left;width:100%;">
															<%-- <input type="text" class="form-control" id="normalVID" name="normalVID" style="width:40%;float:left">
															<label for="VID" style="margin: 17px 13px 0px 2px; display:inline;float:left">v</label>
															<button type='button'  id="btnDupVid" onclick="fnDupIdChk(VID.value , 'VID');" class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; float:left; background-color:white; color:#666; margin:0;'>
																<spring:message code="IMS_BIM_BIR_0014"/>
															</button> --%>
														</div>
													</div>
												 </td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0434" /></td>
		                                     	<td id="normalVNm"  name="normalVNm" style="text-align:center; border:1px solid #c2c2c2;" colspan="9">
	                            					<!-- <input type="text" id="normalVNm"  name="normalVNm" class="form-control" style="float:left; width:30%;" > -->
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0083" /></td>
		                                     	<td id="normalCoNo" name="normalCoNo" style="text-align:center; border:1px solid #c2c2c2;" colspan="9">
	                            					<!-- <input type="text"  id="normalCoNo" name="normalCoNo" class="form-control" style="float:left; width:30%;" > -->
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0143" /></td>
		                                     	<td id="normalRepNm" name="normalRepNm" style="text-align:center; border:1px solid #c2c2c2;" colspan="9">
	                            					<!-- <input type="text"  id="normalRepNm" name="normalRepNm" class="form-control" style="float:left; width:30%;" > -->
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0120" /></td>
		                                     	<td  id="normalBsKind" name="normalBsKind" style="text-align:center; border:1px solid #c2c2c2;" colspan="4">
	                            					<!-- <input type="text"  id="normalBsKind" name="normalBsKind" class="form-control" style="float:left;" > -->
	                           				 	</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0119" /></td>
		                                     	<td id="normalGdKind" name="normalGdKind" style="text-align:center; border:1px solid #c2c2c2;" colspan="4">
	                            					<!-- <input type="text"  id="normalGdKind" name="normalGdKind" class="form-control" style="float:left; width:80%;" > -->
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;">E-MAIL</td>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="4">
	                            					<input type="text"  id="normalEmail" name="normalEmail" class="form-control" style="float:left;" >
	                           				 	</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0435" /></td>
		                                     	<td id="normalStatusChk" name="normalStatusChk" style="text-align:center; border:1px solid #c2c2c2;" colspan="4">
	                            					<%-- <select class = "select2 form-control" id="normalStatusChk" name="normalStatusChk" style="width:30%;">
	                            						<option value='0' selected=true><spring:message code="IMS_BIM_BIR_0025" /></option>
		                            					<option value='1'><spring:message code="IMS_BIM_BIR_0026" /></option>
		                            					<option value='2'><spring:message code="IMS_BIM_BIR_0027" /></option>
	                            					</select> --%>
	                            					
	                            					<input type="hidden"  id="normalStatusChk0" value="<spring:message code="IMS_BIM_BIR_0025" />" >	<!-- 사용 -->
	                            					<input type="hidden"  id="normalStatusChk1" value="<spring:message code="IMS_BIM_BIR_0026" />" >	<!-- 중지( MMS 로그인 가능, 거래 불가 ) -->
	                            					<input type="hidden"  id="normalStatusChk2" value="<spring:message code="IMS_BIM_BIR_0027" />" >	<!-- 해지( MMS 로그인 불가, 거래 불가 ) -->
	                           				 	</td>
		                                	</tr>
		                                	<tr>
			                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><span><spring:message code="IMS_BIM_BIM_0028" /></span></td>
			                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="9">
			                                     	<div class="col-md-1" style='width:55px;'>
														<button type='button' onclick="javascript:fnPostSearch('3');" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
															<span class="glyphicon glyphicon-home" aria-hidden="true" style="color:orange"></span>
														</button>
			                                     	</div>
			                                     	<div class="col-md-3">
		                                         		<input type="text" id="normalAddress1" name="normalAddress1" class="form-control" readonly>
			                                     	</div>
			                                     	<div class="col-md-5">
		                                         		<input type="text" id="normalAddress2" name="normalAddress2" class="form-control" readonly>
			                                     	</div>
		                                         </td>
		                                	</tr>
		                                	<tr>
		                                		<td style="text-align:center; border:1px solid #c2c2c2;" colspan="9">
		                                			<div class="col-md-9">
		                                         		<input type="text" id="normalAddress3" name="normalAddress3" class="form-control">
			                                     	</div>
		                                		</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0416" /></td>
		                                     	<td style="border:1px solid #c2c2c2;" colspan="9">
	                            					<select class = "select2 form-control" id="normalBankCd" name="normalBankCd" style="width:30%;"></select>
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0417" /></td>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="4">
	                            					<input type="text" id="normalVaNo" name="normalVaNo" class="form-control" style="float:left; width:80%;">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left"><spring:message code="IMS_BIM_BM_0430" /></label>
	                           				 	</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="4">
	                            					<input type="text" id="normalVaNm" name="normalVaNm" class="form-control" style="float:left; width:60%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left"><spring:message code="IMS_BIM_BM_0430" /></label>
	                            					<%-- <button type='button'  id="btnVaChk"class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; float:left; background-color:white; color:#666; margin:0;'>
														<spring:message code="IMS_BIM_BM_0436"/>
													</button> --%>
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0079" /></td>
		                                     	<td style="border:1px solid #c2c2c2;" colspan="4">
	                            					<select class = "select2 form-control" id="normalSettleCycle" name="normalSettleCycle">
	                            						<option value='0' selected=true>결제월+1개월째 5일</option>
	                            					</select>
	                           				 	</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0419" /></td>
		                                     	<td style="border:1px solid #c2c2c2;" colspan="4">
	                            					<input type="text" id="normalRegCashPer" name="normalRegCashPer" class="form-control" style="float:left; width:60%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
	                           				 	</td>
		                                	</tr>
		                                </tbody>
		                            </table>
		                            <div class="col-md-11"></div>
                           			<div class="col-md-1">
	                             		<button type='button' class='btn btn-info btn-cons'  id="btnVidReg"  onclick="fnUpdateNormalInfo();" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
											<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0020" />
										</button>
									</div>
	                          	 </div>
	                          	 <!-- END VID NORMAL VIEW AREA -->
                          	  </div>
           	              </div>
               	        </div>
                     </div>
                    	
                    <!-- vid 일반정보 end -->
                	
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               <!-- BEGIN Other Information VIEW AREA -->
	                <form id="depositInfo" name="depositInfo">
                	
                	<!-- START VID SETTLE VIEW AREA -->
	                     <div class = "row" id = "settleVInfo">
		                	<div class = "col-md-12">
		                      <div class="grid simple horizontal light-grey">
		                        <div class="grid-title" >
		                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0012" /></span></h4>
		                          <div class="tools"> <a href="javascript:;" id="settleVInfoCollapse" class="collapse"></a></div>
		                        </div>
		                        <div class="grid-body" >
		                          <div class="row" id="settleVInfo">
	                         		<table class="table" id="tbSettleVidInfo"  style="width:100%;">
		                                <thead id="thFeeInfo">
		                                	<tr>
		                                		<!-- <th>NO</th> -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0420" /></th><!-- 결제 서비스 -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0310" /></th><!-- 수수료 -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0421" /></th><!-- 최소원가 -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0437" /></th><!-- 수익배분 -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0423" /></th><!-- 적용 시작일 -->
		                                	</tr>
			                                <tr>
			                                	<!-- <td class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">1</td> -->
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">이롬머니</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0438" /></td>
			                                	<td id="settMinCashPer" name="settMinCashPer" style="text-align:center; border:1px solid #c2c2c2;">
			                                		<!-- <input type="text" id="settMinCashPer" name="settMinCashPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label> -->
			                                	</td>
			                                	<td id="settProfitSharPer" name="settProfitSharPer" style="text-align:center; border:1px solid #c2c2c2;">
			                                		<!-- <input type="text" id="settProfitSharPer" name="settProfitSharPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label> -->
			                                	</td>
			                                	<td id="settSaveDt" name="settSaveDt" style="text-align:center; border:1px solid #c2c2c2;">
			                                		<!-- <input type="text" id="settSaveDt" name="settSaveDt" class="form-control" style="float:left;"> -->
			                                	</td>
			                                </tr>
		                                </thead>
		                                <tbody id="trFeeRegInfo"  style="width: 100%;">
	                                </tbody> 
	                                <tbody id="trFeeInfo" style="display: none; width: 100%;"> </tbody>
		                            </table>	
                            		<div class="col-md-11"></div>
                           			
									<%-- <div class="col-md-1" id="insertFee">
	                             		<button type='button' class='btn btn-info btn-cons'  id="btnVidCalReg"  onclick="fnVidCalRegist(typeChk);" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
											<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0019" />
										</button>
									</div> --%>
		                          </div>
		                        </div>
		                	</div>
		                </div>
		          	 </div> 
		          	 <!-- END VID SETTVIEW AREA -->
                	
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               
               
               
	            </div>
           </div>
           
           <div id="layer"  style="display:none; position:fixed;overflow:hidden; z-index:1; -webkit-overflow-scrolling:touch;">
				<img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnClose" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
			</div>
		
        </div>
        
        

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }

    function fnPostSearch(chk) {
        new daum.Postcode({
            oncomplete: function(data) {
                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                if(chk == '1'){
	                document.getElementById('Address1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('Address2').value = fullAddr;
                }else if (chk == '2'){
                	document.getElementById('BusinessAddr1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('BusinessAddr2').value = fullAddr;
                }else if(chk == '3'){
                	//vid
	                $("#tbNomalVidInfo #Address1").val( data.zonecode); //5자리 새우편번호 사용
	                $("#tbNomalVidInfo #Address2").val( fullAddr);
                }

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 300; //우편번호서비스가 들어갈 element의 width
        var height = 400; //우편번호서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>        