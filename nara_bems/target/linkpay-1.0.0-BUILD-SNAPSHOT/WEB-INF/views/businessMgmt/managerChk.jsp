<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objManagerList;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
    	fnManagerList();
    });
    $("#btnProc").on("click", function() {
    	IONPay.Msg.fnAlert("fail");
    });
    $("#searchChk").on("click", function() {
		document.getElementsByName("searchChk");
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
* 영업담당자 조회
------------------------------------------------------------*/
function fnManagerList() {
    
    if (typeof objManagerList == "undefined") {
    	$("#frmSearch").serializeObject();
    } else {
    	objManagerList.clearPipeline();
    	objManagerList.ajax.reload();
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
            		<li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.EXISTING_CORPORATE_MANAGEMENT }'/></a> </li>
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
                                            <select id="searchChk" name="searchChk" class="select2 form-control">
                                            	<option value="0"><spring:message code='IMS_BIM_BM_0079'/></option>
                                            	<option value="1"><spring:message code='IMS_BIM_BM_0142'/></option>
                                            	<option value="2"><spring:message code='IMS_BIM_BM_0143'/></option>
                                            	<option value="3"><spring:message code='IMS_BIM_BM_0083'/></option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0099'/></label> 
                                            <input type="text" id="salesManager" name="salesManager" class="form-control">
                                        </div>                                    
                                    </div>
                                    <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-6" >
                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0100'/></label>
                                        <div class="input-with-icon  right" >
                                           <i class=""></i>
  										<input type="file" id="DATA_FILE" name="DATA_FILE" class="filestyle" data-buttonName="btn-primary">
                                       </div>
                                    </div>
                                    <div class="col-md-6">
	                                        <label class="form-label">&nbsp;</label>
	                                        <div>
	                                            <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
	                                            <button type="button" id="btnProc" class="btn btn-primary btn-cons"><spring:message code='IMS_AM_MM_0019'/></button>
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
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0129'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0130'/></th>
                                                     <th rowspan="2"><spring:message code='IMS_BIM_BM_0099'/></th>
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
</div>
<!-- END CONTAINER -->

