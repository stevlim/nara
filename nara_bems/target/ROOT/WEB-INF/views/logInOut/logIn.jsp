<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
    fnInitEvent();
    //fnLoginProc();
});

function fnInitEvent() {
	$("#USR_ID").focus();

	fnSetValidate();
	fnSetPWValidate();

	$("#USR_ID").on("keydown", function(event) {
        if (event.which == 13 && $("#frm").valid()) {
        	fnLoginProc();
        }
    });

	$("#PSWD").on("keydown", function(event) {
        if (event.which == 13 && $("#frmpw2").valid()) {
        	fnChangePwProc();
        }
    });

	$("#btnLogin").on("click", function() {
		if (!$("#frm").valid()) {
            return;
        }

		fnLoginProc();
	});

	$("#btnChangePW2").on("click", function(){
		if (!$("#frmpw2").valid()) {
            return;
        }

		fnChangePwProc();
	});

	fnLoadID();

	fnSessionExpiredMsg();
	
	$('#btnMerApply').on("click", function () {
		var mailChk = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		
		if($("#txtInsApplyCoNo").val() < 1000000000 || $("#txtInsApplyCoNo").val() > 9999999999) {
			alert($("#merApplyValidCoNoMsg").val());
			return;
		}
		
		if($("#txtInsApplyCoNm").val() == "") {
			alert($("#paramEmptyMsg").val());
			return;
		}
		
		if($("#txtInsApplyRepNm").val() == "") {
			alert($("#paramEmptyMsg").val());
			return;
		}
		
		if($("#txtInsApplyContNm").val() == "") {
			alert($("#paramEmptyMsg").val());
			return;
		}
		
		if($("#txtInsApplyContTel").val() < 1) {
			alert($("#paramEmptyMsg").val());
			return;
		}
		
		if($("#txtInsApplyContCp").val() < 1) {
			alert($("#paramEmptyMsg").val());
			return;
		}
		
		if($("#txtInsApplyContEmail").val().match(mailChk) == null) {
			alert($("#merApplyVaildMailMsg").val());
			return;
		}
		
		IONPay.Msg.fnConfirm(gMessage('IMS_SM_SRM_0038'), function () {
			var $CO_NO = $("#txtInsApplyCoNo");
			var $CO_NM = $("#txtInsApplyCoNm");
			var $REP_NM = $("#txtInsApplyRepNm");
			
			var $CONT_NM = $("#txtInsApplyContNm");
			var $CONT_TEL = $("#txtInsApplyContTel");
			var $CONT_CP = $("#txtInsApplyContCp");
			var $CONT_EMAIL = $("#txtInsApplyContEmail");
			
			
			
			arrParameter = {
			           "CO_NO" : $CO_NO.val(),
			           "CO_NM"   : $CO_NM.val(),
			           "REP_NM"   : $REP_NM.val(),
			           "CONT_NM" : $CONT_NM.val(),
			           "CONT_TEL" : $CONT_TEL.val(),
			           "CONT_CP"   : $CONT_CP.val(),
			           "CONT_EMAIL" : $CONT_EMAIL.val()
			           };
			
			strCallUrl  = "/merchantApply.do";
			strCallBack = "fnMerApplySuccessResult";

			IONPay.Ajax.fnMerApplyRequest(arrParameter, strCallUrl, strCallBack);
			
		});

    });
	
	$('#btnDupChk').on("click", function () {
		var $CO_NO = $("#txtInsApplyCoNo");
		
		arrParameter = {
		           "CO_NO" : $CO_NO.val()
		           };
		
		strCallUrl  = "/coNoDupChk.do";
		strCallBack = "fnCoNoDupChkSuccessResult";

		IONPay.Ajax.fnCoNoDupChkRequest(arrParameter, strCallUrl, strCallBack);
			

    });
    
}

function fnSetValidate() {
    var arrValidate = {
                FORMID   : "frm",
                VARIABLE : {
                	"USR_ID"  : {minlength:4, maxlength: 10, required: true},
                	"PSWD"    : {minlength:6, maxlength: 20, required: true}
                    }
    }

    IONPay.Utils.fnSetValidate(arrValidate);
}

function fnSetPWValidate() {
    var arrValidate = {
                FORMID   : "frmpw2",
                VARIABLE : {
                	MERCHANT_ID	  : {minlength:4, maxlength: 10, required: true},
                	USER_ID	  : {minlength:4, maxlength: 10, required: true},
                    CURPSWD   : {minlength:1, maxlength: 20, required: true},
                    NEWPSWD   : {minlength:8, maxlength: 20, notEqualTo: "#CURPSWD", required: true, passwordCheck:true, pwCheckConsecChars:true },
                    RENEWPSWD : {minlength:8, maxlength: 20, equalTo: "#NEWPSWD", required: true, passwordCheck:true, pwCheckConsecChars:true }
                }
    }

    IONPay.Utils.fnSetValidate(arrValidate);
}

function fnLoginProc() {
	var $MER_ID = $("#MER_ID");
	var $USR_ID = $("#USR_ID");
	var $PSWD   = $("#PSWD");

	if($.trim($MER_ID.val()).length < 10) {
		IONPay.Msg.fnAlert("Please Write Your Merchant Id (10 length).");
	}else if ($.trim($USR_ID.val()) == "" || $.trim($PSWD.val()) == "") {
	    IONPay.Msg.fnAlert("Please Enter Your Username or Password.");
	} else {
		arrParameter = {
				   "MER_ID" : $MER_ID.val(),
		           "USR_ID" : $USR_ID.val(),
		           "PSWD"   : $PSWD.val()
		           };

		strCallUrl  = "/logInProc.do";
		strCallBack = "fnLoginProcRet";

		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}

function fnLoginProcRet(objJson) {
    if (objJson.resultCode == 0) {
        if ($("input:checkbox[id='save_id']").is(":checked") == true) {
            IONPay.Utils.fnSetCookie("IMSSaveID=", $("#USR_ID").val(), 3650);
        } else {
            IONPay.Utils.fnSetCookie("IMSSaveID=", $("#USR_ID").val(), 0);
        }

        var strPrevPaage = "${sessionScope['IMSPrevPage']}";

        if($.trim(strPrevPaage) == "") {
            location.href = "/home/dashboard/dashboard.do";
        } else {
            location.href = strPrevPaage;
        }
    } else {
    	if(objJson.resultMessage == "90"){
    		$("body").addClass("breakpoint-1024 pace-done modal-open ");
            $("#btnModalPW").click();
    	} else {
    		IONPay.Msg.fnAlert(objJson.resultMessage);
    	}
    }
}

function fnLoadID(){
    var strSaveID = IONPay.Utils.fnGetCookie("IMSSaveID=");

    if (strSaveID != "") {
        $("#USR_ID").val(strSaveID);
        $("#save_id").attr("checked", true);
    } else {
        $("#save_id").attr("checked", false);
    }
}

function fnSessionExpiredMsg() {
	if (IONPay.Utils.fnGetCookie("<c:out value="${CommonConstants.IMS_SESSION_EXP_KEY}"/>") == "=true") {
	    IONPay.Utils.fnSetCookie("<c:out value="${CommonConstants.IMS_SESSION_EXP_KEY}"/>=", "false", 0);
		IONPay.Msg.fnAlert(gMessage("IMS_COM_MSG_0002"));
	}
}

function fnChangePwProc(){
	
	var $MER_ID = $("#MERCHANT_ID");
	var $USR_ID = $("#USER_ID");
	var $CURPSWD = $("#CURPSWD");
	var $NEWPSWD = $("#NEWPSWD");
	var $RENEWPSWD = $("#RENEWPSWD");

	if ($.trim($MER_ID.val()) == "" || $.trim($USR_ID.val()) == "" || $.trim($CURPSWD.val()) == "" || $.trim($NEWPSWD.val()) == "" || $.trim($RENEWPSWD.val()) == "" ) {
		IONPay.Msg.fnAlert("Please Enter Your Merchant ID, ID, Current Password, NewPassword and RenewPassword.");
	} else if($NEWPSWD.val() != $RENEWPSWD.val()){
		IONPay.Msg.fnAlert("New password and Renew password art wrong. Check please.");
	} else {
		arrParameter = {
			"MER_ID" 	: $MER_ID.val(),
			"USR_ID" 	: $USR_ID.val(),
        	"CURPSWD"   : $CURPSWD.val(),
        	"NEWPSWD"	: $NEWPSWD.val(),
        };
		strCallUrl  = "/logInChangePasswordBeforeProc.do";
		strCallBack = "fnlogInChangePasswordBeforeProcRet";

		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}

}

function fnlogInChangePasswordBeforeProcRet(objJson){
	if (objJson.resultCode == 0) {
		IONPay.Utils.fnFrmReset("frmpw2");
    	IONPay.Msg.fnAlertWithModal(gMessage('IMS_COM_LNB_0001'), "PWModal", true);
	} else {
		IONPay.Utils.fnFrmReset("frmpw2");
	    IONPay.Msg.fnAlertWithModal(objJson.resultMessage, "PWModal", true);
	}
}

function fnMerApplySuccessResult() {
    $("#txtInsApplyCoNo").val("");
    $("#txtInsApplyCoNm").val("");
    $("#txtInsApplyRepNm").val("");
    $("#txtInsApplyContNm").val("");
    $("#txtInsApplyContTel").val("");
    $("#txtInsApplyContCp").val("");
    $("#txtInsApplyContEmail").val("");
    
    $('#divApplyMerchantModal').modal('hide');    
}

function fnCoNoDupChkSuccessResult() {  
}

</script>
	<input type="hidden" id="duplMsg" value="<spring:message code='IMS_MER_JOIN_0010'/>" />
	<input type="hidden" id="notDuplMsg" value="<spring:message code='IMS_MER_JOIN_0011'/>" />
	<input type="hidden" id="paramEmptyMsg" value="<spring:message code='IMS_MER_JOIN_0012'/>" />
	<input type="hidden" id="merApplySuccessMsg" value="<spring:message code='IMS_MER_JOIN_0013'/>" />
	<input type="hidden" id="merApplyFailMsg" value="<spring:message code='IMS_MER_JOIN_0014'/>" />
	<input type="hidden" id="merApplyValidCoNoMsg" value="<spring:message code='IMS_MER_JOIN_0015'/>" />
	<input type="hidden" id="merApplyVaildMailMsg" value="<spring:message code='IMS_MER_JOIN_0016'/>" />
	
	<form id="frm">
		<div class="link-logo">
	    	<img src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/img/LINK%20PAY-LOGO.png" alt="logo" />
		</div>
		<div class="login-block">
		    <h1>Login</h1>
		    <input type="text" placeholder="MerchantId" id="MER_ID" name="MER_ID" value="paylink00m" style="padding:0 20px 0 50px !important"/>
		    <input type="text" placeholder="Username" id="USR_ID" name="USR_ID" value="testmms" style="padding:0 20px 0 50px !important"/>	<!-- mid:testmmsm gid:testmmsg vid:testmmsv -->
		    <input type="password" placeholder="Password" id="PSWD" name="PSWD" value="123456" style="padding:0 20px 0 50px !important"/>
		    <button id="btnLogin" class="btn1">Submit</button>
		    <button id="btnChangePassword" class="btn1" data-toggle='modal' data-target='#PWModal'>Change Password</button>
		    <button id="btnApplyMerchant" class="btn1" data-toggle='modal' data-target='#divApplyMerchantModal'>Merchant Apply</button>
		    <%-- <button id="btnRegistMenu" type='button' class='btn btn-primary auth-all btn-cons' ><spring:message code='IMS_AM_MM_0010'/></button> --%>
		</div>
	</form>


    <button id="btnModalPW" data-toggle="modal" data-target="#PWModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="PWModal" tabindex="-1" role="dialog" aria-labelledby="modalPW" aria-hidden="true">
        <div class="modal-dialog">
        <form id="frmpw2">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw2');">×</button>
                    <br>
                    <i class="fa fa-unlock-alt fa-2x"></i>
                    <h4 id="modalPW" class="semi-bold"><spring:message code='IMS_COM_LNB_0002'/></h4>
                    <br>
                    <spring:message code='IMS_CHG_PW_0002'/><br><spring:message code='IMS_COM_LNB_0006'/>
                </div>
                <div class="modal-body">
                	<div class="row form-row">
                        <div class="col-md-12">
                            <div class="input-with-icon  right">
                                <i class=""></i>
                                <input class="form-control pswd" type="text" id="MERCHANT_ID" name="MERCHANT_ID" placeholder="<spring:message code='IMS_CHG_PW_0001'/>" maxlength=64">
                            </div>
                        </div>
                    </div>
                    <div class="row form-row">
                        <div class="col-md-12">
                            <div class="input-with-icon  right">
                                <i class=""></i>
                                <input class="form-control pswd" type="text" id="USER_ID" name="USR_ID" placeholder="<spring:message code='IMS_AM_MM_0016'/>" maxlength=64">
                            </div>
                        </div>
                    </div>
                    <div class="row form-row">
                        <div class="col-md-12">
                            <div class="input-with-icon  right">
                                <i class=""></i>
                                <input class="form-control pswd" type="password" id="CURPSWD" name="CURPSWD" placeholder="<spring:message code='IMS_COM_LNB_0003'/>" maxlength=64">
                            </div>
                        </div>
                    </div>
                    <div class="row form-row">
                        <div class="col-md-12">
                            <div class="input-with-icon  right">
                                <i class=""></i>
                                <input class="form-control pswd" type="password" id="NEWPSWD" name="NEWPSWD" placeholder="<spring:message code='IMS_COM_LNB_0004'/>" maxlength=64">
                            </div>
                        </div>
                    </div>
                    <div class="row form-row">
                        <div class="col-md-12">
                            <div class="input-with-icon  right">
                                <i class=""></i>
                                <input class="form-control pswd" type="password" id="RENEWPSWD" name="RENEWPSWD" placeholder="<spring:message code='IMS_COM_LNB_0005'/>" maxlength=64">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnChangePW2" class="btn btn-danger">&nbsp&nbspOk&nbsp&nbsp</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw2');">Cancel</button>
                </div>
            </div>
        </form>
        </div>
    </div>

    <!-- Merchant Apply Insert Area -->
    <div class="modal fade" id="divApplyMerchantModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">    
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" data-dismiss="modal">x</button>
                    <br>
                    <i id="iconRegist" class="fa fa-pencil fa-2x"></i>
                    <i id="iconEdit" class="fa fa-edit fa-2x" style="display:none;"></i>
                    <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_MER_JOIN_0001'/></h4>
                    <br>
                </div>
                <div class="modal-body">
                    <!-- <form name="frmEditMenu" id="frmEditMenu"> -->
                    <form name="frmMerApply" id="frmMerApply">
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_MER_JOIN_0003'/></label>
                            <div class="input-with-icon  right">
                            	<table>
                            		<tr>
                            			<td>
                            				<input type="number" id="txtInsApplyCoNo" name="CO_NO" class="form-control" style='width:400px' min="1" max="9999999999">
                            			</td>
                            			<td>
                            				<button type='button'  id="btnDupChk" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin-top:7px; margin-left:10px' onclick="">
												<spring:message code='IMS_BM_CM_0089'/>
											</button>
                            			</td>
                            		</tr>
                            	</table>                                       
                            </div>
                            
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_MER_JOIN_0004'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsApplyCoNm" name="CO_NM" class="form-control" maxlength="40" required/>                                 
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_MER_JOIN_0005'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsApplyRepNm" name="REP_NM" class="form-control" maxlength="30" required/>                                 
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_MER_JOIN_0006'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsApplyContNm" name="CONT_NM" class="form-control" maxlength="30" required/>                                
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_MER_JOIN_0007'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="number" id="txtInsApplyContTel" name="CONT_TEL" class="form-control" maxlength="40"/>                                
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_MER_JOIN_0008'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="number" id="txtInsApplyContCp" name="CONT_CP" class="form-control" maxlength="40"/>                                
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_MER_JOIN_0009'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsApplyContEmail" name="CONT_EMAIL" class="form-control" maxlength="60"/>                                
                            </div>
                        </div> 
                    </form>
                </div>            
                <div class="modal-footer">
                    <div class="pull-right">
                         <button type="button" id="btnMerApply" class="btn btn-danger">저장</button>
                         <button type="button" class="btn btn-default" data-dismiss="modal" onclick="javascript:IONPay.Msg.fnResetBodyClass();fnMerApplySuccessResult();">취소</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- BEGIN CONFIRM MODAL -->
    <button id="btnModalConfirm" data-toggle="modal" data-target="#confirmModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="modalConfirm" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" id="btnConfirmModalTop" class="close" aria-hidden="true">×</button>
                    <br>
                    <i class="fa fa-exclamation fa-2x"></i>
                    <h4 id="modalConfirm" class="semi-bold"></h4>
                    <br>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="eval(strCallBackFN)();">OKay</button>
                    <button type="button" id="btnConfirmModalBottm" class="btn btn-default">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal Menu Insert Area -->