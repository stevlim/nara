<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objCashList;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
    $("#btnSearch").on("click", function() {
    	fnCashList();
    });
    $("select[name=status]").on("click", function() {
		document.getElementsByName("status");
	});
}

function fnSetDDLB() {
    $("#frmEdit #STATUS").html("<c:out value='${STATUS_EDIT}' escapeXml='false' />");    
    $("select[name$='ORD_NO_DUP_CHK_FLG']").html("<c:out value='${ORD_NO_DUP_CHK_FLG_EDIT}' escapeXml='false' />");
    $("select[id='selInsSTATUS']").html("<c:out value='${MERCHANT_STATUS_EDIT}' escapeXml='false' />");
    $("#frmSearch #STATUS").html("<c:out value='${STATUS_SEARCH}' escapeXml='false' />");
    $("#frmSearch #BOARD_TYPE").html("<c:out value='${BOARD_TYPE_SEARCH}' escapeXml='false' />");
    $("#frmSearch #BOARD_CHANNEL").html("<c:out value='${BOARD_CHANNEL_SEARCH}' escapeXml='false' />");
}

/**------------------------------------------------------------
* 현금영수증 리스트 조회
------------------------------------------------------------*/
function fnCashList() {
    
    if (typeof objCashList == "undefined") {
    	$("#frmSearch").serializeObject();
    } else {
    	objCashList.clearPipeline();
    	objCashList.ajax.reload();
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
            		<li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.AFFILIATE_SUB_MALL }'/></a> </li>
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
                                    <div class="row form-row">
                                        <div class="col-md-4">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0078'/></label> 
                                            <select id="status" name="status" class="select2 form-control">
                                            	<option value="0"><spring:message code='IMS_BIM_BM_0081'/></option>
                                            	<option value="1"><spring:message code='IMS_BIM_BM_0091'/></option>
                                            	<option value="2"><spring:message code='IMS_BIM_BM_0095'/></option>
                                            	<option value="3"><spring:message code='IMS_BIM_BM_0098'/></option>
                                            </select>
                                        </div>
                                        <div class="col-md-8">
                                        </div>                                    
                                    </div>
                                    <br>                                
                                    <div class="row form-row" >
		                                <div class="col-md-2">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0077'/></label> 
	                                        <div class="input-append success date col-md-10 col-lg-10 no-padding">
	                                            <input type="text" id="txtFromDate" name="fromdate" class="form-control">
	                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
	                                        </div>                                      
	                                    </div>
	                                    <div class="col-md-2">
	                                       <label class="form-label">&nbsp;</label>
	                                       <div class="input-append success date col-md-10 col-lg-10 no-padding">
	                                           <input type="text" id="txtToDate" name="todate" class="form-control">
	                                           <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
	                                       </div>
	                                    </div> 
	                                    <div id="divSearchDateType4" class="col-md-3">
	                                        <label class="form-label">&nbsp;</label>
	                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>                                       
	                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
	                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
	                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
	                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
	                                    </div>
	                                    <div class="col-md-3">
	                                        <label class="form-label">&nbsp;</label>
	                                        <div>
	                                            <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
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
                                        <div class="grid-body " id="div_creditCard">
                                            <table id="tbCreditCard" class="table" style="width:100%">
                                                <thead>
                                                 <tr>
                                                     <th rowspan="2">NO</th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0125'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0083'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0078'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0126'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0127'/></th>
                                                 </tr>
                                                </thead>
                                            </table>
                                            <div class="col-md-10"></div>
                                            <div class="col-md-2" style="padding: 5px 0 5px 0;">
                                            	<button type="button" id="btnSend" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0128'/></button>
                                            </div>
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
