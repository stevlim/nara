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
	strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/selectNormalInfo.do";
	strCallBack  = "fnSelectBaseInfoRet";
	
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

//조회된 데이터 화면에 뿌리기
function fnSelectBaseInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.midInfo != null){
			if(objJson.midInfo.length > 0 ){
				//일반정보
				$("#normalCoNm").text(objJson.midInfo[0].CO_NM==null?"":objJson.midInfo[0].CO_NM);
				$("#normalMid").text(objJson.midInfo[0].MID==null?"":objJson.midInfo[0].MID);
				$("#normalRepNm").text(objJson.midInfo[0].REP_NM==null?"":objJson.midInfo[0].REP_NM);
				
				$("#normalCoNo").text(objJson.midInfo[0].CO_NO==null?"":objJson.midInfo[0].CO_NO);
				$("#normalRepTel").val(objJson.midInfo[0].TEL_NO);
				$("#normalRepMail").val(objJson.midInfo[0].EMAIL);
				
				$("#normalBsKind").text(objJson.midInfo[0].BS_KIND==null?"":objJson.midInfo[0].BS_KIND);
				$("#normalGdKind").text(objJson.midInfo[0].GD_KIND==null?"":objJson.midInfo[0].GD_KIND);
				$("#normalSignNm").val(objJson.midInfo[0].SIGN_NM);
				
				$("#normalUrl").text(objJson.midInfo[0].MID_URL==null?"":objJson.midInfo[0].MID_URL);
				$("#normalAddress").text(objJson.midInfo[0].ADDR==null?"":objJson.midInfo[0].ADDR);
				
				
				//입금 정보
				$("#depositBankNm").text(objJson.midInfo[0].BANK_NM==null?"":objJson.midInfo[0].BANK_NM);
				$("#depositDepositNm").text(objJson.midInfo[0].ACCNT_NM==null?"":objJson.midInfo[0].ACCNT_NM);
				$("#depositAcctNo").text(objJson.midInfo[0].ACCNT_NO==null?"":objJson.midInfo[0].ACCNT_NO);
				
				$("#depositEromCash").text(objJson.midInfo[0].EROM_FEE==null?"":objJson.midInfo[0].EROM_FEE + "%");
				
				
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
				
				$("#notiPmNmView").text(objJson.midInfo[0].PM_CD_NM==null?"":objJson.midInfo[0].PM_CD_NM);
				$("#notiStartDt").text(objJson.midInfo[0].FR_DT==null?"":IONPay.Utils.fnStringToDateFormat(objJson.midInfo[0].FR_DT));
				$("#notiUrlIp").val(objJson.midInfo[0].SND_CH_TYPE);
				$("#notiEncoding").select2("val", objJson.midInfo[0].CHARSET_TYPE);
				$("#notiReSendTerm").val(objJson.midInfo[0].SND_CYCLE);
				$("#notiReSendCnt").val(objJson.midInfo[0].SND_MAX_CNT);
				
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
		
		strCallUrl   = "/baseInfoMgmt/normalInfoMgmt/updateNormalInfo.do";
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
                	
					<div class = "row" id = "normalInformation">
	                	<div class = "col-md-12">
	                      	<div class="grid simple horizontal red">
	                        	<div class="grid-title">
	                          		<h4><span class="semi-bold">일반 정보</h4>
	                          		<div class="tools"><!--  <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a> --></div>
	                        	</div>
	                        	<div class="grid-body">
	                          		<div class="row">
                            			<table class="table" id="tbNormalInformation" width="100%">
                                			<tbody>
                                				<tr>
	                                	 			<!-- MID -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">상호명</td>
				                               
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "normalCoNm" name = "normalCoNm">
			                            			</td>
                            			 
                            						<!-- 상호 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">MID</td>
									
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "normalMid" name = "normalMid">
			                            			</td>
			                            			
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">대표자명</td>
									
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "normalRepNm" name = "normalRepNm">
			                            			</td>
	                                			</tr>
	                                			
	                                			<tr>
	                                	 			<!-- 사업자번호 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">사업자번호</td>
				                                    
				                               
				                                    <td style="text-align:center; border:1px solid #c2c2c2; width: 23%;" id = "normalCoNo" name = "normalCoNo">
			                            			</td>
                            			 
                            						<!-- 대표 TEL -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">대표 TEL</td>
									
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 23%; " >
				                                    	<input style="min-height: 30px;" type="text" id = "normalRepTel" name = "normalRepTel">
			                            			</td>
			                            			
			                            			<!-- 대표 Mail -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">대표 Mail</td>
									
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 24%;" >
				                                    	<input style="min-height: 30px;" type="text" id = "normalRepMail" name = "normalRepMail">
			                            			</td>
	                                			</tr>
	                                			
	                                			<tr>
	                                	 			<!-- 업종 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">업종</td>
				                                    
				                               
				                                    <td style="text-align:center; border:1px solid #c2c2c2; width: 23%;" id = "normalBsKind" name = "normalBsKind">
			                            			</td>
                            			 
                            						<!-- 업태 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">업태</td>
									
				                                    <td style="text-align:center; border:1px solid #c2c2c2; width: 23%;" id = "normalGdKind" name = "normalGdKind">
			                            			</td>
			                            			
			                            			<!-- 간판명 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">간판명</td>
									
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 24%;" >
				                                    	<input style="min-height: 30px;" type="text" id = "normalSignNm" name = "normalSignNm">
			                            			</td>
	                                			</tr>
	                                			
	                                			<tr>
	                                	 			<!-- 홈페이지 URL -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 100px;">홈페이지 URL</td>
				                               
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "normalUrl" name = "normalUrl" colspan="5">
			                            			</td>
	                                			</tr>
	                                			
	                                			<tr>
	                                	 			<!-- 사업장 주소 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 100px;">사업장 주소</td>
				                               
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "normalAddress" name = "normalAddress" colspan="5">
			                            			</td>
	                                			</tr>
	                                			
	                                			<tr>
			                                    	<td style="text-align:center; border:1px solid #c2c2c2; border-right:0px;" colspan="5"></td>
			                                     	<td style="text-align:right; border:1px solid #c2c2c2; border-left:0px;">
														<button type='button' class='btn btn-info btn-cons'  onclick="fnUpdateNormalInfo();" style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
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
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               <!-- BEGIN Other Information VIEW AREA -->
	                <form id="depositInfo" name="depositInfo">
                	
					<div class = "row" id = "depositInformation">
	                	<div class = "col-md-12">
	                      	<div class="grid simple horizontal purple">
	                        	<div class="grid-title">
	                          		<h4><span class="semi-bold">입금 정보</h4>
	                          		<div class="tools"><!--  <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a> --></div>
	                        	</div>
	                        	<div class="grid-body">
	                          		<div class="row">
                            			<table class="table" id="tbDepositInformation" width="100%">
                                			<tbody>
                                				<tr>
	                                	 			<!-- 입금계좌 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;" colspan="2" rowspan="2">
			                            				입금계좌
			                            			</td>
                            			 
			                            			<!-- 은행 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">은행</td>
                            			 
                            						<!-- 예금주 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">예금주</td>
			                            			
			                            			<!-- 계좌번호 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 40%;">계좌번호</td>
	                                     
	                                			</tr>
	                                			
	                                			<tr>
			                            			<!-- 은행 -->
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "depositBankNm" name = "depositBankNm">&nbsp;
			                            			</td>
                            			 
                            						<!-- 예금주 -->
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "depositDepositNm" name = "depositDepositNm">
			                            			</td>
			                            			
			                            			<!-- 계좌번호 -->
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "depositAcctNo" name = "depositAcctNo">
			                            			</td>
	                                     
	                                			</tr>
	                                			
	                                			
	                                			<tr>
	                                	 			<!-- 입금주기 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;" rowspan="2">입금주기</td>
                            			 
                            						<!-- 온라인 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;" rowspan="2">온라인</td>
			                            			
			                            			<!-- 이롬 캐시 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;" colspan="3">이롬 캐시</td>
	                                			</tr>
	                                			
	                                			<tr>
			                            			<!-- 이롬 캐시 -->
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "depositEromCash" name = "depositEromCash" colspan="3">&nbsp;
			                            			</td>
	                                			</tr>
	                                	
	                                		</tbody>
	                            		</table>
	                          		</div>
	                        	</div>
	                		</div>
	                	</div>
	            	</div> 
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               <!-- BEGIN Other Information VIEW AREA -->
	           <!-- <form id="payInfo" name="payInfo">
                	
					<div class = "row" id = "payInformation">
	                	<div class = "col-md-12">
	                      	<div class="grid simple horizontal yellow">
	                        	<div class="grid-title">
	                          		<h4><span class="semi-bold">결제 정보(수수료)</h4>
	                          		<div class="tools"> <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a></div>
	                        	</div>
	                        	<div class="grid-body">
	                          		<div class="row">
                            			<table class="table" id="tbPayInformation" width="100%">
                                			<tbody>
                                				<tr>
	                                	 			온라인
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;" rowspan="2">온라인</td>
				                    	 
                            						이롬 캐시
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;" rowspan="2">이롬 캐시</td>
									
			                            			
			                            			수수료
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 80%;">수수료</td>

	                                			</tr>
	                                			
	                                			<tr>
			                            			수수료
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "payFee" name = "payFee">&nbsp;
			                            			</td>
	                                     
	                                			</tr>
	                                		</tbody>
	                            		</table>
	                          		</div>
	                        	</div>
	                		</div>
	                	</div>
	            	</div> 
	           </form> -->
               <!-- BEGIN Other Information VIEW AREA -->
               
               <!-- BEGIN Other Information VIEW AREA -->
	                <form id="etcInfo" name="etcInfo">
                	
					<div class = "row" id = "etcInformation">
	                	<div class = "col-md-12">
	                      	<div class="grid simple horizontal grey">
	                        	<div class="grid-title">
	                          		<h4><span class="semi-bold">기타</h4>
	                          		<div class="tools"><!--  <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a> --></div>
	                        	</div>
	                        	<div class="grid-body">
	                          		<div class="row">
                            			<table class="table" id="tbEtcInformation" width="100%">
                                			<tbody>
                                				<tr>
	                                	 			<!-- 거래취소 비밀번호 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;" rowspan="2">
			                            				거래취소 비밀번호
			                            			</td>
				                                    
				                                    <!-- 가맹점 key -->
				                                    <td style="text-align:left; border:1px solid #c2c2c2; border-bottom:0px; width: 80%" id = "etcPwArea" name = "etcPwArea">
				                                    	&nbsp;&nbsp;
				                                    	<input style="min-height: 30px;" type="number" id = "etcPw" name = "etcPw"/>
				                                    	&nbsp;&nbsp;재입력
				                                    	&nbsp;&nbsp;
				                                    	<input style="min-height: 30px;" type="number" id = "etcRePw" name = "etcRePw"/>
				                                    	&nbsp;&nbsp;
				                                    	<button type='button' class='btn btn-info btn-cons'  onclick="fnEtcCancelPwRegist();" style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
															<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_SM_SRM_0053" />
														</button>
			                            			</td>
				                    
	                                			</tr>
	                                	
                                				<tr>
				                                    <!-- 가맹점 key -->
				                                    <td style="text-align:left; border:1px solid #c2c2c2; border-top:0px; width: 80%" id = "etcMemo" name = "etcMemo">
				                                    	&nbsp;&nbsp;<span style="color: red;">6자리 숫자만 가능 </span> 비밀번호를 등록할 경우 거래 취소시 위에 등록한 비밀번호를 입력해야 합니다.
			                            			</td>
			                            			
	                                			</tr>
	                                	
	                                		</tbody>
	                            		</table>
	                          		</div>
	                        	</div>
	                		</div>
	                	</div>
	            	</div> 
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               
               <!-- BEGIN Other Information VIEW AREA -->
	                <form id="telInfo" name="telInfo">
                	
					<div class = "row" id = "telInformation">
	                	<div class = "col-md-12">
	                      	<div class="grid simple horizontal green">
	                        	<div class="grid-title">
	                          		<h4><span class="semi-bold">담당자 연락처</h4>
	                          		<div class="tools"><!--  <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a> --></div>
	                        	</div>
	                        	<div class="grid-body">
	                          		<div class="row">
                            			<table class="table" id="tbTelInformation" width="100%">
                                			<tbody>
                                				<tr>
	                                	 			<!-- 구분 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">구분</td>
			                            			
			                            			<!-- 담당자 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">담당자</td>
			                            			
			                            			<!-- E-Mail -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">E-Mail</td>
			                            			
			                            			<!-- 전화번호(직통) -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">전화번호(직통)</td>
			                            			
			                            			<!-- 이동전화 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">이동전화</td>
				                                    
	                                			</tr>
	                                	
                                				<tr>
				                                	<!-- 계약담당 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">계약담당</td>
			                            			
			                            			<!-- 계약담당 - 담당자 -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telContNm" name = "telContNm" />
			                            			</td>
			                            			
			                            			<!-- 계약담당 - E-Mail -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telContMail" name = "telContMail" />
			                            			</td>
			                            			
			                            			<!-- 계약담당 - 전화번호(직통) -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telContTel" name = "telContTel" />
			                            			</td>
			                            			
			                            			<!-- 계약담당 - 이동전화 -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telContHp" name = "telContHp" />
			                            			</td>
			                            			
	                                			</tr>
	                                			
	                                			<tr>
				                                	<!-- 기술담당 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">기술담당</td>
			                            			
			                            			<!-- 기술담당 - 담당자 -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telTechNm" name = "telTechNm" />
			                            			</td>
			                            			
			                            			<!-- 기술담당 - E-Mail -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telTechMail" name = "telTechMail" />
			                            			</td>
			                            			
			                            			<!-- 기술담당 - 전화번호(직통) -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telTechTel" name = "telTechTel" />
			                            			</td>
			                            			
			                            			<!-- 기술담당 - 이동전화 -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telTechHp" name = "telTechHp" />
			                            			</td>
			                            			
	                                			</tr>
	                                			
	                                			<tr>
				                                	<!-- 정산담당 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 20%;">정산담당</td>
			                            			
			                            			<!-- 정산담당 - 담당자 -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telSettleNm" name = "telSettleNm" />
			                            			</td>
			                            			
			                            			<!-- 정산담당 - E-Mail -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telSettleMail" name = "telSettleMail" />
			                            			</td>
			                            			
			                            			<!-- 정산담당 - 전화번호(직통) -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telSettleTel" name = "telSettleTel" />
			                            			</td>
			                            			
			                            			<!-- 정산담당 - 이동전화 -->
				                                    <td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 20%;">
				                                    	<input style="min-height: 30px;" type="text" id = "telSettleHp" name = "telSettleHp" />
			                            			</td>
			                            			
	                                			</tr>
	                                			
	                                			<tr>
			                                    	<td style="text-align:center; border:1px solid #c2c2c2; border-right:0px;" colspan="4"></td>
			                                     	<td style="text-align:right; border:1px solid #c2c2c2; border-left:0px;">
														<button type='button' class='btn btn-info btn-cons'  onclick="fnUpdateNormalTelInfo();" style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
															<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0019" />
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
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               
               <!-- BEGIN Other Information VIEW AREA -->
	                <form id="notiInfo" name="notiInfo">
                	
					<div class = "row" id = "notiInformation">
	                	<div class = "col-md-12">
	                      	<div class="grid simple horizontal yellow">
	                        	<div class="grid-title">
	                          		<h4><span class="semi-bold">결제 데이터 통보</h4>
	                          		<div class="tools"><!--  <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a> --></div>
	                        	</div>
	                        	<div class="grid-body">
	                          		<div class="row">
                            			<table class="table" id="tbNotiInformation" width="100%">
                                			<tbody>
                                				<tr>
	                                	 			<!-- 지불수단 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">지불수단</td>
				                        
                            						<!-- 시작일자 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">시작일자</td>
	                                    			
	                                    			<!-- URL/IP -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 30%;">URL/IP</td>
				                        
                            						<!-- 인코딩 방식 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">인코딩 방식</td>
	                                    			
	                                    			<!-- 재전송 간격 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">재전송 간격</td>
				                        
				                        
                            						<!-- 재전송 횟수 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">재전송 횟수</td>
	                                    			
	                                    			<!-- 전송 방식 -->
			                            			<!-- <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 10%;">전송 방식</td> -->
				                        
                            						<!-- 초기화 -->
	                                    			<!-- <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 100px;">초기화</td> -->
									 
	                                			</tr>
	                                			
	                                			<tr>
                            						<!-- 지불수단 -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; width: 10%" id = "notiPmNmView" name = "notiPmNmView" >
			                            				<input type="hidden" id = "notiPmNm" name = "notiPmNm" >
			                            			</td>
				                        
                            						<!-- 시작일자 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; width: 10%" id = "notiStartDt" name = "notiStartDt">
			                            			</td>
	                                    			
	                                    			<!-- URL/IP -->
			                            			<td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 30%" >
			                            				<input type="text" id = "notiUrlIp" name = "notiUrlIp" style="width: 330px; min-height: 30px;" />
			                            			</td>
				                        
                            						<!-- 인코딩 방식 -->
	                                    			<td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 10%" >
	                                    				<select style="min-height: 30px;" class = "select2 form-control" id = "notiEncoding" name = "notiEncoding"></select>
			                            			</td>
	                                    			
	                                    			<!-- 재전송 간격 -->
			                            			<td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 10%" >
			                            				<input type="text" id = "notiReSendTerm" name = "notiReSendTerm" style="width: 120px; min-height: 30px;" />&nbsp;&nbsp;분
			                            			</td>
				                        
				                        
                            						<!-- 재전송 횟수 -->
	                                    			<td style="padding: 3px 5px !important; text-align:center; border:1px solid #c2c2c2; width: 10%" >
	                                    				<input type="text" id = "notiReSendCnt" name = "notiReSendCnt"  style="width: 120px; min-height: 30px;" />&nbsp;&nbsp;회
			                            			</td>
	                                    			
	                                    			<!-- 전송 방식 -->
			                            			<!-- <td style="text-align:center; border:1px solid #c2c2c2; width: 10%" id = "notiMid" name = "notiMid">
			                            				<select class = "select2 form-control" id = "notiSendType" name = "notiSendType"">
			                            				</select>
			                            			</td> -->
				                        
                            						<!-- 초기화 -->
	                                    			<!-- <td style="text-align:center; border:1px solid #c2c2c2; width: 10%" id = "notiRefresh" name = "notiRefresh">
			                            			</td> -->
	                                     
	                                			</tr>
	                                	
                                				<tr>
			                            			<td style="text-align:left; border:1px solid #c2c2c2; color: blue;" colspan="5" >
				                            			&nbsp;&nbsp;* 재전송 간격은 최소 1분~60분(1시간)까지만 입력 가능합니다.<br>
														&nbsp;&nbsp;* 재전송 횟수는 최소 1회부터 최대 10회까지 재전송 가능합니다. (전송 실패된 건에 대해 자동으로 재전송)<br>
														&nbsp;&nbsp;* 모든 값이 전부 입력된 경우에만 적용됩니다.
			                            			</td>
				                        
	                                    			<td style="text-align:right; border:1px solid #c2c2c2;" colspan="3" >
	                                    				<button type='button' class='btn btn-info btn-cons'  onclick="fnNotiRegist();" style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
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
	           </form>
               <!-- BEGIN Other Information VIEW AREA -->
               
               
               
	            </div></div></div>
              