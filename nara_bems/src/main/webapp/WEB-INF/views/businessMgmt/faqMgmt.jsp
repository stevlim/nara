<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
var objFaqMgmtListDT;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
    fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
        fnFaqMgmtListDT();
    });
    
    $("#btnEdit").on("click", function() {      
        if (!$("#frmEdit").valid()) {
              return;
        }
        
        fnEditFaqMgmt();
    });
}

function fnSetDDLB() {   
	$("#frmEdit #division").html("<c:out value='${division}' escapeXml='false' />");
	$("#frmEdit #flag").html("<c:out value='${faqFlag}' escapeXml='false' />");
	$("#frmSearch #BOARD_TYPE").html("<c:out value='${BOARD_TYPE}' escapeXml='false' />");
}

function fnSetValidate() {
    var arrValidate = {
        FORMID   : "frmEdit",
        VARIABLE : {
            BOARD_TYPE  : {required: true},
            TITLE       : {maxlength: 100, required: true},
            STATUS      : {required: true}
        }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

/**------------------------------------------------------------
* FAQ 리스트 조회
------------------------------------------------------------*/
function fnFaqMgmtListDT() {
    if (typeof objFaqMgmtListDT == "undefined") {
    	objFaqMgmtListDT = IONPay.Ajax.CreateDataTable("#tbFaqMgmtList", true, {
            url: "/businessMgmt/faqMgmt/selectFaqMgmtList.do",
            data: function() {
                return $("#frmSearch").serializeObject();                
            },
            columns: [                
				{ "class" : "columnc all",         		"data" : null, "render": function(data){return data.RNUM} },
                { "class" : "columnc all",         		"data" : null, "render": function(data){return gMessage(data.CTGR)} },
                { "class" : "columnl all",  "data" : null, "render": function(data, type, full, meta){return "<a href='javascript:fnSelectFaqMgmt("+ data.SEQ_NO +");'><span class='text-info'>"+ data.TITLE +"</span></a>";} },
                { "class" : "columnl all text-center",  "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnCutString(IONPay.Utils.fnStripTags(data.BODY), 50); } }
                /* { "class" : "columnc min-tablet",  		"data" : null, "render": function(data){return gMessage(data.NOTI_TYPE)} },
                { "class" : "columnc min-desktop", 		"data" : null, "render": function(data, type, full, meta){return gMessage(data.DEL_FLG)} }, */
            ]
        }, true);
    } else {
    	objFaqMgmtListDT.clearPipeline();
        objFaqMgmtListDT.ajax.reload();
    }
        
    IONPay.Utils.fnShowSearchArea();
    ////IONPay.Utils.fnHideSearchOptionArea();
}
/**------------------------------------------------------------
* FAQ 등록/수정
------------------------------------------------------------*/
function fnEditFaqMgmt() {
    if ($.trim($("#MEMO_EDITOR").val()) == "")
    {
        IONPay.Msg.fnAlert(gMessage('IMS_BM_FAQ_0008'));
    }
    else
    {
        var editMode = $("#editMode").val();
        
		// 구분 - CTGR : division
		// 표시 - NOTI_TYPE : flag
		// Question - TITLE : TITLE 
		// Ask - BODY : $("#MEMO_EDITOR").data("wysihtml5").editor.getValue();
		arrParameter = {
	        "CTGR" 		 : $.trim($("#division").val()),
	        "NOTI_TYPE"  : $.trim($("#flag").val()),
	        "TITLE"      : $.trim($("#TITLE").val()),
	        "BODY"       : $.trim($("#MEMO_EDITOR").val()),
	        "SEQ_NO"     : $.trim($("#SEQ_NO").val()),
        };
		//"STATUS"	 : $.trim($("#STATUS").val()),
        strCallUrl  = (editMode == "insert" ? "/businessMgmt/faqMgmt/insertFaqMgmt.do" : "/businessMgmt/faqMgmt/updateFaqMgmt.do");
        strCallBack = "fnEditFaqMgmtRet";
         
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    }
}

function fnEditFaqMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearHideForm();
        fnFaqMgmtListDT();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);      
    }
}

/**------------------------------------------------------------
* FAQ 게시물 조회
------------------------------------------------------------*/
function fnSelectFaqMgmt(SEQ_NO) {
    arrParameter = {
            "SEQ_NO" : SEQ_NO            
            };
 
    strCallUrl  = "/businessMgmt/faqMgmt/selectFaqMgmt.do";
    strCallBack = "fnSelectFaqMgmtRet";
     
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSelectFaqMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearShowForm();
        $("#frmEdit #division").select2("val", objJson.rowData.CTGR);        
        $("#frmEdit #flag").select2("val", objJson.rowData.NOTI_TYPE);
        $("#EDIT_TITLE").val(objJson.rowData.TITLE);               
        $("#MEMO_EDITOR").data("wysihtml5").editor.setValue(objJson.rowData.BODY);        
//         var str = "<option value='0'>노출</option>";
//         str += "<option value='1'>비노출</option>";
//         $("#STATUS").html(str);
//         var status = $("#STATUS option");
//         for(var i = 0; i < status.length; i++){
//         	if(objJson.rowData.DEL_FLG == status[i].value){
//         		$("#STATUS option:eq(" + i + ")").attr("selected", "selected");
//         	}
//         }
        //$("#STATUS").select2("val", objJson.rowData.DEL_FLG);
        $("#WORKER").val(objJson.rowData.WORKER);
        $("#SEQ_NO").val(objJson.rowData.SEQ_NO);        
        $("#frmEdit #division").attr("disabled", "disabled");
        $("#frmEdit #flag").attr("disabled", "disabled");
        $("#WORKER").attr("disabled", "disabled");
        $("#SEQ_NO").attr("disabled", "disabled");      
        IONPay.Utils.fnJumpToPageTop();
        $("#frmEdit").valid();
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
                                <input type="hidden" id="SEQ_NO" />
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_FAQ_0014'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select id="division" name="division" class="select2 form-control">
                                            </select>
                                        </div>
                                    </div>                            
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_FAQ_0021'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select id="flag" name="flag" class="select2 form-control">
                                            </select>
                                        </div>
                                    </div>           
                                    <div class="col-md-6">
                                    </div>
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-6">
                                        <label class="form-label">Question</label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="EDIT_TITLE" name="EDIT_TITLE" class="form-control" readonly="readonly">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                    </div>     
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                    <div class="col-md-12">
                                        <label class="form-label">Ask</label>
                                        <textarea id="MEMO_EDITOR" name="MEMO_EDITOR" class="form-control" style="height:400px;" readonly="readonly"></textarea>
                                    </div>
                                </div>
<!--                                 <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 10px 0;"> -->
<!--                                     <div class="col-md-3"> -->
<%--                                         <label class="form-label"><spring:message code='IMS_BM_FAQ_0015'/></label> --%>
<!--                                         <div class="input-with-icon  right"> -->
<!--                                             <i class=""></i> -->
<!--                                             <select id="STATUS" name="STATUS" class="select2 form-control"> -->
<!--                                             </select> -->
<!--                                         </div> -->
<!--                                     </div> -->
<!--                                     <div class="col-md-9"> -->
<!--                                     </div> -->
<!--                                 </div>                                 -->
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_FAQ_0017'/></label>
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
                                            <!-- <button type="button" id="btnEdit" class="btn btn-danger auth-all">저장</button> -->
                                            <button type="button" id="btnEditCancel" class="btn btn-default">닫기</button>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_FAQ_0009'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <div class="row form-row">                                        
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_FAQ_0014'/></label>
                                            <select id="BOARD_TYPE" name="BOARD_TYPE" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_FAQ_0012'/></label>
                                            <div class="input-with-icon  right">
                                                <i class=""></i>
                                                <input type="text" id="TITLE" name="TITLE" maxlength="100" class="form-control">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_FAQ_0010'/></button>                                            
                                                <%-- <button type="button" id="btnRegist" class="btn btn-primary auth-all btn-cons"><spring:message code='IMS_BM_FAQ_0011'/></button> --%>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_FAQ_0013'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>                        
                            <div class="grid-body no-border" >
                                <div id="div_searchResult" style="display:none;">                               
                                    <div class="grid simple ">
                                        <div class="grid-body ">
                                            <table class="table" id="tbFaqMgmtList" style="width:100%">
                                                <thead>
                                                    <tr>
                                                    	<th>NO</th>                                                        
                                                        <th><spring:message code='IMS_BM_FAQ_0014'/></th>
                                                        <th>자주 묻는 질문</th>
                                                        <th>답변</th>
                                                        <%-- <th><spring:message code='IMS_BM_FAQ_0021'/></th>
                                                        <th><spring:message code='IMS_AM_MM_0004'/></th> --%>
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
