<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
var objInquiryMgmtListDT;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	IONPay.Auth.Init("${AUTH_CD}");
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
        fnInquiryMgmtListDT();
    });
    
    $("#btnEdit").on("click", function() {      
        if (!$("#frmEdit").valid()) {
              return;
        }
        
        fnEditInquiryMgmt();
    });

}

function fnSetDDLB() {
	$("#frmSearch select[name=QNA_REQ_CD]").html("<c:out value='${notiLocation}' escapeXml='false' />");
	$("#frmSearch select[name=askStatus]").html("<c:out value='${askStatus}' escapeXml='false' />");
	$("#STATUS").html("<c:out value='${askStatus}' escapeXml='false' />");
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
* 문의 리스트 조회
------------------------------------------------------------*/
function fnInquiryMgmtListDT() {
	var $FROM_DT = $("#txtFromDate");
    var $TO_DT   = $("#txtToDate");
    
    var intFromDT = Number(IONPay.Utils.fnConvertDateFormat($FROM_DT.val()));
    var intToDT   = Number(IONPay.Utils.fnConvertDateFormat($TO_DT.val()));
        
    if (intFromDT > intToDT) {
        IONPay.Msg.fnAlert(gMessage('IMS_BM_IM_0011'));
        return;
    }
    
    if (!IONPay.Utils.fnCheckSearchRange($("#txtFromDate"), $("#txtToDate"), "3")) {
        return;
    }
    
    if (typeof objInquiryMgmtListDT == "undefined") {
    	objInquiryMgmtListDT = IONPay.Ajax.CreateDataTable("#tbInquiryMgmtList", true, {
    		url: "/businessMgmt/inquiryMgmt/selectInquiryMgmtList.do",
   	        data: function() {	
   	            return $("#frmSearch").serializeObject();
   	        },
       	 	columns: [
				{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REQ_DT} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  gMessage(data.QNA_CH_CD)} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  gMessage(data.QNA_REQ_CD)} },
	            { "class" : "columnc min-tablet",  "data" : null, "render": function(data, type, full, meta){return  "<a href=\"javascript:fnSelectMerchantInfo(\'"+ data.MID +"\');\"><span class='text-info'>"+ data.CO_NM +"</span></a>"} },
	            { "class" : "columnc min-desktop", "data" : null, "render": function(data, type, full, meta){return  "<a href=\"javascript:fnSelectInquiryMgmt("+ data.SEQ +");\"><span class='text-info'>"+ data.HEAD +"</span></a>"} },
	            { "class" : "columnc min-desktop", "data" : null, "render": function(data){return  gMessage(data.QNA_ST_TYPE)} },
	            { "class" : "columnc min-desktop", "data" : null, "render": function(data, type, full, meta){return  IONPay.Utils.fnStringToDateTimeFormat(data.PROC_DTM)} },
            ]
   	    }, true);
    } else {
        objInquiryMgmtListDT.clearPipeline();
        objInquiryMgmtListDT.ajax.reload();
    }

    IONPay.Utils.fnShowSearchArea();
    //IONPay.Utils.fnHideSearchOptionArea();
}
/**------------------------------------------------------------
* 문의 게시물 조회
------------------------------------------------------------*/
function fnSelectInquiryMgmt(SEQ) {
    arrParameter = {
    	"SEQ" : SEQ            
    };
 
    strCallUrl  = "/businessMgmt/inquiryMgmt/selectInquiryMgmt.do";
    strCallBack = "fnSelectInquiryMgmtRet";
     
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSelectInquiryMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
    	IONPay.Utils.fnClearShowForm();
        $("#frmEdit #QNA_CH_CD").val(gMessage(objJson.rowData.QNA_CH_CD));
        $("#frmEdit #CO_NM").val(objJson.rowData.CO_NM);
        $("#USRID").val(objJson.rowData.USRID);        
        $("#frmEdit #QNA_REQ_CD").val(gMessage(objJson.rowData.QNA_REQ_CD));        
        $("#HEAD").val(objJson.rowData.HEAD);
        $("#REQ_DT").val(IONPay.Utils.fnStringToDateFormat(objJson.rowData.REQ_DT));
        $("#BODY").val(objJson.rowData.BODY);
        $("#MEMO_EDITOR").data("wysihtml5").editor.setValue(objJson.rowData.ANSWER_MEMO);
        $("#STATUS").select2("val", objJson.rowData.STATUS);
        $("#WORKER").val(($.trim(objJson.rowData.WORKER) == "" ? strWorker : objJson.rowData.WORKER));
        $("#SEQ").val(objJson.rowData.SEQ);       
        IONPay.Utils.fnJumpToPageTop();
        $("#frmEdit").valid();
    } else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}
/**------------------------------------------------------------
* 문의 답변 등록
------------------------------------------------------------*/
function fnEditInquiryMgmt() {
    if ($.trim($("#MEMO_EDITOR").val()) == "")
    {
    	IONPay.Msg.fnAlert(gMessage('IMS_BM_IM_0012'));
    }
    else
    {
        var editMode = $("#editMode").val();
        
        arrParameter = {
                "ANSWER_MEMO" : $.trim($("#MEMO_EDITOR").val()),
                "STATUS"      : $.trim($("#STATUS").val()),
                "SEQ"      : $.trim($("#SEQ").val())
                };
     
        strCallUrl  = (editMode == "insert" ? "/businessMgmt/inquiryMgmt/insertInquiryMgmt.do" : "/businessMgmt/inquiryMgmt/updateInquiryMgmt.do");
        strCallBack = "fnEditInquiryMgmtRet";
         
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    }
}

function fnEditInquiryMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
    	IONPay.Utils.fnClearHideForm();
        fnInquiryMgmtListDT();
    } else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}
/**------------------------------------------------------------
* 가맹점 정보 조회
------------------------------------------------------------*/
function fnSelectMerchantInfo(strIMID) {
	arrParameter = {
        "MID" : strIMID
    }

    strCallUrl  = "/businessMgmt/inquiryMgmt/selectMerchantInfo.do";
    strCallBack = "fnSelectMerchantInfoRet";
    
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSelectMerchantInfoRet(objJson) {
    if(objJson.resultCode == 0) {
		$("body").addClass("breakpoint-1024 pace-done modal-open ");
		$("#MerchantInfoModal #MID").val(objJson.rowData.MID);
    	$("#MerchantInfoModal #GID").val(objJson.rowData.GID);
    	$("#MerchantInfoModal #VID").val(objJson.rowData.VID);
		$("#MerchantInfoModal #CO_NO").val(objJson.rowData.CO_NO);
    	$("#MerchantInfoModal #TEL_NO").val(objJson.rowData.TEL_NO);
    	$("#MerchantInfoModal #FAX_NO").val(objJson.rowData.FAX_NO);
    	$("#MerchantInfoModal #EMAIL").val(objJson.rowData.EMAIL);
    	$("#MerchantInfoModal #CONT_DT").val(objJson.rowData.CONT_DT);
    	$("#MerchantInfoModal #REG_DT").val(objJson.rowData.REG_DT);
    	$("#MerchantInfoModal #CONT_EMP_NM").val(objJson.rowData.CONT_EMP_NM);
    	$("#MerchantInfoModal #CONT_EMP_TEL").val(objJson.rowData.CONT_EMP_TEL);
    	$("#MerchantInfoModal #CONT_EMP_FAX").val(objJson.rowData.CONT_EMP_FAX);
    	$("#MerchantInfoModal #CONT_EMP_EMAIL").val(objJson.rowData.CONT_EMP_EMAIL);
    	$("#MerchantInfoModal #STMT_EMP_NM").val(objJson.rowData.STMT_EMP_NM);
    	$("#MerchantInfoModal #STMT_EMP_TEL").val(objJson.rowData.STMT_EMP_TEL);
    	$("#MerchantInfoModal #STMT_EMP_FAX").val(objJson.rowData.STMT_EMP_FAX);
    	$("#MerchantInfoModal #STMT_EMP_EMAIL").val(objJson.rowData.STMT_EMP_EMAIL);
    	$("#MerchantInfoModal #TECH_EMP_NM").val(objJson.rowData.TECH_EMP_NM);
    	$("#MerchantInfoModal #TECH_EMP_TEL").val(objJson.rowData.TECH_EMP_TEL);
    	$("#MerchantInfoModal #TECH_EMP_FAX").val(objJson.rowData.TECH_EMP_FAX);
    	$("#MerchantInfoModal #TECH_EMP_EMAIL").val(objJson.rowData.TECH_EMP_EMAIL);
    	$("#MerchantInfoModal #ACCNT_NO").val(objJson.rowData.ACCNT_NO);
    	$("#MerchantInfoModal #ACCNT_NM").val(objJson.rowData.ACCNT_NM);
    	$("#MerchantInfoModal #VBANK_NM").val(gMessage(objJson.rowData.VBANK_NM));
    	$("#MerchantInfoModal #MID_URL").val(gMessage(objJson.rowData.MID_URL));
		$("#MerchantInfoModal #SIGN_NM").val(objJson.rowData.SIGN_NM);
		$("#MerchantInfoModal #WORKER").val(objJson.rowData.WORKER);
    	
    	$("#btnMerchantInfoView").click();
    } else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}
</script>

    <!-- BEGIN PAGE CONTAINER-->
    <div class="page-content">
        <div class="content">
            <div class="clearfix"></div>
            <!-- BEGIN PAGE TITLE -->
            <ul class="breadcrumb">
                <li><p>YOU ARE HERE</p></li>
                <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.BUSINESSMGMT_MERCHANTMGMT_TITLE }'/></a> </li>
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
                            <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Regist</span></h4>
                            <div class="tools"> <a href="javascript:;" class="remove"></a></div>
                        </div>                          
                        <div class="grid-body no-border">
                        <form id="frmEdit">
                            <input type="hidden" id="editMode" value="insert" />
                            <input type="hidden" id="SEQ" />
                            <div class="row form-row" style="padding:0 0 10px 0;">
                                <div class="col-md-3">                                        
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0013'/></label>
                                    <div class="input-with-icon  right">
                                        <i class=""></i>
                                        <input type="text" id="QNA_CH_CD" name="QNA_CH_CD" readonly class="form-control">
                                    </div>
                                </div>
                                <div class="col-md-3">                                        
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0014'/></label>
                                    <div class="input-with-icon  right">
                                        <i class=""></i>
                                        <input type="text" id="CO_NM" name="CO_NM" readonly class="form-control">
                                    </div>
                                </div>                                    
                                <div class="col-md-3">
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0015'/></label>
                                    <div class="input-with-icon  right">
                                        <i class=""></i>
                                        <input type="text" id="USRID" name="USRID" readonly class="form-control">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0016'/></label>
                                    <div class="input-with-icon  right">
                                        <i class=""></i>
                                        <input type="text" id="REQ_DT" name="REQ_DT" readonly class="form-control">
                                    </div>
                                </div>
                            </div>
                            <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                <div class="col-md-3">
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0017'/></label>
                                    <div class="input-with-icon  right">
                                        <i class=""></i>
                                        <input type="text" id="QNA_REQ_CD" name="QNA_REQ_CD" readonly class="form-control">
                                    </div>
                                </div>
                                <div class="col-md-9">
                                </div>
                            </div>
                            <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                <div class="col-md-6">
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0018'/></label>
                                    <div class="input-with-icon  right">
                                        <i class=""></i>
                                        <input type="text" id="HEAD" name="HEAD" readonly class="form-control">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                </div>
                            </div>
                            <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                <div class="col-md-12">
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0019'/></label>
                                    <textarea id="BODY" name="BODY" class="form-control" style="height:300px;" readonly></textarea>
                                </div>
                            </div>
                            <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                <div class="col-md-12">
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0020'/></label>                                                                                    
                                    <textarea id="MEMO_EDITOR" name="MEMO_EDITOR" class="form-control" style="height:300px;"></textarea>
                                </div>
                            </div>
                            <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_IM_0021'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select id="STATUS" name="STATUS" class="select2 form-control">                                                    
                                            </select>
                                        </div>
                                    </div>
                                <div class="col-md-9">
                                </div>  
                            </div>                                
                            <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                <div class="col-md-3">
                                    <label class="form-label"><spring:message code='IMS_BM_IM_0022'/></label>
                                    <div class="input-with-icon  right">
                                        <input type="text" id="WORKER" readonly class="form-control">
                                    </div>
                                </div>
                                <div class="col-md-9">
                                </div>
                            </div>
                        </form>
                        </div>
                        <div class="grid-body no-border">
                            <div class="row form-row">
                                <div class="col-md-12">
                                    <p class="pull-right">
                                        <button type="button" id="btnEdit" class="btn btn-danger auth-all">저장</button>
                                        <button type="button" id="btnEditCancel" class="btn btn-default">취소</button>
                                    </p>
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
                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_IM_0023'/></h4>
                            <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                        </div>
                        <div class="grid-body no-border">
                            <form id="frmSearch" name="frmsearch">
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_IM_0014'/></label>
                                        <input type="text" id="CO_NM" name="CO_NM" maxlength="100" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_IM_0034'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select name="QNA_REQ_CD"  id="QNA_REQ_CD" class="select2 form-control">
                                       		</select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_IM_0021'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select name="askStatus"  id="askStatus" class="select2 form-control">
                                       		</select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                    </div>
                                </div>
                                <div class="row form-row" >                         
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_IM_0024'/></label> 
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
                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_IM_0025'/></button>                                       
                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_IM_0026'/></button>
                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_IM_0027'/></button>                                            
                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_IM_0028'/></button>
                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_IM_0029'/></button>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">&nbsp;</label>
                                        <div>
                                            <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_IM_0030'/></button>                                                
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
                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_IM_0032'/></h4>
                            <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                        </div>                        
                        <div class="grid-body no-border" >
                            <div id="div_searchResult" style="display:none;">                               
                                <div class="grid simple ">
                                    <div class="grid-body ">
                                        <table class="table" id="tbInquiryMgmtList" style="width:100%">
                                            <thead>
                                                <tr>         
                                                	<th>NO</th>                                       
                                                    <th><spring:message code='IMS_BM_IM_0033'/></th>
                                                    <th><spring:message code='IMS_BM_IM_0034'/></th>
                                                    <th><spring:message code='IMS_BM_IM_0017'/></th>
                                                    <th><spring:message code='IMS_BM_IM_0014'/></th>
                                                    <th><spring:message code='IMS_BM_IM_0035'/></th>
                                                    <th><spring:message code='IMS_BM_IM_0020'/></th>
                                                    <th><spring:message code='IMS_BM_IM_0037'/></th>
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
    <!-- END CONTAINER-->
    <!-- BEGIN MODAL -->
    <button id="btnMerchantInfoView" data-toggle="modal" data-target="#MerchantInfoModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="MerchantInfoModal" tabindex="-1" role="dialog" aria-labelledby="modalMerchantInfo" aria-hidden="true">
        <div class="modal-dialog" style="width:80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="IONPay.Msg.fnResetBodyClass();">×</button>
                    <br>
                    <i class="fa fa-info-circle fa-2x"></i>
                    <h4 id="modalMerchantInfo" class="semi-bold"><spring:message code='IMS_BM_IM_0038'/></h4>
                    <br>
                </div>
                <div class="modal-body">                    
                    <div class="row form-row">
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BIM_MM_0054'/></label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="CO_NO" name="CO_NO" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='DDLB_0137'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="MID" name="MID" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='DDLB_0138'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="GID" name="GID" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='DDLB_0139'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="VID" name="VID" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="row form-row">
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BM_IM_0048'/></label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="TEL_NO" name="TEL_NO" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BM_IM_0049'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="FAX_NO" name="FAX_NO" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_AM_UAM_0021'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="EMAIL" name="EMAIL" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BIM_MM_0063'/></label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="MID_URL" name="MID_URL" class="form-control" readonly>
                            </div>
                        </div>                            
                    </div>
                    <div class="row form-row">
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_RM_TSM_0054'/></label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="CONT_DT" name="CONT_DT" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BIM_BM_0064'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="REG_DT" name="REG_DT" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BIM_MM_0161'/></label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="SIGN_NM" name="SIGN_NM" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BIM_HS_0006'/></label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="WORKER" name="WORKER" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="row form-row">
                    	<div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_RM_TSM_0052'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="CONT_EMP_NM" name="CONT_EMP_NM" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">계약담당자 전화번호
<%--                             <spring:message code='IMS_BM_IM_0049'/> --%>
                            </label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="CONT_EMP_TEL" name="CONT_EMP_TEL" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">계약담당자 팩스번호
<%--                             <spring:message code='IMS_BM_IM_0050'/> --%>
                            </label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="CONT_EMP_FAX" name="CONT_EMP_FAX" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">계약담당자 이메일
<%--                             <spring:message code='IMS_BM_IM_0052'/> --%>
                            </label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="CONT_EMP_EMAIL" name="CONT_EMP_EMAIL" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                        </div>
                    </div>
                    <div class="row form-row">
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BIM_MM_0068'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="STMT_EMP_NM" name="STMT_EMP_NM" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">정산담당자 전화번호
<%--                             <spring:message code='IMS_BM_IM_0054'/> --%>
                            </label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="STMT_EMP_TEL" name="STMT_EMP_TEL" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">정산담당자 팩스번호
<%--                             <spring:message code='IMS_BM_IM_0055'/> --%>
                            </label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="STMT_EMP_FAX" name="STMT_EMP_FAX" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">정산담당자 이메일
<%--                             <spring:message code='IMS_BM_IM_0057'/> --%>
                            </label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="STMT_EMP_EMAIL" name="STMT_EMP_EMAIL" class="form-control" readonly>
                            </div>
                        </div>                        
                    </div>
                    <div class="row form-row">
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_BIM_BM_0492'/></label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="TECH_EMP_NM" name="TECH_EMP_NM" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">기술담당자 전화번호
<%--                             <spring:message code='IMS_BM_IM_0059'/> --%>
                            </label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="TECH_EMP_TEL" name="TECH_EMP_TEL" class="form-control" readonly>
                            </div>
                        </div> 
                        <div class="col-md-3">
                            <label class="form-label">기술담당자 팩스번호
<%--                             <spring:message code='IMS_BM_IM_0060'/> --%>
                            </label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="TECH_EMP_FAX" name="TECH_EMP_FAX" class="form-control" readonly>
                            </div>
                        </div>       
                        <div class="col-md-3">
                            <label class="form-label">기술담당자 이메일
<%--                             <spring:message code='IMS_BM_IM_0062'/> --%>
                            </label>
                            <div class="input-with-icon right">
                                <i class=""></i>                                            
                                <input type="text" id="TECH_EMP_EMAIL" name="TECH_EMP_EMAIL" class="form-control" readonly>
                            </div>
                        </div>                
                    </div>
                    <div class="row form-row">
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_TV_TH_0062'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="ACCNT_NO" name="ACCNT_NO" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_SM_SR_0014'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="ACCNT_NM" name="ACCNT_NM" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label"><spring:message code='IMS_DM_DM_0010'/></label>
                            <div class="input-with-icon  right">
                                <i class=""></i>                                            
                                <input type="text" id="VBANK_NM" name="VBANK_NM" class="form-control" readonly>
                            </div>
                        </div>
                        <div class="col-md-3">
                        </div>                        
                    </div>
                </div>                
                <div class="modal-footer">
                    <button type="button" id="btnMerchantInfoModalBottom" data-dismiss="modal" class="btn btn-default" onclick="nicepay.Msg.fnResetBodyClass();">닫기</button>
                </div>
            </div>
        </div>
    </div>
    <!-- END MODAL -->
