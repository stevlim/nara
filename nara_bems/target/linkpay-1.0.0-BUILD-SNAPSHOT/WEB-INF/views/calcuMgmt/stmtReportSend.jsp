<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objListInquiry;
var objViewPayDefail;
var objSendMail;
$(document).ready(function(){
    fnSetDDLB();
	fnInitEvent();
    
});

function fnInitEvent() {
	$("#div_searchResult").hide();
	$("#div_mail").hide();
	$("#div_payAmtDetail").hide();
	var year = getToDate("Y");
	var month = getToDate("M");
	$("#frmSearch #year").val(year).attr("selected", "selected");
	$("#frmSearch #mon").val(month).attr("selected", "selected");
    
    $("#btnSearch").on("click", function() {
    	if($("#id").val().length < 10){
    		IONPay.Msg.fnAlert('조회 ID를 입력해주세요');
    		$("#id").focus();
    		return;
    	}
    	$("#div_search").show(200);
    	fnListInquriy("SEARCH");
    });
    $("#btnExcel").on("click", function() {
    	fnListInquriy("EXCEL");
    });
}
function fnSetDDLB(){
	$("select[name=year]").html("<c:out value='${YEAR}' escapeXml='false' />");
	$("select[name=mon]").html("<c:out value='${MONTH}' escapeXml='false' />");
}

function fnListInquriy(strType){
	if(strType == "SEARCH"){
	   	if (typeof objListInquiry == "undefined") {
	   		objListInquiry = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
	               url: "/calcuMgmt/agencyStmtMgmt/selectAgentStmtReportList.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM==null?"":data.RNUM} },
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToMonthDateFormat(data.TRAN_DT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VGRP_NM==null?"":data.VGRP_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VID==null?"":data.VID} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REP_NM==null?"":data.REP_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TRAN_AMT==null?"":IONPay.Utils.fnAddComma(data.TRAN_AMT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SALES_FEE==null?"":IONPay.Utils.fnAddComma(data.SALES_FEE)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SALES_ORG_FEE==null?"":IONPay.Utils.fnAddComma(data.SALES_ORG_FEE)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FEE==null?"":IONPay.Utils.fnAddComma(data.FEE)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VAT==null?"":IONPay.Utils.fnAddComma(data.VAT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){
						   		if(data.PAY_AMT > 0){
						   			return "<a href='#' onclick='fnViewPayAmtDetail(\""+data.VID+"\",\""+data.TRAN_DT+"\");'>"+data.PAY_AMT+" </a>";
						   		}else{
						   			return data.PAY_AMT==null?"":IONPay.Utils.fnAddComma(data.PAY_AMT)
						   		}
						   }
					   },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.PAY_VAT==null?"":IONPay.Utils.fnAddComma(data.PAY_VAT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_AMT==null?"":IONPay.Utils.fnAddComma(data.RESR_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.EXTRA_AMT==null?"":IONPay.Utils.fnAddComma(data.EXTRA_AMT)} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_FLAT_CNT==null?"":data.CARD_FLAT_CNT} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_FLAT_FEE==null?"":data.CARD_FLAT_FEE} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.DPST_AMT==null?"":IONPay.Utils.fnAddComma(data.DPST_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_TRAN_AMT==null?"":IONPay.Utils.fnAddComma(data.CARRY_TRAN_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_FEE==null?"":IONPay.Utils.fnAddComma(data.CARRY_FEE)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_VAT==null?"":IONPay.Utils.fnAddComma(data.CARRY_VAT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_PAY_AMT==null?"":IONPay.Utils.fnAddComma(data.CARRY_PAY_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_PAY_VAT==null?"":IONPay.Utils.fnAddComma(data.CARRY_PAY_VAT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_RESR_AMT==null?"":IONPay.Utils.fnAddComma(data.CARRY_RESR_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_EXTRA_AMT==null?"":IONPay.Utils.fnAddComma(data.CARRY_EXTRA_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_DPST_AMT==null?"":IONPay.Utils.fnAddComma(data.CARRY_DPST_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.TOT_DPST_AMT==null?"":IONPay.Utils.fnAddComma(data.TOT_DPST_AMT)} },
					   
						{ "class" : "columnc all", 			"data" : null, "render":function(data){
					   		if(data.PAY_AMT > 0){
					   			return "<a href='#' onclick='fnSendReportMailView(\""+data.VID+"\",\""+data.TRAN_DT+"\",\""+data.EMAIL+"\"); return false;' > 발송 </a>";
					   		}else{
					   			return data.PAY_AMT==null?"":IONPay.Utils.fnAddComma(data.PAY_AMT)
					   		}
					  	 }
				   		}
	               ]
	       }, true);
	    } else {
	       objListInquiry.clearPipeline();
	       objListInquiry.ajax.reload();
	    }
	   	$("#div_mail").hide();
		IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/agencyStmtMgmt/selectAgentStmtReportListExcel.do");
	}
}

//상세내역 modal
function fnViewPayAmtDetail(vid, tranDt){
	//pay_amt > 0
	//등록비 배분 상세내역 조회 
	arrParameter["vid"] = vid;
	arrParameter["trDt"] = tranDt;
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/selectAgentCoPayAmtDetail.do";
	strCallBack  = "fnViewPayAmtDetailRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnViewPayAmtDetailRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#div_search").hide(200);
		$("#div_searchResult").hide(200);
		$("#div_mail").hide(200);
		$("#div_payAmtDetail").show(200);
		var str = "";
		
		if(objJson.data.length != 0 ){
			for(var i=0; i<objJson.data.length; i++){
				str += "<tr style='text-align: center; '>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RNUM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PAY_CD_NM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].ID+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].CO_NM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].REG_DT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PAY_DT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PAY_AMT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RSHARE_RATE+"%</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RPAY_AMT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RPAY_VAT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PM_NM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].TID+"</td>";
				str += "</tr>";
			} 
			$("#tbody_payAmtDetail").html(str);
			
			str = "";
			str += "<tr style='text-align: center; '>";
			str += "<td colspan='8' style='text-align:center; border:1px solid #ddd;'>&nbsp;</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totRPayAmt+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totRPayVat+"</td>";
			str += "<td colspan='2' style='text-align:center; border:1px solid #ddd;'>&nbsp;</td>";
			str += "</tr>";		
			$("#tbody_totDetail").html(str);
		}else{
			str += "<tr style='text-align: center; '>";
			str += "<td colspan='12' style='text-align:center; border:1px solid #ddd;'><spring:message code='IMS_BIM_BM_0035'/></td>";
			str += "</tr>";
			$("#tbody_payAmtDetail").html(str);
		}
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

//send mail
function fnSendReportMailView(vid, taxMon, email){
	$("#div_search").hide(200);
	$("#div_searchResult").hide(200);
	$("#div_payAmtDetail").hide(200);
	$("#div_mail").show(200);
	if (typeof objSendMail == "undefined") {
   		objSendMail = IONPay.Ajax.CreateDataTable("#tbMail", true, {
               url: "/calcuMgmt/agencyStmtMgmt/selectAgentStmtTaxAccount.do",
               data: function() {	
            		arrParameter["vid"] = vid;
	           	 	arrParameter["mon"] = taxMon;
	           	 	arrParameter["email"] = email;
	           	 	arrParameter["worker"] = strWorker;
                   return arrParameter;
               },
               columns: [
					{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.VGRP_NM==null?"":data.VGRP_NM} },
					{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.VID==null?"":data.VID} },
					{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.REP_NM==null?"":data.REP_NM} },
					{ "class" : "columnc all", 			"data" : null, "render":function(data){return "대리점 정산 메일"} },
					{ "class" : "columnc all", 			"data" : null, "render":
						function(data){
								return "<input type='text' name='emailAddr' value='"+(email==null?"":email)+"' maxlength='60' class='form-control'>";
						}
					},
					{ "class" : "columnc all", 			"data" : null, "render":
						function(data){
							return "<button type='button' name='' onclick='fnSendReportMail(\""+data.VID+"\",\""+taxMon+"\");' class='btn btn-primary btn-cons'> 발송 </button>";
						}
					}
               ]
       }, true);
    } else {
       objSendMail.clearPipeline();
       objSendMail.ajax.reload();
    }
	IONPay.Utils.fnShowSearchArea();
    //IONPay.Utils.fnHideSearchOptionArea();
}
// function fnSen
function fnSendReportMail(vid, taxMon){
	console.log(vid);
	console.log(taxMon);
	if(!fnChkEmail($("#frmSendMail input[name=emailAddr]").val())){
		IONPay.Msg.fnAlert('이메일주소가 유효하지 않습니다.');
	    return;
	}
	//ajax
	arrParameter["vid"] = vid;
	arrParameter["taxMon"] = taxMon;
	arrParameter["email"] = $("#frmSendMail input[name=emailAddr]").val();
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/sendAgentStmtTaxAccount.do";
	strCallBack  = "fnAgentSettlmntTaxAccountRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnAgentSettlmntTaxAccountRet(objJson){
	if(objJson.resultCode == 0){
		IONPay.Msg.fnAlert(objJson.resultMessage);
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0123'/></span></h3>
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
                                        	<select id="year" name="year"  style="width: 80%;" class="select2 form-control">
                           					</select>
                               				<span style="float: right;margin: -8% 8%; "><spring:message code="DDLB_0091" /></span>
	                                    </div>
	                                    <div class="col-md-2" >
	                                    	<label class="form-label">&nbsp;</label>
	                                    	<select id="mon"name="mon"  style="width: 80%;"class="select2 form-control">
                                      		</select>
                                      		<span style="float: right; margin: -8% 8%;"><spring:message code="IMS_BIM_BM_0628" /></span>
	                                    </div>
	                                    <div class="col-md-8" ></div>
                                    </div>
                                    <div class="row form-row"   style="padding:10px 0 10px 0;" >
	                                    <div class="col-md-2" >
											<label class="form-label"><spring:message code="DDLB_0139"/></label>
                                        	<input type="text" id="id" name="id" maxlength="10" class="form-control"  >
	                                    </div>
                                        <div class="col-md-4"></div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_CCS_0005'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
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
                                            <table id="tbListSearch"  class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                            		 <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0630'/></th>
                                            		 <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0631'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0632'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='DDLB_0139'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0571'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0364'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_SM_SR_0018'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0623'/></th>
			                                         <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0437'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0556'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0624'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0625'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0633'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0555'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0634'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0635'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0636'/></th>
                                                     <th colspan="8"><spring:message code='IMS_BIM_BM_0626'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0637'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0296'/></th>
                                                 </tr>
                                                 <tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0364'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0437'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0556'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0624'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0625'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0633'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0555'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0636'/></th>
                                                 </tr>
                                            	</thead>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                                <div id="div_payAmtDetail"  >
	                                    <div class="grid simple">
	                                        <div class="grid-body" id="">
	                                            <table id="tbPayAmtDetail" class="table" style="width:100%">
	                                            	<thead>
	                                            		<tr>
	                                            		 <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
	                                            		 <th ><spring:message code='IMS_BIM_BM_0101'/></th>
	                                                     <th ><spring:message code='IMS_BIM_MM_0054'/></th>
	                                                     <th ><spring:message code='IMS_BM_CM_0028'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0105'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0106'/></th>
	                                                     <th ><spring:message code='IMS_TV_TH_0029'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0437'/></th>
				                                         <th ><spring:message code='IMS_BIM_BM_0624'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0625'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0132'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0689'/></th>
	                                            	</tr>
	                                            	</thead>
	                                            	<tbody id="tbody_payAmtDetail"></tbody>
	                                            	<tbody id="tbody_totDetail"></tbody>
	                                            </table>
	                                        </div>
	                                    </div>  
	                                </div>
                           	 	</div>
                        </div>
                    </div>                
                </div>
                <form id="frmSendMail">
	                <div id="div_mail" class="row">
	                    <div class="col-md-12">
	                        <div class="grid simple">
	                            <div class="grid-title no-border">
	                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
	                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
	                            </div>
	                            <div class="grid-body no-border">
	                                <div id="" >
	                                    <div class="grid simple ">
	                                        <div class="grid-body " id="">
	                                            <table id="tbMail" class="table" style="width:100%">
	                                            	<thead>
	                                            		<tr>
	                                                     <th ><spring:message code='IMS_BIM_BM_0632'/></th>
				                                         <th ><spring:message code='DDLB_0139'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0571'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0688'/></th>
	                                                     <th ><spring:message code='IMS_BIM_MM_0166'/></th>
	                                                     <th ><spring:message code='IMS_BIM_MM_0034'/></th>
	                                                 	</tr>
	                                            	</thead>
	                                            	<tbody id="mainInfo"></tbody>
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
