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
	//var $MER_ID = $("#MER_ID");
	var $USR_ID = $("#USR_ID");
	var $PSWD   = $("#PSWD");

	if ($.trim($USR_ID.val()) == "" || $.trim($PSWD.val()) == "") {
	    IONPay.Msg.fnAlert("ID와 비밀번호를 입력하세요.");
	} else {
		arrParameter = {
				   //"MER_ID" : $MER_ID.val().trim(),
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

<div class="mmslogin">
	<div class="topintro">
		<div class="boxintro">
			<span class="logomms"><img src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/img/nara/login/FMS_logo.png" alt="epay" /></span>
			<h1>Facility Operation Manager</h1>
		</div>
	</div>
	<div class="loginpg">
		<div class="formlogin">
			<div class="headerlogin">
				<h2 class="titlelogin">Log-in</h2>
				<div class="checkid">
					<label class="lblcheck">Remember ID<input type="checkbox" name="sport[]" value="Remember ID" checked="checked" /></label>
				</div>
			</div>
			<div class="rowlogin">
				<input type="text" class="uid" id="USR_ID" name="id" autocomplete="on" placeholder="ID" value="eromuser01">
				<input type="password" class="upwd" id="PSWD" name="id" autocomplete="on" placeholder="Password" value="Eromuser01!">
				<button class="btnlogin" id="btnLogin">Login</button>
			</div>
			<div class="rowforgot">
				<a href="/searchId.do" class="linkfgid">Forgot my ID</a>|
				<a href="/searchPassword.do" class="linkfgpwd">Forgot Password</a>
				
			</div>
		</div>
		<div class="botlogin">
			Copyright © 2019 FOM. All Rights Reserved.
		</div>
	</div>
</div>


