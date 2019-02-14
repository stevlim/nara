<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objVanInfoInquiry;
var strType;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
    	strType="SEARCH";
    	$("#div_frm").hide();
    	$("#div_search").show();
    	fnSelectVanTerInfoList(strType);
    });
    $("#btnExcel").on("click", function() {
    	strType = "EXCEL";
    	fnSelectVanTerInfoList(strType);
    });
	$("#btnRegist").on("click", function() {
      	$("#registTab1").serializeObject();
		$("#div_search").hide();
		IONPay.Utils.fnHideSearchOptionArea();
    });  
}

function fnSetDDLB() {
	$("#CardCompanyList").html("<c:out value='${CardCompanyList}' escapeXml='false' />");
	$("#CardCompanyList1").html("<c:out value='${CardCompanyList1}' escapeXml='false' />");
	$("#MER_TYPE").html("<c:out value='${MER_TYPE}' escapeXml='false' />");
	$("#vanType").html("<c:out value='${VanType}' escapeXml='false' />");
	$("#VanType1").html("<c:out value='${VanType1}' escapeXml='false' />");
}

function fnSetValidate() {
    var arrValidate = {
                FORMID   : "frmEdit",
                VARIABLE : {                    
                    STATUS : {required: true}
                    }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

//van  REGIST
function fnVanRegist(){
	arrParameter = $("#frmRegist").serializeObject();
	arrParameter["WORKER"] = strWorker;
	strCallUrl   = "/baseInfoMgmt/subMallMgmt/insertVanTer.do";
	strCallBack  = "fnAllRegistRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnAllRegistRet(objJson){
	if (objJson.resultCode == 0) {
        IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
        IONPay.Utils.fnJumpToPageTop();
    } else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);	
    }
}
//van inquiry 
function fnSelectVanTerInfoList(strType){
	if(strType == "SEARCH"){
		if (typeof objVanInfoInquiry == "undefined") {
	        objVanInfoInquiry = IONPay.Ajax.CreateDataTable("#tbVanListSearch", true, {
	            url: "/baseInfoMgmt/subMallMgmt/selectVanTerInfo.do",
	            data: function() {	
	                return $("#frmSearch").serializeObject();
	            },
	            columns: [
	                { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return gMessage(data.MBS_TYPE_NM)} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VAN_NM}},
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TERM_NO} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return gMessage(data.CARD_NM)} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.OVER_FLG==null? "" : data.OVER_FLG} },  //해외구분 
	                { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.FR_DT)} },
	                { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.TO_DT)} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MEMO} }
	                ]
	        }, true);
	    } else {
	        objVanInfoInquiry.clearPipeline();
	        objVanInfoInquiry.ajax.reload();
	    }
	
	    IONPay.Utils.fnShowSearchArea();
	    IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/baseInfoMgmt/subMallMgmt/selectVanListExcel.do");
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.AFFILIATE_MANAGEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
	            <div id="div_frm" class="row" style="display:none;">
	                <div class="col-md-12">
	                    <div class="grid simple">
	                        <div class="grid-title no-border">
	                            <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title"><spring:message code="IMS_BIM_BM_0385" /></span></h4>
	                            <div class="tools"><a href="javascript:;" class="remove"></a></div>
	                        </div>                          
	                        <div class="grid-body no-border">
		                         <!-- BEGIN registTab1 AREA -->  
		                         <div id="registTab1" class="tab-pane" >
		                         	<form id="frmRegist" name="frmRegist">
		                                <div class="row form-row" style="padding: 0 0 10px 0;">
		                                	<div class="col-md-3">
		                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0359" /></label>
		                                    	<select class="select2 form-control" id="VanType1" name="VanType">
		                                        </select>
	                                        </div>
	                                        <div class="col-md-3">
		                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0396" /></label>
		                                    	<input type="text" class="form-control"  id="TERM_NO" name="TERM_NO" >
	                                        </div> 
		                                	<div class="col-md-3">
		                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label>
		                                    	<input type="text" class="form-control"  id="MBS_NO" name="MBS_NO" >
	                                        </div>
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0;">
	                                        <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_CCS_0001" /></label> 
		                                        <select class="select2 form-control" id="CardCompanyList1" name="CardCompanyList">
		                                        </select>
		                                    </div> 
                               		 		<div class="col-md-3">
                               		 			<label class="form-label"><spring:message code="IMS_BIM_BM_0381" /></label>
                               		 			<input type="text" class="form-control"  id="memo" name="memo" >
                               		 		</div>
                               		 		<div class="col-md-3">
                               		 			<label class="form-label"><spring:message code="IMS_BIM_BM_0267" /></label>
                               		 			<input type="text" class="form-control"  id="frDt" name="frDt"  maxlength="10" onkeyup="fnReplaceDate(this)">
                               		 		</div>
                               		 	</div>
                        		 		<div class="row form-row" style="padding: 0 0 10px 0;">
                        		 			<div class="col-md-12">
                        		 				<label class="form-label" style="color:red;"><spring:message code="IMS_BIM_BM_0398" /></label>
                        		 			</div>
                        		 		</div>
		                         	</form>
	                             </div>
		                         <!-- END registTab1 AREA -->
	                        </div>
	                        <div class="grid-body no-border">
	                            <div class="row form-row">
	                                <div class="col-md-12" align="center" >
                                        <button type="button" id="btnEdit"  onclick="fnVanRegist();"class="btn btn-danger auth-all"  ><spring:message code="IMS_BIM_BM_0138" /></button>
	                                </div>
	                            </div>
	                        </div>                          
	                    </div>
	                </div>
	            </div>           
	            <!-- END PAGE FORM -->
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
                                    <div class = "row form-row" style = "padding:0 0 5px 0;">
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="DDLB_0141" />/<spring:message code="DDLB_0140" /></label> 
	                                        <select class="select2 form-control" id="MER_TYPE" name="MER_TYPE">
	                                        </select>
	                                    </div>               
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_BIM_CCS_0001" /></label> 
	                                        <select class="select2 form-control" id="CardCompanyList" name="CardCompanyList">
	                                        </select>
	                                    </div> 
	                                    <div class="col-md-3">
	                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0359" /></label>
	                                    	<select class="select2 form-control" id="vanType" name="vanType">
	                                        </select>
                                        </div>    
                            		</div>
                            		<div class="row form-row"  style = "padding:0 0 5px 0;">
                            			<div class="col-md-3">
	                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0396" /></label>
	                                    	<input type="text" class="form-control"  id="termNo" name="termNo" >
                                        </div> 
                                        <div class="col-md-3">
	                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label>
	                                    	<input type="text" class="form-control"  id="mbsNo" name="mbsNo" >
                                        </div>
                                        <div class="col-md-3"></div>
			                          <div class="col-md-3">
			                              <label class="form-label">&nbsp;</label>
			                              <div>
			                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
			                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
			                                  <button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0380'/></button>
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
                                <div id="div_searchResult" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " >
                                            <table id="tbVanListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                            			<th>No</th>
                                            			<th ><spring:message code='IMS_BIM_BIR_0021'/>/<spring:message code='IMS_BIM_BIR_0022'/></th>
                                            			<th ><spring:message code='IMS_BIM_CCS_0030'/></th>
                                            			<th ><spring:message code='IMS_BIM_BM_0396'/></th>
                                            			<th ><spring:message code='IMS_BIM_CCS_0001'/></th>
                                            			<th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                            			<th ><spring:message code='IMS_BM_CM_0087'/></th>
                                            			<th ><spring:message code='IMS_BIM_BM_0254'/></th>
                                            			<th ><spring:message code='IMS_BIM_BM_0397'/></th>
                                            			<th ><spring:message code='IMS_BIM_BM_0381'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tr style="text-align: center;">
                                            		<td colspan="11"><spring:message code='IMS_BIM_BM_0177'/></td>
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
