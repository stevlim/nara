<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objVanInfoInquiry;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#CardCompanyList").html("<c:out value='${CardCompanyList}' escapeXml='false' />");
	$("#CardType").html("<c:out value='${CardType}' escapeXml='false' />");
	$("#ForeignCardType").html("<c:out value='${ForeignCardType}' escapeXml='false' />");

	$("#vanCd").html("<c:out value='${VAN_CD}' escapeXml='false' />");

}

function fnInit(){
	$("#vanListSearch").hide();
	if($("#vanlistSearchCollapse").hasClass("collapse") === true)
    	$("#vanlistSearchCollapse").click();
	$("#vanInfoListSearch").hide();
	if($("#vanInfoListSearchCollapse").hasClass("collapse") === true)
    	$("#vanInfoListSearchCollapse").click();
}
function fnInitEvent() {
    $("#btnSearch").on("click", function(){
    	if($("#searchOption1").is(':checked')){
    		//이용실적
    		fnVanSearch();
    		$("#tbVanListSearch #usingMon").html($("#frmSearch #useMon").val());
    		$("#tbVanListSearch #strNm").html($("#vanCd option:selected").text());
    		$("#vanInfoListSearch").hide();
    		$("#vanListSearch").show();
    	}else {
    		//van 정보
    		$("#vanListSearch").hide();
    		$("#vanInfoListSearch").show();
    		fnVanInfoSearch();
    	}
	    IONPay.Utils.fnHideSearchOptionArea();
   });
}
function fnVanSearch(){
	arrParameter = $("#frmSearch").serializeObject();
	strCallUrl   = "/baseInfoMgmt/creditCardVANMgmt/selectVanList.do";
	strCallBack  = "fnSelectVanRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
   }
function fnSelectVanRet(objJson) {

	if(objJson.resultCode == 0){
		if(objJson.data.length > 0 ){
			$("#tbVanListSearch #appCnt").html(objJson.data[0].APP_04_CNT);
			$("#tbVanListSearch #appAmt").html(objJson.data[0].APP_04_AMT);
			$("#tbVanListSearch #acquCnt").html(objJson.data[0].CC_04_CNT);
			$("#tbVanListSearch #acquAmt").html(objJson.data[0].CC_04_AMT);
			$("#tbVanListSearch #rcptCnt").html(objJson.data[0].ACQU_04_CNT);
			$("#tbVanListSearch #rcptAmt").html(objJson.data[0].ACQU_04_AMT);
			$("#tbVanListSearch #ccCnt").html(objJson.data[0].ACQU_CC_04_CNT);
			$("#tbVanListSearch #ccAmt").html(objJson.data[0].ACQU_CC_04_AMT);
			$("#tbVanListSearch #acquCcCnt").html(objJson.data[0].RCPT_04_CNT);
			$("#tbVanListSearch #acquCcAmt").html(objJson.data[0].RCPT_04_AMT);
		}
	} else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
	function fnVanInfoSearch(){
	   	if (typeof objVanInfoInquiry == "undefined") {
	   			   objVanInfoInquiry = IONPay.Ajax.CreateDataTable("#tbVanInfoListSearch", true, {
	               url: "/baseInfoMgmt/creditCardVANMgmt/selectVanInfoList.do",
	               data: function() {
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.VAN_CD_NM} },
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.VAN_FEE} },
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ACQ_FEE} },
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CSHRCPT_FEE} }
	                   ]
	           }, true);
	       } else {
	    	   objVanInfoInquiry.clearPipeline();
	           objVanInfoInquiry.ajax.reload();
	       }

	       IONPay.Utils.fnShowSearchArea();
	       IONPay.Utils.fnHideSearchOptionArea();
	   }
</script>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <!-- BEGIN PAGE -->
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CREDIT_CARD_SUPPORT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class = "row">
                	<div class = "col-md-12">
                		<div class = "grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_TV_TH_0050" /></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                            	<form id = "frmSearch" name = "frmsearch">
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
	                                    <div class="col-md-3">
                                     	 	<label class="form-label"><spring:message code="IMS_BIM_CCS_0027" /></label>
							                <div class="radio " style="padding-top:5px;">
							                   <input id="searchOption1" name="SearchOption" type="radio" checked="checked">
							                   <label for="searchOption1"><spring:message code="IMS_BIM_CCS_0028"/></label>
							                   <input id="searchOption2" name="SearchOption" type="radio">
							                   <label for="searchOption2"><spring:message code="IMS_BIM_CCS_0029"/></label>
							               	</div>
	                                    </div>
	                                    <div class="col-md-9">
                                        </div>
                            		</div>
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
	                                    <div class="col-md-3">
                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0359" /></label>
	                                        <select class="select2 form-control" id="vanCd" name="vanCd">
	                                        </select>
	                                    </div>
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0360" /></label>
	                                        <input id="useMon"  name="useMon" class="form-control" maxlength="7" onkeyup="fnReplaceDate(this)">
	                                    </div>
	                                    <div class="col-md-3">
                                        </div>
	                                    <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_TV_TH_0053" /></button>
                                            </div>
	                                    </div>
                            		</div>
                            	</form>
                            </div>
                		</div>
                	</div>
                </div>
                <!-- END VIEW OPTION AREA -->
                <!-- BEGIN LIST Search VIEW AREA -->
	                <div class = "row" id = "vanListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_BIM_BM_0361" /></h4>
                                <div class="tools"><a href="javascript:;" id="vanListSearchCollapse" class="collapse"></a></div>
                            </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbVanListSearch" style="width: 100%">
	                                <thead>
	                                 <tr>
	                                     <th rowspan="2" class="th_verticleLine"><spring:message code="IMS_BIM_BM_0360" /></th>
	                                     <th rowspan="2" class="th_verticleLine"><spring:message code="IMS_BIM_BM_0101" /></th>
	                                     <th colspan="2" class="th_verticleLine" id="strNm"></th>
	                                 </tr>
	                                 <tr>
	                                     <th><spring:message code="IMS_BIM_BM_0362" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0131"/></th>
	                                 </tr>
	                                <tr>
	                                	<td rowspan="6" style="text-align: center;" id="usingMon"></td>
	                                </tr>
	                                <tr style="text-align: right;">
	                                	<td style="text-align: center;"><spring:message code="IMS_BIM_CCS_0037" /></td>
	                                	<td id="appCnt"></td>
	                                	<td id="appAmt"></td>
	                                </tr>
	                                <tr style="text-align: right;">
	                                	<td style="text-align: center;"><spring:message code="IMS_BIM_CCS_0038" /></td>
	                                	<td id="acquCnt"></td>
	                                	<td id="acquAmt"></td>
	                                </tr>
	                                <tr style="text-align: right;">
	                                	<td style="text-align: center;"><spring:message code="IMS_BIM_CCS_0039" /></td>
	                                	<td id="rcptCnt"></td>
	                                	<td id="rcptAmt"></td>
	                                </tr>
	                                <tr style="text-align: right;">
	                                	<td style="text-align: center;"><spring:message code="IMS_BIM_CCS_0040" /></td>
	                                	<td id="ccCnt"></td>
	                                	<td id="ccAmt"></td>
	                                </tr>
	                                <tr style="text-align: right;">
	                                	<td style="text-align: center;"><spring:message code="IMS_BIM_CCS_0041" /></td>
	                                	<td id="acquCcCnt"></td>
	                                	<td id="acquCcAmt"></td>
	                                </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
                		</div>
           	 		</div>
          		</div>
          		<div class = "row" id = "vanInfoListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_BIM_BM_0460" /></h4>
                                <div class="tools"><a href="javascript:;" id="vanInfoListSearchCollapse" class="collapse"></a></div>
                            </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbVanInfoListSearch" style="width: 100%">
	                                <thead>
	                                 <tr>
	                                     <th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0101" /></th>
	                                     <th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0457" /></th>
	                                     <th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0458" /></th>
	                                     <th class="th_verticleLine"><spring:message code="IMS_BIM_BM_0459" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
                		</div>
           	 		</div>
          		</div>
               <!-- END LIST Search VIEW AREA -->
           </div>
           <!-- END PAGE -->
        </div>
        <!-- END CONTAINER -->
    <!-- Modal Menu Insert Area -->