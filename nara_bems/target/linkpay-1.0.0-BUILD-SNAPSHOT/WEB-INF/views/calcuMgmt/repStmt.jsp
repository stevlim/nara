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
   	$("select[name=division]").on("change", function(){
   		if($.trim(this.value)=="ALL"){
   			$("#id").val("");
   			$("#frmSearch #id").attr("readonly", true);
   		}else{
   			$("#frmSearch #id").attr("readonly", false);
   		}
   	});
    
    $("#btnProc").on("click", function() {
    	if($("#division").val() != "ALL" && $("#id").val().length < 10){
    		IONPay.Msg.fnAlert('조회 ID를 입력해주세요');
    		$("#id").focus();
    		return;
    	}
    	$("#div_search").show(200);
    	fnSelectAgentStmt();
    });

}
function fnSetDDLB(){
	$("select[name=division]").html("<c:out value='${division}' escapeXml='false' />");
}
//정산재생성 조회 
function fnSelectAgentStmt() {
	arrParameter = $("#frmSearch").serializeObject();
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/selectAgentStmtList.do";
	strCallBack  = "fnSelectAgentStmtRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectAgentStmtRet(objJson){
	if(objJson.resultCode == 0 ){
		var str = "";	
		if(objJson.data.length ==  0 ){
			str += "<tr style='text-align: center; '>";
			str += "<td colspan='24' style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'><spring:message code='IMS_BIM_MM_0011'/></td>";
			str += "<tr>>";
		}else{
			for(var i=0; i<objJson.data.length;i++){
				str += "<tr style='text-align: center; '>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.VID+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.STMT_DT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.TRAN_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.ORG_FEE+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.SALES_ORG_FEE+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.FEE+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.VAT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.PAY_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.PAY_VAT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.RESR_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.RESR_CC_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.EXTRA_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.DPST_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_TRAN_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_SALES_FEE+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_SALES_ORG_FEE+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_FEE+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_VAT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_PAY_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_PAY_VAT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_RESR_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_RESR_CC_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_EXTRA_AMT+"</td>";
				str += "<td  style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CARRY_DPST_AMT+"</td>";
				str += "</tr>";
			}
		}
		
		$("#tbody_list").html(str);
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0121'/></span></h3>
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
											<label class="form-label"><spring:message code="IMS_PW_DE_08" /></label>
                                        	<select id="division" name="division"  class="select2 form-control">
                                       		</select>
	                                    </div>
	                                    <div class="col-md-3" >
											<label class="form-label">&nbsp;</label>
                                        	<input type="text" id="id" name="id" maxlength="10" class="form-control"  >
	                                    </div>
                                        <div class="col-md-3"></div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnProc" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0552'/></button>
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
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0621'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0622'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0364'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_SM_SR_0018'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0623'/></th>
			                                         <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0437'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0556'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0624'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0625'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0554'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0555'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_SM_SR_0063'/></th>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0557'/></th>
                                                     <th colspan="11"><spring:message code='IMS_BIM_BM_0626'/></th>
                                                 </tr>
                                                 <tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0364'/></th>
                                                     <th ><spring:message code='IMS_SM_SR_0018'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0623'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0437'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0556'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0624'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0625'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0554'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0555'/></th>
                                                     <th ><spring:message code='IMS_SM_SR_0063'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0557'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_list"></tbody>
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
