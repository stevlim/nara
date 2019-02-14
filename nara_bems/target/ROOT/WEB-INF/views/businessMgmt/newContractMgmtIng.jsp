<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var salesAuth5= "<%=request.getAttribute("SALES_AUTH_FLQ5")%>";
var toDay ;
var objCoInfoInquiry; 
$(document).ready(function(){
	toDay = fnToDay();
	fnSetDDLB();
	fnInit();
    fnInitEvent();
    setCallTime();
});

function fnInit(){
	$("#div_frm").css("display", "none");
	$("#div_search").css("display", "none");
}

function fnSetDDLB() {
	$("#frmSearch select[name='division']").html("<c:out value='${DIVISION_SEARCH}' escapeXml='false' />");
	$("select[name=inOutChk]").html("<c:out value='${inOutChk}' escapeXml='false' />");
	$("select[name=flagChk]").html("<c:out value='${flagChk}' escapeXml='false' />");
	$("select[name=yMoney]").html("<c:out value='${useCash}' escapeXml='false' />");
	$("select[name=registMoney]").html("<c:out value='${useCash}' escapeXml='false' />");
	$("select[name=contFlg]").html("<c:out value='${contFlg}' escapeXml='false' />");
	$("select[name=contRoute]").html("<c:out value='${contRoute}' escapeXml='false' />");
	$("#frmEdit select[name=status]").html("<c:out value='${STATUS}' escapeXml='false' />");
	$("select[name='STATUS']").html("<c:out value='${STATUSL_EDIT}' escapeXml='false' />");
	$("select[name='RECV_CHANNEL']").html("<c:out value='${RECV_CHANNEL_EDIT}' escapeXml='false' />");
	$("#frmEdit select[name=status]").html("<c:out value='${STATUS}' escapeXml='false' />");
	
}

function fnInitEvent() {	
	
	$("#frmSearch select[name=division]").on("change", function(){
		if($.trim(this.value)==""){
			$("#search").val("");
			$("#frmSearch #txtSearchDivisionValue").attr("readonly", true);
		}else{
			$("#frmSearch #txtSearchDivisionValue").attr("readonly", false);
		}
	});
    
	$("#btnSearch").on("click", function() {
        $("#div_search").css("display", "block");
        $("#div_frm").css("display", "none");
        
        if(salesAuth5 == "1"){
			$("#saleAuthChk").show();
			$("#saleAuthNChk").hide();
		}else{
			$("#saleAuthChk").hide();
			$("#saleAuthNChk").show();
		}
        
        fnSelectCoList();
    });
	
	$("#btnRegistration").on("click", function() {
		var input = $("#todate").val();
	   	var contDt = input.replace(/(\d\d)\-(\d\d)\-(\d{4})/, "$3/$1/$2");
		$("#registDt").val(contDt);
		$("#div_search").css("display", "none");
		$("#div_frm").css("display", "block");
		$("#frmEdit").css("display", "block");
		
		if(salesAuth5 == "1"){
			$("#saleAuthChk").show();
			$("#saleAuthNChk").hide();
		}else{
			$("#saleAuthChk").hide();
			$("#saleAuthNChk").show();
		}
    });
	
	
	/* $("#btnEdit").on("click", function() {
		$("#frmEdit").serializeObject();
		IONPay.Utils.fnHideSearchOptionArea();
	}); */

	$("#btnAddress").on("click", function() {
        $("#address4").val($("#address1").val());
        $("#address5").val($("#address2").val());
        $("#address6").val($("#address3").val());
    });
	
}
/** 통화내역 시간 기록 */
function setCallTime() { 

	var intHour, intMin, intSec; 
	var now_date = new Date(); 

	intHour = now_date.getHours(); 
	intMin = now_date.getMinutes(); 
	intSec = now_date.getSeconds(); 

	if (intHour < 10) intHour = "0"+intHour;
	if (intMin < 10)  intMin = "0"+intMin; 
	if (intSec < 10)  intSec = "0"+intSec; 
	strTime =  intHour + ":" + intMin + ":" + intSec; 

	$("#frmEdit #callTime").val(toDay + " " + strTime);
	
	window.setTimeout("setCallTime();", 100); 
} 
function fnRegistCoInfo(){
	var telNo = $("#frmEdit #telNo");
	var faxNo = $("#frmEdit #faxNo");
	var contTel = $("#frmEdit #contTel");
	var settTel = $("#frmEdit #settTel");
	var techTel = $("#frmEdit #techTel");
	
	if(chkSpeChar(telNo)== false || chkSpeChar(faxNo)== false ||chkSpeChar(contTel)== false
			|| chkSpeChar(settTel)== false || chkSpeChar(techTel)== false){
		IONPay.Msg.fnAlert('숫자만 입력해주세요.' );
		return ;
	}
	/* if(!chkCoNo(coNo)){
	IONPay.Msg.fnAlert('유효하지 않은 사업자 번호입니다.\n 다시 확인하시고 입력해주세요.');
	return false;
	} */
	// 생년월일 필수입력
	/* if($("#frmEdit #compYMD").val().length < 10) {
		IONPay.Msg.fnAlert('대표자 생년월일을 확인 해주세요.');
		$("#frmEdit #compYMD").focus();
	  	return ;
	} */

    // 계약일자
    if(($("#frmEdit #status").val() == "88" ||$("#frmEdit #status").val() == "89") && $("#frmEdit #contDt").val().length < 10) {
      IONPay.Msg.fnAlert('계약일자를 입력해주세요.');
      $("#frmEdit #contDt").focus();
      return false;
    }
    
	// 증권항목 필수입력
	if($("#frmEdit #flagChk").val() == "1" && ($("#frmEdit #insurance").val().length < 1 || $("#frmEdit #insuStartDt").val().length < 10 || $("#frmEdit #insuEndDt").val().length< 10 )) {
		IONPay.Msg.fnAlert('증권여부가 수령일 경우, 보증보험, 보험증권 기간은 필수 항목입니다.\n다시 한번 확인해주세요.');
		$("#frmEdit #flagChk").focus();
	  	return;
	}
	if($("#frmEdit #flagChk").val() == "0" && !confirm("증권여부가 면제일 경우, 보증보험, 보험증권 기간 항목은 저장되지 않습니다.\n계속 진행 하시겠습니까?")){
		$("#frmEdit #flagChk").focus();
		return;
	}

    
	// 현재상태 선택시 제어
	// 다음 값은 선택 불가 처리.
	/*
	03  : 책임자 승인완료
	04  : 책임자 승인반려
	05  : RM심사 부적격
	06  : 카드사 심사 부적격
	*/
	var stateObj = $("#frmEdit #status");
	
	var stateNo = Number(stateObj.val());
	//IONPay.Msg.fnAlert('stateNo : '+stateNo);
	if ( stateNo > 2 && stateNo< 7 ){
		IONPay.Msg.fnAlert('['+stateObj[stateObj.selectedIndex].text+']는 선택할 수 없습니다.');
		return false;
	} 
	var flg = $("#frmEdit #editMode").val();
	
	arrParameter = $("#frmEdit").serializeObject();
	arrParameter["flg"]    =flg;
	arrParameter["worker"]    =strWorker;
	strCallUrl   = $("#frmEdit #editMode").val() == "insert" ? "/businessMgmt/newContractMgmt/insertCoInfo.do" : "/businessMgmt/newContractMgmt/updateCoInfo.do"  ;
	strCallBack  = "fnInsertCoInfoRet";
	 
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	
}
function fnInsertCoInfoRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("등록되었습니다.");
		IONPay.Utils.fnClearHideForm();		
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnClose(){
		$("#div_frm").hide();
}
//사업자 번호 중복 확인
function fnCheckCoNo(){
	var coNo = $("#frmEdit #coNo");
	
	if(chkSpeChar(coNo) == false){
		IONPay.Msg.fnAlert('숫자만 입력해주세요.' );
		return false;
	}
	/* if(!chkCoNo(coNo)){
		IONPay.Msg.fnAlert('유효하지 않은 사업자 번호입니다.\n 다시 확인하시고 입력해주세요.');
		return false;
	} */
	if(coNo.val().length < 10){
		IONPay.Msg.fnAlert("사업자번호는 10자리가 유효합니다.");
		return false;
	}else{
		arrParameter["coNo"]    = coNo.val();
		strCallUrl   = "/businessMgmt/newContractMgmt/selectCoNo.do";
		strCallBack  = "fnCheckCoNoRet";
		 
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}
function fnCheckCoNoRet(objJson){
	var check = false;
	
	if(objJson.resultCode == 0 ){
		if(objJson.data == 0){
			IONPay.Msg.fnAlert("사용가능한 사업자 번호입니다.");
			chkNoflg.value = 'true';
		}
	}else{
		if((objJson.data[0].CNT==null?"":objJson.data[0].CNT) == "0"){
			check = true;
		}else{
			check = false;
		}
		
		var status = null;
		
		if((objJson.data[0].UNUSE_FLG==null?"": objJson.data[0].UNUSE_FLG) == "0"){
			status = "사용 중";
		}else if((objJson.data[0].UNUSE_FLG==null?"":objJson.data[0].UNUSE_FLG) == "1"){
			status = "해지";
		}else{
			status = "미등록";
		}
		
		if(check){
			IONPay.Msg.fnAlert("사용가능한 사업자 번호입니다.");
			chkNoflg.value = 'true';
		}else{
			IONPay.Msg.fnAlert("중복되는 사업자 번호가 존재합니다. 현재 상태는 "+status+"입니다.");
		}
	}
}
/** 수수료 등록창
*@param way  구분   ( 01: 카드,  02: 계좌이체, 03: 가상계좌, 05 : 휴대폰 , 06 : 휴대폰빌링)
*@param type 결재타입 ( 01 : 온라인,  02 : 모바일 , 03 : 스마트폰) 	
*/
function fnFeeRegist( pmCd, spmCd ){		
	var coNo = $("#frmEdit #coNo");
	if(chkSpeChar(coNo) == false){
		IONPay.Msg.fnAlert('숫자만 입력해주세요.' );
		return false;
	}
	if(coNo.val() == ""){
		IONPay.Msg.fnAlert("사업자 번호를 입력해주세요.");
		return;
	}
	
	// 사업자 번호 check
	/* if(!chkCoNo(coNo)){
		IONPay.Msg.fnAlert('유효하지 않은 사업자 번호입니다.\n 다시 확인하시고 입력해주세요.');
		return false;
	} */
	
	if( pmCd == '01' ){	// 카드
		//modal
		strModalID = "modalCardFee";
    	arrParameter["pmCd"] = pmCd;
    	arrParameter["spmCd"] = spmCd;
    	arrParameter["coNo"] = coNo.val();
    	arrParameter["load"] = "R";
        strCallUrl   = "/businessMgmt/newContractMgmt/selectCardFeeInfo.do";
        strCallBack  = "fnModalCardFeeRet";
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	} 
}
function fnModalCardFeeRet(objJson){
	var isLoad = false;
	if(objJson.resultCode == 0 ){
		var day = fnToDay();
		$("body").addClass("breakpoint-1024 pace-done modal-open ");
		var title = objJson.title;
		$("#frmCardFeeReg  #ftTitle").html(title);
		var load = objJson.data.load;
		var cardSize = objJson.majorCardCd.length;
		var overCardSize = objJson.overCardCd.length;
		var i=0;
		var feeSize = 0;
		var feeInfo = null;
		var str = "";
		
		/* if(load != null || load != ""){
			isLoad = true;
			
			if(objJson.coFeeList != null  ){
				var feeSize = objJson.coFeeList.length;
				var feeInfo = new String[feeSize][3];
				for(i=0; i<feeSize; i++){
					feeInfo[i][0] = objJson.coFeeList[i].PM_CD;
					feeInfo[i][1] = objJson.coFeeList[i].FEE;
					feeInfo[i][2] = objJson.coFeeList[i].FR_DT;
				}
			}
		} */
		
		$("#frmCardFeeReg  input[name=dSize]").val(cardSize+overCardSize);
		$("#frmCardFeeReg  input[name=coNo]").val(objJson.data.coNo);
		$("#frmCardFeeReg  input[name=spmCd]").val(objJson.data.spmCd);
		$("#frmCardFeeReg  input[name=pmCd]").val(objJson.data.pmCd);
		
		
		var matchId = [];
		for(i =0; i<cardSize+overCardSize; i++){
			if(i < cardSize){
				cardCd = objJson.majorCardCd[i];
			}else{
				cardCd = objJson.overCardCd[i-cardSize];
			}
			str += "<tr style='text-align:center;'><td>"+cardCd.DESC1+"</td>";
			if(objJson.merIdList == null ){
				str += "<td><input type='text' name='fee_"+i+"' class='form-control'> %</td>";
				str += "<td><input type='hidden' name='code_"+i+"' value='"+cardCd.CODE1+"'>";
				str += "<input type='text' name='date_"+i+"' value='' class='form-control' onkeyup='fnReplaceDate(this)' maxlength='10' > 부터  ";
			}else{
				str += "<td><input type='text' name='fee_"+i+"' class='form-control' value='"+objJson.merIdList[i][0]+"' > %</td>";
				str += "<td><input type='hidden' name='code_"+i+"' value='"+cardCd.CODE1+"'>";
				str += "<input type='text' name='date_"+i+"' value='"+objJson.merIdList[i][1]+"' class='form-control' onkeyup='fnReplaceDate(this)' maxlength='10' > 부터  ";
			}
			str += "</td></tr>";
		}
		$("#frmCardFeeReg #cardDataSetting").html(str);
		initDay();
		$("#modalCardFee").modal(); 	
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function initDay() {
	var toDay = dateLMaskOn(fnToDay());	   
	var max = $("#frmCardFeeReg input[name=dSize]").val();
	for ( var i=0 ; i< max ; i++){
		// 저장된 정보가 있을 경우는 세팅 금지
		if(js_IsEmpty($("#frmCardFeeReg input[name=date_"+i+"]").val())){
			$("#frmCardFeeReg input[name=date_"+i+"]").val(toDay);
		}			
	}
}	
function setAll(id) {
	var cardSize = $("#frmCardFeeReg input[name=dSize]").val();
	var i=0;
	if(id == 'set') {
	  for(i = 0; i < cardSize; i++) {
	    	eval($("#frmCardFeeReg input[name=fee_"+i+"]")).val($("#frmCardFeeReg input[name=fee_set]").val()) 
	    }
  	} else {
	  	for(i = 0; i < cardSize; i++) {
		    eval($("#frmCardFeeReg input[name=fee_"+i+"]")).val("");
   		}
	}
}

function fnRegistFee(){
	var cardSize = $("#frmCardFeeReg input[name=dSize]").val();
	for(var i=0; i<cardSize; i++){
		if($("#frmCardFeeReg input[name=fee_"+i+"]").val() > 100){
			IONPay.Msg.fnAlert("수수료는 100%를 초과할 수 없습니다.");
			return;
		}
		if($("#frmCardFeeReg input[name=fee_"+i+"]").val() != ""){
			if($("#frmCardFeeReg input[name=date_"+i+"]").val() ==""){
				IONPay.Msg.fnAlert('변경적용기간을 입력해주세요');
				return;
			}
			if(dateLMaskOff($("#frmCardFeeReg input[name=date_"+i+"]").val()) < fnToDay()){
				IONPay.Msg.fnAlert('변경적용기간은 오늘이후여야 합니다.');
				return;
			}
		}else{
			if($("#frmCardFeeReg input[name=date_"+i+"]").val() != ""){
				IONPay.Msg.fnAlert('수수료를 입력해주세요.');
				return;
			}
		}
	} 
	arrParameter = $("#frmCardFeeReg").serializeObject();
	arrParameter["worker"] = strWorker;
    strCallUrl   = "/businessMgmt/newContractMgmt/insertCardFeeReg.do";
    strCallBack  = "fnRegistFeeRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnRegistFeeRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data != null){
			//if(objJson.data.result == 1){
				$("#frmEdit  input[name=onCard]").val(objJson.data.dpFee);
				IONPay.Msg.fnAlert("등록되었습니다.");
				$("#modalCardFee").modal("hide");
			//}
		} 
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnSelectCoList(){
		if (typeof objCoInfoInquiry == "undefined") {
			objCoInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbNewContractMgmt", true, {
	        url: "/businessMgmt/newContractMgmt/selectCoInfoList.do",
	        data: function() {	
	            return $("#frmSearch").serializeObject();
	        },
	        columns: [
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RECV_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.RECV_DT) } },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NO==null?"":"<a href='#' onClick='fnView(\""+data.CO_NO+"\")'>"+data.CO_NO} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM==null?"":data.CO_NM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REG_AMT==null?"":data.REG_AMT} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.YEAR_AMT==null?"":data.YEAR_AMT} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CONDOC==null?"":data.CONDOC} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.STATE==null?"":data.STATE} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CONFIRM==null?"":data.CONFIRM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.EMP_NM==null?"":data.EMP_NM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RECV_CHANNEL==null?"":data.RECV_CHANNEL} }
	            
	            ]
		    }, true);
		} else {
			objCoInfoInquiry.clearPipeline();
			objCoInfoInquiry.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();
		IONPay.Utils.fnHideSearchOptionArea();
}
// 계약서 등록
function fnContImgUpload(){
	//사업자 번호 중복 확인 여부
	if(chkNoflg.value == 'false') {
	  IONPay.Msg.fnAlert('사업자번호 중복확인을 해주세요.');
	  coNo.focus();
	  return;
	}
	if (confirm("계약서 이미지를 등록하시겠습니까?")) {
		var $objForm = $("#frmEdit");
        var $objFormData = new FormData($objForm);
        $objFormData.append("coNo",      $.trim($("#coNo").val()));
        $objFormData.append("worker",      $.trim(strWorker));
		$objFormData.append("DATA_FILE",  $("input[name=DATA_FILE]")[0].files[0]);
		
	    strCallUrl   = "/businessMgmt/newContractMgmt/uploadContImg.do";
	    strCallBack  = "fnContImgUploadRet";
	    IONPay.Ajax.fnRequestFile($objFormData, strCallUrl, strCallBack);
	}else{
		return;
	}
}
function fnContImgUploadRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("등록되었습니다.");
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnContImgView(){
		//modal
		$("body").addClass("breakpoint-1024 pace-done modal-open ");
		if (typeof objContImgView == "undefined") {
			objContImgView  = IONPay.Ajax.CreateDataTable("#tbContImgView", true, {
	        url: "/businessMgmt/newContractMgmt/selectContImgList.do",
	        data: function() {	
	            return $("#frmEdit").serializeObject();
	        },
	        columns: [
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NO==null?"":data.CO_NO} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.REG_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.REG_DT)} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.IMG_NM==null?"":"<a href="+data.IMG_URL+" >  "+data.IMG_NM+"</a>"} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.EMP_NM==null?"":data.EMP_NM} }
	            ]
		    }, true);
		} else {
			objContImgView.clearPipeline();
			objContImgView.ajax.reload();
		}
		$("#modalContImgView").modal();
}
function fnContImgViewRet(objJson){
	if(objJson.resultCode == 0){
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage)
	}
}
function fnView(coNo){
	arrParameter["coNo"] = coNo;
    strCallUrl   = "/businessMgmt/newContractMgmt/selectCoIngView.do";
    strCallBack  = "fnViewRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnViewRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Utils.fnClearShowForm();
		$("#frmEdit #registDt").val(objJson.coView.RECV_DT);
		$("#frmEdit #coNo").val(objJson.coView.CO_NO);
		$("#frmEdit #coNm").val(objJson.coView.CO_NM);
		$("#frmEdit #contMng").val(objJson.coView.contMng);
		$("#frmEdit #settMng").val(objJson.coView.settMng);
		$("#frmEdit #onLst").val(objJson.coView.onList);
		$("#frmEdit #address").val(objJson.coView.address);
		$("#frmEdit #telNo").val(objJson.coView.TEL_NO);
		$("#frmEdit #faxNo").val(objJson.coView.FAX_NO);
		$("#frmEdit #email").val(objJson.coView.EMAIL);
		$("#frmEdit #startMoney").val(objJson.coView.FUND_AMT);
		$("#frmEdit #bsKind").val(objJson.coView.BS_KIND);
		$("#frmEdit #gdKind").val(objJson.coView.GD_KIND);
		$("#frmEdit #url").val(objJson.coView.CO_URL);
		$("#frmEdit #maItem").val(objJson.coView.MAIN_GOODS_NM);
		$("#frmEdit #contDt").val(objJson.coView.CONT_DT);
		$("#frmEdit #openDt").val(objJson.coView.OPEN_DT);
		$("#frmEdit #repNm").val(objJson.coView.REP_NM);
		$("#frmEdit #contChk").val(objJson.coView.CONTDOC_RCV_FLG=="0"?"미수취":"수취");
		$("#frmEdit #recvChan").val(objJson.coView.RECV_CH);
		$("#frmEdit #nowStatus").val(objJson.coView.CONT_ST);
		$("#frmEdit #address1").val(objJson.coView.POST_NO);
		$("#frmEdit #address2").val(objJson.coView.RADDR_NO1);
		$("#frmEdit #address3").val(objJson.coView.RADDR_NO2);
		$("#frmEdit #address4").val(objJson.coView.RPOST_NO);
		$("#frmEdit #address5").val(objJson.coView.RADDR_NO1);
		$("#frmEdit #address6").val(objJson.coView.RADDR_NO2);
		$("#frmEdit #contNm").val(objJson.coView.CONT_NM);
		$("#frmEdit #contTel").val(objJson.coView.CONT_TEL);
		$("#frmEdit #contCp").val(objJson.coView.CONT_CP);
		$("#frmEdit #contEmail").val(objJson.coView.CONT_EMAIL);
		$("#frmEdit #settNm").val(objJson.coView.SETT_NM);
		$("#frmEdit #settTel").val(objJson.coView.SETT_TEL);
		$("#frmEdit #settEmail").val(objJson.coView.SETT_EMAIL);
		$("#frmEdit #contFlg").select2("val", objJson.coView.CONTDOC_RCV_FLG);
		$("#frmEdit #contRoute").select2("val", objJson.coView.RECV_CH_CD);
		$("#frmEdit #status").select2("val", objJson.coView.CONT_ST_CD);
		$("#frmEdit #contManager").select2("val", objJson.coView.CONT_EMP_NO);
		$("#frmEdit #salesManager").select2("val", objJson.coView.MGR1_EMP_NO);
		if(objJson.coView.strInitAmt == "none"){
			$("#frmEdit #registMoney").select2("val", "0");
		}else{
			$("#frmEdit #registMoney").select2("val", objJson.coView.strInitAmt);
		}
		if(objJson.coView.strMngAmt == "none"){
			$("#frmEdit #yMoney").select2("val", "0");
		}else{
			$("#frmEdit #yMoney").select2("val", objJson.coView.strMngAmt);
		}
		if(typeof objJson.coView.onList != "undefined"){
			if(objJson.coView.onList[0] == "checked"){
				frmEdit.checkOnPmCd[0].checked=true;
			}
			if(objJson.coView.onList[1] == "checked"){
				frmEdit.checkOnPmCd[1].checked=true;
			}
			if(objJson.coView.onList[2] == "checked"){
				frmEdit.checkOnPmCd[2].checked=true;
			}
			if(objJson.coView.onList[4] == "checked"){
				frmEdit.checkOnPmCd[3].checked=true;
			}
		}
			
		$("#frmEdit input[name=onCard]").val(objJson.feeMap.FEE);
		chkNoflg.value = 'true';
		if($("#frmEdit #editMode").val()  == "update" ){
			$("#btnSave").hide();
		}else{
			$("#btnSave").show();
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
</script>
    <!-- BEGIN PAGE CONTAINER-->
    <div class="page-content">         
        <div class="content">
            <div class="clearfix"></div>
            <!-- BEGIN PAGE TITLE -->
            <ul class="breadcrumb">
                <li><p>YOU ARE HERE</p></li>
                <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.NEW_CONTRACT_PROGRESS_HISTORY }'/></a> </li>                
            </ul>
            <div class="page-title"> <i class="icon-custom-left"></i>
                <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
            </div>
            <!-- END PAGE TITLE -->
            <!-- BEGIN PAGE FORM -->
            <div id="div_frm" class="row" >
                <div class="col-md-12">
                    <div class="grid simple">
                        <div class="grid-title no-border">
                            <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Regist</span></h4>
                            <div class="tools"><a href="javascript:;"  id="div_edit"></a></div>
                        </div>                          
                        <div class="grid-body no-border">
                         <form id="frmEdit">
                        	 <input type="hidden" id="editMode" value="insert" />	
                             <input type="hidden" id="txtEditMER_CONF_SEQ_NO" name="MER_CONF_SEQ_NO"/>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0010'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="registDt" name="registDt" class="form-control"  readonly>
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0119'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="bsKind" name="bsKind"  maxlength="80" class="form-control">
                                       </div>
                                    </div>
                                    <div class="col-md-4">
                                       <label class="form-label"><spring:message code='IMS_BM_CM_0120'/></label>
                                       <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="gdKind" name="gdKind"  maxlength="80"  class="form-control">
                                       </div>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0084'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="openDt" name="openDt" class="form-control" maxlength="10" onkeyup="fnReplaceDate(this)">
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0085'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="startMoney" name="startMoney" class="form-control">
                                       </div>
                                    </div>
                                    <div class="col-md-4">
                                       <label class="form-label"><spring:message code='IMS_BM_CM_0086'/></label>
                                       <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="url" name="url" class="form-control" >
                                       </div>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0028'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="coNm" name="coNm" class="form-control">
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0088'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="coNo" name="coNo" class="form-control" maxlength="10" onchange="chkNoflg.value='false' ">
                                       </div>
                                    </div>
                                    <div class="col-md-2">
                                    	<input type="hidden" id="chkNoflg" name="chkNoflg" value="false">
                                    	<label class="form-label" >&nbsp;</label>
                                    	<div class="input-with-icon  right">
                                           <i class=""></i>
                                           <button type='button'  id="btnDupChk" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; ' onclick="fnCheckCoNo();">
												<spring:message code='IMS_BM_CM_0089'/>
											</button>
                                    	</div>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0029'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="repNm" name="repNm" class="form-control">
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <%-- <label class="form-label"><spring:message code='IMS_BM_CM_0090'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="compYMD" name="compYMD"  class="form-control"  maxlength="10" onkeyup="fnReplaceDate(this)">
                                       </div> --%>
                                    </div>
                                    <div class="col-md-4">
                                        <%-- <label class="form-label"><spring:message code='IMS_BM_CM_0087'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="inOutChk"  id="inOutChk" class="select2 form-control">
                                           </select>
                                       </div> --%>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0093'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="maItem" name="maItem" class="form-control">
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0094'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="contDt" name="contDt" class="form-control"  maxlength="10" onkeyup="fnReplaceDate(this)">
                                       </div>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0095'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="insurance" name="insurance" class="form-control">
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0096'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="flagChk"  id="flagChk" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0099'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="insuStartDt" name="insuStartDt" class="form-control" style="width: 45%;  float: left;" maxlength="10" onkeyup="fnReplaceDate(this)"> 
                                           <p style="float:left;  margin: 8px 8px;"> ~ </p>
                                           <input type="text" id="insuEndDt" name="insuEndDt" class="form-control" style="width: 45%; float: left;" maxlength="10" onkeyup="fnReplaceDate(this)">
                                       </div>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0100'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="money" name="money" class="form-control">
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0101'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="depositDt" name="depositDt" class="form-control" maxlength="10" onkeyup="fnReplaceDate(this)">
                                       </div>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0033'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="telNo" name="telNo" class="form-control">
                                       </div>
                                    </div>                                    
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0034'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="faxNo" name="faxNo" class="form-control">
                                       </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0035'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text" id="email" name="email" class="form-control">
                                       </div>
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                		<div class="col-md-1" >
                                			<label class="form-label">&nbsp;</label>
											<button type='button' onclick="javascript:fnPostSearch('1');" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default;  background-color:white; color:#666; '>
												<span class="glyphicon glyphicon-home" aria-hidden="true" style="color:orange"></span>
											</button>
                                     	</div>
                                       <div class="col-md-3">
                                   		 <label class="form-label"><spring:message code='IMS_BM_CM_0036'/></label>
                                     	 <input type="text"  id="address1" name="address1" class="form-control" readonly>
                                      </div>
                                      <div class="col-md-4">
                                      	 <label class="form-label">&nbsp;</label>
                                     	 <input type="text"  id="address2" name="address2" class="form-control" readonly>
                                      </div>
                                      <div class="col-md-4">
                                      	<label class="form-label">&nbsp;</label>
                                      	<input type="text"  id="address3" name="address3" class="form-control">
                                      </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                			<div class="col-md-1">
                                				<label class="form-label">&nbsp;</label>
												<button type='button' onclick="javascript:fnPostSearch('2');" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
													<span class="glyphicon glyphicon-home" aria-hidden="true" style="color:orange"></span>
												</button>
	                                     	</div>
                                            <div class="col-md-2">
                                        	<label class="form-label"><spring:message code='IMS_BM_CM_0102'/></label>
                                           <input type="text"  id="address4" name="address4" class="form-control" readonly>
                                           </div>
                                           <div class="col-md-4">
                                           <label class="form-label">&nbsp;</label>
                                           <input type="text"  id="address5" name="address5" class="form-control" readonly>
                                           </div>
                                           <div class="col-md-4">
                                           <label class="form-label">&nbsp;</label>
                                           <input type="text"  id="address6" name="address6" class="form-control">
                                  		 </div>
                                  		 <div class="col-md-1">                                   
                                           <label class="form-label">&nbsp;</label>
                                           <button type='button'  id="btnAddress" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
												<spring:message code='IMS_BM_CM_0103'/>
											</button>
	                                     </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0104'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0097'/></p><input type="text"  id="contNm" name="contNm" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0098'/></p><input type="text"  id="contTel" name="contTel" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0107'/></p><input type="text"  id="contCp" name="contCp" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0108'/></p><input type="text"  id="contEmail" name="contEmail" class="form-control">
                                           </div>
                                       </div>
                                    </div>                                    
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0105'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0097'/></p><input type="text"  id="settNm" name="settNm" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0098'/></p><input type="text"  id="settTel" name="settTel" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0107'/></p><input type="text"  id="settCp" name="settCp" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0108'/></p><input type="text"  id="settEmail" name="settEmail" class="form-control">
                                           </div>
                                       </div>
                                    </div>                                    
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0106'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0097'/></p><input type="text"  id="techNm" name="techNm" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0098'/></p><input type="text"  id="techTel" name="techTel" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0107'/></p><input type="text"  id="techCp" name="techCp" class="form-control" >
                                           </div>
                                           <div class="col-md-3">
	                                           <p><spring:message code='IMS_BM_CM_0108'/></p><input type="text"  id="techEmail" name="techEmail" class="form-control">
                                           </div>
                                       </div>
                                    </div>                                    
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0109'/> - <spring:message code='IMS_BM_CM_0110'/></label>
							                <div class="grid-body no-border" style="padding-bottom:0;">
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_CARD"  name="checkOnPmCd"  value="01"  type="checkbox" checked="checked">
									                   <label for="CHK_CARD"><spring:message code="IMS_BIM_MM_0009"/></label>
									               	</div>
								               	</div>
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_ACCT"  name="checkOnPmCd"   value="02"   type="checkbox" checked="checked">
									                   <label for="CHK_ACCT"><spring:message code="IMS_BIM_MM_0150"/></label>
									               	</div>
								               	</div>
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_VACCT" name="checkOnPmCd"  value="03"  type="checkbox" checked="checked">
									                   <label for="CHK_VACCT"><spring:message code="IMS_BIM_MM_0010"/></label>
									               	</div>
								               	</div>
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_PHONE" name="checkOnPmCd"  value="05"   type="checkbox" checked="checked">
									                   <label for="CHK_PHONE"><spring:message code="IMS_BIM_MM_0151"/></label>
									               	</div>
								               	</div>
							                </div>
                                     </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0115'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                          <div class="col-md-2">
	                                           <p><spring:message code='IMS_BM_CM_0080'/> (%)</p><input type="text" name="onCard" class="form-control"  onclick="fnFeeRegist('01','01');">
                                           </div>
                                           <div class="col-md-2">
	                                           <p><spring:message code='IMS_BM_CM_0111'/> (%)</p><input type="text"  id="" name="fee" class="form-control" >
                                           </div>
                                           <div class="col-md-2">
	                                           <p><spring:message code='IMS_BM_CM_0081'/> (%)</p><input type="text"  id="" name="fee" class="form-control" >
                                           </div>
                                           <div class="col-md-2">
	                                           <p><spring:message code='IMS_BM_CM_0112'/></p><input type="text"  id="" name="fee" class="form-control">
                                           </div>
                                            <div class="col-md-2">
	                                           <p><spring:message code='IMS_BM_CM_0113'/></p><input type="text"  id="" name="fee" class="form-control">
                                           </div>
                                       </div>
                                    </div>                                    
                                </div>
                              	 <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0051'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="contFlg"  id="contFlg" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>   
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0015'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="contRoute"  id="contRoute" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>   
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0014'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="status"  id="status" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>                                    
                              	 </div>
                              	 <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0016'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="contManager"  id="contManager" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>   
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0049'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="salesManager"  id="salesManager" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>                                   
                              	 </div>
                              	 <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0046'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="registMoney"  id="registMoney" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>   
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0116'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <select name="yMoney"  id="yMoney" class="select2 form-control">
                                           </select>
                                       </div>
                                    </div>   
                              	 </div>
                              	  <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0117'/></label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <input type="text"  id="callTime" name="callTime" class="form-control">
                                       </div>
                                    </div>   
                                    <div class="col-md-8">
                                        <label class="form-label" >&nbsp;</label>
                                        <div class="input-with-icon  right">
                                           <i class=""></i>
                                           <textarea rows="2" cols="80" name="contents" name="callMsg"></textarea>
                                       </div>
                                    </div>                                   
                              	 </div>
                         </form>
						<div class="row form-row" style="padding:0 0 10px 0;">
                         <form id="frmContReg" enctype="multipart/form-data"  method="post">
							<div class="col-md-6" >
							    <label class="form-label"><spring:message code='IMS_BM_CM_0118'/></label>
	                            <div class="input-with-icon  right" >
	                               <i class=""></i>
									<input type="file" id="DATA_FILE" name="DATA_FILE" class="filestyle" data-buttonName="btn-primary">
	                           </div>
	                        </div>
		                   	<div class="col-md-1" >
		                       	<label class="form-label" >&nbsp;</label>
		                       	<div class="input-with-icon  right" >
		                          <i class=""></i>
		                          <button type='button'  id="btnSave" onclick='fnContImgUpload();' class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
									<spring:message code='IMS_BM_NM_0027'/>
									</button>
	                            </div>
	                         </div>
	                         <div class="col-md-2" >
	                         	<label class="form-label" >&nbsp;</label>
		                       	<div class="input-with-icon  right" >
									<div id="saleAuthChk">	
										<span class="add-on"><spring:message code='IMS_BM_CM_0118'/></span>
										<button type='button'  id="btnInquiry" onclick='fnContImgView();'  class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
										<spring:message code='IMS_BM_NM_0026'/>
										</button>
									</div>
									<div id="saleAuthNChk">
										<span><spring:message code='IMS_BIM_BM_0493'/></span>
									</div>
								</div>
	                        </div>
	                        <div class="col-md-4"></div>      
                         </form>
                   	 	</div>
                        </div>
                        <div class="grid-body no-border">
                            <div class="row form-row">
                                <div class="col-md-12">
                                    <p class="pull-right">
                                        <button type="button" id="btnEdit"  onclick="fnRegistCoInfo();" class="btn btn-danger auth-all">저장</button>
                                        <button type="button" id="btnEditCancel"  onclick="fnClose();"class="btn btn-default">닫기</button>
                                    </p>
                                </div>
                            </div>
                        </div>                          
                    </div>
                </div>
            </div>           
            <!-- END PAGE FORM -->
            <!-- BEGIN VIEW OPTION AREA -->
            <div class="row">
                <div class="col-md-12">
                    <div class="grid simple">
                        <div class="grid-title no-border">
                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_CM_0054'/></h4>
                            <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                        </div>
                        <div class="grid-body no-border">
	                        <form id="frmSearch" name="frmsearch">
	                            <div class="row form-row" style="padding:0 0 5px 0;">                                    
	                                <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0063'/></label>
                                        <select id="selSearchDivision" name="division" class="select2 form-control"></select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">&nbsp;</label>
                                        <input type="text" id="txtSearchDivisionValue" name="divisionvalue" class="form-control" readonly>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0041'/></label>
                                        <input type="text" id="contManager" name="contManager" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                    </div>                                        
	                            </div>                                
	                            <div class="row form-row" >
	                                <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0015'/></label>
                                        <select id="selSearchRECV_CHANNEL" name="RECV_CHANNEL" class="select2 form-control"></select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0064'/></label>
                                        <select id="selSearchSTATUS" name="STATUS" class="select2 form-control"></select>
                                    </div>     
                                    <div class="col-md-6">                                        
                                    </div>
	                            </div>
	                            <br />
	                            <div class="row form-row" >
	                                <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_CM_0055'/></label> 
                                        <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                            <input type="text" id="fromdate" name="fromdate" class="form-control">
                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                        </div>                                      
                                    </div>
                                    <div class="col-md-3">
                                       <label class="form-label">&nbsp;</label>
                                       <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                           <input type="text" id="todate" name="todate" class="form-control">
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
                                            <button type="button" id="btnRegistration" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0062'/></button>
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
            <div id="div_search"  class="row" >
                <div class="col-md-12">
                    <div class="grid simple">
                        <div class="grid-title no-border">
                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_CM_0065'/></h4>
                            <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                        </div>                        
                        <div class="grid-body no-border" >
                            <div id="div_searchResult" >
                                <div class="grid simple ">
                                    <div class="grid-body ">
                                        <table class="table" id="tbNewContractMgmt" style="width:100%">
                                            <thead>
                                             <tr>
                                             	<th><spring:message code='IMS_BM_CM_0010'/></th>
                                                <th><spring:message code='IMS_BIM_BM_0129'/></th>
                                                <th><spring:message code='IMS_BM_CM_0028'/></th>
                                                <th><spring:message code='IMS_BM_CM_0046'/></th>
                                                <th><spring:message code='IMS_BM_CM_0116'/></th>
                                                <th><spring:message code='IMS_BM_CM_0118'/></th>
                                                <th><spring:message code='IMS_BM_CM_0014'/></th>
                                                <th><spring:message code='IMS_BIM_BM_0214'/></th>
                                                <th><spring:message code='IMS_BM_CM_0041'/></th>
                                                <th><spring:message code='IMS_BM_CM_0015'/></th>
                                             </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>                
            </div>
            <!-- END SEARCH LIST AREA -->
       </div>   
	    <div id="layer"  style="display:none; position:fixed;overflow:hidden; z-index:1; -webkit-overflow-scrolling:touch;">
			<img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnClose" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
		</div>
       <!-- END PAGE --> 
    </div>
       </div>
    <!-- BEGIN MODAL -->
    <form id="frmCardFeeReg">
    	<input type='hidden' name='dSize' >
		<input type='hidden' name='coNo' >
		<input type='hidden' name='spmCd' >
		<input type='hidden' name='pmCd' >
		<div class="modal fade" id="modalCardFee"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0472"/> (<font color='blue' id="ftTitle" ></font>)<spring:message code="IMS_BIM_BIR_0019"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="tbCardFeeInfo" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0178'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0310'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0465'/></th>
                                  </tr>
                                 </thead>
                                 <tbody id="cardDataSetting" >
                                 </tbody>
                                 <tfoot style="text-align: center;">
                                 	<tr>
                                 		<td><spring:message code='IMS_BIM_BM_0081'/></td>
                                 		<td><input type="text" name='fee_set'  class="form-control"></td>
                                 		<td>
                                 			<button type="button" onclick="setAll('set');" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BIR_0024'/></button> &nbsp;&nbsp;
                                 			<button type="button" onclick="setAll('can');"class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0175'/></button>
                                 		</td>
                                 	</tr>
                                 </tfoot>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" onclick="fnRegistFee();" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BIR_0024'/></button> &nbsp;&nbsp;
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
  	</form>
	<!-- END MODAL -->
    <!-- BEGIN MODAL -->
    <form id="frmModalContImgView">
		<div class="modal fade" id="modalContImgView"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0495"/> </h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="tbContImgView" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0083'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0329'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0494'/></th>
                                      <th><spring:message code='IMS_BIM_HS_0006'/></th>
                                  </tr>
                                 </thead>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" onclick="fnRegistFee();" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BIR_0024'/></button> &nbsp;&nbsp;
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
  	</form>
	<!-- END MODAL -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }

    function fnPostSearch(chk) {
        new daum.Postcode({
            oncomplete: function(data) {
                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                if(chk == '1'){
	                document.getElementById('address1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('address2').value = fullAddr;
                }else if (chk = '2'){
                	document.getElementById('address4').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('address5').value = fullAddr;
                }

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 300; //우편번호서비스가 들어갈 element의 width
        var height = 400; //우편번호서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>
    