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
        //if (event.which == 13 && $("#frm").valid()) {
        if (event.which == 13) {	
        	fnLoginProc();
        }
    });

	$("#PSWD").on("keydown", function(event) {
        //if (event.which == 13 && $("#frmpw2").valid()) {
        if (event.which == 13) {	
        	fnChangePwProc();
        }
    });

	$("#btnLogin").on("click", function() {
		/* if (!$("#frm").valid()) {
            return;
        } */

		fnLoginProc();
	});

	$("#btnChangePW2").on("click", function(){
		/* if (!$("#frmpw2").valid()) {
            return;
        } */
        var pattern1 = /[0-9]/;
        var pattern2 = /[a-zA-Z]/;
        var pattern3 = /[~!@\#$%<>^&*]/;     // 원하는 특수문자 추가 제거
        
        var pattern4 = /(0123)|(1234)|(2345)|(3456)|(4567)|(5678)|(6789)|(7890)/;
        
        var nowPw = $("#CURPSWD").val();
        var pw = $("#NEWPSWD").val();
        var id = $("#USER_ID").val();
        
        if(nowPw==pw) {
        	alert("새 비밀번호가 기존 비밀번호와 같습니다");
        	return;
        }
        
        if(pwContinue()=="n"){
        	return;
        }
        
        if(pwSame()=="n"){
        	return;
        }
        
        
        if(!pattern1.test(pw)||!pattern2.test(pw)||!pattern3.test(pw)||pw.length<8||pw.length>20){
            alert("비밀번호는 숫자, 영어, 특수문자를 포함한 8자리어야 합니다.");
            return;
        }
        
        
        

        if(pw.indexOf(id) > -1) {
            alert("비밀번호는 ID를 포함할 수 없습니다.");
            return;
        }
        
		fnChangePwProc();
	});

	fnLoadID();

	fnSessionExpiredMsg();
	
	$('#btnMerApply').on("click", function () {
		var mailChk = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		
		if($("#txtInsApplyAddress").val() == "") {
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
		
		if($("#txtInsApplyContEmail").val().match(mailChk) == null) {
			alert($("#merApplyVaildMailMsg").val());
			return;
		}
		
		IONPay.Msg.fnConfirm(gMessage('IMS_SM_SRM_0038'), function () {
			var $ADDRESS = $("#txtInsApplyAddress");
			var $CONT_NM = $("#txtInsApplyContNm");
			var $CONT_TEL = $("#txtInsApplyContTel");
			var $CONT_EMAIL = $("#txtInsApplyContEmail");
			var $MEMO = $("#txtInsApplyMemo");
			
			
			arrParameter = {
			           "ADDRESS"   : $ADDRESS.val(),
			           "CONT_NM" : $CONT_NM.val(),
			           "CONT_TEL" : $CONT_TEL.val(),
			           "CONT_EMAIL" : $CONT_EMAIL.val(),
			           "MEMO" : $MEMO.val()
			           };
			
			strCallUrl  = "/merchantApply.do";
			strCallBack = "fnMerApplySuccessResult";

			IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
			//IONPay.Ajax.fnMerApplyRequest(arrParameter, strCallUrl, strCallBack);
			
		});

    });
	
	/* $('#btnDupChk').on("click", function () {
		var $CO_NO = $("#txtInsApplyCoNo");
		
		arrParameter = {
		           "CO_NO" : $CO_NO.val()
		           };
		
		strCallUrl  = "/coNoDupChk.do";
		strCallBack = "fnCoNoDupChkSuccessResult";

		IONPay.Ajax.fnCoNoDupChkRequest(arrParameter, strCallUrl, strCallBack);
			

    }); */
    
}

//비밀번호에 3자리 이상 연속된 문자(예:abc)는 사용할 수 없습니다.
function pwContinue(){   //연속된 문자, 숫자 체크(3자리)
	var cnt = 0;
	var cnt2 = 0;
	var tmp = "";
	var tmp2 = "";
	var tmp3 = "";
	var validpw = $("#NEWPSWD").val();
	
	//validpw = document.frm01.pw.value; 
	for(i=0; i<validpw.length; i++){
		tmp = validpw.charAt(i);
	 	tmp2 = validpw.charAt(i+1);
	 	tmp3 = validpw.charAt(i+2);
	 
	 	if(tmp.charCodeAt(0) - tmp2.charCodeAt(0) == 1 && tmp2.charCodeAt(0) - tmp3.charCodeAt(0) == 1){
	  		cnt = cnt + 1;
	 	}
	 	
	 	if(tmp.charCodeAt(0) - tmp2.charCodeAt(0) == -1 && tmp2.charCodeAt(0) - tmp3.charCodeAt(0) == -1){
	  		cnt2 = cnt2 + 1;
	 	}
	}
	
	if(cnt > 0 || cnt2 > 0){
	 	alert("비밀번호에 연속된 문자 및 숫자가 있습니다. 예)abc, 123");
	 	return "n";
	}else{
		return "p";
	}
}

// 비밀번호에 3자리 이상 연속된 동일한 문자(예:aaa)는 사용할 수 없습니다.
function pwSame(){   //동일 문자, 숫자 체크(3자리)
	var tmp = "";
	var cnt = 0;
	//validpw = document.frm01.pw.value;
	var validpw = $("#NEWPSWD").val();
	
	for(i=0; i<validpw.length; i++){
		tmp = validpw.charAt(i);
	 //if(tmp == validpw.charAt(i+1) && tmp == validpw.charAt(i+2)){
		if(tmp == validpw.charAt(i+1)){  
			cnt = cnt + 1;
		}
	}
	 
	if(cnt > 0){
		alert("비밀번호에 동일된 문자 및 숫자가 연속됩니다");
		return "n";
	}else{
		return "p";
	}
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
		IONPay.Msg.fnAlert("가맹점 ID는 10자리로 입력해주세요.");
	}else if ($.trim($USR_ID.val()) == "" || $.trim($PSWD.val()) == "") {
	    IONPay.Msg.fnAlert("ID와 비밀번호를 입력하세요.");
	} else {
		arrParameter = {
				   "MER_ID" : $MER_ID.val().trim(),
		           "USR_ID" : $USR_ID.val().trim(),
		           "PSWD"   : $PSWD.val().trim()
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
		IONPay.Msg.fnAlert("ID, 비밀번호를 모두 입력해주세요.");
	} else if($NEWPSWD.val() != $RENEWPSWD.val()){
		IONPay.Msg.fnAlert("변경 비밀번호와 변경 확인 비밀번호가 불일치합니다.");
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
    $("#txtInsApplyAddress").val("");
    $("#txtInsApplyContNm").val("");
    $("#txtInsApplyContTel").val("");
    $("#txtInsApplyContEmail").val("");
    $("#txtInsApplyMemo").val("");
    
    $('#divApplyMerchantModal').modal('hide');    
}

function fnCoNoDupChkSuccessResult() {  
}
</script>
<style> 
#MER_ID {
    width: 270px;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
    margin-top: 0.4em;
    margin-left: 4em;
    color: #5F00FF;
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 0.35em;
    box-sizing: border-box;
    font-weight: 500;
    border: none;
    border-bottom: 1px solid #4d4d4d;
}

#USR_ID {
    width: 270px;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
    margin-top: 0.4em;
    margin-left: 4em;
    color: #5F00FF;
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 0.35em;
    box-sizing: border-box;
    font-weight: 500;
    border: none;
    border-bottom: 1px solid #4d4d4d;
}

#PSWD {
    width: 270px;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
    margin-top: 0.4em;
    margin-left: 4em;
    color: #5F00FF;
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 0.35em;
    box-sizing: border-box;
    font-weight: 500;
    border: none;
    border-bottom: 1px solid #4d4d4d;
}
</style>


<div id="wrap_mms">
	<input type="hidden" id="duplMsg" value="<spring:message code='IMS_MER_JOIN_0010'/>" />
	<input type="hidden" id="notDuplMsg" value="<spring:message code='IMS_MER_JOIN_0011'/>" />
	<input type="hidden" id="paramEmptyMsg" value="<spring:message code='IMS_MER_JOIN_0012'/>" />
	<input type="hidden" id="merApplySuccessMsg" value="<spring:message code='IMS_MER_JOIN_0013'/>" />
	<input type="hidden" id="merApplySuccessMsg2" value="<spring:message code='IMS_MER_JOIN_0027'/>" />
	<input type="hidden" id="merApplyFailMsg" value="<spring:message code='IMS_MER_JOIN_0014'/>" />
	<input type="hidden" id="merApplyValidCoNoMsg" value="<spring:message code='IMS_MER_JOIN_0015'/>" />
	<input type="hidden" id="merApplyVaildMailMsg" value="<spring:message code='IMS_MER_JOIN_0016'/>" />
	
	<img src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/img/login/logo.png" height="10%" style="position: absolute; margin-top: 1em; margin-left: 2em;">
	<div class="box_wrapper">
		<div class="box_right">
			<div class="right_title">
				본인의 계정을 통해 로그인 해주세요.
			</div>
			
			<div class="login_text_fixed">
				merchant id
			</div>
			<input type="text" id="MER_ID" name="MER_ID" placeholder="아이디를 입력해주세요" class="masked" value="erompay01m" />
			
			<div class="login_text_fixed">
				username
			</div>
			<input type="text" id="USR_ID" name="USR_ID" placeholder="아이디를 입력해주세요" class="masked" value="eromuser01" />
			<div class="login_text_fixed">
				password
			</div>
			<input type="password" id="PSWD" name="PSWD" placeholder="비밀번호를 입력해주세요" class="masked" style="margin-bottom: 3.3em;" value="Eromuser01!" />
			
			<button class="login_btn" id="btnLogin" >로그인&nbsp;&nbsp;</button>
			<button class="login_btn" id="btnChangePassword" style="padding: 12px 80x 12px 30px;" data-toggle='modal' data-target='#PWModal' >비밀번호 변경</button>
			<button class="login_btn" id="btnApplyMerchant" style="padding: 12px 80x 12px 30px;" data-toggle='modal' data-target='#divApplyMerchantModal'>가맹점 요청</button>
			<br/>
			<div class="terms"><a href="#" data-toggle='modal' data-target='#useRuleModal'>&#9654; 이용 약관</a></div>
			<div class="terms" style="margin-left: 1em;"><a href="#" data-toggle='modal' data-target='#personalInfoRuleModal'>&#9654; 개인정보처리방침</a></div>
		</div>
		<div class="box_left">
			<div class="left_title">
				MMS 가맹점 관리 시스템
				<div class="line_white"></div>
					<div class="left_text">
						PAY EASY<br/>
						PAY FAST<br/>
						PAY SAFE<br/>
					</div>
				<div class="left_text_italic">
					WITH EROMPAY
				</div>
			</div>
		</div>
	</div>
	<div class="wrap_test"></div>
	<div class="copyright">© 2018 Eromlab. All rights reserved.</div>
</div>


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
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw2');">취소</button>
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
                    <%-- <div class="form-group">
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
                    </div> --%>
                    <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_MER_JOIN_0019'/></h4>
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
                        <label class="form-label"><spring:message code='IMS_MER_JOIN_0009'/></label>
                        <div class="input-with-icon  right">                                       
                            <i class=""></i>
                            <input type="text" id="txtInsApplyContEmail" name="CONT_EMAIL" class="form-control" maxlength="60"/>                                
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"><spring:message code='IMS_MER_JOIN_0018'/></label>
                        <div class="input-with-icon  right">                                       
                            <i class=""></i>
                            <input type="text" id="txtInsApplyAddress" name="ADDRESS" class="form-control" maxlength="100"/>                                
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"><spring:message code='IMS_MER_JOIN_0017'/></label>
                        <div class="input-with-icon  right">                                       
                            <i class=""></i>
                            <input type="text" id="txtInsApplyMemo" name="MEMO" class="form-control" maxlength="40"/>                                
                        </div>
                    </div> 
                    
                    <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_MER_JOIN_0020'/></h4>
                    <label class="form-label"><spring:message code='IMS_MER_JOIN_0023'/></label>
                    <label class="form-label"><spring:message code='IMS_MER_JOIN_0024'/></label>
                    <label class="form-label"><spring:message code='IMS_MER_JOIN_0025'/></label>
                    
                    <br>
                    <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_MER_JOIN_0021'/></h4>
                    
                    <br>
                    <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_MER_JOIN_0022'/></h4>
                    <label class="form-label"><spring:message code='IMS_MER_JOIN_0026'/></label>
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
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="eval(strCallBackFN)();">확인</button>
                <button type="button" id="btnConfirmModalBottm" class="btn btn-default">취소</button>
            </div>
        </div>
    </div>
</div>
<!-- Modal Menu Insert Area -->



<!-- 이용 약관 modal start -->
<div class="modal fade" id="useRuleModal" tabindex="-1" role="dialog" aria-labelledby="modalUseRule" aria-hidden="true">
    <div class="modal-dialog">
    <form id="frmUseRule">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw2');">×</button>
                <br>
                <i class="fa fa-unlock-alt fa-2x"></i>
                <h4 id="modalUseRule" class="semi-bold">이용 약관</h4>
                <br>
            </div>
            <div class="modal-body">
            	<div style="overflow-y:scroll; height:600px; padding:10px; background-color:white;">
					이롬랩 이용약관

										
            	</div>
            	
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw2');">확인</button>
            </div>
        </div>
    </form>
    </div>
</div>
<!-- 이용 약관 modal end -->


<!-- 개인정보처리방침 modal start -->
<div class="modal fade" id="personalInfoRuleModal" tabindex="-1" role="dialog" aria-labelledby="modalPersonalInfoRule" aria-hidden="true">
    <div class="modal-dialog">
    <form id="frmpersonalInfoRule">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw2');">×</button>
                <br>
                <i class="fa fa-unlock-alt fa-2x"></i>
                <h4 id="modalPersonalInfoRule" class="semi-bold">개인정보 처리방침</h4>
                <br>
            </div>
            <div class="modal-body">
            	<div style="overflow-y:scroll; height:600px; padding:10px; background-color:white;">
‘주식회사 이롬랩’(이하 ‘회사’)은 개인정보보호법 등 개인정보를 보호하기 위한 관련법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다. 회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.
<br><br>
○ 본 방침은부터 2018년 9월 1일부터 시행됩니다.<br>
1. 개인정보 수집∙ 이용목적 및 항목<br>
2. 개인정보 수집방법<br>
3. 수집한 개인정보의 이용 및 제 3자 제공<br>
4. 개인정보처리 위탁<br>
5. 개인정보의 처리 및 보유 기간<br>
6. 개인정보의 파기절차 및 방법<br>
7. 정보주체와 법정대리인의 권리·의무 및 그 행사방법<br>
8. 개인정보 자동 수집 장치의 설치∙운영 및 거부에 관한 사항<br>
9. 개인정보의 기술적 ∙ 관리적 보호대책<br>
10. 개인정보 보호책임자 작성<br>
11. 개인정보 권익 침해 및 구제방법<br>
12. 개인정보 처리방침 변경 고지의 의무<br><br>

1. 개인정보 수집∙ 이용목적 및 항목<br>
회사는 이용자의 개인정보를 다음의 목적을 위해 수집합니다. 수집한 개인정보는 다음의 목적이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를 구할 예정입니다.<br><br>

				            	<table class="table">
				            		<tr>
										<td style="border:1px solid #c2c2c2; text-align: center; background-color: #ecf0f2; width: 40%;">
								          	수집∙이용 목적
								        </td>
								        <td style="border:1px solid #c2c2c2; text-align: center; background-color: #ecf0f2; width: 60%;">
								          	수집 항목
								        </td>
								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											회원가입
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	[필수] 이름(실명), 아이디(ID), 홈페이지 및 어플리케이션 로그인 비밀번호, 간편결제 비밀번호, 이메일, 휴대폰번호, 비밀번호 질문과 답, 성별, 생년월일, 등록 계좌정보(은행, 계좌번호), 서비스 이용 기록, 방문 일시, 접속 로그, 쿠키, 접속 IP 정보, 결제기록, 통신사, 단말기정보(기기고유식별값 ,광고식별값), DI(중복가입정보)<br>[선택] 주소
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											충전수단 통합관리 및 적립/사용/현금상환
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	이름(실명), 생년월일, 이메일, 연락처, 은행 및 계좌번호, 상환금액
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											홈페이지 ∙ 어플리케이션 로그인
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	아이디, 비밀번호, 접속기록, 쿠키정보
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											고객상담
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	이롬페이 계정정보, 휴대폰번호, 상담신청 내용
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											온/오프라인 결제
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	이롬페이 결제수단 등록 정보, 결제 내역 , QR코드/바코드/NFC 태킹 형성 정보
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											본인인증 및 스마트폰 인증
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	본인인증정보(이름, 휴대폰번호, 생년월일, 성별, 외국인여부), 계좌점유인증정보(이름, 계좌번호, 은행), 휴대폰점유인증정보(통신사, 휴대폰번호, OS구분, 기기식별번호)
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											이롬페이머니 계좌등록
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	계좌번호, 은행명, 예금주명, 휴대폰번호, 단말기정보
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											충전수단 통합관리 및 연동
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	충전 수단 회원가입정보(아이디, 비밀번호), 포인트 및 마일리지 등 충전수단 잔액 현황
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											충전수단 교환 및 사용
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	충전 수단 교환 내역, 사용 내역(날짜, 사용 금액, 가맹점), 가맹점 정보(사업자번호, 가맹점명, 은행계좌번호, 은행명, 예금주명)
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											마케팅 및 광고 활용
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	이름(실명), 휴대폰번호, 이롬페이 이용실적 및 계정정보, 접속기록, 온라인 행태정보, 쿠키정보
								        </td>								        
								     </tr>
				            	</table>				           
<br>				           
2. 개인정보 수집방법<br>
회사는 이용자의 개인정보 수집 동의 후 다음 방법을 통해 개인정보를 수집합니다.<br>
- 홈페이지 ∙ 어플리케이션 회원가입, 서비스 이용 및 이벤트 참여 등을 통해 이용자가 개인정보 수집에 동의를 하고 직접 정보를 입력<br>
- 가맹점 및 제휴사로부터 제공<br>
- 휴대폰 및 유∙무선 인터넷 서비스 이용 시 생성정보 수집 도구로부터 제공<br>
- 상담절차를 통해 수집된 정보 제공<br><br>

3. 수집한 개인정보의 이용 및 제3자 제공<br>
회사는 원칙적으로 “1. 개인정보 수집∙ 이용목적 및 항목”에서 고지한 범위 내에서만 이용자로부터 수집한 개인정보를 사용하며, 이용자의 동의 없이 해당 범위에 해당하지 않는 목적으로 제3자에게 제공하지 않습니다.<br>
다만, 아래의 경우에는 예외로 합니다.<br>
- 서비스 개선 및 서비스 제공에 필요한 경우<br>
- 법령의 규정에 의하거나 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 정당한 요구가 있는 경우<br>
- 유료 서비스 제공에 따른 요금 정산에 필요한 경우<br>
- 이용자들의 사전 동의를 얻은 경우<br><br>
				            	<table class="table">
				            		<tr>
										<td style="border:1px solid #c2c2c2; text-align: center; background-color: #ecf0f2; width: 35%;">
								          	제공받는 자
								        </td>
								        <td style="border:1px solid #c2c2c2; text-align: center; background-color: #ecf0f2; width: 65%;">
								          	제공 항목
								        </td>
								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											한국모바일인증 주식회사
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	성명, 생년월일, 성별, 외국인여부, 휴대전화번호
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
											금융결제원
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	성명, 생년월일, 성별, 외국인여부, 발급은행, 계좌번호
								        </td>								        
								     </tr>
								</table>     
<br>
4. 개인정보의 처리 및 보유 기간<br>
회사는 “1. 개인정보 수집∙ 이용목적 및 항목”에서 명시된 목적이 달성될 때까지 수집한 개인정보를 보유하며, 이용목적 달성 후에는 해당 정보를 지체 없이 파기합니다. 
다만, 관계 법령의 규정에 의하여 일정기간 보관을 규정하고 있는 경우에는 수집한 이용자의 정보를 일정기간 보관합니다. 법령에 따른 개인정보 보관기간은 다음과 같습니다.<br><br>
								<table class="table">
				            		<tr>
										<td style="border:1px solid #c2c2c2; text-align: center; background-color: #ecf0f2; width: 40%;">
								          	보유항목
								        </td>
								        <td style="border:1px solid #c2c2c2; text-align: center; background-color: #ecf0f2; width: 20%;">
								          	보유 기간
								        </td>
								        <td style="border:1px solid #c2c2c2; text-align: center; background-color: #ecf0f2; width: 40%;">
								          	법적 근거
								        </td>
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											신용정보의 수집/ 처리 및 이용 등에 관한 기록
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	3년
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	신용정보의 이용 및 보호에 관한 법률
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											소비자의 불만 또는 분쟁처리에 관한 기록
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	3년
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	전자상거래 등에서의 소비자보호에관한법률
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											통신사실확인자료를 제공할 때 필요한 로그기록자료
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	3개월
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	통신비밀보호법
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											통신사실확인자료 제공 때 필요한 가입자의 전기통신 일시, 전기통신개시 · 종료시각, 통신번호 등 상대방의 가입자번호, 통신망에 접속된 정보통신기기의 위치추적자료
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	12개월
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	통신비밀보호법
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											대금결제 및 재화 등의 공급에 관한 기록
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	5년
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	전자상거래 등에서의 소비자보호에 관한 법률
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											계약 또는 청약철회 등에 관한 기록
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	5년
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	전자상거래 등에서의 소비자보호에 관한 법률
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											표시/광고에 관한 기록
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	6개월
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	전자상거래 등에서의 소비자보호에 관한 법률
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											전자금융 거래에 관한 기록 및 부정거래 기록
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	5년
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	전자금융거래법
								        </td>								        
								     </tr>
								     
								     <tr>
										<td style="border:1px solid #c2c2c2;   text-align: left;">
											공인전자주소 및 전자문서 유통정보
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: center; vertical-align: middle;">
								        	10년
								        </td>
								        <td style="border:1px solid #c2c2c2;   text-align: left;">
								        	전자문서및전자거래기본법 제31조의18 제4항 및 공인전자문서중계자업무세부준칙 제7조제3항
								        </td>								        
								     </tr>
								</table>		

<br>
5. 개인정보의 파기절차 및 방법<br>
회사는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 방법은 다음과 같습니다.<br>
(1)파기절차:<br>
이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.<br>
(2)파기방법:<br>
전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.<br>
종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.<br><br>

6. 정보주체와 법정대리인의 권리·의무 및 그 행사방법<br>
이용자는 개인정보주체로서 다음과 같은 권리를 행사할 수 있습니다.<br>
- 정보주체는 회사에 대해 언제든지 개인정보 열람,정정,삭제,처리정지 요구 등의 권리를 행사할 수 있습니다.<br>
- 제1항에 따른 권리 행사는 회사에 대해 개인정보 보호법 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 회사는 이에 대해 지체 없이 조치하겠습니다.<br>
- 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출해야 합니다.<br>
- 개인정보 열람 및 처리정지 요구는 개인정보보호법 제35조 제5항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.<br>
- 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.<br>
- 회사는 정보주체 권리에 따른 열람의 요구, 정정· 삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.<br><br>

7. 개인정보 자동 수집 장치의 설치∙운영 및 거부에 관한 사항<br>
회사는 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠기(cookie)’를 사용합니다. <br>
(1) 쿠키란 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보를 의미하며, 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. <br>
(2) 쿠키의 사용 목적 : 쿠키는 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. <br>
(3) 쿠키의 설치 ∙ 운영 및 거부 : <br>
웹 브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부할 수 있습니다. <br>
단, 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.<br><br>

8. 개인정보의 기술적 ∙ 관리적 보호대책<br>
회사는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.<br>
(1) 정기적인 자체 감사 실시<br>
회사는 정기적인 자체 감사를 실시하여 개인정보 취급 관련 안정성 확보를 목표로 합니다.<br>
(2) 개인정보 취급 직원의 최소화 및 교육<br>
회사는 개인정보를 취급하는 담당 직원을 지정하고 해당 담당자에 한해서 개인정보를 관리하는 대책을 시행하고 있습니다.<br>
(3) 내부관리계획의 수립 및 시행<br>
이용자의 개인정보를 안전하게 처리하기 위하여 내부관리계획을 별도로 수립하고 시행하고 있습니다.<br>
(4) 해킹 등에 대비한 기술적 대책<br>
회사는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신 및 점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.<br>
(5) 개인정보의 암호화<br>
이용자의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.<br>
(6) 접속기록의 보관 및 위변조 방지<br>
개인정보처리시스템에 접속한 기록을 최소 6개월 이상 보관, 관리하고 있으며, 접속 기록이 위변조 및 도난, 분실되지 않도록 보안기능 사용하고 있습니다.<br>
(7) 개인정보에 대한 접근 제한<br>
개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.<br>
(8) 문서보안을 위한 잠금장치 사용<br>
개인정보가 포함된 서류, 보조저장매체 등을 잠금장치가 있는 안전한 장소에 보관하고 있습니다.<br>
(9) 비인가자에 대한 출입 통제<br>
개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.<br><br>

9. 개인정보 보호책임자 작성 <br>
회사는 개인정보 처리와 관련한 이용자의 불만을 처리하고 및 이용자의 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.<br><br>

▶ 개인정보 보호책임자 <br>
성명 : 전형순<br>
직책 : 부장<br>
연락처 : 02-6207-5829, sec@eromlab.com<br>
※ 개인정보 보호 담당부서로 연결됩니다.<br><br>

▶ 개인정보 보호 담당부서<br>
부서명 : IT개발팀<br>
연락처 : 02-6207-5829<br><br>

이용자는 회사의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 회사는 이용자의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.<br><br>

11. 개인정보 권익 침해 및 구제방법<br>
이용자는 개인정보 침해에 대한 신고 및 상담이 필요한 경우 아래 기관에 문의하셔서 도움을 받을 수 있습니다.<br>
- 개인정보 침해신고센터 : (국번없이) 118 (http://privacy.kisa.or.kr)<br>
- 개인정보 분쟁조정위원회 : 1833-6972 (http://kopico.go.kr)<br>
- 대검찰청 사이버수사과 : (국번없이)1301, (http://spo.go.kr)<br>
- 경찰청 사이버안전국 : (국번없이)182 (http://cyberbureau.police.go.kr)<br><br>

12. 개인정보 처리방침 변경 고지의 의무<br>
현 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 회사의 홈페이지 및 어플리케이션 내 ‘공지사항’을 통하여 고지할 것입니다.<br>

										
            	</div>
            	
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass(); IONPay.Utils.fnFrmReset('frmpw2');">확인</button>
            </div>
        </div>
    </form>
    </div>
</div>
<!-- 개인정보처리방침 modal end -->