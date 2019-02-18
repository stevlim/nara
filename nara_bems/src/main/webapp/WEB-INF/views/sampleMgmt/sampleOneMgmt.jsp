<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	
	
    //fnInitEvent();
    //fnSetDDLB();
    fnEditFaqMgmt();
});

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

    aaaaa samp 01 ~~~~~
