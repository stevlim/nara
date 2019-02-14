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
	fnSelectListInquriy();
	//setInterval(function(){fnSelectListInquriy(); }, 5000);

});

function fnInitEvent() {
	$("#btnAddJob").on("click", function() {
		// 특정 id form reset
		  $("form").each(function() {
                if(this.id == "frmJobInfo") this.reset();
             });
    });
}

function subStr(){
	var fullStr = "문자열";
	var lastChar = fullStr.charAt(fullStr.length-1); //열
}

function fnSetDDLB(){
	$("#modalJobInfo select[name=jobUse]").html("<c:out value='${JOB_USE}' escapeXml='false' />");
	$("#modalJobInfo select[name=jobState]").html("<c:out value='${JOB_STATE}' escapeXml='false' />");
}
function fnSelectListInquriy(){
	$("#div_search").css("display", "block");
   	if (typeof objListInquriy == "undefined") {
   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbJobList", true, {
               url: "/operMgmt/batchMgmt/selectBatchJobList.do",
               data: function() {
                   //return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM}},
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_ID} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_NAME} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_CLASS_NAME} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_TRIGGER} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_USE_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.JOB_STATE_NM}},
                   { "class" : "columnc all", 			"data" : null, "render":
               	   		function(data){
                	   		var str = "";
                	   		str += "<button type='button' onclick='fnMod(\""+data.JOB_ID+"\",\""+data.JOB_NAME+"\",\""+data.JOB_DETAIL+"\",\""+data.JOB_PACKAGE_PATH+"\",\""+data.JOB_CLASS_NAME+"\",\""+data.JOB_TRIGGER+"\",\""+data.JOB_USE+"\",\""+data.JOB_STATE+"\",\""+data.JOB_USE_NM+"\",\""+data.JOB_STATE_NM+"\");' class='btn btn-primary btn-cons'  > <spring:message code='IMS_BAT_NM_0022'/> </button>";
                	   		if(data.JOB_STATE == "0"){
                	   			str +="<button type='button' onclick='fnProc(\""+data.JOB_ID+"\",\"E_START\", null);' class='btn btn-primary btn-cons'  > <spring:message code='IMS_BAT_NM_0015'/> </button>";
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
   	$("select[name=tbJobList_length] option[value=25]").attr("selected", true);
	IONPay.Utils.fnShowSearchArea();
    //IONPay.Utils.fnHideSearchOptionArea();
}
//실행
function fnProc(jobId, stFlg, retryFlg){
	arrParameter["jobId"] = jobId;
	arrParameter["stFlg"] = stFlg;
	arrParameter["retryFlg"] = retryFlg;
	strCallUrl = "/operMgmt/batchMgmt/processing.do"; //proc
	strCallBack = "fnProcRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnProcRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalUpdJobInfo").modal("hide");
		fnSelectListInquriy();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnAddJob(){
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalJobInfo").modal();
	$("#modalJobInfo #trSeq").css("display", "none");
}
//사용유무 업데이트
function fnUpdUse(jobId, useType){
	arrParameter = $("#frmUpdJobInfo").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl = "/operMgmt/batchMgmt/updateUseType.do";
	strCallBack = "fnUpdUseRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnUpdUseRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("사용유무 변경 완료");
		if(objJson.data.JOB_USE == "0"){
			$("#modalUpdJobInfo #tdUse").show();
			$("#modalUpdJobInfo #tdUnUse").hide();
			$("#modalUpdJobInfo input[name=jobUse]").val(jobUse);
			$("#modalUpdJobInfo #labJobUse").html(jobUseNm);
		}else{
			$("#modalUpdJobInfo #tdUse").hide();
			$("#modalUpdJobInfo #tdUnUse").show();
			$("#modalUpdJobInfo input[name=jobUse]").val(jobUse);
			$("#modalUpdJobInfo #labJobUse").html(jobUseNm);
		}
		fnSelectListInquriy();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
//job update
function fnMod(jobId, jobName,jobDetail, jobPack, jobClassNm, jobTrigger, jobUse, jobState, jobUseNm, jobStateNm){
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalUpdJobInfo").modal();
	$("#modalUpdJobInfo #trSeq").css("display", "block");
	//화면에 뿌리기
	$("#modalUpdJobInfo input[name=jobId]").val(jobId);
	$("#modalUpdJobInfo input[name=jobName]").val(jobName);
	$("#modalUpdJobInfo input[name=jobDetail]").val(jobDetail);
	$("#modalUpdJobInfo input[name=jobPack]").val(jobPack);
	$("#modalUpdJobInfo input[name=jobClassNm]").val(jobClassNm);
	$("#modalUpdJobInfo input[name=jobTrigger]").val(jobTrigger);
	$("#modalUpdJobInfo input[name=jobState]").val(jobState);
	$("#modalUpdJobInfo #labJobState").html(jobStateNm);

	if(jobUse == "0"){
		$("#modalUpdJobInfo #tdUse").show();
		$("#modalUpdJobInfo #tdUnUse").hide();
		$("#modalUpdJobInfo input[name=jobUse]").val(jobUse);
		$("#modalUpdJobInfo #labJobUse").html(jobUseNm);
	}else{
		$("#modalUpdJobInfo #tdUse").hide();
		$("#modalUpdJobInfo #tdUnUse").show();
		$("#modalUpdJobInfo input[name=jobUse]").val(jobUse);
		$("#modalUpdJobInfo #labJobUse").html(jobUseNm);
	}
}
function fnUpdate(){
	arrParameter = $("#frmUpdJobInfo").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl = "/operMgmt/batchMgmt/updateBatchJob.do";
	strCallBack = "fnModRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnModRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalUpdJobInfo").modal("hide");
		fnSelectListInquriy();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
//job 추가 저장
function fnSave(){
	arrParameter = $("#frmJobInfo").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl = "/operMgmt/batchMgmt/insertBatchJob.do";
	strCallBack = "fnSaveRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSaveRet(objJson){
if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalJobInfo").modal("hide");
		fnSelectListInquriy();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function subStr(formId){
	var fullStr =   $( "#"+formId +" input[name=jobPack]").val(); // "/linkpay_ims/src/main/java/egov/linkpay/ims/operMgmt/dao/OperMgmtDAO.java"; //5번쨰/ 찾은뒤 앞에꺼 지우고, 제일 마지막 .찾아서 삭제하고 다음 input에 넣기
	var ind = fullStr.indexOf("\/java\/")+6;
	var lastStr = "";
	//앞 path 제거
	fullStr = fullStr.substr(ind, fullStr.length);
	// / -> . 로 변환
	var test = fullStr.split("/");
	var pkg = "";
	 for(var i=0; i<test.length-1;i++){
		 console.log(test[i]);
		 if(i == test.length-2){
			 pkg += test[i];
		 }else{
			 pkg += test[i] + ".";
		 }
	 }

	 var cls = test[test.length-1].replace(".java","");


	 $("#"+formId +" input[name=jobPack]").val(pkg);
	 $("#"+formId +" input[name=jobClassNm]").val(cls);
	console.log(pkg);
	console.log(cls);
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0128'/></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
<!--                             <div class="grid-body no-border"> -->
<!--                             	<br> -->
<!--                                 <form id="frmSearch" name="frmsearch" method="post" enctype="multipart/form-data"> -->
<!-- 		                            <div class="row form-row"  style="padding: 0 0 10px 0;"> -->
<!-- 		                                <div class="col-md`-6" > -->
<%-- 	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0354'/></label> --%>
<!-- 	                                        <div class="input-with-icon  right" > -->
<!-- 	                                           <i class=""></i> -->
<!-- 	  										<input type="file" id="DATA_FILE" name="DATA_FILE" class="filestyle" data-buttonName="btn-primary"> -->
<!-- 	                                       </div> -->
<!-- 	                                    </div> -->
<!-- 	                                    <div class="col-md-3"></div> -->
<!-- 			                          	<div class="col-md-3" > -->
<!-- 			                              <label class="form-label">&nbsp;</label> -->
<!-- 			                              <div> -->
<%-- 			                                  <button type="button" id="btnRetry" onclick="fnReqFile();" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0353'/></button> --%>
<!-- 			                              </div> -->
<!-- 			                          </div>       -->
<!-- 	                            	</div> -->
<!-- 	                            	<input type="hidden" name="duplicateCheck" value="0" > -->
<!--                                 </form> -->
<!--                             </div> -->
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
                                        	<button type="button" id="btnAddJob" onclick="fnAddJob();" class="btn btn-primary btn-cons" style="float:right;"><spring:message code='IMS_BAT_NM_0007'/></button>
                                            <table class="table" id="tbJobList" style="width:100%">
                                                <thead>
                                                    <tr>
                                                        <th><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0001'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0002'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0003'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0004'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0005'/></th>
                                                        <th><spring:message code='IMS_BAT_NM_0006'/></th>
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
    	<form id="frmJobInfo">
			<div class="modal fade" id="modalJobInfo"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content" >
			            <div class="modal-header" style="background-color: #F3F5F6;">
			                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			                <br />
	<!-- 		                <i id="icon" class="fa fa-envelope-o fa-2x"></i> -->
			                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BAT_NM_0017"/></h4>
			                <br />
			            </div>
			            <div class="modal-body" style="background-color: #e5e9ec;">
			                <div class="row form-row">
			                    <table class="table" style="width:100%; border:1px solid #ddd;">
	                                <thead >
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0002'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobName" maxlength="30" class='form-control'></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0009'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobDetail" maxlength="300" class='form-control  ' ></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0008'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobPack" maxlength="200" class='form-control'  onchange="subStr('frmJobInfo');"></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0010'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobClassNm" maxlength="100" class='form-control'></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0011'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobTrigger" maxlength="30" class='form-control'></td>
	                                    </tr>
	                                 </thead>
	                           </table>
	                         </div>
		            	</div>
			            <div class="modal-footer">
			            	<button type="button"  id="btnSave" onclick="fnSave()" class="btn btn-primary btn-cons"  style="margin-top: 2%;"><spring:message code='IMS_BAT_NM_0016'/></button>
			                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			            </div>
		            </div>
		        </div>
		    </div>
	    </form>
    <!-- END MODAL -->
    <!-- BEGIN MODAL -->
    	<form id="frmUpdJobInfo">
			<div class="modal fade" id="modalUpdJobInfo"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content" >
			            <div class="modal-header" style="background-color: #F3F5F6;">
			                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			                <br />
	<!-- 		                <i id="icon" class="fa fa-envelope-o fa-2x"></i> -->
			                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BAT_NM_0027"/></h4>
			                <br />
			            </div>
			            <div class="modal-body" style="background-color: #e5e9ec;">
			                <div class="row form-row">
			                    <table class="table" style="width:100%; border:1px solid #ddd;">
	                                <thead >
	                                	<tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0001'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobId" maxlength="5" class='form-control' readonly> </td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0002'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobName" maxlength="30" class='form-control'></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0009'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobDetail" maxlength="300" class='form-control  ' ></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0008'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobPack" maxlength="200" class='form-control'  onchange="subStr('frmUpdJobInfo');"></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0010'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobClassNm" maxlength="100" class='form-control'></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0011'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;' colspan="2"><input type="text" name="jobTrigger" maxlength="30" class='form-control'></td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0012'/></th>
	                                        <td style='text-align:center; border:1px solid #ddd;    background-color: #e7eff9;'  colspan="2" >
	                                        	<input type="hidden" name="jobState"  id="jobState" class='form-control' readonly >
		                                        <label for="jobState"  id="labJobState" class="form-label"></label>
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th class="th_verticleLine"><spring:message code='IMS_BAT_NM_0005'/></th>
	                                        <td style="text-align:center; border:1px solid #ddd;    background-color: #e7eff9;">
	                                        	<input type="hidden" name="jobUse"  id="jobUse" class='form-control' readonly >
		                                        <label for="jobUse"  id="labJobUse" class="form-label"></label>
                                        	</td>
	                                        <td style="text-align:center; border:1px solid #ddd;    background-color: #e7eff9;" id="tdUse">
		                                        <button type="button" onclick='fnProc(jobId.value, "START", null);' id="btnUse"  style="text-align:center; margin-top: 2%;" class="btn btn-primary btn-cons">
		                                        	<spring:message code='IMS_BAT_NM_0018'/>
		                                        </button>
	                                        </td>
	                                        <td style="text-align:center; border:1px solid #ddd;    background-color: #e7eff9;" id="tdUnUse">
		                                        <button type="button"  onclick='fnProc(jobId.value, "STOP" , null);' id="btnUnUse"   style="text-align:center; margin-top: 2%;" class="btn btn-primary btn-cons">
		                                        	<spring:message code='IMS_BAT_NM_0019'/>
		                                        </button>
	                                        </td>
	                                    </tr>
	                                 </thead>
	                           </table>
	                         </div>
		            	</div>
			            <div class="modal-footer">
			            	<button type="button"  onclick="fnUpdate()" class="btn btn-primary btn-cons"  style="margin-top: 2%;"><spring:message code='IMS_BAT_NM_0022'/></button>
			                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			            </div>
		            </div>
		        </div>
		    </div>
	    </form>
    <!-- END MODAL -->