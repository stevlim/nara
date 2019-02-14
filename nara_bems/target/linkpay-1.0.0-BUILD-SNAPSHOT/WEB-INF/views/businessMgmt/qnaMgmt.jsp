<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
var objQnaMgmtListDT;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strEmail = "<%=CommonUtils.getSessionInfo(session, "EMAIL")%>";
var strUsrNm = "<%=CommonUtils.getSessionInfo(session, "USR_NM")%>";
var strTelNo = "<%=CommonUtils.getSessionInfo(session, "TEL_NO")%>";
var strMid = "<%=request.getAttribute("MID")%>";
var pageCl = <%=request.getParameter("pageCl")%>;
var detailSeq = <%=request.getParameter("seq")%>;
	
$(document).ready(function(){
    fnInitEvent();
    fnSetDDLB();
});

window.onload = function (){
	if(pageCl == "moreInfo"){
		fnQnaMgmtListDT();
	}else if(detailSeq != null){
		fnSelectQnaMgmt(detailSeq);
	}
}

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
    	IONPay.Utils.fnClearHideForm();
    	fnQnaMgmtListDT();
    });
    
    /* $("#btnEdit").on("click", function() {      
        if (!$("#frmEdit").valid()) {
              return;
        }
        
        fnEditQnaMgmt();
    }); */
    
    $("#btnEnrollment").on("click", function(){
    	fnInsertForm();
    });
}

function fnSetDDLB() {   
	//$("#frmEdit #division").html("<c:out value='${division}' escapeXml='false' />");
	//$("#frmEdit #flag").html("<c:out value='${faqFlag}' escapeXml='false' />");
	//$("#frmSearch #QNA_TYPE").html("<c:out value='${QNA_TYPE}' escapeXml='false' />");
}

function fnSetValidate() {
    var arrValidate = {
        FORMID   : "frmEdit",
        VARIABLE : {
            QNA_TYPE  : {required: true},
            TITLE       : {maxlength: 100, required: true},
            STATUS      : {required: true}
        }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

/**------------------------------------------------------------
* Qna 리스트 조회
------------------------------------------------------------*/
function fnQnaMgmtListDT() {
    if (typeof objQnaMgmtListDT == "undefined") {
    	objQnaMgmtListDT = IONPay.Ajax.CreateDataTable("#tbQnaMgmtList", true, {
            url: "/businessMgmt/qnaMgmt/selectQnaMgmtList.do",
            data: function() {
                return $("#frmSearch").serializeObject();                
            },
            columns: [                
				{ "class" : "column10c all",         		"data" : null, "render": function(data){return data.RNUM} },
                { "class" : "column10c all",         		"data" : null, "render": fnStatus },
                { "class" : "column30l all",  "data" : null, "render": function(data, type, full, meta){return "<a href='javascript:fnSelectQnaMgmt("+ data.SEQ_NO +");'><span class='text-info'>"+ data.HEAD +"</span></a>";} },
                { "class" : "column20l all text-center",  "data" : "REQ_DT" },
                { "class" : "column20l all text-center",  "data" : "WORKER" }
                /* { "class" : "columnc min-tablet",  		"data" : null, "render": function(data){return gMessage(data.NOTI_TYPE)} },
                { "class" : "columnc min-desktop", 		"data" : null, "render": function(data, type, full, meta){return gMessage(data.DEL_FLG)} }, */
            ]
        }, true);
    } else {
    	objQnaMgmtListDT.clearPipeline();
        objQnaMgmtListDT.ajax.reload();
    }
        
    IONPay.Utils.fnShowSearchArea();
    ////IONPay.Utils.fnHideSearchOptionArea();
}

function fnStatus(data){
	var strHtml = "";
	
	if(data.QNA_TYPE == "0"){//문의
		strHtml = "<spring:message code='IMS_BM_IM_0009'/>";
	}else{//답변 완료
		strHtml = "<spring:message code='IMS_BM_IM_0010'/>";
	}
	
	return strHtml;
}

/**------------------------------------------------------------
* Qna 등록/수정
------------------------------------------------------------*/
function fnEditQnaMgmt(mode) {
    if ($.trim($("#MEMO_EDITOR").val()) == "")
    {
        IONPay.Msg.fnAlert(gMessage('IMS_BM_FAQ_0008'));
    }
    else
    {
        
		arrParameter = $("#frmEdit").serializeObject();
		arrParameter["SEQ_NO"]= $("#SEQ_NO").val();
		arrParameter["MID"]= strMid;
		//"STATUS"	 : $.trim($("#STATUS").val()),
        strCallUrl  = (mode == "insert" ? "/businessMgmt/qnaMgmt/insertQnaMgmt.do" : "/businessMgmt/qnaMgmt/updateQnaMgmt.do");
        strCallBack = "fnEditQnaMgmtRet";
         
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    }
}

function fnEditQnaMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearHideForm();
        fnQnaMgmtListDT();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);      
    }
}


function fnInsertForm(){
	IONPay.Utils.fnClearShowForm();
	$("#EDIT_TITLE").val("");
	$("#MEMO_EDITOR").data("wysihtml5").editor.setValue("");
	$("#ANSWER").css("display", "none");
	$("#EDIT_TITLE").removeAttr("disabled");
	$("#btnEdit").hide();
	$("#btnSave").show();
	$("#USR_NM").val(strUsrNm);
	$("#USR_TEL").val(strTelNo);
	$("#USR_EMAIL").val(strEmail);	
	$("#WORKER").val(strWorker);
	IONPay.Utils.fnJumpToPageTop();
}

/**------------------------------------------------------------
* QNA 게시물 조회
------------------------------------------------------------*/
function fnSelectQnaMgmt(SEQ_NO) {
    arrParameter = {
            "SEQ_NO" : SEQ_NO            
            };
 
    strCallUrl  = "/businessMgmt/qnaMgmt/selectQnaMgmt.do";
    strCallBack = "fnSelectQnaMgmtRet";
     
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSelectQnaMgmtRet(objJson) {
	$("#btnSave").hide();
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearShowForm();
        $("#frmEdit #division").select2("val", objJson.rowData.QNA_TYPE);        
        $("#EDIT_TITLE").val(objJson.rowData.HEAD);               
        $("#MEMO_EDITOR").data("wysihtml5").editor.setValue(objJson.rowData.BODY);
        $("#ANSWER_EDITOR").val(objJson.rowData.ANSWER_MEMO);
        $("#ANSWER").css("display", "none");
        $("#SEQ_NO").val(objJson.rowData.SEQ_NO);
    	$("#USR_NM").val(objJson.rowData.REQ_NM);
    	$("#USR_TEL").val(objJson.rowData.REQ_TEL);
    	$("#USR_EMAIL").val(objJson.rowData.REQ_EMAIL);
        
        if(objJson.rowData.QNA_TYPE == "1"){//상태가 답변 완료일 경우, 수정이 안되도록 disabled
        	$("#ANSWER").css("display", "block");
        	$("#frmEdit #division").attr("disabled", "disabled");
            $("#EDIT_TITLE").attr("disabled", "disabled");               
            $("#MEMO_EDITOR").attr("disabled", "disabled");            
            $("#WORKER").val(objJson.rowData.WORKER);
            $("#WORKER").attr("disabled", "disabled");
            $("#SEQ_NO").attr("disabled", "disabled");
        	$("#btnEdit").hide();        	
        }else{
        	$("#frmEdit #division").removeAttr("disabled");
        	$("#EDIT_TITLE").removeAttr("disabled");               
            $("#MEMO_EDITOR").removeAttr("disabled");            
            $("#WORKER").val(strWorker);
            $("#WORKER").attr("disabled", "disabled");
            $("#btnEdit").show();
        }
        /* $("#frmEdit #division").attr("disabled", "disabled");        
        $("#WORKER").attr("disabled", "disabled");
        $("#SEQ_NO").attr("disabled", "disabled"); */      
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
                                <%-- <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_FAQ_0014'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select id="division" name="division" class="select2 form-control">
												<option value="0"><spring:message code='IMS_MENU_SUB_0021'/></option>
                                            	<option value="1"><spring:message code='IMS_BM_IM_0010'/></option>                                            
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
                                </div> --%>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-6">
                                        <label class="form-label">제목</label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="EDIT_TITLE" name="EDIT_TITLE" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                    </div>     
                                </div>
                                <div div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-2">
                                        <label class="form-label">작성자</label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="USR_NM" name="USR_NM" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">연락 전화</label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="USR_TEL" name="USR_TEL" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">연락 Mail</label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="USR_EMAIL" name="USR_EMAIL" class="form-control">
                                        </div>
                                    </div>                                    
                                    <div class="col-md-6">
                                    </div>                                     	
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                    <div class="col-md-12">
                                        <label class="form-label">내용</label>
                                        <textarea id="MEMO_EDITOR" name="MEMO_EDITOR" class="form-control" style="height:400px;"></textarea>
                                    </div>
                                </div>
                                <div id="ANSWER" class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                    <div class="col-md-12">
                                        <label class="form-label">답변</label>
                                        <textarea id="ANSWER_EDITOR" name="ANSWER_EDITOR" class="form-control" style="height:400px;"></textarea>
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
                                            <button type="button" id="btnEdit" class="btn btn-danger auth-all" onclick="fnEditQnaMgmt('edit');">수정</button>
                                            <button type="button" id="btnSave" class="btn btn-danger auth-all" onclick="fnEditQnaMgmt('insert');">저장</button>
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
                                            <label class="form-label"><spring:message code='IMS_BM_FAQ_0015'/></label>
                                            <select id="QNA_TYPE" name="QNA_TYPE" class="select2 form-control">
                                            	<option value="ALL"><spring:message code='IMS_BM_AM_0015'/></option>
                                            	<option value="0"><spring:message code='IMS_MENU_SUB_0021'/></option>
                                            	<option value="1"><spring:message code='IMS_BM_IM_0010'/></option>
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
                                                <button type="button" id="btnEnrollment" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_AM_0027'/></button>                                            
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
                                            <table class="table" id="tbQnaMgmtList" style="width:100%">
                                                <thead>
                                                    <tr>
                                                    	<th>NO</th>                                                        
                                                        <th><spring:message code='IMS_BM_FAQ_0014'/></th>
                                                        <th>질문</th>
                                                        <th>등록일자</th>
                                                        <th>등록자</th>
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
