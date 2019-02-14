<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<style>
.form-inline .form-control{
    display: inline-block;
    width: 100%;
    vertical-align: middle;
}
.table > thead > tr > th, .table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td {
    padding: 0;
}
</style>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objListInquriy;

$(document).ready(function(){
    fnSetDDLB();
	fnInitEvent();
});

function fnInitEvent() {
	$("#div_search").hide();
	$("#div_payAmtDetail").hide();
	$("#div_carryAmtDetail").hide();
	
	var year = getToDate("Y");
	var month = getToDate("M");
	$("#frmSearch #year").val(year).attr("selected", "selected");
	$("#frmSearch #mon").val(month).attr("selected", "selected");
	
    $("#btnSearch").on("click", function() {
    	if($("#vid").val().length < 10){
    		IONPay.Msg.fnAlert('조회 ID를 입력해주세요');
    		$("#vid").focus();
    		return;
    	}
    	$("#div_search").show(200);
    	fnListInquriy("SEARCH");
    });
    $("#btnExcel").on("click", function() {
    	fnListInquriy("EXCEL");
    });
}
function fnSetDDLB(){
	$("select[name=year]").html("<c:out value='${YEAR}' escapeXml='false' />");
	$("select[name=mon]").html("<c:out value='${MONTH}' escapeXml='false' />");
	$("select[name=selType]").html("<c:out value='${TYPE}' escapeXml='false' />");
}
function fnConfirmCl(){
	if($("#frmSearch #selType").val() == "0"){
		$("#frmSearch #divYear").css("display","none");
		$("#frmSearch #divMon").css("display","none");
	}else{
		$("#frmSearch #divYear").css("display","block");
		$("#frmSearch #divMon").css("display","block");
	}
}
/*
 * 날짜포맷에 맞는지 검사
 */
function isDateFormat(d) {
    var df = /[0-9]{4}\/[0-9]{2}\/[0-9]{2}/;
    return d.match(df);
}

/*
 * 윤년여부 검사
 */
function isLeaf(year) {
    var leaf = false;

    if(year % 4 == 0) {
        leaf = true;

        if(year % 100 == 0) {
            leaf = false;
        }

        if(year % 400 == 0) {
            leaf = true;
        }
    }

    return leaf;
}

/*
 * 날짜가 유효한지 검사
 */
function isValidDate(d) {
    // 포맷에 안맞으면 false리턴
    if(!isDateFormat(d)) {
        return false;
    }

    var month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    var dateToken = d.split('/');
    var year = Number(dateToken[0]);
    var month = Number(dateToken[1]);
    var day = Number(dateToken[2]);
    
    // 날짜가 0이면 false
    if(day == 0) {
        return false;
    }

    var isValid = false;

    // 윤년일때
    if(isLeaf(year)) {
        if(month == 2) {
            if(day <= month_day[month-1] + 1) {
                isValid = true;
            }
        } else {
            if(day <= month_day[month-1]) {
                isValid = true;
            }
        }
    } else {
        if(day <= month_day[month-1]) {
            isValid = true;
        }
    }

    return isValid;
}

function fnConfirmChkChange(obj){
	var chkProc = $("#div_searchResult input[name=confirmChkProc]")
	
	if(obj.checked) { 
	    for(i = 0; i < chkProc.length; i++) {
	    	if(!chkProc[i].disabled) chkProc[i].checked = true;
	    }
	  } else { 
	    for(i = 0; i < chkProc.length; i++) {
	      chkProc[i].checked = false;
	    }	  
	  }
}
function fnCarryChkChange(obj){
	var chkProc = $("#div_searchResult input[name=carryChkProc]")
	if(obj.checked) { 
	    for(i = 0; i < chkProc.length; i++) {
	    	if(!chkProc[i].disabled) chkProc[i].checked = true;
	    }
	  } else { 
	    for(i = 0; i < chkProc.length; i++) {
	      chkProc[i].checked = false;
	    }	  
	  }
}
function fnConfirmStmt(){
	if(!confirm("확정하시겠습니까?")){
		return;
	}
	var toDay = fnToDay();
	var chkProc = $("#div_searchResult input[name=confirmChkProc]")
	var cnt = 0;
    var taxCnt1 = 0;
    var taxCnt2 = 0;
    var stmtCnt = 0;
    
    if(chkProc.length != null && chkProc.length != undefined && chkProc.length > 0) {
        for(i = 0; i < chkProc.length; i++) {
            if(chkProc[i].checked){
            	cnt++;
            	
            	var chkVal = chkProc[i].value;
            	var taxDt = $("input[name=taxDt_" + chkVal.substr(19,chkVal.length-19)+"]");
            	var stmtDt = $("input[name=stmtDt_" + chkVal.substr(19,chkVal.length-19)+"]");
            	
            	if(taxDt.val() == '') 				taxCnt1++;
            	else if(!isValidDate(taxDt.val()))	taxCnt2++;
            	
            	if(toDay > stmtDt.val()) stmtCnt++;
            }
        }
    } else {
    	if(chkProc.checked){
    		cnt++;
    		
    		var chkVal = chkProc.value;
    		var taxDt = $("input[name=taxDt_" + chkVal.substr(19,chkVal.length-19)+"]");
        	var stmtDt = $("input[name=stmtDt_" + chkVal.substr(19,chkVal.length-19)+"]");

        	if(taxDt.val() == '') 				taxCnt1++;
        	else if(!isValidDate(taxDt.val()))	taxCnt2++;
        	
        	if(toDay > stmtDt.value) stmtCnt++;
    	}
    }

    if(cnt < 1) {
      IONPay.Msg.fnAlert("선택된 항목이 없습니다. 최소 하나 이상을 선택 후 처리해주세요.");
      return;
    }
    
    if(taxCnt1 > 0) {
    	IONPay.Msg.fnAlert("계산서 발행일을 입력해 주세요.");
		return;
    }
	
	if(taxCnt2 > 0) {
		IONPay.Msg.fnAlert("계산서 발행일이 유효한 날짜가 아닙니다.");
		return;
    }
	
	if(stmtCnt > 0) {
		IONPay.Msg.fnAlert('확정처리는 지급일 이후에는 불가능합니다. 이후 처리건은 개발팀에 문의하세요.');
	    return;
    }
	arrParameter = $("#frmStmtSave").serializeObject();
	arrParameter["saveType"] = "0";
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/updateConfStmtSave.do";
	strCallBack  = "fnConfirmCcStmtRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnCarryStmt(){
	if(!confirm("이월 하시겠습니까?")) {
		return;
	}
	var toDay = fnToDay();
	var chkProc = $("#div_searchResult input[name=carryChkProc]")
    var cnt = 0;
    var stmtCnt = 0;
    
    if(chkProc.length != null && chkProc.length != undefined && chkProc.length > 0) {
        for(i = 0; i < chkProc.length; i++) {
            if(chkProc[i].checked){
            	cnt++;
            	
            	var chkVal = chkProc[i].value;
            	var stmtDt = $("input[name=stmtDt_" + chkVal.substr(19,chkVal.length-19)+"]");
            	
            	if(toDay > stmtDt.val()) stmtCnt++;
            }
        }
    } else {
    	if(chkProc.checked){
    		cnt++;
    		
    		var chkVal = chkProc.value;
        	var stmtDt = $("input[name=stmtDt_" + chkVal.substr(19,chkVal.length-19)+"]");
    		
    		if(toDay > stmtDt.val()) stmtCnt++;
    	}
    }
    
    if(cnt < 1) {
	      IONPay.Msg.fnAlert("선택된 항목이 없습니다. 최소 하나 이상을 선택 후 처리해주세요.");
	      return;
	}
    
    if(stmtCnt > 0) {
		IONPay.Msg.fnAlert('이월처리는 지급일 이후에는 불가능합니다. 이후 처리건은 개발팀에 문의하세요.');
	    return;
    }
    arrParameter = $("#frmStmtSave").serializeObject();
	arrParameter["saveType"] = "2";
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/updateConfStmtSave.do";
	strCallBack  = "fnConfirmCcStmtRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnListInquriy(strType){
	if(strType == "SEARCH"){
	   	if (typeof objListInquriy == "undefined") {
	   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
	               url: "/calcuMgmt/agencyStmtMgmt/selectAgentStmtConfirmList.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM==null?"":data.RNUM} },
	                    { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToMonthDateFormat(data.TRAN_DT) + "<input type='hidden' name='stmtDt_"+data.RNUM+"' value=\""+data.STMT_DT+"\">"} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VGRP_NM==null?"":data.VGRP_NM} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VID==null?"":data.VID} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REP_NM==null?"":data.REP_NM} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TOT_AMT==null?"":IONPay.Utils.fnAddComma(data.TOT_AMT)} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_AMT==null?"":IONPay.Utils.fnAddComma(data.CARD_AMT)} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.APP_AMT==null?"":IONPay.Utils.fnAddComma(data.APP_AMT)} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VAPP_AMT==null?"":IONPay.Utils.fnAddComma(data.VAPP_AMT)} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.PHONE_AMT==null?"":IONPay.Utils.fnAddComma(data.PHONE_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.ORG_FEE==null?"":IONPay.Utils.fnAddComma(data.ORG_FEE)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.SALES_ORG_FEE==null?"":IONPay.Utils.fnAddComma(data.SALES_ORG_FEE)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.FEE==null?"":IONPay.Utils.fnAddComma(data.FEE)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.VAT==null?"":IONPay.Utils.fnAddComma(data.VAT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.PAY_AMT > 0 ?"<a href='#' onclick='fnViewPayAmtDetail(\""+data.VID+"\",\""+data.TRAN_DT+"\");'>"+data.PAY_AMT+"</a>":data.PAY_AMT} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.PAY_VAT==null?"":IONPay.Utils.fnAddComma(data.PAY_VAT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_AMT==null?"":IONPay.Utils.fnAddComma(data.RESR_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_CC_AMT==null?"":IONPay.Utils.fnAddComma(data.RESR_CC_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.EXTRA_AMT==null?"":IONPay.Utils.fnAddComma(data.EXTRA_AMT)} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_FLAT_CNT==null?"":data.CARD_FLAT_CNT} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_FLAT_FEE==null?"":data.CARD_FLAT_FEE} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.DPST_AMT==null?"":IONPay.Utils.fnAddComma(data.DPST_AMT)} },
					    { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARRY_DPST_AMT > 0?"<a href='#' onclick='fnViewCarryDetail(\""+data.VID+"\",\""+data.ST_TYPE+"\",\""+data.CONF1_TM+"\",\""+data.CARRY_CL+"\",\""+data.CARRY_DT+"\");'>"+data.CARRY_DPST_AMT+"</a>":IONPay.Utils.fnAddComma(data.CARRY_DPST_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.TOT_AMT==null?"":IONPay.Utils.fnAddComma(data.TOT_AMT)} },
						{ "class" : "columnc all", 			"data" : null, "render":
							function(data){
								if(data.ST_TYPE != "0"){
									return data.CONFIRM_DT + (data.CONFIRM_MODIFY_YN == "0"?"<button type='button' onclick='fnConfirmCcStmt(\""+data.VID+"\", \""+data.STMT_DT+"\", \""+data.CARRY_DT+"\");' class='btn btn-primary btn-cons' >확정취소</button>":""); 
								}else{
									var str = "";
									if(data.CARRY_CL == "0"){
										str += "<div class='checkbox check-success'  >";
										str += "<input type='checkbox' id='confirmChkProc"+data.RNUM+"' name='confirmChkProc' value='"+data.ST_TYPE+""+data.STMT_DT+""+data.VID+""+data.RNUM+"' >";
										str += "<label for='confirmChkProc"+data.RNUM+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'></label>";
										str += "</div>";
									}else{
										str += "";
									}
									return str;
								}
							}
						},
						{ "class" : "columnc all", 			"data" : null, "render":
							function(data){
								if(data.ST_TYPE != "0"){
									return data.CONFIRM_DT + (data.CONFIRM_MODIFY_YN == "0"?"<button type='button' onclick='fnConfirmCcStmt(\""+data.VID+"\", \""+data.STMT_DT+"\", \""+data.CARRY_DT+"\");' class='btn btn-primary btn-cons' >확정취소</button>":""); 
								}else{
									var str = "";
									if(data.CARRY_CL == "0"){
										str += "<div class='checkbox check-success' >";
										str += "<input type='checkbox' id='carryChkProc"+data.RNUM+"' name='carryChkProc' value='"+data.CARRY_CL+""+data.STMT_DT+""+data.VID+""+data.RNUM+"' >";
										str += "<label for='carryChkProc"+data.RNUM+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'></label>";
										str += "</div>";
									}else{
										str += data.CARRY_DT;
									}
									return str;
								}
							}
						},
						{ "class" : "columnc all", 			"data" : null, "render":
							function(data){
								if(data.ST_TYPE == "0" && data.CARRY_CL == "0"){
									return "<input type='text'  class='form-control' name='taxDt_"+data.RNUM+"' onkeyup='fnReplaceDate(this)' value='"+data.TAX_DT+"'  >"; 
								}else if(data.ST_TYPE != "0"){
									return data.TAX_DT;
								}else{
									return "";
								}
							}
						}
	               ]
	       }, true);
	    } else {
	       objListInquriy.clearPipeline();
	       objListInquriy.ajax.reload();
	    }
	   	$("#div_payAmtDetail").hide();
		$("#div_carryAmtDetail").hide();
		IONPay.Utils.fnShowSearchArea();
	    IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/agencyStmtMgmt/selectAgentStmtConfirmListExcel.do");
	}
}
function fnConfirmCcStmt(vid, stmtDt, confDt){
	//확정 취소 
	if(!confirm("취소하시겠습니까?")){
		 return;
	}
	var toDay = fnToDay();
	if(toDay > stmtDt){
		IONPay.Msg.fnAlert('취소처리는 지급일 이후에는 불가능합니다. 이후 처리건은 개발팀에 문의하세요.');
	    //return;
	}
	arrParameter["vid"] = vid;
	arrParameter["stmtDt"] = stmtDt;
	arrParameter["confDt"] = confDt;
	arrParameter["saveType"] = "1";
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/updateConfStmtSave.do";
	strCallBack  = "fnConfirmCcStmtRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnConfirmCcStmtRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage);
		window.location.reload();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnViewPayAmtDetail(vid, tranDt){
	//pay_amt > 0
	//등록비 배분 상세내역 조회 
	arrParameter["vid"] = vid;
	arrParameter["trDt"] = tranDt;
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/selectAgentCoPayAmtDetail.do";
	strCallBack  = "fnViewPayAmtDetailRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnViewPayAmtDetailRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#div_searchResult").hide(200);
		$("#div_payAmtDetail").show(200);
		$("#div_carryAmtDetail").hide(200);
		var str = "";
		
		if(objJson.data.length != 0 ){
			for(var i=0; i<objJson.data.length; i++){
				str += "<tr style='text-align: center; '>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RNUM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PAY_CD_NM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].ID+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].CO_NM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].REG_DT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PAY_DT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PAY_AMT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RSHARE_RATE+"%</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RPAY_AMT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RPAY_VAT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].PM_NM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].TID+"</td>";
				str += "</tr>";
			} 
			$("#tbody_payAmtDetail").html(str);
			
			str = "";
			str += "<tr style='text-align: center; '>";
			str += "<td colspan='8' style='text-align:center; border:1px solid #ddd;'>&nbsp;</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totRPayAmt+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totRPayVat+"</td>";
			str += "<td colspan='2' style='text-align:center; border:1px solid #ddd;'>&nbsp;</td>";
			str += "</tr>";		
			$("#tbody_totDetail").html(str);
		}else{
			str += "<tr style='text-align: center; '>";
			str += "<td colspan='12' style='text-align:center; border:1px solid #ddd;'><spring:message code='IMS_BIM_BM_0035'/></td>";
			str += "</tr>";
			$("#tbody_payAmtDetail").html(str);
		}
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#div_payAmtDetail").hide(200);
	}
}
function fnViewCarryDetail(vid, status, conf1Tm, carryCl, carryDt){
	//carry_deposit_amt > 0
	//이월내역 상세 조회 
	arrParameter["vid"] = vid;
	arrParameter["status"] = status;
	arrParameter["conf1Tm"] = conf1Tm;
	arrParameter["carryCl"] = carryCl;
	arrParameter["carryDt"] = carryDt;
	strCallUrl   = "/calcuMgmt/agencyStmtMgmt/selectAgentStmtCarryDetail.do";
	strCallBack  = "fnViewCarryDetailRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnViewCarryDetailRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#div_searchResult").hide(200);
		$("#div_payAmtDetail").hide(200);
		$("#div_carryAmtDetail").show(200);
		var str = "";
		
		if(objJson.data.length != 0  ){
			for(var i=0; i<objJson.data.length; i++){
				str += "<tr style='text-align: center; '>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].RNUM+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].CARRY_DT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].TR_AMT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].FEE+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].VAT+"</td>";
				str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].DPST_AMT+"</td>";
				if(objJson.data[i].STATUS == "2"){
					str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data[i].CONFIRM_DT+"</td>";
				}
				str += "</tr>";
			} 
			$("#tbody_carryAmtDetail").html(str);
			
			str = "";
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd;'><spring:message code='IMS_BIM_BM_0176'/></td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.data.length+"건 </td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totTrAmt+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totFee+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totVat+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>"+objJson.totMap.totDepositAmt+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd;'>&nbsp;</td>";
			str += "</tr>";		
			$("#tbody_totCarryDetail").html(str);
		}else{
			str += "<tr style='text-align: center; '>";
			str += "<td colspan='7' style='text-align:center; border:1px solid #ddd;'><spring:message code='IMS_BIM_BM_0035'/></td>";
			str += "</tr>";
			$("#tbody_carryAmtDetail").html(str);
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#div_carryAmtDetail").css("display", "none");
	}
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.AGENCY_SETTLEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0124'/></span></h3>
                </div>
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
                                    <div class="row form-row"   >
		                                <div class="col-md-2"   id="divYear">
											<label class="form-label"><spring:message code="IMS_BIM_BM_0631"/></label>
                                        	<select id="year" name="year"  style="width: 80%;" class="select2 form-control">
                           					</select>
                               				<span style="float: right;margin: -8% 8%; "><spring:message code="DDLB_0091" /></span>
	                                    </div>
	                                    <div class="col-md-2"  id="divMon">
	                                    	<label class="form-label">&nbsp;</label>
	                                    	<select id="mon"name="mon"  style="width: 80%;"class="select2 form-control">
                                      		</select>
                                      		<span style="float: right; margin: -8% 8%;"><spring:message code="IMS_BIM_BM_0628" /></span>
	                                    </div>
	                                    <div class="col-md-8" ></div>
                                    </div>
                                    <div class="row form-row"   style="padding:10px 0 0 0;" >
	                                    <div class="col-md-2" >
											<label class="form-label"><spring:message code="DDLB_0139"/></label>
                                        	<input type="text" id="vid" name="vid" maxlength="10" class="form-control"  >
	                                    </div>
	                                    <div class="col-md-10"></div>
                                    </div>
                                    <div class="row form-row"   style="padding:10px 0 10px 0;" >
                                    	<div class="col-md-2" >
	                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0101"/></label>
	                                    	<select id="selType"name="selType" onchange="fnConfirmCl();"  style="width: 80%;"class="select2 form-control">
                                      		</select>
	                                    </div>
                                        <div class="col-md-4"></div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_CCS_0005'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
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
                <form id="frmStmtSave">
	                <div id="div_search" class="row">
	                    <div class="col-md-12">
	                        <div class="grid simple">
	                            <div class="grid-title no-border">
	                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
	                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
	                            </div>
	                            <div class="grid-body no-border">
	                                <div id="div_searchResult" >
	                                    <div class="grid simple ">
	                                        <div class="grid-body " id="">
	                                            <table id="tbListSearch" class="table" style="width:100%">
	                                            	<thead>
	                                            		<tr>
	                                            		 <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_DASHBOARD_0029'/></th>
	                                            		 <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0631'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0632'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='DDLB_0139'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0571'/></th>
	                                                     <th colspan="5" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0364'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_SM_SR_0018'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0623'/></th>
				                                         <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0437'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0556'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0624'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0625'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0640'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0641'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0642'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0634'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0635'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0557'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0643'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0644'/></th>
	                                                     
	                                                     <th rowspan="2" class="th_verticleLine">
	                                                     	<spring:message code='IMS_BIM_BM_0574'/>
	                                                     	<div class="checkbox check-success" style="padding-top:10px; padding-bottom:0; float: left; width: 68%;" >
														 		<input id="confirmChkProc"  name="confirmChkProc"   type="checkbox"  onclick="fnConfirmChkChange(this);" >
										                   		<label for="confirmChkProc"></label>
														 	</div>
	                                                   	</th>
	                                                     <th rowspan="2" class="th_verticleLine">
	                                                     	<spring:message code='IMS_BIM_BM_0626'/>
	                                                     	<div class="checkbox check-success" style="padding-top:10px; padding-bottom:0; float: left; width: 68%;" >
														 		<input id="carryChkProc"  name="carryChkProc"  type="checkbox"  onclick="fnCarryChkChange(this);" >
										                   		<label for="carryChkProc"></label>
														 	</div>
	                                                   	</th>
	                                                     
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0645'/></th>
	                                                 </tr>
	                                                 <tr>
	                                                     <th ><spring:message code='IMS_BIM_BM_0176'/></th>
				                                         <th ><spring:message code='IMS_BIM_BM_0280'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0281'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0282'/></th>
	                                                     <th><spring:message code='IMS_BIM_BM_0283'/></th>
	                                                 </tr>
	                                            	</thead>
	                                            </table>
	                                            <table class="table">
	                                            	<tr>
	                                            		<td>
	                                            			<div class="col-md-10">
	                                            			</div>
	                                            			<div class="col-md-2">
	                                            				<button type="button" onclick="fnConfirmStmt();"class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0574'/></button>
	                                            				<button type="button" onclick="fnCarryStmt();"class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0626'/></button>
	                                            			</div>
	                                            		</td>
	                                            	</tr>
	                                            </table>
	                                        </div>
	                                    </div>  
	                                </div>
	                                <div id="div_payAmtDetail"  >
	                                    <div class="grid simple ">
	                                        <div class="grid-body " id="">
	                                            <table id="tbPayAmtDetail" class="table" style="width:100%">
	                                            	<thead>
	                                            		<tr>
	                                            		 <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
	                                            		 <th ><spring:message code='IMS_BIM_BM_0101'/></th>
	                                                     <th ><spring:message code='IMS_BIM_MM_0054'/></th>
	                                                     <th ><spring:message code='IMS_BM_CM_0028'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0105'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0106'/></th>
	                                                     <th ><spring:message code='IMS_TV_TH_0029'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0437'/></th>
				                                         <th ><spring:message code='IMS_BIM_BM_0624'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0625'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0132'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0689'/></th>
	                                            	</tr>
	                                            	</thead>
	                                            	<tbody id="tbody_payAmtDetail"></tbody>
	                                            	<tbody id="tbody_totDetail"></tbody>
	                                            </table>
	                                        </div>
	                                    </div>  
	                                </div>
	                                <div id="div_carryAmtDetail"  >
	                                    <div class="grid simple ">
	                                        <div class="grid-body " id="">
	                                            <table id="tbCarryAmtDetail" class="table" style="width:100%">
	                                            	<thead>
	                                            		<tr>
	                                            		 <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
	                                            		 <th ><spring:message code='IMS_BIM_BM_0627'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0364'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0437'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0556'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0636'/></th>
	                                                     <th ><spring:message code='IMS_BIM_BM_0690'/><br><spring:message code='IMS_BIM_BM_0691'/></th>
	                                            	</tr>
	                                            	</thead>
	                                            	<tbody id="tbody_carryAmtDetail"></tbody>
	                                            	<tbody id="tbody_totCarryDetail"></tbody>
	                                            </table>
	                                        </div>
	                                    </div>  
	                                </div>
	                            </div>
	                        </div>
	                    </div>                
	                </div>
                </form>
                <!-- END SEARCH LIST AREA -->
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    	<!-- END CONTAINER -->
