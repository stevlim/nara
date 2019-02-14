<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strType;
var map= new Map();
$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    //fnModalSerTid();
});

function fnInitEvent() {
    /* $("select[name=idChk]").on("change", function(){
    	if ($.trim(this.value) == "all") {
    		$("#txtIdSearch").val("");
    		$("#txtIdSearch").attr("readonly", true);
    	}
    	else {
    		$("#txtIdSearch").attr("readonly", false);
    	}
    }); */
    
    /* $("select[name=typeChk]").on("change", function(){
    	if ($.trim(this.value) == "all") {
    		$("#txtTypeSearch").val("");
    		$("#txtTypeSearch").attr("readonly", true);
    	}
    	else {
    		$("#txtTypeSearch").attr("readonly", false);
    	}
    }); */
    
    $("select[name=searchPayFlg]").on("change", function(){
    	if ($.trim(this.value) == "ALL") {
    		$("#txtPaySearch").val("");
    		$("#txtPaySearch").attr("readonly", true);
    	}
    	else {
    		$("#txtPaySearch").attr("readonly", false);
    	}
    });
    
    $("#btnSearch").on("click", function() {
    	$("#divTidList").css("display", "none");
    	$("#div_search").css("display", "block");
    	 strType = "SEARCH";
    	var $FROM_DT = $("#txtFromDate");
        var $TO_DT   = $("#txtToDate");

        map.set("strDate" , $("#dateChk").val());

        var intFromDT = Number(IONPay.Utils.fnConvertDateFormat($FROM_DT.val()));
        var intToDT   = Number(IONPay.Utils.fnConvertDateFormat($TO_DT.val()));
        console.log(intFromDT);
        console.log(intToDT);
        if (intFromDT > intToDT) {
            IONPay.Msg.fnAlert(gMessage('IMS_BM_IM_0011'));
            return;
        }

        if (!IONPay.Utils.fnCheckSearchRange($("#txtFromDate"), $("#txtToDate"), "3")) {
            return;
        }
        //fnSelectCardInfoAmt();
        fnInquiry(strType);
    });
    $("#btnExcel").on("click", function() {
    	strType = "EXCEL";
    	//엑셀은 리스트만 조회해오면 됨
    	fnInquiry(strType);
    });
    
    $("#btnAllReqest").on("click", function() {
    	var clearReqChk = confirm("정산요청 하시겠습니까?");
    	
    	if(clearReqChk == true) {
    		arrParameter = $("#frmSearchList").serializeObject();
    		arrParameter["WORKER"] = $("#WORKER").val();
    		/* arrParameter["TID"] = tid;
    		arrParameter["TRX_STAT_CD"] = trxStatCd; */
    		
    		strCallUrl   = "/baseInfoMgmt/settleReqMgmt/updateAllSettleReqStatus.do";
    		//strCallUrl   = "/rmApproval/blackListMgmt/updateBlackListClear.do";
    		strCallBack  = "fnClearUpdateRet";
    		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    	}else {
    		return;
    	}
    	
    	/* $("#divTidList").css("display", "none");
    	$("#div_search").css("display", "block");
    	 strType = "SEARCH";
    	var $FROM_DT = $("#txtFromDate");
        var $TO_DT   = $("#txtToDate");

        map.set("strDate" , $("#dateChk").val());

        var intFromDT = Number(IONPay.Utils.fnConvertDateFormat($FROM_DT.val()));
        var intToDT   = Number(IONPay.Utils.fnConvertDateFormat($TO_DT.val()));
        console.log(intFromDT);
        console.log(intToDT);
        if (intFromDT > intToDT) {
            IONPay.Msg.fnAlert(gMessage('IMS_BM_IM_0011'));
            return;
        }

        if (!IONPay.Utils.fnCheckSearchRange($("#txtFromDate"), $("#txtToDate"), "3")) {
            return;
        }
        fnInquiry(strType); */
    });
    
    //$(".confirmChkProcClass").on("click", function() {alert("9999");
    	/* var checkBoxClickIndex = $("input[name=confirmChkProc]").index(this);
    	var confirmChkedTf = $("#div_searchResult input[name=confirmChkedTf]");
	    
    	alert(checkBoxClickIndex + " : " + confirmChkedTf.eq(checkBoxClickIndex).val());
    	
    	if(confirmChkedTf.eq(checkBoxClickIndex).val() == "T") {
    		confirmChkedTf.eq(checkBoxClickIndex).val("F");
    	}else {
    		confirmChkedTf.eq(checkBoxClickIndex).val("T");
    	}
    	
    	alert(checkBoxClickIndex + " :: " + confirmChkedTf.eq(checkBoxClickIndex).val()); */
    //});
    
    
}

function fnSetDDLB() {
    $("#frmSearch #searchFlg").html("<c:out value='${MER_SEARCH}' escapeXml='false' />");
    $("#frmSearch #searchPayFlg").html("<c:out value='${PAY_SEARCH}' escapeXml='false' />");

    $("#frmSearch #dateChk").html("<c:out value='${DateChk}' escapeXml='false' />");
    //$("#frmSearch #idChk").html("<c:out value='${IdChk}' escapeXml='false' />");
    //$("#frmSearch #typeChk").html("<c:out value='${TypeChk}' escapeXml='false' />");
    
}

function fnSelectCardInfoAmt(){
	arrParameter = $("#frmSearch").serializeObject();
	strCallUrl   = "/paymentMgmt/payInquiry/selectCardInfoAmt.do";
    //strCallUrl   = "/paymentMgmt/card/selectCardInfoAmt.do";
    strCallBack  = "fnSelectCardInfoAmtRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectCardInfoAmtRet(objJson){
	
	if(objJson.resultCode == 0 ){
		$("#div_searchResult").css("display", "block");
		$("#tbCardAmtInfo #appCnt").html(objJson.data[0].APPCNT==null?"0":objJson.data[0].APPCNT);
		$("#tbCardAmtInfo #appAmt").html(objJson.data[0].APPAMT==null?"0":objJson.data[0].APPAMT);
		$("#tbCardAmtInfo #canCnt").html(objJson.data[0].CCCNT==null?"0":objJson.data[0].CCCNT);
		$("#tbCardAmtInfo #canAmt").html(objJson.data[0].CCAMT==null?"0":objJson.data[0].CCAMT);
		$("#tbCardAmtInfo #cntSum").html(objJson.data[0].TOT_CNT==null?"0":objJson.data[0].TOT_CNT);
		$("#tbCardAmtInfo #amtSum").html(objJson.data[0].TOT_AMT==null?"0":objJson.data[0].TOT_AMT);
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#tbCardAmtInfo").hide();
	}
}

function fnInquiry(strType) {
    if(strType == "SEARCH"){
	    $("#div_searchResult").serializeObject();
	    $("#div_searchResult").show(200);
		if (typeof objCoMInfoInquiry == "undefined") {
			objCoMInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbCardTransList", true, {
	        
	        //url: "/paymentMgmt/payFailInquiry/selectTransFailInfoList.do",
	        url: "/baseInfoMgmt/settleReqMgmt/selectSettleReqList.do",
	        
	        data: function() {
	            return $("#frmSearch").serializeObject();
	        },
	        columns: [
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.TID==null?"":data.TID} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MID==null?"":data.MID} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.GID==null?"":data.GID} },	
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.VID==null?"":data.VID} },
	             
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.PM_CD_NM==null?"":data.PM_CD_NM} },	
	             { "class" : "columnc all",         "data" : null, "render": function(data){
	            	var str = "";
	            	if(data.TRX_STAT_CD == "0") {
	            		str = "승인";
	            	}else if(data.TRX_STAT_CD == "2") {
	            		str = "취소";
	            	}
	            	
	            	return str;
	            			 
	             } },
	             //{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.TRX_APP_CD==null?"":data.TRX_APP_CD} },
	             /* { "class" : "columnc all",         "data" : null, "render": function(data){
	            	 var str = "";
	            	 
	            	 if(data.TRX_APP_CD_NM != null) {
	            		 str = "<span style='color:blue;'>" + data.TRX_APP_CD_NM + "</span>";	 
	            	 }
	            	 
	            	 return str;
	             } }, */
	             
	             
	             //{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.TRX_CC_HIST_CD==null?"":data.TRX_CC_HIST_CD} },
	             /* { "class" : "columnc all",         "data" : null, "render": function(data){
	            	 var str = "";
	            	 
	            	 if(data.TRX_CC_HIST_CD_NM != null) {
	            		 str = "<span style='color:red;'>" + data.TRX_CC_HIST_CD_NM + "</span>";	 
	            	 }
	            	 
	            	 return str;
	             } }, */
	             
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.APP_DT)} },
	             
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CC_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.CC_DT)} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ORD_NM==null?"":data.ORD_NM} },	
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.GOODS_NM==null?"":data.GOODS_NM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.GOODS_AMT==null?"":IONPay.Utils.fnAddComma(data.GOODS_AMT) + "원"} },
	             
	             { "class" : "columnc all", 			"data" : null, "render":function(data){
	               	var str = "";
	               	var checkBox = "";
	               	var hiddenCheckBox = "";
	               	
	               	var checkBoxVal = "";
	               	var hiddenCheckBoxVal = "";
	               	
	               	var checkBoxTid = "";
	               	var hiddenCheckBoxTid = "";
	               	
	               	checkBox = "<input type='checkbox' onclick='fnCheckBoxClick(this);' id='confirmChkProc"+data.RNUM+"' name='confirmChkProc' value='"+data.TID+"' />";
	               	hiddenCheckBox = "<input type='checkbox' onclick='fnCheckBoxClick(this);' id='confirmChkProc"+data.RNUM+"' name='confirmChkProc' value='"+data.TID+"' style='display:none' />";
	               	
	               	checkBoxVal	= "<input id='confirmChkProcVal"+data.RNUM+"' name='confirmChkProcVal' type='hidden' value='Y' />";
	               	hiddenCheckBoxVal = "<input id='confirmChkProcVal"+data.RNUM+"' name='confirmChkProcVal' type='hidden' value='N' />";
	               	
	               	checkBoxTid	= "<input id='confirmChkProcTid"+data.RNUM+"' name='confirmChkProcTid' type='hidden' value='"+data.TID+"' />";
	               	hiddenCheckBoxTid = "<input id='confirmChkProcTid"+data.RNUM+"' name='confirmChkProcTid' type='hidden' value='"+data.TID+"' />";
	               	
	               	
	               	if(data.TRX_CC_HIST_CD == '51') {	//취소상태
	               		str = checkBox
               			
   						+ checkBoxVal
   						+ checkBoxTid
   						+ "<input id='TRX_STAT_CD_VAL"+data.RNUM+"' name='TRX_STAT_CD_VAL' type='hidden' value='2' />"
               			+ "<input id='confirmChkedTf"+data.RNUM+"' name='confirmChkedTf' type='hidden' value='F' />";	
	               	}else if(data.TRX_APP_CD == "00" && 
	               			data.TRX_CC_HIST_CD != '51' && data.TRX_CC_HIST_CD != '67' && data.TRX_CC_HIST_CD != '69') {	//승인상태
	               		str = checkBox
							
   						+ checkBoxVal
   						+ checkBoxTid
   						+ "<input id='TRX_STAT_CD_VAL"+data.RNUM+"' name='TRX_STAT_CD_VAL' type='hidden' value='0' />"
   						+ "<input id='confirmChkedTf"+data.RNUM+"' name='confirmChkedTf' type='hidden' value='F' />";
   						
	               	}else {
	               		if(data.TRX_CC_HIST_CD != null && data.TRX_CC_HIST_CD != "") {
	               			
		            		str = hiddenCheckBox + data.TRX_CC_HIST_CD_NM + hiddenCheckBoxVal + hiddenCheckBoxTid
		            		+ "<input id='TRX_STAT_CD_VAL"+data.RNUM+"' name='TRX_STAT_CD_VAL' type='hidden' value='99' />"
		            		+ "<input id='confirmChkedTf"+data.RNUM+"' name='confirmChkedTf' type='hidden' value='F' />";
	               			
		            	}else {
		            		str = hiddenCheckBox + data.TRX_APP_CD_NM + hiddenCheckBoxVal + hiddenCheckBoxTid
		            		+ "<input id='TRX_STAT_CD_VAL"+data.RNUM+"' name='TRX_STAT_CD_VAL' type='hidden' value='99' />"
		            		+ "<input id='confirmChkedTf"+data.RNUM+"' name='confirmChkedTf' type='hidden' value='F' />";
		            		
		            	}
	               	}
	               	
	           		return str;
	           	
	               } }
	             
	             
	             
	            ]
		    }, true);


		} else {
			objCoMInfoInquiry.clearPipeline();
			objCoMInfoInquiry.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();
		////IONPay.Utils.fnHideSearchOptionArea();

		}
		else{
			var $objFrmData = $("#frmSearch").serializeObject();

	        arrParameter = $objFrmData;
	        arrParameter["EXCEL_TYPE"]                  = strType;
	        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
	        IONPay.Ajax.fnRequestExcel(arrParameter, "/baseInfoMgmt/settleReqMgmt/selectSettleReqListExcel.do");
	        //IONPay.Ajax.fnRequestExcel(arrParameter, "/paymentMgmt/card/selectCardTransInfoListExcel.do");
		}
}

function fnBlackListClearUpdate(tid, trxStatCd) {
	var clearReqChk = confirm("정산요청 하시겠습니까?");
	
	if(clearReqChk == true) {
		//arrParameter = $("#frmSubMallUpdateInfo").serializeObject();
		arrParameter["WORKER"] = $("#WORKER").val();
		arrParameter["TID"] = tid;
		arrParameter["TRX_STAT_CD"] = trxStatCd;
		
		strCallUrl   = "/baseInfoMgmt/settleReqMgmt/updateSettleReqStatus.do";
		//strCallUrl   = "/rmApproval/blackListMgmt/updateBlackListClear.do";
		strCallBack  = "fnClearUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}else {
		return;
	}
}

function fnClearUpdateRet(objJson){
	if (objJson.resultCode == 0) {
		IONPay.Msg.fnAlert("요청 완료되었습니다.");
        IONPay.Utils.fnJumpToPageTop();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
	
	$("#btnSearch").click();
}






//mid로 변환 후 다시 조회
function fnSerMID(mid){
	/* $("#frmSearch #searchFlg").select2("val", "1");
	$("#frmSearch #txtSearch").val(mid);
	strType="SEARCH"; */
	strType="SEARCH";
	fnInquiry(strType);
}
//모달 창 생성 후  tid 로  조회

function fnSerTID(tid){
	map.set("TID", tid);
	strModalID = "modalSerTid";
	arrParameter["tid"] = tid;
	arrParameter["USR_ID"] = $("#USR_ID").val();
	//strCallUrl  = "/paymentMgmt/card/selectSerTidInfo.do";
    strCallUrl   = "/paymentMgmt/payFailInquiry/selectSerTidFailInfo.do";
    strCallBack  = "fnSerTidRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    
  
}
function fnSerTidRet(objJson){
	$("#divTidList #state0").hide();
	$("#divTidList #state51").hide();
	$("#divTidList #div_partCList").hide();
	$("#divTidList #div4").hide();

	if(objJson.resultCode == 0 ){
		var str = "";
		if(objJson.tidInfo != null){
			$("#div_search").css("display", "none");
			$("#divTidList").css("display", "block");

			var emp = strWorker;
			var clientIp = "<%=request.getRemoteAddr( )%>";

			$("#divTidList input[name=emp]").val(emp);
			$("#divTidList input[name=canIP]").val(clientIp);
			$("#divTidList input[name=canUID]").val(emp);

			$("#divTidList input[name=canMID]").val(objJson.tidInfo.MID);
			$("#divTidList input[name=canTID]").val(map.get("TID"));
			$("#divTidList input[name=canAmt]").val(objJson.tidInfo.GOODS_AMT);
			//$("#divTidList input[name=rid]").val(objJson.tidInfo.REQ_NO);
			$("#divTidList input[name=ccDt]").val(objJson.tidInfo.CC_DT);
			$("#divTidList input[name=ccTm]").val(objJson.tidInfo.CC_TM);


			$("#tb_serTid #state0").show();

			var cseq = "-1";
			var str = "";
			if(objJson.tidDetailLst != null){
				$("#tb_serTid #div_partCList").show();
				for(var i=0; i<objJson.tidDetailLst.length;i++){
					cseq = objJson.tidDetailLst[i].CC_SEQ;

					str+="<tr>";
					if(i == 0 ){
						str+="<th style='text-align: center; border: 1px solid #ddd;background-color:#ecf0f2; '>원거래 TID</th>";
					}else{
						str+="<th style='text-align: center; border: 1px solid #ddd; background-color:#ecf0f2;'>부분취소 TID</th>";
					}
					str+="<td style='text-align: center; border: 1px solid #ddd; '><a href='#' onclick=fnSerTID(\'"+objJson.tidDetailLst[i].TID+"\');>"+objJson.tidDetailLst[i].TID+"</a></td>";
					if(i == 0 ){
						str+="<th style='text-align: center; border: 1px solid #ddd;background-color:#ecf0f2; '>원거래금액</th>";
					}else{
						str+="<th style='text-align: center; border: 1px solid #ddd; background-color:#ecf0f2;'>부분취소 후 잔액</th>";
					}
					str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+objJson.tidDetailLst[i].REMAIN_AMT+"</td>";
					str+="</tr>";
				}

				$("#div_partCList #thForCseq").html(str);
			}
			$("#divTidList input[name=cseq]").val(cseq);
			$("#divTidList input[name=remainOrg]").val(objJson.tidInfo.remainAmt);


			$("#div1 #pmNm").html(objJson.tidInfo.PM_NM);
			$("#div1 #tidVal").html(objJson.tidInfo.TID);
			$("#div1 #mid").html(objJson.tidInfo.MID);
			$("#div1 #gid").html(objJson.tidInfo.GID);
			$("#div1 #vid").html(objJson.tidInfo.VID);
			
			$("#div2 #APP_REQ_DNT").html(IONPay.Utils.fnStringToDatePickerFormat(objJson.tidInfo.APP_REQ_DNT));
			$("#div2 #APP_DNT").html(IONPay.Utils.fnStringToDatePickerFormat(objJson.tidInfo.APP_DNT));
			$("#div2 #GOODS_NM").html(objJson.tidInfo.GOODS_NM);
			$("#div2 #GOODS_AMT").html(IONPay.Utils.fnAddComma(objJson.tidInfo.GOODS_AMT));
			$("#div2 #GOODS_SPL_AMT").html(IONPay.Utils.fnAddComma(objJson.tidInfo.GOODS_SPL_AMT));
			$("#div2 #GOODS_VAT").html(IONPay.Utils.fnAddComma(objJson.tidInfo.GOODS_VAT));
			
			$("#div2 #UID").html(objJson.tidInfo.UID);
			$("#div2 #ORD_NM").html(objJson.tidInfo.ORD_NM);
			$("#div2 #RSLT_CD").html(objJson.tidInfo.RSLT_CD);
			$("#div2 #PM_MTHD_CD").html(objJson.tidInfo.PM_MTHD_CD);
			$("#div2 #PGSW_VER").html(objJson.tidInfo.PGSW_VER);
			$("#div2 #MBS_DVC_ID").html(objJson.tidInfo.MBS_DVC_ID);
			
			
			$("#div2 #MBS_SCK_ID").html(objJson.tidInfo.MBS_SCK_ID);
			$("#div2 #RSLT_SND_ST").html(objJson.tidInfo.RSLT_SND_ST);
			$("#div2 #RSLT_SND_DNT").html(objJson.tidInfo.RSLT_SND_DNT_FULL);
			$("#div2 #AUTO_CHRG_CD").html(objJson.tidInfo.AUTO_CHRG_CD);
			$("#div2 #PNT_ID").html(objJson.tidInfo.PNT_ID);
			
			$("#div2 #RE_SND_FLG").html(objJson.tidInfo.RE_SND_FLG);
			$("#div2 #SND_DNT").html(objJson.tidInfo.SND_DNT_FULL);
			$("#div2 #RCV_DNT").html(objJson.tidInfo.RCV_DNT_FULL);
			

		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnDecCardNo(tid){
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalPwChk #tid").val(tid);
	$("#modalPwChk").modal();
}
function captureReturnKey(e) {
	if(e.keyCode==13) return false;
}
function fnPwCheck(){
	strModalID = "modalPwChk";
	arrParameter = $("#frmPwChk").serializeObject();
	arrParameter["cont"] = "cardNoDec";
	arrParameter["worker"] = strWorker;

    strCallUrl   = "/paymentMgmt/card/selectPwChk.do";
    strCallBack  = "fnPwCheckRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnPwCheckRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data.resultCd == "success"){
// 			$("#modalPwChk #maskNo_0").css("display" , "none");
// 			$("#modalPwChk #unMaskNo_0").css("display" , "block");
			$("#div2 #maskNo_0").hide();
			$("#div2 #unMaskNo_0").show();
			$("#div2 #unMaskNo_0").html(objJson.data.data);
			$("#modalPwChk .close").click();

		}else{
			IONPay.Msg.fnAlertWithModal(objJson.data.resultMsg, "modalPwChk");
		}
	}else{
		IONPay.Msg.fnAlertWithModal("비밀번호 확인에 실패하였습니다" + objJson.resultMessage, "modalPwChk");
	}
}

function fnCancelTrans(){

	if($("#frmCardCC input[name=cseq]").val() == "-1" && $("#frmCardCC input[name=canFlag]").val() == "0"){
		IONPay.Msg.fnAlert("해당거래는 부분취소내역이 존재하므로 전체취소를 하실 수 없습니다.\n부분취소로 취소 해주시기 바랍니다.");
		$("#frmCardCC input[name=canFlag]").focus();
		return;
	}
	if($("#frmCardCC input[name=canGoods]").val() == "" || $("#frmCardCC input[name=canGoods]").val() <  0){
		IONPay.Msg.fnAlert("취소금액을 입력해주세요.");
		$("#frmCardCC input[name=canGoods]").focus();
		return;
	}
	if($("#frmCardCC input[name=remainOrg]").val() < $("#frmCardCC input[name=canGoods]").val()){
		IONPay.Msg.fnAlert("취소금액이 잔액보다 큽니다. 다시 입력해주세요.");
		$("#frmCardCC input[name=canGoods]").val("");
		$("#frmCardCC input[name=canGoods]").focus();
		return;
	}
	if($("#frmCardCC input[name=cseq]").val() == "-1" && $("#frmCardCC input[name=canFlag]").val() == "1"){
		if($("#frmCardCC input[name=remainOrg]").val() == $("#frmCardCC input[name=canGoods]").val()){
			IONPay.Msg.fnAlert("전체 금액에 대한 취소는 전체취소로 취소해주시기 바랍니다.");
			$("#frmCardCC input[name=canFlag]").focus();
			return;
		}
	}

	$("#frmCardCC input[name=canAmt]").val($("#frmCardCC input[name=canGoods]").val());
	$("#frmCardCC input[name=PartialCancelCode]").val($("#frmCardCC input[name=canFlag]").val());

	if($("#frmCardCC input[name=canNm]").val() == ""){
		IONPay.Msg.fnAlert("취소 작업자를 입력해주세요.");
		$("#frmCardCC input[name=canNm]").focus();
		return;
	}
	if($("#frmCardCC input[name=canMsg]").val() == ""){
		IONPay.Msg.fnAlert("취소 사유를 입력해주세요.");
		$("#frmCardCC input[name=canMsg]").focus();
		return;
	}

	if(confirm("강제 취소하시겠습니까?\n취소를 원하시면 확인 버튼을 클릭하십시오.") == false){
		
	}else {
		
	}

	/* if(confirm("강제 취소하시겠습니까?\n취소를 원하시면 확인 버튼을 클릭하십시오.") == false){
// 		return;
	}else{
		//결제취소 api ->common/cancel/payCancelProcess.jsp

		arrParameter = $("#frmCardCC").serializeObject();
		arrParameter = $("#frmSearch").serializeObject();
// 		arrParameter["fromdate"] = $("#frmSearch input[name=fromdate]").val();
// 		arrParameter["todate"] = $("#frmSearch input[name=todate]").val();
	    strCallUrl   = "/paymentMgmt/card/selectTransInfoTotalList.do";
	    strCallBack  = "fnSumInquiryRet";

	    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	} */
}
function fnRecTrans() {
	if($("#frmCardCC #recNm").val() == ""){
		IONPay.Msg.fnAlert("원복작업자를 입력해주세요");
		$("#frmCardCC #recNm").focus();
		return;
	}
	if($("#frmCardCC #recMsg").val() == ""){
		IONPay.Msg.fnAlert("원복사유를 입력해주세요");
		$("#frmCardCC #recMsg").focus();
		return;
	}

	if(confirm("후취소 원복하시겠습니까?\n원복하시려면 확인 버튼을 클릭하십시오.") == false){
		return;
	}else{
		//취소원복 api - > trans/ReCoverTrans.jsp



	}
  }
//APP_NO으로 모달 생성
function fnSerIssue(tid, appDt) {
		if( confirm("두가지 중 필요로 하는 것을 선택하세요(확인 : 거래확인서, 취소 : 소보법메일)") ) {
			// 거래확인서 출력 - > 서버에 쏘는 거 ????
// 			var	f	=	parent.formFrame.document.mainForm;
// 			var	status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,width=414,height=622";
// 			var trDoc = js_OpenWindow("about:blank", "popupIssue", 414, 622);
// 			//var trDoc = window.open("about:blank","popupIssue",status);
// 			f.target = "popupIssue";

// 			f.submit();
		} else {
			//소보법 메일 발송내역 조회
			arrParameter["tid"] = tid;
			arrParameter["pmCd"] = "01";
			arrParameter["appDt"] = appDt;
			arrParameter["strDate"] = map.get("strDate");
		    strCallUrl   = "/paymentMgmt/card/selectMailSendSearch.do";
		    strCallBack  = "fnMailSendSearchRet";

		    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
		}
	}
//소보법 메일 발송내역 조회
function fnMailSendSearch(){
	arrParameter = $("#frmSearch").serializeObject();
    strCallUrl   = "/paymentMgmt/card/selectMailSendSearch.do";
    strCallBack  = "fnMailSendSearchRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

//각각 버튼 누를때 발송, 재발송
function fnMailSendSearchRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.dataList != null){
			$("#div_mailReSend").css("display", "block");
			$("#div_searchResult").hide();
			$("#tbMailReSend").show();
			$("#tbMailReSendInfo").hide();

			var str = "";
			for(var i=0; i<objJson.dataList.length;i++){
				str += "<tr>";
				str += "<input type='hidden' name='Seq_"+(i+1)+"' value="+objJson.dataList[i].SEQ+">";
				str += "<input type='hidden' name='TableNm_"+(i+1)+"' value="+objJson.dataList[i].TABLE_NM+">";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].SEQ+"</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].SND_DT +"  " +objJson.dataList[i].SND_TM+ "</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].GOODS_NM+"</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].ORD_NM+"</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'><input type='text' name='Email_"+(i+1)+"' value='"+objJson.dataList[i].ORD_EMAIL+"' maxlength='60'></td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'><button type='button' onclick='sendMail('"+(i+1)+"');'>재발송</button></td>";
				str += "</tr>";
			}
			$("#tbody_reMailList").html(str);
		}else{
			if(objJson.data != null){
				$("#div_mailReSend").css("display", "block");
				$("#div_searchResult").hide();
				$("#tbMailReSend").hide();
				$("#tbMailReSendInfo").show();

				$("#tbMailReSendInfo #goodsNm").html(objJson.data.GOODS_NM);
				$("#tbMailReSendInfo #ordNm").html(objJson.data.ORD_NM);
				$("#tbMailReSendInfo #stateNm").html(objJson.data.stateNm==null?"":objJson.data.stateNm);
				$("#tbMailReSendInfo input[name=tid]").val(objJson.data.TID);
				$("#tbMailReSendInfo input[name=appDt]").val(objJson.data.APP_DT);
				$("#tbMailReSendInfo input[name=appTm]").val(objJson.data.APP_TM);
				$("#tbMailReSendInfo input[name=ccDt]").val(objJson.data.CC_DT);
				$("#tbMailReSendInfo input[name=ccTm]").val(objJson.data.CC_TM);
				$("#tbMailReSendInfo input[name=stateCd]").val(objJson.data.TRX_ST_CD);
				$("#tbMailReSendInfo input[name=pmCd]").val(objJson.data.PM_CD);
				///$("#tbMailReSendInfo input[name=spmCd]").val(objJson.data.SPM_CD);
				$("#tbMailReSendInfo input[name=amt]").val(objJson.data.GOODS_AMT);
				$("#tbMailReSendInfo input[name=goodsNm]").val(objJson.data.GOODS_NM);
				$("#tbMailReSendInfo input[name=ordNm]").val(objJson.data.ORD_NM);
				$("#tbMailReSendInfo input[name=ordTel]").val(objJson.data.ORD_TEL);
				$("#tbMailReSendInfo input[name=appNo]").val(objJson.data.APP_NO);
				$("#tbMailReSendInfo input[name=instmntMon]").val(objJson.data.QUOTA_MON);
				$("#tbMailReSendInfo input[name=noInterestCl]").val(objJson.data.NOINT_FLG);
				$("#tbMailReSendInfo input[name=moid]").val(objJson.data.ORD_NO);
				$("#tbMailReSendInfo input[name=cpCd]").val(objJson.data.CP_CD);
				$("#tbMailReSendInfo input[name=payNo]").val(objJson.data.PAY_NO);
				$("#tbMailReSendInfo input[name=mid]").val(objJson.data.MID);
			}
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnSelectCardInfoTotAmt(){
	arrParameter = $("#frmSearch").serializeObject();
    //strCallUrl   = "/paymentMgmt/card/selectCardTotalAmt.do";
    strCallUrl   = "/paymentMgmt/payInquiry/selectCardTotalAmt.do";
    strCallBack  = "fnSelectCardInfoTotAmtRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

//메일 재발송 api
function sendMail(index){

}
//신규메일 발송 api
function sendNewMail(){

}
function listShow(){
	$("#div_searchResult").show();
	$("#tbMailReSendInfo").hide();
}
function fnSelectCardInfoTotAmtRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#div_searchSumResult").css("display", "block");

		$("#tbCardTransTotalAmt #rAppCnt").html(objJson.data.REALAPPCNT==null?"0":objJson.data.REALAPPCNT);
		$("#tbCardTransTotalAmt #rAppAmt").html(objJson.data.REALAPPAMT==null?"0":objJson.data.REALAPPAMT);
		/* $("#tbCardTransTotalAmt #tAppCnt").html(objJson.data.TESTAPPCNT==null?"0":objJson.data.TESTAPPCNT);
		$("#tbCardTransTotalAmt #tAppAmt").html(objJson.data.TESTAPPAMT==null?"0":objJson.data.TESTAPPAMT); */
		$("#tbCardTransTotalAmt #totAppCnt").html(objJson.data.TOT_APP_CNT==null?"0":objJson.data.TOT_APP_CNT);
		$("#tbCardTransTotalAmt #totAppAmt").html(objJson.data.TOT_APP_AMT==null?"0":objJson.data.TOT_APP_AMT);

		$("#tbCardTransTotalAmt #rCanCnt").html(objJson.data.REALCCCNT==null?"0":objJson.data.REALCCCNT);
		$("#tbCardTransTotalAmt #rCanAmt").html(objJson.data.REALCCAMT==null?"0":objJson.data.REALCCAMT);
		/* $("#tbCardTransTotalAmt #tCanCnt").html(objJson.data.TESTCCCNT==null?"0":objJson.data.TESTCCCNT);
		$("#tbCardTransTotalAmt #tCanAmt").html(objJson.data.TESTCCAMT==null?"0":objJson.data.TESTCCAMT); */
		$("#tbCardTransTotalAmt #totCanCnt").html(objJson.data.TOT_CC_CNT==null?"0":objJson.data.TOT_CC_CNT);
		$("#tbCardTransTotalAmt #totCanAmt").html(objJson.data.TOT_CC_AMT==null?"0":objJson.data.TOT_CC_AMT);
		
		
		//환불
		/* $("#tbCardTransTotalAmt #rRefundCnt").html(objJson.data.REALRFCNT==null?"0":objJson.data.REALRFCNT);
		$("#tbCardTransTotalAmt #rRefundAmt").html(objJson.data.REALRFAMT==null?"0":objJson.data.REALRFAMT);
		$("#tbCardTransTotalAmt #tRefundCnt").html(objJson.data.TESTRFCNT==null?"0":objJson.data.TESTRFCNT);
		$("#tbCardTransTotalAmt #tRefundAmt").html(objJson.data.TESTRFAMT==null?"0":objJson.data.TESTRFAMT);
		$("#tbCardTransTotalAmt #totRefundCnt").html(objJson.data.TOT_RF_CNT==null?"0":objJson.data.TOT_RF_CNT);
		$("#tbCardTransTotalAmt #totRefundAmt").html(objJson.data.TOT_RF_AMT==null?"0":objJson.data.TOT_RF_AMT); */

		$("#tbCardTransTotalAmt #rTotCnt").html(objJson.data.REAL_TOT_CNT==null?"0":objJson.data.REAL_TOT_CNT);
		$("#tbCardTransTotalAmt #rTotAmt").html(objJson.data.REAL_TOT_AMT==null?"0":objJson.data.REAL_TOT_AMT);
		/* $("#tbCardTransTotalAmt #tTotCnt").html(objJson.data.TEST_TOT_CNT==null?"0":objJson.data.TEST_TOT_CNT);
		$("#tbCardTransTotalAmt #tTotAmt").html(objJson.data.TEST_TOT_AMT==null?"0":objJson.data.TEST_TOT_AMT); */
		$("#tbCardTransTotalAmt #totTotCnt").html(objJson.data.TOT_TOT_CNT==null?"0":objJson.data.TOT_TOT_CNT);
		$("#tbCardTransTotalAmt #totTotAmt").html(objJson.data.TOT_TOT_AMT==null?"0":objJson.data.TOT_TOT_AMT);

	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#tbCardAmtInfo").hide();
	}
}


function fnConfirmChkChange(obj){
	var chkProc = $("#div_searchResult input[name=confirmChkProc]");
	var chkProcVal = $("#div_searchResult input[name=confirmChkProcVal]");
	var confirmChkedTf = $("#div_searchResult input[name=confirmChkedTf]");
	
	if(obj.checked) {
	    for(i = 0; i < chkProc.length; i++) {
	    	//if(!chkProc[i].disabled) {
	    		
    		if(chkProcVal.eq(i).val() == 'Y') {
    			chkProc[i].checked = true;
    			confirmChkedTf.eq(i).val("T");
    		}else {
    			chkProc[i].checked = false;
    			confirmChkedTf.eq(i).val("F");
    		}
    		
	    	//}
	    }
	  } else { 
	    for(i = 0; i < chkProc.length; i++) {
	      chkProc[i].checked = false;
	      confirmChkedTf.eq(i).val("F");
	    }	  
	  }
}

function fnCheckBoxClick(obj) {
	var chkProc = $("#div_searchResult input[name=confirmChkProc]");
	var checkBoxClickIndex = $("input[name=confirmChkProc]").index(obj);
	var confirmChkedTf = $("#div_searchResult input[name=confirmChkedTf]");
	
	//alert(checkBoxClickIndex + " : " + confirmChkedTf.eq(checkBoxClickIndex).val());
	
	if(confirmChkedTf.eq(checkBoxClickIndex).val() == "T") {
		chkProc[checkBoxClickIndex].checked = false;
		confirmChkedTf.eq(checkBoxClickIndex).val("F");
	}else {
		chkProc[checkBoxClickIndex].checked = true;
		confirmChkedTf.eq(checkBoxClickIndex).val("T");
	}
	
	//alert(checkBoxClickIndex + " :: " + confirmChkedTf.eq(checkBoxClickIndex).val());
}

function fnSumInquiry(){

}
function fnSumInquiryRet(objJson){

}
function fnSumInquiry1() {

}
</script>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <div class="content">
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><c:out value="${MENU_SUBMENU_TITLE }" /></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                
                <input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
                <input type="hidden" id="USR_ID" value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>" />
                
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0058'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <!-- <div class="row form-row" >
                                        <div class="col-md-3" style="width: 200px">
                                            <select id="searchFlg" name="searchFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" id="txtSearch" name="txtSearch" class="form-control" readonly>
                                        </div>
                                    
                                        <div class="col-md-3" style="width: 200px">
                                            <select id="searchPayFlg" name="searchPayFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" id="txtPaySearch" name="txtPaySearch" class="form-control" readonly>
                                        </div>
                                    </div> -->
                                    
                                    <!-- <div class="row form-row" >
                                        <div class="col-md-3" style="width: 200px">
                                            <select id="idChk" name="idChk" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" id="txtIdSearch" name="txtIdSearch" class="form-control" readonly>
                                        </div>
                                    
                                        <div class="col-md-3" style="width: 200px">
                                            <select id="typeChk" name="typeChk" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" id="txtTypeSearch" name="txtTypeSearch" class="form-control" readonly>
                                        </div>
                                    </div> -->
                                    
                                    
		                             <div class="row form-row" >
				                       <div class="col-md-2">
				                       		<label class="form-label">&nbsp;</label>
				                           	<select id="dateChk" name="dateChk" class="select2 form-control">
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
				                          <div id="divSearchDateType4" class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>
				                              <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
				                              <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
				                              <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
				                              <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
				                          </div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
				                                  <%-- <button type="button" id="btnSumSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0151'/></button> --%>
				                              </div>
				                          </div>
		                         	</div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END VIEW OPTION AREA -->
               



                <!-- BEGIN SEARCH LIST AREA -->
                <div id="div_search" class="row" >
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                            
                            
                            	<form id="frmSearchList" name="frmSearchList">
                            		
                            		
	                                <div id="div_searchResult"  style="display:none;">
	                                    <div class="grid simple ">
	                                        <div class="grid-body " id="">
		                                        <table style="width: 100%">
		                                        	<tr align="right">
		                                        		<td>
		                                        			<button type="button" id="btnAllReqest" class="btn btn-info btn-sm btn-cons">정산요청</button>
		                                        		</td>
		                                        	</tr>
		                                        </table>
	                                        
	                                            <%-- <table id="tbCardAmtInfo" class="table" style="width:50%">
	                                                <thead>
	                                                 <tr>
	                                                     <th ><spring:message code='IMS_BIM_BM_0152'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0153'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0154'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0155'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0156'/></th>
				                                         <th ><spring:message code='IMS_BIM_BM_0157'/></th>
	                                                 </tr>
	                                                </thead>
	                                                <tr style="text-align: right;;">
	                                                	<td id="appCnt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
	                                                	<td id="appAmt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
	                                                	<td id="canCnt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
	                                                	<td id="canAmt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
	                                                	<td id="cntSum" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
	                                                	<td id="amtSum" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
	                                                </tr>
	                                            </table> --%>
	                                            
	                                            <table id="tbCardTransList" class="table" style="width:100%">
	                                            	<input type='checkbox' onclick='fnCheckBoxClick(this);' id='confirmChkProcFirst' name='confirmChkProc' value='none' style='display:none' />
													<input id='confirmChkProcValFirst' name='confirmChkProcVal' type='hidden' value='N' />
													<input id='confirmChkProcTidFirst' name='confirmChkProcTid' type='hidden' value='none' />
													<input id='TRX_STAT_CD_VALFirst' name='TRX_STAT_CD_VAL' type='hidden' value='99' />
													<input id='confirmChkedTfFirst' name='confirmChkedTf' type='hidden' value='F' />
	                                            
	                                            	<thead>
	                                            		<tr>
	                                                 	 <th >No</th>
	                                                     <th >TID</th>
	                                                     <th >MID</th>
	                                                     <th >GID</th>
				                                         <th >VID</th>
				                                         
	                                                     <th >지불수단</th>
	                                                     <th >구분</th>
	                                                     <!-- <th >승인상태</th>
	                                                     <th >취소상태</th> -->
	                                                     <th >승인일자</th>
	                                                     
	                                                     <th >취소일자</th>
	                                                     <th >구매자</th>
	                                                     <th >상품명</th>
	                                                     <th >결제금액</th>
	                                                     <th >
	                                                     	<input id="confirmChkProcAll"  name="confirmChkProcAll"   type="checkbox"  onclick="fnConfirmChkChange(this);" >
	                                                     	<!-- <input id='confirmChkProcVal"+data.RNUM+"' name='confirmChkProcVal' type='text' value='N' /> -->
	                                                     	관리
	                                                     </th>
	                                                     
	                                                 </tr>
	                                            	</thead>
	                                            </table>
	                                            <div class="col-md-9"></div>
	                                        </div>
	                                    </div>
	                                </div>
                                
                                </form>
                                
                                
                                
                                
                                <div id="div_searchSumResult" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbCardTransTotalAmt" class="table" style="width:100%">
                                                <thead>
                                                 <tr>
                                                     <th><spring:message code='IMS_BIM_BM_0167'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0168'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0169'/></th>
                                                     <%-- <th><spring:message code='IMS_BIM_BM_0170'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0171'/></th> --%>
                                                     <th><spring:message code='IMS_BIM_BM_0172'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0173'/></th>
                                                 </tr>
                                                </thead>
                                                <tr style="text-align: center;">
                                                	<td rowspan="3" id="date"></td>
                                                	<td><spring:message code='IMS_BIM_BM_0174'/></td><!-- 승인 -->
                                                	<td id="rAppCnt"></td>
                                                	<td id="rAppAmt"></td>
                                                	<!-- <td id="tAppCnt"></td>
                                                	<td id="tAppAmt"></td> -->
                                                	<td id="totAppCnt"></td>
                                                	<td id="totAppAmt"></td>
                                                </tr>
                                                <tr style="text-align: center;">
                                                	<td><spring:message code='IMS_BIM_BM_0175'/></td><!-- 취소  -->
                                                	<td id="rCanCnt"></td>
                                                	<td id="rCanAmt"></td>
                                                	<!-- <td id="tCanCnt"></td>
                                                	<td id="tCanAmt"></td> -->
                                                	<td id="totCanCnt"></td>
                                                	<td id="totCanAmt"></td>
                                                </tr>
                                                
                                                <!-- 환불  -->
                                                <%-- <tr style="text-align: center;">
                                                	<td><spring:message code='IMS_BIM_BM_0185'/></td>
                                                	<td id="rRefundCnt"></td>
                                                	<td id="rRefundAmt"></td>
                                                	<td id="tRefundCnt"></td>
                                                	<td id="tRefundAmt"></td>
                                                	<td id="totRefundCnt"></td>
                                                	<td id="totRefundAmt"></td>
                                                </tr> --%>
                                                
                                                <tr style="text-align: center;">
                                                	<td><spring:message code='IMS_BIM_BM_0176'/></td><!-- 합계 -->
                                                	<td id="rTotCnt"></td>
                                                	<td id="rTotAmt"></td>
                                                	<!-- <td id="tTotCnt"></td>
                                                	<td id="tTotAmt"></td> -->
                                                	<td id="totTotCnt"></td>
                                                	<td id="totTotAmt"></td>
                                                </tr>
                                            </table>
                                            <%-- <table id="tbCardTransTotalList" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_PV_MP_0002'/></th>
                                                     <th ><spring:message code='IMS_BIM_CCS_0034'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0168'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0169'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0170'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0171'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_cardTotList"></tbody>
                                            </table> --%>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>
                                </div>
                                <form id="frmMailReSend">
                                <div id="div_mailReSend" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbMailReSend" class="table" style="width:100%">
                                                <thead>
                                                	<tr >
												        <th align='center'>NO</th>
												        <th align='center'>발송일시</th>
												        <th align='center'>상품명</th>
												        <th align='center'>구매자</th>
												        <th align='center'>E-Mail</th>
												        <th align='center'>발송</th>
											        </tr>
                                                 </thead>
                                                 <tbody id="tbody_reMailList"></tbody>
                                           	</table>
                                            <table id="tbMailReSendInfo" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <td align='center' style="border:1px solid #c2c2c2; background-color:#ecf0f2;">1</td>
											         <td align='center'  style="border:1px solid #c2c2c2; background-color:#ecf0f2;"></td>
											         <td align='left' id="goodsNm"  style="border:1px solid #c2c2c2; background-color:#ecf0f2;">&nbsp;</td>
											         <td align='left' id="ordNm" style="border:1px solid #c2c2c2; background-color:#ecf0f2;">&nbsp;</td>
											         <!-- <td align='center' id="stateNm"></td> -->
											         <td align='left' id="ordEmail" style="border:1px solid #c2c2c2; background-color:#ecf0f2;">&nbsp;&nbsp;
											         	<input type='text' name='ordEmail'  class="form-control" maxlength='60' ">
										         	 </td>
											         <td align='center'  style="border:1px solid #c2c2c2; background-color:#ecf0f2;">
											         	<button type='button' name='' onclick="sendNewMail();" class="btn btn-success btn-cons">발송 </button>
										         	 </td>
                                                 </tr>
                                            	</thead>
                                            	<input type='hidden' name='tid'  >
										        <input type='hidden' name='appDt' >
										        <input type='hidden' name='appTm' >
										        <input type='hidden' name='ccDt' >
										        <input type='hidden' name='ccTm' >
										        <input type='hidden' name='stateCd' >
										        <input type='hidden' name='status' value='0'>
										        <input type='hidden' name='pmCd' >
										        <input type='hidden' name='spmCd' >
										        <input type='hidden' name='amt' >
										        <input type='hidden' name='goodsNm' >
										        <input type='hidden' name='ordNm' >
										  	    <input type='hidden' name=ordTel >
										        <input type='hidden' name='appNo'>
										        <input type='hidden' name='instmntMon' >
										        <input type='hidden' name='nonInterestCl' >
										        <input type='hidden' name='moid' >
										        <input type='hidden' name='cpCd' >
										        <input type='hidden' name='payNo' >
										        <input type='hidden' name='mid' >
										        <input type='hidden' name='templateId' >
                                            </table>
                                            <table width='800' border='0' cellspacing='0' cellpadding='0'>
												<tr height='20'><td>&nbsp;</td></tr>
												<tr height='17'>
													<td align='right'>
														<button type='button' name='' class="btn btn-success btn-cons" onclick="listShow();">목록</button>
													</td>
												</tr>
												<tr height='20'><td>&nbsp;</td></tr>
											</table>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>
                                </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END SEARCH LIST AREA -->
                </div></div>
            </div>
            <!-- END PAGE -->
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
