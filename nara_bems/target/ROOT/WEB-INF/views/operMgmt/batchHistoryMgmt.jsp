<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objListInquriy;
$(document).ready(function(){
	fnInitEvent();
	fnSetDDLB();
});

function fnInitEvent() {
   
}
function fnSetDDLB(){
	$("#successFlg").html("<c:out value='${SUCCESS_FLG}' escapeXml='false' />");
}
function fnSelectListInquriy(){
	$("#div_search").css("display", "block");
	
   	if (typeof objListInquriy == "undefined") {
   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbJobHistList", true, {
               url: "/operMgmt/batchMgmt/selectBatchJobHistList.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_HISTORY_ID} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_ID} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_START_TIME} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_END_TIME} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_DURING_TIME} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.IS_SUCCESS}},
//                    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RETRY_COUNT}},
                   { "class" : "columnc all", 			"data" : null, "render":
               	   		function(data){
                	   		var str = "";
                	   		if(data.IS_SUCCESS == "N"){
// 	                	   		str += "<button type='button' onclick='fnProc(\""+data.JOB_ID+"\",\""+data.JOB_HISTORY_ID+"\",\""+data.RETRY_COUNT+"\",\"E_START\", \"HIST\");' class='btn btn-primary btn-cons'  > <spring:message code='IMS_BAT_NM_0015'/> </button>" 
	                	   		str += "<button type='button' onclick='fnErrorMsg(\""+data.ERR_REASON+"\");' class='btn btn-primary btn-cons'  > <spring:message code='IMS_BAT_NM_0039'/> </button>";
                	   		}
                	   		return str;		   
                   		}
                   }
               ]
       }, true);
    } else {
       objListInquriy.clearPipeline();
       objListInquriy.ajax.reload();
    }
	IONPay.Utils.fnShowSearchArea();
    IONPay.Utils.fnHideSearchOptionArea();
}
//실행
function fnProc(jobId, jobHistId, retryCnt, stFlg,retryFlg){
	arrParameter["jobId"] = jobId;
	arrParameter["jobHistId"] = jobHistId;
	arrParameter["retryCnt"] = retryCnt;
	arrParameter["stFlg"] = stFlg;
	arrParameter["retryFlg"] = retryFlg;
	strCallUrl = "/operMgmt/batchMgmt/processing.do"; //proc
	strCallBack = "fnProcRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnProcRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);	
		fnSelectListInquriy();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		fnSelectListInquriy();
	}
}
function fnErrorMsg(errorMsg){
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalErrorResult").modal();
	$("#modalErrorResult #textErrResult").html(errorMsg);
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.BATCH_MANAGEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0129'/></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-body no-border">
                            	<br>
                               	<form id="frmSearch" name="frmsearch">
	                                <div class="row form-row" style="padding:0 0 10px 0;">                                    
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BAT_NM_0031'/></label>
                                            <input type="text" id="jobId" name="jobId" class="form-control">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BAT_NM_0032'/></label>
                                            <select id="successFlg" name="successFlg" class="select2 form-control">   
                                            <option value="Y"><spring:message code='IMS_BAT_NM_0029'/></option>
                                            <option value="N"><spring:message code='IMS_BAT_NM_0030'/></option>                                          
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                        </div>	                                    
	                                </div>                                
		                            <div class="row form-row" >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BAT_NM_0028'/></label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="txtFromDate" name="txtFromDate" class="form-control">
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
                                        <div id="divSearchDateType4" class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0021'/></button>                                       
                                            <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0022'/></button>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch"  onclick="fnSelectListInquriy();" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_NM_0026'/></button>                                            
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
                <div id="div_search" class="row" style="display:none">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_IM_0032'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>                        
                            <div class="grid-body no-border" >
                                <div id="div_searchResult" >                               
                                    <div class="grid simple ">
                                        <div class="grid-body ">
                                            <table class="table" id="tbJobHistList" style="width:100%">
                                                <thead>
                                                    <tr>
                                                        <th><spring:message code='IMS_BAT_NM_0033'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0034'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0035'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0036'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0037'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0032'/></th>
<%--                                                         <th><spring:message code='IMS_BAT_NM_0038'/></th> --%>
                                                        <th><spring:message code='IMS_BAT_NM_0026'/></th>
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
<!-- BEGIN MODAL -->
		<div class="modal fade" id="modalErrorResult"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
<!-- 		                <i id="icon" class="fa fa-envelope-o fa-2x"></i> -->
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BAT_NM_0039"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                	<tr>
<%--                                         <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0039'/></th>  --%>
                                        <td style='border:1px solid #ddd;    background-color: #e7eff9;' >
                                        	<textarea rows="30" cols="50" id="textErrResult" readonly="readonly" style="width: 100%;"></textarea>
                                       	</td>
                                    </tr>
                                 </thead>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
    <!-- END MODAL -->