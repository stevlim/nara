<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objDepReportInquiry;
var objReceiveDeferSearch;
var objDifferenceAmtSearch;

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
	$("#div_search").hide();
    
    $("#btnSearch").on("click", function() {
    	$("#div_search").show(200);
    	
    	arrParameter = $("#frmSearch").serializeObject();
    	arrParameter["worker"] = strWorker;
    	strCallUrl   = "/calcuMgmt/reportMgmt/selectReportSearch.do";
        strCallBack  = "fnSearchRet";
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    	
    });
}
function fnSetDDLB(){
	$("select[name=division]").html("<c:out value='${division}' escapeXml='false' />");
}
function fnSearchRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.pmReport != null){
			var str = "";
			str += "<tr style='text-align: center; '><td rowspan='5' style='text-align:center; border:1px solid #ddd;'>";
			str += $("#stmtDt").val()+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>신용카드</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CARD_CNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CARD_AMT+"</td>";
			str += "<td rowspan='4' style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.RESR_AMT+"</td>";
			str += "<td rowspan='4' style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.RESR_CC_AMT+"</td>";
			str += "<td rowspan='4' style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.EXTRA_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CARD_FEE+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CARD_VAT+"</td>";
			str += "<td rowspan='4' style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.DPST_AMT+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>계좌이체</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.ACCNT_CNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.ACCNT_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.ACCNT_FEE+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.ACCNT_VAT+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>가상계좌</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.VACCT_CNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.VACCT_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.VACCT_FEE+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.VACCT_VAT+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>휴대폰</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CP_CNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CP_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CP_FEE+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.CP_VAT+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>합계</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.TOT_CNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.TOT_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.RESR_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.RESR_CC_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.EXTRA_AMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.TOT_FEE+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.TOT_VAT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.pmReport.DPST_AMT+"</td>";
			str += "</tr>";
			
			$("#tbody_info").html(str);
		}if(objJson.confData != null){
			var str = "";
			if(objJson.confData.CONF1_COMP == "X"){
				str += "&nbsp; 전체 "+(objJson.pmReport.ID_CNT==null?"":objJson.pmReport.ID_CNT)+"건 중 " + (objJson.pmReport.ID_CNT==null?"":objJson.pmReport.ID_CNT)+ "건 확정.";
			}else{
				str += "&nbsp; 담당 ( "+(objJson.confData.CONF1_EMP_NO==null?"":objJson.confData.CONF1_EMP_NO)+" )&nbsp;&nbsp; " + (objJson.confData.CONF1_DNT==null?"":objJson.confData.CONF1_DNT); 
			}
			$("#pmContMng").html(str);
			str = "";
			if(objJson.confData.CONF2_COMP == "X"){
				str += "&nbsp; 전체 "+(objJson.pmReport.ID_CNT==null?"":objJson.pmReport.ID_CNT)+"건 중 " + (objJson.confData.CONF2_CNT==null?"":objJson.confData.CONF2_CNT)+ "건 확정.";
			}else{
				str += "&nbsp; 팀장 ( "+(objJson.confData.CONF2_EMP_NO==null?"":objJson.confData.CONF2_EMP_NO)+" )&nbsp;&nbsp; " + (objJson.confData.CONF2_DNT==null?"":objJson.confData.CONF2_DNT); 
			}
			$("#pgTeamMng").html(str);
			str = "";
			if(objJson.confData.CONF3_COMP == "X"){
				str += "&nbsp; 전체 "+objJson.pmReport.ID_CNT+"건 미확정. ";
				if(objJson.confData.CONF1_COMP != "X" && objJson.confData.CONF2_COMP != "X"){
					if(strStmtFlg7 == "1"){
						str += "<button type='button' onclick='fnConfirm();' class='btn btn-primary btn-cons'>확정</button>";
					}else{
						str += "&nbsp;";
					}
				}
			}else{
				str += "&nbsp; 송금 ( "+(objJson.confData.CONF3_EMP_NO==null?"":objJson.confData.CONF3_EMP_NO)+" )&nbsp;&nbsp; " + (objJson.confData.CONF3_DNT==null?"":objJson.confData.CONF3_DNT);
			}
			$("#mng3").html(str);
		}if(objJson.refundCnt != null){
			var str = "";
			str += "<tr style='text-align: center; '>";
			if(objJson.refundCnt.TOT_CNT == 0){
				str += "<td style='text-align:center; border:1px solid #ddd;'><spring:message code='IMS_COM_EXCEL_0001'/></td>";
			}else{
				str += "<td style='text-align:center; border:1px solid #ddd;'>건수</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>금액</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>상세내역</td>";
				str += "</tr><tr style='text-align: center; '>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.refundCnt.TOT_CNT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.refundCnt.TOT_CNT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>";
				str += "<button type='button' onclick='fnDownRefundReport();' class='btn btn-primary btn-cons'>다운로드</button>";
				str += "</td>";
			}
			str +="</tr>";
			$("#thInfo").html(str);
		}
		$("#frmDown input[name=stmtDt]").val(IONPay.Utils.fnConvertDateFormat($("#frmSearch input[name=stmtDt]").val()));
		$("#frmDown input[name=payType]").val($("#frmSearch #payType").val());
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnConfirm(){
// 	var toDay = getToDay();

//     if(toDay != f.settlmntDt.value) {
//       IONPay.Msg.fnAlert('확정처리는 지급일 당일만 가능합니다. 이후 처리건은 개발팀에 문의하세요.');
//       return;
//       SendReportDecision.jsp
//     }
}
function fnDownSend(){
	var $objFrmData = $("#frmDown").serializeObject();
    arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
    IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/reportMgmt/selectSendListExcel.do");
}
function fnDownReport(){
	var $objFrmData = $("#frmDown").serializeObject();
    arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
    IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/reportMgmt/selectSendReportExcel.do");
}
function fnDownExcel(){
	var $objFrmData = $("#frmDown").serializeObject();
    arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
    IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/reportMgmt/selectPgStmtExcel.do");
}
function fnDownRefundReport(){
	var $objFrmData = $("#frmDown").serializeObject();
    arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
    IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/reportMgmt/selectSendRefundExcel.do");
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0109'/></span></h3>
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
		                                <div class="col-md-3" >
											<label class="form-label"><spring:message code='IMS_BIM_BM_0558'/></label> 
                                        	<div class="input-append success date col-md-10 col-lg-10 no-padding">
	                                            <input type="text" id="stmtDt" name="stmtDt" class="form-control">
	                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                       	 	</div>                                      
	                                    </div>
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code='IMS_BIM_BM_0149'/></label>
                                        	<select id=payType name="payType"  class="select2 form-control">
                                        		<option value="none" selected="selected"><spring:message code='DDLB_0142'/></option>
                                        		<option value="om"><spring:message code='IMS_BIM_BM_0581'/></option>
                                       		</select>
	                                    </div>
                                        <div class="col-md-3"></div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_PW_DE_10'/></button>
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
                           <form id="frmDown">
                           <input type='hidden' name='stmtDt' >
							<input type='hidden' name='payType' >
                            <div class="grid-body no-border">
                                <div id="div_searchResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbInfoSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0565'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0245'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0139'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0160'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0583'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0584'/></th>  
                                                     <th ><spring:message code='IMS_BIM_BM_0555'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0310'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0556'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0573'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_info"></tbody>
                                            </table>
                                            <table id="tbInfoSearch" class="table" style="width:50%">
                                            	<thead>
                                            		<tr>
                                                     <th rowspan="4" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0574'/></th>
                                                 	</tr>
                                                 	<tr>
                                                     <th class="th_verticleLine"><spring:message code='IMS_BIM_BM_0585'/></th>
                                                     <td style="border:1px solid #ddd; text-align: center;" id="pmContMng" ></td>
                                                     <td style="border:1px solid #ddd; text-align: center;" >
                                                     	<button type="button" onClick="fnDownSend();"class="btn btn-primary btn-cons">
                                                     		<spring:message code='IMS_BIM_BM_0588'/>
                                                     	</button>
                                                   	</td>
                                                 	</tr>
                                                 	<tr>
                                                     <th class="th_verticleLine"><spring:message code='IMS_BIM_BM_0586'/></th>
                                                     <td style="border:1px solid #ddd; text-align: center;" id="pgTeamMng"></td>
                                                      <td style="border:1px solid #ddd; text-align: center;" >
                                                     	<button type="button" onClick="fnDownReport();"class="btn btn-primary btn-cons">
                                                     		<spring:message code='IMS_SM_SR_0056'/>
                                                     	</button>
                                                   	</td>
                                                 	</tr>
                                                 	<tr>
                                                     <th class="th_verticleLine"><spring:message code='IMS_BIM_BM_0587'/></th>
                                                     <td style="border:1px solid #ddd; text-align: center;"  id="mng3"></td>
                                                      <td style="border:1px solid #ddd; text-align: center;" >
                                                     	<button type="button" onClick="fnDownExcel();"class="btn btn-primary btn-cons">
                                                     		<spring:message code='IMS_SM_SR_0057'/> EXCEL
                                                     	</button>
                                                   	</td>
                                                 	</tr>
                                            	</thead>
                                            	<tbody id="tbody_info"></tbody>
                                            </table>
                                       		<div style="font-weight: bold;"><spring:message code='IMS_BIM_BM_0589'/></div>
                                            <table id="tbInfoSearch" class="table" style="width:50%">
                                            	<thead id="thInfo">
                                            		<tr>
                                                     <th><spring:message code='IMS_COM_EXCEL_0001'/></th>
                                                 	</tr>
                                               	</thead>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                            </div>
                          </form>
                        </div>
                    </div>                
                </div>
                <!-- END SEARCH LIST AREA -->
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    	<!-- END CONTAINER -->
