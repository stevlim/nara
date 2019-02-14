<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objInquiryApprove;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var map = new Map();
var typeChk; 
$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#MER_SEARCH").html("<c:out value='${MER_SEARCH}' escapeXml='false' />");	
	$("#NHCategory").html("<c:out value='${NH_CATEGORY_LIST}' escapeXml='false' />");
	$("#VACCT_LMT_DAY").html("<c:out value='${DEPOSIT_LIMIT}' escapeXml='false' />");	
	
	$("#SmallCategory").html("<c:out value='${SMALL_CATEGORY_LIST}' escapeXml='false' />");
	$("#BS_KIND_CD").html("<c:out value='${BIG_CATEGORY_LIST}' escapeXml='false' />");
	$("#MBS_TYPE_CD").html("<c:out value='${MBS_CD_LIST}' escapeXml='false' />");
	$("#MALL_TYPE_CD").html("<c:out value='${MALL_CD_LIST}' escapeXml='false' />");
	$("#RECV_CH_CD").html("<c:out value='${RECV_CH}' escapeXml='false' />");
	$("#ACQ_CL_CD").html("<c:out value='${ACQ_CD}' escapeXml='false' />"); //CODE =0013  매입방법
	$("#APP_VAN1_CD").html("<c:out value='${VAN_CD}' escapeXml='false' />");
	$("#ACQ_VAN_CD").html("<c:out value='${VAN_CD}' escapeXml='false' />");
	$("#ACQ_DAY").html("<c:out value='${ACQ_DAY}' escapeXml='false' />");
	$("#CC_CL_CD").html("<c:out value='${CC_CL_CD}' escapeXml='false' />");
	
	$("#insertInfo #bankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
	$("#insertInfo #bankCd2").html("<c:out value='${BANK_CD}' escapeXml='false' />");
	$("#insertInfo #authType").html("<c:out value='${AUTH_TYPE}' escapeXml='false' />");
	
	$("#vidRegInfo #bankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
	$("#gidRegInfo #bankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
	
	
	$("#midRegInfo #ContractStaff").html("<c:out value='${EMP_MANAGER}' escapeXml='false' />");
	$("#midRegInfo #SalesStaff").html("<c:out value='${EMP_MANAGER}' escapeXml='false' />");
	
	$("#gidInfo #gidList").html("<c:out value='${GID_LIST}' escapeXml='false' />");
	$("#gidInfo #selectBankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
	$("#vidInfo #vidList").html("<c:out value='${VID_LIST}' escapeXml='false' />");
	$("#vidInfo #selectBankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
}

function fnInit(){
	if($("#listSearchCollapse").hasClass("collapse") === true)
    	$("#listSearchCollapse").click();
	$("#ListSearch").hide();
	$("#midRegInfo").hide();
	$("#gidRegInfo").hide();
	$("#vidRegInfo").hide();
}

function fnInitEvent() {	    
	
    $("#btnSearch").on("click", function(){
    	typeChk = "update";
    	changeState();
    	if($("#MER_SEARCH_TEXT").val()==""){
    		
    		IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + " 를 입력해 주세요.");
    	}else{
    		if($("#MER_SEARCH option:selected").text() == 'MID'){
       			//mid
       			$("#midRegInfo").show(200);
        		$("#gidRegInfo").hide();
        		$("#vidRegInfo").hide();
       		}else if($("#MER_SEARCH option:selected").text() == 'GID' ){
       			//gid
       			$("#midRegInfo").hide();
    			$("#gidRegInfo").show(200);
    			$("#vidRegInfo").hide();
       		}else if($("#MER_SEARCH option:selected").text() == 'VID'){
       			//aid
       			$("#midRegInfo").hide();
    			$("#gidRegInfo").hide();
    			$("#vidRegInfo").show(200);
       		}
    		if($("#listSearchCo	llapse").hasClass("collapse") === true)
     	    	$("#listSearchCollapse").click(); 
        		$("#ListSearch").hide();
    		
    		fnSelectBaseInfo();
    	}
    });
    
    $("#btnRegistration").on("click", function(){
    	typeChk = "insert";
    	
    	if($("#MER_SEARCH option:selected").text() == 'MID'){
   			//mid
   			$("#midRegInfo").show(200);
    		$("#gidRegInfo").hide();
    		$("#vidRegInfo").hide();
    		fnCardList();
   		}else if($("#MER_SEARCH option:selected").text() == 'GID' ){
   			//gid
   			$("#midRegInfo").hide();
			$("#gidRegInfo").show(200);
			$("#vidRegInfo").hide();
   		}else if($("#MER_SEARCH option:selected").text() == 'VID'){
   			//INSERT
   			$("#vidRegInfo #trFeeRegInfo").css("display" , "block");
   			$("#vidRegInfo #thFeeInfo").css("display" , "block");
   			$("#vidRegInfo #insertFee").css("display", "block");
   			$("#vidRegInfo #trFeeInfo").css("display" , "none");
   			$("#vidRegInfo #updateFee").css("display", "none");
   			//vid
   			$("#midRegInfo").hide();
			$("#gidRegInfo").hide();
			$("#vidRegInfo").show(200);
   		}
    	if($("#listSearchCollapse").hasClass("collapse") === true)
 	    	$("#listSearchCollapse").click(); 
    		$("#ListSearch").hide();
    	
    	$("form").each(function() {  
            this.reset();  
         });  
    	
		IONPay.Utils.fnHideSearchOptionArea();
    });
    
    $("#btnListSearch").on("click", function(){
		if($("#MER_SEARCH_TEXT").val()==""){
    		
    		IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + " 를 입력해 주세요.");
    	}else{
    		var merId = $("#MER_SEARCH option:selected").text();
    		console.log(merId + "0");
    		if(merId=="MID"){
    			map.set("merId", merId);
    			console.log(merId + ": MID");
    			$("#tbListSearch #id").html("MID");
    			fnSelectApproList(merId);
        		$("#midRegInfo").hide();
        		$("#gidRegInfo").hide();
        		$("#vidRegInfo").hide();
             	$("#ListSearch").show();
             	if($("#listSearchCollapse").hasClass("collapse") === false)
         	    	$("#listSearchCollapse").click();
             	IONPay.Utils.fnHideSearchOptionArea();
    		}else if(merId == "VID"){
    			map.set("merId", merId);
    			console.log(merId + " : VID");
    			$("#tbListSearch #id").html("VID");
    			fnSelectApproList(merId);
        		$("#midRegInfo").hide();
        		$("#gidRegInfo").hide();
        		$("#vidRegInfo").hide();
             	$("#ListSearch").show();
             	if($("#listSearchCollapse").hasClass("collapse") === false)
         	    	$("#listSearchCollapse").click();
             	IONPay.Utils.fnHideSearchOptionArea();
    		}else if(merId == "GID"){
    			IONPay.Msg.fnAlert("MID, VID로만 조회 가능");
    		}
    	}
    });
    
    $("#btnVaChk").on("click", function(){
		if($("#vidRegInfo #vaNo").val() == ""){
			IONPay.Msg.fnAlert("계좌번호를 입력하세요.");
		}
		if($("#vidRegInfo #vaNm").val() == ""){
			IONPay.Msg.fnAlert("예금주를 입력하세요.");
		}
		if($("#vidRegInfo #vaNo").val() != "" && $("#vidRegInfo #vaNm").val() != ""){
	        IONPay.Msg.fnAlert("성명 확인 되었습니다.");
	        //전문 쏴서 하는건데....어떻게 할지 체크
	        
	        
		}
    });
    $("#btnNormalReg").on("click", function(){
		fnNormalRegist();    	
    });
	$("#btnSettleReg").on("click", function(){
		IONPay.Msg.fnAlert("MID 등록이 되지 않았습니다.");
		//fnSettleRegist();    	
    });
	$("#btnPayTypeReg").on("click", function(){
		IONPay.Msg.fnAlert("MID 등록이 되지 않았습니다.");
		//fnPayTypeRegist();    	
    });
	$("#btnAboradTypeReg").on("click", function(){
		IONPay.Msg.fnAlert("MID 등록이 되지 않았습니다.");
		//fnAbroadTypeRegist();    	
	});
    $("#btnAllReg").on("click", function(){
    	if(typeChk == "update"){
    		fnBaseAllUpdate();
    	}else{
    		type="all";
			fnAllRegist(type);    	
    	}
    });
    $("#btnCoNo").on("click", function(){
    	if($("#CO_NO").val().length < 10){
    		IONPay.Msg.fnAlert("사업자번호를 정확히 입력해주세요.");
    	}else{
	    	fnSearchCoNo();
    	}
    });
    $("#btnInqGid").on("click", function(){
    	if(typeChk == "update"){
	    	strModalID = "modalGidInfo";
	    	arrParameter["MER_ID"] = $("#insertInfo #GID").val() + "g";
	        strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectGidInfo.do";
	        strCallBack  = "fnGidPopupRet";
	        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    	}else{
    		strModalID = "modalGidInfo";
    		$("body").addClass("breakpoint-1024 pace-done modal-open ");
    		$("#modalGidInfo #trGidList").css("display", "block");
			$("#modalGidInfo #tdBtnGidSetting").html('<button type="button" onclick="idSetting(\'gid\');" class="btn btn-primary btn-cons"><spring:message code="IMS_BIM_BM_0442" /></button>');
    		$("#modalGidInfo").modal();
    	}
    });
    $("#btnInqVid").on("click", function(){
    	if(typeChk == "update"){
    		$("#modalVidInfo #settleNone").css("display", "block");
    		strModalID = "modalVidInfo";
	    	arrParameter["MER_ID"] = $("#insertInfo #VID").val() + "v";
	        strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectVidInfo.do";
	        strCallBack  = "fnVidPopupRet";
	        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	    }else{
			strModalID = "modalVidInfo";
			$("body").addClass("breakpoint-1024 pace-done modal-open ");
			$("#modalVidInfo #trVidList").css("display", "block");
			$("#modalVidInfo #settleNone").css("display", "none");
			$("#modalVidInfo #tdBtnVidSetting").html('<button type="button" onclick="idSetting(\'vid\');" class="btn btn-primary btn-cons"><spring:message code="IMS_BIM_BM_0442" /></button>');
			$("#modalVidInfo").modal();
		}
    });
}
function idSetting(id){
	if(id == "gid"){
	   	var gid = $("#gidInfo #gid").text().substring(0, 9);
	   	$("#insertInfo #GID").val(gid);
	}else{
		var vid = $("#vidInfo #vId").text().substring(0, 9);
	   	$("#insertInfo #VID").val(vid);
	}
}

function selectGid(){
	strModalID = "modalGidInfo";
	arrParameter["MER_ID"] = $("#gidList option:selected").text();
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectGidInfo.do";
    strCallBack  = "fnGidPopupRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function selectVid(){
	strModalID = "modalVidInfo";
	arrParameter["MER_ID"] = $("#vidList option:selected").text();
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectVidInfo.do";
    strCallBack  = "fnVidPopupRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnCheckValidate(type){
	var resultCd ;
	var resultMsg ; 
	var resultMap = new Map();
	
	// 우선 오픈마켓 지급대행은 MID 정산만 가능하도록.
	if($("#OM_SETT_CL").val() == '1' && $("#PAY_ID_CD").val() != '2') {
		$("#PAY_ID_CD").focus();
		resultCd = 9999;
		resultMsg = "오픈마켓 지급대행은 MID 정산만 가능합니다.";
		resultMap.set("resultCd", resultCd);
		resultMap.set("resultMsg", resultMsg);
		return resultMap;
	}
	  
	// 일반정보
	if(type == '1' || type == 'all') {
	
		// 사업자번호
		if($("#CO_NO").val().length < 10) {
			resultCd = 9999;
			resultMsg = "사업자번호는 10자리가 유효합니다.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
	
		// 사업자 번호 Get
		if($("#chkCoNo").val() == 'false') {
			resultCd = 9999;
			resultMsg = "기존 사업자 정보를 가져오세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
	
		// MID
		if($("#chkID").val() == 'false') {
			resultCd = 9999;
			resultMsg = "MID 중복확인을 체크해주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		
		// GID
		if($("#insertInfo #GID").val().length < 9) {
			resultCd = 9999;
			resultMsg = "GID를 입력해주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		
		// VID
		if($("#insertInfo #VID").val().length < 9) {
			resultCd = 9999;
			resultMsg = "AID를 입력해주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		
		// 상호명
		if($("#insertInfo #MerchantName").val() =='') {
			resultCd = 9999;
			resultMsg = "상호명을 입력해 주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
	  
		// 대표 TEL
		if($("#TEL_NO").val().length < 8 || $("#TEL_NO").val().length > 11 ) {
			resultCd = 9999;
			resultMsg = "전화번호는 8자리에서 11자리가 유효합니다.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
	  
		// 대표 FAX
		if($("#FAX_NO").val() !='' && ($("#FAX_NO").val().length < 9 || $("#FAX_NO").val().length > 11  )){
			resultCd = 9999;
			resultMsg = "팩스번호는 9자리에서 11자리가 유효합니다.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
	  
		// E-Mail
		if(!fnEmailValidate($("#EMAIL").val())) {
			resultCd = 9999;
			resultMsg = "이메일주소가 유효하지 않습니다.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}

		// 계약일자
		var input = $("#insertInfo #ContractDate").val();
		var contDt = input.replace(/(\d\d)\-(\d\d)\-(\d{4})/, "$3$1$2");
		
		if(contDt == '' || contDt.length < 8) {
			resultCd = 9999;
			resultMsg = "계약일자를 입력 해주세요";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		
		// 사업장 주소
		if($("#insertInfo #Address1").val() == '') {
			resultCd = 9999;
			resultMsg = "사업장 주소를 입력해 주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		
		if($("#insertInfo #BusinessAddr1").val() == '') {
			resultCd = 9999;
			resultMsg = "사업장 주소를 입력해 주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		
		if(type == '1'){
			if($("#insertInfo #MALL_TYPE_CD").val() == '0'){
				/* if(f.oldTerNo_1101.value !='' || f.oldTerNo_1201.value !=''){
					IONPay.Msg.fnAlert('오프라인으로 설정된 결제수단 항목이 존재합니다.\n해당 정보를 수정 및 저장한 후 진행해주세요.');
					return;
				} */
			}
		}
		
		if(typeChk == 'insert' && type != 'all') {
			if(confirm('사업자 기본 수수료로 기본 저장하시겠습니까? \n추후 수정 가능합니다.')) {
				$("#insertInfo #defaultCoFee").val("true");
			}else{
				$("#insertInfo #defaultCoFee").val("false");  
			}
		}
	}else {
		if($("#insertInfo #regMID").val()== 'false') {
			IONPay.Msg.fnAlert('MID 등록이 되지 않았습니다.');
			resultCd = 9999;
			resultMsg = "사업장 주소를 입력해 주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
	}
	
	  // 기타정보
	if(type == '2' || type == 'all') {
		if($("#insertInfo #APP_VAN1_CD").val() == '00') {
			resultCd = 9999;
			resultMsg = "승인Van이 미지정됐습니다.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		
		if($("#insertInfo #ACQ_VAN_CD").val() == '00') {
			resultCd = 9999;
			resultMsg = "매입Van이 미지정됐습니다.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
	}
		
		  // 정산정보
	if(type == '3' || type == 'all') {
		if($("#insertInfo #ACQ_CL_CD").val() != "2" && $("#insertInfo #ACQ_DAY").val() != "1"){
			resultCd = 9999;
			resultMsg = "매입일자는 [반자동] 매입 업체만 설정하세요. [반자동] 아닐 경우 1로 설정.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		if( ($("#insertInfo #bankCd").val() == "" && $("#insertInfo #ACCNT_NO").val() == "" && $("#insertInfo #ACCNT_NM").val() == "") &&
				($("#insertInfo #bankCd").val() != "" && $("#insertInfo #ACCNT_NO").val() != "" && $("#insertInfo #ACCNT_NM").val() != "") ){
			resultCd = 9999;
			resultMsg = "계좌 정보를 확인해주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		}
		/* if($("#insertInfo #ACCNT_NO").val() != "" && $("#insertInfo #chkAccnt").val() == "false"){
			IONPay.Msg.fnAlert('계좌 성명조회를 수행해주세요.');
			resultCd = 9999;
			resultMsg = "사업장 주소를 입력해 주세요.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		} */
	}
  // IPG || Smart
	if(type == '4' || type == 'all') { //type == '4' || type == '5' || type == '6' || type == 'all'
		/* var failFnNm = checkCardMemberAuthType();
		
		// 신용카드 : 가맹점번호 인증형태 체크
		if(failFnNm !=''){
			resultCd = 9999;
			resultMsg = "설정한 가맹점 번호의 인증 타입이 \n인증형태 값과 일치하지 않습니다.['+failFnNm+']";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		} */
		// 계좌이체 : 사용함 but CPID 사용안함. 오류
		/* $("#insertInfo #selUseCl_0101").val() == "1" && $("")
		if((f.selUseCl_0201.value == '1' && f.selCPID_0201.value == '0')) { // || (f.selUseCl_0202.value == '1' && f.selCPID_0202.value == '0')
			resultCd = 9999;
			resultMsg = "CPID가 선택되지 않았습니다.";
			resultMap.set("resultCd", resultCd);
			resultMap.set("resultMsg", resultMsg);
			return resultMap;
		} */

		/* if($("#insertInfo #defaultCoFee").val()== 'true') {
			IONPay.Msg.fnAlert('사업자 기본 수수료가 저장됩니다.');
		} */
		console.log("결제수단 ");
	}   
	
	/* if(type =='5'  || type == 'all'){
		var chkVal1 = f.global_van_sync_11.value;
		var chkVal2 = f.global_van_sync_12.value;
		
		var oldSettVal_11 = f.oldSettlSvc0007_11.value;
		var settVal_11 = f.selSettlSvc0007_11.value;
		var oldSettVal_12 = f.oldSettlSvc0007_12.value;
		var settVal_12 = f.selSettlSvc0007_12.value;
		var oldSettVal_13 = f.oldSettlSvc0007_13.value;
		var settVal_13 = f.selSettlSvc0007_13.value;
		
		if(oldSettVal_11 != ""){
			if(settVal_11 != oldSettVal_11){
				IONPay.Msg.fnAlert('저장된 정산지급주체 데이터가 존재합니다.\n변경하실 수 없습니다.(위챗)');
				resultCd = 9999;
				resultMsg = "사업장 주소를 입력해 주세요.";
				resultMap.set("resultCd", resultCd);
				resultMap.set("resultMsg", resultMsg);
				return resultMap;
			}
		}
		
		if(oldSettVal_12 != ""){
			if(settVal_12 != oldSettVal_12){
				IONPay.Msg.fnAlert('저장된 정산지급주체 데이터가 존재합니다.\n변경하실 수 없습니다.(QQPay)');
				resultCd = 9999;
				resultMsg = "사업장 주소를 입력해 주세요.";
				resultMap.set("resultCd", resultCd);
				resultMap.set("resultMsg", resultMsg);
				return resultMap;
			}
		}
		
		if(oldSettVal_13 != ""){
			if(settVal_13 != oldSettVal_13){
				IONPay.Msg.fnAlert('저장된 정산지급주체 데이터가 존재합니다.\n변경하실 수 없습니다.(라카라)');
				resultCd = 9999;
				resultMsg = "사업장 주소를 입력해 주세요.";
				resultMap.set("resultCd", resultCd);
				resultMap.set("resultMsg", resultMsg);
				return resultMap;
			}
		}		
		
		if(chkVal1 =='0' || chkVal2 == '0'){
			IONPay.Msg.fnAlert('VAN과 동기화 되지 않은 데이터가 존재합니다.');
		}
	} */
	resultCd = 0000;
	resultMsg = "success.";
	resultMap.set("resultCd", resultCd);
	resultMap.set("resultMsg", resultMsg);
	return resultMap;
}
function checkCardMemberAuthType(){
	var aPmCd = '01'; //지불수단 - 01:신용카드, 02:계좌이체, 03:가상계좌, 05:휴대폰, 06:휴대폰빌링, 07:일반빌링, 08:안심빌링
	var aSpmCd = '01';
	var aCpCd = ['01','02','03','04','06','07','08','12','25','26','27','28','29','38'];//카드사 - 01:비씨, 02:국민, 03:외환, 04:삼성, 06:신한, 07:현대, 08:롯데, 12:농협 
	
	var CpCdList = { 
		properties:{
			0:{name:'비씨', value:'01'},
			1:{name:'국민', value:'02'},
			2:{name:'하나(외환)', value:'03'},
			3:{name:'삼성', value:'04'},
			4:{name:'신한', value:'06'},
			5:{name:'현대', value:'07'},
			6:{name:'롯데', value:'08'},
			7:{name:'NH(채움)', value:'12'},
			8:{name:'해외비자', value:'25'},
			9:{name:'해외마스터', value:'26'},
			10:{name:'해외다이너스', value:'27'},
			11:{name:'해외AMX', value:'28'},
			12:{name:'해외JCB', value:'29'},
			13:{name:'은련', value:'38'}
		},
		size : 14
	};
	
	var authFlg = $("#insertInfo #authType").val();
	
	// 카드 가맹점 정보 (ex: fn_no_010101) 
	var aInst = ['01', '02'];//무이자 여부
	for(var i = 0; i< aInst.length; i++ ){
		for(var k = 0; k < CpCdList.size; k++) {
			if(aInst[i]=='02' && (CpCdList.properties[k].value == '25' || CpCdList.properties[k].value == '26' ||
					CpCdList.properties[k].value == '27' || CpCdList.properties[k].value == '28' || CpCdList.properties[k].value == '29' || CpCdList.properties[k].value == '38')) continue;
			
			var selVal = eval('f.authType_'+ aInst[i] + aSpmCd + CpCdList.properties[k].value + '.value');
			
			if(selVal =='00'){
				continue;				
			}else{
				if(authFlg =="0"){
					//인증
					if(selVal == '04'){
						return CpCdList.properties[k].name+(aInst[i]=='02'?'(무이자)':'');
					}
				}else{
					//KeyIn && 빌링	
					if(selVal == '02' || selVal =='03'){
						return CpCdList.properties[k].name+(aInst[i]=='02'?'(무이자)':'');
					}
				}
			}
		}
	}
	
	return '';
};
function fnEmailValidate(email){
	// 이메일 주소 유효성 검사
		var check = 1;
		var check1 = 1;
		var cont = 0;
		var c;

		if( email == "" ){
			return true;
		}
			
		c = email.charAt(0);
		if( !( (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c == '-') ) ){
			return false;
		}
		
		c = email.charAt(email.length-1 );
		if( !( (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) ){
			return false;
		}
							
		for(i=1; i<email.length; i++){
			c = email.charAt(i);			
			if( !((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) ){
				if(c == '.' || c == '-' || c == '_' ){
					if(cont==1){
						return false;
					}else{
						check++ ;
					}
				}else if( c == '@'){
					if( check1 == 5 ){
						return false;
					}else{
						check1 =5;
						cont=1;
					}
				}else{
					return false;
				}
			}else{
				cont = 0;
			}
		}

		if( check == 1 ||  check1 == 1){
			return false;
		}
		return true;
}
function fnCardList(){
		//card table 
		var str = "";
		//카드 배열
		var map1 = new Map();
		var map2 = new Map();
		/* jQuery.each(arr, function(){
			
		}); */
			
		var overCard  = ${overCard};
		var majorCard = ${majorCard};
		var minorCard = ${minorCard};
		var stmtCycleCd = ${stmtCycleCd};
		
		var numOverCard  = overCard.length;
		var numMajorCard = majorCard.length;
		var trCnt = 0;
		var tdCnt = 7; 
		trCnt = parseInt((numMajorCard+numOverCard)/tdCnt);
		
		for(var z=0; z <= trCnt; z++){
			str += "<tr style='text-align: center; '>";
			str += "<th style='border: 1px solid #c2c2c2; background-color: #ecf0f2;'></th>";
			for(var i = tdCnt*z; i < tdCnt*(z+1); i++) {
			    var cardNm = "";
			    
			    if(i < numMajorCard) {					
			    	//overCard[I] &&  majorCard[I] 형식으로 하고 카드이름만 셋팅  
			    	cardNm = majorCard[i].DESC1==null?"&nbsp;":majorCard[i].DESC1;
			    	console.log("cardNm : " +cardNm);
			    }
			    else if(i < numMajorCard+numOverCard) {
			    	cardNm = overCard[i-numMajorCard].DESC1==null?"&nbsp;":overCard[i-numMajorCard].DESC1;
			    }
			    else if(i == numMajorCard+numOverCard){	
			    	cardNm = "은련";
			    } else {
			    	cardNm = "&nbsp;";
			    }
			    str+= "<th colspan='2'  style='text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;'> " + cardNm+"</th>";
			}
			str += "</tr><tr><th style='text-align: center;  border: 1px solid #c2c2c2; background-color: #ecf0f2;'>일반</th>";
			for(var i = tdCnt*z; i < tdCnt*(z+1); i++) {
			    var cpCd = "";
				
			    if(i < numMajorCard) {					
			    	cpCd = majorCard[i].CODE1==null?"&nbsp;":majorCard[i].CODE1;
			    }
			    else if(i < numMajorCard+numOverCard) {
			    	cpCd = overCard[i-numMajorCard].CODE1 ==null?"&nbsp;":overCard[i-numMajorCard].CODE1;
			    }
			    else if(i == numMajorCard+numOverCard){	
			    	cpCd = "38";
			    }
			    var terNo = map.get("TERM_NO_0101" +cpCd ) == null ? "&nbsp;" :map.get("TERM_NO_0101" +cpCd ) ;
			    if(i <= numMajorCard+numOverCard) {
			    	//if(terNo != null || terNo != ""){
			    	//	terNo = "(T:"+terNo+")";
			    	//}
			    	str += "<td style='text-align: center; border: 1px solid #c2c2c2; '><input type='hidden' name='oldMbsNo_0101"+cpCd+"'/>";
			        str += "<input type='hidden' name='oldTermNo_0101"+cpCd+"'/>";
				    str += "<input type='hidden' name='oldAuthType_0101"+cpCd+"'/>";
		    		str += "<input type='text' name='selMbsNo_0101"+cpCd+"' class='form-control' > ";
		    		str += "<br><span style='float:left;margin-top: 10%;width: 20%;'>T:</span><input type='text' name='selTermNo_0101"+cpCd+"'  class='form-control' style='width:80%; float:right;'  >"; 
		    		str += "<input type='hidden' name='authType_0101"+cpCd+"' class='form-control'  ></td>";
		    		str += "<td style='text-align: center; border: 1px solid #c2c2c2; '><input type='text' name='chgFee_0101"+cpCd+"' class='form-control' style='width:80%; float:left;' ><span style='margin-top: 8%; float:right;'>%</span></td>";
		    	}else{
		    		str += "<td style='text-align: center; border: 1px solid #c2c2c2; '>&nbsp;</td>";
		    		str += "<td style='text-align: center; border: 1px solid #c2c2c2; '>&nbsp;</td>";
		    	}
		    }
			str += "</tr><tr>";		
		    str += "<th style='text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;'>무이자</th>";	
		    for(var i = tdCnt*z; i < tdCnt*(z+1); i++) {
			    var cpCd= "";
			    
			    if(i < numMajorCard) {					
			    	cpCd = majorCard[i].CODE1==null?"&nbsp;":majorCard[i].CODE1;
			    }
			    else if(i < numMajorCard+numOverCard) {
			    	cpCd = majorCard[i-numMajorCard].CODE1==null?"&nbsp;":majorCard[i-numMajorCard].CODE1;
			    }
			    else if(i == numMajorCard+numOverCard){	
			    	cpCd = "38";
			    }
			    
			    var terNo = map.get("TERM_NO_0201"+cpCd) == null? "&nbsp;":map.get("TERM_NO_0201"+cpCd);
			    //if(terNo != null || terNo != ""){
			    //	terNo = "(T:"+terNo+")";
			    //}
			    if(i < numMajorCard){
			    	str += "<td style='text-align: center; border: 1px solid #c2c2c2; '><input type='hidden' name='oldMbsNo_0201"+cpCd+"'/>";
			        str += "<input type='hidden' name='oldTermNo_0201"+cpCd+"'/>";
				    str += "<input type='hidden' name='oldAuthType_0201"+cpCd+"'/>";
		    		str += "<input type='text' name='selMbsNo_0201"+cpCd+"' class='form-control' onclick='fnSelectMbsNo(\'"+cpCd+"\', '1','01','',selAuthFlg);' > ";
		    		str += "<br><span style='float:left;margin-top: 10%;width: 20%;'>T:</span><input type='text' name='selTermNo_0201"+cpCd+"'  class='form-control' style='width:80%; float:right;' >"; 
		    		str += "<input type='hidden' name='authType_0201"+cpCd+"' class='form-control'  ></td>";
			    	str += "<td style='text-align: center; border: 1px solid #c2c2c2; '> <input type='button' value='보기' id='btnFeeNonInterest' class='btn btn-success btn-cons'  onclick='fnFeeNonInterest("+i+");'></td>";
			    }else{
			    	str += "<td style='text-align: center; border: 1px solid #c2c2c2; '>&nbsp;</td>";
			    	str += "<td style='text-align: center; border: 1px solid #c2c2c2; '>&nbsp;</td>";
			    }
		    } 
		    str += "</tr>";
		}
		str += "<tr><td colspan='2' rowspan='2' style='text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;'>정산주기</td><td colspan='2' rowspan='2' style='text-align: center; border: 1px solid #c2c2c2; '>";
// 		str += "&nbsp;<input type='hidden' name='oldCycle_0101'/>";
// 		if(stmtCycleCd!= null){
// 			if(stmtCycleCd.length > 0 ){
// 				str += "<select class = 'select2 form-control' id='selCycle_0101'  name='selCycle_0101'> ";
// 				for(var i=0; i<stmtCycleCd.length; i++){
// 					str += "<option value='"+stmtCycleCd[i].CODE1+"' >"+stmtCycleCd[i].DESC1+"</option> ";
// 				}				
// 				str += " </select>";
// 			}
// 		}
		str += "<select id='selCycle_0101' name='selCycle_0101' class='select2 form-control'>";
		
		var stmtCycleObj = [
			{"D1" : "일일(+1일)"},
			{"D2" : "일일(+2일)"},
			{"D3" : "일일(+3일)"},
			{"D4" : "일일(+4일)"},
			{"D5" : "일일(+5일)"},
			{"D6" : "일일(+6일)"},
			{"D7" : "일일(+7일)"},
			{"M1" : "월1회"},
			{"M2" : "월2회"},
			{"M4" : "월4회"},
			{"C1" : "결제월+1개월째 5일"},
			{"C106" : "결제월+1개월째 6일"},
			{"C131" : "결제월+1개월째 말일"},
			{"C2" : "결제월+2개월째 5일"},
			{"C3" : "결제월+3개월째 5일"},
		];
		for(var i = 0; i < stmtCycleObj.length; i++){
			var resultObj = stmtCycleObj[i];
			var key = Object.keys(resultObj)[0];
			str += "<option value='"+ key +"'>"+ resultObj[key] +"</option> ";
		}
		str += " </select>";
		
		str += "</td>";
		str +="<td colspan='2' rowspan='2' style='text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;'>사용불가 카드사 <br> (체크시 미사용)</td>";
		str += "<td  style='text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;'>MAJOR</td>";
		str += "<td style='text-align: center; border: 1px solid #c2c2c2; ' colspan='8'><div class='checkbox check-success checkbox_center' style='padding-top:12px; padding-bottom:0;'>";
		var majorLeng = majorCard.length;
		var overLeng = overCard.length;
		var minorLeng = minorCard.length;
		console.log(majorLeng);
	    console.log (overLeng + ", "+minorLeng); 
		 for(var i=0; i<majorLeng; i++){
			str += "<input type='checkbox' id='useMJCard_01"+majorCard[i].CODE1+"' name='useMJCard_01"+majorCard[i].CODE1+"'>";
			str += "<label for='useMJCard_01"+majorCard[i].CODE1+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'>"+majorCard[i].DESC1+"</label>";
		}
		
		str += "</div></td></tr><tr><td style='text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;'>MINOR</td><td style='text-align: center; border: 1px solid #c2c2c2; ' colspan='8'><div class='checkbox check-success checkbox_center' style='padding-top:12px; padding-bottom:0;'>";
		for(var i=0; i < minorLeng; i++ ){
			str += "<input type='checkbox' id='useMICard_01"+minorCard[i].CODE1+"' name='useMICard_01"+minorCard[i].CODE1+"'> ";
			str += "<label for='useMICard_01"+minorCard[i].CODE1+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'>"+minorCard[i].DESC1+"</label>";
			if(i == 8 ){
				str += "<br>";
			}
		}
		str += "<br>";
		for(var i=0; i<overLeng; i++){
			str += "<input type='checkbox' id='useMICard_01"+overCard[i].CODE1+"' name='useMICard_01"+overCard[i].CODE1+"'> ";
			str += "<label for='useMICard_01"+overCard[i].CODE1+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'>"+overCard[i].DESC1+"</label>";
		}
		str += "</div></td></tr>";
	  //card table 결과 
	$("#tbPayMethod #tb_card").html(str);
}
function fnFeeNonInterest(index){
	
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	var aryFrDt = [
			["2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01"],		// 삼성
			["2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01"],		// 비씨
			["2009/02/01","2009/02/01","2009/02/01","2009/02/01","2009/02/01","2009/02/01","2009/02/01","2009/02/01","2009/02/01","2009/02/01","2009/02/01"],		// 국민
			["2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01"],		// 외환
			["2009/02/15","2009/02/15","2009/02/15","2009/02/15","2009/02/15","2009/02/15","2009/02/15","2009/02/15","2009/02/15","2009/02/15","2009/02/15"],		// 신한
			["2009/02/05","2009/02/05","2009/02/05","2009/02/05","2009/02/05","2009/02/05","2009/02/05","2009/02/05","2009/02/05","2009/02/05","2009/02/05"],		// 현대
			["2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01","2009/01/01"],		// 롯데
			["2011/01/01","2011/01/01","2011/01/01","2011/01/01","2011/01/01","2011/01/01","2011/01/01","2011/01/01","2011/01/01","2011/01/01","2011/01/01"]];		// 농협
	var aryCardFee = [
					["1.3","1.3","1.3","1.3","1.3","1.3","1.3","1.3","1.3","1.3","1.3"],		// 삼성
					["1.0","1.0","1.0","1.1","1.1","1.2","1.2","1.3","1.4","1.5","1.5"],		// 비씨
					["1.1","1.1","1.1","1.1","1.1","1.2","1.2","1.2","1.3","1.4","1.5"],		// 국민
					["1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2"],		// 외환
					["1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2"],		// 신한
					["1.1","1.1","1.1","1.1","1.2","1.2","1.2","1.2","1.2","1.2","1.2"],		// 현대
					["1.0","1.0","1.0","1.0","1.0","1.0","1.0","1.0","1.0","1.0","1.0"],		// 롯데
					["1.1","1.1","1.1","1.1","1.1","1.2","1.2","1.2","1.3","1.4","1.5"]];		// 농협
					
	var aryCardNm = ("삼성", "비씨", "KB국민", "하나(외환)", "신한", "현대", "롯데", "NH채움");
	
    $("#modalFeeNonInstCard #nonInstFee").html(aryFrDt[index]+"무이자 수수료 ");					
	var str = "";
	
	for(var i=0; i<=10; i++){
		str += "<tr style='text-align:center;'>";
		str += "<td style='border:1px solid #c2c2c2; background-color:white;'>"+(i+2) +"</td>";
		str += "<td style='border:1px solid #c2c2c2; background-color:white;'>"+ aryCardFee[index][i] +"</td>";
		str += "<td style='border:1px solid #c2c2c2; background-color:white;'>"+ aryFrDt[index][i] +"</td>";
		str += "<tr>";
	}
	
	$("#modalFeeNonInstCard #tbody_result").html(str);
	$("#modalFeeNonInstCard").modal(); 
}

function fnGidPopupRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data != null){
			$("body").addClass("breakpoint-1024 pace-done modal-open ");
			$("#modalGidInfo #gid").html("<c:out value='"+objJson.data[0].GID+"' escapeXml='false' />");
			$("#modalGidInfo #gNm").html("<c:out value='"+objJson.data[0].G_NM+"' escapeXml='false' />");
			$("#modalGidInfo #coNo").html("<c:out value='"+objJson.data[0].CO_NO+"' escapeXml='false' />");
			$("#modalGidInfo #bankCd").html("<c:out value='"+objJson.data[0].BANK_CD+"' escapeXml='false' />");
			$("#modalGidInfo #vaNo").html("<c:out value='"+objJson.data[0].VGRP_NO+"' escapeXml='false' />");
			$("#modalGidInfo #vaNm").html("<c:out value='"+objJson.data[0].VGRP_NM+"' escapeXml='false' />");
			$("#modalGidInfo").modal(); 
		}else{
			IONPay.Msg.fnAlert("data not exist");
		}
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalGidInfo").hide();
	}
}
function fnVidPopupRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data != null){
			$("body").addClass("breakpoint-1024 pace-done modal-open ");
			$("#modalVidInfo #vId").html("<c:out value='"+objJson.data[0].VID+"' escapeXml='false' />");
			$("#modalVidInfo #vNm").html("<c:out value='"+objJson.data[0].VGRP_NM+"' escapeXml='false' />");
			$("#modalVidInfo #coNo").html("<c:out value='"+objJson.data[0].CO_NO+"' escapeXml='false' />");
			$("#modalVidInfo #repNm").html("<c:out value='"+objJson.data[0].REP_NM+"' escapeXml='false' />");
			$("#modalVidInfo #bsKind").html("<c:out value='"+objJson.data[0].BS_KIND+"' escapeXml='false' />");
			$("#modalVidInfo #gdKind").html("<c:out value='"+objJson.data[0].GD_KIND+"' escapeXml='false' />");
			$("#modalVidInfo #email").html("<c:out value='"+objJson.data[0].BS_KIND+"' escapeXml='false' />");
			$("#modalVidInfo #contCharge").html("<c:out value='"+objJson.data[0].CONT_NM+"' escapeXml='false' />");
			$("#modalVidInfo #settleCharge").html("<c:out value='"+objJson.data[0].SETT_NM+"' escapeXml='false' />");
			$("#modalVidInfo #techCharge").html("<c:out value='"+objJson.data[0].TECH_EMP_NM+"' escapeXml='false' />");
			$("#modalVidInfo #bankCd").html("<c:out value='"+objJson.data[0].BANK_CD+"' escapeXml='false' />");
			$("#modalVidInfo #vaNo").html("<c:out value='"+objJson.data[0].ACCNT_NO+"' escapeXml='false' />");
			$("#modalVidInfo #vaNm").html("<c:out value='"+objJson.data[0].ACCNT_NM+"' escapeXml='false' />");
			$("#modalVidInfo #settleCycle").html("<c:out value='"+objJson.data[0].STMT_CYCLE_CD+"' escapeXml='false' />");
			$("#modalVidInfo #rsRate").html("<c:out value='"+objJson.data[0].RSHARE_RATE+"' escapeXml='false' />");
			$("#modalVidInfo").modal(); 
		}else{
			IONPay.Msg.fnAlert("data not exist");
		}
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalVidInfo").hide();
	}
}
function fnSelectApproList(merId){
	if (typeof objInquiryApprove == "undefined") {
		console.log(merId + "1");
        objInquiryApprove = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
            url: "/baseInfoMgmt/baseInfoRegistration/selectApproList.do",
            data: function() {	
                return $("#frmSearch").serializeObject();
            },
            columns: [
                { "class" : "columnc all",         "data" : null, "name" : "reqDt", "render":  function(data, type, full, meta){map.set("frDt", data.FR_DT);	return IONPay.Utils.fnStringToDateFormat(data.FR_DT)} },
                { "class" : "columnc all",         "data" : null, "render": function(data){return data.CO_NO} },
                { "class" : "columnc all",         "data" : null, "render":function(data){return data.CO_NM==null?"":data.CO_NM }},
                { "class" : "columnc all", 			"data" : null, "render":function(data){
                		map.set("id", data.ID);
                		map.set("pmCd", data.PM_CD);
                		map.set("spmCd", data.SPM_CD);
                		map.set("feeTypeCd", data.FEE_TYPE_CD);
                		map.set("cpCd", data.CP_CD);
                		map.set("frAmt", data.FR_AMT);
                		return data.ID
                		} 
                },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.PM_NM}},
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.BEFORE_AVG_FEE} },
                { "class" : "columnc all", 			"data" : null, "render": function(data){
	                	var str = "";
	                	if(data.PM_CD == "01" || data.PM_CD == "03"){
	                		console.log(merId + "2");
	                		if(map.get("merId") == "VID"){
	                			str += data.AFTER_AVG_FEE; 
	                		}else if(map.get("merId")== "MID"){
	                			str = "<b><a href='#' onclick=\"fnFeeRegLst(\'"+data.ID+"' ,'"+data.PM_CD +"' ,'"+ data.SPM_CD+"' ,'"+ data.FR_DT+"','"+data.CP_CD + "\') ; \"> "+ data.AFTER_AVG_FEE+ " </a></b>&nbsp; ";
	                		}
	                	}else{
	                		str =data.AFTER_AVG_FEE;
	                	}
	                	return str;
                		
                	}
                },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.REG_DNT)} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){
	                	var str = "";
	                	console.log(merId + "3");
	                	if(data.STATUS == "0"){
	                		map.set("merId" , merId);
	                		str = "<input type='button' id='btnApprove' value='승인' class='btn btn-info btn-sm btn-cons'	onclick='fnChgStatus("+map+", this);'>";
	                	}else if(data.STATUS == "2"){
	                		str = data.STATUS_NM;
	                	}
	                	return str;
	                	} 
	                },
	            	{ "class" : "columnc all", 			"data" : null, "render":function(data, type, full, meta){
	            		console.log(merId + "4");
	            		console.log(map);
	            		return "<input type='button' id='btnReturn' value='반려' class='btn btn-info btn-sm btn-cons' onclick='fnChgStatus(map, this);'>"; 
	            		}
	            	}
                ]
        }, true);
    } else {
    	console.log(merId + " : RELOAD");
        objInquiryApprove.clearPipeline();
        objInquiryApprove.ajax.reload();
    }

    IONPay.Utils.fnShowSearchArea();
    IONPay.Utils.fnHideSearchOptionArea();
}
function fnSelectMbsNo(cpCd, nonInst, memberCl, joinType, mbsNo, authFlg){
	strModalID = "modalSelectMbsNo";
	arrParameter = {
            "cpCd" : cpCd,
            "nonInst" : nonInst,
            "memberCl" : memberCl,
            "joinType" : joinType,
            "mbsNo" : mbsNo,
            "authFlg" : authFlg
            };
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectMbsNo.do";
    strCallBack  = "fnSelectMbsNoRet";
}
function fnFeeRegLst(id, pmCd, spmCd, frDt, cpCd){
	arrParameter["id"]    = id;
	if(pmCd == "01"){
		if(cpCd == "25"||cpCd == "27"||cpCd == "28"||cpCd == "29"||cpCd == "38"){
			strModalID = "modalFeeRegOverCardLst";
			arrParameter["pmCd"]    = pmCd;
			arrParameter["spmCd"]    = spmCd;
			arrParameter["frDt"]    = frDt;
			strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectFeeRegOverCardLst.do";
	        strCallBack  = "fnFeeRegOverCardLstRet";
		} else{
			strModalID = "modalFeeRegCardLst";
			arrParameter["pmCd"]    = pmCd;
			arrParameter["spmCd"]    = spmCd;
			arrParameter["frDt"]    = frDt;
			strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectFeeRegCardLst.do";
	        strCallBack  = "fnFeeRegCardLstRet";
		} 
	}else if(pmCd == "03"){ //가상계좌
		strModalID = "modalFeeRegVacctLst";
		arrParameter["spmCd"]    = spmCd;
		arrParameter["frDt"]    = frDt;
		//strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectGidInfo.do";
        strCallBack  = "fnVacctPopupRet";
	}
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnFeeRegOverCardLstRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.cardList != null){
		$("body").addClass("breakpoint-1024 pace-done modal-open ");
		var str = "";
		for(var i=0; i<objJson.cardList.length; i++){
			var pmCd = map.get("pmCd");
			var spmCd = map.get("spmCd");
			var cpCd = map.get("cpCd");
			var fee = "FEE_"+pmCd+spmCd+cpCd;
			var frDt = "FR_DT_" + pmCd+spmCd+cpCd;
			
			if(objJson.feeAddList != null){
				for(var j=0; j<objJson.feeAddList.length;j++){
					var listObj = objJson.feeAddList[j];
					console.log(listObj[fee]);	
					var feeVal = listObj[fee];
					console.log(listObj[frDt]);	
					var frDtVal = listObj[frDt];
				}
			}
			
			str += "<tr style='text-align:center;'>";
			str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.cardList[i].DESC1+"</td>";
			str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+feeVal+"%</td>";
			str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+frDtVal+"부터</td>";
			str += "</tr>";
		}
				
		//화면 셋팅 
		$("#tbody_feeRegOverCardList").html(str);
		//모달 
		$("#modalFeeRegOverCardLst").modal(); 
		}else{
			IONPay.Msg.fnAlert("data not exist");	
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalFeeRegOverCardLst").hide();
	}
}
function fnFeeRegCardLstRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.cardList != null){
		$("body").addClass("breakpoint-1024 pace-done modal-open ");
		var str = "";
		for(var i=0; i<objJson.cardList.length; i++){
			var pmCd = map.get("pmCd");
			var spmCd = map.get("spmCd");
			var cpCd = map.get("cpCd");
			var fee = "FEE_"+pmCd+spmCd+cpCd;
			var frDt = "FR_DT_" + pmCd+spmCd+cpCd;
			
			if(objJson.feeAddList != null){
				for(var j=0; j<objJson.feeAddList.length;j++){
					var listObj = objJson.feeAddList[j];
					console.log(listObj[fee]);	
					var feeVal = listObj[fee];
					console.log(listObj[frDt]);	
					var frDtVal = listObj[frDt];
					//포인트 fee????
				}
			}
			
			str += "<tr style='text-align:center;'>";
			str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.cardList[i].DESC1+"</td>";
			str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+feeVal+"%</td>";
			str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+0+"%</td>";
			str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+frDtVal+"부터</td>";
			str += "</tr>";
		}
				
		//화면 셋팅 
		$("#tbody_feeRegCardList").html(str);
		//모달 
		$("#modalFeeRegCardLst").modal(); 
		}else{
			IONPay.Msg.fnAlert("data not exist");	
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalFeeRegCardLst").hide();
	}
}

function fnChgStatus(map, value){
	//parameter 셋팅
	var mid = "";
	if(value.name=="btnApprove"){
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["merId"]    = map.get("merId");
		arrParameter["status"]    = "1";
		arrParameter["index"]    = map.get("index");
		arrParameter["id"]    = map.get("id");
		arrParameter["regFrDt"]    = map.get("frDt");
		arrParameter["pmCd"]    = map.get("pmCd");
		arrParameter["spmCd"]    = map.get("spmCd");
		arrParameter["feeTypeCd"]    = map.get("feeTypeCd");
		arrParameter["cpCd"]    = map.get("cpCd");
		arrParameter["frAmt"]    = map.get("frAmt");
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/merchantReg.do";
		strCallBack  = "fnUpdateRet";
		
	}else if(value.name="btnReturn"){
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["merId"]    = map.get("merId");
		arrParameter["status"]    = "2";
		arrParameter["index"]    = map.get("index");
		arrParameter["id"]    = map.get("id");
		arrParameter["frDt"]    = map.get("frDt");
		arrParameter["pmCd"]    = map.get("pmCd");
		arrParameter["spmCd"]    = map.get("spmCd");
		arrParameter["feeTypeCd"]    = map.get("feeTypeCd");
		arrParameter["cpCd"]    = map.get("cpCd");
		arrParameter["frAmt"]    = map.get("frAmt");
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/merchantReg.do";
		strCallBack  = "fnUpdateRet";
	}
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnDupIdChk(ID, TYPE){
	if(ID.length<9){
		IONPay.Msg.fnAlert(TYPE + "는 9자리가 유효합니다.");
	}else{
		if(TYPE == 'MID'){
			arrParameter["MID"]    = $("#insertInfo #MID").val()+ "m";
			strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/dupIdChk.do";
			strCallBack  = "fnDupMidChkRet";
		}else if(TYPE == 'GID'){
			arrParameter["GID"]    = $("#frmGidInfo #GID").val()+"g";
			strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/dupIdChk.do";
			strCallBack  = "fnDupGidChkRet";
		}else if(TYPE == 'VID'){
			arrParameter["VID"]    = $("#frmVidInfo #VID").val()+"v";
			strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/dupIdChk.do";
			strCallBack  = "fnDupVidChkRet";
		}
		
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}
function serAccntConfirm(type){
	var bankCd, chgAccntNm, chgAccntNo, chkAccnt;
	
	bankCd 		= $("#insertInfo #bankCd").val();
	chgAccntNm 	= f.chgAccntNm;
	chgAccntNo 	= f.chgAccntNo;
	chkAccnt 	= f.chkAccnt;

	if(document.mainForm.regType.value == 'Update') {
		if(chkAccnt.value == "false"){		
			if(bankCd.value ==""){
				IONPay.Msg.fnAlert("은행코드를 입력해주세요.");
				bankCd.focus();
				return false;
			}else if(chgAccntNm.value ==""){
				IONPay.Msg.fnAlert("예금주명을 입력해주세요.");
				chgAccntNm.focus();
				return false;
			}else if(chgAccntNo.value ==""){
				IONPay.Msg.fnAlert("계좌번호를 입력해주세요.");
				chgAccntNo.focus();
				return false;
			}
		}else{
			IONPay.Msg.fnAlert("성명조회가 완료된 건입니다.");
			return false;
		}
			
	   	$.ajax({
	        type : "POST" 
	        , async : true 
	        , url : "ConfirmAccntNo.jsp" 
	        , dataType : "json" 
	        , data : {
	        	"chgMID": f.chgMID.value,
	        	"selBankCd": bankCd.value,
	        	"chgAccntNm": chgAccntNm.value,
	        	"chgAccntNo": chgAccntNo.value
	        }
	        , contentType: "application/x-www-form-urlencoded; charset=UTF-8"
	        , error : function(request, status, error) {
	         	IONPay.Msg.fnAlert("code : " + request.status + "\r\nmessage : " + request.reponseText);
	        }
	        , success : function(result) {
	        	var resultMsg = result.resultMsg;
	        	var resultCode = result.resultCd;
	        	
	        	if(resultCode == '0000') {
	        		var matchCl = result.matchCl;
	        		
	        		if(matchCl == 1){
	           			IONPay.Msg.fnAlert("예금주명 확인 성공");
	           			chkAccnt.value = "true";        		        			
	        		}else{
	        			IONPay.Msg.fnAlert("예금주명이 일치하지 않습니다.");
	        		}

	        	}else{
	        		IONPay.Msg.fnAlert(resultMsg);
	        	}
	        	
	        	return false;
	        	}
	  	});	

	}else {
		IONPay.Msg.fnAlert('MID 등록을 먼저 해주세요.');
	}
};
/** MID 등록 시 또는 MID Update 시 **/
function changeState() {
	$("#insertInfo #chkID").val("true");
	$("#insertInfo #regMID").val("true");
	$("#insertInfo #regType").val("update");
	
	// MID, GID, AID 수정 불가
	$("#insertInfo #MID").readOnly = "true";
	$("#insertInfo #GID").readOnly = "true";
	$("#insertInfo #VID").readOnly = "true";
	$("#insertInfo #btnDupMidChk").disabled= "true";
};
function fnDupMidChkRet(objJson){
	if (objJson.resultCode == 0) {
		$("#insertInfo #chkID").val("true");
        IONPay.Msg.fnAlert("사용가능한 MID입니다.");
        if($("#listSearchCollapse").hasClass("collapse") === true)
	    	$("#listSearchCollapse").click();
		$("#ListSearch").hide();
	    IONPay.Utils.fnHideSearchOptionArea();
    	$("#Information").show();
    	if($("#informationCollapse").hasClass("collapse") === false)
	    	$("#informationCollapse").click();
    	$("#OtherInformation").show();
    	if($("#otherInformationCollapse").hasClass("collapse") === false)
	    	$("#otherInformationCollapse").click();
    	$("#CalculationInformation").show();
    	if($("#calculationInformationCollapse").hasClass("collapse") === false)
	    	$("#calculationInformationCollapse").click();
    	$("#PayMethodArea").show();
    	if($("#payMethodCollapse").hasClass("collapse") === false)
	    	$("#payMethodCollapse").click();
    	$("#ForeignPayment").show();
    	if($("#foreignPaymentCollapse").hasClass("collapse") === false)
	    	$("#foreignPaymentCollapse").click();
    	$("#Others").show();
    	if($("#othersCollapse").hasClass("collapse") === false)
	    	$("#othersCollapse").click();
    } else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);	
    }
}
function fnDupGidChkRet(objJson){
	//gid
	if(objJson.resultCode == 0){
		 IONPay.Msg.fnAlert("사용가능한 GID입니다.");
		$("#midRegInfo").hide();
		$("#gidRegInfo").show(200);
		$("#vidRegInfo").hide();
	}else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);	
    }
}
function fnDupVidChkRet(objJson){
	//vid
	if(objJson.resultCode == 0){
		 IONPay.Msg.fnAlert("사용가능한 VID입니다.");
		$("#midRegInfo").hide();
		$("#gidRegInfo").hide();
		$("#vidRegInfo").show(200);
	}else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);	
    }
}
function fnSelectBaseInfo(){
	arrParameter = $("#frmSearch").serializeObject();
	if($("#MER_SEARCH option:selected").text() == "MID"){
		arrParameter["MER_VAL"]    = '2';
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		arrParameter["SHOP_TYPE"]    = $("#insertInfo #MALL_TYPE_CD").val();
		
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectBaseInfo.do";
		strCallBack  = "fnSelectBaseInfoRet";
	}else if($("#MER_SEARCH option:selected").text() == "GID"){
		arrParameter["MER_VAL"]    = '3';
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectBaseInfo.do";
		strCallBack  = "fnSelectGidInfoRet";
	}else if($("#MER_SEARCH option:selected").text() == "VID"){
		arrParameter["MER_VAL"]    = '4';
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectBaseInfo.do";
		strCallBack  = "fnSelectVidInfoRet";
	}
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectBaseInfoRet(objJson){
	if (objJson.resultCode == 0) {
		var map = new Map();
		//var pmCd = ("01", "02", "03", "05", "06", "07", "10", "11", "12", "13");
	  	//var spmCd = ("01", "03", "04", "05"); //"01", "02", "03"
	  	var pmCd = ["01", "02", "03", "05", "06", "07", "10", "11", "12", "13"];
	  	var spmCd = ["01", "03", "04", "05"]; //"01", "02", "03"
		if(objJson.midInfo != null){
			var mid = objJson.midInfo[0].MID.substr(0,9);
			var gid = objJson.midInfo[0].GID.substr(0,9);
			var vid = objJson.midInfo[0].VID.substr(0,9);
			if(objJson.midInfo.length > 0 ){
				$("#insertInfo #MID").val(mid);
				$("#insertInfo #GID").val(gid);
				$("#insertInfo #VID").val(vid);
				$("#insertInfo #CO_NO").val(objJson.midInfo[0].CO_NO);
				$("#insertInfo #MerchantName").val(objJson.midInfo[0].CO_NM);
				$("#insertInfo #RepersentativeName").val(objJson.midInfo[0].REP_NM);
				$("#insertInfo #TEL_NO").val(objJson.midInfo[0].TEL_NO);
				$("#insertInfo #FAX_NO").val(objJson.midInfo[0].FAX_NO);
				$("#insertInfo #EMAIL").val(objJson.midInfo[0].EMAIL);
				$("#insertInfo #URL").val(objJson.midInfo[0].MID_URL);
				$("#insertInfo #ClassificationBusiness").val(objJson.midInfo[0].BS_KIND);
				$("#insertInfo #BusinessStatus").val(objJson.midInfo[0].GD_KIND);
				$("#insertInfo #Address1").val(objJson.midInfo[0].POST_NO);
				$("#insertInfo #Address2").val(objJson.midInfo[0].ADDR_NO1);
				$("#insertInfo #Address3").val(objJson.midInfo[0].ADDR_NO2);
				$("#insertInfo #BusinessAddr1").val(objJson.midInfo[0].RPOST_NO);
				$("#insertInfo #BusinessAddr2").val(objJson.midInfo[0].RADDR_NO1);
				$("#insertInfo #BusinessAddr3").val(objJson.midInfo[0].RADDR_NO2);
				$("#insertInfo #SIGN_NM").val(objJson.midInfo[0].SIGN_NM);
				$("#insertInfo #CONT_EMP_NM").val(objJson.midInfo[0].CONT_EMP_NM);
				$("#insertInfo #CONT_EMP_TEL").val(objJson.midInfo[0].CONT_EMP_TEL);
				$("#insertInfo #CONT_EMP_HP").val(objJson.midInfo[0].CONT_EMP_HP);
				$("#insertInfo #CONT_EMP_EMAIL").val(objJson.midInfo[0].CONT_EMP_EMAIL);
				$("#insertInfo #STMT_EMP_NM").val(objJson.midInfo[0].STMT_EMP_NM);
				$("#insertInfo #STMT_EMP_TEL").val(objJson.midInfo[0].STMT_EMP_TEL);
				$("#insertInfo #STMT_EMP_CP").val(objJson.midInfo[0].STMT_EMP_CP);
				$("#insertInfo #STMT_EMP_EMAIL").val(objJson.midInfo[0].STMT_EMP_EMAIL);
				$("#insertInfo #TECH_EMP_NM").val(objJson.midInfo[0].TECH_EMP_NM);
				$("#insertInfo #TECH_EMP_TEL").val(objJson.midInfo[0].TECH_EMP_TEL);
				$("#insertInfo #TECH_EMP_CP").val(objJson.midInfo[0].TECH_EMP_CP);
				$("#insertInfo #TECH_EMP_EMAIL").val(objJson.midInfo[0].TECH_EMP_EMAIL);
				
				//hardcoding 
				$("#insertInfo #UseTPayMobileUnauthorizedYN").select2("val", "0");
				
				$("#insertInfo #UseStatus").select2("val", objJson.midInfo[0].USE_CL);
				$("#insertInfo #MBS_TYPE_CD").select2("val", objJson.midInfo[0].MBS_TYPE_CD);
				$("#insertInfo #CompanyType").select2("val", objJson.midInfo[0].CO_CL_CD);
				$("#insertInfo #MALL_TYPE_CD").select2("val", objJson.midInfo[0].MALL_TYPE_CD);
				$("#insertInfo #RECV_CH_CD").select2("val", objJson.midInfo[0].RECV_CH_CD);
				
				var bsKindCd = objJson.midInfo[0].BS_KIND_CD;
				var kindCd = "";
				if(bsKindCd == null){
					
				}else{
					kindCd = bsKindCd.split(":")
					$("#insertInfo #BS_KIND_CD").select2("val", kindCd[0]);
				}
				
				if(objJson.cateList != null ){
					for(var i=0; i<objJson.cateList.length; i++){
						if(objJson.cateList[i].CODE2 == kindCd[1]){
							$("#insertInfo #SmallCategory").select2("val", kindCd[1]);
						}
					}
				}
				$("#tbOtherInformation #CSHRCPT_AUTO_FLG").select2("val", objJson.midInfo[0].CSHRCPT_AUTO_FLG);
				$("#tbOtherInformation #PAY_NOTI_CD").select2("val", objJson.midInfo[0].PAY_NOTI_CD);
				$("#tbOtherInformation #RCPT_PRT_TYPE").select2("val", objJson.midInfo[0].RCPT_PRT_TYPE);
				$("#tbOtherInformation #VAT").select2("val", objJson.midInfo[0].VAT_MARK_FLG);
				$("#tbOtherInformation #RECV_CH_CD").select2("val", objJson.midInfo[0].VACCT_LMT_DAY);
				$("#tbOtherInformation #VACCT_ISS_TYPE").select2("val", objJson.midInfo[0].VACCT_ISS_TYPE);
				$("#tbOtherInformation #UnsentAutoCancle").select2("val", objJson.midInfo[0].AUTO_CANCEL_FLG);
				$("#tbOtherInformation #PhoneFeeSection").select2("val", objJson.midInfo[0].CP_SLIDING_TYPE);
				$("#tbOtherInformation #APP_VAN1_CD").select2("val", objJson.midInfo[0].APP_VAN1_CD);
				$("#tbOtherInformation #ACQ_VAN_CD").select2("val", objJson.midInfo[0].ACQ_VAN_CD);
				$("#tbOtherInformation #PUSH_PAY_CD").select2("val", (objJson.midInfo[0].PUSH_PAY_CD==null?"0":objJson.midInfo[0].PUSH_PAY_CD));
				if(objJson.midInfo[0].SMS_PUSH_FLG == "1"){
					$("#tbOtherInformation #PushFailedSMS").$("#PushFailedSMS").prop("checked", true);
				}
				$("#tbOtherInformation #MBS_KEY_AUTH_FLG").select2("val", objJson.midInfo[0].MBS_KEY_AUTH_FLG);
				$("#tbOtherInformation #MMS_PAY_FLG").select2("val", objJson.midInfo[0].MMS_PAY_FLG);
				$("#tbOtherInformation #ORD_NO_DUP_FLG").select2("val", objJson.midInfo[0].ORD_NO_DUP_FLG);
				
				$("#tbCalculationInformation #ACQ_CL_CD").select2("val", objJson.midInfo[0].ACQ_CL_CD);
				$("#tbCalculationInformation #ACQ_DAY").select2("val", objJson.midInfo[0].ACQ_DAY);
				$("#tbCalculationInformation #PAY_ID_CD").select2("val", objJson.midInfo[0].PAY_ID_CD);
				$("#tbCalculationInformation #CC_CL_CD").select2("val", objJson.midInfo[0].CC_CL_CD);
				$("#tbCalculationInformation #CC_ChkFlg").select2("val", objJson.midInfo[0].CC_CHK_FLG);
				$("#tbCalculationInformation #autoCancel").select2("val", objJson.midInfo[0].AUTO_CAL_FLG);
				//$("#tbCalculationInformation #bankCd").select2("val", objJson.midInfo[0].BANK_CD);
				$("#tbCalculationInformation #ACCNT_NO").val(objJson.midInfo[0].ACCNT_NO);
				$("#tbCalculationInformation #ACCNT_NM").val(objJson.midInfo[0].ACCNT_NM);
				
				if( objJson.midInfo[0].CC_PART_CL == "000"){
					//미사용
				}else if( objJson.midInfo[0].CC_PART_CL == "100"){
					//card
					$("#tbCalculationInformation #PartialCancelFunctionCredit").prop("checked", true);
				}else if( objJson.midInfo[0].CC_PART_CL == "010"){
					//계좌이체
					$("#tbCalculationInformation #PartialCancelFunctionVACCT").prop("checked", true);
				}else if( objJson.midInfo[0].CC_PART_CL == "001"){
					//가상계좌
				}else if( objJson.midInfo[0].CC_PART_CL == "110"){
					//카드+계좌이체
					$("#tbCalculationInformation #PartialCancelFunctionCredit").prop("checked", true);
					$("#tbCalculationInformation #PartialCancelFunctionVACCT").prop("checked", true);
				}else if( objJson.midInfo[0].CC_PART_CL == "999"){
					//...나머지
				}
				if(objJson.settleServiceInfo != null){
					$("#tbCalculationInformation #oldSettlSvc0001").val(objJson.settleServiceInfo[0].STMT_SVC_VALUE);
				}
				if(objJson.payType != null){
					$("#PayMethodArea input[name=oldUseCl_0101]").val(objJson.payType[0].USE_CL);
					$("#PayMethodArea #selUseCl_0101").select2("val",objJson.payType[0].USE_CL);
				}
				$("#PayMethodArea #LMT_INSTMN").select2("val",objJson.midInfo[0].LMT_INSTMN);
			}
			if(objJson.settleFee != null){
				for(var i = 0; i < objJson.settleFee.length; i++) {
					var id = objJson.settleFee[i].PM_CD +objJson.settleFee[i].SPM_CD+objJson.settleFee[i].CP_CD;
		   	   		
					map.set("fee_"+id, objJson.settleFee[i].FEE);
					map.set("fee_mark"+id, objJson.settleFee[i].FEE_TYPE_CD);
					//mapf.put("fee_mark"+id, dm.getStr("fee_type"));
					
				}
			}else{
				if(objJson.compFee != null){
					$("#insertInfo #defaultCoFee").val("true");
				}	
			}
				
			if(objJson.cardInfo != null){
		  		for(var i = 0; i < objJson.cardInfo.length; i++) {
		  		    /* if(objJson.cardInfo[i].PM_CD != "02"){
		  			    var mbsNo = "mbsNo_"+ objJson.cardInfo[i].NON_INST + objJson.cardInfo[i].SPM_CD + objJson.cardInfo[i].CP_CD;
		  			    map.set(mbsNo, objJson.cardInfo[i].MBS_NO);
		  			    
		  			    var termNo= "termNo_"+objJson.cardInfo[i].NON_INST+ objJson.cardInfo[i].SPM_CD + objJson.cardInfo[i].CP_CD;
		  			  	map.set(termNo, objJson.cardInfo[i].TERM_NO);
		  		    } */
		  			var id = "mbsNo_"+objJson.cardInfo[i].NON_INST+objJson.cardInfo[i].SPM_CD+objJson.cardInfo[i].CP_CD;
		  			map.set(id, objJson.cardInfo[i].MBS_NO);
		  			var id2 = "termNo_"+objJson.cardInfo[i].NON_INST+objJson.cardInfo[i].SPM_CD+objJson.cardInfo[i].CP_CD;
		  			map.set(id2, objJson.cardInfo[i].TERM_NO);
		  			var id3 = "authType_"+objJson.cardInfo[i].NON_INST+objJson.cardInfo[i].SPM_CD+objJson.cardInfo[i].CP_CD;
		  			map.set(id3, objJson.cardInfo[i].AUTH_TYPE_CD);
		  		    
		  		  }
		  	}
		  	if(objJson.settleCycle != null){
				if(objJson.settleCycle.length > 0 ){
				  	var isSetCycle = false;
			  		for(var i=0; i<pmCd.length; i++){
				  		for(var j=0; j<spmCd.length; j++){
				  			var settCycle = "미정산";
				  			var settType = "";
				  			
				  			for(var k=0; k<objJson.settleCycle.length; k++){
				  				settType  = objJson.settleCycle[i].STMT_TYPE_NM;
				  				if((objJson.settleCycle[k].PM_CD == pmCd[i]) && (objJson.settleCycle[k].SPM_CD==spmCd[j])){
				  					settCycle = objJson.settleCycle[k].SETTLMNT_CYCLE_NM;
				  					isSetCycle = true;
				  					break;
				  				}
				  			}
				  			map.set("stmtCycle_" + pmCd[i] + spmCd[j] , settCycle);
				  			map.set("stmtType_" + pmCd[i] + spmCd[j] , settType);
				  			$("#midInfo #stmtCyc").html(map.get("stmtCycle_0101"));
				  			if(isSetCycle) break;
				  		}
				  		if(isSetCycle) break;
				  	}
				}
			}
		}
		  	if(objJson.useCard != null){
				//사용카드사 
				var cardUseIn = "";
				var cardUseSm = "";
				var cardUseCp = "";
				var cardUseBill = "";
				
				for(var i=0; i<objJson.useCard.length; i++){
					if(objJson.useCard[i].INTERNET == "FALSE"){
						cardUseIn += objJson.useCard[i].DESC1 + ":";
						console.log(cardUseIn);
					}
				}
				//card table 
				var str = "";
				//카드 배열
				var numOverCard  = objJson.overCardCd.length;
				var numMajorCard = objJson.majorCardCd.length;
				var trCnt = 0;
				var tdCnt = 7; 
				trCnt = parseInt((numMajorCard+numOverCard)/tdCnt);
				
				for(var z=0; z <= trCnt; z++){
					str += "<tr style='text-align: center; '>";
					str += "<th style='border: 1px solid #ddd; background-color: #ecf0f2;'></th>";
					for(var i = tdCnt*z; i < tdCnt*(z+1); i++) {
					    var cardNm = "";
					    
					    if(i < numMajorCard) {					
					    	cardNm = objJson.majorCardCd[i].DESC1==null?"&nbsp;":objJson.majorCardCd[i].DESC1;
					    	console.log("cardNm : " +cardNm);
					    }
					    else if(i < numMajorCard+numOverCard) {
					    	cardNm = objJson.overCardCd[i-numMajorCard].DESC1==null?"&nbsp;":objJson.overCardCd[i-numMajorCard].DESC1;
					    }
					    else if(i == numMajorCard+numOverCard){	
					    	cardNm = "은련";
					    } else {
					    	cardNm = "&nbsp;";
					    }
					    str+= "<th colspan='2'  style='text-align: center; border: 1px solid #ddd; background-color: #ecf0f2;'> " + cardNm+"</th>";
					}
					str += "</tr><tr><th style='text-align: center;  border: 1px solid #ddd; background-color: #ecf0f2;'>일반</th>";
					for(var i = tdCnt*z; i < tdCnt*(z+1); i++) {
					    var cpCd = "";
						
					    if(i < numMajorCard) {					
					    	cpCd = objJson.majorCardCd[i].CODE1==null?"&nbsp;":objJson.majorCardCd[i].CODE1;
					    }
					    else if(i < numMajorCard+numOverCard) {
					    	cpCd = objJson.overCardCd[i-numMajorCard].CODE1 ==null?"&nbsp;":objJson.overCardCd[i-numMajorCard].CODE1;
					    }
					    else if(i == numMajorCard+numOverCard){	
					    	cpCd = "38";
					    }
					    var terNo = map.get("termNo_0101" +cpCd ) == null ? "&nbsp;" :map.get("termNo_0101" +cpCd ) ;
					    if(i <= numMajorCard+numOverCard) {
					    	//if(terNo != null || terNo != ""){
					    	//	terNo = "(T:"+terNo+")";
					    	//}
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '><input type='hidden' name='oldMbsNo_0101"+cpCd+"'/>";
					        str += "<input type='hidden' name='oldTermNo_0101"+cpCd+"'/>";
						    str += "<input type='hidden' name='oldAuthType_0101"+cpCd+"'/>";
				    		str += "<input type='text' name='selMbsNo_0101"+cpCd+"' class='form-control' > ";
				    		str += "<br><span style='float:left;margin-top: 10%;width: 20%;''>T:</span><input type='text' name='selTermNo_0101"+cpCd+"'  class='form-control' style='width: 80%;float:right;' >"; 
				    		str += "<input type='hidden' name='authType_0101"+cpCd+"' class='form-control'  ></td>";
				    		str += "<td style='text-align: center; border: 1px solid #ddd; '><input type='text' name='chgFee_0101"+cpCd+"' class='form-control' style='float:left; width:80%;'  ><span style='margin-top: 8%; float:right;'>%</span></td>";
				    	}else{
				    		str += "<td style='text-align: center; border: 1px solid #ddd; '>&nbsp;</td>";
				    		str += "<td style='text-align: center; border: 1px solid #ddd; '>&nbsp;</td>";
				    	}
				    }
					str += "</tr><tr>";		
				    str += "<th style='text-align: center; border: 1px solid #ddd; background-color: #ecf0f2;'>무이자</th>";	
				    for(var i = tdCnt*z; i < tdCnt*(z+1); i++) {
					    var cpCd= "";
					    
					    if(i < numMajorCard) {					
					    	cpCd = objJson.majorCardCd[i].CODE1==null?"&nbsp;":objJson.majorCardCd[i].CODE1;
					    }
					    else if(i < numMajorCard+numOverCard) {
					    	cpCd = objJson.majorCardCd[i-numMajorCard].CODE1==null?"&nbsp;":objJson.majorCardCd[i-numMajorCard].CODE1;
					    }
					    else if(i == numMajorCard+numOverCard){	
					    	cpCd = "38";
					    }
					    
					    var terNo = map.get("termNo_0201"+cpCd) == null? "&nbsp;":map.get("termNo_0201"+cpCd);
					    if(terNo != null || terNo != ""){
					    	terNo = "(T:"+terNo+")";
					    }
					    if(i < numMajorCard){
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '><input type='hidden' name='oldMbsNo_0201"+cpCd+"'/>";
					        str += "<input type='hidden' name='oldTermNo_0201"+cpCd+"'/>";
						    str += "<input type='hidden' name='oldAuthType_0201"+cpCd+"'/>";
				    		str += "<input type='text' name='selMbsNo_0201"+cpCd+"' class='form-control' onclick='fnSelectMbsNo(\'"+cpCd+"\', '1','01','',selAuthFlg);' > ";
				    		str += "<br><span style='float:left;margin-top: 10%;width: 20%;'>T:</span><input type='text' name='selTermNo_0201"+cpCd+"'  class='form-control' style='width: 80%;float:right;'  >"; 
				    		str += "<input type='hidden' name='authType_0201"+cpCd+"' class='form-control'  ></td>";
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '> <input type='button' value='보기' id='btnFeeNonInterest' class='btn btn-success btn-cons'  onclick='fnFeeNonInterest("+i+");'></td>";
					    }else{
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '>&nbsp;</td>";
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '>&nbsp;</td>";
					    }
				    } 
				    str += "</tr>";
				}
				str += "<tr><td colspan='2' rowspan='2' style='text-align: center; border: 1px solid #ddd; background-color:#ecf0f2;' >정산주기</td><td colspan='2' rowspan='2' style='text-align: center; border: 1px solid #ddd; '>";
				str += "<select id='selCycle_0101'name='selCycle_0101' class='select2 form-control'>";
				
				var stmtCycleObj = [
					{"D1" : "일일(+1일)"},
					{"D2" : "일일(+2일)"},
					{"D3" : "일일(+3일)"},
					{"D4" : "일일(+4일)"},
					{"D5" : "일일(+5일)"},
					{"D6" : "일일(+6일)"},
					{"D7" : "일일(+7일)"},
					{"M1" : "월1회"},
					{"M2" : "월2회"},
					{"M4" : "월4회"},
					{"C1" : "결제월+1개월째 5일"},
					{"C106" : "결제월+1개월째 6일"},
					{"C131" : "결제월+1개월째 말일"},
					{"C2" : "결제월+2개월째 5일"},
					{"C3" : "결제월+3개월째 5일"},
				];
				for(var i = 0; i < stmtCycleObj.length; i++){
					var resultObj = stmtCycleObj[i];
					if(objJson.settleCycle[i] != null && (Object.keys(resultObj)[0] == objJson.settleCycle[i].STMT_CYCLE_CD)){
						str += "<option value='"+objJson.settleCycle[i].STMT_CYCLE_CD+"' selected>"+objJson.settleCycle[i].SETTLMNT_CYCLE_NM+"</option> ";
					}else{
						var key = Object.keys(resultObj)[0];
						str += "<option value='"+ key +"'>"+ resultObj[key] +"</option> ";
					}
				}
				str += " </select>";
				
				str += "</td><td colspan='2' rowspan='2' style='text-align: center; border: 1px solid #ddd;background-color:#ecf0f2; '>사용불가 카드사 <br> (체크시 미사용)</td>";
				str += "<td  style='text-align: center; border: 1px solid #ddd; '>MAJOR</td>";
				str += "<td colspan='8' style='text-align: center; border: 1px solid #ddd; '> <div class='checkbox check-success checkbox_center' style='padding-top:12px; padding-bottom:0; margin-left:5%; ' >";
				var majorLeng = objJson.majorCardCd.length;
				var overLeng = objJson.overCardCd.length;
				var minorLeng = objJson.minorCardCd.length;
				console.log(majorLeng);
			    console.log (minorLeng); 
 			 	for(var i=0; i<majorLeng; i++){
					str += "<input type='checkbox' id='useMJCard_01"+objJson.majorCardCd[i].CODE1+"' name='useMJCard_01"+objJson.majorCardCd[i].CODE1+"'>";
					str += "<label for='useMJCard_01"+objJson.majorCardCd[i].CODE1+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'>"+objJson.majorCardCd[i].DESC1+"</label>";
				}
				str += "</div></td></tr><tr><td style='text-align: center; border: 1px solid #ddd; '>MINOR</td><td colspan='8' style='text-align: center; border: 1px solid #ddd; '>";
				str += "<div class='checkbox check-success checkbox_center' style='padding-top:12px; padding-bottom:0; margin-left:5%; ' >";
				for(var i=0; i < minorLeng; i++ ){
					str += "<input type='checkbox' id='useMICard_01"+objJson.minorCardCd[i].CODE1+"' name='useMICard_01"+objJson.minorCardCd[i].CODE1+"'> ";
					str += "<label for='useMICard_01"+objJson.minorCardCd[i].CODE1+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'>"+objJson.minorCardCd[i].DESC1+"</label>";
					if(i == 8 ){
						str += "<br>";
					}
				}
				str += "<br>";
				for(var i=0; i<overLeng; i++){
					str += "<input type='checkbox' id='useMICard_01"+objJson.overCardCd[i].CODE1+"'  name='useMICard_01"+objJson.overCardCd[i].CODE1+"'> ";
					str += "<label for='useMICard_01"+objJson.overCardCd[i].CODE1+"' style='margin:0px;margin-left:12px; right:20px; padding-left:20px;'>"+objJson.overCardCd[i].DESC1+"</label>";
				}
				str += "</div></td></tr>";
			}
		//card table 결과 
		$("#tbPayMethod #tb_card").html(str);
		if(objJson.settleCycle != null){
			if(objJson.settleCycle[0].STMT_CYCLE_CD!=null){
				$("#tbPayMethod #tb_card #selCycle_0101 > option[value='"+ objJson.settleCycle[0].STMT_CYCLE_CD+"']").attr("selected","true");
			}
		}
		if(objJson.midInfo[0].CARD_BLOCK_CD != null){
			var cardBlockCd = objJson.midInfo[0].CARD_BLOCK_CD;
			var blockCd= cardBlockCd.split(":");
			
			for(var i=0; i< blockCd.length; i++){
				for(var j=0; j<majorLeng;j++){
					console.log("blockCardCd : " + blockCd[i]);
					if(objJson.majorCardCd[j].CODE1 == blockCd[i]){
						console.log("majorCard : " + objJson.majorCardCd[j].CODE1);
						$("input[name=useMJCard_01"+objJson.majorCardCd[j].CODE1+"]").prop("checked", true);
					}
				}
			}
			for(var i=0; i< blockCd.length; i++){
				for(var j=0; j<minorLeng;j++){
					console.log("blockCardCd : " + blockCd[i]);
					if(objJson.minorCardCd[j].CODE1 == blockCd[i]){
						console.log("minorCardCd : " + objJson.minorCardCd[j].CODE1);
						$("input[name=useMICard_01"+objJson.minorCardCd[i].CODE1+"]").prop("checked", true);
					}
				}
			}
			for(var i=0; i< blockCd.length; i++){
				for(var j=0; j<overLeng;j++){
					console.log("blockCardCd : " + blockCd[i]);
					if(objJson.overCardCd[j].CODE1 == blockCd[i]){
						console.log("overCardCd : " + objJson.overCardCd[j].CODE1);
						$("input[name=useMICard_01"+objJson.overCardCd[i].CODE1+"]").prop("checked", true);
					}
				}
			}
		}
		
		var setNoNm = "";
		var fnSvcLst = ["01"];
		var fnCdLst = ["01", "02", "03", "04", "06", "07", "08", "12", "25", "26", "27", "28", "29", "38"];
		
		// 010301, 010302, 010303, 010304, 010306, 010307, 010308, 010312, 010399, 020301, 020302, 020303, 020304, 020306, 020307, 020308, 020312
		 for(var k = 0; k < fnSvcLst.length; k++) {
		  
		 	for(var j = 0; j < fnCdLst.length; j++) {

		 		
		 		setNoNm = "_01"+fnSvcLst[k]+fnCdLst[j];
		 		$("input[name=chgFee"+setNoNm+"]").val(map.get("fee"+setNoNm)); 
				
				if("25" == (fnCdLst[j]) || "26" == (fnCdLst[j]) || "27" == (fnCdLst[j]) || "28" == (fnCdLst[j]) 
		  				|| "29" == (fnCdLst[j]) || "38" == (fnCdLst[j])){
					continue;
		  		}
			 }
		}

		
		// 010301, 010302, 010303, 010304, 010306, 010307, 010308, 010312, 010399, 020301, 020302, 020303, 020304, 020306, 020307, 020308, 020312
		for(var i = 1; i < 3; i++) {
		 
		 for(var k = 0; k < fnSvcLst.length; k++) {
		  
		 	for(var j = 0; j < fnCdLst.length; j++) {
		 		
		 		if(i == 2 && ("25" == (fnCdLst[j]) || "26" == (fnCdLst[j]) || "27" == (fnCdLst[j]) || "28" == (fnCdLst[j]) 
		  				|| "29" == (fnCdLst[j]) || "38" == (fnCdLst[j]))){
					continue;
		  		}
		 		
		 		var setNoNm = "_0"+i+fnSvcLst[k]+fnCdLst[j];
		 		// mapa = cardInfo
		 		$("input[name=selMbsNo"+setNoNm+"]").val(map.get("mbsNo"+setNoNm));
		 		$("input[name=selTermNo"+setNoNm+"]").val(map.get("termNo"+setNoNm));
		 		$("input[name=authType"+setNoNm+"]").val(map.get("authType"+setNoNm) == null ? "00" : map.get("authType"+setNoNm) );
				
		 		$("input[name=oldMbsNo"+setNoNm+"]").val(map.get("mbsNo"+setNoNm));
		 		$("input[name=oldTermNo"+setNoNm+"]").val(map.get("termNo"+setNoNm));
		 		$("input[name=oldAuthType"+setNoNm+"]").val(map.get("authType"+setNoNm) == null ? "00" : map.get("authType"+setNoNm) );
		 		
		 		}
			}
		}
		  
        IONPay.Utils.fnJumpToPageTop();

	}else{
    	/* $("#Information").hide();
    	$("#OtherInformation").hide();
    	$("#CalculationInformation").hide();
    	$("#PayMethodArea").hide();
    	$("#ForeignPayment").hide();
    	$("#Others").hide(); */
    	$("#midRegInfo").hide();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}
function fnSelectGidInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.gidInfo.length > 0 ){
			var gid = objJson.gidInfo[0].GID.substr(0,9);
			$("#gidRegInfo #GID").val(gid);
			$("#gidRegInfo #issuDt").val(objJson.gidInfo[0].REG_DT);
			$("#gidRegInfo #gNm").val(objJson.gidInfo[0].G_NM);
			$("#gidRegInfo #coNo").val(objJson.gidInfo[0].CO_NO);
			$("#gidRegInfo #vaNo").val(objJson.gidInfo[0].VGRP_NO);
			$("#gidRegInfo #vaNm").val(objJson.gidInfo[0].VGRP_NM);
			$("#gidRegInfo #contNm1").val(objJson.gidInfo[0].EMP1_NM);
			$("#gidRegInfo #contTel1").val(objJson.gidInfo[0].EMP1_TEL);
			$("#gidRegInfo #contCp1").val(objJson.gidInfo[0].GIEMP1_CP);
			$("#gidRegInfo #contEmail1").val(objJson.gidInfo[0].EMP1_EMAIL);
			$("#gidRegInfo #contNm2").val(objJson.gidInfo[0].EMP2_NM);
			$("#gidRegInfo #contTel2").val(objJson.gidInfo[0].EMP2_TEL);
			$("#gidRegInfo #contCp2").val(objJson.gidInfo[0].GIEMP2_CP);
			$("#gidRegInfo #contEmail2").val(objJson.gidInfo[0].EMP2_EMAIL);
			$("#gidRegInfo #bankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
			$("#gidRegInfo #bankCd").select2("val", objJson.gidInfo[0].BANK_CD);
			
		}
	IONPay.Utils.fnJumpToPageTop();
	}else{
		$("#gidRegInfo").hide();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}
function fnSelectVidInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.vidInfo != null){
			if(objJson.vidInfo.length > 0 ){
				var vid = objJson.vidInfo[0].VID.substr(0,9);
				$("#vidRegInfo #VID").val(vid);
				$("#vidRegInfo #vNm").val(objJson.vidInfo[0].VGRP_NM);
				$("#vidRegInfo #coNo").val(objJson.vidInfo[0].CO_NO);
				$("#vidRegInfo #repNm").val(objJson.vidInfo[0].REP_NM);
				$("#vidRegInfo #bsKind").val(objJson.vidInfo[0].BS_KIND);
				$("#vidRegInfo #gdKind").val(objJson.vidInfo[0].GD_KIND);
				$("#vidRegInfo #email").val(objJson.vidInfo[0].EMAIL);
				$("#vidRegInfo #contCharge").val(objJson.vidInfo[0].CONT_NM);
				$("#vidRegInfo #settleCharge").val(objJson.vidInfo[0].SETT_NM);
				$("#vidRegInfo #techCharge").val(objJson.vidInfo[0].TECH_EMP_NM);
				$("#vidRegInfo #vaNo").val(objJson.vidInfo[0].V_ACCT_NO);
				$("#vidRegInfo #vaNm").val(objJson.vidInfo[0].V_ACCT_NM);
				$("#vidRegInfo #settleCycle").html("<option value='"+objJson.vidInfo[0].STMT_CYCLE_CD+"' selected='selected'>"+objJson.vidInfo[0].V_SETTLE_CYCLE +"</option>");
				$("#vidRegInfo #rsRate").val(objJson.vidInfo[0].RSHARE_RATE);
				$("#vidRegInfo #bankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
				$("#vidRegInfo #bankCd").select2("val", objJson.vidInfo[0].BANK_CD);
				$("#vidRegInfo #Address1").val(objJson.vidInfo[0].POST_NO);
				$("#vidRegInfo #Address2").val(objJson.vidInfo[0].ADDR_NO1);
				$("#vidRegInfo #Address3").val(objJson.vidInfo[0].ADDR_NO2);
				
				$("#vidRegInfo #statusChk").val(objJson.vidInfo[0].USE_TYPE);
				$("#vidRegInfo #settleCycle").html("<c:out value='${STMT_CYCLE_CD}' escapeXml='false' />");
				$("#vidRegInfo #settleCycle").select2("val", objJson.vidInfo[0].STMT_CYCLE_CD);
			}
			
			if(objJson.vidFeeInfo != null ){
				//VID 정산수수료 리스트
				if(objJson.vidFeeInfo.length > 0){
					var strServiceName = new Array("신용카드 (국내)", "신용카드 (해외)", "계좌이체", "계좌이체", "가상계좌", "휴대폰", "휴대폰");
		        	var strPmCd= new Array("01", "01", "01", "01", "02", "02", "03", "05", "05");
		      	 	var strFeeType = new Array("2", "2", "3", "2", "3", "2", "2");
		        	var strFrAmt = new Array("1","1", "1", "11601", "1", "1", "1");
			  		var strCpCd  = new Array("00", "99", "00", "00", "00", "CONTENTS", "GOODS");
					var str = "";
					str+='<tr>';
			  		str+='<th rowspan="10" class="th_verticleLine" style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_MM_0045"/></th>';
			  		str+='<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_DASHBOARD_0029"/></th>';
			  		str+='<th colspan="2" style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0420"/></th>';
			  		str+='<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0421"/></th>';
			  		str+='<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0422"/></th>';
			  		str+='<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0423"/></th></tr>';
			  		str+='</tr>';
			  		
	  				str += "<tr>";
			  			for(var i=0; i<strServiceName.length; i++){
				  			if(i < objJson.vidFeeInfo.length){
				  				
				  				var id = (objJson.vidFeeInfo[i].PM_CD+objJson.vidFeeInfo[i].FEE_TYPE_CD + objJson.vidFeeInfo[i].CP_CD_RE);
				  				var fee = objJson.vidFeeInfo[i].FEE
				  				var frDt = objJson.vidFeeInfo[i].FR_DT; 
				  				var shaRate = objJson.vidFeeInfo[i].SHARE_RATE;
				  				var etcFee = objJson.vidFeeInfo[i].ETC_FEE;
				  				
				  				
				  				var map = new Map();
				  				map.set("FEE_"+id  , objJson.vidFeeInfo[i].FEE );
				  				map.set("FR_DT_"+id  , objJson.vidFeeInfo[i].FR_DT);
				  				map.set("SHARE_RATE_"+id  , objJson.vidFeeInfo[i].SHARE_RATE);
				  				map.set("ETC_FEE_"+id  , objJson.vidFeeInfo[i].ETC_FEE );
				  				
				  				console.log(map);
				  			}
				  				
				  				if(i == 0 || i==1 || i==2 ){
				  					str += '<th style="text-align: center; border: 1px solid #ddd;" rowspan="2"  >' +(i+1)+  '</th>';
					  				str += '<td style="text-align: center; border: 1px solid #ddd; " rowspan="2">' +strServiceName[i]+  '</td>';
				  				}
				  				else if(i != 0 && i != 1 && i != 2 && i != 3){
					  				str += '<th style="text-align: center; border: 1px solid #ddd; ">' +(i+1)+  '</th>';
					  				str += '<td style="text-align: center; border: 1px solid #ddd; ">' +strServiceName[i]+  '</td>';
				  				}
				  				str += "<input type='hidden' name='iSpmCd' value='00' >";
				  				str += "<input type='hidden' name='iCpCd' value='"+strCpCd[i]+"' >";
				  				str += "<input type='hidden' name='iFeeType' value='"+strFeeType[i]+"' >";
				  				str += "<input type='hidden' name='iFrAmt' value='"+strPmCd[i]+"' >";
				  				str += "<input type='hidden' name='iFee' value='"+map.get("FEE_"+id)+"' >";
				  				str += "<input type='hidden' name='iFrDt' value='"+map.get("FR_DT_"+id)+"' >";
				  				
				  				str += "<input type='hidden' name='lNewFee"+id+"' value='' >";
				  				str += "<input type='hidden' name='lShareRate' value='' >";
				  				str += "<input type='hidden' name='lNewFrdt' value='' >";
				  				str += '<td style="text-align: center; border: 1px solid #ddd; ">';
				  				if(i == 0 || i == 1 ){
				  					str += '정률제';
				  				}
// 				  				else if(i == 1 || i == 3 ){
// 				  					str += '정액제';
// 				  				}
				  				else if(i == 2 ){
				  					str += strFrAmt[i] + '원~ '+(strFrAmt[i+1]-1)+ '원';
				  				}else if(i == 3 ){
				  					str += strFrAmt[i] + '원~';
				  				}else if(i == 5 ){
				  					str += '컨텐츠';
				  				}else if(i == 6 ){
				  					str += '실물';
				  				}else{
				  					str += '-';	
				  				}
				  				str += '</td>';
				  				
				  				str+='<td style="text-align: center; border: 1px solid #ddd;"><input type="text" name="chgFee'+strPmCd[i]+strFeeType[i]+strCpCd[i] + '" value=""  onchange="javascript:setFeeData(this, '+i+')"> &nbsp;<span style="margin-top:8%;"> '; 
			  					if(strFeeType[i] == "2"){
			  						str += "%";
				  					//str += map.get("ETC_FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )==null?'': (map.get("ETC_FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )) ;
				  				}else if(strFeeType[i] == "3"){
				  					str += "원";
				  					//str += map.get("FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )==null?'': (map.get("FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] ));
				  				}
// 				  				if(i != 1 && i != 3 && strFeeType[i]=="2"){
// 				  					str += '%';
// 				  				}else if(i == 1 || i == 3 || strFeeType[i]=="3"){
// 				  					str += '원';
// 				  				}
				  				str += '</span></td>';
				  				
				  				str += '<td style="text-align: center; border: 1px solid #ddd;"><input type="text" name="chgFrShare'+strPmCd[i]+strFeeType[i]+strCpCd[i] + '" value=""  onchange=\"javascript:setShareData(this, '+i+')\">&nbsp; ';
				  				str += '<td style="text-align: center; border: 1px solid #ddd;"><input type="text" name="chgFrDt'+strPmCd[i]+strFeeType[i]+strCpCd[i] +'" value=""  maxlength="10"   onchange="javascript:dateLMaskOn(this); setFrDtData(this, '+i+')">';
// 				  				if(i != 1 && i != 3 ){
// 				  					str += map.get("SHARE_RATE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )==null?'': (map.get("SHARE_RATE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] ));				
// 				  				}else{
// 				  					str += '-';
// 				  				}
// 				  				str += '</td>';
				  				
// 				  				if(map.get("FR_DT_"+strPmCd[i]+strFeeType[i]+strCpCd[i]) == ''){
// 									str += '<td style="text-align: center; border: 1px solid #ddd;"> - </td>';
// 				  				}else{
// 									str += '<td style="text-align: center; border: 1px solid #ddd;"><input type="text" name="chgFrDt'+strPmCd[i]+strFeeType[i]+strCpCd[i] +'" value="" onchange="javascript:setFrDtData(this, '+i+')">'+ (map.get("FR_DT_"+strPmCd[i]+strFeeType[i]+strCpCd[i])==null?'': map.get("FR_DT_"+strPmCd[i]+strFeeType[i]+strCpCd[i]) )+ '</td>&nbsp; ';
				  					
// 				  				}
								if(i == 0 || i == 1) {
									str += "<tr>";
									str += '<input type="hidden" name="lEtcFee"  value="'+map.get("ETC_FEE_"+id)+'" >';
									str += '<input type="hidden" name="lNewEtcFee"  value="" >';
									str += '<td style="text-align: center; border: 1px solid #ddd;">정액제 </td>';
									str += '<td style="text-align: center; border: 1px solid #ddd;"><input type="text" name="chgEtcFee'+strPmCd[i]+strFeeType[i]+strCpCd[i] +'" value=""  onchange="javascript:setEtcFeeData(this, '+i+');">&nbsp; <span style="margin-top:8%;">원 </span></td>';
									str += '<td style="text-align: center; border: 1px solid #ddd;">&nbsp;</td><td style="text-align: center; border: 1px solid #ddd;">&nbsp;</td>';
									str += "</tr>";
								}else{
									str += '<input type="hidden" name="lEtcFee"  value="" >';
									str += '<input type="hidden" name="lNewEtcFee"  value="" >';
									str += '<input type="hidden" name="chgEtcFee'+strPmCd[i]+strFeeType[i]+strCpCd[i]+'"  value="" >';
								}


				  				str += "</tr>";
				  				
				  		}
		  				$("#vidRegInfo #trFeeInfo").html(str);
		  				
		  				for(var i=0;i<objJson.vidFeeInfo.length;i++){
		  					var id = (objJson.vidFeeInfo[i].PM_CD+objJson.vidFeeInfo[i].FEE_TYPE_CD + objJson.vidFeeInfo[i].CP_CD_RE);
			  				var fee = objJson.vidFeeInfo[i].FEE
			  				var frDt = objJson.vidFeeInfo[i].FR_DT; 
			  				var shaRate = objJson.vidFeeInfo[i].SHARE_RATE;
			  				var etcFee = objJson.vidFeeInfo[i].ETC_FEE;
			  				
			  				
			  				$("#trFeeInfo input[name=chgFee"+[0]+"]").val(fee);
			  				$("#trFeeInfo input[name=chgFrShare"+id+"]").val(shaRate);
			  				$("#trFeeInfo input[name=chgFrDt"+id+"]").val(frDt);
			  				$("#trFeeInfo input[name=chgEtcFee"+id+"]").val(etcFee);
			  				if(id == "01200"){
			  					$("#trFeeInfo input[name=lNewFee"+id+"]").val(fee);
				  				$("#trFeeInfo input[name=lShareRate"+id+"]").val(shaRate);
				  				$("#trFeeInfo input[name=lNewFrdt"+id+"]").val(frDt);
				  				$("#trFeeInfo input[name=lNewEtcFee"+id+"]").val(etcFee);
			  				}else if(id == "01299"){
			  					$("#trFeeInfo input[name=lNewFee"+id+"]").val(fee);
				  				$("#trFeeInfo input[name=lShareRate"+id+"]").val(shaRate);
				  				$("#trFeeInfo input[name=lNewFrdt"+id+"]").val(frDt);
				  				$("#trFeeInfo input[name=lNewEtcFee"+id+"]").val(etcFee);
			  				}else if(id == "02300"){
			  					$("#trFeeInfo input[name=lNewFee"+id+"]").val(fee);
				  				$("#trFeeInfo input[name=lShareRate"+id+"]").val(shaRate);
				  				$("#trFeeInfo input[name=lNewFrdt"+id+"]").val(frDt);
				  				$("#trFeeInfo input[name=lNewEtcFee"+id+"]").val(etcFee);
			  				}
		  					
		  				}
		  				
		  				
		  				
		  			}
				
			//UPDATE
			$("#vidRegInfo #trFeeRegInfo").css("display" , "none");
			$("#vidRegInfo #thFeeInfo").css("display" , "none");
			$("#vidRegInfo #insertFee").css("display", "none");
			$("#vidRegInfo #trFeeInfo").css("display" , "block");
			$("#vidRegInfo #updateFee").css("display", "block");
			
			}
		}
	IONPay.Utils.fnJumpToPageTop();
	}else{
		$("#vidRegInfo").hide();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}

function setFrDtData(myFrom, index){
	var f = document.mainForm;
	if(myFrom.value !="")
		f.lNewFrdt[index].value = myFrom.value;
}
function setFeeData(myFrom, index){
	var f = document.mainForm;
	if(myFrom.value !=""){
		f.lNewFee[index].value = myFrom.value;
	}
}
function setShareData(myFrom, index){
	var f = document.mainForm;
	if(myFrom.value !="")
		f.lShareRate[index].value = myFrom.value;
}

function setEtcFeeData(myFrom, index){
	var f = document.mainForm;
	if(myFrom.value !="")
		f.lNewEtcFee[index].value = myFrom.value;
}

function fnSearchCoNo(){
	arrParameter["CO_NO"]    = $("#CO_NO").val();
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectCoNo.do";
	strCallBack  = "fnSelectCoNoRet";
	 
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSelectCoNoRet(objJson) {
	if(objJson.resultCode == 0){
		if(objJson.data != 0){
			if(objJson.data.length > 0 ){
				if(objJson.data[0].CONT_ST_CD == '88' || objJson.data[0].CONT_ST_CD == '89'){
					if(objJson.data[0].UNUSE_FLG == '0'){
					var strToday = $.datepicker.formatDate('dd-mm-yy', new Date());
					
					$("#insertInfo #MerchantName").val(objJson.data[0].CO_NM);
					$("#insertInfo #RepersentativeName").val(objJson.data[0].REP_NM);
					$("#insertInfo #TEL_NO").val(objJson.data[0].TEL_NO);
					$("#insertInfo #FAX_NO").val(objJson.data[0].FAX_NO);
					$("#insertInfo #URL").val(objJson.data[0].CO_URL);
					$("#insertInfo #ClassificationBusiness").val(objJson.data[0].BS_KIND);
					$("#insertInfo #BusinessStatus").val(objJson.data[0].GD_KIND);
					$("#insertInfo #ContractDate").val(strToday);
					$("#insertInfo #Address1").val(objJson.data[0].POST_NO);
					$("#insertInfo #Address2").val(objJson.data[0].ADDR_NO1);
					$("#insertInfo #Address3").val(objJson.data[0].ADDR_NO2);
					$("#insertInfo #BusinessAddr1").val(objJson.data[0].RPOST_NO);
					$("#insertInfo #BusinessAddr2").val(objJson.data[0].RADDR_NO1);
					$("#insertInfo #BusinessAddr3").val(objJson.data[0].RADDR_NO2);
					//나머지 불러올 수 있는 것들 체크 
					
					$("#insertInfo #chkCoNo").val("true");
						
					}else{
						IONPay.Msg.fnAlert("사업자가 [해지] 상태입니다. \n 상태 변경후 등록하세요.");
					}
				}else{
					IONPay.Msg.fnAlert("사업자 계약이 완료되지 않았습니다.");
				}
			}
		} else {
			IONPay.Msg.fnAlert("조회할 내역이 없습니다.");
		}
	}else{
		IONPay.Msg.fnAlert("사업자 번호가 기존에 존재하지 않습니다.");
	}
}
//GID REGIST
function fnGidRegist(){
	arrParameter = $("#frmGidInfo").serializeObject();
	arrParameter["GID"] = $("#frmGidInfo #GID").val() + "g";
	arrParameter["WORKER"] = strWorker;
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/insertGidRegist.do";
	strCallBack  = "fnAllRegistRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnVidRegist(type){
	arrParameter = $("#frmVidInfo").serializeObject();
	arrParameter["VID"] = $("#frmVidInfo #VID").val() + "v";
	arrParameter["WORKER"] = strWorker;
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/insertVidRegist.do";
	strCallBack  = "fnAllRegistRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnAllRegist(){
	resultMap = fnCheckValidate('all');
	if(resultMap.get("resultCd") != 0000){
		IONPay.Msg.fnAlert(resultMap.get("resultMsg"));
	}else{
		var input = $("#insertInfo #ContractDate").val();
		var contDt = input.replace(/(\d\d)\-(\d\d)\-(\d{4})/, "$3$1$2");
		
		var smsPushChk = $("#PushFailedSMS").prop("checked");
		var smsPush;
		if(smsPushChk == true){
			smsPush = "1";
		}else{
			smsPush = "0";
		}
		var bCardChk = $("#PartialCancelFunctionCredit").prop("checked")
		var bAcctChk = $("#PartialCancelFunctionVACCT").prop("checked");
		var ccPartFlg;
		if(bCardChk == true && bAcctChk ==false){
			ccPartFlg = "100";
		}else if(bCardChk == false && bAcctChk == true ){
			ccPartFlg= "010";
		}else if(bCardChk ==true && bAcctChk == true ){
			ccPartFlg= "110";
		}else{
			ccPartFlg= "000";
		}
		arrParameter = $("#insertInfo").serializeObject();
		arrParameter["MER_ID"] = $("#insertInfo #MID").val() + "m";
		arrParameter["MID"] = $("#insertInfo #MID").val() + "m";
		arrParameter["GID"] = $("#insertInfo #GID").val() + "g";
		arrParameter["VID"] = $("#insertInfo #VID").val() + "v";
		arrParameter["CONT_DT"] = contDt;
		arrParameter["CC_PART_CL"] = ccPartFlg;
		arrParameter["SMS_PUSH_FLG"] = smsPush;
		arrParameter["WORKER"] = strWorker;
		arrParameter["ACQ_CL_CD"] = $("#ACQ_CL_CD").val();
		
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/insertBaseInfo.do";
		strCallBack  = "fnAllRegistRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}
function fnAllRegistRet(objJson){
	if (objJson.resultCode == 0) {
        IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
    } else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);	
    }
}
function fnUpdateRet(objJson){
	if (objJson.resultCode == 0) {
		IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
        IONPay.Utils.fnJumpToPageTop();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnGidAllUpdate(){
	
	var input = $("#ContractDate").val();
   	var contDt = input.replace(/(\d\d)\-(\d\d)\-(\d{4})/, "$3$1$2");
	arrParameter = $("#insertInfo").serializeObject();
	arrParameter["CONT_DT"] = contDt;
	arrParameter["MID"] = $("#insertInfo #MID").val() + "m";
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/baseGidUpdate.do";
	strCallBack  = "fnUpdateRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnVidAllUpdate(){
	
	var input = $("#ContractDate").val();
   	var contDt = input.replace(/(\d\d)\-(\d\d)\-(\d{4})/, "$3$1$2");
	arrParameter = $("#insertInfo").serializeObject();
	arrParameter["CONT_DT"] = contDt;
	arrParameter["MID"] = $("#insertInfo #MID").val() + "m";
	strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/baseVidUpdate.do";
	strCallBack  = "fnUpdateRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnBaseAllUpdate(){
	resultMap = fnCheckValidate('all');
	if(resultMap.get("resultCd") != 0000){
		IONPay.Msg.fnAlert(resultMap.get("resultMsg"));
	}else{
		var input = $("#ContractDate").val();
	   	var contDt = input.replace(/(\d\d)\-(\d\d)\-(\d{4})/, "$3$1$2");
		arrParameter = $("#insertInfo").serializeObject();
		arrParameter["CONT_DT"] = contDt;
		arrParameter["MID"] = $("#insertInfo #MID").val() + "m";
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/baseAllUpdate.do";
		strCallBack  = "fnUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}

function fnNormalRegist(){
	resultMap = fnCheckValidate('1');
	if(resultMap.get("resultCd") != 0000){
		IONPay.Msg.fnAlert(resultMap.get("resultMsg"));
	}else{
		var input = $("#ContractDate").val();
	   	var contDt = input.replace(/(\d\d)\-(\d\d)\-(\d{4})/, "$3$1$2");
		arrParameter = $("#insertInfo").serializeObject();
		arrParameter["CONT_DT"] = contDt;
		arrParameter["CO_NO"] = $("#CO_NO").val();
		arrParameter["MID"] = $("#insertInfo #MID").val() + "m";
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/normalReg.do";
		strCallBack  = "fnUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}
	
function fnEtcRegist(typeChk){
	resultMap = fnCheckValidate('2');
	if(resultMap.get("resultCd") != 0000){
		IONPay.Msg.fnAlert(resultMap.get("resultMsg"));
	}else{
		if(typeChk == "update"){
			var smsPushChk = $("#PushFailedSMS").prop("checked");
			var smsPush;
			if(smsPushChk == true){
				smsPush = "1";
			}else{
				smsPush = "0";
			}
			arrParameter = $("#insertInfo").serializeObject();
			arrParameter["MID"] = $("#MID").val()+"m";
			arrParameter["SMS_PUSH_FLG"] = smsPush;
			strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/etcReg.do";
			strCallBack  = "fnUpdateRet";
			IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
		}else{
			IONPay.Msg.fnAlert("MID가 등록되지 않았습니다.");
		}
	}
}
	
function fnSettleRegist(typeChk){
	resultMap = fnCheckValidate('3');
	if(resultMap.get("resultCd") != 0000){
		IONPay.Msg.fnAlert(resultMap.get("resultMsg"));
	}else{
		var bCardChk = $("#PartialCancelFunctionCredit").prop("checked")
		var bAcctChk = $("#PartialCancelFunctionVACCT").prop("checked");
		var ccPartFlg;
		if(bCardChk == true && bAcctChk ==false){
			ccPartFlg = "010";
		}else if(bCardChk == false && bAcctChk == true ){
			ccPartFlg= "001";
		}else if(bCardChk ==true && bAcctChk == true ){
			ccPartFlg= "110";
		}else{
			ccPartFlg= "000";
		}
    	if($("#ACQ_CL_CD").val()=="2"){
    		arrParameter = {
    				"MID"								:	$("#MID").val()+"m",
    				"ACQ_CL_CD"					:	$("#ACQ_CL_CD").val(),
    				"ACQ_DAY"						:	$("#selSettlSvc0001").val(), //ACQ_CL_CD==반자동
    				"PAY_ID_CD"					:	$("#PAY_ID_CD").val(), //지급구분
    				"CC_CL_CD"					:	$("#CC_CL_CD").val(),
    				"CC_PART_CL"				:	ccPartFlg,
    				"AUTO_CAL_FLG"			:	$("#autoCancel").val(),
    				"ACCNT_NO"					:	$("#ACCNT_NO").val(),
    				"ACCNT_NM"					:	$("#ACCNT_NM").val() //가상계좌 사용 미사용 체크한다음에 INSERT. UI상 두개 가능한데 같은 곳에 넣어야하는지 체크
    		}
   		}else{
			arrParameter = {
					"MID"								:	$("#MID").val()+"m",
					"ACQ_CL_CD"					:	$("#ACQ_CL_CD").val(),
					"PAY_ID_CD"					:	$("#PAY_ID_CD").val(), //지급구분
					"CC_CL_CD"					:	$("#CC_CL_CD").val(),
					"CC_PART_CL"				:	ccPartFlg,
					"AUTO_CAL_FLG"			:	$("#autoCancel").val(),
					"ACCNT_NO"					:	$("#ACCNT_NO").val(),
					"ACCNT_NM"					:	$("#ACCNT_NM").val() //가상계좌 사용 미사용 체크한다음에 INSERT. UI상 두개 가능한데 같은 곳에 넣어야하는지 체크
			}
   		}
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/settleReg.do";
		strCallBack  = "fnUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
}
	
	function fnPayTypeRegist(typeChk){
		resultMap = fnCheckValidate('3');
		if(resultMap.get("resultCd") != 0000){
			IONPay.Msg.fnAlert(resultMap.get("resultMsg"));
		}else{
			arrParameter = $("#insertInfo").serializeObject();
			arrParameter["MID"] = $("#MID").val()+"m";
			arrParameter["LMT_INSTMN"] = $("#LMT_INSTMN").val();
			arrParameter["selAuthFlg"] = $("select[name=selAuthFlg]").val();
			/* arrParameter = {
					"MID"					:	$("#MID").val()+"m",
					"AUTH_TYPE"		:	$("#authType").val(),
					"LMT_INSTMN"	:	$("#LMT_INSTMN").val(), 
			} */
			strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/payTypeReg.do";
			strCallBack  = "fnUpdateRet";
			IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
		}
	}
	
	function fnAbroadTypeRegist(){
		arrParameter = $("#insertInfo").serializeObject();
		arrParameter["MID"] = $("#MID").val()+"m";
		arrParameter["GID"] =$("#GID").val()+"g";
		arrParameter["VID"] = $("#VID").val()+"v";
		arrParameter["CONT_DT"] = contDt;
			
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/normalAbroad.do";
		strCallBack  = "fnUpdateRet";
		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
		}
		
		function fnSelectCateListRet(objJson){
			if(objJson.resultCode == 0){
				var smCateList = objJson.SMALL_CATEGORY_LIST;
		        $("#SmallCategory").html(smCateList);
		        
			}else{
				IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
			}
		}
	/**------------------------------------------------------------
	* 메뉴 이벤트
	------------------------------------------------------------*/
	$(function () {
		$("#BS_KIND_CD").on("change", function(){
			
			$("#SmallCategory").empty();
			
			if($(this).val() == "" || $(this).val() == "0"){
				
			}else{
				var strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/selectCateList.do";
		        var strCallBack  = "fnSelectCateListRet";
		        var objPram = {};
		        
		        objPram["BS_KIND_CD"] = $(this).val();
		        
		        IONPay.Ajax.fnRequest(objPram, strCallUrl, strCallBack);
			}
		});
	});
</script>
<style>
.checkbox_center label::after {
  left:1px;
}
</style>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <!-- BEGIN PAGE -->         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.BASIC_INFORMATION }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class = "row">
                	<div class = "col-md-12">
                		<div class = "grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_TV_TH_0050" /></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                            	<form id = "frmSearch" name = "frmsearch">
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
                            			<div class = "col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_TV_TH_0051" /></label> 
                            				<select id = "MER_SEARCH" name = "MER_SEARCH" class = "select2 form-control">
                            				</select>
                            			</div>
	                                    <div class="col-md-3">
	                                        <div class="input-with-icon  right">
	                                       		<label class="form-label">&nbsp;</label>
	                                            <input type="text" id="MER_SEARCH_TEXT" name="MER_SEARCH_TEXT" class="form-control" maxlength="10">
	                                        </div>
	                                    </div>             
	                                    <div class="col-md-6">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_TV_TH_0053" /></button>
                                                <button type="button" id="btnRegistration" class="btn btn-primary btn-cons"><spring:message code="IMS_BIM_BIR_0012" /></button>                                            
                                                <button type="button" id="btnListSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_BIM_BIR_0002"/></button>                                            
                                            </div>
                                        </div>
                            		</div>    
                            	</form>
                            </div>
                		</div>
                	</div>
                </div>
                <!-- END VIEW OPTION AREA -->
                <!-- BEGIN LIST Search VIEW AREA -->
	                <div class = "row" id = "ListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_BIR_0002" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="listSearchCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
		                        <div class="row">
		                          <h6><span class="semi-bold"><spring:message code="IMS_BIM_BIR_0001" /></span></h6>
		                        </div>
	                          <div class="row">
	                          <form id="frmAppro">
	                          	<input type='hidden' name='regMID'>
								<input type='hidden' name='regSvcCd'>
								<input type='hidden' name='regSvcPrdtCd'>
								<input type='hidden' name='regFnCd'>
								<input type='hidden' name='regFrDt'>
								<input type='hidden' name='regFrAmt'>
								<input type='hidden' name='regFeeType'>
								<input type='hidden' name='regStatus'>
								<input type='hidden' name='regOverCl'>
	                            <table class="table" id="tbListSearch" style="width:100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_BIM_BIR_0003" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0004" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0005"/></th>
	                                     <th id="id"></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0006" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0007" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0008" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0009" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0010" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0011" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </form>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END LIST Search VIEW AREA -->  
                <!-- BEGIN Information VIEW AREA -->
                <div id="midRegInfo"  >
                <form id="insertInfo" name="insertInfo">
                	<!-- 사업자번호 Get 여부 -->
					<input type='hidden' name='chkCoNo' id='chkCoNo' value='false'> 
					<!-- MID 중복확인 체크 여부 -->
					<input type='hidden' name='chkID' id='chkID' value='false'>
					<!-- 기 승인 사업자번호 수수료 -->
					<input type='hidden' name='defaultCoFee' id='defaultCoFee' value='false'>
					<!-- MID 저장 여부-->
					<input type='hidden' name='regMID'  id='regMID' value='false'>
					<!-- 계좌성명 체크 여부 -->
					<input type='hidden' name='chkAccnt' id='chkAccnt' value='false'>
                	<input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
	                <div class = "row" id = "Information">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_BM_0047" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="informationCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          	<input type="hidden" name="regDt" id="regDt" value="">
		                          <div class="row">
		                            <table class="table" id="tbInformation" width="100%">
		                                <tbody>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0054" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px">
												<div class="form-inline" style="margin:0;padding:0;">
													<div class="form-group" style="margin:0;padding:0;float:left;width:100%;">
														<input type="text" class="form-control" id="CO_NO" name="CO_NO" style="width:100%;float:left" maxlength="10"   onchange="chkCoNo.value='false'">
													</div>
												</div>
											 </td>
											 <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px">
														<button type='button'  id="btnCoNo"class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
															<spring:message code="IMS_BIM_BIR_0013"/>
														</button>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0057"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                         	<input type="text" id="RepersentativeName" name="RepersentativeName" class="form-control">
	                                       	 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0061" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;;">
	                                         	<input type="text" id="TEL_NO" name="TEL_NO" class="form-control">
	                                       	</td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0051" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                         	<input type="text" id="MerchantName" name="MerchantName" class="form-control">
	                                       	</td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0161"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3">
	                                         	<input type="text" id="SIGN_NM" name="SIGN_NM" class="form-control" style="width:39%">
	                                       	</td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0137" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px">
														<input type="text" class="form-control" id="MID" name="MID" style="width:95%;float:left" maxlength="9" onchange="chkID.value='false'">
														<label for="MID" style="margin:0; margin-top:10px;display:inline;float:left" >m</label>
	                                       	</td>
											 <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px">
													<button type='button' id="btnDupMidChk" onclick="fnDupIdChk(MID.value, 'MID');" class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0'>
														<spring:message code="IMS_BIM_BIR_0014"/>
													</button>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0163"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                         	<input type="text" id="URL" name="URL" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0164" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                         	<input type="text" id="FAX_NO" name="FAX_NO" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0138" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px">
														<input type="text" class="form-control" id="GID" name="GID" style="width:95%;float:left" readonly>
														<label for="GID" style="margin:0; margin-top:10px;display:inline;float:left">g</label>
	                                       	</td>
											 <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px">
													<button type='button'  id="btnInqGid"  class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666;  margin:0'>
														<spring:message code="IMS_BIM_BIR_0015"/>
													</button>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0165"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                         	<input type="text" id="ClassificationBusiness" name="ClassificationBusiness" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0166" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                         	<input type="text" id="EMAIL" name="EMAIL" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="DDLB_0139" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px">
														<input type="text" class="form-control" id="VID" name="VID" style="width:95%;float:left" readonly>
														<label for="VID" style="margin:0; margin-top:10px;display:inline;float:left">v</label>
	                                       	</td>
											 <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px">
													<button type='button' id="btnInqVid" class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666;  margin:0'>
														<spring:message code="IMS_BIM_BIR_0015"/>
													</button>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0167"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                         	<input type="text" id="BusinessStatus" name="BusinessStatus" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "UseStatus" name = "UseStatus" class = "select2 form-control">
	                            					<option value='0' selected=true><spring:message code="IMS_BIM_BIR_0025" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0026" /></option>
	                            					<option value='2'><spring:message code="IMS_BIM_BIR_0027" /></option>
	                            				</select>
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_MM_0081" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                            				<select id = "MBS_TYPE_CD" name = "MBS_TYPE_CD" class = "select2 form-control">
	                            					<option value='0' selected=true><spring:message code="IMS_BIM_BIR_0021" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0022" /></option>
	                            				</select>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0148"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "OM_SETT_CL" name = "OM_SETT_CL" class = "select2 form-control">
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0023" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0024" /></option>
	                            				</select>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0070" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "ContractStaff" name = "ContractStaff" class = "select2 form-control">
	                            				</select>
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0147" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                            				<select id = "CompanyType" name = "CompanyType" class = "select2 form-control">
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0028" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0029" /></option>
	                            					<option value='2'><spring:message code="IMS_BIM_BIR_0030" /></option>
	                            				</select>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0168"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "ACCNT_RISK_GRADE" name = "ACCNT_RISK_GRADE" class = "select2 form-control">
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0031" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0032" /></option>
	                            					<option value='2'><spring:message code="IMS_BIM_BIR_0033" /></option>
	                            				</select>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0049" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "SalesStaff" name = "SalesStaff" class = "select2 form-control">
	                            				</select>
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0149" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                            				<select id = "MALL_TYPE_CD" name = "MALL_TYPE_CD" class = "select2 form-control">
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0034" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0035" /></option>
	                            				</select>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0050"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
				                                    <div class="input-append success date col-md-10 col-lg-10 no-padding">
				                                        <input type="text" id="ContractDate" name="ContractDate" class="form-control">
				                                        <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
				                                    </div>	                     
	                                         </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0015" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "RECV_CH_CD" name = "RECV_CH_CD" class = "select2 form-control">
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0036" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0037" /></option>
	                            					<option value='2'><spring:message code="IMS_BIM_BIR_0038" /></option>
	                            					<option value='3'><spring:message code="IMS_BIM_BIR_0039" /></option>
	                            					<option value='4'><spring:message code="IMS_BIM_BIR_0040" /></option>
	                            					<option value='5'><spring:message code="IMS_BIM_BIR_0041" /></option>
	                            				</select>
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0169" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                            				<select id = "BS_KIND_CD" name = "BS_KIND_CD" class = "select2 form-control">
	                            				</select>
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0170"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3">
	                            				<select id = "SmallCategory" name = "SmallCategory" class = "select2 form-control" style="width:40%">
	                            				</select>
											 </td>
		                                     <%-- <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0171" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "NHCategory" name = "NHCategory" class = "select2 form-control">
	                            				</select>
											 </td> --%>
											 
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_BIM_0028" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="6">
		                                     	<div class="col-md-1">
													<button type='button' onclick="javascript:fnPostSearch('1');" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
														<span class="glyphicon glyphicon-home" aria-hidden="true" style="color:orange"></span>
													</button>
		                                     	</div>
		                                     	<div class="col-md-2">
	                                         		<input type="text" id="Address1" name="Address1" class="form-control" readonly>
		                                     	</div>
		                                     	<div class="col-md-4">
	                                         		<input type="text" id="Address2" name="Address2" class="form-control" readonly>
		                                     	</div>
		                                     	<div class="col-md-5">
	                                         		<input type="text" id="Address3" name="Address3" class="form-control">
		                                     	</div>
	                                         </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_BIM_0029" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="6">
		                                     	<div class="col-md-1">
													<button type='button' onclick="javascript:fnPostSearch('2');" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
														<span class="glyphicon glyphicon-home" aria-hidden="true" style="color:orange"></span>
													</button>
		                                     	</div>
		                                     	<div class="col-md-2">
	                                         		<input type="text" id="BusinessAddr1" name="BusinessAddr1" class="form-control" readonly>
		                                     	</div>
		                                     	<div class="col-md-4">
	                                         		<input type="text" id="BusinessAddr2" name="BusinessAddr2" class="form-control" readonly>
		                                     	</div>
		                                     	<div class="col-md-5">
	                                         		<input type="text" id="BusinessAddr3" name="BusinessAddr3" class="form-control">
		                                     	</div>
	                                         </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><spring:message code="IMS_BIM_BIR_0016" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                         	<input type="text" id="CONT_EMP_NM" name="CONT_EMP_NM" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" >
	                                         	<input type="text" id="CONT_EMP_TEL" name="CONT_EMP_TEL" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0180"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                         	<input type="text" id="CONT_EMP_HP" name="CONT_EMP_HP" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" >
	                                         	<input type="text" id="CONT_EMP_EMAIL" name="CONT_EMP_EMAIL" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><spring:message code="IMS_BIM_BIR_0017" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                         	<input type="text" id="STMT_EMP_NM" name="STMT_EMP_NM" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" >
	                                         	<input type="text" id="STMT_EMP_TEL" name="STMT_EMP_TEL" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0180"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                         	<input type="text" id="STMT_EMP_CP" name="STMT_EMP_CP" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" >
	                                         	<input type="text" id="STMT_EMP_EMAIL" name="STMT_EMP_EMAIL" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><span><spring:message code="IMS_BIM_BIR_0018" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                         	<input type="text" id="TECH_EMP_NM" name="TECH_EMP_NM" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" >
	                                         	<input type="text" id="TECH_EMP_TEL" name="TECH_EMP_TEL" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><span><spring:message code="IMS_BIM_MM_0180" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                         	<input type="text" id="TECH_EMP_CP" name="TECH_EMP_CP" class="form-control">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" >
	                                         	<input type="text" id="TECH_EMP_EMAIL" name="TECH_EMP_EMAIL" class="form-control">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px;" colspan="6"></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px;">
												<button type='button' class='btn btn-info btn-cons'  id="btnNormalReg"  style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
													<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0019" />
												</button>
											 </td>
		                                	</tr>
		                                </tbody>
		                            </table>
		                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END Information VIEW AREA -->  
                <!-- BEGIN Other Information VIEW AREA -->
	                <div class = "row" id = "OtherInformation">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal purple">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0157" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbOtherInformation" width="100%">
	                                <tbody>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0001" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "CSHRCPT_AUTO_FLG" name = "CSHRCPT_AUTO_FLG" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0164" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0165" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0002"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "PAY_NOTI_CD" name = "PAY_NOTI_CD" class = "select2 form-control">
                            					<option value='00'><spring:message code="IMS_BIM_BIR_0166" /></option>
                            					<option value='01' selected="true"><spring:message code="IMS_BIM_BIR_0167" /></option>
                            					<option value='02'><spring:message code="IMS_BIM_BIR_0168" /></option>
                            					<option value='03'><spring:message code="IMS_BIM_BIR_0169" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0003" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "RCPT_PRT_TYPE" name = "RCPT_PRT_TYPE" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0170" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0171" /></option>
                            					<option value='2'><spring:message code="IMS_BIM_BIR_0172" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0004"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "VAT" name = "VAT" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0173" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0174" /></option>
                            				</select>
                            			 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0005" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "VACCT_LMT_DAY" name = "VACCT_LMT_DAY" class = "select2 form-control">
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0006"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "VACCT_ISS_TYPE" name = "VACCT_ISS_TYPE" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0209" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0210" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0007" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "UnsentAutoCancle" name = "UnsentAutoCancle" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0023" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0024" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0008"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "PhoneAuthenticationYN" name = "PhoneAuthenticationYN" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0211" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0212" /></option>
                            				</select>
                            			 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0009" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "ESCROW_USE_FLG" name = "ESCROW_USE_FLG" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0010"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "APP_VAN1_CD" name = "APP_VAN1_CD" class = "select2 form-control">
                            					<option value='0'><spring:message code="IMS_BIM_BIR_0215" /></option>
                            					<option value='1' selected="true"><spring:message code="IMS_BIM_BIR_0214" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0011" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "ACQ_VAN_CD" name = "ACQ_VAN_CD" class = "select2 form-control">
                            					<option value='0'><spring:message code="IMS_BIM_BIR_0215" /></option>
                            					<option value='1' selected="true"><spring:message code="IMS_BIM_BIR_0214" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0012"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select id = "QuickAuthenticationYN" name = "QuickAuthenticationYN" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                            				</select>
                            			 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0013" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" >
                            				<select id = "PUSH_PAY_CD" name = "PUSH_PAY_CD" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0216" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0217" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0014"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" >
                            				<select id = "PhoneFeeSection" name = "PhoneFeeSection" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0218" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0219" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0015" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" >
								                <div class="checkbox check-success checkbox_center" style="padding-top:12px; padding-bottom:0;">
								                   <input id="PushFailedSMS"  name="PushFailedSMS" type="checkbox">
								                   <label for="PushFailedSMS" style="margin:0px;margin-left:12px; right:20px; padding-left:20px;"><spring:message code="IMS_BIM_BIR_0224"/></label>
								               	</div>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0016"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" >
                            				<select id = "MBS_KEY_AUTH_FLG" name = "MBS_KEY_AUTH_FLG" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0220" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0221" /></option>
                            				</select>
                            			 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_BIM_0017" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" >
                            				<select id = "UseVACCTIssueMenuYN" name = "UseVACCTIssueMenuYN" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0216" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0217" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0018"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" >
                            				<select id = "UseTPayMobileUnauthorizedYN" name = "UseTPayMobileUnauthorizedYN" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0216" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0217" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0019" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" >
                            				<select id = "MMS_PAY_FLG" name = "MMS_PAY_FLG" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0222" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0223" /></option>
                            				</select>
                            			 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0020"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" >
                            				<select id = "ORD_NO_DUP_FLG" name = "ORD_NO_DUP_FLG" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                            				</select>
                            			 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px;" colspan="7"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px;">
											<button type='button' class='btn btn-info btn-cons'  onclick="fnEtcRegist(typeChk);" style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
												<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0020" />
											</button>
										 </td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END Other Information VIEW AREA -->  
                <!-- BEGIN Calculation Information VIEW AREA -->
	                <div class = "row" id = "CalculationInformation">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal yellow">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0012" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="calculationInformationCollapse" class="collapse"></a></div>
	                        </div>
                           	  <div class="grid-body no-border">
	                          <div class="row">
	                            <table class="table" id="tbCalculationInformation" width="100%">
	                                <tbody>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0021" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
                            				<select id = "ACQ_CL_CD" name = "ACQ_CL_CD" class = "select2 form-control">
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_PM_PV_0015"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3" >
	                                     	<div class="col-md-3">
	                            				<select id = "ACQ_DAY" name = "ACQ_DAY" class = "select2 form-control">
	                            				</select>
                            				</div>
                            				<div class="col-md-9">
                            					<p style="text-align:left;color:red;margin-top:12px"><spring:message code="IMS_BIM_BIR_0225"/></p>
                            				</div>
                            			</td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0022" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
                            				<select id = "PAY_ID_CD" name = "PAY_ID_CD" class = "select2 form-control">
                            					<option value='2' selected="true"><spring:message code="IMS_BIM_BM_0468" /></option>
                            					<option value='3'><spring:message code="IMS_BIM_BM_0469" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0023"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3">
	                                     	<input type="hidden" name="oldSettlSvc0001" value=""/>
	                                     	<div class="col-md-3">
	                            				<select id = "selSettlSvc0001" name = "selSettlSvc0001" class = "select2 form-control"><!-- selSettlSvc0001 -->
	                            					<option value='00' selected="true"><spring:message code="IMS_BIM_BM_0470" /></option>
	                            					<option value='01'><spring:message code="IMS_BIM_BM_0471" /></option>
	                            				</select>
	                            				<input type="hidden" name="oldSettlSvc0005" value=""/>
            									<input type="hidden" name="selSettlSvc0005" value="01">
                            				</div>
                            				<div class="col-md-9">
                            				</div>
                            			</td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0095" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
                            				<select id = "CC_CL_CD" name = "CC_CL_CD" class = "select2 form-control">
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0096"/></td>
	                                     <td style="border:1px solid #c2c2c2;">
							                <div class="checkbox check-success" style="padding-top:12px; padding-bottom:0;display:inline-block;    margin-left: 5%; ">
							                   <input id="PartialCancelFunctionCredit" name="PartialCancel" type="checkbox" >
							                   <label for="PartialCancelFunctionCredit" style="margin:0px;margin-left:12px; right:20px; padding-left:20px;"><spring:message code="IMS_BIM_BIR_0226"/></label>
							               	</div>
							                <div class="checkbox check-success" style="padding-top:12px; padding-bottom:0;display:inline-block;">
							                   <input id="PartialCancelFunctionVACCT" name="PartialCancel" type="checkbox" >
							                   <label for="PartialCancelFunctionVACCT" style="margin:0px;margin-left:12px; right:20px; padding-left:20px;"><spring:message code="IMS_BIM_BIR_0227"/></label>
							               	</div>
						               	 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0024" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
                            				<select id = "CC_ChkFlg" name = "CC_ChkFlg" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                            				</select>
                           				 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><spring:message code="IMS_BIM_BIM_0025" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" rowspan="2" id="AutoSetoff" name="AutoSetoff">
                            				<select id = "autoCancel" name = "autoCancel" class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0026"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                     	<div class = "col-md-3">
	                            				<select id = "bankCd" name = "bankCd" class = "select2 form-control">
	                            				</select>
                            				</div>
                            				<div class = "col-md-6">
                                         		<input type="text" id="ACCNT_NO" name="ACCNT_NO" class="form-control">
                            				</div>
                            				<div class = "col-md-3">
                            					<p style="text-align:left;margin-top:12px"><spring:message code="IMS_BIM_BIR_0228"/></p>
                            				</div>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                     	<div class = "col-md-9">
                                         		<input type="text" id="ACCNT_NM" name="ACCNT_NM" class="form-control">
                                       		</div>
                                       		<div class = "col-md-3">
                                       			<button type='button' id="acctNmChk" onclick="serAccntConfirm('0')" class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0 ; margin-left: -15px;'   >
                                       				<spring:message code="IMS_BIM_BM_0436" />
                                       			</button>
                                       		</div>
                           				 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0071"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                                     	<div class = "col-md-3">
	                            				<select id = "bankCd2" name = "bankCd2" class = "select2 form-control">
	                            				</select>
                            				</div>
                            				<div class = "col-md-6">
                                         		<input type="text" id="AcctInfo2_2" name="AcctInfo2_2" class="form-control">
                            				</div>
                            				<div class = "col-md-3">
                            					<p style="text-align:left;margin-top:12px"><spring:message code="IMS_BIM_BIR_0228"/></p>
                            				</div>
                           				 </td>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
                                         		<input type="text" id="AcctHolder2" name="AcctHolder2" class="form-control">
                           				 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px;" colspan="5"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px;">
											<button type='button' class='btn btn-info btn-cons'  onclick="fnSettleRegist(typeChk);"  style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
												<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0020" />
											</button>
										 </td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
                            </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END Calculation Information VIEW AREA -->  
                <!-- BEGIN PayMethod VIEW AREA -->
	                <div class = "row" id = "PayMethodArea">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal green">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_BIR_0247" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="payMethodCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbPayMethod" width="100%">
	                                <thead>
	                                 <tr>
	                                     <th colspan="15"><spring:message code="IMS_BIM_BIR_0248" /></th>
	                                 </tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIR_0241" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="2" id="stmtCycle">
	                                     &nbsp;<input type='hidden' name='oldUseCl_0101'/>
                            				<select class = "select2 form-control" id="selUseCl_0101" name="selUseCl_0101">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0216" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0217" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="2"><spring:message code="IMS_BIM_BIR_0242"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="2">
	                                     	&nbsp;<input type="hidden" name="selOldAuthFlg" />
                            				<select class = "select2 form-control" id="authType" name="selAuthFlg">
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="11"></td>
	                                	</tr>
	                                </thead>
	                                <tbody id="tb_card"></tbody>
	                                	<tfoot>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="2"><spring:message code="IMS_BIM_BIM_0047"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="11">
	                                     	<div class="col-md-3">
	                            				<select class = "select2 form-control"  id="LMT_INSTMN"  name="LMT_INSTMN">
	                            					<option value='1' selected="true">1개월</option>
	                            					<%
	                            					for(int i = 2; i <= 36; i++){
	                            						%>
	                            					<option value='<%= i %>'><%= i %>개월</option>
	                            						<%
	                            					}	                            					
	                            					%>
	                            				</select>
	                                     	</div>
	                                     	<div class="col-md-9">
												<label style="margin:0; margin-top:10px;display:inline;float:left"><spring:message code="IMS_BIM_BIR_0246" /></label>
	                                     	</div>
										 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px;" colspan="2">
											<button type='button' class='btn btn-info btn-xs btn-mini btn-cons'  onclick="fnPayTypeRegist(typeChk);" style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
												<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0020" />
											</button>
										 </td>
	                                	</tr>
	                                </tfoot>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END PayMethod VIEW AREA -->  
                <%-- <!-- BEGIN Foreign Payment VIEW AREA -->
	                <div class = "row" id = "ForeignPayment">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal light-grey">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0159" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="foreignPaymentCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbForeignPayment" width="100%">
	                                <tbody>
	                                	<tr>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="6"><spring:message code="IMS_BIM_BIM_0059" /></th>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="6"><spring:message code="IMS_BIM_BIM_0060" /></th>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
                                         	<input type="text" id="WECHATCPID" name="WECHATCPID" class="form-control">
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0061"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="3">
	                                     	<div class="col-md-6">
	                            				<select class = "select2 form-control" readonly>
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0231" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0232" /></option>
	                            				</select>
                            				</div>
	                                     	<div class="col-md-6">
	                            				<select class = "select2 form-control" readonly>
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0233" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0234" /></option>
	                            				</select>
                            				</div>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                                         	<input type="text" id="QQPAYCPID" name="QQPAYCPID" class="form-control">
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0061"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="3">
	                                     	<div class="col-md-6">
	                            				<select class = "select2 form-control" readonly>
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0231" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0232" /></option>
	                            				</select>
                            				</div>
	                                     	<div class="col-md-6">
	                            				<select class = "select2 form-control" readonly>
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0233" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0234" /></option>
	                            				</select>
                            				</div>
                           				 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0062" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                                         	<input type="text" class="form-control">
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0063"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="3">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0214" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0235" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0062"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                                         	<input type="text" class="form-control">
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0063"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="3">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0214" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0235" /></option>
                            				</select>
                           				 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0236" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0237" /></option>
                            					<option value='2'><spring:message code="IMS_BIM_BIR_0238" /></option>
                            					<option value='3'><spring:message code="IMS_BIM_BIR_0239" /></option>
                            					<option value='4'><spring:message code="IMS_BIM_BIR_0240" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
											<input type="text" class="form-control" style="width:85%;float:left">
											<label style="margin:0; margin-top:10px;display:inline;float:left">%</label>
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0216" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0217" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0236" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0237" /></option>
                            					<option value='2'><spring:message code="IMS_BIM_BIR_0238" /></option>
                            					<option value='3'><spring:message code="IMS_BIM_BIR_0239" /></option>
                            					<option value='4'><spring:message code="IMS_BIM_BIR_0240" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
											<input type="text" class="form-control" style="width:85%;float:left">
											<label style="margin:0; margin-top:10px;display:inline;float:left">%</label>
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0216" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0217" /></option>
                            				</select>
                           				 </td>
	                                	</tr>
	                                	<tr>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="6"><spring:message code="IMS_BIM_BIM_0064" /></th>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; color:white;" colspan="6">T e m p l a t eT e m p l a t eT e m p l a t eT e m p l a t e</th>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                                         	<input type="text" id="LAKALACPID" name="LAKALACPID" class="form-control">
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0061"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="3">
	                                     	<div class="col-md-6">
	                            				<select class = "select2 form-control" readonly>
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0231" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0232" /></option>
	                            				</select>
                            				</div>
	                                     	<div class="col-md-6">
	                            				<select class = "select2 form-control" readonly>
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0233" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0234" /></option>
	                            				</select>
                            				</div>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="6">T e m p l a t eT e m p l a t eT e m p l a t eT e m p l a t e</td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0063" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0214" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0235" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3">
											<input type="text" class="form-control" style="width:85%;float:left">
											<label style="margin:0; margin-top:10px;display:inline;float:left">%</label>
                                         </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="6">T e m p l a t eT e m p l a t eT e m p l a t eT e m p l a t e</td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0236" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0237" /></option>
                            					<option value='2'><spring:message code="IMS_BIM_BIR_0238" /></option>
                            					<option value='3'><spring:message code="IMS_BIM_BIR_0239" /></option>
                            					<option value='4'><spring:message code="IMS_BIM_BIR_0240" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="3">
                            				<select class = "select2 form-control">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0216" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0217" /></option>
                            				</select>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="6">T e m p l a t eT e m p l a t eT e m p l a t eT e m p l a t e</td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px;" colspan="11"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px;">
											<button type='button' class='btn btn-info btn-cons'  onclick="fnAbroadTypeRegist(typeChk);"style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
												<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0020" />
											</button>
										 </td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END Foreign Payment VIEW AREA -->   --%>
                <!-- BEGIN Others VIEW AREA -->
	                <div class = "row" id = "Others">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal grey">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_BIR_0155" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="othersCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbOthers" width="100%">
	                                <tbody>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIR_0229" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="6">
                                         		<textarea rows="5" cols="100" id="Memo" name="Memo" class="form-control"></textarea>
                                    	 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px;">
											<button type='button' class='btn btn-info btn-cons'  id="btnAllReg" style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0;'>
												<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0230" />
											</button>
										 </td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
	           </form>
	           </div>
               <!-- END Others VIEW AREA -->  
               <!-- START GID VIEW AREA -->
               <div id="gidRegInfo">
               		<form id="frmGidInfo" name="frmGidInfo">
               			<input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
		                <div class = "row" id = "Information">
		                	<div class = "col-md-12">
		                      <div class="grid simple horizontal red">
		                        <div class="grid-title">
		                          	<h4><span class="semi-bold"><spring:message code='IMS_BIM_BM_0061'/></span></h4>
		                          	<div class="tools"> <a href="javascript:;" id="gidInformationCollapse" class="collapse"></a></div>
	       		                  </div>
	       		                  <div class="grid-body">
		                         	<div class="row">
		                         		<table class="table" id="gidInfo" style="width:100%">
			                                <tbody>
			                                	<tr>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0138" /></td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px" >
														<div class="form-inline" style="margin:0;padding:0;">
															<div class="form-group" style="margin:0;padding:0;float:left;width:100%;">
																<input type="text" class="form-control" id="GID" name="GID" style="width:50%;float:left">
																<label for="GID" style="margin: 17px 13px 0px 2px; display:inline;float:left">g</label>
																<button type='button'  id="btnDupGid" onclick="fnDupIdChk(GID.value , 'GID');"class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; float:left; background-color:white; color:#666; margin:0;'>
																	<spring:message code="IMS_BIM_BIR_0014"/>
																</button>
															</div>
														</div>
													 </td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0428"/></td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="4">
			                                         	<input type="text" id="issuDt" name="issuDt" class="form-control" style="width:30%;">
			                                       	 </td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0415" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="6">
		                            					<input type="text" id="gNm"  name="gNm" class="form-control" style="float:left; width:15%;" >
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0083" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="6">
		                            					<input type="text"  id="coNo" name="coNo" class="form-control" style="float:left; width:15%;" >
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0429" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white; width:15%;">
		                            					<select class = "select2 form-control" id="bankCd" name="bankCd"></select>
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_BM_0417"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2">
	                                        		 	<input type="text" id="vaNo" name="vaNo" class="form-control" style=" width:85%; float:left;">
	                                        		 	<label style="margin: 10px 10px 0px 5px; display:inline; float:left;"><spring:message code="IMS_BIM_BM_0430" /></label>
													</td>
													<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee; "><spring:message code="IMS_BIM_BIM_0027"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" >
	                                        		 	<input type="text"  id="vaNm" name="vaNm" class="form-control" style="float:left; " >
													</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2" ><spring:message code="IMS_BIM_BM_0431" /></td>
		                           				 	
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BM_CM_0097"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                                        		 	<input type="text"  id="contNm1" name="contNm1" class="form-control" style="float:left; " >
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">TEL/CP</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;">
		                            					<input type="text"  id="contTel1" name="contTel1" class="form-control" style="float:left; width:40%;" >
		                            					<label style="margin: 10px 10px 0px 8px; display:inline;float:left;"> / </label>
		                            					<input type="text"  id="contCp1" name="contCp1" class="form-control" style="float:left; width:40%;" >
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">EMAIL</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;">
		                            					<input type="text"  id="contEmail1" name="contEmail1" class="form-control" style="float:left;" >
													</td>
			                                	</tr>
			                                	<tr>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BM_CM_0097"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;">
	                                        		 	<input type="text"  id="contNm2" name="contNm2" class="form-control" style="float:left; " >
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">TEL/CP</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;">
		                            					<input type="text"  id="contTel2" name="contTel2" class="form-control" style="float:left; width:40%;" >
		                            					<label style="margin: 10px 10px 0px 8px; display:inline;float:left;"> / </label>
		                            					<input type="text"  id="contCp2" name="contCp2" class="form-control" style="float:left; width:40%;" >
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">EMAIL</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;">
		                            					<input type="text"  id="contEmail2" name="contEmail2" class="form-control" style="float:left;" >
													</td>
			                                	</tr>
			                                	<tr>
			                                		<td colspan="6">
				                                	<td>
				                                		<button type='button' class='btn btn-info btn-cons'  id="btnGidReg"  onclick="fnGidRegist();" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
															<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0019" />
														</button>
				                                	</td>
			                                	</tr>
			                                </tbody>
			                            </table>
		                          	 </div>
	                          	  </div>
            	              </div>
                	        </div>
	                     </div>
	                     
                     </form>
               </div>
               <!-- END GID VIEW AREA -->
               <!-- START VID VIEW AREA -->
               <div id="vidRegInfo">
               		<form id="frmVidInfo" name="frmVidInfo">
               			<input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
		                <input type='hidden' name='chkAccnt' id='chkAccnt' value='false'>
		                <input type="hidden" name="regType" value="New">
		                <input type="hidden" name="chkID" value="false">
		                <div class = "row" id = "Information">
		                	<div class = "col-md-12">
		                      <div class="grid simple horizontal red">
		                        <div class="grid-title">
		                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_BM_0047" /></span></h4>
		                          <div class="tools"> <a href="javascript:;" id="vidInformationCollapse" class="collapse"></a></div>
	       		                 </div>
	       		                 <div class="grid-body">
	       		                 <!-- START VID NORMAL VIEW AREA -->
		                         	<div class="row" id="normaltVInfo">
		                         		<table class="table" id="tbNomalVidInfo"  style="width:100%;">
			                                <tbody>
			                                	<tr>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0139" /></td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px" colspan="9">
														<div class="form-inline" style="margin:0;padding:0;">
															<div class="form-group" style="margin:0;padding:0;float:left;width:100%;">
																<input type="text" class="form-control" id="VID" name="VID" style="width:40%;float:left">
																<label for="VID" style="margin: 17px 13px 0px 2px; display:inline;float:left">v</label>
																<button type='button'  id="btnDupVid" onclick="fnDupIdChk(VID.value , 'VID');" class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; float:left; background-color:white; color:#666; margin:0;'>
																	<spring:message code="IMS_BIM_BIR_0014"/>
																</button>
															</div>
														</div>
													 </td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0434" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="9">
		                            					<input type="text" id="vNm"  name="vNm" class="form-control" style="float:left; width:30%;" >
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0083" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="9">
		                            					<input type="text"  id="coNo" name="coNo" class="form-control" style="float:left; width:30%;" >
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0143" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="9">
		                            					<input type="text"  id="repNm" name="repNm" class="form-control" style="float:left; width:30%;" >
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0120" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="4">
		                            					<input type="text"  id="bsKind" name="bsKind" class="form-control" style="float:left;" >
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0119" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="4">
		                            					<input type="text"  id="gdKind" name="gdKind" class="form-control" style="float:left; width:80%;" >
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;">E-MAIL</td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="4">
		                            					<input type="text"  id="email" name="email" class="form-control" style="float:left;" >
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0435" /></td>
			                                     	<td style="border:1px solid #c2c2c2; color:white;" colspan="4">
		                            					<select class = "select2 form-control" id="statusChk" name="statusChk" style="width:30%;">
		                            						<option value='0' selected=true><spring:message code="IMS_BIM_BIR_0025" /></option>
			                            					<option value='1'><spring:message code="IMS_BIM_BIR_0026" /></option>
			                            					<option value='2'><spring:message code="IMS_BIM_BIR_0027" /></option>
		                            					</select>
		                           				 	</td>
			                                	</tr>
			                                	<tr>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><span><spring:message code="IMS_BIM_BIM_0028" /></span></td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="9">
				                                     	<div class="col-md-1">
															<button type='button' onclick="javascript:fnPostSearch('3');" class='btn btn-info btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; '>
																<span class="glyphicon glyphicon-home" aria-hidden="true" style="color:orange"></span>
															</button>
				                                     	</div>
				                                     	<div class="col-md-3">
			                                         		<input type="text" id="Address1" name="Address1" class="form-control" readonly>
				                                     	</div>
				                                     	<div class="col-md-5">
			                                         		<input type="text" id="Address2" name="Address2" class="form-control" readonly>
				                                     	</div>
			                                         </td>
			                                	</tr>
			                                	<tr>
			                                		<td style="text-align:center; border:1px solid #c2c2c2;" colspan="9">
			                                			<div class="col-md-9">
			                                         		<input type="text" id="Address3" name="Address3" class="form-control">
				                                     	</div>
			                                		</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0416" /></td>
			                                     	<td style="border:1px solid #c2c2c2;" colspan="9">
		                            					<select class = "select2 form-control" id="bankCd" name="bankCd" style="width:30%;"></select>
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0417" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="4">
		                            					<input type="text" id="vaNo" name="vaNo" class="form-control" style="float:left; width:80%;">
		                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left"><spring:message code="IMS_BIM_BM_0430" /></label>
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; color:white;" colspan="4">
		                            					<input type="text" id="vaNm" name="vaNm" class="form-control" style="float:left; width:60%">
		                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left"><spring:message code="IMS_BIM_BM_0430" /></label>
		                            					<button type='button'  id="btnVaChk"class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; float:left; background-color:white; color:#666; margin:0;'>
															<spring:message code="IMS_BIM_BM_0436"/>
														</button>
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0079" /></td>
			                                     	<td style="border:1px solid #c2c2c2;" colspan="4">
		                            					<select class = "select2 form-control" id="settleCycle" name="settleCycle"></select>
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0419" /></td>
			                                     	<td style="border:1px solid #c2c2c2;" colspan="4">
		                            					<input type="text" id="regCashPer" name="regCashPer" class="form-control" style="float:left; width:60%">
		                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
		                           				 	</td>
			                                	</tr>
			                                </tbody>
			                            </table>
			                            <div class="col-md-11"></div>
	                           			<div class="col-md-1">
		                             		<button type='button' class='btn btn-info btn-cons'  id="btnVidReg"  onclick="fnVidRegist();" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
												<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0019" />
											</button>
										</div>
		                          	 </div>
		                          	 <!-- END VID NORMAL VIEW AREA -->
	                          	  </div>
            	              </div>
                	        </div>
	                     </div>
	                     <!-- START VID SETTLE VIEW AREA -->
	                     <div class = "row" id = "settleVInfo">
		                	<div class = "col-md-12">
		                      <div class="grid simple horizontal light-grey">
		                        <div class="grid-title" >
		                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0012" /></span></h4>
		                          <div class="tools"> <a href="javascript:;" id="settleVInfoCollapse" class="collapse"></a></div>
		                        </div>
		                        <div class="grid-body" >
		                          <div class="row" id="settleVInfo">
	                         		<table class="table" id="tbSettleVidInfo"  style="width:100%;">
		                                <thead id="thFeeInfo">
		                                	<tr>
		                                		<th>NO</th>
		                                		<th><spring:message code="IMS_BIM_BM_0420" /></th>
		                                		<th><spring:message code="IMS_BIM_BM_0310" /></th>
		                                		<th><spring:message code="IMS_BIM_BM_0421" /></th>
		                                		<th><spring:message code="IMS_BIM_BM_0437" /></th>
		                                		<th><spring:message code="IMS_BIM_BM_0423" /></th>
		                                	</tr>
			                                <tr>
			                                	<td rowspan="2" class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">1</td>
			                                	<td rowspan="2" style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0280" /> ( <spring:message code="IMS_BM_CM_0091" /> )</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0438" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="inCardMinCashPer" name="inCardMinCashPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="inCardProfitSharPer" name="inCardProfitSharPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="inCardSaveDt" name="inCardSaveDt" class="form-control" style="float:left;">
			                                	</td>
			                                </tr>
			                                <tr>     
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0439" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="outCardMinCashWon" name="outCardMinCashWon" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">원</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                	</td>
		                                	</tr>
		                                	<tr>
			                                	<td rowspan="2" class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">2</td>
			                                	<td rowspan="2" style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0280" /> ( <spring:message code="IMS_BM_CM_0092" /> )</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0438" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="outCardMinCashPer" name="outCardMinCashPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="outCardProfitSharPer" name="outCardProfitSharPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="outCardSaveDt" name="outCardSaveDt" class="form-control" style="float:left;">
			                                	</td>
			                                </tr>
			                                <tr>     
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0439" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="outCardMinCashWon" name="outCardMinCashWon" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">원</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                	</td>
		                                	</tr>
		                                	<tr>
			                                	<td rowspan="2" class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">3</td>
			                                	<td rowspan="2" style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0281" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">1~11600</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="acctMinCashWon" name="acctMinCashWon" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">원</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="acctProfitSharPer" name="acctProfitSharPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="acctSaveDt1" name="acctSaveDt1" class="form-control" style="float:left;">
			                                	</td>
			                                </tr>
			                                <tr>     
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">11601~</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="acctMinCashPer" name="acctMinCashPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="acctProfitSharPer1" name="acctProfitSharPer1" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="acctSaveDt2" name="acctSaveDt2" class="form-control" style="float:left;">
			                                	</td>
		                                	</tr>
		                                	<tr>
			                                	<td class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">4</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0282" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">-</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="vaMinCashWon" name="vaMinCashWon" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">원</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="vaProfitSharPer" name="vaProfitSharPer" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="vaSaveDt" name="vaSaveDt" class="form-control" style="float:left;">
			                                	</td>
			                                </tr>
			                                <tr>
			                                	<td class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">5</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0283" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0440" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="phoneMinCashPer1" name="phoneMinCashPer1" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="phoneProfitSharPer1" name="phoneProfitSharPer1" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="phoneSaveDt1" name="phoneSaveDt1" class="form-control" style="float:left;">
			                                	</td>
			                                </tr>
			                                 <tr>
			                                	<td class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">6</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0283" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0441" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="phoneMinCashPer1" name="phoneMinCashPer1" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="phoneProfitSharPer1" name="phoneProfitSharPer1" class="form-control" style="float:left; width:80%">
	                            					<label style="margin: 17px 13px 0px 2px; display:inline;float:left">%</label>
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;">
			                                		<input type="text" id="phoneSaveDt1" name="phoneSaveDt1" class="form-control" style="float:left;">
			                                	</td>
			                                </tr>
		                                </thead>
		                                <tbody id="trFeeRegInfo"  style="width: 100%;">
	                                </tbody> 
	                                <tbody id="trFeeInfo" style="display: none; width: 100%;"> </tbody>
		                            </table>	
                            		<div class="col-md-11"></div>
                           			<div class="col-md-1" id="updateFee" style="display: none;">
	                             		<button type='button' class='btn btn-info btn-cons'  id="btnVidReg"  onclick="fnVidRegist();" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
											<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BM_0466" />
										</button>
									</div>
									<div class="col-md-1" id="insertFee">
	                             		<button type='button' class='btn btn-info btn-cons'  id="btnVidReg"  onclick="fnVidRegist();" style='border:1px solid #c2c2c2; text-align:center; cursor:default; background-color:white; color:#666; margin:0;'>
											<span class="glyphicon glyphicon-ok" aria-hidden="true" style="color:orange"></span><spring:message code="IMS_BIM_BIR_0019" />
										</button>
									</div>
		                          </div>
		                        </div>
		                	</div>
		                </div>
		          	 </div> 
		          	 <!-- END VID SETTVIEW AREA -->
                  </form>
               </div>
               <!-- END VID VIEW AREA -->
           </div>
			<div id="layer"  style="display:none; position:fixed;overflow:hidden; z-index:1; -webkit-overflow-scrolling:touch;">
				<img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnClose" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
			</div>
           <!-- END PAGE --> 
        </div>
        <!-- BEGIN MODAL -->
		<div class="modal fade" id="modalGidInfo"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="DDLB_0138"/> INFORMATION</h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="gidInfo" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                	<tr id="trGidList" style="display: none;">
                                		<td >
                                			<select id="gidList"  class="select2 form-control"  onchange="selectGid();"></select>
                                		</td>
                                		<td><br></td>
                                	</tr>
                                  <tr>
                                      <th><spring:message code='DDLB_0138'/></th>
                                      <td colspan="3" id="gid" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0415'/></th>
                                      <td colspan="3" id="gNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0083'/></th>
                                      <td colspan="3" id="coNo" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0416'/></th>
                                      <td colspan="3" id="bankCd" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                      <td colspan="3" id="selBankCd" style="border:1px solid #c2c2c2; background-color:white; display: none;">
                                      	<select id="selectBankCd"></select>
                                      </td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0417'/></th>
                                      <td id="vaNo" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                      <th><spring:message code='IMS_BIM_BIM_0027'/></th>
                                      <td id="vaNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                  	<td id="tdBtnGidSetting"></td>
                                  </tr>
                                 </thead>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END MODAL -->
		<!-- BEGIN MODAL -->
		<div class="modal fade" id="modalVidInfo"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="DDLB_0139"/> INFORMATION</h4>
		                <br />
		            </div>
		            <div class="modal-body">
		                <div class="row form-row">
		                    <table class="table" id="vidInfo" style="width:100%">
                                <thead>
                                	<tr id="trVidList" style="display: none;" onchange="selectVid();">
                                		<td >
                                			<select id="vidList"  class="select2 form-control" ></select>
                                		</td>
                                		<td><br></td>
                                	</tr>
                                  <tr>
                                      <th><spring:message code='DDLB_0139'/></th>
                                      <td colspan="4" id="vId" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0418'/></th>
                                      <td colspan="4" id="vNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0083'/></th>
                                      <td colspan="4" id="coNo" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0143'/></th>
                                      <td colspan="4" id="repNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_MM_0167'/></th>
                                      <td colspan="2" id="bsKind" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                      <th><spring:message code='IMS_BIM_MM_0165'/></th>
                                      <td colspan="2" id="gdKind" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_MM_0166'/></th>
                                      <td colspan="4" id="email" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_MM_0175'/></th>
                                      <td colspan="4" id="contCharge" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_MM_0176'/></th>
                                      <td colspan="4" id="settleCharge" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_MM_0177'/></th>
                                      <td colspan="4" id="techCharge" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0416'/></th>
                                      <td colspan="4" id="bankCd" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0417'/></th>
                                      <td colspan="2" id="vaNo" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                      <th><spring:message code='IMS_BIM_BIM_0027'/></th>
                                      <td colspan="2" id="vaNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_MM_0087'/></th>
                                      <td colspan="4" id="stmtCycle" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0419'/></th>
                                      <td colspan="4" id="rsRate" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                   <tr>
                                      <th rowspan="8" class="th_verticleLine"><spring:message code='IMS_BIM_MM_0045'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0420'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0421'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0422'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0423'/></th>
                                  </tr>
                                  <tr>
                                      <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code='IMS_BIM_BM_0424'/></td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code='IMS_BIM_BM_0425'/></td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">원</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">-</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code='IMS_BIM_BM_0281'/>1-11601</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">원</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code='IMS_BIM_BM_0281'/>11601~</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code='IMS_BIM_BM_0282'/></td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">원</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code='IMS_BIM_BM_0426'/></td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                      <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code='IMS_BIM_BM_0427'/></td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;">%</td>
                                      <td style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                                  	<td id="tdBtnVidSetting"></td>
                                  </tr>
                                 </thead>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END MODAL -->
		<!-- BEGIN FEE_REG_OVER_CARD_LIST MODAL -->
		<div class="modal fade" id="modalFeeRegOverCardLst"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0467"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="tb_feeRegOverCardLst" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0178'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0310'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0465'/></th>
                                  </tr>
                                 </thead>
                                 <tbody id="tbody_feeRegOverCardList"></tbody>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END FEE_REG_OVER_CARD_LIST MODAL -->
		<!-- BEGIN FEE_REG_CARD_LIST MODAL -->
		<div class="modal fade" id="modalFeeRegCardLst"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0467"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="tb_feeRegCardLst" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0178'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0310'/></th>
                                      <th><spring:message code='DDLB_0144'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0465'/></th>
                                  </tr>
                                 </thead>
                                 <tbody id="tbody_feeRegCardList"></tbody>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END FEE_REG_CARD_LIST MODAL -->
		<!-- BEGIN MODAL -->
		<div class="modal fade" id="modalFeeNonInstCard"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="DDLB_0139"/> INFORMATION</h4>
		                <br />
		            </div>
		            <div class="modal-body">
		                <div class="row form-row">
		                    <table class="table" id="feeNonInstCard" style="width:100%">
                                <thead>
                                	<tr>
                                		<td id="cardNm" style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;">무이자수수료</td>
                                	</tr>
                                	<tr>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0464" /></td>
                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0310" /></td>
                                		<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0465"/></td>
                                	</tr>
                                </thead>
                                <tbody id="tbody_result">
                                </tbody>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END MODAL -->
        <!-- END CONTAINER -->
        
       
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
	                document.getElementById('Address1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('Address2').value = fullAddr;
                }else if (chk == '2'){
                	document.getElementById('BusinessAddr1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('BusinessAddr2').value = fullAddr;
                }else if(chk == '3'){
                	//vid
	                $("#tbNomalVidInfo #Address1").val( data.zonecode); //5자리 새우편번호 사용
	                $("#tbNomalVidInfo #Address2").val( fullAddr);
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
