<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strStmtFlg6 = "<c:out value='${SETT_AUTH_FLG6}' escapeXml='false' />";

$(document).ready(function(){
    fnSetDDLB();
	fnInitEvent();
    
});

function fnInitEvent() {
	$("#div_search").hide();
    $("#div_searchMng").hide();
    
	var year = getToDate("Y");
	var month = getToDate("M");
	$("#frmSearch #year").val(year).attr("selected", "selected");
	$("#frmSearch #mon").val(month).attr("selected", "selected");
	
    $("#btnSearch").on("click", function() {
    	$("#div_search").show(200);
    	fnSelectAgentStmtList();
    });
}
function fnSetDDLB(){
	$("select[name=year]").html("<c:out value='${YEAR}' escapeXml='false' />");
	$("select[name=mon]").html("<c:out value='${MONTH}' escapeXml='false' />");
}

function fnSelectAgentStmtList() {
	arrParameter = $("#frmSearch").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/selectAgentStmtConfList.do";
	strCallBack  = "fnSelectAgentStmtListRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectAgentStmtListRet(objJson){
	if(objJson.resultCode == 0 ){
		var str = "";
		if(objJson.list.length != 0 && objJson.list[0].VID != ""){
			for(var i=0; i<objJson.list.length;i++){
				if(i == 0 ){
					str += "<tr>";
					str += "<td rowspan='"+(objJson.list.length+1)+"' style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;'>"+objJson.list[i].STMT_DT;
					str += "<input type='hidden'  name='stmtDt' value='"+objJson.list[i].STMT_DT+"'</td> ";
				}else{
					str += "<tr>";
				}
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+objJson.list[i].VGRP_NM+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+objJson.list[i].CO_NO+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+objJson.list[i].TRANS_YYMM+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].TRANAMT)+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].FEE)+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].VAT)+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].PAY_AMT)+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].PAY_VAT)+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].RESR_AMT)+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].EXTRA_AMT)+"</td>";
					str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.list[i].DPST_AMT)+"</td>";
					str += "</tr>";
			}
			str += "<tr style='text-align: center; '>";
			str += "<td colspan='2' style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >합계</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+objJson.tot.size+"건  </td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumTranAmt)+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumFee)+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumVat)+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumPayAmt)+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumPVat)+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumResrAmt)+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumExtraAmt)+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"+IONPay.Utils.fnAddComma(objJson.tot.sumDepositAmt)+"</td>";
			str += "</tr>";
		}else{
			str += "<tr style='text-align: center; >";
			str += "<td colspan='12' style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >데이터가 존재하지 않습니다. </td>";
			str += "<tr>";
		}
		$("#tbody_info").html(str);
		
		if(objJson.list != null ){
			if(objJson.list.length > 0 ){
				$("#div_searchMng").show(200);
				var status = objJson.data.STATUS==null?"":objJson.data.STATUS;
				str = "";
				str += "<tr style='text-align: center; '>";
				str += "<td rowspan='3' style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' ><spring:message code='IMS_BIM_BM_0574'/></td>";
				str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' ><spring:message code='IMS_BIM_BM_0585'/></td>";
				str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' ><spring:message code='IMS_BIM_BM_0661'/>";
				str += "("+(objJson.data.CONF1_EMP==null?'':objJson.data.CONF1_EMP)+") &nbsp;&nbsp; "+(objJson.data.CONF1_TM==null?'':IONPay.Utils.fnStringToDateFormat(objJson.data.CONF1_TM))+"&nbsp;&nbsp;</td>";
				str += "<td rowspan='3' style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >"; 
				if(strStmtFlg6=="1" && objJson.data.CONF2_COMP=="X" && status == "1"){
					str += "팀장 확정 필요";
				}else if(objJson.data.CONF2_EMP != "" && status=="2"){
					str += "<button type='button' onclick='fnDownSend();' class='btn btn-primary btn-cons'><spring:message code='IMS_BIM_BM_0588'/></button>";
					str += "<button type='button' onclick='fnDownReport();' class='btn btn-primary btn-cons'><spring:message code='IMS_SM_SR_0056'/></button>";
				}
				str += "</td></tr><tr style='text-align: center; '>";
				str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' ><spring:message code='IMS_BIM_BM_0586'/>";
				str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;' >";
				if(strStmtFlg6=="1" && objJson.data.CONF2_COMP=="X" && status == "1"){
					str += "<button type='button' onclick='fnUpdConfirm(1,2,\""+objJson.data.CONF1_TM+"\")' class='btn btn-primary btn-cons'><spring:message code='IMS_BIM_BM_0686'/></button>";
				}else{
					if(objJson.data.CONF2_EMP != ""){
						str += "팀장("+(objJson.data.CONF2_EMP==null?'':objJson.data.CONF2_EMP)+")&nbsp;&nbsp; "+(objJson.data.CONF2_TM==null?'':IONPay.Utils.fnStringToDateFormat(objJson.data.CONF2_TM))+"&nbsp;&nbsp;";
						if(status == "2"){
							str += "<button type='button' onclick='fnUpdConfirm(2,2,\""+objJson.data.CONF1_TM+"\")' class='btn btn-primary btn-cons'><spring:message code='IMS_BIM_BM_0687'/></button>";
						}else{
							str += "미확정 ";
						}
					}
				}
				str += "</td></tr>";
				str += "<tr style='text-align: center; '>";
				str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;'>재무 담당자</td>";
				str += "<td style='text-align:center; border:1px solid #ddd; background-color:#ecf0f2;'>";
				if(strStmtFlg6=="1" && objJson.data.CONF3_COMP=="X" && status == "2"){
					str += "<button type='button' onclick='fnUpdConfirm(1,3,\""+objJson.data.CONF1_TM+"\")' class='btn btn-primary btn-cons'><spring:message code='IMS_BIM_BM_0686'/></button>";
				}else{
					if(objJson.data.CONF3_EMP != ""){
						str += "팀장("+(objJson.data.CONF3_EMP==null?'':objJson.data.CONF3_EMP)+")&nbsp;&nbsp; "+(objJson.data.CONF3_TM==null?'':IONPay.Utils.fnStringToDateFormat(objJson.data.CONF3_TM))+"&nbsp;&nbsp;";
						if(status == "2"){
							str += "<button type='button' onclick='fnUpdConfirm(2,3,\""+objJson.data.CONF1_TM+"\")' class='btn btn-primary btn-cons'><spring:message code='IMS_BIM_BM_0687'/></button>";
						}else{
							str += "미확정 ";
						}
					}
				}
				
				str += "</td></tr>";
				
				$("#tbody_mng").html(str);
			}
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnUpdConfirm(upType, degree, confDt){
	var toDay = fnToDay();
	
	if(toDay > $("#stmtDt").val()){
		IONPay.Msg.fnAlert('확정처리는 지급일 당일만 가능합니다. 이후 처리건은 개발팀에 문의하세요.');
	}
	//ajax
	if(upType == "1"){
		//save
		arrParameter["type"] = upType;
		arrParameter["degree"] = degree;
		arrParameter["confDt"] = confDt;
		arrParameter["worker"] = strWorker;
		strCallUrl   = "/calcuMgmt/agencyStmtMgmt/updateAgentStmtAdSave.do";
		strCallBack  = "fnUpdConfirmRet";
	}else{
		//cancel
		arrParameter["type"] = upType;
		arrParameter["degree"] = degree;
		arrParameter["confDt"] = confDt;
		arrParameter["worker"] = strWorker;
		strCallUrl   = "/calcuMgmt/agencyStmtMgmt/updateAgentStmtAdCancel.do";
		strCallBack  = "fnUpdConfirmRet";
	}
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnUpdConfirmRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);
		window.location.reload();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
//송금
function fnDownSend(){
	var $objFrmData = $("#frmSearch").serializeObject();
	arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
    IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/agencyStmtMgmt/selectAgentStmtConfirmedListExcel.do");
}
//보고서
function fnDownReport(){
	var $objFrmData = $("#frmSearch").serializeObject();
    arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
    IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/agencyStmtMgmt/selectAgentSendReportExcel.do");
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0125'/></span></h3>
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
		                                <div class="col-md-2"   id="divYear">
											<label class="form-label"><spring:message code="IMS_BIM_BM_0639"/></label>
                                        	<select id="year" name="year"  style="width: 80%;" class="select2 form-control">
                           					</select>
                               				<span style="float: right;margin: -8% 8%; "><spring:message code="DDLB_0091" /></span>
	                                    </div>
	                                    <div class="col-md-2"  id="divMon">
	                                    	<label class="form-label">&nbsp;</label>
	                                    	<select id="mon"name="mon"  style="width: 80%;"class="select2 form-control">
                                      		</select>
                                      		<span style="float: right; margin: -8% 8%;"><spring:message code="IMS_BIM_BM_0628" /></span>
	                                    </div>
	                                    <div class="col-md-5" ></div>
			                          	<div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_CCS_0005'/></button>
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
                <form id="frmList">
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
	                                            <table id="tbListSearch" class="table" style="width:100%">
	                                            	<thead>
	                                                 <tr>
	                                                     <th ><spring:message code='IMS_BIM_BM_0565'/></th>
				                                         <th ><spring:message code='IMS_BIM_BM_0142'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0083'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0646'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0160'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0647'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0556'/></th>
	                                                     <th><spring:message code='IMS_BIM_BM_0648'/></th>
	                                                     <th><spring:message code='IMS_BIM_BM_0649'/></th>
	                                                     <th><spring:message code='IMS_BIM_BM_0633'/></th>
	                                                     <th><spring:message code='IMS_BIM_BM_0555'/></th>
	                                                     <th><spring:message code='IMS_BIM_BM_0573'/></th>
	                                                 </tr>
	                                            	</thead>
	                                            	<tbody id="tbody_info"></tbody>
	                                            </table>
	                                        </div>
	                                    </div>  
	                                </div>
	                            </div>
	                            <div class="grid-body no-border">
	                                <div id="div_searchMng" >
	                                    <div class="grid simple ">
	                                        <div class="grid-body " id="">
	                                            <table id="" class="table" style="width:100%">
	                                            	<tbody id="tbody_mng"></tbody>
	                                            </table>
	                                        </div>
	                                    </div>  
	                                </div>
	                            </div>
	                        </div>
	                    </div>                
	                </div>
                </form>
                <!-- END SEARCH LIST AREA -->
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    	<!-- END CONTAINER -->
