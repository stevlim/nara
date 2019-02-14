<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strStmtFlg5 = "<%=request.getParameter("SETT_AUTH_FLG5")%>";
var strStmtFlg6 = "<%=request.getParameter("SETT_AUTH_FLG6")%>";

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
	$("#div_search").hide();
   	$("select[name=division]").on("change", function(){
   		if($.trim(this.value)=="ALL"){
   			$("#id").val("");
   			$("#frmSearch #id").attr("readonly", true);
   		}else{
   			$("#frmSearch #id").attr("readonly", false);
   		}
   	});
    
    $("#btnSearch").on("click", function() {
    	$("#div_search").show(200);
    	fnSelectListInquriy("SEARCH");
    });
    $("#btnExcel").on("click", function() {
    	fnSelectListInquriy("EXCEL");
    });
}
function fnSetDDLB(){
	$("select[name=selType]").html("<c:out value='${selType}' escapeXml='false' />");
	$("select[name=selDecide]").html("<c:out value='${selDecide}' escapeXml='false' />");
	$("select[name=selPayType]").html("<c:out value='${selPayType}' escapeXml='false' />");
}
function fnSelectListInquriy(strType){
	 if(strType == "SEARCH"){
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["worker"] = strWorker;
		strCallUrl   = "/calcuMgmt/reportMgmt/selectStmtPayRepList.do";
	    strCallBack  = "fnStmtPayRepListRet";
	    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/reportMgmt/selectStmtPayRepListExcel.do");
	}
}
function fnStmtPayRepListRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data.length > 0 ){
		var str = ""
		// 합계
		var iTotCardAmt = 0;
		var iTotAccntAmt = 0;
		var iTotVacctAmt = 0;
		var iTotCPAmt = 0;
		var iTotResrAmt = 0;
		var iTotResrCcAmt = 0;
		var iTotExtraAmt = 0;
		var iTotFee = 0;
		var iTotVat = 0;
		var iTotDepositAmt = 0;
		for(var i=0; i<objJson.data.length; i++){
			iTotCardAmt += data.CARD_AMT;
			iTotAccntAmt += data.ACCNT_AMT;
			iTotVacctAmt += data.VACCT_AMT;
			iTotCPAmt += data.CP_AMT;
			iTotResrAmt += data.RESR_AMT;
			iTotResrCcAmt += data.RESR_CC_AMT;
			iTotExtraAmt += data.EXTRA_AMT;
			iTotFee += data.FEE;
			iTotVat  += data.VAT;
			iTotDepositAmt += data.DPST_AMT;
			
			
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].STMT_DT;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].ID;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].CO_NM;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].REP_NM;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].PAY_ID_NM;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].CARD_CNT == 0 ){
				str += "0";
			}else{
				str += "<a href='#' >"+objJson.data[i].CARD_AMT + "</a>";
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].ACCNT_CNT == 0 ){
				str += "0";
			}else{
				str += "<a href='#' >"+objJson.data[i].ACCNT_AMT + "</a>";
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].VACCT_CNT == 0 ){
				str += "0";
			}else{
				str += "<a href='#' >"+objJson.data[i].VACCT_AMT + "</a>";
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].CP_CNT == 0 ){
				str += "0";
			}else{
				str += "<a href='#' >"+objJson.data[i].CP_AMT + "</a>";
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].RESR_AMT == 0 ){
				str += "0";
			}else{
				str += "<a href='#' >"+objJson.data[i].RESR_AMT + "</a>";
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].RESR_CC_AMT == 0 ){
				str += "0";
			}else{
				str += "<a href='#' >"+objJson.data[i].RESR_CC_AMT + "</a>";
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].EXTRA_AMT == 0 ){
				str += "0";
			}else{
				str += "<a href='#' >"+objJson.data[i].EXTRA_AMT + "</a>";
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].FEE == "" ){
				str += "";
			}else{
				str += objJson.data[i].FEE;
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].VAT == "" ){
				str += "";
			}else{
				str += objJson.data[i].VAT;
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(objJson.data[i].DPST_AMT == "" ){
				str += "";
			}else{
				str += objJson.data[i].DPST_AMT;
			}
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].DEL_FLG_NM;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			if(strStmtFlg5 == "1" && strStmtFlg6 == "1" && (data.STATUS == "0" || data.STATUS == "1")){
				str += "<input type='checkbox' name='chkProc' value='' >";
			}else if(strStmtFlg5 == "1" && strStmtFlg6 == "0" && data.STATUS == "0"){
				str += "<input type='checkbox' name='chkProc' value='' >";
			}else if(strStmtFlg5 == "0" && strStmtFlg6 == "1" && data.STATUS == "1"){
				str += "<input type='checkbox' name='chkProc' value='' >";
			}else{
				"확정";
			}
			str += "</td>";
			str += "</tr>";
		}
		str += "<tr style='text-align: center; '>";
		str += "<td colspan='4'style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += "합계";
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >";
		str += objJson.data.length+" 건";
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += iTotCardAmt ;
		str += "</td >";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += iTotAccntAmt ;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += iTotVacctAmt ;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += iTotCPAmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += iTotResrAmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += iTotResrCcAmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += iTotExtraAmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA; '>";
		str += iTotFee;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA; '>";
		str += iTotVat;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA; '>";
		str += iTotDepositAmt;
		str += "</td>";
		str += "<td colspan='2' style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' ></td>";
		str += "</tr>";
		$("#listInfo").html(str);
		
		var strInfo = "";
		if((strStmtFlg5 == "1" || strStmtFlg6 == "1") && data.STMT_DT != ""){
			$("#tdBtn").css("display", "block");
			if(strStmtFlg5 == "1"){
				strInfo = "<button type='button'  id='btnExcel' class='btn btn-primary btn-cons' onclick='fnReqUpdate(\'1\')'>담당자 확정 </button>";
			}
			if(strStmtFlg6 == "1" ){
				strInfo = "<button type='button'  id='btnExcel' class='btn btn-primary btn-cons' onclick='fnReqUpdate(\'2\')'>팀장 확정 </button>";
			}
			$("#tdBtn").html(strInfo);
		}
		}else{
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;' colspan='17'>";
			str += "" +gMessage("IMS_COM_EXCEL_0001")+"</td></tr>";
			$("#listInfo").html(str);
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnChkChange(obj){
	var chkProc = document.getElementsByName('chkProc');
    
	  if(obj.checked) { 
	    for(i = 0; i < chkProc.length; i++) {
	    	if(!chkProc[i].disabled) chkProc[i].checked = true;
	    }
	  } else { 
	    for(i = 0; i < chkProc.length; i++) {
	      chkProc[i].checked = false;
	    }	  
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0108'/></span></h3>
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
                                    <div class="row form-row"  style="padding:0 0 10px 0;" >
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0566" /></label>
                                        	<select id="selType" name="selType"  class="select2 form-control">
                                       		</select>
	                                   	</div>
                                        <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0567" /></label>
                                        	<select id="selDecide" name="selDecide"  class="select2 form-control">
                                       		</select>
	                                    </div>
	                                    <div class="col-md-6" ></div>
                                    </div>
                                    <div class="row form-row"   >
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_SM_SR_0063" /></label>
                                        	<input type="text" id=id name="id" maxlength='10'  class="form-control">
	                                   	</div>
                                        <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0149" /></label>
                                        	<select id="selPayType" name="selPayType"  class="select2 form-control">
                                       		</select>
	                                    </div>
	                                    <div class="col-md-3" ></div>
	                                    <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button"  id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_MM_0103'/></button>
				                                  <button type="button"  id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
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
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0565'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0570'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0571'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0572'/></th>  
                                                     <th ><spring:message code='IMS_BIM_BM_0280'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0281'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0282'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0283'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0327'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0328'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0555'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0310'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0556'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0573'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0574'/></th>
													 <th>
													 	<div class="checkbox check-success" style="padding-top:10px; padding-bottom:0; float: left; width: 68%;" >
													 		<input id="chkAll"  name="chkAll"  value="01"  type="checkbox"  onclick="fnChkChange(this);" >
									                   		<label for="chkAll"></label>
													 	</div>
													 </th>	                                                     
                                                 </tr>
                                            	</thead>
                                            	<tbody id="listInfo"></tbody>
                                            </table>
                                            <table class="table" id="tableBtn" style="display: none;">
                                            	<tr>
                                            		<td colspan="2"></td>
                                            	</tr>
                                            	<tr>
                                            		<td id="tdBtn"></td>
                                            	</tr>
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
