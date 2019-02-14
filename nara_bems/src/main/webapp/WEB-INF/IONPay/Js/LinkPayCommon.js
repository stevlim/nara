/**------------------------------------------------------------
 * LinkPay Global Constants
 ------------------------------------------------------------*/
var LinkPay = {
	COMMONERRORMSG1   : "error1",
	COMMONERRORMSG2   : "error2",
	COMMONERRORMSG3   : "error3"
}

/**------------------------------------------------------------
 * LinkPay.Ajax
 ------------------------------------------------------------*/
LinkPay.Ajax = {
	/**------------------------------------------------------------
	 * Function Name  : fnRequest
	 * Description    : Ajax Process
	 * Author         : 2017. 10. 12.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnRequest: function(arrParameter, strCallUrl, strCallBack, aSync) {
		var intErrCnt = 0;
		$.ajax({
			cache: false,
			async: (typeof (aSync) == "undefined" ? false : aSync),
			type: "POST",
			data: JSON.stringify(arrParameter),
			url: strCallUrl,
			dataType: "JSON",
			contentType: "application/json; charset=utf-8",
			headers: { "IMSRequestVerificationToken": IONPay.AntiCSRF.getVerificationToken() },
			beforeSend: function () {			    
			   //로딩바 시작
			},
			complete: function () {
			   //로딩바 종료
			},
			success: function (objJson) {
				if (typeof (objJson) === "object") {
				    eval(strCallBack)(objJson);
				} else if (typeof (objJson) === "string") {
					eval(strCallBack)(jQuery.parseJSON(objJson));
				} 
	        },
			error: function (XMLHttpRequest, textStatus, errorThrown) {
			    
				//세션 만료
			    if(XMLHttpRequest.status == 901) {
//			    	IONPay.Msg.fnAlert("세션이 만료되었습니다.\n다시 로그인해 주세요. ");
//			    	location.href = "/logout.jsp";
			        return;
			    }

				if(XMLHttpRequest.readyState == 4 && textStatus == "parsererror") {
				    alert(LinkPay.COMMONERRORMSG1);
				}else if (XMLHttpRequest.readyState == 0 && textStatus == "error") {
				    alert(LinkPay.COMMONERRORMSG1);
				}else{
					alert(XMLHttpRequest.responseText);
				}
				
			}
		});
	}

}