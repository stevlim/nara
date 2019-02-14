<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var fnBaseInfoInquiry;
var strType;
$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#MER_SEARCH").html("<c:out value='${MER_SEARCH}' escapeXml='false' />");	
	$("#MER_TYPE").html("<c:out value='${MER_TYPE}' escapeXml='false' />");	
	$("#COMPANY_TYPE").html("<c:out value='${COMPANY_TYPE}' escapeXml='false' />");	
	$("#OM_PAY_SETTLE").html("<c:out value='${OM_PAY_SETTLE}' escapeXml='false' />");	
	$("#SHOP_TYPE").html("<c:out value='${SHOP_TYPE}' escapeXml='false' />");	
	$("#USE_STATUS").html("<c:out value='${USE_STATUS}' escapeXml='false' />");	
}

function fnInit(){
	$("#midInfo").hide();
	$("#gidInfo").hide();
	$("#vidInfo").hide();
}

function fnInitEvent() {	
    
    $("input[name='CHK_PAY_TYPE']").click(function () {
        var chk_listArr = $("input[name='svcList']");
        for (var i=0; i < chk_listArr.length; i++) {
            chk_listArr[i].checked = this.checked;
        }
    });

    $("#txtFromDate").on("change", function(){
        $("#TRANS_FROM_TM").val("00:00");        
    });    

    $("#txtToDate").on("change", function(){
        $("#TRANS_TO_TM").val("24:00");
    });
    
    $("#btnSearch").on("click", function(){
		if($("#MER_SEARCH_TEXT").val()==""){
			if($("#MER_SEARCH option:selected").val() == '1' ||$("#MER_SEARCH option:selected").val() == '5' ){
		    	IONPay.Msg.fnAlert(" ID만 조회 가능합니다.");
		    }else{
	   			IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + " 를 입력해 주세요.");
		    }	
	   	}else if( $("#MER_SEARCH_TEXT").val()!="" && ($("#MER_SEARCH option:selected").val() == '1' ||$("#MER_SEARCH option:selected").val() == '5')){
		    	IONPay.Msg.fnAlert(" ID만 조회 가능합니다.");
	   	}else{
	   		$("#ListSearch").hide();
	   		if($("#MER_SEARCH option:selected").text() == 'MID'){
      			//mid
      			$("#midInfo").show(200);
	       		$("#gidInfo").hide();
	       		$("#vidInfo").hide();
	      		}else if($("#MER_SEARCH option:selected").text() == 'GID' ){
	      			//gid
	      			$("#midInfo").hide();
	   			$("#gidInfo").show(200);
	   			$("#vidInfo").hide();
	      		}else if($("#MER_SEARCH option:selected").text() == 'VID'){
	      			//aid
	      			$("#midInfo").hide();
	   			$("#gidInfo").hide();
	   			$("#vidInfo").show(200);
	      		}
	   		fnSelectBaseInfo();
	   	}
    });
    
    $("#btnExcel").on("click", function(){
    	strType="EXCEL";
    	fnBaseInfoInquiry(strType);
    });
    
    $("#btnListSearch").on("click", function(){
    	strType="SEARCH";
    	fnBaseInfoInquiry(strType);
    	$("#ListSearch").show();
    	
    });
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
function fnSelectBaseInfo(){
	if($("#MER_SEARCH option:selected").text() == "MID"){
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		arrParameter["MER_VAL"]    = '2';
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectBaseInfoRet";
	}else if($("#MER_SEARCH option:selected").text() == "GID"){
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		arrParameter["MER_VAL"]    = '3';
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectGidInfoRet";
	}else if($("#MER_SEARCH option:selected").text() == "VID"){
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["MER_VAL"]    = '4';
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectVidInfoRet";
	}
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectBaseInfoRet(objJson){
	if (objJson.resultCode == 0) {
		var map = new Map();
		if(objJson.midInfo != null ){
			console.log(objJson.midInfo[0]);
			$("#midInfo #MID").html(objJson.midInfo[0].MID);
			$("#midInfo #GID").html(objJson.midInfo[0].GID);
			$("#midInfo #VID").html(objJson.midInfo[0].VID);
			$("#midInfo #CO_NO").html(objJson.midInfo[0].CO_NO);
			$("#midInfo #MerchantName").html(objJson.midInfo[0].CO_NM);
			$("#midInfo #RepersentativeName").html(objJson.midInfo[0].REP_NM);
			$("#midInfo #RepersentativeTel	").html(objJson.midInfo[0].TEL_NO);
			$("#midInfo #RepersentativeFAX").html(objJson.midInfo[0].FAX_NO);
			$("#midInfo #E-MAIL").html(objJson.midInfo[0].EMAIL);
			$("#midInfo #SignName").html(objJson.midInfo[0].SIGN_NM);
			$("#midInfo #URL").html(objJson.midInfo[0].MID_URL);
			$("#midInfo #ClassificationBusiness").html(objJson.midInfo[0].BS_KIND);
			$("#midInfo #BusinessStatus").html(objJson.midInfo[0].GD_KIND);
			$("#midInfo #UseStatus").html(objJson.midInfo[0].USE_NM);
			$("#midInfo #Address").html(objJson.midInfo[0].ADDR_NO1 +" " +  objJson.midInfo[0].ADDR_NO2);
			$("#midInfo #BusinessAddr").html(objJson.midInfo[0].RADDR_NO1 +" " + objJson.midInfo[0].RADDR_NO2);
			$("#midInfo #FranchiseType").html(objJson.midInfo[0].MBS_TYPE_NM);
			$("#midInfo #OMPaySettle").html(objJson.midInfo[0].OM_SETT_NM);
			$("#midInfo #ContractStaff").html(objJson.midInfo[0].CONT_EMP_NM);
			$("#midInfo #CompanyType").html(objJson.midInfo[0].CO_CL_NM);
			$("#midInfo #AcctRiskLvl").html(objJson.midInfo[0].ACCNT_RISK_GRADE + "등급");
			$("#midInfo #BigCategory").html(objJson.midInfo[0].BIG_KIND_CD);
			$("#midInfo #SmallCategory").html(objJson.midInfo[0].SM_KIND_CD);
			$("#midInfo #ShopType").html(objJson.midInfo[0].MALL_TYPE_NM);
			$("#midInfo #ContractDate").html(objJson.midInfo[0].CONT_DT);
			$("#midInfo #AcceptRoute").html(objJson.midInfo[0].RECV_CH_NM);
			$("#midInfo #ContractStaffName").html(objJson.midInfo[0].CONT_EMP_NM);
			$("#midInfo #ContractStaffTel").html(objJson.midInfo[0].CONT_EMP_TEL);
			$("#midInfo #ContractStaffCP").html(objJson.midInfo[0].CONT_EMP_HP);
			$("#midInfo #ContractStaffEmail").html(objJson.midInfo[0].CONT_EMP_EMAIL);
			$("#midInfo #CalculateStaffName").html(objJson.midInfo[0].STMT_EMP_NM);
			$("#midInfo #CalculateStaffTel").html(objJson.midInfo[0].STMT_EMP_TEL);
			$("#midInfo #CalculateStaffCP").html(objJson.midInfo[0].STMT_EMP_CP);
			$("#midInfo #CalculateStaffEmail").html(objJson.midInfo[0].STMT_EMP_EMAIL);
			$("#midInfo #TechnologyStaffName").html(objJson.midInfo[0].TECH_EMP_NM);
			$("#midInfo #TechnologyStaffTel").html(objJson.midInfo[0].TECH_EMP_TEL);
			$("#midInfo #TechnologyStaffCP").html(objJson.midInfo[0].TECH_EMP_CP);
			$("#midInfo #TechnologyStaffEmail").html(objJson.midInfo[0].TECH_EMP_EMAIL);
			//기타정보
			$("#midInfo #CashReceipt").html(objJson.midInfo[0].CSHRCPT_AUTO_NM);
			$("#midInfo #PaymentNotice").html(objJson.midInfo[0].PAY_NOTI_NM);
			$("#midInfo #CardSalesStatement").html(objJson.midInfo[0].RCPT_PRT_NM);
			$("#midInfo #VAT").html(objJson.midInfo[0].VAT_MARK_NM);
			$("#midInfo #VACCTDepositLimit").html("D+ "+objJson.midInfo[0].VACCT_LMT_DAY);
			$("#midInfo #VACCTNumberForm").html(objJson.midInfo[0].VACCT_TYPE_NM);
			$("#midInfo #UnsentAutoCancle").html(objJson.midInfo[0].AUTO_CANCEL_NM);
			$("#midInfo #UseEscrowYN").html(objJson.midInfo[0].ESCROW_NM);
			$("#midInfo #AuthorizationVAN").html(objJson.midInfo[0].APP_VAN1_NM);
			$("#midInfo #PurchaseVAN").html(objJson.midInfo[0].ACQ_VAN_NM);
			$("#midInfo #PhoneFeeSection").html(objJson.midInfo[0].CP_SLIDING_TYPE=="1"?"2001이상만" : "2001~이상 사용");
			$("#midInfo #PushFailedSMS").html(objJson.midInfo[0].SMS_PUSH_FLG=="1"?"허용":"허용안함");
			$("#midInfo #MerchantKeyModify").html(objJson.midInfo[0].MBS_KEY_AUTH_FLG=="0"?"불가능":"가능");
			$("#midInfo #MmsPaymentAuthority").html(objJson.midInfo[0].MMS_PAY_FLG=="0"?"권한없음":"권한있음");
			$("#midInfo #OverlapOrderCheck").html(objJson.midInfo[0].ORD_NO_DUP_FLG=="0"?"미사용":"사용");
			$("#midInfo #UsePushPayYN").html(objJson.midInfo[0].PUSH_PAY_CD=="0"?"미사용":"사용");
			$("#midInfo #PurchaseWay").html(objJson.midInfo[0].ACQ_CL_NM);
			
			$("#midInfo #AcctInfo1").html((objJson.midInfo[0].BANK_CD==null?"":objJson.midInfo[0].BANK_CD )+"  "+(objJson.midInfo[0].ACCNT_NO==null?"":objJson.midInfo[0].ACCNT_NO));
			
			
			//정산
			$("#midInfo #PurchaseWay").html(objJson.midInfo[0].ACQ_CL_NM);
			$("#midInfo #PurchaseDate").html("D+"+objJson.midInfo[0].ACQ_DAY);
			$("#midInfo #PayMethod").html(objJson.midInfo[0].PAY_ID_NM);
			$("#midInfo #CancelFunction").html(objJson.midInfo[0].CC_CL_NM);
			$("#midInfo #PartialCancelFunction").html((objJson.midInfo[0].CC_PART_CARD=="1"?"신용카드":"")+" "+(objJson.midInfo[0].CC_PART_ACCT=="1"?"계좌이체":"")+" "+(objJson.midInfo[0].CC_PART_VACCT=="1"?"가상계좌":""));
			$("#midInfo #LCPB").html(objJson.midInfo[0].CC_CHK_NM);
			$("#midInfo #AutoSetoff").html(objJson.midInfo[0].AUTO_CAL_NM);
			$("#midInfo #AcctInfo1").html(objJson.midInfo[0].BANK_NM + " " +  objJson.midInfo[0].ACCNT_NO_ENC==null?"":objJson.midInfo[0].ACCNT_NO_ENC) ;
			$("#midInfo #AcctHolder1").html(objJson.midInfo[0].ACCNT_NM);
			if(objJson.settleServiceInfo != null ){
				if(objJson.settleServiceInfo[0].PM_CD=="00"){
					var noFlg = objJson.settleServiceInfo[0].STMT_SVC_CD+objJson.settleServiceInfo[0].STMT_SVC_VALUE;
					$("#midInfo #FeePayMethod").html(objJson.settleServiceInfo[0].SERVICE_VAL_NM);
				}else{
					var flg = objJson.settleServiceInfo[0].STMT_SVC_CD+objJson.settleServiceInfo[0].PM_CD+objJson.settleServiceInfo[0].STMT_SVC_VALUE;
					$("#midInfo #FeePayMethod").html(objJson.settleServiceInfo[0].SERVICE_VAL_NM);
				}
			}
			
			var pmCd = ["01", "02", "03", "05"];
		  	var spmCd = ["01", "02", "03", "05"]; //"01", "02", "03"
			if(objJson.settleCycle != null){
				if(objJson.settleCycle.length > 0 ){
				  	
				  	for(var i=0; i<pmCd.length; i++){
				  		for(var j=0; j<spmCd.length; j++){
				  			var settCycle = "미정산";
				  			var settType = "";
				  			
				  			for(var k=0; k<objJson.settleCycle.length; k++){
				  				settType  = ( objJson.settleCycle[k].STMT_TYPE_NM==null?"":objJson.settleCycle[k].STMT_TYPE_NM);
				  				if((objJson.settleCycle[k].PM_CD == pmCd[i]) && (objJson.settleCycle[k].SPM_CD==spmCd[j])){
				  					settCycle = objJson.settleCycle[k].SETTLMNT_CYCLE_NM;
				  					break;
				  				}
				  			}
				  			map.set("STMT_CYCLE_" + pmCd[i] + spmCd[j] , settCycle);
				  			map.set("STMT_TYPE_" + pmCd[i] + spmCd[j] , settType);
				  			$("#midInfo #stmtCyc").html(map.get("STMT_CYCLE_0101"));
				  		}
				  	}
				}
			}
		  	
			if(objJson.settleFeeInfo != null){
		  		 for(var i = 0; i < objJson.settleFeeInfo.length; i++) {
		  		    if(objJson.settleFeeInfo[i].SPM_CD != "02"){
			  		    var fee = objJson.settleFeeInfo[i].PM_CD + objJson.settleFeeInfo[i].SPM_CD + objJson.settleFeeInfo[i].CP_CD
		  			    map.set("FEE_"+id, objJson.settleFeeInfo[i].FEE);
			  		    if(objJson.settleFeeInfo[i].FEE_TYPE_CD == "2"){
							map.set("FEE_TYPE_" + fee, "%");
			  		    }else if(objJson.settleFeeInfo[i].FEE_TYPE_CD == "3"){
			  		    	map.set("FEE_TYPE_" + fee, "원");
			  		    }
	  		    	}
		  		}	  		
		  	}
			if(objJson.cardInfo != null){
		  		for(var i = 0; i < objJson.cardInfo.length; i++) {
		  		    if(objJson.cardInfo[i].PM_CD != "02"){
		  			    var mbsNo = "MBS_NO_"+ objJson.cardInfo[i].NON_INST + objJson.cardInfo[i].SPM_CD + objJson.cardInfo[i].CP_CD;
		  			    map.set(mbsNo, objJson.cardInfo[i].MBS_NO);
		  			    
		  			    var termNo= "TERM_NO_"+objJson.cardInfo[i].NON_INST+ objJson.cardInfo[i].SPM_CD + objJson.cardInfo[i].CP_CD;
		  			  	map.set(termNo, objJson.cardInfo[i].TERM_NO);
		  		    }
		  		  }
		  	}
			if(objJson.payType != null){
				//지불수단
				for(var i=0; i<pmCd.length; i++){
			  		for(var j=0; j<spmCd.length; j++){
			  			var useCl = "사용안함";
			  			for(var k=0; k<objJson.payType.length;k++){
			  				if((objJson.payType[k].PM_CD == pmCd[i]) && objJson.payType[k].SPM_CD == spmCd[j]){
			  					if(objJson.payType[k].USE_CL=="1"){
			  						useCl = "사용";
			  					}else{
			  						useCl = "사용안함";
			  					}
			  					break;
			  				}
			  			}
			  			map.set("USE_CL_"+pmCd[i]+spmCd[j], useCl);
			  			$("#midInfo #cardUsFlg").html(map.get("USE_CL_0101"));
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
				//IPG 카드
				$("#midInfo #authFlg").html(objJson.midInfo[0].AUTH_TYPE_NM);
				$("#midInfo #useCard").html(cardUseIn);
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
					    var terNo = map.get("TERM_NO_0101" +cpCd ) == null ? "&nbsp;" :map.get("TERM_NO_0101" +cpCd ) ;
					    if(i <= numMajorCard+numOverCard) {
					    	if(terNo != null || terNo != ""){
					    		terNo = "(T:"+terNo+")";
					    	}
				    		str += "<td style='text-align: center; border: 1px solid #ddd; '>"+(map.get("MBS_NO_0101"+cpCd )==null?"&nbsp;":map.get("MBS_NO_0101"+cpCd ))+"<br><span>"+terNo+"</span>"+"</td>";
				    		str += "<td style='text-align: center; border: 1px solid #ddd; '>"+(map.get("FEE_0101"+cpCd)==null?'&nbsp;' : map.get("FEE_0101"+cpCd)) + (map.get("FEE_TYPE_0101"+cpCd)==null?'&nbsp;':map.get("FEE_TYPE_0101"+cpCd))+"<br><span>"+(map.get("FEE_TYPE_0101"+cpCd)==null?'&nbsp;':map.get("FEE_TYPE_0101"+cpCd))+"</span></td>";
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
					    
					    var terNo = map.get("TERM_NO_0201"+cpCd) == null? "&nbsp;":map.get("TERM_NO_0201"+cpCd);
					    if(terNo != null || terNo != ""){
					    	terNo = "(T:"+terNo+")";
					    }
					    if(i < numMajorCard){
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '>&nbsp; "+(map.get("MBS_NO_0201"+cpCd)==null?"&nbsp;":map.get("MBS_NO_0201"+cpCd))+"<br><span>"+terNo+"</span></td>";
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '> <input type='button' value='보기' class='btn btn-success btn-cons'  onclick='fnFeeNonInterest("+i+");'></td>";
					    }else{
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '>&nbsp;</td>";
					    	str += "<td style='text-align: center; border: 1px solid #ddd; '>&nbsp;</td>";
					    }
				    } 
				    str += "</tr>";
				}
				str += "<tr style='text-align: center; '><th colspan='2'  style='text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;'>할부개월제한</th>";
				str += "<td colspan='13'  style='text-align: left; border: 1px solid #ddd; ' >"+(objJson.midInfo[0].LMT_INSTMN==null?"&nbsp;":objJson.midInfo[0].LMT_INSTMN)+"개월(12개월일 경우 제한없음)</td></tr>";
				
			}
			
			//card table 결과 
			$("#midInfo #tb_card").html(str);
			//ㄴㅏ머지 결과(계좌이체)
			$("#midInfo #td_acctStmtCycle").html(map.get("STMT_CYCLE_0201")==null?"&nbsp;" : map.get("STMT_CYCLE_0201"));
			$("#midInfo #td_acctUseChk").html(map.get("USE_CL_0201")==null?"&nbsp;" : map.get("USE_CL_0201"));
			$("#midInfo #td_acctFee").html(map.get("FEE_020101")==null?"&nbsp;":map.get("FEE_020101") + "원");
			$("#midInfo #td_acctFee2").html(map.get("FEE_020102")==null?"&nbsp;":map.get("FEE_020102") + "%");
			$("#midInfo #td_acctAllPart").html(map.get("FEE_020103")==null?"&nbsp;":map.get("FEE_020103") + "%");
			
			//ㄴㅏ머지 결과(가상계좌)
			$("#midInfo #td_vacctStmtCycle").html(map.get("STMT_CYCLE_0301")==null?"&nbsp;" : map.get("STMT_CYCLE_0301"));
			$("#midInfo #td_vacctUseChk").html(map.get("USE_CL_0301")==null?"&nbsp;" : map.get("USE_CL_0301"));
			$("#midInfo #td_vacctType").html("&nbsp;");
			$("#midInfo #td_vacctFee").html("건당 "+map.get("FEE_030100")==null?"&nbsp;":map.get("FEE_030100") + "원");
			
			//ㄴㅏ머지 결과(휴대폰)
			$("#midInfo #td_phStmtCri").html(map.get("STMT_TYPE_0501")==null?"&nbsp;" : map.get("STMT_TYPE_0501"));
			$("#midInfo #td_phStmtCycle").html(map.get("STMT_CYCLE_0501")==null?"&nbsp;" : map.get("STMT_CYCLE_0501"));
			$("#midInfo #td_phUseChk").html(map.get("USE_CL_0501")==null?"&nbsp;" : map.get("USE_CL_0501"));
			$("#midInfo #td_phFee").html(map.get("FEE_050100")==null?"":map.get("FEE_050100") +"," + map.get("FEE_TYPE_050100")==null?"":map.get("FEE_TYPE_050100"));
			
			//ㄴㅏ머지 결과(휴대폰빌링)
			$("#midInfo #td_phBillStmtCri").html(map.get("STMT_TYPE_0601")==null?"&nbsp;" : map.get("STMT_TYPE_0601"));
			$("#midInfo #td_phBillStmtCycle").html(map.get("STMT_CYCLE_0601")==null?"&nbsp;" : map.get("STMT_CYCLE_0601"));
			$("#midInfo #td_phBillUseChk").html(map.get("USE_CL_0601")==null?"&nbsp;" : map.get("USE_CL_0601"));
			$("#midInfo #td_phBillFee").html(map.get("FEE_060100")==null?"":map.get("FEE_060100") +"," + map.get("FEE_TYPE_060100")==null?"":map.get("FEE_TYPE_060100"));
			
			//ㄴㅏ머지 결과(sms 수수료 )
			$("#midInfo #td_smsFee").html(map.get("FEE_SMS0101")==null?"":map.get("FEE_SMS0101") +"원" );
			
			//등록정보
			$("#midInfo #regWorker").html(objJson.midInfo[0].WORKER);
			$("#midInfo #regDt").html(IONPay.Utils.fnStringToDateFormat(objJson.midInfo[0].REG_DNT));
			$("#midInfo #updWorker").html(objJson.midInfo[0].WORKER);
			$("#midInfo #updDt").html(IONPay.Utils.fnStringToDateFormat(objJson.midInfo[0].UPD_DNT));
			
			$("#Information").show();
	    	$("#OtherInformation").show();
	    	$("#CalculationInformation").show();
	    	$("#IPG").show();
	    	$("#PayMethodArea").show();
	    	$("#ForeignPayment").show();
	    	$("#Others").show();
	    	$("#RegistrationInformation").show();
	    	
		}else {
			IONPay.Msg.fnAlert("data not exist");
			$("#Information").hide();
	    	$("#OtherInformation").hide();
	    	$("#CalculationInformation").hide();
	    	$("#IPG").hide();
	    	$("#PayMethodArea").hide();
	    	$("#ForeignPayment").hide();
	    	$("#Others").hide();
	    	$("#RegistrationInformation").hide();
		}
        IONPay.Utils.fnJumpToPageTop();
	}else{
    	$("#Information").hide();
    	$("#OtherInformation").hide();
    	$("#CalculationInformation").hide();
    	$("#IPG").hide();
    	$("#PayMethodArea").hide();
    	$("#ForeignPayment").hide();
    	$("#Others").hide();
    	$("#RegistrationInformation").hide();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}
function fnSelectGidInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.gidInfo != null ){
			if(objJson.gidInfo.length > 0 ){
				$("#gidInfo #gid").html(objJson.gidInfo[0].GID);
				$("#gidInfo #issuDt").html(objJson.gidInfo[0].REG_DT);
				$("#gidInfo #gNm").html(objJson.gidInfo[0].G_NM);
				$("#gidInfo #coNo").html(objJson.gidInfo[0].CO_NO);
				$("#gidInfo #vaNo").html(objJson.gidInfo[0].VGRP_NO);
				$("#gidInfo #vaNm").html(objJson.gidInfo[0].VGRP_NM);
				$("#gidInfo #manager").html(" Manager : " + (objJson.gidInfo[0].EMP1_NM==null ?"":objJson.gidInfo[0].EMP1_NM)+ "  Tel :  " + (objJson.gidInfo[0].EMP1_TEL==null?"":objJson.gidInfo[0].EMP1_TEL )+ "   CP : " + (objJson.gidInfo[0].EMP1_CP==null?"":objJson.gidInfo[0].EMP1_CP) + "   EMAIL : " +(objJson.gidInfo[0].EMP1_EMAIL==null?"":objJson.gidInfo[0].EMP1_EMAIL ) );
				$("#gidInfo #manager2").html(" Manager : " + (objJson.gidInfo[0].EMP2_NM==null?"":objJson.gidInfo[0].EMP2_NM) + "  Tel :  " + (objJson.gidInfo[0].EMP2_TEL==null?"":objJson.gidInfo[0].EMP2_TEL) + "   CP : " + (objJson.gidInfo[0].EMP2_CP==null?"":objJson.gidInfo[0].EMP2_CP) + "   EMAIL : " +(objJson.gidInfo[0].EMP2_EMAIL==null?"":objJson.gidInfo[0].EMP2_EMAIL) );
			}
			if(objJson.gidMidInfo==null){
				var str = "";
	  			str += '<th rowspan="2" style="text-align: center;font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"> <spring:message code="IMS_BIM_BM_0462"/> </th>';
	  			str += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0142"/></th>';
	  			str += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0083"/></th>';
	  			str += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0194"/></th>';
	  			$("#gidInfo #trBottomGidInfo").html(str);
	  			
				$("#gidInfo #coNm1").empty();
				$("#gidInfo #coNo1").empty();
				$("#gidInfo #mid").empty();
			}else if(objJson.gidMidInfo.length>0){
	            var str = "";
	  			str += '<th rowspan=\" ' + (objJson.gidMidInfo.length+1) + ' \" class="th_verticleLine" style="text-align: center;font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"> <spring:message code="IMS_BIM_BM_0462"/> </th>';
	  			str += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0142"/></th>';
	  			str += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0083"/></th>';
	  			str += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0194"/></th>';
	  			$("#gidInfo #trBottomGidInfo").html(str);
	  			
				$("#gidInfo #coNm1").html(objJson.gidMidInfo[0].CO_NM);
				$("#gidInfo #coNo1").html(objJson.gidMidInfo[0].CO_NO);
				$("#gidInfo #mid").html(objJson.gidMidInfo[0].MID);
			}
			if(objJson.gidBankList.length>0){
				for(var i=0; i<objJson.gidBankList.length; i++){
					if(objJson.gidInfo[0].BANK_CD==objJson.gidBankList[i].CODE1){
						$("#gidInfo #bankCd").html(objJson.gidBankList[i].DESC1);
					}
				}
			}
			$("#gidInfo").show();
		}else{
			IONPay.Msg.fnAlert("data not exist");
			$("#gidInfo").hide();
		}
	IONPay.Utils.fnJumpToPageTop();
	}else{
		$("#gidInfo").hide();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}
function fnSelectVidInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.vidInfo != null){
			if(objJson.vidInfo.length > 0 ){
				$("#vidInfo #vId").html(objJson.vidInfo[0].VID);
				$("#vidInfo #vNm").html(objJson.vidInfo[0].VGRP_NM);
				$("#vidInfo #coNo").html(objJson.vidInfo[0].CO_NO);
				$("#vidInfo #repNm").html(objJson.vidInfo[0].REP_NM);
				$("#vidInfo #bsKind").html(objJson.vidInfo[0].BS_KIND);
				$("#vidInfo #gdKind").html(objJson.vidInfo[0].GD_KIND);
				$("#vidInfo #email").html(objJson.vidInfo[0].EMAIL);
				
				$("#vidInfo #contCharge").html(" Manager : " + (objJson.vidInfo[0].CONT_NM==null ?"":objJson.vidInfo[0].CONT_NM)+ "  Tel :  " + (objJson.vidInfo[0].CONT_TEL==null?"":objJson.vidInfo[0].CONT_TEL )+ "   CP : " + (objJson.vidInfo[0].CONT_CP==null?"":objJson.vidInfo[0].CONT_CP) + "   EMAIL : " +(objJson.vidInfo[0].CONT_EMAIL==null?"":objJson.vidInfo[0].CONT_EMAIL ));
				$("#vidInfo #settleCharge").html(" Manager : " + (objJson.vidInfo[0].SETT_NM==null ?"":objJson.vidInfo[0].SETT_NM)+ "  Tel :  " + (objJson.vidInfo[0].SETT_TEL==null?"":objJson.vidInfo[0].SETT_TEL )+ "   CP : " + (objJson.vidInfo[0].SETT_CP==null?"":objJson.vidInfo[0].SETT_CP) + "   EMAIL : " +(objJson.vidInfo[0].SETT_EMAIL==null?"":objJson.vidInfo[0].SETT_EMAIL ));
				$("#vidInfo #techCharge").html(" Manager : " + (objJson.vidInfo[0].TECH_EMP_NM==null ?"":objJson.vidInfo[0].TECH_EMP_NM)+ "  Tel :  " + (objJson.vidInfo[0].TECH_EMP_TEL==null?"":objJson.vidInfo[0].TECH_EMP_TEL )+ "   CP : " + (objJson.vidInfo[0].TECH_EMP_CP==null?"":objJson.vidInfo[0].TECH_EMP_CP) + "   EMAIL : " +(objJson.vidInfo[0].TECH_EMP_EMAIL==null?"":objJson.vidInfo[0].TECH_EMP_EMAIL ));
				$("#vidInfo #vaNo").html(objJson.vidInfo[0].ACCNT_NO_ENC);
				$("#vidInfo #vaNm").html(objJson.vidInfo[0].ACCNT_NM);
				$("#vidInfo #settleCycle").html(objJson.vidInfo[0].STMT_CYCLE_CD=="C115" ? "결제월+1개월째 15일" :objJson.vidInfo[0].V_SETTLE_CYCLE);
				$("#vidInfo #rsRate").html(objJson.vidInfo[0].RSHARE_RATE);
				$("#vidInfo #Address1").html(objJson.vidInfo[0].POST_NO);
				$("#vidInfo #Address2").html(objJson.vidInfo[0].ADDR_NO1);
				$("#vidInfo #Address3").html(objJson.vidInfo[0].ADDR_NO2);
				
				if(objJson.vidBankList.length>0){
					for(var i=0; i<objJson.vidBankList.length; i++){
						if(objJson.vidInfo[0].BANK_CD==objJson.vidBankList[i].CODE1){
							$("#vidInfo #bankCd").html(objJson.vidBankList[i].DESC1);
						}
					}
				}
			}
			if(objJson.vidFeeInfo != null){
				if(objJson.vidFeeInfo.length > 0){
				var strServiceName = new Array("신용카드 (국내)", "신용카드 (국내)", "신용카드 (해외)", "신용카드 (해외)", "계좌이체", "계좌이체", "가상계좌", "휴대폰", "휴대폰");
	        	var strFrAmt = new Array("1", "1", "1", "1", "1", "11601", "1", "1", "1");
	        	var strPmCd= new Array("01", "01", "01", "01", "02", "02", "03", "05", "05");
	      	 	var strFeeType = new Array("2", "2", "2", "2", "3", "2", "3", "2", "2");
		  		var strCpCd  = new Array("00", "00", "99", "99", "00", "00", "00", "CONTENTS", "GOODS");
				var str = "";
				str+='<tr>';
		  		str+='<th rowspan="10" class="th_verticleLine" style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_MM_0045"/></th>';
		  		str+='<th colspan="2" style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0420"/></th>';
		  		str+='<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0421"/></th>';
		  		str+='<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0422"/></th>';
		  		str+='<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0423"/></th></tr>';
		  		str+='</tr>';
		  		
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
			  				str += "<tr>";
			  				str += '<td style="text-align: center; border: 1px solid #ddd; ">' +strServiceName[i]+  '</td>';
			  				str += '<td style="text-align: center; border: 1px solid #ddd; ">';
			  				if(i == 0 || i == 2 ){
			  					str += '정률제';
			  				}else if(i == 1 || i == 3 ){
			  					str += '정액제';
			  				}else if(i == 4 ){
			  					str += strFrAmt[i] + '원~ '+strFrAmt[i+1]+ '원';
			  				}else if(i == 5 ){
			  					str += strFrAmt[i] + '원~';
			  				}else if(i == 6 ){
			  					str += '-';
			  				}else if(i == 7 ){
			  					str += '컨텐츠';
			  				}else if(i == 8 ){
			  					str += '실물';
			  				}
			  				str += '</td>';
			  				
			  				str+='<td style="text-align: center; border: 1px solid #ddd;">'; 
		  					if(i==1 || i==3){
			  					str += map.get("ETC_FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )==null?'': (map.get("ETC_FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )) ;
			  				}else {
			  					str += map.get("FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )==null?'': (map.get("FEE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] ));
			  				}
			  				if(i != 1 && i != 3 && strFeeType[i]=="2"){
			  					str += '%';
			  				}else if(i == 1 || i == 3 || strFeeType[i]=="3"){
			  					str += '원';
			  				}
			  				str += '</td>';
			  				
			  				str += '<td style="text-align: center; border: 1px solid #ddd;">';
			  				if(i != 1 && i != 3 ){
			  					str += map.get("SHARE_RATE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] )==null?'': (map.get("SHARE_RATE_"+strPmCd[i]+strFeeType[i]+strCpCd[i] ));				
			  				}else{
			  					str += '-';
			  				}
			  				str += '</td>';
			  				
			  				if(map.get("FR_DT_"+strPmCd[i]+strFeeType[i]+strCpCd[i]) == ''){
								str += '<td style="text-align: center; border: 1px solid #ddd;"> - </td>';
			  				}else{
								str += '<td style="text-align: center; border: 1px solid #ddd;">' + (map.get("FR_DT_"+strPmCd[i]+strFeeType[i]+strCpCd[i])==null?'': map.get("FR_DT_"+strPmCd[i]+strFeeType[i]+strCpCd[i]) )+ '</td> ';
			  					
			  				}
			  				str += "</tr>";
			  		}
		  			
	  				$("#vidInfo #trFeeInfo").html(str);
	  			}	
			} 
	  		if(objJson.vidMidInfo.length > 0){
	  			var str1 = "";
	  			str1 += '<th rowspan=\" ' + (objJson.vidMidInfo.length+1) + ' \" class="th_verticleLine" style="text-align: center;font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"> <spring:message code="IMS_BIM_BM_0462"/> </th>';
	  			str1 += '<th colspan="2" style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0142"/></th>';
	  			str1 += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_BIM_BM_0083"/></th>';
	  			str1 += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"><spring:message code="IMS_PW_DE_09"/></th>';
	  			str1 += '<th style="text-align: center; font-weight: bold; border: 1px solid #ddd; background-color: #ecf0f2;"></th>';
	  			$("#vidInfo #trBottomInfo").html(str1);
	  			$("#vidInfo #botCoNm").html(objJson.vidMidInfo[0].CO_NM);
				$("#vidInfo #botCoNo").html(objJson.vidMidInfo[0].CO_NO);
				$("#vidInfo #botMid").html(objJson.vidMidInfo[0].MID);
	  		}
	  		$("#vidInfo").show();
		}else{
			IONPay.Msg.fnAlert("data not exist");
			$("#vidInfo").hide();
		}
	IONPay.Utils.fnJumpToPageTop();
	}else{
		$("#vidInfo").hide();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}
function checkSelectedValue(){
    var valueArr = new Array();
    var list = $("input[name='chk_list']");
    for(var i = 0; i < list.length; i++){
        if(list[i].checked){ //선택되어 있으면 배열에 값을 저장함
            valueArr.push(list[i].value);
        }
    }
    
}


function fnBaseInfoInquiry(strType) {
	if(strType == "SEARCH"){
	if (typeof objBaseInfoInquiry == "undefined") {
	   objBaseInfoInquiry = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
        url: "/baseInfoMgmt/baseInfoMgmt/selectBaseInfoList.do",
        data: function() {	
            return $("#frmSearch").serializeObject();
        },
        columns: [
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MBS_TYPE_NM} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NO} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MID} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.GID} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.VID} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REG_DNT} },
            { "class" : "columnc all",         "data" : null, "render": function(data){return  "<input type='button' value='상세보기' onclick=\"javascript:fnMerInfo( '" +data.ID_CD + "', '" +  data.ID +"', '" + "');\" class='btn btn-primary btn-cons'/>"} },
            { "class" : "columnc all",         "data" : null, "render": function(data, auth){return  auth==null?"권한없음":(auth.FINFO_AUTH_FLG1=="1"?"<input type='button' value='메일발송' class='btn btn-primary btn-cons' onclick='sndMailSearch("+data.MID+");'>" : "권한없음") } }
            ]
	    }, true);
	} else {
		   objBaseInfoInquiry.clearPipeline();
	    objBaseInfoInquiry.ajax.reload();
	}
	$("#midInfo").hide();
	$("#gidInfo").hide();
	$("#vidInfo").hide();
	IONPay.Utils.fnShowSearchArea();
	IONPay.Utils.fnHideSearchOptionArea();
		
	}
	else{
		var $objFrmData = $("#frmSearch").serializeObject();
        
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/baseInfoMgmt/baseInfoMgmt/selectBaseInfoListExcel.do");
	}
}
function fnMerInfo(idCd , id){
	$("#ListSearch").hide();
	if(idCd=="2"){
		$("#midInfo").show(200);
   		$("#gidInfo").hide();
   		$("#vidInfo").hide();
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["MER_ID"]    = id;
		arrParameter["MER_VAL"]  = idCd;
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectBaseInfoRet";
	}else if(idCd=="3"){
		$("#midInfo").hide();
   		$("#gidInfo").show(200);
   		$("#vidInfo").hide();
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["MER_ID"]    = id;
		arrParameter["MER_VAL"]  = idCd;
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectGidInfoRet";
	}else if(idCd=="4"){
		$("#midInfo").hide();
   		$("#gidInfo").hide();
   		$("#vidInfo").show(200);
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["MER_ID"]    = id;
		arrParameter["MER_VAL"]  = idCd;
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectVidInfoRet";
	}
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
</script>
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
                    <h3><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0047" /></span></h3>
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
                            		<input type="hidden" name="empNo" value="<%= CommonUtils.getSessionInfo(session, "USR_ID")%>>">
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
                            			<div class = "col-md-2">
	                                        <label class="form-label"><spring:message code="IMS_TV_TH_0051" /></label> 
                            				<select id = "MER_SEARCH" name = "MER_SEARCH" class = "select2 form-control">
                            				</select>
                            			</div>
	                                    <div class="col-md-2">
	                                        <div class="input-with-icon  right">
	                                       		<label class="form-label">&nbsp;</label>
	                                            <input type="text" id="MER_SEARCH_TEXT" name="MER_SEARCH_TEXT" class="form-control" >
	                                        </div>
	                                    </div>                
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code="IMS_BIM_MM_0006" /></label> 
	                                        <select id="MER_TYPE" name="MER_TYPE" class="select2 form-control">
	                                        </select>
	                                    </div>                                      
	                                    <div class="col-md-4">
                                        </div>    
                            		</div>
                            		<div class = "row" style = "padding:0 0 15px 0;">
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code="IMS_BIM_MM_0147" /></label> 
	                                        <select id="COMPANY_TYPE" name="COMPANY_TYPE" class="select2 form-control">
	                                        </select>
	                                    </div>    
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code="IMS_BIM_MM_0148" /></label> 
	                                        <select id="OM_PAY_SETTLE" name="OM_PAY_SETTLE" class="select2 form-control">
	                                        </select>
	                                    </div>                                
	                                    <div class="col-md-4">
                                        </div>    
                            		</div>
                            		<div class = "row" style = "padding:0 0 15px 0;">
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code="IMS_BIM_MM_0149" /></label> 
	                                        <select id="SHOP_TYPE" name="SHOP_TYPE" class="select2 form-control">
	                                        </select>
	                                    </div>    
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code="IMS_BIM_MM_0080" /></label> 
	                                        <select id="USE_STATUS" name="USE_STATUS" class="select2 form-control">
	                                        </select>
	                                    </div>                                
	                                    <div class="col-md-4">
                                        </div>    
                            		</div>
	                                <div id="div_area_card">                               
		                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
			                                <div class="col-md-3">
								                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
								                   <input id="CHK_REGIST_DATE" type="checkbox" checked="checked">
								                   <label for="CHK_REGIST_DATE"><spring:message code="IMS_BIM_MM_0100"/></label>
								               	</div>
			                                    <div class="input-append success date col-md-10 col-lg-10 no-padding">
			                                        <input type="text" id="txtFromDate" name="frDt" class="form-control">
			                                        <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
			                                    </div>	                                    
			                                </div>
			                                <div class="col-md-3">
			                                   <label class="form-label" style="padding-top:10px; padding-bottom:0;">&nbsp;</label>
			                                   <div class="input-append success date col-md-10 col-lg-10 no-padding">
			                                       <input type="text" id="txtToDate" name="toDt" class="form-control">
			                                       <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
			                                   </div>
			                                </div>
			                                <div id="divSearchDateType1" class="col-md-6">
			                                    <label class="form-label" style="padding-top:10px; padding-bottom:0;">&nbsp;</label>                                        
			                                    <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0054" /></button>                                       
			                                    <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0055" /></button>       
			                                </div>
		                                </div>
		                                <div class="row" style="padding:0px 0 10px 0;">
	                                        <div class="col-md-3">
	                                            <div class="input-group transparent clockpicker col-md-11">
	                                                <input class="form-control" id="TRANS_FROM_TM" name="TRANS_FROM_TM" type="text" value="00:00">
	                                                <span class="input-group-addon">
	                                                <i class="fa fa-clock-o"></i>
	                                                </span>
	                                            </div>                                          
	                                         </div>
	                                         <div class="col-md-3">
	                                            <div class="input-group transparent clockpicker col-md-11">
	                                                <input class="form-control" id="TRANS_TO_TM" name="TRANS_TO_TM" type="text" value="24:00">
	                                                <span class="input-group-addon">
	                                                <i class="fa fa-clock-o"></i>
	                                                </span>
	                                            </div>                                          
	                                         </div>
			                                <div id="divSearchDateType3" class="col-md-6">                                                          
			                                    <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0056" /></button>                        
			                                    <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code="IMS_BIM_BM_0011" /></button>                                      
			                                    <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code="IMS_BIM_BM_0012" /></button>
			                                </div>
                                   	 	</div>
		                            </div>               
	                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                
	                                    <div class="col-md-6">
							                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
							                   <input id="CHK_PAY_TYPE" name="CHK_PAY_TYPE" type="checkbox"  >
							                   <label for="CHK_PAY_TYPE"><spring:message code="IMS_DM_DM_0003"/></label>
							               	</div>
							                <div class="grid-body no-border" style="padding-bottom:0;">
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_CARD"  name="svcList" type="checkbox" value="01">
									                   <label for="CHK_CARD"><spring:message code="IMS_BIM_MM_0009"/></label>
									               	</div>
								               	</div>
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_ACCT" name="svcList" type="checkbox" value="02">
									                   <label for="CHK_ACCT"><spring:message code="IMS_BIM_MM_0150"/></label>
									               	</div>
								               	</div>
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_VACCT" name="svcList" type="checkbox"  value="03">
									                   <label for="CHK_VACCT"><spring:message code="IMS_BIM_MM_0010"/></label>
									               	</div>
								               	</div>
							                	<div class="col-md-3">
									                <div class="checkbox check-success" style="padding-top:10px; padding-bottom:0;">
									                   <input id="CHK_PHONE" name="svcList" type="checkbox" value="05">
									                   <label for="CHK_PHONE"><spring:message code="IMS_BIM_MM_0151"/></label>
									               	</div>
								               	</div>
							                </div>
	                                    </div>
	                                    <div class="col-md-6">
                                            <label class="form-label" style="padding-top:10px; padding-bottom:0;">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_TV_TH_0053" /></button>
                                                <button type="button" id="btnExcel" class="btn btn-primary btn-cons">Excel</button>                                            
                                                <button type="button" id="btnListSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_BIM_MM_0152"/></button>                                            
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
	                <div class = "row" id = "ListSearch" style="display: none;">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0152" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="listSearchCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbListSearch" width="100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_DASHBOARD_0029" /></th>
	                                     <th><spring:message code="IMS_BIM_MM_0006" /></th>
	                                     <th><spring:message code="IMS_BIM_MM_0054"/></th>
	                                     <th><spring:message code="IMS_BIM_MM_0051" /></th>
	                                     <th><spring:message code="DDLB_0137" /></th>
	                                     <th><spring:message code="DDLB_0138" /></th>
	                                     <th><spring:message code="DDLB_0139" /></th>
	                                     <th><spring:message code="IMS_BIM_MM_0008" /></th>
	                                     <th><spring:message code="IMS_BIM_MM_0155" /></th>
	                                     <th><spring:message code="IMS_BIM_MM_0156" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END LIST Search VIEW AREA -->  
                <!-- BEGIN Information VIEW AREA -->
                <div id="midInfo">
	                <div class = "row" id = "Information">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_BM_0047" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="informationCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbInformation" width="100%">
	                                <tbody>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0054" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CO_NO" name="CO_NO"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0057"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="RepersentativeName" name="RepersentativeName"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0061" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="RepersentativeTel" name="RepersentativeTel"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0051" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="MerchantName" name="MerchantName"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0161"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="SignName" name="SignName"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0162" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="RepersentativeCP" name="RepersentativeCP"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0137" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="MID" name="MID"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0163"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="URL" name="URL"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0164" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="RepersentativeFAX" name="RepersentativeFAX"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0138" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="GID" name="GID"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0165"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ClassificationBusiness" name="ClassificationBusiness"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0166" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="E-MAIL" name="E-MAIL"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="DDLB_0139" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="VID" name="VID"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0167"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="BusinessStatus" name="BusinessStatus"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="UseStatus" name="UseStatus"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_MM_0081" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="FranchiseType" name="FranchiseType"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0148"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="OMPaySettle" name="OMPaySettle"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0070" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ContractStaff" name="ContractStaff"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0147" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CompanyType" name="CompanyType"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0168"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="AcctRiskLvl" name="AcctRiskLvl"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0049" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="SalesStaff" name="SalesStaff"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0149" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ShopType" name="ShopType"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0050"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ContractDate" name="ContractDate"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0015" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="AcceptRoute" name="AcceptRoute"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0169" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="BigCategory" name="BigCategory"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0170"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="SmallCategory" name="SmallCategory"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0171" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="NHCategory" name="NHCategory"></td>
	                                	</tr>
	                                	<%-- <tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0172" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="SuretyInsurance" name="SuretyInsurance"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0173"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="StockCheck" name="StockCheck"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0174" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="InsurancePolicyTerm" name="InsurancePolicyTerm"></td>
	                                	</tr> --%>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_BIM_0028" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="5" id="Address" name="Address"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_BIM_0029" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="5" id="BusinessAddr" name="BusinessAddr"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="2" rowspan="2"><spring:message code="IMS_BIM_MM_0175" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ContractStaffName" name="ContractStaffName"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ContractStaffTel" name="ContractStaffTel"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0180"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ContractStaffCP" name="ContractStaffCP"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="ContractStaffEmail" name="ContractStaffEmail"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="2" rowspan="2"><spring:message code="IMS_BIM_MM_0176" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CalculateStaffName" name="CalculateStaffName"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CalculateStaffTel" name="CalculateStaffTel"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0180"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CalculateStaffCP" name="CalculateStaffCP"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CalculateStaffEmail" name="CalculateStaffEmail"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="2" rowspan="2"><span><spring:message code="IMS_BIM_MM_0177" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="TechnologyStaffName" name="TechnologyStaffName"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="TechnologyStaffTel" name="TechnologyStaffTel"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><span><spring:message code="IMS_BIM_MM_0180" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="TechnologyStaffCP" name="TechnologyStaffCP"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="TechnologyStaffEmail" name="TechnologyStaffEmail"></td>
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
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CashReceipt" name="CashReceipt"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0002"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PaymentNotice" name="PaymentNotice"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0003" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CardSalesStatement" name="CardSalesStatement"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0004"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="VAT" name="VAT"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0005" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="VACCTDepositLimit" name="VACCTDepositLimit"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0006"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="VACCTNumberForm" name="VACCTNumberForm"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0007" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="UnsentAutoCancle" name="UnsentAutoCancle"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0008"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PhoneAuthenticationYN" name="PhoneAuthenticationYN"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0009" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="UseEscrowYN" name="UseEscrowYN"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0010"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="AuthorizationVAN" name="AuthorizationVAN"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0011" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PurchaseVAN" name="PurchaseVAN"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0012"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="QuickAuthenticationYN" name="QuickAuthenticationYN"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0013" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="UsePushPayYN" name="UsePushPayYN"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0014"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PhoneFeeSection" name="PhoneFeeSection"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0015" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PushFailedSMS" name="PushFailedSMS"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0016"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="MerchantKeyModify" name="MerchantKeyModify"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_BIM_0017" /></span></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="UseVACCTIssueMenuYN" name="UseVACCTIssueMenuYN"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0018"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="UseTPayMobileUnauthorizedYN" name="UseTPayMobileUnauthorizedYN"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0019" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="MmsPaymentAuthority" name="MmsPaymentAuthority"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0020"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="OverlapOrderCheck" name="OverlapOrderCheck"></td>
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
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PurchaseWay" name="PurchaseWay"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_PM_PV_0015"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="3" id="PurchaseDate" name="PurchaseDate"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0022" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PayMethod" name="PayMethod"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0023"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="3" id="FeePayMethod" name="FeePayMethod"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0095" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="CancelFunction" name="CancelFunction"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0096"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="PartialCancelFunction" name="PartialCancelFunction"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0024" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="LCPB" name="LCPB"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><spring:message code="IMS_BIM_BIM_0025" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " rowspan="2" id="AutoSetoff" name="AutoSetoff"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0026"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="AcctInfo1" name="AcctInfo1"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="AcctHolder1" name="AcctHolder1"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0026"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="AcctInfo2" name="AcctInfo2"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="AcctHolder2" name="AcctHolder2"></td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
                            </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END Calculation Information VIEW AREA -->  
                <!-- BEGIN IPG VIEW AREA -->
	                <div class = "row" id = "IPG">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal green">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0158" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="iPGCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbIPG1" width="100%">
	                                <thead>
	                                 <tr>
	                                     <th colspan="15" ><spring:message code="IMS_BIM_BIM_0030" />(<span id="authFlg"></span>)</th>
	                                 </tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2" id="stmtCyc"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="2"><spring:message code="IMS_BIM_MM_0080"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="cardUsFlg"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="2"><spring:message code="IMS_BIM_BIM_0031"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="7" id="useCard"></td>
	                                	</tr>
	                                </thead>
	                                <tbody id="tb_card" style='text-align: center; '>
	                                </tbody>
	                            </table>
	                          </div>
	                          <%-- <div class="row">
	                            <table class="table" id="tbIPG2" width="100%">
	                                <thead>
	                                 <tr>
	                                     <th colspan="3"><spring:message code="IMS_BIM_BIM_0050" /></th>
	                                     <th colspan="2"><spring:message code="IMS_BIM_BIM_0051" /></th>
	                                     <th colspan="2"><spring:message code="IMS_BIM_BIM_0052" /></th>
	                                     <th colspan="2"><spring:message code="IMS_BIM_BIM_0053" /></th>
	                                 </tr>
	                                </thead>
	                                <tbody>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2" id="td_acctStmtCycle"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_vacctStmtCycle"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0048"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phStmtCri"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0048"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phBillStmtCri"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2"  id="td_acctUseChk"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_vacctUseChk"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phStmtCycle"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phStmtCycle"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0090"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_vacctType"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phUseChk"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phBillUseChk"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0054" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " > 1원~11,600원</td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; ">11,601원~</td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " ></td> <!-- id="td_vacctFee" -->
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_acctFee"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_acctFee2"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0055"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0056"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0057" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2" id="td_acctAllPart"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0056"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phBillFee"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0057" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2" id="td_acctAllPart"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="2"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_phFee"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
	                          <div class="row">
	                            <table class="table" id="tbIPG3" width="100%">
	                                <tbody>
	                                	<tr>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" ><spring:message code="IMS_BIM_BIM_0058" /></th>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="td_smsFee"></td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div> --%>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END IPG VIEW AREA -->  
                <!-- BEGIN Foreign Payment VIEW AREA -->
	                <%-- <div class = "row" id = "ForeignPayment">
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
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="4"><spring:message code="IMS_BIM_BIM_0059" /></th>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="4"><spring:message code="IMS_BIM_BIM_0060" /></th>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0061"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0061"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0062" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0063"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0062"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0063"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="3"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="3"></td>
	                                	</tr>
	                                	<tr>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" colspan="4"><spring:message code="IMS_BIM_BIM_0064" /></th>
	                                     <th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; " colspan="4"></th>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0049" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0061"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="4"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0063" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="3"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="4"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0087" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0088"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="4"></td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="3"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " colspan="4"></td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div>  --%>
               <!-- END Foreign Payment VIEW AREA -->  
                <!-- BEGIN Registration Information VIEW AREA -->
	                <div class = "row" id = "RegistrationInformation">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal grey">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0160" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="registrationInformationCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbRegistrationInformation1" width="100%">
	                                <tbody>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0065" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="regWorker"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0066"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="regDt"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0067"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; "id="updWorker"></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0068"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; " id="updDt"></td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
	                          <div class="row">
	                            <table class="table" id="tbRegistrationInformation2" width="100%">
	                                <tbody>
	                                	<tr>
	                                    	<th style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0070" /></th>
	                                	</tr>
	                                	<tr>
	                                    	<td style="text-align:center; border:1px solid #c2c2c2; "></td>
	                                	</tr>
	                                </tbody>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
           </div>
        <!-- END Registration Information VIEW AREA -->
        <!-- START GID VIEW AREA -->
               <div id="gidInfo">
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
		                         		<table class="table" id="gidInfo" style="width:100%; border:1px solid #ddd;">
                                <thead >
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
                                  </tr>
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0417'/></th>
                                      <td id="vaNo" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                      <th><spring:message code='IMS_BIM_BIM_0027'/></th>
                                      <td id="vaNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                              		 <th rowspan="2"><spring:message code='IMS_BIM_BM_0461'/></th>
                                     <td  colspan="3"  id="manager" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr>
                               		<td  colspan="3"  id="manager2" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                  <tr id="trBottomGidInfo">
                                  </tr>
                                  <tr style="text-align: center;">
                                     <td id="coNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                     <td id="coNo1" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                     <td id="mid" style="border:1px solid #c2c2c2; background-color:white;"></td>
                                  </tr>
                                 </thead>
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
               <div id="vidInfo">
               		<form id="frmVidInfo" name="frmVidInfo">
               			<input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
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
		                                <thead>
		                                  <tr>
		                                      <th><spring:message code='DDLB_0139'/></th>
		                                      <td colspan="5" id="vId" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_BM_0418'/></th>
		                                      <td colspan="5" id="vNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_BM_0083'/></th>
		                                      <td colspan="5" id="coNo" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_BM_0143'/></th>
		                                      <td colspan="5" id="repNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_MM_0167'/></th>
		                                      <td colspan="2" id="bsKind" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                      <th><spring:message code='IMS_BIM_MM_0165'/></th>
		                                      <td colspan="2" id="gdKind" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_MM_0166'/></th>
		                                      <td colspan="5" id="email" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_MM_0175'/></th>
		                                      <td colspan="5" id="contCharge" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_MM_0176'/></th>
		                                      <td colspan="5" id="settleCharge" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_MM_0177'/></th>
		                                      <td colspan="5" id="techCharge" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_BM_0416'/></th>
		                                      <td colspan="5" id="bankCd" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_BM_0417'/></th>
		                                      <td colspan="2" id="vaNo" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                      <th><spring:message code='IMS_BIM_BIM_0027'/></th>
		                                      <td colspan="2" id="vaNm" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_MM_0087'/></th>
		                                      <td colspan="5" id="stmtCycle" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  <tr>
		                                      <th><spring:message code='IMS_BIM_BM_0419'/></th>
		                                      <td colspan="5" id="rsRate" style="border:1px solid #c2c2c2; background-color:white;"></td>
		                                  </tr>
		                                  
		                                  <tr>
		                                  <%--  <th rowspan="8" class="th_verticleLine"><spring:message code='IMS_BIM_MM_0045'/></th>
		                                      <th><spring:message code='IMS_BIM_BM_0420'/></th>
		                                      <th><spring:message code='IMS_BIM_BM_0421'/></th>
		                                      <th><spring:message code='IMS_BIM_BM_0422'/></th>
		                                      <th><spring:message code='IMS_BIM_BM_0423'/></th>
		                                  </tr> --%>
		                                  <!-- <tr id="trFeeInfo"></tr> -->
		                                   <%-- <tr>
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
		                                  </tr> --%>
		                                 </thead>
		                                 <tbody id="trFeeInfo">
		                                 	
		                                 </tbody>
		                                 <tfoot>
			                                  <tr id="trBottomInfo" >	
			                                  </tr>
			                                  <tr style="text-align: center;">
			                                      <td id="botCoNm"  colspan="2" style="border:1px solid #c2c2c2; " ></td>
			                                      <td  id="botCoNo"  style="border:1px solid #c2c2c2; "></td>
			                                      <td id="botMid" style="border:1px solid #c2c2c2; " ></td>
			                                      <td style="border:1px solid #c2c2c2; " ></td>		
			                                  </tr>
		                                 </tfoot>
		                            </table>
		                            
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
    <!-- END PAGE --> 
 </div>
 <!-- END CONTAINER -->
    <!-- Modal Menu Insert Area -->
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