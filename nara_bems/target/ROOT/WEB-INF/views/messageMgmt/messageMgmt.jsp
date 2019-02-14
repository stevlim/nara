<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
var objMessageMgmtDT;

$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");    
    fnInitEvent();
    fnSetValidate();
});

function fnSetValidate() {    
    var arrMessageValidate = {
            FORMID   : "frmEdit",
            VARIABLE : {
                MESSAGE_CODE  : {required: true,  maxlength: 30},
                MESSAGE_KOR   : {required: true,  maxlength: 250},
                MESSAGE_ENG   : {required: false, maxlength: 250},
                MESSAGE_LOCAL : {required: false, maxlength: 250},
           }
        };
    
    IONPay.Utils.fnSetValidate(arrMessageValidate);
}

function fnInitEvent() {
    $("#btnSearch").on("click", function() {
        fnCreateMessageMgmtDT();
        $("#div_searchResult").show(200);
    });
    
    $("#btnRegist").on("click", function() {
        $("#txtEditMESSAGE_CODE").attr("readonly", false);
    });
    
    $("#btnEdit").on("click", function() {     
        fnEditMessageMgmt();
    });
    
    $("#tbMessageMgmt").on("click", "button[name='UpdateMessage']", function() {     
        fnSelectMessageMgmtInfo($(this).data("message_code"));
    });
    
    $("[id^='btnIMS'], [id^='btnMMS']").on("click", function(){
        fnGetLanguageFile(this.id);
    });
}

/**------------------------------------------------------------
* 메시지 리스트 조회
------------------------------------------------------------*/
function fnCreateMessageMgmtDT() {
    if (typeof objMessageMgmtDT == "undefined") {
        objMessageMgmtDT = IONPay.Ajax.CreateDataTable("#tbMessageMgmt", true, {
            url: "/messageMgmt/messageMgmt/selectMessageMgmtList.do",
            data: function() {
                return $("#frmSearch").serializeObject();
            },
            columns: [                
                { "class" : "column20c", "data" : "MESSAGE_CODE"  },
                { "class" : "column25c", "data" : "MESSAGE_KOR"   },
                { "class" : "column25c", "data" : "MESSAGE_ENG"   },
                { "class" : "column25c", "data" : "MESSAGE_LOCAL" },
                { "class" : "column5c auth-all", "data" : null, "render": fnUpdateMessage },
            ]
        });
    } else {
        objMessageMgmtDT.clearPipeline();
        objMessageMgmtDT.ajax.reload();
    }
    
    IONPay.Utils.fnShowSearchArea();
}

function fnUpdateMessage(data, type, full, meta) {
	return "<button type='button' id='btnUpdateMessage" + data.MESSAGE_CODE + "' name='UpdateMessage' class='btn btn-primary btn-xs btn-mini' data-message_code='"+ data.MESSAGE_CODE +"'>" + gMessage('IMS_MM_MM_0002') + "</button>";
}

/**------------------------------------------------------------
* 메시지 등록/수정
------------------------------------------------------------*/
function fnEditMessageMgmt() {
    if (!$("#frmEdit").valid()) {
        return false;
    }
    
    strCallUrl  =  ($("#editMode").val() != "modify") ? "/messageMgmt/messageMgmt/insertMessageMgmt.do" : "/messageMgmt/messageMgmt/updateMessageMgmt.do";
    strCallBack = "fnEditMessageMgmtListRet";
    
    IONPay.Ajax.fnRequest($("#frmEdit").serializeObject(), strCallUrl, strCallBack);
}

function fnEditMessageMgmtListRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearHideForm();
        IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
        fnCreateMessageMgmtDT();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}

/**------------------------------------------------------------
* 메시지 조회(업데이트를 위한 조회)
------------------------------------------------------------*/
function fnSelectMessageMgmtInfo(strMessageCode) {
    
    arrParameter = {
            "MESSAGE_CODE" : strMessageCode     
    } 
    
    strCallUrl  =  "/messageMgmt/messageMgmt/selectMessageMgmtInfo.do";
    strCallBack = "fnSelectMessageMgmtInfoRet";
     
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSelectMessageMgmtInfoRet(objJson) {
    if (objJson.resultCode == 0) {
        
        $("#txtEditMESSAGE_CODE").attr("readonly", true);
        
        IONPay.Utils.fnClearShowForm();
        for (var key in objJson.rowData) {
            $("#frmEdit input[name='" + key + "']").val(objJson.rowData[key]);
        }
        
        $("#frmEdit").valid();
        
        IONPay.Utils.fnJumpToPageTop();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);  
    }
}

/**------------------------------------------------------------
* 언어파일 다운로드
------------------------------------------------------------*/
function fnGetLanguageFile(strID) {
    var strVal      = "";
    var strType     = "";
    var strLanguage = "";
    
    strVal = IONPay.Utils.fnReplaceAll(strID, "btn", "");
    
    strType     = strVal.substring(0,3);
    strLanguage = strVal.substring(3,strVal.length);
    
    var objFrm;
    
    objFrm = IONPay.Utils.fnFrmCreate('frmDown', 'post', '/messageMgmt/messageMgmt/downLoadLanguage.do', '');
    objFrm = IONPay.Utils.fnFrmInputCreate(objFrm, 'TYPE',     strType);
    objFrm = IONPay.Utils.fnFrmInputCreate(objFrm, 'LANGUAGE', strLanguage);
    IONPay.Utils.fnFrmSubmit(objFrm);
}
</script>

        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;" class="active"><c:out value="${MENU_TITLE }" /></a> </li>
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
                                <div class="tools"><a href="javascript:;" class="remove"></a></div>
                            </div>                          
                            <div class="grid-body no-border">
                                 <form id="frmEdit">
                                     <input type="hidden" id="editMode" name="editMode" value="insert" />
                                     <div class="row form-row" style="padding:0 0 10px 0;">
                                         <div class="col-md-12">
                                             <label class="form-label"><spring:message code='IMS_MM_MM_0003'/></label>
                                             <div class="input-with-icon  right">
                                                 <i class=""></i>
                                                   <input type="text" id="txtEditMESSAGE_CODE" name="MESSAGE_CODE" class="form-control">
                                             </div>
                                         </div>                                    
                                     </div>
                                     <div class="row form-row" style="padding:0 0 10px 0;">
                                         <div class="col-md-12">
                                             <label class="form-label"><spring:message code='IMS_MM_MM_0004'/></label>
                                             <div class="input-with-icon  right">
                                                 <i class=""></i>
                                                   <input type="text" id="txtEditMESSAGE_KOR" name="MESSAGE_KOR" class="form-control">
                                             </div>
                                         </div>                                    
                                     </div>
                                     <div class="row form-row" style="padding:0 0 10px 0;">
                                         <div class="col-md-12">
                                             <label class="form-label"><spring:message code='IMS_MM_MM_0005'/></label>
                                             <div class="input-with-icon  right">
                                                 <i class=""></i>
                                                   <input type="text" id="txtEditMESSAGE_ENG" name="MESSAGE_ENG" class="form-control">
                                             </div>
                                         </div>                                    
                                     </div>
                                     <div class="row form-row" style="padding:0 0 10px 0;">
                                         <div class="col-md-12">
                                             <label class="form-label"><spring:message code='IMS_MM_MM_0006'/></label>
                                             <div class="input-with-icon  right">
                                                 <i class=""></i>
                                                   <input type="text" id="txtEditMESSAGE_LOCAL" name="MESSAGE_LOCAL" class="form-control">
                                             </div>
                                         </div>                                    
                                     </div>
                                 </form>
                            </div>
                            <div class="grid-body no-border">
                                <div class="row form-row">
                                    <div class="col-md-12">
                                        <p class="pull-right">
                                            <button type="button" id="btnEdit" class="btn btn-danger auth-all">저장</button>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_MM_MM_0007'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch">
                                    <div class="row form-row">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_MM_MM_0003'/></label>
                                            <input type="text" id="txtSearchMESSAGE_CODE" name="MESSAGE_CODE" class="form-control">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_MM_MM_0008'/></label>
                                            <input type="text" id="txtSearchMESSAGE" name="MESSAGE" class="form-control">
                                        </div>   
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_MM_MM_0009'/></button>
                                                <button type="button" id="btnRegist" class="btn btn-primary btn-cons auth-all"><spring:message code='IMS_MM_MM_0010'/></button>
                                            </div>
                                        </div>
                                        <div class="col-md-3"></div>
                                    </div>                                      
                                    <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                            
                                        <div class="col-md-3">
                                         <label class="form-label"><spring:message code='IMS_MM_MM_0011'/></label>
                                         <div>
                                             <button type="button" id="btnIMSKOR" class="btn btn-primary btn-cons auth-all"><spring:message code='IMS_MM_MM_0012'/></button>
                                             <button type="button" id="btnIMSENG" class="btn btn-primary btn-cons auth-all"><spring:message code='IMS_MM_MM_0013'/></button>
                                             <button type="button" id="btnIMSLOCAL" class="btn btn-primary btn-cons auth-all"><spring:message code='IMS_MM_MM_0014'/></button>
                                         </div>
                                     </div>
                                        <div class="col-md-3">
                                         <label class="form-label">&nbsp;</label>
                                         <div>
                                             <button type="button" id="btnMMSKOR" class="btn btn-primary btn-cons auth-all"><spring:message code='IMS_MM_MM_0015'/></button>
                                             <button type="button" id="btnMMSENG" class="btn btn-primary btn-cons auth-all"><spring:message code='IMS_MM_MM_0016'/></button>
                                             <button type="button" id="btnMMSLOCAL" class="btn btn-primary btn-cons auth-all"><spring:message code='IMS_MM_MM_0017'/></button>
                                         </div>
                                        </div>
                                        <div class="col-md-6"></div>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_MM_MM_0018'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>                        
                            <div class="grid-body no-border" >
                                <div id="div_searchResult" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body">
                                            <table id="tbMessageMgmt" class="table" style="width:100%;">
                                                <thead>
                                                    <tr>
                                                        <th><spring:message code='IMS_MM_MM_0019'/></th>
                                                        <th><spring:message code='IMS_MM_MM_0004'/></th>
                                                        <th><spring:message code='IMS_MM_MM_0005'/></th>
                                                        <th><spring:message code='IMS_MM_MM_0006'/></th>
                                                        <th><spring:message code='IMS_MM_MM_0020'/></th>
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
    </div>
    <!-- END CONTAINER -->    