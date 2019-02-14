<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objInnerUserMenuAuthTable;
var objMerchantUserMenuAuthTable;
var objMenuAuthTableDtl;
var blnMerAuthTypeDisable;
var intMode = 1; // mode관리 (1:select, 2:edit, 3:update, 4:insert )

$(document).ready(function(){
	IONPay.Auth.Init("${AUTH_CD}");
	fnSetValidate();
	fnSetDDLB();
});

function fnSetDDLB() {
    $("#selAuthType").html("<c:out value='${AUTH_TYPE}' escapeXml='false' />");  
}

/**------------------------------------------------------------
* 메뉴 역할 등록 유효성 이벤트
------------------------------------------------------------*/
function fnSetValidate() {
    var arrValidate = {
                FORMID   : "frmEditMenuAuth",
                VARIABLE : {
                	AUTH_TYPE : { required: true },
                	AUTH_NM   : { required: true, maxlength:30 },
                	STATUS    : { required: true }
               }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

/**------------------------------------------------------------
* 메뉴 역할 리스트 조회(내부)
------------------------------------------------------------*/
function fnCreateInnerUserDT() {
	var strAuthClass = "${AUTH_CD}" == "1" ? "column10c" : "column10c never";
	
    if (typeof objInnerUserMenuAuthTable == "undefined") {
    	objInnerUserMenuAuthTable = IONPay.Ajax.CreateDataTable("#tbInnerUserMenuAuthMgmt", false, {
            url: '/authorityMgmt/menuRoleMgmt/selectMenuRoleMgmtList.do',
            data: function () {
                return $("#frmMenuAuth").serializeObject();
            },                               
            columns: [              
                { "data" : "AUTH_NM", "class" : "column20c"},
                { "data" : "WORKER", "class" : "column10c"},
                { "data" : null, "render": fnSelectStatus, "class" : "column10c"},
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.REG_DT)}, "class" : "column10c" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.UPD_DT)}, "class" : "column10c" },
                { "data" : null, "render": fnCreateRenderUpdBtn, "class" : strAuthClass } 
            ]
        }, true);
    } else {
    	objInnerUserMenuAuthTable.clearPipeline();
    	objInnerUserMenuAuthTable.ajax.reload();
    }
}

/**------------------------------------------------------------
* 메뉴 역할 리스트 조회(가맹점)
------------------------------------------------------------*/
function fnCreateMerchantUserDT() {
    if (typeof objMerchantUserMenuAuthTable == "undefined") {
    	objMerchantUserMenuAuthTable = IONPay.Ajax.CreateDataTable("#tbMerchantUserMenuAuthMgmt", false, {
            url: '/authorityMgmt/menuRoleMgmt/selectMenuRoleMgmtList.do',
            data: function () {
                return $("#frmMenuAuth").serializeObject();
            },                               
            columns: [              
                { "data" : "AUTH_NM", "class" : "column20c"},
                { "data" : null, "render": function(data){return data.MER_AUTH_TYPE == "1" ? gMessage("IMS_AM_MRM_0002"):gMessage("IMS_AM_MRM_0003");}, "class" : "column10c" },
                { "data" : "WORKER", "class" : "column10c"},
                { "data" : null, "render": fnSelectStatus, "class" : "column10c"},
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.REG_DT)}, "class" : "column10c" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.UPD_DT)}, "class" : "column10c" },
                { "data" : null, "render": fnCreateRenderUpdBtn, "class" : "column10c auth-all"} 
            ]
        });
    } else {
    	objMerchantUserMenuAuthTable.clearPipeline();
    	objMerchantUserMenuAuthTable.ajax.reload();
    }
}

/**------------------------------------------------------------
* 메뉴 역할 등록 메뉴 리스트 조회
------------------------------------------------------------*/
var fnCreateDetailTable = function() {    
	if (typeof objMenuAuthTableDtl == "undefined") {
		objMenuAuthTableDtl = IONPay.Ajax.CreateDataTable("#tblMenuAuthMgmtDtl", false, {
	        url: '/authorityMgmt/menuRoleMgmt/selectMenuRoleMgmtDtl.do',
	        data: function () {
	        	var objParam = {};
	        	objParam["AUTH_TYPE"] = $("#hidMenuAuthType").val();
	        	objParam["AUTH_NO"]   = $("#hidMenuAuthNo").val();
	        	return objParam; 
	        },             
	        lengthChange: false,
	        displayLength: -1,
	        paging: false,
	        columns: [         
	            { "data": null, "render": fnCreateDetailTableMenuName, "class" : "column60c"},      
	            { "data": null, "render": fnCreateDetailTableAddDDLB, "class" : "column10"},       
	            { "data": null, "render": fnCreateDetailTableRemoveDDLB, "class" : "column10"},    
	            { "data": null, "render": fnCreateDetailTableAllDDLB, "class" : "column10"},      
	            { "data": null, "render": fnCreateDetailTableReadDDLB, "class" : "column10"}                                                    
	        ],
	        ordering : false,
	        paging: false,
            dom: "rt"
	    });
	} else {
		objMenuAuthTableDtl.clearPipeline();
		objMenuAuthTableDtl.ajax.reload();
    }
}

/**------------------------------------------------------------
* 메뉴 역할 리스트 수정 버튼 Render
------------------------------------------------------------*/
function fnCreateRenderUpdBtn(data) {
	var strHtml = "";
    strHtml = data.AUTH_TYPE == "1"? "<button id='btnEditMenuRole' type='button' data-toggle='modal' data-target='#divEditMenuAuth' data-authtype='" + data.AUTH_TYPE + "' data-authno='" + data.AUTH_NO + "' data-authname='" + data.AUTH_NM + "' data-status='" + data.STATUS + "' class='btn btn-primary btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_MRM_0027') + "</button>" 
                                   : "<button id='btnEditMenuRole' type='button' data-toggle='modal' data-target='#divEditMenuAuth' data-authtype='" + data.AUTH_TYPE + "' data-merauthtype='" + data.MER_AUTH_TYPE+ "' data-authno='" + data.AUTH_NO + "' data-authname='" + data.AUTH_NM + "' data-status='" + data.STATUS + "' class='btn btn-primary btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_MRM_0027') + "</button>";
    return strHtml;
}

/**------------------------------------------------------------
* 메뉴 역할 등록 메뉴 명 Render
------------------------------------------------------------*/
function fnCreateDetailTableMenuName(data) {
    if (data.DEPTH == 1) {
        return "<h5 align='left'><b>" + gMessage(data.MENU_NM) + '</h5></b>';
    } else {
        if (data.STATUS == 1) {
            return "<h5 align='left'>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;" + gMessage(data.MENU_NM) + '</h5>';
        } else {
            return "<h5 align='left'>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;" + gMessage(data.MENU_NM) + "&nbsp<font color='blue'>(PopUp)</font></h5>";
        }
    }
}

/**------------------------------------------------------------
* 메뉴 역할 등록 추가 체크 박스 Render
------------------------------------------------------------*/
function fnCreateDetailTableAddDDLB (data) {
    if (data.DEPTH == 1) {
        return "<div class='checkbox check-primary'><input type='checkbox' id='ddlbAdd_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbAdd' class='detailTable_ddlbAdd' value=''/><label for='ddlbAdd_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
    } else {
        if (data.AUTH_CD == 0) {
            return "<div class='checkbox check-primary'><input type='checkbox' id='ddlbAdd_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbAdd' class='detailTable_ddlbAdd' value=''/><label for='ddlbAdd_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
        } else {
            return "";
        }
    }
}

/**------------------------------------------------------------
* 메뉴 역할 등록 삭제 체크 박스 Render
------------------------------------------------------------*/
function fnCreateDetailTableRemoveDDLB (data) {
    if (data.AUTH_CD == 1) {
        return "<div class='checkbox check-danger'><input type='checkbox' id='ddlbRemove_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbRemove' class='detailTable_ddlbRemove' value=''/><label for='ddlbRemove_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
    } else {
        if (intMode == 4 && data.DEPTH == 1) {
            return "<div class='checkbox check-danger'><input type='checkbox' id='ddlbRemove_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbRemove' class='detailTable_ddlbRemove' value=''/><label for='ddlbRemove_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
        } else {
            if (data.AUTH_CD == 2)
            {
                return "<div class='checkbox check-danger'><input type='checkbox' id='ddlbRemove_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbRemove' class='detailTable_ddlbRemove' value=''/><label for='ddlbRemove_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
            } else {
                return "";
            }
        }
    } 
}

/**------------------------------------------------------------
* 메뉴 역할 등록 전체 체크 박스 Render
------------------------------------------------------------*/
function fnCreateDetailTableAllDDLB (data) {
    if (data.DEPTH == 2) {
        if (data.AUTH_CD == 1) {
            return "<div class='checkbox check-info'><input type='checkbox' id='ddlbAll_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbAll' class='detailTable_ddlbAll' value='' checked='true'/><label for='ddlbAll_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
        } else {
            return "<div class='checkbox check-info'><input type='checkbox' id='ddlbAll_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbAll' class='detailTable_ddlbAll' value=''/><label for='ddlbAll_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
        }
    } else {
        return "<div class='checkbox check-info'><input type='checkbox' id='ddlbAll_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbAll' class='detailTable_ddlbAll' value=''/><label for='ddlbAll_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
    }
}

/**------------------------------------------------------------
* 메뉴 역할 등록 읽기 체크 박스 Render
------------------------------------------------------------*/
function fnCreateDetailTableReadDDLB (data) {
    if (data.DEPTH == 2) {
        if (data.AUTH_CD == 2) {
            return "<div class='checkbox check-warning'><input type='checkbox' id='ddlbRead_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbRead' class='detailTable_ddlbRead' value='' checked='true'/><label for='ddlbRead_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
        } else {
            return "<div class='checkbox check-warning'><input type='checkbox' id='ddlbRead_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbRead' class='detailTable_ddlbRead' value=''/><label for='ddlbRead_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
        }
    } else {
        return "<div class='checkbox check-warning'><input type='checkbox' id='ddlbRead_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "' name='ddlbRead' class='detailTable_ddlbRead' value=''/><label for='ddlbRead_" + data.MENU_GRP_NO + '_' + data.MENU_NO + "'></label></div>";
    }
}

/**------------------------------------------------------------
* 메뉴 역할 리스트 상태 Render
------------------------------------------------------------*/
var fnSelectStatus = function (data){
    var strHtml = "";
    strHtml = data.STATUS == "1"? "<span>" + gMessage('IMS_AM_MRM_0026') + "</span>" : "<span>" + gMessage('IMS_AM_MRM_0004') + "</span>";
    return strHtml;                                                                                                                      
}

/**------------------------------------------------------------
* 메뉴 역할 등록 체크 박스 유동적 변경
------------------------------------------------------------*/
function chkMenu (strMenuGRPNo, strMenuNo, strMenuDepth, strType) {                
    var rowData          = null;                        
    var strBaseGroupID   = "";
    var strChkID         = "";
    var strRelateChkID   = "";
    var strReleaseChkID1 = "";

    var strReleaseChkID2 = "";
    var strReleaseChkID3 = "";
    var strReverseChk    = "";
    
    objMenuAuthTableDtl.rows().indexes().each(function (idx) {                
        rowData = objMenuAuthTableDtl.row(idx).data();                
        strChkID   = '#ddlb' + strType + '_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;

        if (strType == 'Add') {
            strRelateChkID   = '#ddlbAll_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
            strReleaseChkID1 = '#ddlbRead_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
        }
        else if (strType == 'All') {
            strRelateChkID   = '#ddlbAdd_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
            strReleaseChkID1 = '#ddlbRead_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
            strReverseChk    = '#ddlbRemove_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
        } else if (strType == 'Read') {
            strRelateChkID   = '#ddlbAdd_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
            strReleaseChkID1 = '#ddlbAll_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
            strReverseChk    = '#ddlbRemove_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
        } else {
            strReleaseChkID1 = '#ddlbAdd_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
            strReleaseChkID2 = '#ddlbAll_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
            strReleaseChkID1 = '#ddlbRead_' + rowData.MENU_GRP_NO + '_' + rowData.MENU_NO;
        }

        if (strMenuDepth == 1) {
            strBaseGroupID = '#ddlb' + strType + '_' + strMenuGRPNo + '_' + strMenuNo;

            if (rowData.MENU_GRP_NO == strMenuGRPNo) {
                if ($(strBaseGroupID).is(":checked")) {
                    $(strChkID).prop("checked", true);
                    $(strRelateChkID).prop("checked", true);
                    $(strReleaseChkID1).prop("checked", false);

                    if (strType == 'Remove') {
                        $(strReleaseChkID2).prop("checked", false);
                        $(strReleaseChkID3).prop("checked", false);
                    } else {
                        $(strReverseChk).prop("checked", false);
                    }
                } else {
                    $(strChkID).prop("checked", false);
                    $(strRelateChkID).prop("checked", false);
                    $(strReleaseChkID1).prop("checked", false);

                    if ((strType == 'All' || strType == 'Read') && (intMode == 4)) {
                        $(strReverseChk).prop("checked", true);
                    }
                }                                  
            }
        } else {                
            if ((rowData.MENU_GRP_NO == strMenuGRPNo) && (rowData.MENU_NO == strMenuNo)) {
                if ($(strChkID).is(":checked")) {                            
                    $(strRelateChkID).prop("checked", true);
                    $(strReleaseChkID1).prop("checked", false);

                    if (strType == 'Remove') {
                        $(strReleaseChkID2).prop("checked", false);
                        $(strReleaseChkID3).prop("checked", false);
                    } else {
                        $(strReverseChk).prop("checked", false);
                    }
                } else {                            
                    $(strRelateChkID).prop("checked", false);
                    $(strReleaseChkID1).prop("checked", false);

                    if ((strType == 'All' || strType == 'Read') && (intMode == 4))
                    {
                        $(strReverseChk).prop("checked", true);
                    }
                }                    
            }
        }
    });
}

/**------------------------------------------------------------
* 메뉴 역할 등록 결과
------------------------------------------------------------*/
function fnCBInsMenuRoleSuccessResult(){
    $("#divEditMenuAuth").modal("hide");
    
    if($("#selAuthType").val() == "1") {
    	objInnerUserMenuAuthTable.clearPipeline();
        objInnerUserMenuAuthTable.ajax.reload();
    } else {
    	objMerchantUserMenuAuthTable.clearPipeline();
        objMerchantUserMenuAuthTable.ajax.reload();
    }
}

/**------------------------------------------------------------
* 메뉴 등록 Form Clear
------------------------------------------------------------*/
function fnRegMenuRoleFormClear() {
    var icon   = $('.input-with-icon').children('i');
    var parent = $('.input-with-icon');
    var span   = $('.input-with-icon').children('span');

    icon.removeClass("fa fa-exclamation").removeClass('fa fa-check');
    parent.removeClass('error-control').removeClass('success-control');
    span.html("");
    
    $("#txtUpdMenuAuthName").val("");
    $("#selMerAuthType").select2("val", $("#selMerAuthType option[selected]").val());
    $("#selUpdMenuAuthStatus").select2("val", $("#selUpdMenuAuthStatus option[selected]").val());
}

/**------------------------------------------------------------
* 메뉴 역할 이벤트
------------------------------------------------------------*/
$(function () {
	$("#divEditMenuAuth").on("shown.bs.modal", function(){
		$("#divEditMenuAuth").animate({scrollTop:0}, "slow");
	});
	
	$("#selAuthType").on("change", function(){
		var strValue    = $(this).val();
		var objSettings = $("#frmEditMenuAuth").validate().settings;
	     
		$("#divRegisterBtn").show();
		
		if(strValue == "1"){
			$("#divInnerUserGridArea").show();
			$("#divMerchantUserGridArea").hide();
			fnCreateInnerUserDT();
			
			delete objSettings.rules.MER_AUTH_TYPE;
		} else {
			$("#divInnerUserGridArea").hide();
            $("#divMerchantUserGridArea").show();
            fnCreateMerchantUserDT();
            
            objSettings.rules.MER_AUTH_TYPE = {required: true};
		}
		
	    $("#selMerAuthType").select2("val", "1");
        
        if(strValue == "" || strValue == "0"){
            $("#divMerAuthType").hide();
            blnMerAuthTypeDisable = true;
        }else{
            $("#hidMenuAuthType").val($(this).val());
            $("#divMerAuthType").hide();
            fnCreateDetailTable();
            blnMerAuthTypeDisable = true;
            
            if(strValue == "2") {
                $("#divMerAuthType").show();
                blnMerAuthTypeDisable = false;
            }
        }
	});
	
    $("#btnRegistMenuAuth").on('click', function () {
        intMode = 3;
        fnRegMenuRoleFormClear();
        
        $("#myModalInsertMenuAuth").show();
        $("#myModalUpdateMenuAuth").hide();
        $('#hidMenuAuthType').val($("#selAuthType").val());
        $('#hidMenuAuthNo').val("");
        
        $('#txtUpdMenuAuthName').val("");
        $('#selUpdMenuAuthStatus').val("1");
        $("#selMerAuthType").select2("enable", true);
        
        $("#iconRegist").show();
        $("#iconEdit").hide();
        
        fnCreateDetailTable();
    });
    
    // add checkbox action
    $('#tblMenuAuthMgmtDtl').on('click', '.detailTable_ddlbAdd', function () {
        var rowData = objMenuAuthTableDtl.row($(this).parents('tr')).data();
        chkMenu(rowData.MENU_GRP_NO, rowData.MENU_NO, rowData.DEPTH, 'Add');
    });

    // add checkbox action
    $('#tblMenuAuthMgmtDtl').on('click', '.detailTable_ddlbRemove', function () {
        var rowData = objMenuAuthTableDtl.row($(this).parents('tr')).data();
        chkMenu(rowData.MENU_GRP_NO, rowData.MENU_NO, rowData.DEPTH, 'Remove');
    });

    // add checkbox action
    $('#tblMenuAuthMgmtDtl').on('click', '.detailTable_ddlbAll', function () {
        var rowData = objMenuAuthTableDtl.row($(this).parents('tr')).data();
        chkMenu(rowData.MENU_GRP_NO, rowData.MENU_NO, rowData.DEPTH, 'All');
    });

    // add checkbox action
    $('#tblMenuAuthMgmtDtl').on('click', '.detailTable_ddlbRead', function () {
        var rowData = objMenuAuthTableDtl.row($(this).parents('tr')).data();
        chkMenu(rowData.MENU_GRP_NO, rowData.MENU_NO, rowData.DEPTH, 'Read');
    });
    
    $("#btnEditMenuAuth").on('click', function () {
        var intChkCnt     = 0;
        var arrChkID      = null;
        var selAddList    = "";
        var selAllList    = "";
        var selRemoveList = "";

        var selReadList   = "";
        var strMethod     = "";
        var strCallURI    = "";
        var intMenuExist  = 0;

        if(!$("#frmEditMenuAuth").valid()){
            return;
        }

        $("#tblMenuAuthMgmtDtl input[type=checkbox]").each(function () {
            if (this.checked) {
                intChkCnt++;
            }
        });

        if (intChkCnt <= 0) {
        	IONPay.Msg.fnAlertWithModal(gMessage('IMS_AM_MRM_0005'), "divEditMenuAuth", true);
            return false;
        }

        $("#tblMenuAuthMgmtDtl input[name=ddlbAdd]").each(function () {
            if (this.checked) {
                arrChkID = $(this).attr("id").split("_");
                if (selAddList == "") {
                    selAddList = arrChkID[2];
                } else {
                    selAddList = selAddList + "," + arrChkID[2];
                }
            }
        });

        $("#tblMenuAuthMgmtDtl input[name=ddlbRemove]").each(function () {
            if (this.checked) {
                arrChkID = $(this).attr("id").split("_");
                if (selRemoveList == "") {
                    selRemoveList = arrChkID[2];
                } else {
                    selRemoveList = selRemoveList + "," + arrChkID[2];
                }
            }
        });

        $("#tblMenuAuthMgmtDtl input[name=ddlbAll]").each(function () {                        
            if (this.checked) {
                arrChkID = $(this).attr("id").split("_");
                if (selAllList == "") {
                    selAllList = arrChkID[2];
                } else {
                    selAllList = selAllList + "," + arrChkID[2];
                }
            }
        });

        $("#tblMenuAuthMgmtDtl input[name=ddlbRead]").each(function () {
            if (this.checked) {
                arrChkID = $(this).attr("id").split("_");
                if (selReadList == "") {
                    selReadList = arrChkID[2];
                } else {
                    selReadList = selReadList + "," + arrChkID[2];
                }
            }
        });

        if (intMode == 3) {
        	strCallURI = "/authorityMgmt/menuRoleMgmt/insertMenuRoleMgmt.do";
        } else if (intMode == 4) {
        	strCallURI = "/authorityMgmt/menuRoleMgmt/updateMenuRoleMgmt.do";
        } else {
        	IONPay.Msg.fnAlertWithModal(gMessage('IMS_AM_MRM_0006'), "divEditMenuAuth", true);
            return false;
        }

        var objParam = {};
        
        objParam["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
        objParam["ADDLIST"]    = selAddList == "" ? "0" : selAddList;
        objParam["ALLLIST"]    = selAllList == "" ? "0" : selAllList;
        objParam["REMOVELIST"] = selRemoveList == "" ? "0" : selRemoveList;
        objParam["READLIST"]   = selReadList == "" ? "0" : selReadList;
        
        objParam["AUTH_NM"]      = $('#txtUpdMenuAuthName').val();
        objParam["STATUS"]       = $("#selUpdMenuAuthStatus").val();
        objParam["AUTH_TYPE"]    = $("#hidMenuAuthType").val();
        objParam["AUTH_NO"]      = $("#hidMenuAuthNo").val() == "" ? "0" : $("#hidMenuAuthNo").val();
        objParam["MER_AUTH_TYPE"] = blnMerAuthTypeDisable ? "0" :  $("#selMerAuthType").val();
        
        $.post(strCallURI, $.param(objParam)).done(function (objJson) {
            if (parseInt(objJson.resultCode) == 0) {
            	fnCBInsMenuRoleSuccessResult(objJson, null);
            } else {
                IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "divEditMenuAuth", true);
            }
        }).fail(function (XMLHttpRequest) {
            if(XMLHttpRequest.status == 901) {
                location.href = IONPay.LOGINURL;
            } else {
            	IONPay.Msg.fnAlertWithModal(IONPay.AJAXERRORMSG, "divEditMenuAuth", true);
            }
        });
        
        return true;
    });
    
    $('#tbInnerUserMenuAuthMgmt').on('click', '#btnEditMenuRole', function (event) {
        intMode               = 4;
        blnMerAuthTypeDisable = true;
        
        fnRegMenuRoleFormClear();
        
        var strMenuAuthNo     = $(this).data("authno");
        var strMenuAuthName   = $(this).data("authname");
        var intMenuAuthType   = $(this).data("authtype");
        var intMenuAuthStatus = $(this).data("status");
        
        $("#divMerAuthType").hide();
        $("#myModalInsertMenuAuth").hide();
        $("#myModalUpdateMenuAuth").show();
        
        $('#hidMenuAuthType').val(intMenuAuthType);
        $('#hidMenuAuthNo').val(strMenuAuthNo);
        $('#txtUpdMenuAuthName').val(strMenuAuthName);
        $('#selUpdMenuAuthStatus').select2("val", intMenuAuthStatus);
        
        $("#iconRegist").hide();
        $("#iconEdit").show();
        
        fnCreateDetailTable();

        event.preventDefault();
    });
    
    $('#tbMerchantUserMenuAuthMgmt').on('click', '#btnEditMenuRole', function (event) {
        intMode               = 4;
        blnMerAuthTypeDisable = false;
        
        fnRegMenuRoleFormClear();
        
        var strMenuAuthNo      = $(this).data("authno");
        var strMenuAuthName    = $(this).data("authname");
        var intMenuAuthType    = $(this).data("authtype");
        var intMenuAuthStatus  = $(this).data("status");
        var intMeneMerAuthType = $(this).data("merauthtype"); 
        
       	$("#selMerAuthType").select2("enable", false);
       	$("#divMerAuthType").show();
       	$("#selMerAuthType").select2("val", intMeneMerAuthType);
        
        $("#myModalInsertMenuAuth").hide();
        $("#myModalUpdateMenuAuth").show();
        
        $('#hidMenuAuthType').val(intMenuAuthType);
        $('#hidMenuAuthNo').val(strMenuAuthNo);
        $('#txtUpdMenuAuthName').val(strMenuAuthName);
        $('#selUpdMenuAuthStatus').select2("val", intMenuAuthStatus);
        
        $("#iconRegist").hide();
        $("#iconEdit").show();
        
        fnCreateDetailTable();

        event.preventDefault();
    });
});
</script>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;" class="active">${MENU_TITLE }</a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold">${MENU_SUBMENU_TITLE }</span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
                <div class="row">
                   <input id="hidMenuAuthNo"    name="AUTH_NO"    type="hidden" value="" />
                   <input id="hidMenuAuthType"  name="AUTH_TYPE"  type="hidden" value="" />
                   <input id="hidAddList"       name="ADDLIST"    type="hidden" value="" />
                   <input id="hidRemoveList"    name="REMOVELIST" type="hidden" value="" />
                   <input id="hidAllList"       name="ALLLIST"    type="hidden" value="" />
                   <input id="hidReadList"      name="READLIST"   type="hidden" value="" />
                   <div class="col-md-12">
                       <div class="grid simple">
                          <div class="grid-title no-border">
                              <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_MRM_0007'/></h4>
                              <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                          </div>
                          <div class="grid-body no-border">
                          <form id="frmMenuAuth" name="frmMenuAuth">
                               <div class="row form-row">
                                   <div class="col-md-3">
                                       <label class="form-label"><spring:message code='IMS_AM_MRM_0008'/></label> 
                                       <select id="selAuthType" name="AUTH_TYPE" class="select2 form-control">
                                       </select>
                                   </div>
                                   <div id="divRegisterBtn" class="col-md-3" style="display:none;">
                                     <label class="form-label">&nbsp;</label> 
                                     <div>
                                        <button id="btnRegistMenuAuth" type='button' class='btn btn-primary auth-all btn-cons' data-toggle='modal' data-target='#divEditMenuAuth'><spring:message code='IMS_AM_MRM_0009'/></button>
                                     </div>
                                 </div>
                               </div>
                          </form>        
                          </div>
                       </div>
                   </div>
                </div>
                <div id="div_search" class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                           <div class="grid-title no-border">
                               <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_MRM_0010'/></h4>
                               <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                               
                           </div>
                           <div class="grid-body no-border">
                               <div class="grid-body no-border">
                                 <div class="grid simple ">
                                 <div id="divInnerUserGridArea" class="grid-body " style="display:none;">
	                                  <table class="table" id="tbInnerUserMenuAuthMgmt" width="100%">
	                                      <thead>
	                                       <tr>
	                                           <th><spring:message code='IMS_AM_MRM_0011'/></th>
	                                           <th><spring:message code='IMS_AM_MRM_0012'/></th>
	                                           <th><spring:message code='IMS_AM_MRM_0013'/></th>
	                                           <th><spring:message code='IMS_AM_MRM_0014'/></th>
	                                           <th><spring:message code='IMS_AM_MRM_0015'/></th>
	                                           <th><spring:message code='IMS_AM_MRM_0016'/></th>
	                                       </tr>
	                                      </thead>
	                                  </table>
                                  </div>
                                  <div id="divMerchantUserGridArea" class="grid-body " style="display:none;">
                                      <table class="table" id="tbMerchantUserMenuAuthMgmt" width="100%">
                                          <thead>
                                           <tr>
                                               <th><spring:message code='IMS_AM_MRM_0011'/></th>
                                               <th><spring:message code='IMS_AM_MRM_0017'/></th>
                                               <th><spring:message code='IMS_AM_MRM_0012'/></th>
                                               <th><spring:message code='IMS_AM_MRM_0013'/></th>
                                               <th><spring:message code='IMS_AM_MRM_0014'/></th>
                                               <th><spring:message code='IMS_AM_MRM_0015'/></th>
                                               <th><spring:message code='IMS_AM_MRM_0016'/></th>
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
                <!-- END PAGE FORM -->
           </div>   
           <!-- END PAGE --> 
        </div>
        <!-- END CONTAINER -->
    </div>
    <!-- Modal Detail Area -->
	<div class="modal fade" id="divEditMenuAuth" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">            
	            <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" data-dismiss="modal">x</button>
                    <br>
                    <i id="iconRegist" class="fa fa-pencil fa-2x"></i>
                    <i id="iconEdit" class="fa fa-edit fa-2x" style="display:none;"></i>
                    <h4 id="myModalInsertMenuAuth" class="semi-bold"><spring:message code='IMS_AM_MRM_0018'/></h4>
                    <h4 id="myModalUpdateMenuAuth" class="semi-bold" style="display:none;"><spring:message code='IMS_AM_MRM_0019'/></h4>
                    <br>
                </div>
	            <div class="modal-body">
	            <form id="frmEditMenuAuth" name="frmEditMenuAuth">
                    <div id="divMerAuthType" class="form-group" style="display: none;">
                        <label class="form-label"><spring:message code='IMS_AM_MRM_0017'/></label>
                        <div class="input-with-icon  right">                                       
                            <i class=""></i>
                            <select id="selMerAuthType" name="MER_AUTH_TYPE" class="select2 form-control">
                                <option value="1" selected><spring:message code='IMS_AM_MRM_0002'/></option>
                                <option value="2"><spring:message code='IMS_AM_MRM_0003'/></option>
                            </select>                   
                        </div>
                    </div>
	                <div class="form-group">
                        <label class="form-label"><spring:message code='IMS_AM_MRM_0011'/></label>
                        <div class="input-with-icon  right">                                     
                            <i class=""></i>
                            <input id="txtUpdMenuAuthName" name="AUTH_NM" type="text" class="form-control" maxlength="30" />                    
                        </div>
                    </div>
                    <div class="form-group">
		                <table id="tblMenuAuthMgmtDtl" class="table" width="100%"> 
		                    <thead>
		                        <tr>                                                                              
		                            <th><spring:message code='IMS_AM_MRM_0020'/></th>
		                            <th><spring:message code='IMS_AM_MRM_0021'/></th>
		                            <th><spring:message code='IMS_AM_MRM_0022'/></th>
		                            <th><spring:message code='IMS_AM_MRM_0023'/></th>
		                            <th><spring:message code='IMS_AM_MRM_0024'/></th>
		                        </tr>
		                    </thead>
		                </table>
	                </div>   
	                <div class="form-group">
                        <label class="form-label"><spring:message code='IMS_AM_MRM_0025'/></label>
                        <div class="input-with-icon  right">                                 
                            <i class=""></i>
                            <select id="selUpdMenuAuthStatus" name="STATUS" class="select2 form-control">
                                <option value="1" selected><spring:message code='IMS_AM_MRM_0026'/></option>
                                <option value="2"><spring:message code='IMS_AM_MRM_0004'/></option>
                            </select>
                        </div>
                    </div> 
	            </form>        
	            </div>
	            <div class="modal-footer">
	                <div class="pull-right">
                         <button type="button" id="btnEditMenuAuth" class="btn btn-danger">저장</button>
                         <button type="button" class="btn btn-default" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass();">취소</button>
                    </div>             
	            </div>            
	        </div>
	    </div>
	</div>
	<!-- Modal Detail Area -->