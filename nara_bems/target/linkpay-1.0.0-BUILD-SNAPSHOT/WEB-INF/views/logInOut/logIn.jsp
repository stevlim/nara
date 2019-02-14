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
			<input type="text" id="MER_ID" name="MER_ID" placeholder="아이디를 입력해주세요" class="masked" value="121212121m" />
			
			<div class="login_text_fixed">
				username
			</div>
			<input type="text" id="USR_ID" name="USR_ID" placeholder="아이디를 입력해주세요" class="masked" value="eromtest10" />
			<div class="login_text_fixed">
				password
			</div>
			<input type="password" id="PSWD" name="PSWD" placeholder="비밀번호를 입력해주세요" class="masked" style="margin-bottom: 3.3em;" value="qwert1245@" />
			
			<button class="login_btn" id="btnLogin" >로그인&nbsp;&nbsp;</button>
			<button class="login_btn" id="btnChangePassword" style="padding: 12px 80x 12px 30px;" data-toggle='modal' data-target='#PWModal' >비밀번호 변경</button>
			<button class="login_btn" id="btnApplyMerchant" style="padding: 12px 80x 12px 30px;" data-toggle='modal' data-target='#divApplyMerchantModal'>가맹점 요청</button>
			<br/>
			<div class="terms"><a href="#">&#9654; 이용 약관</a></div>
			<div class="terms" style="margin-left: 1em;"><a href="#">&#9654; 개인정보처리방침</a></div>
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