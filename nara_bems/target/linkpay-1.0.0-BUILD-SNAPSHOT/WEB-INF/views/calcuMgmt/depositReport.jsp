<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objUsrAcctTable;
var objUsrAcctTableDetail;
var intSelAuthType;
var intEditAuthNo;

$(document).ready(function(){
	IONPay.Auth.Init("${AUTH_CD}");
	fnSetDDLB();
    fnGetSortable();
    fnSetUserAcctEditFormValidate();
    fnInitEvent();
});

function fnSetDDLB() { 
    /* $("#selStatus").html("<c:out value='${USR_ACCT_STATUS_TYPE}' escapeXml='false' />"); 
    $("#selEditUsrType").html("<c:out value='${USR_TYPE}' escapeXml='false' />"); 
    $("#selUsrType").html("<c:out value='${USR_TYPE_FOR_SEARCH}' escapeXml='false' />"); */
        
    $("#div_search_detail").hide();
    
    $("#PM_CD_TYPE").html("<c:out value='${PM_CD_TYPE}' escapeXml='false' />");	
    $("#MBS_CD_TYPE").html("<c:out value='${MBS_CD_TYPE}' escapeXml='false' />");
    $("#SEARCH_DATE_TYPE").html("<c:out value='${SEARCH_DATE_TYPE}' escapeXml='false' />");
}

function fnInitEvent(){
    $("#btnSearchUsrAcct").on("click", function(){
        $("#divGridArea").show();
        $("#divGridDetailArea").hide();
        
        $("#div_search").show();
        $("#div_search_detail").hide();
        
        fnDepositSum();
        fnCreateDataTables();
        ////IONPay.Utils.fnHideSearchOptionArea();
        IONPay.Utils.fnShowSearchArea();
    });
    
    $("#btnSearchUsrAcctDetail").on("click", function(){
        $("#divGridArea").hide();
        $("#divGridDetailArea").show();
        
        $("#div_search").hide();
        $("#div_search_detail").show();
        
        fnCreateDataTablesDetail();
        ////IONPay.Utils.fnHideSearchOptionArea();
        IONPay.Utils.fnShowSearchArea();
    });
    
    
    $("#txtEditTelNo").mask("9999-9999-9999");
}

/**------------------------------------------------------------
* 이용자 등록 유효성 이벤트
------------------------------------------------------------*/
function fnSetUserAcctEditFormValidate() {
    var arrValidate = {
                FORMID   : "frmEditMenu",
                VARIABLE : {
                	USR_ID       : { required: true, maxlength:10, minlength:4, dupId:"#H_USR_ID", alphaNumeric:true },
                	USR_NM       : { required: false },
                	PSWD         : { required: true, maxlength:20, minlength:8, passwordCheck:true, pwCheckConsecChars:true },
                	PSWD_CONFIRM : { required: true, maxlength:20, minlength:8, equalTo:"#txtEditUsrPassword", passwordCheck:true, pwCheckConsecChars:true },
                	TEL_NO       : { required: false },
                	EMAIL        : { required: false, email:true },
                	AUTH_NO      : { required: true },
                	USR_TYPE     : { required: true },
                    STATUS       : { required: true }
               }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

function fnSetEmailValidate() {
    var arrValidate = {
                FORMID   : "frmResetPwd",
                VARIABLE : {
                	EMAIL        : { required: false, email:true }
               }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

/**------------------------------------------------------------
* 이용자 리스트 조회
------------------------------------------------------------*/
var fnCreateDataTables = function () {
	var strAuthClass = "${AUTH_CD}" == "1" ? "column10c" : "column10c never";
	
    if (typeof objUsrAcctTable == "undefined") {
    	objUsrAcctTable = IONPay.Ajax.CreateDataTable("#tbUsrAcctMgmt", true, {
            //url: '/authorityMgmt/userAccountMgmt/selectUserAccountMgmtList.do',
            url: '/depositMgmt/depositReport/selectUserAccountMgmtList.do',
            
            data: function () {
                return $("#frmSearchUsrAcct").serializeObject();
            },
            columns: [   
                { "data" : null, "render": function(data){return data.RNUM}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return data.MID}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.STMT_DT)}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.APP_AMT)+"원"}, "class" : "columnc all td-amt" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.CAN_AMT)+"원"}, "class" : "columnc all td-amt" },
                
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.RESR_AMT)+"원"}, "class" : "columnc all td-amt" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.RESR_CC_AMT)+"원"}, "class" : "columnc all td-amt" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.EXTRA_AMT)+"원"}, "class" : "columnc all td-amt" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.FEE)+"원"}, "class" : "columnc all td-amt" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.VAT)+"원"}, "class" : "columnc all td-amt" },
                
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.DEPOSIT_AMT)+"원"}, "class" : "columnc all td-amt" }
            ]
        }, true);
    }
    else{
    	objUsrAcctTable.clearPipeline();
    	objUsrAcctTable.ajax.reload();
    }
    
    
}


/**------------------------------------------------------------
* 이용자 리스트 상세조회
------------------------------------------------------------*/
var fnCreateDataTablesDetail = function () {
	var strAuthClass = "${AUTH_CD}" == "1" ? "column10c" : "column10c never";
	
    if (typeof objUsrAcctTableDetail == "undefined") {
    	objUsrAcctTableDetail = IONPay.Ajax.CreateDataTable("#tbUsrAcctMgmtDetail", true, {
            //url: '/authorityMgmt/userAccountMgmt/selectUserAccountMgmtListDetail.do',
            url: '/depositMgmt/depositReport/selectUserAccountMgmtListDetail.do',
            
            data: function () {
                return $("#frmSearchUsrAcct").serializeObject();
            },
            columns: [   
                { "data" : null, "render": function(data){return data.RNUM}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return data.MID}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.STMT_DT)}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.APP_DT)}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return data.SVC_CD_NM}, "class" : "columnc all" },
                
                { "data" : null, "render": function(data){return data.APP_CO}, "class" : "columnc all" },
                { "data" : null, "render": function(data){
                	var str="";
       	 			str += "<a href='#' style='color: blue;' onclick='fnTidDetail("+data.TID+", \""+data.TID+"\" );' >" + data.TID + "</a>";
       	 			return str;
                	
                }, "class" : "columnc all" },
                /* { "data" : null, "render": function(data){return data.ORD_NO}, "class" : "columnc all" }, */
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.TR_AMT)+"원"}, "class" : "columnc all td-amt" },
                { "data" : null, "render": function(data){return data.GOODS_NM}, "class" : "columnc all" },
                
                { "data" : null, "render": function(data){return data.ORD_NM}, "class" : "columnc all" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.FEE)+"원"}, "class" : "columnc all td-amt" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.VAT)+"원"}, "class" : "columnc all td-amt" },
                /* { "data" : null, "render": function(data){return data.SMS_FEE}, "class" : "columnc all" }, */
                { "data" : null, "render": function(data){return IONPay.Utils.fnAddComma(data.DPST_AMT)+"원"}, "class" : "columnc all td-amt" }
            ]
        }, true);
    }
    else{
    	objUsrAcctTableDetail.clearPipeline();
    	objUsrAcctTableDetail.ajax.reload();
    }
    
    
}



/**------------------------------------------------------------
* 이용자 리스트 이용자 유형 Render
------------------------------------------------------------*/
function fnCreateRenderUsrType(data){
    var strHtml = "";
    strHtml = data.USR_TYPE == "1"? "<span>" + gMessage('IMS_AM_UAM_0001') + "</span>" : "<span>" + gMessage('IMS_AM_UAM_0002') + "</span>";
    return strHtml;
}

/**------------------------------------------------------------
* 이용자 리스트 상태 Render
------------------------------------------------------------*/
function fnCreateRenderStatus(data) {
	var strHtml = "";
    strHtml = data.STATUS == "1"? "<span>" + gMessage('IMS_AM_UAM_0003') + "</span>" : "<span>" + gMessage('IMS_AM_UAM_0004') + "</span>";
    return strHtml;
}

/**------------------------------------------------------------
* 이용자 리스트 작업 Render
------------------------------------------------------------*/
function fnCreateWork(data) {
	var strHtml = "";
	strHtml = "<button data-toggle='modal' id='btnEditUserPwd' type='button' data-userid='" + data.USR_ID + "' data-email='" + data.EMAIL + "'class='btn btn-primary btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_UAM_0005') + "</button>&nbsp";
	strHtml += "<button data-toggle='modal' data-target='#divEditUsrAcct' id='btnUpdateUserAcct' type='button' data-userid='" + data.USR_ID + "' class='btn btn-primary btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_UAM_0006') + "</button>";
    return strHtml;
}

$.fn.extend({
    Select: function () {
        return $(this).addClass('selected');
    },
    Unselect: function () {
        return $(this).removeClass('selected');
    }
});

/**------------------------------------------------------------
* 이용자 등록 가맹점 Render
------------------------------------------------------------*/
var fnGetSortable = function () {
    $("ul#list1").html("<c:out value='${MERCHANT_ID}' escapeXml='false' />");

    fnSetupSortable();
}

var fnSetupSortable = function () {
    $('ul.sortable-list').multisortable();
    $('ul#list1').sortable('option', 'connectWith', 'ul#list2');
    $('ul#list2').sortable('option', 'connectWith', 'ul#list1');

    $('li').dblclick(function () {
        if ($(this).parent().get(0).id == "list1") {
            $("ul#list2 > li").each(function () {
                $(this).Unselect();
            });

            $(this).clone(true).appendTo($('ul#list2'));
        }
        else {
            $("ul#list1 > li").each(function () {
                $(this).Unselect();
            });

            $(this).clone(true).appendTo($('ul#list1'));
        }

        $(this).remove();
    });
}

/**------------------------------------------------------------
* 이용자 등록 Form Clear
------------------------------------------------------------*/
var cleanFrm = function (formID) {
	var icon   = $('.input-with-icon').children('i');
    var parent = $('.input-with-icon');
    var span   = $('.input-with-icon').children('span');

    icon.removeClass("fa fa-exclamation").removeClass('fa fa-check');
    parent.removeClass('error-control').removeClass('success-control');
    span.html("");
    
    $("#" + formID + " input[type='text']").val("").attr("disabled", false);
    $("#" + formID + " input[type='password']").val("").attr("disabled", false);
    $("#" + formID + " select option:eq(0)").attr("selected", true);
    $("#hidModechk").val("");
    
    $("#frmEditMenu select").each(function () { $(this).find("option:eq(0)").prop("selected", true); });

    $("#chkAllMerchantFlag").prop("checked", false);
    $("#txtEditUsrID").prop("readonly", false);

    $("#list2 li").each(function () {
    	$("#list1").append("<li class='item' id='" + this.id + "'>" + $(this).html() + "</li>");
    });
    
    $("#list2").html("");
    $("#trUsrPassword").show();
    $("#divSelectMerchant").hide();
    
    fnGetSortable();
}

/**------------------------------------------------------------
* 이용자 등록 결과
------------------------------------------------------------*/
function fnCBInsMenuSuccessResult(objJson) {
    if(objJson.resultCode == 0){
    	cleanFrm("frmEditMenu");
    	fnCreateDataTables();
        $('#divEditUsrAcct').modal('hide');
    }else{
        cleanFrm("frmEditMenu");
        if($("#hidModechk").val() == "edit"){
        	IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "divEditUsrAcct");
        }else{
        	IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "divEditUsrAcct", true);
        }
    }
}

/**------------------------------------------------------------
* 이용자 아이디 조회 결과(중복체크)
------------------------------------------------------------*/
function fnSearchUsrIDRet(objJson){
	if(objJson.resultCode == 0){
		$("#H_USR_ID").val("Y");
	}else{
		$("#H_USR_ID").val("N");
	}
}

/**------------------------------------------------------------
* 이용자 패스워드 초기화 결과
------------------------------------------------------------*/
function fnUpdateUserPSWDRet(objJson){
	if(objJson.resultCode == 0){
		fnCreateDataTables();
		IONPay.Msg.fnAlert(gMessage("IMS_BIM_MM_0146") + " [" + objJson.objMap["DE_PSWD"] + "] ");
    }else{
    	IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
    }
}

/**------------------------------------------------------------
* 이용자 상세 정보 조회 결과
------------------------------------------------------------*/
function fnSelectUserAcctDtlRet(objJson){
	if(objJson.resultCode == 0){
		intSelAuthType = 2;
		intEditAuthNo  = objJson.data[0].AUTH_NO;
		
		$("#txtEditUsrID").val(objJson.data[0].USR_ID);
		$("#txtEditUsrName").val(objJson.data[0].USR_NM);
        $("#txtEditTelNo").val(objJson.data[0].TEL_NO);
        $("#txtEditEmail").val(objJson.data[0].EMAIL);
        $("#selEditUsrType").select2("val", objJson.data[0].USR_TYPE);
        
        $("#selEditUsrStatus").select2("val", objJson.data[0].STATUS);
        $("#H_USR_ID").val("Y");
        $("#hidModechk").val("edit");
        $("#txtEditUsrID").prop("readonly", true);
        $("#selEditAuthNo").select2("enable", true);
        
        var strCallUrl  = "/authorityMgmt/userAccountMgmt/selectAuthTypeList.do";
        var strCallBack = "fnselectAuthTypeListRet";
        var objPram     = {};
        
        objPram["AUTH_TYPE"] = objJson.data[0].USR_TYPE;
        
        IONPay.Ajax.fnRequest(objPram, strCallUrl, strCallBack);
        
        if($.trim($("#selEditUsrType").val()) != ""){
        	$("#divEditAuthSelector").show();
        }
        
        if(objJson.data[0].USR_TYPE == 2){
        	$("#divSelectMerchant").show();
        } else {
        	$("#divSelectMerchant").hide();
        }
        
        if (objJson.MERNMs != "") {
            var arrIMIDs = objJson.IMIDs.split(',');

            for (var i = 0; i <= arrIMIDs.length; i++) {
                $("#list1 li").each(function () {
                    var $objThis = this;

                    if ($objThis.id == arrIMIDs[i]) {
                    	$("#list2").append("<li class='item' id='" + $objThis.id + "'>" + $($objThis).html() + "</li>");
                        $("#" + arrIMIDs[i]).remove();
                    }
                });
            }
        }
    }else{
    	cleanFrm("frmEditMenu");
        IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "divEditUsrAcct", false);
    }
}

/**------------------------------------------------------------
* 이용자 등록 이용자 유형별 역할 조회 결과
------------------------------------------------------------*/
function fnselectAuthTypeListRet(objJson){
    if(objJson.resultCode == 0){
        var strHtml = "";
        
        intSelAuthType == 1 ? $("#divAuthSelector").show() : $("#divEditAuthSelector").show();
        
        if(intSelAuthType == 1){
        	strHtml = "<option value=''>" + gMessage('IMS_AM_UAM_0034') + "</option>";
        }
            
        for (var intIdx = 0; intIdx < objJson.data.length; intIdx++) {
            strHtml += "<option value='" + objJson.data[intIdx].AUTH_NO + "'>" + objJson.data[intIdx].AUTH_NM + "</option>";
        }
        
        intSelAuthType == 1 ? $("#selAuthName").html(strHtml) : $("#selEditAuthNo").html(strHtml);
        intSelAuthType == 1 ? $("#selAuthName").select2("val", $("#selAuthName option[selected]").val()) : $("#selEditAuthNo").select2("val", $("#selEditAuthNo option[selected]").val());
        
        if($("#hidModechk").val() == "edit"){
        	$("#selEditAuthNo").select2("val", intEditAuthNo);
        }else{
        	$("#selEditAuthNo").select2("val", $("#selEditAuthNo option[selected]").val());
        }
    }else{
    	IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
    }
}

/**------------------------------------------------------------
* 이용자 이벤트
------------------------------------------------------------*/
$(function () {
	$("#selUsrType, #selEditUsrType").on("change", function(){
		var strValue = this.value;
		
		if($(this).attr("id") == "selUsrType"){
			intSelAuthType = 1;
			$("#selAuthName").html("");
		}else{
			intSelAuthType = 2;
            $("#selEditAuthNo").html("");
            if(strValue == 2){
            	$("#divSelectMerchant").show();
            } else {
            	$("#divSelectMerchant").hide();
            }
		}
        
        if($(this).val() == "" || $(this).val() == "0"){
        	intSelAuthType == 1 ? $("#divAuthSelector").hide() : $("#divEditAuthSelector").hide();
        }else{
            var strCallUrl   = "/authorityMgmt/userAccountMgmt/selectAuthTypeList.do";
            var strCallBack  = "fnselectAuthTypeListRet";
            var objPram = {};
            
            objPram["AUTH_TYPE"] = $(this).val();
            
            IONPay.Ajax.fnRequest(objPram, strCallUrl, strCallBack);
        }
    });
	
	$("#frmSearchUsrAcct").on("keydown", function (event) {
        if (event.keyCode == 13) {
            $("#btnSearchUsrAcct").click();
        }
    });
	
	$("#txtEditUsrID").on("keyup", function() {
		var objParam = {};
		
        if($.trim($("#txtEditUsrID").val()).length == 0) {
            $("#spUsrIDChk").html("");
            return;
        }          
        
        if($.trim($("#txtEditUsrID").val()).length >= 4) {
        	objParam["USR_ID"] = $("#txtEditUsrID").val();
        	objParam["ISLOADING"] = false;
	        
	        var strCallUrl   = "/authorityMgmt/userAccountMgmt/selectUserID.do";
	        var strCallBack  = "fnSearchUsrIDRet";
	         
	        IONPay.Ajax.fnRequest(objParam, strCallUrl, strCallBack);
        }
    });
	
	$("#chkAllMerchantFlag").on("click", function () {
        var $objThis = this;
        
        if ($objThis.checked == true) {
            $("#list1 li").each(function () {
                $("#list2").append("<li class='item' id='" + this.id + "'>" + $(this).html() + "</li>");
            });

            $("#list1").html("");
        }
        else {
            $("#list2 li").each(function () {
                $("#list1").append("<li class='item' id='" + this.id + "'>" + $(this).html() + "</li>");
            });

            $("#list2").html("");
        }
    });
	
	$("#btnRegistUsrAcct").on("click", function (event) {
		var objSettings = $("#frmEditMenu").validate().settings;
		
		objSettings.rules.PSWD         = { required: true, maxlength:20, minlength:6, passwordCheck:true, pwCheckConsecChars:true };
		objSettings.rules.PSWD_CONFIRM = { required: true, maxlength:20, minlength:6, equalTo:"#txtEditUsrPassword", passwordCheck:true, pwCheckConsecChars:true };
		
        $("#myModalInsertUsrAcct").show();
        $("#myModalUpdateUsrAcct").hide();
        $("#divEditAuthSelector").hide();
        $("#iconRegist").show();
        $("#iconEdit").hide();
        $("#H_USR_ID").val("N");
        cleanFrm("frmEditMenu");
        
        $("#selEditUsrType").select2("val", $("#selEditUsrType option[selected]").val());
        $("#selEditAuthNo").select2("val", $("#selEditAuthNo option[selected]").val());
        $("#selEditUsrStatus").select2("val", "1");
        $("#selEditUsrType").select2("enable", true);
        $("#selEditAuthNo").select2("enable", true);
        
        event.preventDefault();
    });
	
    $("#btnEditUserAcct").on("click", function () {
        var strModeChk      = $.trim($("#hidModechk").val());
        var strUsrPw        = $.trim($("#txtEditUsrPassword").val());
        var strUsrPwConfirm = $.trim($("#txtEditUsrPasswordConfirm").val());
        var intUserType     = $("#selEditUsrType").val();
        var strMerchantList = "";
        
        var strCallURI      = "";

        $("#txtUsrID").val($("#txtUsrID").val().replace(/[^a-z0-9]/gi,""));
        
        $("#list2 li").each(function () {
        	strMerchantList = (strMerchantList == "" ? $(this).attr("id") : strMerchantList + "," + $(this).attr("id"));
        });
        
        $("#hidMerchantlist").val(strMerchantList);

        if (!$("#frmEditMenu").valid()) {
            return;
        }
        
        if (strUsrPw != strUsrPwConfirm) {
        	IONPay.Msg.fnAlertWithModal(gMessage('IMS_AM_UAM_0007'), "divEditUsrAcct", true);
            return;
        }
        
        if(intUserType == 2 && $.trim($("#hidMerchantlist").val()) == ""){
        	IONPay.Msg.fnAlertWithModal(gMessage('IMS_AM_UAM_0008'), "divEditUsrAcct", true);
            return;
        }

        if (strModeChk == "") {
            strCallURI = "/authorityMgmt/userAccountMgmt/insertUserAccountMgmt.do";
        }
        else {
            strCallURI = "/authorityMgmt/userAccountMgmt/updateUserAccountMgmt.do";
        }
        
        var strCallBack = "fnCBInsMenuSuccessResult";
        var objParam    = $("#frmEditMenu").serializeObject();
        
        if(strModeChk != ""){
        	objParam["USR_TYPE"] = intUserType;
        }
        
        IONPay.Ajax.fnRequest(objParam, strCallURI, strCallBack);
    });
    
    $("#tbUsrAcctMgmt").on("click", "[type=button]#btnEditUserPwd", function(){
    	IONPay.Utils.fnValidateStyleClear();
    	var form = $('#frmResetPwd').get(0); // validation init
    	$.removeData(form,'validator');
    	fnSetEmailValidate();

    	var strUserName = $(this).data("userid");
    	var strEmail = $(this).data("email");
    	
    	IONPay.Msg.fnResetPwdConfirm(gMessage('IMS_AM_UAM_0009'), "[ " +strUserName+ " ]", gMessage('IMS_AM_UAM_0035'), strEmail, function () { 
    		var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    		if(regEmail.test($("#inputEmail").val())) {
	    		var strCallUrl  = "/authorityMgmt/userAccountMgmt/updateUserPSWD.do";
	            var strCallBack = "fnUpdateUserPSWDRet";
	            var objParam    = {};
	
	            objParam["USR_ID"] = strUserName;
	            objParam["EMAIL"] = $("#inputEmail").val();
	            
	            $("#btnResetPwdConfirmModalBottm").click();
	            
	            IONPay.Ajax.fnRequest(objParam, strCallUrl, strCallBack);
    		}else{
				return;
    		}
    	});
    });
    
    $("#tbUsrAcctMgmt").on("click", "[type=button]#btnUpdateUserAcct", function(){
    	cleanFrm("frmEditMenu");
        var strUserID   =  $(this).data("userid");
        var objSettings = $("#frmEditMenu").validate().settings;
        
        delete objSettings.rules.PSWD;
        delete objSettings.rules.PSWD_CONFIRM;
        
        $("#txtEditUsrID").val(strUserID);
        $("#selEditUsrType").select2("enable", false);
        $("#trUsrPassword").hide();
        $("#myModalInsertUsrAcct").hide();
        $("#myModalUpdateUsrAcct").show();
        $("#iconRegist").hide();
        $("#iconEdit").show();
        
        var strCallUrl  = "/authorityMgmt/userAccountMgmt/selectUserAccountDtl.do";
        var strCallBack = "fnSelectUserAcctDtlRet";
        var objParam = {};
        
        objParam["USR_ID"] = strUserID;
        
        IONPay.Ajax.fnRequest(objParam, strCallUrl, strCallBack);
    });
    
    $("#btnSearchUsrAcctExcel").on("click", function(){
		strType ="EXCEL";
		fnExcel(strType);
		
	});
    
    $("#btnSearchUsrAcctDetailExcel").on("click", function(){
		strType ="EXCEL";
		fnDetailExcel(strType);
		
	});
});

function fnDepositSum(){
	$("#searchFromDt").text($("#txtFromDate").val());
	$("#searchToDt").text($("#txtToDate").val());
	
	arrParameter = $("#frmSearchUsrAcct").serializeObject();
	
    //strCallUrl   = "/authorityMgmt/userAccountMgmt/selectDepositSum.do";
    strCallUrl   = "/depositMgmt/depositReport/selectDepositSum.do";
    
    strCallBack  = "fnDepositSumRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    
}

function fnDepositSumRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data != null){
			
			$("#strAppAmtSum").text(IONPay.Utils.fnAddComma(objJson.data[0].APP_AMT)+"원");
			$("#strCanCntSum").text(IONPay.Utils.fnAddComma(objJson.data[0].CAN_AMT)+"원");
			$("#strResrAmtSum").text(IONPay.Utils.fnAddComma(objJson.data[0].RESR_AMT)+"원");
			$("#strResrCcAmtSum").text(IONPay.Utils.fnAddComma(objJson.data[0].RESR_CC_AMT)+"원");
			$("#strExtraAmtSum").text(IONPay.Utils.fnAddComma(objJson.data[0].EXTRA_AMT)+"원");
			
			$("#strFeeSum").text(IONPay.Utils.fnAddComma(objJson.data[0].FEE)+"원");
			$("#strVatSum").text(IONPay.Utils.fnAddComma(objJson.data[0].VAT)+"원");
			$("#strDepositAmtSum").text(IONPay.Utils.fnAddComma(objJson.data[0].DEPOSIT_AMT)+"원");
			
			
			
		}else{
			IONPay.Msg.fnAlert("data not exist");
		}
		
		
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		//$("#modalDetailTaxInfo").hide();
	}
}


function fnTidDetail(id, tid){
	//$("#hdSeq").val(hdSeq);
	strModalID = "modalDetailTaxInfo";
	arrParameter["tid"] = tid;
    //strCallUrl   = "/authorityMgmt/userAccountMgmt/selectDepositSum.do";
    strCallUrl   = "/depositMgmt/depositReport/selectTidDetail.do";
    strCallBack  = "fnTidDetailRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    
}

function fnTidDetailRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data != null){
			$("body").addClass("breakpoint-1024 pace-done modal-open ");
			
			/* $("#modalDetailTaxInfo #modalRecptCl").val(objJson.data[0].USR_ID);
			
			$("#modalDetailTaxInfo #CHG_TAX_DT").html("<c:out value='"+objJson.data[0].PM_NM+"' escapeXml='false' />");
			$("#modalDetailTaxInfo #CHG_ISS_DT").html("<c:out value='"+objJson.data[0].MBS_USR_ID+"' escapeXml='false' />");
			$("#modalDetailTaxInfo #CHG_ID").html("<c:out value='"+objJson.data[0].USR_ID+"' escapeXml='false' />");
			
			$("#modalDetailTaxInfo #CHG_CO_NM").html("<c:out value='"+objJson.data[0].USR_ID+"' escapeXml='false' />");
			$("#modalDetailTaxInfo #CHG_RECPT_CL").html("<c:out value='"+objJson.data[0].USR_ID+"' escapeXml='false' />");
			$("#modalDetailTaxInfo #CHG_ISS_NM").html("<c:out value='"+objJson.data[0].USR_ID+"' escapeXml='false' />"); */
			
			$("#modalDetailTaxInfo #APP_REQ_DNT").html(objJson.data[0].APP_REQ_DNT);
			$("#modalDetailTaxInfo #APP_DNT").html(objJson.data[0].APP_DNT);
			$("#modalDetailTaxInfo #GOODS_NM").html(objJson.data[0].GOODS_NM);
			$("#modalDetailTaxInfo #GOODS_AMT").html(IONPay.Utils.fnAddComma(objJson.data[0].GOODS_AMT) + "원");
			$("#modalDetailTaxInfo #GOODS_SPL_AMT").html(IONPay.Utils.fnAddComma(objJson.data[0].GOODS_SPL_AMT) + "원");
			$("#modalDetailTaxInfo #GOODS_VAT").html(IONPay.Utils.fnAddComma(objJson.data[0].GOODS_VAT) + "원");
			
			$("#modalDetailTaxInfo #UID").html(objJson.data[0].UID);
			$("#modalDetailTaxInfo #ORD_NM").html(objJson.data[0].ORD_NM);
			$("#modalDetailTaxInfo #RSLT_CD").html(objJson.data[0].RSLT_CD);
			$("#modalDetailTaxInfo #PM_MTHD_CD").html(objJson.data[0].PM_MTHD_CD);
			$("#modalDetailTaxInfo #PGSW_VER").html(objJson.data[0].PGSW_VER);
			$("#modalDetailTaxInfo #MBS_DVC_ID").html(objJson.data[0].MBS_DVC_ID);
			
			
			$("#modalDetailTaxInfo #MBS_SCK_ID").html(objJson.data[0].MBS_SCK_ID);
			$("#modalDetailTaxInfo #RSLT_SND_ST").html(objJson.data[0].RSLT_SND_ST);
			$("#modalDetailTaxInfo #RSLT_SND_DNT").html(IONPay.Utils.fnStringToDateFormat(objJson.data[0].RSLT_SND_DNT));
			$("#modalDetailTaxInfo #AUTO_CHRG_CD").html(objJson.data[0].AUTO_CHRG_CD);
			$("#modalDetailTaxInfo #PNT_ID").html(objJson.data[0].PNT_ID);
			
			$("#modalDetailTaxInfo #RE_SND_FLG").html(objJson.data[0].RE_SND_FLG);
			$("#modalDetailTaxInfo #SND_DNT").html(IONPay.Utils.fnStringToDateFormat(objJson.data[0].SND_DNT));
			$("#modalDetailTaxInfo #RCV_DNT").html(IONPay.Utils.fnStringToDateFormat(objJson.data[0].RCV_DNT));
			
			
			
			$("#modalDetailTaxInfo").modal();
			
			//fnChangeUpdateList();
		}else{
			IONPay.Msg.fnAlert("data not exist");
		}
		
		
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalDetailTaxInfo").hide();
	}
}

function fnExcel(strType) {
	  //IONPay.Utils.fnShowSearchArea();
	  //IONPay.Utils.fnHideSearchOptionArea();
		
	  var $objFrmData = $("#frmSearchUsrAcct").serializeObject();

    arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";//strType;
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
    IONPay.Ajax.fnRequestExcel(arrParameter, "/depositMgmt/depositReport/selectUserAccountMgmtListExcel.do");
}

function fnDetailExcel(strType) {
	  //IONPay.Utils.fnShowSearchArea();
	  //IONPay.Utils.fnHideSearchOptionArea();
		
	  var $objFrmData = $("#frmSearchUsrAcct").serializeObject();

    arrParameter = $objFrmData;
    arrParameter["EXCEL_TYPE"]                  = "EXCEL";//strType;
    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
    IONPay.Ajax.fnRequestExcel(arrParameter, "/depositMgmt/depositReport/selectUserAccountMgmtListDetailExcel.do");
}
</script>

<style>
.detail-th {
	background-color: #ecf0f2;
	color: black;
	font-weight: bold;
}

.detail-td {
	background-color: white;
	color: black;
	
}

.td-amt {
	text-align: right;
}
</style>
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
                    <h3><span class="semi-bold">${MENU_TITLE }</span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
                <div class="row">
                   <div class="col-md-12">
                       <div class="grid simple">
                          <div class="grid-title no-border">
                              <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_UAM_0010'/></h4>
                              <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                          </div>
                          <div class="grid-body no-border" id="searchArea">
                            <form id="frmSearchUsrAcct" name="frmSearchUsrAcct">
                            <input id="H_USR_ID" name="H_USR_ID" type="hidden" value="N" />    
                                <div class="row form-row">
                                    <%-- <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_AM_UAM_0011'/></label> 
                                        <input type="text" id="txtUsrID" name="USR_ID" value="" class="form-control" maxlength="10" />
                                    </div> --%>
                                    <div class = "col-md-3">
                                        <label class="form-label">가맹점 ID</label> 
                           				<select id = "MER_SEARCH" name = "MER_SEARCH" class = "select2 form-control">
                           					<option value="<c:out value="${MID }" />"><c:out value="${MID }" /></option>
                           				</select>
                           			</div>
                            			
                            		<div class = "col-md-3">
                                        <label class="form-label">결제수단</label> 
                           				<select id = "PM_CD_TYPE" name = "PM_CD_TYPE" class = "select2 form-control">
                           				</select>
                           			</div>	
                                    <%-- <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_AM_UAM_0012'/></label> 
                                        <input type="text" id="txtUsrNM" name="USR_NM" value="" class="form-control" maxlength="30" />
                                    </div>
                                    <div class="col-md-3">
                                    </div> --%>
                                </div>
                                
                                <div class="row form-row">
	                                <div class="col-md-2">
				                          <label class="form-label">&nbsp;</label>
				                           <select id="SEARCH_DATE_TYPE" name="SEARCH_DATE_TYPE" class="select2 form-control">
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
			                          <div id="divSearchDateType4" class="col-md-4">
			                              <label class="form-label">&nbsp;</label>
			                              <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>
			                              <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
			                              <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
			                              <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
			                              <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
			                          </div>
		                        </div>  
		                        
                                <div class="row form-row">
                                    <div class="col-md-3">
                                        <label class="form-label">가맹점</label> 
                                        <select name="MBS_CD_TYPE" id="MBS_CD_TYPE" class="select2 form-control">
                                        </select>
                                    </div>
                                    <%-- <div id="divAuthSelector" class="col-md-3" style="display:none;">
                                        <label class="form-label"><spring:message code='IMS_AM_UAM_0016'/></label> 
                                        <select name="AUTH_NO" id="selAuthName" class="select2 form-control">
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_AM_UAM_0017'/></label> 
                                        <select name="STATUS" id="selStatus" class="select2 form-control">
                                        </select>
                                    </div> --%>
                                    <div class="col-md-3">
                                        <label class="form-label">&nbsp;</label>
                                        <div>
                                            <button type="button" id="btnSearchUsrAcct" class="btn btn-primary btn-cons"><spring:message code='IMS_AM_UAM_0013'/></button>
                                            <button type="button" id="btnSearchUsrAcctDetail" class="btn btn-primary btn-cons">상세조회</button>
                                            <button type="button" id="btnSearchUsrAcctExcel" class="btn btn-primary btn-cons">Excel</button>
                                            <button type="button" id="btnSearchUsrAcctDetailExcel" class="btn btn-primary btn-cons">상세Excel</button>                                                                                       
                                            <%-- <button type="button" id="btnRegistUsrAcct" class="btn btn-primary auth-all btn-cons" data-toggle='modal' data-target='#divEditUsrAcct'><spring:message code='IMS_AM_UAM_0014'/></button> --%>
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
                               <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_UAM_0018'/></h4>
                               <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                           </div>
                           <div class="grid-body no-border">
                               <div class="grid simple ">
                                  <div id="divGridArea" class="grid-body " style="display:none;">
                                  	* 입금합계
									<br>아래 내역의 조회 기간은 <span id="searchFromDt"></span> ~  <span id="searchToDt"></span> 입니다.

                                  	  <table class="table responsive nowrap" id="tbUsrAcctMgmtSum" width="100%">
                                  	  	<thead>
	                                       <tr>
	                                           <th>결제금액</th>
	                                           <th>취소금액</th>
	                                           <th>지급보류</th>
	                                           <th>보류해제</th>
	                                           <th>별도가감</th>
	                                           <th>수수료</th>
	                                           <th>VAT</th>
	                                           <th>입금액</th>
	                                       </tr>
	                                       
	                                      </thead>
	                                      <tr>
	                                           <td class=" column10c td-amt" id="strAppAmtSum">0원</td>
	                                           <td class=" column10c td-amt" id="strCanCntSum">0원</td>
	                                           <td class=" column10c td-amt" id="strResrAmtSum">0원</td>
	                                           <td class=" column10c td-amt" id="strResrCcAmtSum">0원</td>
	                                           <td class=" column10c td-amt" id="strExtraAmtSum">0원</td>
	                                           <td class=" column10c td-amt" id="strFeeSum">0원</td>
	                                           <td class=" column10c td-amt" id="strVatSum">0원</td>
	                                           <td class=" column10c td-amt" id="strDepositAmtSum">0원</td>
	                                       </tr>
                                  	  </table>
                                  	  
	                                  <table class="table responsive nowrap" id="tbUsrAcctMgmt" width="100%">
	                                      <thead>
	                                       <tr>
	                                           <th>NO</th>
	                                           <th>MID</th>
	                                           <th>입금일</th>
	                                           <th>결제금액</th>
	                                           <th>취소금액</th>
	                                           
	                                           <th>지급보류</th>
	                                           <th>보류해제</th>
	                                           <th>별도가감</th>
	                                           <th>수수료</th>
	                                           <th>VAT</th>
	                                           
	                                           <th>입금액</th>
	                                       </tr>
	                                      </thead>
	                                  </table>
                                  </div>
                              </div>
                            </div>
                        </div>
                    </div>
                </div>              
                
                
                <!-- 상세조회 -->
                <div id="div_search_detail" class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                           <div class="grid-title no-border">
                               <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_UAM_0018'/></h4>
                               <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                           </div>
                           <div class="grid-body no-border">
                               <div class="grid simple ">
                                  <div id="divGridDetailArea" class="grid-body " style="display:none;">
										※ 취소건의 경우 결제일자에 취소일자가 표시되며, 금액은 마이너스('-')로 표시됩니다.
	                                  <table class="table responsive nowrap" id="tbUsrAcctMgmtDetail" width="100%">
	                                      <thead>
	                                       <tr>
	                                           <th>NO</th>
	                                           <th>MID</th>
	                                           <th>입금일</th>
	                                           <th>결제일시</th>
	                                           <th>결제수단</th>
	                                           
	                                           <th>금융사</th>
	                                           <th>TID</th>
	                                           <!-- <th>승인번호</th> -->
	                                           <th>결제금액</th>
	                                           <th>상품명</th>
	                                           
	                                           <th>구매자</th>
	                                           <th>수수료</th>
	                                           <th>VAT</th>
	                                           <!-- <th>SMS</th> -->
	                                           <th>입금액</th>
	                                           
	                                       </tr>
	                                      </thead>
	                                  </table>
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
        <!-- END PAGE CONTAINER-->
    </div>
    <!-- Modal User Acct Insert Area -->
	<div class="modal fade" id="divEditUsrAcct" role="dialog" aria-labelledby="modalAdminDetaillLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" aria-hidden="true" data-dismiss="modal">x</button>
            <br>
            <i id="iconRegist" class="fa fa-pencil fa-2x"></i>
            <i id="iconEdit" class="fa fa-edit fa-2x" style="display:none;"></i>
            <h4 id="myModalInsertUsrAcct" class="semi-bold"><spring:message code='IMS_AM_UAM_0024'/></h4>
            <h4 id="myModalUpdateUsrAcct" class="semi-bold" style="display:none;"><spring:message code='IMS_AM_UAM_0025'/></h4>
            <br>
	      </div>
	      <div class="modal-body">
	           <form name="frmEditMenu" id="frmEditMenu">
                    <input id="hidModechk" name="MODECHK" type="hidden" value="" />
                    <input id="hidMerchantlist" name="MERCHANTIDLIST" type="hidden" value=" " />
                    <div class="row form-row">
	                    <div class="col-md-6">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0011'/></label>
	                        <span id="spUsrIDChk" class="help"></span>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <input id="txtEditUsrID" name="USR_ID" type="text" style="ime-mode:disabled" class="form-control" maxlength="10"/>   
	                        </div>
	                    </div>
	                    <div class="col-md-6">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0012'/></label>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <input id="txtEditUsrName" name="USR_NM" type="text" class="form-control" maxlength="30"/>                               
	                        </div>
	                    </div>
                    </div>
                    <div id="trUsrPassword" class="row form-row">
	                    <div class="col-md-6">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0026'/></label>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <input id="txtEditUsrPassword" name="PSWD" type="password" class="form-control" maxlength="20" />                                
	                        </div>
	                    </div>
	                    <div class="col-md-6">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0027'/></label>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <input id="txtEditUsrPasswordConfirm" name="PSWD_CONFIRM" type="password" class="form-control" maxlength="20" />                               
	                        </div>
	                    </div>
                    </div>
                    <div class="row form-row">
	                    <div class="col-md-6">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0020'/></label>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <input id="txtEditTelNo" name="TEL_NO" type="text" class="form-control" maxlength="40" />                             
	                        </div>
	                    </div>
	                    <div class="col-md-6">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0021'/></label>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <input id="txtEditEmail" name="EMAIL" type="text" class="form-control" maxlength="60" />                    
	                        </div>
	                    </div>
                    </div>
                    <div class="row form-row">
                        <div class="col-md-6">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0015'/></label>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <select id="selEditUsrType" name="USR_TYPE" class="select2 form-control">
	                            </select>
	                        </div>
	                    </div>
	                    <div id="divEditAuthSelector" class="col-md-6" style="display:none;">
	                        <label class="form-label"><spring:message code='IMS_AM_UAM_0028'/></label>
	                        <div class="input-with-icon  right">                                       
	                            <i class=""></i>
	                            <select id="selEditAuthNo" name="AUTH_NO" class="select2 form-control">
	                            </select>
	                        </div>
	                    </div>
                    </div>
                    <br/>
                    <div id="divSelectMerchant" class="form-group" style="display:none;">
                        <label class="form-label"><spring:message code='IMS_AM_UAM_0002'/></label>
                        <span class="help"></span>
                        <div class="  right">
                            <div id="divMerchantSort">
                                <!-- BEGIN: XHTML for example -->   
                                <table id="tdMerchant" class="table" width="100%">
                                    <thead>
	                                    <tr>
	                                        <th class="text-center" colspan="2">
	                                            <div class='checkbox check-info'>
	                                                <input type="checkbox" id="chkAllMerchantFlag" name="AllMerchantFlag" value="ALL" /><label for="chkAllMerchantFlag"></label>&nbsp;&nbsp;<spring:message code='IMS_AM_UAM_0029'/>
	                                            </div>
	                                        </th>
	                                    </tr>
	                                    <tr>
	                                        <th class="column50c"><spring:message code='IMS_AM_UAM_0030'/></th>
	                                        <th class="column50c"><spring:message code='IMS_AM_UAM_0031'/></th>
	                                    </tr>
                                    </thead>
                                    <tbody>
	                                    <tr>
	                                        <td class="column50c"><ul id="list1" class="sortable-list"></ul></td>
	                                        <td class="column50c"><ul id="list2" class="sortable-list"></ul></td>
	                                    </tr>
                                    </tbody>
                                </table>    
                                <!-- END: XHTML for example 2.1 --> 
                            </div>    
                        </div>
                    </div>  
                    <div class="form-group">
                        <label class="form-label"><spring:message code='IMS_AM_UAM_0032'/></label>
                        <span class="help"></span>
                        <div class="input-with-icon  right">                                       
                            <i class=""></i>
                            <select id="selEditUsrStatus" name="STATUS" class="select2 form-control">
                                <option value="1"><spring:message code='IMS_AM_UAM_0003'/></option>
                                <option value="2"><spring:message code='IMS_AM_UAM_0004'/></option>
                            </select>
                        </div>
                    </div> 
                </form>
            </div>            
            <div class="modal-footer">
                <div class="pull-right">
                     <button type="button" id="btnEditUserAcct" class="btn btn-danger">저장</button>
                     <button type="button" class="btn btn-default" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass();">취소</button>
                </div>
            </div>
	    </div>
	  </div>
	</div>
	<!-- Modal User Acct Insert Area -->
	
	
	
	
	<!-- BEGIN MODAL -->
		<div class="modal fade" id="modalDetailTaxInfo"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold">TID 상세조회</h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                	<form id="frmTaxModify" name="frmTaxModify">
			                	<input type="hidden" id="modalRecptCl" name="modalRecptCl">
			                	
	                           
	                           <table class="table">
								<tr>
									<td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
							          	승인요청일시<%-- <spring:message code="IMS_BIM_BM_0510"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
							          	승인일시<%-- <spring:message code="IMS_BIM_BM_0511"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
							          	상품명<%-- <spring:message code="IMS_BIM_BM_0512"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
							          	상품가격<%-- <spring:message code="IMS_BIM_BM_0513"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
							          	공급가액<%-- <spring:message code="IMS_BIM_BM_0514"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
							          	부가가치세<%-- <spring:message code="IMS_BIM_BM_0515"/> --%>
							        </td>
							     </tr>
							     <tr>
							        <td class="detail-td" id="APP_REQ_DNT" style="border:1px solid #c2c2c2;  text-align: center;">
							        </td>
							        <td class="detail-td" id="APP_DNT" style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="GOODS_NM"style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="GOODS_AMT"  style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="GOODS_SPL_AMT" style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="GOODS_VAT" style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							     </tr>
								<tr style="font-weight: bold;">
									<td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	구매자 고유번호<%-- <spring:message code="IMS_BIM_BM_0516"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	구매자명<%-- <spring:message code="IMS_BIM_BM_0517"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	결제결과 코드<%-- <spring:message code="IMS_BIM_BM_0518"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	결제방식 코드<%-- <spring:message code="IMS_BIM_BM_0519"/> --%>
							        </td>
							        <td class="detail-th"  style="border:1px solid #c2c2c2;   text-align: center;">
							          	결제모듈버전<%-- <spring:message code="IMS_BIM_BM_0520"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	가맹점 기기 ID<%-- <spring:message code="IMS_BIM_BM_0521"/> --%>
							        </td>
							     </tr>
							     <tr>
									<td class="detail-td" id="UID" style="border:1px solid #c2c2c2;   text-align: center;">

							        </td>
							        <td class="detail-td" id="ORD_NM" style="border:1px solid #c2c2c2;  text-align: center;">
							        </td>
							        <td class="detail-td" id="RSLT_CD"style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="PM_MTHD_CD"  style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="PGSW_VER" style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="MBS_DVC_ID" style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							     </tr>
						     	<tr>
									<td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	가맹점 소켓 ID<%-- <spring:message code="IMS_BIM_BM_0178"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	결과통보상태<%-- <spring:message code="IMS_BIM_BM_0179"/> --%>
							        </td>
							        <td class="detail-th" colspan="2" style="border:1px solid #c2c2c2;   text-align: center;">
							          	결과통보일시<%-- <spring:message code="IMS_BIM_BM_0205"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	자동충전여부<%-- <spring:message code="IMS_TV_TH_0015"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
							          	포인트 충전내역 ID<%-- <spring:message code="IMS_BIM_BM_0522"/> --%>
							        </td>
							     </tr>
							     <tr>
									<td class="detail-td" id="MBS_SCK_ID" style="border:1px solid #c2c2c2;   text-align: center;">

							        </td>
							        <td class="detail-td" id="RSLT_SND_ST" style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="RSLT_SND_DNT" colspan="2" style="border:1px solid #c2c2c2;   text-align: center;">


							        </td>
							        <td class="detail-td" id=AUTO_CHRG_CD  style="border:1px solid #c2c2c2;   text-align: center;">
							        </td>
							        <td class="detail-td" id="PNT_ID" style="border:1px solid #c2c2c2;  text-align: center;">
							        </td>
							     </tr>
							     <tr>
									<td class="detail-th"  style="border:1px solid #c2c2c2;   text-align: center;">
							          	재통보여부<%-- <spring:message code="IMS_TV_TH_0079"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;" colspan='2'>
							          	등록전송일시<%-- <spring:message code="IMS_BIM_BM_0160"/> --%>
							        </td>
							        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;" colspan='3'>
							          	등록수신일시<%-- <spring:message code="DDLB_0068"/> --%>
							        </td>
							   
							     </tr>
							     <tr>
									<td class="detail-td" id="RE_SND_FLG" style="border:1px solid #c2c2c2;  text-align: center;">
							        </td>
							        <td class="detail-td" id="SND_DNT" style="border:1px solid #c2c2c2; text-align: center;" colspan='2'>
							        </td>
							        <td class="detail-td" id="RCV_DNT"style="border:1px solid #c2c2c2;  text-align: center;" colspan='3'>
							        </td>
							   
							     </tr>
							</table>
		                    
		                    </form>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">확인</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END MODAL -->	
		