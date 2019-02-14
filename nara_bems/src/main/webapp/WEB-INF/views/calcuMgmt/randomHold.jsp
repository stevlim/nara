<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strStmtFlg = "<c:out value='${SETT_AUTH_FLG2 }' escapeXml='false'/>";
var objListInquriy;

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
	$("#div_search").hide();
	$("#frmSearch #id").attr("readonly", true);
   	$("select[name=division]").on("change", function(){
   		if($.trim(this.value)=="ALL"){
   			$("#id").val("");
   			$("#frmSearch #id").attr("readonly", true);
   		}else{
   			$("#frmSearch #id").attr("readonly", false);
   		}
   	});

    $("#btnSearch").on("click", function() {
    	if($("#division").val() != "ALL" && $("#id").val().length < 10){
    		IONPay.Msg.fnAlert('10자의 처리 ID를 입력하세요');
    		$("#id").focus();
    		return;
    	}
    	$("#div_search").show(200);
    	fnSelectListInquriy();
    });

}
function fnSetDDLB(){
	$("select[name=division]").html("<c:out value='${MER_TYPE}' escapeXml='false' />");
}
function fnRegistResr(){
	//modal창 생성
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalReg").modal();
}
function fnSave(){
	if($("#frmModalReg #mid").val().length < 10){
		IONPay.Msg.fnAlert("정산ID를 입력하세요.");
		$("#frmModalReg #mid").focus();
		return;
	}
	if($("#frmModalReg #setAmt").val().length < 1){
		IONPay.Msg.fnAlert("금액을 입력하세요.");
		$("#frmModalReg #setAmt").focus();
		return;
	}
	if($("#frmModalReg #startDt").val().length < 10){
		IONPay.Msg.fnAlert("시작일자를 입력하세요.");
		$("#frmModalReg #startDt").focus();
		return;
	}
	var startDt = $("#frmModalReg #startDt").val();
	if(fnDateMask(startDt) <= fnToDay()){
		IONPay.Msg.fnAlert('설정일자는 미래일자로만 가능합니다. 다시 입력해주세요.');
		$("#frmModalReg #startDt").focus();
		return;
	}
	if(confirm("임의지급보류를 등록하시겠습니까?") == true){
		fnRegist();
	}else{
		return;
	}
}
function fnDateMask(date){
	var ddmmyyyy = date.split('-');
	var resultDate = '';
	for(var i = ddmmyyyy.length-1; i >= 0; i--){
		resultDate += ddmmyyyy[i];
	}
	return resultDate;
}
function fnRegist(){
	arrParameter = $("#frmModalReg").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/reportMgmt/insertResrSet.do";
    strCallBack  = "fnRegistRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnRegistRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalReg").modal("hide");
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnSelectListInquriy(){
   	if (typeof objListInquriy == "undefined") {
   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
               url: "/calcuMgmt/reportMgmt/selectResrSetList.do",
               data: function() {
                   return $("#frmSearch").serializeObject();
               },
               columns: [
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CO_NM}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ID} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.RESR_START_DT)} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.RESR_END_DT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.RESR_SET_AMT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.RESR_AMT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.RESR_CALC)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_DESC} },
                   { "class" : "columnc all", 			"data" : null, "render":
                	   function(data){
                	   		if(strStmtFlg == "1"){
                	   			if((data.PROC_FLG==null?"":data.PROC_FLG) == "x"){
                	   				return "<button type='button' onclick='reqUpdate();' class='btn btn-primary btn-cons'><spring:message code='IMS_AM_MM_0003'/></button>"
					   			}else{
					   				return "";
					   			}
                	   		}else{
                	   			return "권한없음";
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
    //IONPay.Utils.fnHideSearchOptionArea();
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
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0106'/></span></h3>
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
                                        <div class="col-md-6"></div>
									</div>
                                    <div class="row form-row" >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0559'/></label>
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
                                        <div id="divSearchDateType4" class="col-md-4">
                                            <label class="form-label">&nbsp;</label>
                                            <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0021'/></button>
                                            <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0022'/></button>
                                            <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0023'/></button>
                                            <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0024'/></button>
                                            <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0025'/></button>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" onclick="fnInquiry();"  id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_NM_0026'/></button>
                                                <button type="button"  onclick="fnRegistResr();"id="btnRegist" class="btn btn-primary auth-all btn-cons"><spring:message code='IMS_BM_NM_0027'/></button>
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
                                                     <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th ><spring:message code='DDLB_0137'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0562'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0563'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0561'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0564'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0009'/></th>
                                                     <th ><spring:message code='IMS_SM_SRM_0007'/></th>
                                                     <th ><spring:message code='IMS_BIM_UC_0003'/></th>
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
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    	<!-- END CONTAINER -->
<!-- BEGIN MODAL -->
    <form id="frmModalReg">
		<div class="modal fade" id="modalReg"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0560"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="DDLB_0137"/></th>
                                		<td><input type="text" id="mid" name="mid" maxlength="10" class="form-control"  ></td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0561"/></th>
                                		<td><input type="text" id="setAmt" name="setAmt" maxlength="13" class="form-control"  onkeyup="javascript:setSignalMaskOn(this);" ></td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0400"/></th>
                                		<td>
                                			<div class="input-append success date col-md-10 col-lg-10 no-padding">
                                               <input type="text" id="startDt" name="startDt" class="form-control">
                                               <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                                           </div>
                                        </td>
                                	</tr>
                                	<tr>
                                		<th class="th_verticleLine"><spring:message code="IMS_SM_SRM_0007"/></th>
                                		<td><input type="text" id="desc" name="desc" maxlength="100" class="form-control"  ></td>
                                	</tr>
                                 </thead>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		            	<button type="button" class="btn btn-default"  onclick="fnSave();"	><spring:message code="IMS_BIM_BM_0138"/></button>
		                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="IMS_BIM_BM_0175"/></button>
		            </div>
	            </div>
	        </div>
	    </div>
  	</form>
	<!-- END MODAL -->