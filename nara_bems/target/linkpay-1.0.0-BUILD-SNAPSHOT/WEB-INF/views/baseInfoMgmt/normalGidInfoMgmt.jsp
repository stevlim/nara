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
	strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/selectNormalGidInfo.do";
	strCallBack  = "fnSelectBaseInfoRet";
	
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

//조회된 데이터 화면에 뿌리기
function fnSelectBaseInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.midInfo != null){
			if(objJson.midInfo.length > 0 ){
				
				$("#normalGID").text(objJson.midInfo[0].GID);
				$("#normalIssuDt").text(IONPay.Utils.fnStringToDateFormat(objJson.midInfo[0].REG_DT));
				$("#normalGNm").text(objJson.midInfo[0].G_NM);
				$("#normalCoNo").text(objJson.midInfo[0].CO_NO);
				$("#normalVaNo").val(objJson.midInfo[0].VGRP_NO);
				$("#normalVaNm").val(objJson.midInfo[0].VGRP_NM);
				$("#normalContNm1").val(objJson.midInfo[0].EMP1_NM);
				$("#normalContTel1").val(objJson.midInfo[0].EMP1_TEL);
				$("#normalContCp1").val(objJson.midInfo[0].EMP1_CP);
				$("#normalContEmail1").val(objJson.midInfo[0].EMP1_EMAIL);
				$("#normalContNm2").val(objJson.midInfo[0].EMP2_NM);
				$("#normalContTel2").val(objJson.midInfo[0].EMP2_TEL);
				$("#normalContCp2").val(objJson.midInfo[0].EMP2_CP);
				$("#normalContEmail2").val(objJson.midInfo[0].EMP2_EMAIL);
				$("#normalBankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
				$("#normalBankCd").select2("val", objJson.midInfo[0].BANK_CD);
				
				$("#settMinCashPer").text(objJson.midInfo[0].MIN_CASH_PER + "%");
				$("#settSaveDt").text(IONPay.Utils.fnStringToDateFormat(objJson.midInfo[0].SAVE_DT));
				
				/* //일반정보
				$("#normalCoNm").text(objJson.midInfo[0].CO_NM);
				$("#normalMid").text(objJson.midInfo[0].MID);
				$("#normalRepNm").text(objJson.midInfo[0].REP_NM);
				
				$("#normalCoNo").text(objJson.midInfo[0].CO_NO);
				$("#normalRepTel").val(objJson.midInfo[0].TEL_NO);
				$("#normalRepMail").val(objJson.midInfo[0].EMAIL);
				
				$("#normalBsKind").text(objJson.midInfo[0].BS_KIND);
				$("#normalGdKind").text(objJson.midInfo[0].GD_KIND);
				$("#normalSignNm").val(objJson.midInfo[0].SIGN_NM);
				
				$("#normalUrl").text(objJson.midInfo[0].MID_URL);
				$("#normalAddress").text(objJson.midInfo[0].ADDR);
				
				
				//입금 정보
				$("#depositBankNm").text(objJson.midInfo[0].BANK_NM);
				$("#depositDepositNm").text(objJson.midInfo[0].ACCNT_NM);
				$("#depositAcctNo").text(objJson.midInfo[0].ACCNT_NO);
				
				$("#depositEromCash").text(objJson.midInfo[0].EROM_FEE + "%");
				
				
				//담당자 연락처
				$("#telContNm").val(objJson.midInfo[0].CONT_EMP_NM);
				$("#telContMail").val(objJson.midInfo[0].CONT_EMP_EMAIL);
				$("#telContTel").val(objJson.midInfo[0].CONT_EMP_TEL);
				$("#telContHp").val(objJson.midInfo[0].CONT_EMP_HP);
				
				$("#telTechNm").val(objJson.midInfo[0].TECH_EMP_NM);
				$("#telTechMail").val(objJson.midInfo[0].TECH_EMP_EMAIL);
				$("#telTechTel").val(objJson.midInfo[0].TECH_EMP_TEL);
				$("#telTechHp").val(objJson.midInfo[0].TECH_EMP_CP);
				
				$("#telSettleNm").val(objJson.midInfo[0].STMT_EMP_NM);
				$("#telSettleMail").val(objJson.midInfo[0].STMT_EMP_EMAIL);
				$("#telSettleTel").val(objJson.midInfo[0].STMT_EMP_TEL);
				$("#telSettleHp").val(objJson.midInfo[0].STMT_EMP_CP);
				
				
				//결제 데이터 통보
				$("#notiPmNm").text(objJson.midInfo[0].PM_CD);
				$("#notiPmNmView").text(objJson.midInfo[0].PM_CD_NM);
				$("#notiStartDt").text(IONPay.Utils.fnStringToDateFormat(objJson.midInfo[0].FR_DT));
				$("#notiUrlIp").val(objJson.midInfo[0].SND_CH_TYPE);
				$("#notiEncoding").select2("val", objJson.midInfo[0].CHARSET_TYPE);
				$("#notiReSendTerm").val(objJson.midInfo[0].SND_CYCLE);
				$("#notiReSendCnt").val(objJson.midInfo[0].SND_MAX_CNT); */
				
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
		
		strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/updateNormalGidInfo.do";
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
                	
                	<!-- gid 일반정보 start -->
                    <div class = "row" id = "Information">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          	<h4><span class="semi-bold">일반정보</span></h4>
	                          	<div class="tools"> <a href="javascript:;" id="gidInformationCollapse" class="collapse"></a></div>
	      		                  </div>
	      		                  <div class="grid-body">
	                         	<div class="row">
	                         		<table class="table" id="gidInfo" style="width:100%">
		                                <tbody>
		                                	<tr>
			                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0138" /></td>
			                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px" >
													<div class="form-inline" style="margin:0;padding:0;">
														<div class="form-group" id="normalGID" name="normalGID" style="margin:0;padding:0;float:left;width:100%;">
															<!-- <input type="text" class="form-control" style="width:50%;float:left" id="normalGID" name="normalGID">
															<label for="GID" style="margin: 17px 13px 0px 2px; display:inline;float:left">g</label> -->
														</div>
													</div>
												 </td>
			                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0428"/></td>
			                                     <td id="normalIssuDt" name="normalIssuDt" style="text-align:center; border:1px solid #c2c2c2;" colspan="4">
		                                         	<!-- <input type="text" id="normalIssuDt" name="normalIssuDt" class="form-control" style="width:30%;"> -->
		                                       	 </td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0415" /></td>
		                                     	<td  id="normalGNm"  name="normalGNm" style="text-align:center; border:1px solid #c2c2c2;" colspan="6">
	                            					<!-- <input type="text" id="normalGNm"  name="normalGNm" class="form-control" style="float:left; width:15%;" > -->
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0083" /></td>
		                                     	<td id="normalCoNo" name="normalCoNo" style="text-align:center; border:1px solid #c2c2c2;" colspan="6">
	                            					<!-- <input type="text"  id="normalCoNo" name="normalCoNo" class="form-control" style="float:left; width:15%;" > -->
	                           				 	</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0429" /></td>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white; width:15%;">
	                            					<select class = "select2 form-control" id="normalBankCd" name="normalBankCd"></select>
	                           				 	</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_BM_0417"/></td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                       		 	<input type="text" id="normalVaNo" name="normalVaNo" class="form-control" style=" width:85%; float:left;">
	                                       		 	<label style="margin: 10px 10px 0px 5px; display:inline; float:left;"><spring:message code="IMS_BIM_BM_0430" /></label>
												</td>
												<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee; "><spring:message code="IMS_BIM_BIM_0027"/></td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;" >
	                                       		 	<input type="text"  id="normalVaNm" name="normalVaNm" class="form-control" style="float:left; " >
												</td>
		                                	</tr>
		                                	<tr>
		                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2" ><spring:message code="IMS_BIM_BM_0431" /></td>
	                           				 	
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BM_CM_0097"/></td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                                       		 	<input type="text"  id="normalContNm1" name="normalContNm1" class="form-control" style="float:left; " >
												</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">TEL/CP</td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                            					<input type="text"  id="normalContTel1" name="normalContTel1" class="form-control" style="float:left; width:40%;" >
	                            					<label style="margin: 10px 10px 0px 8px; display:inline;float:left;"> / </label>
	                            					<input type="text"  id="normalContCp1" name="normalContCp1" class="form-control" style="float:left; width:40%;" >
												</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">EMAIL</td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                            					<input type="text"  id="normalContEmail1" name="normalContEmail1" class="form-control" style="float:left;" >
												</td>
		                                	</tr>
		                                	<tr>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BM_CM_0097"/></td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                                       		 	<input type="text"  id="normalContNm2" name="normalContNm2" class="form-control" style="float:left; " >
												</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">TEL/CP</td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                            					<input type="text"  id="normalContTel2" name="normalContTel2" class="form-control" style="float:left; width:40%;" >
	                            					<label style="margin: 10px 10px 0px 8px; display:inline;float:left;"> / </label>
	                            					<input type="text"  id="normalContCp2" name="normalContCp2" class="form-control" style="float:left; width:40%;" >
												</td>
	                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">EMAIL</td>
			                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                            					<input type="text"  id="normalContEmail2" name="normalContEmail2" class="form-control" style="float:left;" >
												</td>
		                                	</tr>
		                                	<tr>
		                                		<td colspan="6">
			                                	<td>
			                                		<button type='button' class='btn btn-info btn-cons'  id="btnGidReg"  onclick="fnUpdateNormalInfo();" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
														<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0020" />
													</button>
			                                	</td>
		                                	</tr>
		                                </tbody>
		                            </table>
	                          	 </div>
	                         	  </div>
	          	              </div>
              	        </div>
                    </div>
                    	
                    <!-- gid 일반정보 end -->
                	
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               <!-- BEGIN Other Information VIEW AREA -->
	                <form id="depositInfo" name="depositInfo">
                	
                	<!-- gid 정산정보 start -->
                		<div class = "row" id = "settleGInfo">
		                	<div class = "col-md-12">
		                      <div class="grid simple horizontal light-grey">
		                        <div class="grid-title" >
		                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0012" /></span></h4>
		                          <div class="tools"> <a href="javascript:;" id="settleGInfoCollapse" class="collapse"></a></div>
		                        </div>
		                        <div class="grid-body" >
		                          <div class="row" id="settleVInfo">
	                         		<table class="table" id="tbSettleGidInfo"  style="width:100%;">
		                                <thead id="thFeeInfo">
		                                	<tr>
		                                		<!-- <th>NO</th> -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0420" /></th><!-- 결제 서비스 -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0310" /></th><!-- 수수료 -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0421" /></th><!-- 최소원가 -->
		                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0423" /></th><!-- 적용 시작일 -->
		                                	</tr>
			                                <tr>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">이롬머니</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0438" /></td>
			                                	<td id="settMinCashPer" name="settMinCashPer" style="text-align:center; border:1px solid #c2c2c2;">
			                                		<!-- <input type="text" id="settMinCashPer" name="settMinCashPer" class="form-control" style="float:left; width:80%">
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
	                             		<button type='button' class='btn btn-info btn-cons'  id="btnGidCalReg"  onclick="fnGidCalRegist(typeChk);" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
											<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0019" />
										</button>
									</div> --%>
		                          </div>
		                        </div>
		                	</div>
		                </div>
		          	 </div> 
		          	 <!-- gid 정산정보 end -->
					
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               
               
               
	            </div>
           </div><!-- <br><br><br> -->
        </div>
        
        