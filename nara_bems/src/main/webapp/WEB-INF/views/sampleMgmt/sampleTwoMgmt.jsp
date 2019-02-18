<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	$("#hdingpgNm").text("Sample 02");
	
    //fnInitEvent();
    //fnSetDDLB();
    //fnEditFaqMgmt();
});

function fnEdit() {
	arrParameter = $("#regist").serializeObject();
	arrParameter["worker"] = strWorker;
	
	strCallUrl = "/rmApproval/approvalLimit/selectApproLimitDetail.do";
	strCallBack = "fnEditRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnEditRet(objJson) {
	if (objJson.resultCode == 0) {
		if(objJson.data != null ) {
			$("#regist #tranCutFlg").val(objJson.data.BLOCK_FLG);
			$("#regist #date").val(objJson.data.FR_DT);
			$("#regist #payType").val(objJson.data.PM_CD);
			$("#regist #instMon").val(objJson.data.INSTMN_DT);
			$("#regist #limitType").val(objJson.data.LMT_CD);
			$("#regist #detail").val(objJson.data.LMT_TYPE_CD);
			$("#regist #cashLimit").val(objJson.data.AMT_TYPE);
			$("#regist #limit").val(objJson.data.AMT_LMT);
			$("#regist #countLimit").val(objJson.data.CNT_TYPE);
			$("#regist #count").val(objJson.data.CNT_LMT);
			$("#regist #sendChk").val(objJson.data.NOTI_FLG);
			$("#regist #target").val(objJson.data.NOTI_TRG_TYPE);
			$("#regist #pac").val(objJson.data.NOTI_PCT);
			
			$("#regist #maxCount").val(objJson.data.MAX_SND_CNT);
			$("#regist #sendEmail").val(objJson.data.EMAIL_LIST);
			$("#regist #sendSms").val(objJson.data.SMS_LIST);
			$("#regist #regiReason").val(objJson.data.MEMO);
			$("#regist #registType").val("1");	
			$("#regist #seqNo").val(objJson.data.SEQ);	
		}
	} else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

/**------------------------------------------------------------
* FAQ 등록/수정
------------------------------------------------------------*/
function fnEditFaqMgmt() {
    alert("123123213123777777");
        var editMode = "insert";
        
		// 구분 - CTGR : division
		// 표시 - NOTI_TYPE : flag
		// Question - TITLE : TITLE 
		// Ask - BODY : $("#MEMO_EDITOR").data("wysihtml5").editor.getValue();
		arrParameter = {
	        "CTGR" 		 : "26",
	        "NOTI_TYPE"  : "26",
	        "TITLE"      : "26",
	        "BODY"       : "23",
	        "SEQ_NO"     : "23",
        };
		//"STATUS"	 : $.trim($("#STATUS").val()),
        strCallUrl  = (editMode == "insert" ? "/sampleMgmt/sampleOneMgmt/insertFaqMgmt.do" : "/sampleMgmt/sampleOneMgmt/updateFaqMgmt.do");
        strCallBack = "fnEditFaqMgmtRet";
         
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    
}

function fnEditFaqMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearHideForm();
        fnFaqMgmtListDT();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);      
    }
}

</script>

<!-- Sample 02 -->
<div class="transpg">
	<ul class="tabmerchant tabtrans">
		<li class="selected"><a href="#0" class="titletabs">Merchant<br />info</a></li>
		<li><a href="#0" class="titletabs">Settlement<br />info</a></li>
		<li><a href="#0" class="titletabs">Service<br />info</a></li>
		<li><a href="#0" class="titletabs">Limit<br />info</a></li>
	</ul>
	<div class="tab_content">
		<div class="contentmerchant transcontent">
			<h3 class="titlemerchant">Merchant information</h3>
			<ul class="list_transhistory">
				<li>
					<span class="labeltranshistory">MID</span>
					<span class="infotranshistory">EPAYTEST</span>
				</li>
				<li>
					<span class="labeltranshistory">MID name</span>
					<span class="infotranshistory">VNPT EPAY</span>
				</li>
				<li>
					<span class="labeltranshistory">Representative MID</span>
					<span class="infotranshistory">EPAYTEST</span>
				</li>
				<li>
					<span class="labeltranshistory">Tax number</span>
					<span class="infotranshistory">123456799</span>
				</li>
				<li>
					<span class="labeltranshistory">Phone number</span>
					<span class="infotranshistory">84 234 5678</span>
				</li>
				<li>
					<span class="labeltranshistory">Fax</span>
					<span class="infotranshistory">84 234 5678</span>
				</li>
				<li>
					<span class="labeltranshistory">Homepage</span>
					<span class="infotranshistory">www.vnptepay.com.vn</span>
				</li>
				<li>
					<span class="labeltranshistory">Contracting person</span>
					<span class="infotranshistory">Dang Kim Ngan</span>
				</li>
				<li>
					<span class="labeltranshistory">Business PIC</span>
					<span class="infotranshistory">Phan Van A</span>
				</li>
				<li>
					<span class="labeltranshistory">Technical PIC</span>
					<span class="infotranshistory">Nguyen Van B</span>
				</li>
				<li>
					<span class="labeltranshistory">Contract status</span>
					<span class="infotranshistory">Effective</span>
				</li>
				<li>
					<span class="labeltranshistory">Contract effective date</span>
					<span class="infotranshistory">01/12/2018</span>
				</li>
			</ul>
		</div>
	</div>
</div>
