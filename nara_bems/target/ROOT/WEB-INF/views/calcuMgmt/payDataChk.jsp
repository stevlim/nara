<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objStmtListInquiry;
var objStmtFeeListInquiry;
var objStmtOffListInquiry;
$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
	$("#div_search").hide();
	$("select[name=selType]").on("change", function(){
		if($("#selType").val() == "settlmnt"){
			$("#divToDt").css("display","none");
		}else{
			$("#divToDt").css("display","block");
		}
	});
	
    $("#btnSearch").on("click", function() {
    	$("#div_search").show(200);
    	if($("#selType").val() == "settlmnt"){
    		$("#dataChk").html("지급일자");
    	}else{
    		$("#dataChk").html("승인일자");
    	}
    	fnSelectStmtListInquiry();
    	fnSelectStmtFeeListInquiry();
    	fnSelectStmtOffListInquiry();
    });

}
function fnSetDDLB(){
}
//지급데이터 검증
function fnSelectStmtListInquiry(){
	arrParameter = $("#frmSearch").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/reportMgmt/selectStmtInsList.do";
    strCallBack  = "fnSelectStmtListInquiryRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectStmtListInquiryRet(objJson){
	if(objJson.resultCode == 0 ){
		var str = ""
   		var cardApp=0;
		var acctApp=0;
		var vacctApp=0;
		var hppApp=0;
		var cardStmt=0;
		var acctStmt=0;
		var vacctStmt=0;
		var hppStmt=0; 
		var cardGap=0;
		var acctGap=0;
		var vacctGap=0;
		var hppGap= 0;
		for(var i=0; i<objJson.data.length; i++){
			cardApp = cardApp + objJson.data[i].CARD_APP;
			acctApp = acctApp + objJson.data[i].ACCT_APP;
			vacctApp = vacctApp + objJson.data[i].VACCT_APP;
			hppApp = hppApp + objJson.data[i].HPP_APP;
			cardStmt = cardApp + objJson.data[i].CARD_STMT;
			acctStmt = acctStmt + objJson.data[i].ACCT_STMT;
			vacctStmt = vacctStmt + objJson.data[i].VACCT_STMT;
			hppStmt = hppStmt + objJson.data[i].HPP_STMT;
			cardGap = cardGap + objJson.data[i].CARD_GAP;
			acctGap = acctGap + objJson.data[i].ACCT_GAP;
			vacctGap = vacctGap + objJson.data[i].VACCT_GAP;
			hppGap = hppGap + objJson.data[i].HPP_GAP;
			
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].STMT_CYCLE;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].CARD_APP;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].ACCT_APP;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].VACCT_APP;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].HPP_APP;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].CARD_STMT;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].ACCT_STMT;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].VACCT_STMT;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].HPP_STMT;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].CARD_GAP;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].ACCT_GAP;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].VACCT_GAP;
			str += "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>";
			str += objJson.data[i].HPP_GAP;
			str += "</td>";
			str += "</tr>";
		}
		str += "<tr style='text-align: center; '>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += "합계";
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >";
		str += cardApp;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += acctApp;
		str += "</td >";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += vacctApp;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += hppApp;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += cardStmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += acctStmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += vacctStmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>";
		str += hppStmt;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA; color:red;'>";
		str += cardGap;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA; color:red;'>";
		str += acctGap;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA; color:red;'>";
		str += vacctGap;
		str += "</td>";
		str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA; color:red;' >";
		str += hppGap;
		str += "</td>";
		str += "</tr>";
		$("#listInfo").html(str);
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
	
}
//수수료 검증
function fnSelectStmtFeeListInquiry(){
   	if (typeof objStmtFeeListInquiry == "undefined") {
   		objStmtFeeListInquiry = IONPay.Ajax.CreateDataTable("#tbStmtFeeListSearch", true, {
               url: "/calcuMgmt/reportMgmt/selectStmtFeeInsList.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MID} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACCT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VACCT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CP} }
               ]
       }, true);
    } else {
       objStmtFeeListInquiry.clearPipeline();
       objStmtFeeListInquiry.ajax.reload();
    }

	IONPay.Utils.fnShowSearchArea();
    IONPay.Utils.fnHideSearchOptionArea();
}
//채권 상계 회원사 리스트
function fnSelectStmtOffListInquiry(){
   	if (typeof objStmtOffListInquiry == "undefined") {
   		objStmtOffListInquiry = IONPay.Ajax.CreateDataTable("#tbStmtOffListSearch", true, {
               url: "/calcuMgmt/reportMgmt/selectStmtOffInsList.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
					{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.EXTRA_ID} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.OFF_ID}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.AMT} }
               ]
       }, true);
    } else {
       objStmtOffListInquiry.clearPipeline();
       objStmtOffListInquiry.ajax.reload();
    }

	IONPay.Utils.fnShowSearchArea();
    IONPay.Utils.fnHideSearchOptionArea();
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0107'/></span></h3>
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
                                        	<select id="selType" name="selType"  class="select2 form-control">
                                       			<option value="settlmnt" selected="selected">지급일자</option>
              									<option value="app">승인일자</option>
                                       		</select>
	                                    </div>
	                                    <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="stmtDt" name="stmtDt" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div class="col-md-3" id="divToDt" style="display: none;">
                                       		<label class="form-label">&nbsp;</label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="toDt" name="toDt" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                       	</div>
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
                <div id="div_search" class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <div id="div_searchDataResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0575'/>&nbsp;(<span id="dataChk">&nbsp;</span>)</h6>
                                            <table id="tbStmtListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0450'/></th>
                                                     <th colspan="4"><spring:message code='DDLB_0052'/></th>
                                                     <th colspan="4"><spring:message code='IMS_BM_IM_0003'/></th>
                                                     <th colspan="4"><spring:message code='IMS_BIM_BM_0317'/></th>
                                                 </tr>	
                                                 <tr>
                                                 	<th ><spring:message code='IMS_BIM_BM_0280'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0281'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0282'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0283'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0280'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0281'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0282'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0283'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0280'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0281'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0282'/></th>
                                                    <th ><spring:message code='IMS_BIM_BM_0283'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="listInfo"></tbody>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                                <div id="div_searchFeeResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0576'/></h6>
                                            <table id="tbStmtFeeListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0194'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0280'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0281'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0282'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0283'/></th>
                                                 </tr>
                                            	</thead>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                                <div id="div_searchCompResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0577'/></h6>
                                            <table id="tbStmtOffListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0023'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0029'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0131'/></th>
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
