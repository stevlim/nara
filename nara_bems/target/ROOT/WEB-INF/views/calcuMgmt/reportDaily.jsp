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
    	var id = $("#division").val();
    	//fnSelectIdChk(id);
    	fnSelectListInquriy();
    });

}
function fnSetDDLB(){
	$("select[name=division]").html("<c:out value='${division}' escapeXml='false' />");
}
function fnSelectListInquriy(){
   	if (typeof objListInquriy == "undefined") {
   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
               url: "/calcuMgmt/reportMgmt/selectStmtList.do",
               data: function() {
                   return $("#frmSearch").serializeObject();
               },
               columns: [
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ID} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.STMT_DT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.APP_CNT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.APP_AMT)}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CC_CNT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.CC_AMT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.RESR_AMT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.RESR_CC_AMT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.EXTRA_AMT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.FEE)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.VAT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.DPST_AMT)} }
               ]
       }, true);
    } else {
       objListInquriy.clearPipeline();
       objListInquriy.ajax.reload();
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
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
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
                                	<input type="hidden"  name="currency" value="KRW">
                                	<input type="hidden"  name="stmtCd" value="0">
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
                                                     <th ><spring:message code='IMS_SM_SR_0063'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0553'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0152'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0153'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0154'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0155'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0554'/></th>
                                                     <th ><spring:message code='IMS_SM_SR_0040'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0555'/></th>
                                                     <th ><spring:message code='IMS_SM_SR_0018'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0556'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0557'/></th>
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
