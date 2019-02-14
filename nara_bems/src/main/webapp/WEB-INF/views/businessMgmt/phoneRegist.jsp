<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objPhoneList;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	IONPay.Auth.Init("${AUTH_CD}");
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
    	fnPhoneList();
    });
    $("#btnExcel").on("click", function() {
    	IONPay.Msg.fnAlert("fail");
    });
    $("#btnProc").on("click", function() {
    	IONPay.Msg.fnAlert("fail");
    });
    $("#searchFlg").on("click", function() {
		document.getElementsByName("searchFlg");
	});
	$("#phoneChk").on("click", function() {
		document.getElementsByName("phoneChk");
	});
	$("#regStatus").on("click", function() {
		document.getElementsByName("regStatus");
	});
	$("#dateChk").on("click", function() {
		document.getElementsByName("dateChk");
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

function fnSetValidate() {
    var arrValidate = {
                FORMID   : "frmEdit",
                VARIABLE : {                    
                    STATUS : {required: true}
                    }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

/**------------------------------------------------------------
* 핸드폰 리스트 조회
------------------------------------------------------------*/
function fnPhoneList() {
    
    if (typeof objPhoneList == "undefined") {
    	$("#frmSearch").serializeObject();
    } else {
    	objPhoneList.clearPipeline();
    	objPhoneList.ajax.reload();
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
                                    <div class="row form-row" style="padding:0 0 10px 0;">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0080'/></label> 
                                            <select id="searchFlg" name="searchFlg" class="select2 form-control">
                                            	<option value="0"><spring:message code='DDLB_0137'/></option>
                                            	<option value="1"><spring:message code='IMS_BIM_BM_0097'/></option>
                                            	<option value="2"><spring:message code='IMS_BIM_BM_0083'/></option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label> 
                                            <input type="text" id="search" name="search" class="form-control">
                                        </div>                                    
                                    </div>
                                    <div class="row form-row" style="padding:0 0 10px 0;">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0075'/></label> 
                                            <select id="phoneChk" name="phoneChk" class="select2 form-control">
                                            	<option value="0"><spring:message code='IMS_BIM_BM_0081'/></option>
                                            	<option value="1">SKT</option>
                                            	<option value="2">LG</option>
                                            	<option value="3">KT</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0084'/></label> 
                                            <select id="regStatus" name="regStatus" class="select2 form-control">
                                            	<option value="0"><spring:message code='IMS_BIM_BM_0081'/></option>
                                            	<option value="1"><spring:message code='IMS_BIM_BM_0091'/></option>
                                            	<option value="2"><spring:message code='IMS_BIM_BM_0092'/></option>
                                            	<option value="3"><spring:message code='IMS_BIM_BM_0093'/></option>
                                            	<option value="4"><spring:message code='IMS_BIM_BM_0094'/></option>
                                            	<option value="5"><spring:message code='IMS_BIM_BM_0095'/></option>
                                            	<option value="6"><spring:message code='IMS_BIM_BM_0096'/></option>
                                            	<option value="7"><spring:message code='IMS_BIM_BM_0097'/></option>
                                            </select>
                                        </div>                                    
                                    </div>
                                      <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-6" >
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0118'/></label>
                                        <div class="input-with-icon  right" >
                                           <i class=""></i>
  										<input type="file" id="DATA_FILE" name="DATA_FILE" class="filestyle" data-buttonName="btn-primary">
                                       </div>
                                    </div>
                                    <div class="col-md-6" >
                                        <label class="form-label" >&nbsp;</label>
                                    </div>      
                              	 </div>
                                    <br>                                
                                    <div class="row form-row" >
	                                    <div class="col-md-2">
	                                    <label class="form-label">&nbsp;</label>
	                                     <select id="dateChk" name="dateChk" class="select2 form-control">
	                                            	<option value="0"><spring:message code='IMS_BIM_BM_0085'/></option>
	                                            	<option value="1"><spring:message code='IMS_BIM_BM_0096'/></option>
	                                            </select>
	                                    </div>
		                                <div class="col-md-2">
	                                        <label class="form-label">&nbsp;</label> 
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
	                                            <button type="button" id="btnExcel" class="btn btn-primary btn-cons">Excel</button>
	                                            <button type="button" id="btnProc" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0087'/></button>
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
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0085'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th rowspan="2">MID</th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0083'/></th>
                                                     <th rowspan="2">URL</th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0111'/></th>
                                                     <th rowspan="2">SKT</th>
                                                     <th rowspan="2">KT</th>
                                                     <th rowspan="2">LGU+</th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0123'/></th>
                                                     <th colspan="7" ><spring:message code='IMS_BIM_BM_0124'/></th>
                                                     
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
