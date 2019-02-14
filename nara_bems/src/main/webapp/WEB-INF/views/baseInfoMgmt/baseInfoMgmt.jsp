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
	
	$("#MER_TYPE").html("<c:out value='${MER_TYPE}' escapeXml='false' />");	
	
	$("#NHCategory").html("<c:out value='${NH_CATEGORY_LIST}' escapeXml='false' />");
	$("#VACCT_LMT_DAY").html("<c:out value='${DEPOSIT_LIMIT}' escapeXml='false' />");	
	
	$("#SmallCategory").html("<c:out value='${SMALL_CATEGORY_LIST}' escapeXml='false' />");
	$("#BS_KIND_CD").html("<c:out value='${BIG_CATEGORY_LIST}' escapeXml='false' />");
	$("#MBS_TYPE_CD").html("<c:out value='${MBS_CD_LIST}' escapeXml='false' />");
	$("#MALL_TYPE_CD").html("<c:out value='${MALL_CD_LIST}' escapeXml='false' />");
	$("#RECV_CH_CD").html("<c:out value='${RECV_CH}' escapeXml='false' />");
	//$("#ACQ_CL_CD").html("<c:out value='${ACQ_CD}' escapeXml='false' />"); //CODE =0013  매입방법
	$("#APP_VAN1_CD").html("<c:out value='${VAN_CD}' escapeXml='false' />");
	$("#ACQ_VAN_CD").html("<c:out value='${VAN_CD}' escapeXml='false' />");
	$("#ACQ_DAY").html("<c:out value='${ACQ_DAY}' escapeXml='false' />");
	$("#CC_CL_CD").html("<c:out value='${CC_CL_CD}' escapeXml='false' />");
	
	$("#mBankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
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
	
	$("#tbCalculationInformation #autoCancel").select2("val", "0");
	$("#vidRegInfo #settleCycle").select2("val", "0");
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
        		$("#MER_SEARCH").select2("val", "1");
        		
        		// 조회시 비활성화
        		$("#btnDupMidChk").prop("disabled", true);
        		$("#CO_NO").attr("readonly",true);
        		$("#MID").attr("readonly", true);
        		
       		}else if($("#MER_SEARCH option:selected").text() == 'GID' ){
       			//gid
       			$("#midRegInfo").hide();
    			$("#gidRegInfo").show(200);
    			$("#vidRegInfo").hide();
    			$("#MER_SEARCH").select2("val", "2");
    			
    			// 조회시 비활성화
    			$("#btnDupGid").prop("disabled", true);
    			$("#frmGidInfo #GID").attr("readonly", true);
    			
       		}else if($("#MER_SEARCH option:selected").text() == 'VID'){
       			//aid
       			$("#midRegInfo").hide();
    			$("#gidRegInfo").hide();
    			$("#vidRegInfo").show(200);
    			$("#MER_SEARCH").select2("val", "3");
    			
    			// 조회시 비활성화
    			$("#btnDupVid").prop("disabled", true);
    			$("#frmVidInfo #VID").attr("readonly", true);
    			
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
    		$("#MER_SEARCH").select2("val", "1");
    		
    		//등록시 활성화
			$("#btnDupMidChk").prop("disabled", false);
			$("#CO_NO").attr("readonly", false);
			$("#MID").attr("readonly", false);
    		
    		fnCardList();
   		}else if($("#MER_SEARCH option:selected").text() == 'GID' ){
   			//gid
   			$("#midRegInfo").hide();
			$("#gidRegInfo").show(200);
			$("#vidRegInfo").hide();
			$("#MER_SEARCH").select2("val", "2");
			
			//등록시 활성화
			$("#btnDupGid").prop("disabled", false);
			$("#frmGidInfo #GID").attr("readonly", false);
			
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
			$("#MER_SEARCH").select2("val", "3");
			
			//등록시 활성화
			$("#btnDupVid").prop("disabled", false);
			$("#frmVidInfo #VID").attr("readonly", false);
			
   		}
    	if($("#listSearchCollapse").hasClass("collapse") === true)
 	    	$("#listSearchCollapse").click(); 
    		$("#ListSearch").hide();
    	
    	$("form").each(function() {  
            this.reset();  
         });  
    	
		//IONPay.Utils.fnHideSearchOptionArea();
    });
    
    $("#btnListSearch").on("click", function(){		
   		var merId = $("#MER_SEARCH option:selected").text();
   		console.log(merId + "0");
   		if(merId=="MID"){
   			$("#MER_SEARCH").select2("val", "1");
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
            	//IONPay.Utils.fnHideSearchOptionArea();
   		}else {
   			alert("MID만 조회 가능합니다.");
   			return;
   		}
    	
    });
    
    
    $("#btnInqGid").on("click", function(){//alert($("#insertInfo #GID").val() + "g" + " : " + typeChk);
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
            url: "/baseInfoMgmt/baseInfoMgmt/selectApproList.do",
            data: function() {	
                return $("#frmSearch").serializeObject();
            },
            columns: [
                { "class" : "columnc all",         "data" : null, "render": function(data){return data.RNUM} },
                { "class" : "columnc all",         "data" : null, "render": function(data){
                	var mbsTypeCd = "";
                	if(data.MBS_TYPE_CD=="0") {
                		mbsTypeCd = $("#directMerchant").val();
                	}else if(data.MBS_TYPE_CD=="1") {
                		mbsTypeCd = $("#notDirectMerchant").val();
                	}
                	
                	return mbsTypeCd
                	} 
                },
                { "class" : "columnc all",         "data" : null, "render": function(data){return data.CO_NO} },
                { "class" : "columnc all",         "data" : null, "render": function(data){return data.CO_NM} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MID}},
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.GID} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VID} },

                { "class" : "columnc all", 			"data" : null, "render":function(data){
                	var str = "";
                		
                	str = '<input type="button" id="btnMidDetail" value="상세보기" class="btn btn-info btn-sm btn-cons"  onClick="fnMidInfoDetail(\'' + data.MID + '\')" />';
                	
                	return str;
                	} 
                },
                { "class" : "columnc all", 			"data" : null, "render":function(data){
                	var str = "";
                		
                	str = '<input type="button" id="btnSendMail" value="메일발송" class="btn btn-info btn-sm btn-cons"  onClick="fnSendMail(\'' + data.MID + '\' '
        				+ ' , \'' + data.MBS_TYPE_CD + '\')" />';
                	
                	return str;
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
    //IONPay.Utils.fnHideSearchOptionArea();
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

function fnChgStatus(value, merId, id, frDt, pmCd, spmCd, feeTypeCd, cpCd, frAmt, fee){
	//parameter 셋팅
	var mid = "";
	if(value==1){	//승인
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["merId"]    = merId;
		arrParameter["status"]    = "1";
		//arrParameter["index"]    = map.get("index");
		arrParameter["id"]    = id;
		arrParameter["frDt"]    = frDt;
		arrParameter["regFrDt"]    = frDt;
		arrParameter["pmCd"]    = pmCd;
		arrParameter["spmCd"]    = spmCd;
		arrParameter["feeTypeCd"]    = feeTypeCd;
		arrParameter["cpCd"]    = cpCd;
		arrParameter["frAmt"]    = frAmt;
		arrParameter["fee"]    = fee;
		
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/merchantReg.do";
		strCallBack  = "fnUpdateRet";
		
	}else if(value==2){	//반려
		arrParameter = $("#frmSearch").serializeObject();
		arrParameter["merId"]    = merId;
		arrParameter["status"]    = "2";
		//arrParameter["index"]    = map.get("index");
		arrParameter["id"]    = id;
		arrParameter["frDt"]    = frDt;
		arrParameter["pmCd"]    = pmCd;
		arrParameter["spmCd"]    = spmCd;
		arrParameter["feeTypeCd"]    = feeTypeCd;
		arrParameter["cpCd"]    = cpCd;
		arrParameter["frAmt"]    = frAmt;
		
		strCallUrl   = "/baseInfoMgmt/baseInfoRegistration/merchantReg.do";
		strCallBack  = "fnUpdateRet";
	}
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
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
	    //IONPay.Utils.fnHideSearchOptionArea();
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
		
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectBaseInfoRet";
	}else if($("#MER_SEARCH option:selected").text() == "GID"){
		arrParameter["MER_VAL"]    = '3';
		arrParameter["MER_ID"]    = $("#MER_SEARCH_TEXT").val();
		strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
		strCallBack  = "fnSelectGidInfoRet";
	}else if($("#MER_SEARCH option:selected").text() == "VID"){
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
		
	  	var pmCd = ["01", "02", "03", "05", "06", "07", "10", "11", "12", "13"];
	  	var spmCd = ["01", "03", "04", "05"]; 
		if(objJson.midInfo != null){
			var mid = objJson.midInfo[0].MID.substr(0,9);
			var gid = objJson.midInfo[0].GID.substr(0,9);
			var vid = objJson.midInfo[0].VID.substr(0,9);
			if(objJson.midInfo.length > 0 ){
				$("#insertInfo #midCoNo").text(objJson.midInfo[0].CO_NO);
				$("#insertInfo #RepersentativeName").text(objJson.midInfo[0].REP_NM);
				$("#insertInfo #TEL_NO").text(objJson.midInfo[0].TEL_NO);
				
				$("#insertInfo #MerchantName").text(objJson.midInfo[0].CO_NM);
				$("#insertInfo #SIGN_NM").text(objJson.midInfo[0].SIGN_NM);
				
				$("#insertInfo #midMid").text(mid + "m");
				$("#insertInfo #midUrl").text(objJson.midInfo[0].MID_URL);
				$("#insertInfo #FAX_NO").text(objJson.midInfo[0].FAX_NO);
				
				$("#insertInfo #midGid").text(gid + "g");
				$("#insertInfo #ClassificationBusiness").text(objJson.midInfo[0].BS_KIND);
				$("#insertInfo #midMail").text(objJson.midInfo[0].EMAIL);
				
				$("#insertInfo #midVid").text(vid + "v");
				$("#insertInfo #BusinessStatus").text(objJson.midInfo[0].GD_KIND);
				//midUseStatus
				$("#insertInfo #UseStatus").select2("val", objJson.midInfo[0].USE_CL);
				$("#insertInfo #midUseStatus").text($("#insertInfo #UseStatus option:selected").text());
				
				//ContractStaff
				$("#insertInfo #ContractStaff").select2("val", objJson.midInfo[0].CONT_EMP_NO);
				
				$("#insertInfo #midContractStaff").text($("#insertInfo #ContractStaff option:selected").text());
				//SalesStaff
				$("#insertInfo #SalesStaff").select2("val", objJson.midInfo[0].MGR1_EMP_NO);
				$("#insertInfo #midSalesStaff").text($("#insertInfo #SalesStaff option:selected").text());
				
				//MALL_TYPE_CD
				$("#insertInfo #MALL_TYPE_CD").select2("val", objJson.midInfo[0].MALL_TYPE_CD);
				$("#insertInfo #midMallTypeCd").text($("#insertInfo #MALL_TYPE_CD option:selected").text());
				//ContractDate
				//$("#insertInfo #ContractDate").val(IONPay.Utils.fnStringToDatePickerFormat(objJson.midInfo[0].CONT_DT));
				$("#insertInfo #midContractDate").text(IONPay.Utils.fnStringToDatePickerFormat(objJson.midInfo[0].CONT_DT));
				$("#insertInfo #RECV_CH_CD").select2("val", objJson.midInfo[0].RECV_CH_CD);
				$("#insertInfo #midRecvChCd").text($("#insertInfo #RECV_CH_CD option:selected").text());
				
				
				$("#insertInfo #midAddress1").text("(" + objJson.midInfo[0].POST_NO + ")");
				$("#insertInfo #midAddress2").text(objJson.midInfo[0].ADDR_NO1);
				$("#insertInfo #midAddress3").text(objJson.midInfo[0].ADDR_NO2);
				$("#insertInfo #midBusinessAddr1").text("(" + objJson.midInfo[0].RPOST_NO + ")");
				$("#insertInfo #midBusinessAddr2").text(objJson.midInfo[0].RADDR_NO1);
				$("#insertInfo #midBusinessAddr3").text(objJson.midInfo[0].RADDR_NO2);
				
				$("#insertInfo #CONT_EMP_NM").text(objJson.midInfo[0].CONT_EMP_NM);
				$("#insertInfo #CONT_EMP_TEL").text(objJson.midInfo[0].CONT_EMP_TEL);
				$("#insertInfo #CONT_EMP_HP").text(objJson.midInfo[0].CONT_EMP_HP);
				$("#insertInfo #CONT_EMP_EMAIL").text(objJson.midInfo[0].CONT_EMP_EMAIL);
				$("#insertInfo #STMT_EMP_NM").text(objJson.midInfo[0].STMT_EMP_NM);
				$("#insertInfo #STMT_EMP_TEL").text(objJson.midInfo[0].STMT_EMP_TEL);
				$("#insertInfo #STMT_EMP_CP").text(objJson.midInfo[0].STMT_EMP_CP);
				$("#insertInfo #STMT_EMP_EMAIL").text(objJson.midInfo[0].STMT_EMP_EMAIL);
				$("#insertInfo #TECH_EMP_NM").text(objJson.midInfo[0].TECH_EMP_NM);
				$("#insertInfo #TECH_EMP_TEL").text(objJson.midInfo[0].TECH_EMP_TEL);
				$("#insertInfo #TECH_EMP_CP").text(objJson.midInfo[0].TECH_EMP_CP);
				$("#insertInfo #TECH_EMP_EMAIL").text(objJson.midInfo[0].TECH_EMP_EMAIL);
				
				//hardcoding 
				$("#insertInfo #UseTPayMobileUnauthorizedYN").select2("val", "0");
				
				
				
				
				$("#insertInfo #MBS_TYPE_CD").select2("val", objJson.midInfo[0].MBS_TYPE_CD);
				$("#insertInfo #CompanyType").select2("val", objJson.midInfo[0].CO_CL_CD);
				
				
				
				var bsKindCd = objJson.midInfo[0].BS_KIND_CD;
				var kindCd = "";
				if(bsKindCd == null){
					
				}else{
					kindCd = bsKindCd.split(":")
					$("#insertInfo #BS_KIND_CD").select2("val", kindCd[0]);
					$("#insertInfo #midBsKindCd").text($("#insertInfo #BS_KIND_CD option:selected").text());
				}
				
				if(objJson.cateList != null ){
					for(var i=0; i<objJson.cateList.length; i++){
						if(objJson.cateList[i].CODE2 == kindCd[1]){
							$("#insertInfo #SmallCategory").select2("val", kindCd[1]);
							$("#insertInfo #midSmallCategory").text($("#insertInfo #SmallCategory option:selected").text());
						}
					}
				}
				
				//기타 정보
				//$("#tbOtherInformation #UnsentAutoCancle").select2("val", objJson.midInfo[0].AUTO_CANCEL_FLG);
				var unsentAutoCancleVal = '';
				if(objJson.midInfo[0].AUTO_CANCEL_FLG == '0') {
					unsentAutoCancleVal = $("#UnsentAutoCancle00").val();
				}else if(objJson.midInfo[0].AUTO_CANCEL_FLG == '1') {
					unsentAutoCancleVal = $("#UnsentAutoCancle01").val();
				}
				$("#tbOtherInformation #midUnsentAutoCancle").text(unsentAutoCancleVal);
				
				//$("#tbOtherInformation #PAY_NOTI_CD").select2("val", objJson.midInfo[0].PAY_NOTI_CD);
				var payNotiCdVal = '';
				if(objJson.midInfo[0].PAY_NOTI_CD == '00') {
					payNotiCdVal = $("#PAY_NOTI_CD00").val();
				}else if(objJson.midInfo[0].PAY_NOTI_CD == '01') {
					payNotiCdVal = $("#PAY_NOTI_CD01").val();
				}else if(objJson.midInfo[0].PAY_NOTI_CD == '02') {
					payNotiCdVal = $("#PAY_NOTI_CD02").val();
				}else if(objJson.midInfo[0].PAY_NOTI_CD == '03') {
					payNotiCdVal = $("#PAY_NOTI_CD03").val();
				}
				$("#tbOtherInformation #midPayNotiCd").text(payNotiCdVal);
				
				//$("#tbOtherInformation #ORD_NO_DUP_FLG").select2("val", objJson.midInfo[0].ORD_NO_DUP_FLG);
				var ordNoDupFlgVal = '';
				if(objJson.midInfo[0].ORD_NO_DUP_FLG == '0') {
					ordNoDupFlgVal = $("#ORD_NO_DUP_FLG00").val();
				}else if(objJson.midInfo[0].ORD_NO_DUP_FLG == '1') {
					ordNoDupFlgVal = $("#ORD_NO_DUP_FLG01").val();
				}
				$("#tbOtherInformation #midOrdNoDupFlg").text(ordNoDupFlgVal);
				
				//$("#VAT").select2("val", objJson.midInfo[0].VAT_MARK_FLG);
				var vatVal = '';
				if(objJson.midInfo[0].VAT_MARK_FLG == '0') {
					vatVal = $("#VAT00").val();
				}else if(objJson.midInfo[0].VAT_MARK_FLG == '1') {
					vatVal = $("#VAT01").val();
				}
				$("#tbOtherInformation #midVat").text(vatVal);
				
				$("#tbOtherInformation #ONCE_AMT_MAX").text(objJson.midInfo[0].PAY_MAX);
				$("#tbOtherInformation #ONCE_AMT_MIN").text(objJson.midInfo[0].PAY_MIN);
				$("#tbOtherInformation #MEM_AMT_ONE_DAY").text(objJson.midInfo[0].PAY_ACCU_ONE);
				$("#tbOtherInformation #MEM_AMT_THREE_DAY").text(objJson.midInfo[0].PAY_ACCU_THREE);
				
				//정산 정보
				$("#tbCalculationInformation #EROM_FEE").text(objJson.midInfo[0].EROM_FEE + "%");
				$("#tbCalculationInformation #APPLY_START_DATE").text(IONPay.Utils.fnStringToDatePickerFormat(objJson.midInfo[0].APPLY_START_DATE));
				
				//$("#tbCalculationInformation #AUTO_CAL_TERM").select2("val", objJson.midInfo[0].AUTO_CAL_TERM);
				var autoCalTermVal = '';
				if(objJson.midInfo[0].AUTO_CAL_TERM == '1') {
					autoCalTermVal = $("#AUTO_CAL_TERM01").val();
				}else if(objJson.midInfo[0].AUTO_CAL_TERM == '2') {
					autoCalTermVal = $("#AUTO_CAL_TERM02").val();
				}else if(objJson.midInfo[0].AUTO_CAL_TERM == '3') {
					autoCalTermVal = $("#AUTO_CAL_TERM03").val();
				}else if(objJson.midInfo[0].AUTO_CAL_TERM == '4') {
					autoCalTermVal = $("#AUTO_CAL_TERM04").val();
				}
				$("#tbCalculationInformation #midAutoCalTerm").text(autoCalTermVal);
				
				//$("#tbCalculationInformation #PAY_ID_CD").select2("val", objJson.midInfo[0].PAY_ID_CD);
				var payIdCdVal = '';
				if(objJson.midInfo[0].PAY_ID_CD == '2') {
					payIdCdVal = $("#PAY_ID_CD02").val();
				}else if(objJson.midInfo[0].PAY_ID_CD == '3') {
					payIdCdVal = $("#PAY_ID_CD03").val();
				}
				$("#tbCalculationInformation #midPayIdCd").text(payIdCdVal);
				
				//$("#tbCalculationInformation #selSettlSvc0001").select2("val", objJson.midInfo[0].FEE_PAY_RULE);
				var selSettlSvcVal = '';
				if(objJson.midInfo[0].FEE_PAY_RULE == '00') {
					selSettlSvcVal = $("#selSettlSvc00").val();
				}else if(objJson.midInfo[0].FEE_PAY_RULE == '01') {
					selSettlSvcVal = $("#selSettlSvc01").val();
				}
				$("#tbCalculationInformation #midSelSettlSvc0001").text(selSettlSvcVal);
				
				$("#CC_CL_CD").select2("val", objJson.midInfo[0].CC_CL_CD);
				$("#tbCalculationInformation #midCcClCd").text($("#CC_CL_CD option:selected").text());
				
				//$("#tbCalculationInformation #CC_ChkFlg").select2("val", objJson.midInfo[0].CC_CHK_FLG);
				var ccChkFlgVal = '';
				if(objJson.midInfo[0].CC_CHK_FLG == '0') {
					ccChkFlgVal = $("#CC_ChkFlg00").val();
				}else if(objJson.midInfo[0].CC_CHK_FLG == '1') {
					ccChkFlgVal = $("#CC_ChkFlg01").val();
				}
				$("#tbCalculationInformation #midCcChkFlg").text(ccChkFlgVal);
				
				//$("#tbCalculationInformation #autoCancel").select2("val", objJson.midInfo[0].AUTO_CAL_FLG);
				var autoCancelVal = '';
				if(objJson.midInfo[0].AUTO_CAL_FLG == '0') {
					autoCancelVal = $("#autoCancel00").val();
				}else if(objJson.midInfo[0].AUTO_CAL_FLG == '1') {
					autoCancelVal = $("#autoCancel01").val();
				}
				$("#tbCalculationInformation #midAutoCancel").text(autoCancelVal);
				
				$("#mBankCd").select2("val", objJson.midInfo[0].BANK_CD);
				$("#tbCalculationInformation #midBankCdAcctNo").text($("#mBankCd option:selected").text()
						+ " : " + objJson.midInfo[0].ACCNT_NO);
				
				$("#tbCalculationInformation #midAccntNm").text(objJson.midInfo[0].ACCNT_NM);
				
				//기타
				$("#tbOthers #Memo").text(objJson.midInfo[0].MEMO);
				
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
				
			
		}
		  	
		
		  
        IONPay.Utils.fnJumpToPageTop();

	}else{
    	$("#midRegInfo").hide();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}
function fnSelectGidInfoRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.gidInfo.length > 0 ){
			var gid = objJson.gidInfo[0].GID.substr(0,9);
			$("#gidRegInfo #GID").text(gid + "g");
			$("#gidRegInfo #issuDt").text(IONPay.Utils.fnStringToDatePickerFormat(objJson.gidInfo[0].REG_DT));
			$("#gidRegInfo #gidNm").text(objJson.gidInfo[0].G_NM);
			$("#gidRegInfo #gidCoNo").text(objJson.gidInfo[0].CO_NO);
			
			$("#gidRegInfo #bankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
			$("#gidRegInfo #bankCd").select2("val", objJson.gidInfo[0].BANK_CD);
			$("#gidRegInfo #gidBankCd").text($("#gidRegInfo #bankCd option:selected").text());
			
			$("#gidRegInfo #gidVaNo").text(objJson.gidInfo[0].VGRP_NO);
			$("#gidRegInfo #gidVaNm").text(objJson.gidInfo[0].VGRP_NM);
			
			$("#gidRegInfo #gidContNm1").text(objJson.gidInfo[0].EMP1_NM);
			$("#gidRegInfo #gidContTelCp1").text(objJson.gidInfo[0].EMP1_TEL + " / " + objJson.gidInfo[0].EMP1_CP);
			$("#gidRegInfo #gidContEmail1").text(objJson.gidInfo[0].EMP1_EMAIL);

			$("#gidRegInfo #gidContNm2").text(objJson.gidInfo[0].EMP2_NM);
			$("#gidRegInfo #gidContTelCp2").text(objJson.gidInfo[0].EMP2_TEL + " / " + objJson.gidInfo[0].EMP2_CP);
			$("#gidRegInfo #gidContEmail2").text(objJson.gidInfo[0].EMP2_EMAIL);
			
			
			$("#gidRegInfo #gidMinCashPer").text(objJson.gidInfo[0].MIN_CASH_PER);
			$("#gidRegInfo #gidSaveDt").text(IONPay.Utils.fnStringToDatePickerFormat(objJson.gidInfo[0].SAVE_DT));
			
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
				$("#vidRegInfo #vidVid").text(vid + "v");
				$("#vidRegInfo #vidNm").text(objJson.vidInfo[0].VGRP_NM);
				$("#vidRegInfo #vidCoNo").text(objJson.vidInfo[0].CO_NO);
				$("#vidRegInfo #vidRepNm").text(objJson.vidInfo[0].REP_NM);
				$("#vidRegInfo #vidBsKind").text(objJson.vidInfo[0].BS_KIND);
				$("#vidRegInfo #vidGdKind").text(objJson.vidInfo[0].GD_KIND);
				$("#vidRegInfo #vidEmail").text(objJson.vidInfo[0].EMAIL);
				
				var vidStatusChkVal = "";
				if(objJson.vidInfo[0].USE_TYPE == "0") {
					vidStatusChkVal = $("#vidStatusChk00").val();
				}else if(objJson.vidInfo[0].USE_TYPE == "1") {
					vidStatusChkVal = $("#vidStatusChk01").val();
				}else if(objJson.vidInfo[0].USE_TYPE == "2") {
					vidStatusChkVal = $("#vidStatusChk02").val();
				}
				$("#vidRegInfo #vidStatusChk").text(vidStatusChkVal);
				
				
				
				$("#vidRegInfo #vidAddress12").text("(" + objJson.vidInfo[0].POST_NO + ") " + objJson.vidInfo[0].ADDR_NO1);
				
				$("#vidRegInfo #vidAddress3").text(objJson.vidInfo[0].ADDR_NO2);
				//$("#vidRegInfo #bankCd").html("<c:out value='${BANK_CD}' escapeXml='false' />");
				
				$("#vidRegInfo #bankCd").select2("val", objJson.vidInfo[0].BANK_CD);
				$("#vidRegInfo #vidBankCd").text($("#vidRegInfo #bankCd option:selected").text());
				
				$("#vidRegInfo #vidVaNo").text(objJson.vidInfo[0].ACCNT_NO);
				$("#vidRegInfo #vidVaNm").text(objJson.vidInfo[0].ACCNT_NM);
				//$("#vidRegInfo #settleCycle").html("<option value='"+objJson.vidInfo[0].STMT_CYCLE_CD+"' selected='selected'>"+objJson.vidInfo[0].V_SETTLE_CYCLE +"</option>");
				
				var vidSettleCycleVal = "";
				if(objJson.vidInfo[0].STMT_CYCLE_CD == "0") {
					vidSettleCycleVal = $("#vidSettleCycle00").val();
				}
				$("#vidRegInfo #vidSettleCycle").text(vidSettleCycleVal);
				
				$("#vidRegInfo #vidRegCashPer").text(objJson.vidInfo[0].RSHARE_RATE + "%");
				
				$("#tbSettleVidInfo #vidMinCashPer").text(objJson.vidInfo[0].MIN_CASH_PER + "%");
				$("#tbSettleVidInfo #vidProfitSharPer").text(objJson.vidInfo[0].PROFIT_SHARE_PER + "%");
				$("#tbSettleVidInfo #vidSaveDt").text(IONPay.Utils.fnStringToDatePickerFormat(objJson.vidInfo[0].SAVE_DT));
				
				
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

	
		
function fnSelectCateListRet(objJson){
	if(objJson.resultCode == 0){
		var smCateList = objJson.SMALL_CATEGORY_LIST;
        $("#SmallCategory").html(smCateList);
        
	}else{
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}

function fnMidInfoDetail(mid) {
	$("#midRegInfo").show(200);
	$("#gidRegInfo").hide();
	$("#vidRegInfo").hide();
	$("#ListSearch").hide();
	
	arrParameter["MER_VAL"]    = '2';
	arrParameter["MER_ID"]    = mid;
	arrParameter["MER_TYPE"]    = "ALL";
			
	strCallUrl   = "/baseInfoMgmt/baseInfoMgmt/selectBaseInfo.do";
	strCallBack  = "fnSelectBaseInfoRet";

	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	
	
}

function fnSendMail(mid, mbsTypeCd) {
	return;
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
                            <input type="hidden" id="directMerchant" value="<spring:message code="DDLB_0140" />">
                            <input type="hidden" id="notDirectMerchant" value="<spring:message code="DDLB_0141" />">
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
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code="IMS_BIM_MM_0006" /></label> 
	                                        <select id="MER_TYPE" name="MER_TYPE" class="select2 form-control">
	                                        </select>
	                                    </div>      
	                                    <div class="col-md-6">
                                            <label class="form-label">&nbsp;</label>
                                            <div style="padding-left: 30%">
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
	                                 	<th>NO</th>
	                                 	<th>가맹점구분</th>
	                                 	<th>사업자번호</th>
	                                 	<th>상호</th>
	                                 	
	                                 	<th>MID</th>
	                                 	<th>GID</th>
	                                 	<th>VID</th>
	                                 	<th>상세보기</th>
	                                 	<th>계약완료 메일발송</th>
	                                     <%-- <th><spring:message code="IMS_BIM_BIR_0003" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0004" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0005"/></th>
	                                     <th id="id"></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0006" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0007" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0008" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0009" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0010" /></th>
	                                     <th><spring:message code="IMS_BIM_BIR_0011" /></th> --%>
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
		                                     <!-- <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px">
												<div class="form-inline" style="margin:0;padding:0;">
													<div class="form-group" style="margin:0;padding:0;float:left;width:100%;">
														<input type="text" class="form-control" id="CO_NO" name="CO_NO" style="width:100%;float:left" maxlength="10"   onchange="chkCoNo.value='false'">
													</div>
												</div>
											 </td> -->
											 <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px" colspan="2" id="midCoNo">
														
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0057"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="RepersentativeName" name="RepersentativeName">
	                                       	 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0061" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="TEL_NO" name="TEL_NO">
	                                       	</td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0051" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="MerchantName" name="MerchantName">
	                                       	</td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0161"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3" id="SIGN_NM" name="SIGN_NM">
	                                       	</td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0137" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px" colspan="2" id="midMid">
														<!-- <input type="text" class="form-control" id="MID" name="MID" style="width:95%;float:left" maxlength="9" onchange="chkID.value='false'">
														<label for="MID" style="margin:0; margin-top:10px;display:inline;float:left" >m</label> -->
	                                       	</td>
											 <%-- <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px">
													<button type='button' id="btnDupMidChk" onclick="fnDupIdChk(MID.value, 'MID');" class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666; margin:0'>
														<spring:message code="IMS_BIM_BIR_0014"/>
													</button>
											 </td> --%>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0163"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="midUrl" name="midUrl">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0164" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="FAX_NO" name="FAX_NO">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="DDLB_0138" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px" colspan="2" id="midGid">
														<!-- <input type="text" class="form-control" id="GID" name="GID" style="width:95%;float:left" readonly>
														<label for="GID" style="margin:0; margin-top:10px;display:inline;float:left">g</label> -->
	                                       	</td>
											 <%-- <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px">
													<button type='button'  id="btnInqGid"  class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666;  margin:0'>
														<spring:message code="IMS_BIM_BIR_0015"/>
													</button>
											 </td> --%>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0165"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="ClassificationBusiness" name="ClassificationBusiness">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0166" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="midMail" name="midMail">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="DDLB_0139" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; border-right:0px" colspan="2" id="midVid">
														<!-- <input type="text" class="form-control" id="VID" name="VID" style="width:95%;float:left" readonly>
														<label for="VID" style="margin:0; margin-top:10px;display:inline;float:left">v</label> -->
	                                       	</td>
											 <%-- <td style="text-align:center; border:1px solid #c2c2c2; border-left:0px">
													<button type='button' id="btnInqVid" class='btn btn-info btn-sm btn-cons' style='border:1px solid #c2c2c2; cursor:default; background-color:white; color:#666;  margin:0'>
														<spring:message code="IMS_BIM_BIR_0015"/>
													</button>
											 </td> --%>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0167"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="BusinessStatus" name="BusinessStatus">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0080" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midUseStatus" name = "midUseStatus">
	                            				<select id = "UseStatus" name = "UseStatus" class = "select2 form-control" style="display: none;">
	                            					<option value='0' selected=true><spring:message code="IMS_BIM_BIR_0025" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0026" /></option>
	                            					<option value='2'><spring:message code="IMS_BIM_BIR_0027" /></option>
	                            				</select>
											 </td>
		                                	</tr>
		                                	
											 
											 <!-- 계약 담당자 -->
											 <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0070" /></td>
		                                     <select id = "ContractStaff" name = "ContractStaff" class = "select2 form-control" style="display: none;">
	                            			 </select>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id = "midContractStaff" name = "midContractStaff">
											 </td>
		                                     
		                                     <!-- 영업 담당자 -->
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0049" /></td>
		                                     <select id = "SalesStaff" name = "SalesStaff" class = "select2 form-control" style="display: none;">
	                            			 </select>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3" id = "midSalesStaff" name = "midSalesStaff">
											 </td>
											 
											 <%-- <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0168"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;">
	                            				<select id = "ACCNT_RISK_GRADE" name = "ACCNT_RISK_GRADE" class = "select2 form-control">
	                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0031" /></option>
	                            					<option value='1'><spring:message code="IMS_BIM_BIR_0032" /></option>
	                            					<option value='2'><spring:message code="IMS_BIM_BIR_0033" /></option>
	                            				</select>
											 </td> --%>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0149" /></td>
		                                     
		                                     <select id = "MALL_TYPE_CD" name = "MALL_TYPE_CD" class = "select2 form-control" style="display: none">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0034" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0035" /></option>
                            				</select>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="midMallTypeCd" name="midMallTypeCd">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0050"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="midContractDate" name="midContractDate">
				                                    <!-- <div class="input-append success date col-md-10 col-lg-10 no-padding">
				                                        <input type="text" id="ContractDate" name="ContractDate" class="form-control">
				                                        <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
				                                    </div>	  -->                    
	                                         </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0015" /></td>
		                                     
		                                     <select id = "RECV_CH_CD" name = "RECV_CH_CD" class = "select2 form-control" style="display: none;">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0036" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0037" /></option>
                            					<option value='2'><spring:message code="IMS_BIM_BIR_0038" /></option>
                            					<option value='3'><spring:message code="IMS_BIM_BIR_0039" /></option>
                            					<option value='4'><spring:message code="IMS_BIM_BIR_0040" /></option>
                            					<option value='5'><spring:message code="IMS_BIM_BIR_0041" /></option>
                            				</select>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midRecvChCd" name = "midRecvChCd">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0169" /></td>
											
											<select id = "BS_KIND_CD" name = "BS_KIND_CD" class = "select2 form-control" style="display: none;">
	                            			</select>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id = "midBsKindCd" name = "midBsKindCd">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0170"/></td>

											<select id = "SmallCategory" name = "SmallCategory" class = "select2 form-control" style="width:40%; display: none">
	                            			</select>		                                    
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3" id = "midSmallCategory" name = "midSmallCategory">
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
		                                     	
		                                     	<div class="col-md-2" id="midAddress1" name="midAddress1">
	                                         		<!-- <input type="text" id="Address1" name="Address1" class="form-control" readonly> -->
		                                     	</div>
		                                     	<div class="col-md-4" id="midAddress2" name="midAddress2">
	                                         		<!-- <input type="text" id="Address2" name="Address2" class="form-control" readonly> -->
		                                     	</div>
		                                     	<div class="col-md-5" id="midAddress3" name="midAddress3">
	                                         		<!-- <input type="text" id="Address3" name="Address3" class="form-control"> -->
		                                     	</div>
	                                         </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><span><spring:message code="IMS_BIM_BIM_0029" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="6">
		                                     	
		                                     	<div class="col-md-2" id="midBusinessAddr1" name="midBusinessAddr1">
	                                         		<!-- <input type="text" id="BusinessAddr1" name="BusinessAddr1" class="form-control" readonly> -->
		                                     	</div>
		                                     	<div class="col-md-4" id="midBusinessAddr2" name="midBusinessAddr2">
	                                         		<!-- <input type="text" id="BusinessAddr2" name="BusinessAddr2" class="form-control" readonly> -->
		                                     	</div>
		                                     	<div class="col-md-5" id="midBusinessAddr3" name="midBusinessAddr3">
	                                         		<!-- <input type="text" id="BusinessAddr3" name="BusinessAddr3" class="form-control"> -->
		                                     	</div>
	                                         </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><spring:message code="IMS_BIM_BIR_0016" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="CONT_EMP_NM" name="CONT_EMP_NM">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="CONT_EMP_TEL" name="CONT_EMP_TEL">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0180"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="CONT_EMP_HP" name="CONT_EMP_HP">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="CONT_EMP_EMAIL" name="CONT_EMP_EMAIL">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><spring:message code="IMS_BIM_BIR_0017" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="STMT_EMP_NM" name="STMT_EMP_NM">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="STMT_EMP_TEL" name="STMT_EMP_TEL">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0180"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="STMT_EMP_CP" name="STMT_EMP_CP">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="STMT_EMP_EMAIL" name="STMT_EMP_EMAIL">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><span><spring:message code="IMS_BIM_BIR_0018" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0178"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="TECH_EMP_NM" name="TECH_EMP_NM">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0179" /></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="TECH_EMP_TEL" name="TECH_EMP_TEL">
											 </td>
		                                	</tr>
		                                	<tr>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><span><spring:message code="IMS_BIM_MM_0180" /></span></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="TECH_EMP_CP" name="TECH_EMP_CP">
											 </td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_MM_0166"/></td>
		                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="TECH_EMP_EMAIL" name="TECH_EMP_EMAIL">
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
	                                	 <!-- 미통보 자동 취소 -->
                            			 <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0007" /></td>
	                                     
	                                     <input type="hidden" id="UnsentAutoCancle00" value="<spring:message code="IMS_BIM_BIR_0023" />">
                            			 <input type="hidden" id="UnsentAutoCancle01" value="<spring:message code="IMS_BIM_BIR_0024" />">
                            			 
	                                     <%-- <select id = "UnsentAutoCancle" name = "UnsentAutoCancle" class = "select2 form-control" style="display: none;">
                           					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0023" /></option>
                           					<option value='1'><spring:message code="IMS_BIM_BIR_0024" /></option>
                           				</select> --%>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midUnsentAutoCancle" name = "midUnsentAutoCancle">
                            			 </td>
                            			 
                            			<!-- 결제 공지 -->
	                                    <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0002"/></td>
										
										<input type="hidden" id="PAY_NOTI_CD00" value="<spring:message code="IMS_BIM_BIR_0166" />">
                            			<input type="hidden" id="PAY_NOTI_CD01" value="<spring:message code="IMS_BIM_BIR_0167" />">
                            			<input type="hidden" id="PAY_NOTI_CD02" value="<spring:message code="IMS_BIM_BIR_0168" />">
                            			<input type="hidden" id="PAY_NOTI_CD03" value="<spring:message code="IMS_BIM_BIR_0169" />">
										
										<%-- <select id = "PAY_NOTI_CD" name = "PAY_NOTI_CD" class = "select2 form-control" style="display: none;">
                           					<option value='00'><spring:message code="IMS_BIM_BIR_0166" /></option>
                           					<option value='01' selected="true"><spring:message code="IMS_BIM_BIR_0167" /></option>
                           					<option value='02'><spring:message code="IMS_BIM_BIR_0168" /></option>
                           					<option value='03'><spring:message code="IMS_BIM_BIR_0169" /></option>
                           				</select> --%>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midPayNotiCd" name = "midPayNotiCd">
                            			 </td>
	                                     
	                                     <!-- 중복 주문 체크 -->
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0020"/></td>
										 
										 <input type="hidden" id="ORD_NO_DUP_FLG00" value="<spring:message code="IMS_BIM_BIR_0213" />">
                            			 <input type="hidden" id="ORD_NO_DUP_FLG01" value="<spring:message code="IMS_BIM_BIR_0025" />">
                            			 
										<%-- <select id = "ORD_NO_DUP_FLG" name = "ORD_NO_DUP_FLG" class = "select2 form-control" style="display: none;">
                           					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                           					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                           				</select> --%>
                           				
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midOrdNoDupFlg" name = "midOrdNoDupFlg">
                            			 </td>
                            			 
                            			 <!-- 부가 가치세 -->
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0004"/></td>
	                                     
	                                     <input type="hidden" id="VAT00" value="<spring:message code="IMS_BIM_BIR_0173" />">
                            			 <input type="hidden" id="VAT01" value="<spring:message code="IMS_BIM_BIR_0174" />">
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midVat" name = "midVat">
                            				
                            				<%-- <select id = "VAT" name = "VAT" class = "select2 form-control" >
                            					<option value='0'><spring:message code="IMS_BIM_BIR_0173" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0174" /></option>
                            				</select> --%>
                            			 </td>
	                                	</tr>
	                                	
	                                	<tr>
	                                	 <!-- 1회 승인금액 최대 -->
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0072" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="ONCE_AMT_MAX" name="ONCE_AMT_MAX">
                            			</td>
                            			 
                            			 <!-- 1회 승인금액 최소 -->
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0073"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="ONCE_AMT_MIN" name="ONCE_AMT_MIN">
                            			 </td>
                            			 
                            			 <!-- 회원 누적한도 금액(1일) -->
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0074" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="MEM_AMT_ONE_DAY" name="MEM_AMT_ONE_DAY">
                            			 </td>
	                                     
	                                     <!-- 회원 누적한도 금액(3일) -->
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0075"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="MEM_AMT_THREE_DAY" name="MEM_AMT_THREE_DAY">
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
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0076" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="EROM_FEE" name="EROM_FEE">
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0077"/></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="APPLY_START_DATE" name="APPLY_START_DATE">
                            			</td>
                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0078"/></td>
	                                     
	                                     <input type="hidden" id="AUTO_CAL_TERM01" value="<spring:message code="IMS_BIM_BM_0700" />">
                            			 <input type="hidden" id="AUTO_CAL_TERM02" value="<spring:message code="IMS_BIM_BM_0701" />">
                            			 <input type="hidden" id="AUTO_CAL_TERM03" value="<spring:message code="IMS_BIM_BM_0702" />">
                            			 <input type="hidden" id="AUTO_CAL_TERM04" value="<spring:message code="IMS_BIM_BM_0703" />">
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midAutoCalTerm" name = "midAutoCalTerm">
                            				<%-- <select id = "AUTO_CAL_TERM" name = "AUTO_CAL_TERM" class = "select2 form-control" style="display: none;">
                            					<option value='1' selected="true"><spring:message code="IMS_BIM_BM_0700" /></option>
                           						<option value='2'><spring:message code="IMS_BIM_BM_0701" /></option>
                           						<option value='3'><spring:message code="IMS_BIM_BM_0702" /></option>
                           						<option value='4'><spring:message code="IMS_BIM_BM_0703" /></option>
                            				</select> --%>
                            			</td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0022" /></td>
	                                     
	                                     <input type="hidden" id="PAY_ID_CD02" value="<spring:message code="IMS_BIM_BM_0468" />">
                            			 <input type="hidden" id="PAY_ID_CD03" value="<spring:message code="IMS_BIM_BM_0469" />">
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midPayIdCd" name = "midPayIdCd">
                            				<%-- <select id = "PAY_ID_CD" name = "PAY_ID_CD" class = "select2 form-control" style="display: none">
                            					<option value='2' selected="true"><spring:message code="IMS_BIM_BM_0468" /></option>
                            					<option value='3'><spring:message code="IMS_BIM_BM_0469" /></option>
                            				</select> --%>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0023"/></td>
	                                     
	                                     <input type="hidden" id="selSettlSvc00" value="<spring:message code="IMS_BIM_BM_0470" />">
                            			 <input type="hidden" id="selSettlSvc01" value="<spring:message code="IMS_BIM_BM_0471" />">
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3" id = "midSelSettlSvc0001" name = "midSelSettlSvc0001">
	                                     	<input type="hidden" name="oldSettlSvc0001" value=""/>
	                                     	<div class="col-md-3">
	                            				<%-- <select id = "selSettlSvc0001" name = "selSettlSvc0001" class = "select2 form-control" style="display: none;">
	                            					<option value='00' selected="true"><spring:message code="IMS_BIM_BM_0470" /></option>
	                            					<option value='01'><spring:message code="IMS_BIM_BM_0471" /></option>
	                            				</select> --%>
	                            				<input type="hidden" name="oldSettlSvc0005" value=""/>
            									<input type="hidden" name="selSettlSvc0005" value="01">
                            				</div>
                            				<div class="col-md-9">
                            				</div>
                            			</td>
	                                	</tr>
	                                	
	                                	
	                                	<select id = "CC_CL_CD" name = "CC_CL_CD" class = "select2 form-control" style="display: none;">
                            			</select>	
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_MM_0095" /></td>
											
										
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midCcClCd" name = "midCcClCd">
                           				 
                           				 </td>
	                                     
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0024" /></td>
	                                     
	                                     <input type="hidden" id="CC_ChkFlg00" value="<spring:message code="IMS_BIM_BIR_0213" />">
                            			 <input type="hidden" id="CC_ChkFlg01" value="<spring:message code="IMS_BIM_BIR_0025" />">
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="3" id = "midCcChkFlg" name = "midCcChkFlg">
                            				<%-- <select id = "CC_ChkFlg" name = "CC_ChkFlg" class = "select2 form-control" style="display: none;">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                            				</select> --%>
                           				 </td>
	                                	</tr>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0025" /></td>
	                                     
	                                     <input type="hidden" id="autoCancel00" value="<spring:message code="IMS_BIM_BIR_0213" />">
                            			 <input type="hidden" id="autoCancel01" value="<spring:message code="IMS_BIM_BIR_0025" />">
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midAutoCancel" name = "midAutoCancel">
                            				<%-- <select id = "autoCancel" name = "autoCancel" class = "select2 form-control" style="display: none;">
                            					<option value='0' selected="true"><spring:message code="IMS_BIM_BIR_0213" /></option>
                            					<option value='1'><spring:message code="IMS_BIM_BIR_0025" /></option>
                            				</select> --%>
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0026"/></td>
	                                     
	                                     <select id = "mBankCd" name = "mBankCd" class = "select2 form-control" style="display: none;">
	                            		 	</select>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id = "midBankCdAcctNo" name = "midBankCdAcctNo">
                           				 	
                           				 </td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
	                                     <td style="text-align:center; border:1px solid #c2c2c2;" id="midAccntNm" name="midAccntNm">
                           				 </td>
	                                	</tr>
	                                	
	                                </tbody>
	                            </table>
	                          </div>
                            </div>
	                	</div>
	                </div>
	           </div> 
               
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
	                            <table class="table" id="tbOthers" width="100%" style="height: 100px">
	                                <tbody>
	                                	<tr>
	                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 150px"><spring:message code="IMS_BIM_BIR_0229" /></td>
	                                     <td style="text-align:left; border:1px solid #c2c2c2;" colspan="6" id="Memo" name="Memo">
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
															<div class="form-group" style="margin:0;padding:0;float:left;width:100%;" id="GID" name="GID">
																<!-- <input type="text" class="form-control" id="GID" name="GID" style="width:50%;float:left">
																<label for="GID" style="margin: 17px 13px 0px 2px; display:inline;float:left">g</label> -->
																
															</div>
														</div>
													 </td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0428"/></td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="4" id="issuDt" name="issuDt">
			                                       	 </td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0415" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="6" id="gidNm"  name="gidNm">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0083" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="6" id="gidCoNo" name="gidCoNo">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0429" /></td>
			                                     	
			                                     	<select class = "select2 form-control" id="bankCd" name="bankCd" style="display: none;"></select>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; width:15%;" id="gidBankCd" name="gidBankCd">
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BIM_BM_0417"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" colspan="2" id="gidVaNo" name="gidVaNo">
													</td>
													<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee; "><spring:message code="IMS_BIM_BIM_0027"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id="gidVaNm" name="gidVaNm">
													</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2" ><spring:message code="IMS_BIM_BM_0431" /></td>
		                           				 	
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BM_CM_0097"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id="gidContNm1" name="gidContNm1">
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">TEL/CP</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id="gidContTelCp1" name="gidContTelCp1">
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">EMAIL</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id="gidContEmail1" name="gidContEmail1">
													</td>
			                                	</tr>
			                                	<tr>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;"><spring:message code="IMS_BM_CM_0097"/></td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id="gidContNm2" name="gidContNm2">
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">TEL/CP</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;"  id="gidContTelCp2" name="gidContTelCp2">
													</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#eee;">EMAIL</td>
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id="gidContEmail2" name="gidContEmail2">
													</td>
			                                	</tr>
			                                	
			                                </tbody>
			                            </table>
		                          	 </div>
	                          	  </div>
            	              </div>
                	        </div>
	                     </div>
	                     
	                     
	                     <!-- START GID SETTLE VIEW AREA -->
	                     <div class = "row" id = "settleGInfo">
		                	<div class = "col-md-12">
		                      <div class="grid simple horizontal light-grey">
		                        <div class="grid-title" >
		                          <h4><span class="semi-bold"><spring:message code="IMS_BIM_MM_0012" /></span></h4>
		                          <div class="tools"> <a href="javascript:;" id="settleGInfoCollapse" class="collapse"></a></div>
		                        </div>
		                        <div class="grid-body" >
		                          <div class="row" id="settleVInfo">
	                         		<table class="table" id="tbSettleGidInfo"  style="width:100%;">
		                                <thead id="thFeeInfo">
		                                	<tr>
		                                		<!-- <th>NO</th> -->
		                                		<th><spring:message code="IMS_BIM_BM_0420" /></th><!-- 결제 서비스 -->
		                                		<%-- <th><spring:message code="IMS_BIM_BM_0450" /></th> --%><!-- 정산주기 -->
		                                		<th><spring:message code="IMS_BIM_BM_0310" /></th><!-- 수수료 -->
		                                		<th><spring:message code="IMS_BIM_BM_0421" /></th><!-- 최소원가 -->
		                                		<%-- <th><spring:message code="IMS_BIM_BM_0437" /></th> --%><!-- 수익배분 -->
		                                		<th><spring:message code="IMS_BIM_BM_0423" /></th><!-- 적용 시작일 -->
		                                	</tr>
			                                <tr>
			                                	<!-- <td class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">1</td> -->
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BM_MSG_0001" /></td>
			                                	<%-- <td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0438" />99</td> --%>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0438" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;" id="gidMinCashPer" name="gidMinCashPer">
			                                	</td>
			                                	
			                                	<td style="text-align:center; border:1px solid #c2c2c2;" id="gidSaveDt" name="gidSaveDt">
			                                	</td>
			                                </tr>
			                                
		                                </thead>
		                                <tbody id="trFeeRegInfo"  style="width: 100%;">
	                                </tbody> 
	                                <tbody id="trFeeInfo" style="display: none; width: 100%;"> </tbody>
		                            </table>	
                            		
		                          </div>
		                        </div>
		                	</div>
		                </div>
		          	 </div> 
		          	 <!-- END GID SETTVIEW AREA -->
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
															<div class="form-group" style="margin:0;padding:0;float:left;width:100%;" id="vidVid" name="vidVid">
															</div>
														</div>
													 </td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0434" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="9" id="vidNm"  name="vidNm">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0083" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="9" id="vidCoNo" name="vidCoNo">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0143" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="9" id="vidRepNm" name="vidRepNm">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0120" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="4" id="vidBsKind" name="vidBsKind">
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0119" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="4" id="vidGdKind" name="vidGdKind">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;">E-MAIL</td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="4" id="vidEmail" name="vidEmail">
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0435" /></td>
			                                     	
			                                     	<input type="hidden" id="vidStatusChk00" value="<spring:message code="IMS_BIM_BIR_0025" />">
			                                     	<input type="hidden" id="vidStatusChk01" value="<spring:message code="IMS_BIM_BIR_0026" />">
			                                     	<input type="hidden" id="vidStatusChk02" value="<spring:message code="IMS_BIM_BIR_0027" />">
			                                     	<td style="border:1px solid #c2c2c2; text-align: center;" colspan="4" id="vidStatusChk" name="vidStatusChk">
		                            					<%-- <select class = "select2 form-control" id="statusChk" name="statusChk" style="width:30%;">
		                            						<option value='0' selected=true><spring:message code="IMS_BIM_BIR_0025" /></option>
			                            					<option value='1'><spring:message code="IMS_BIM_BIR_0026" /></option>
			                            					<option value='2'><spring:message code="IMS_BIM_BIR_0027" /></option>
		                            					</select> --%>
		                           				 	</td>
			                                	</tr>
			                                	<tr>
				                                     <td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;" rowspan="2"><span><spring:message code="IMS_BIM_BIM_0028" /></span></td>
				                                     <td style="text-align:center; border:1px solid #c2c2c2;" colspan="9" id="vidAddress12" name="vidAddress12">
			                                         </td>
			                                	</tr>
			                                	<tr>
			                                		<td style="text-align:center; border:1px solid #c2c2c2;" colspan="9" id="vidAddress3" name="vidAddress3">
			                                		</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0416" /></td>
			                                     	
			                                     	<select class = "select2 form-control" id="bankCd" name="bankCd" style="width:30%; display: none;"></select>
			                                     	<td style="border:1px solid #c2c2c2; text-align: center;" colspan="9" id="vidBankCd" name="vidBankCd">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0417" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="4" id="vidVaNo" name="vidVaNo">
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BIM_0027" /></td>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2;" colspan="4" id="vidVaNm" name="vidVaNm">
		                           				 	</td>
			                                	</tr>
			                                	<tr>
			                                     	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BM_CM_0079" /></td>
			                                     	
			                                     	<input type="hidden" id="vidSettleCycle00" value="<spring:message code="IMS_BIM_BIR_0249" />">
			                                     	<td style="border:1px solid #c2c2c2; text-align: center;" colspan="4" id="vidSettleCycle" name="vidSettleCycle">
		                            					<%-- <select class = "select2 form-control" id="settleCycle" name="settleCycle">
		                            						<option value='0' selected=true><spring:message code="IMS_BIM_BIR_0249" /></option>
		                            					</select> --%>
		                           				 	</td>
		                           				 	<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;"><spring:message code="IMS_BIM_BM_0419" /></td>
			                                     	<td style="border:1px solid #c2c2c2; text-align: center;" colspan="4" id="vidRegCashPer" name="vidRegCashPer">
		                           				 	</td>
			                                	</tr>
			                                </tbody>
			                            </table>
			                            
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
		                                		<!-- <th>NO</th> -->
		                                		<th><spring:message code="IMS_BIM_BM_0420" /></th><!-- 결제 서비스 -->
		                                		<th><spring:message code="IMS_BIM_BM_0310" /></th><!-- 수수료 -->
		                                		<th><spring:message code="IMS_BIM_BM_0421" /></th><!-- 최소원가 -->
		                                		<th><spring:message code="IMS_BIM_BM_0437" /></th><!-- 수익배분 -->
		                                		<th><spring:message code="IMS_BIM_BM_0423" /></th><!-- 적용 시작일 -->
		                                	</tr>
			                                <tr>
			                                	<!-- <td class="th_verticleLine"  style="text-align:center; border:1px solid #c2c2c2">1</td> -->
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BM_MSG_0001" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;"><spring:message code="IMS_BIM_BM_0438" /></td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;" id="vidMinCashPer" name="vidMinCashPer">
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;" id="vidProfitSharPer" name="vidProfitSharPer">
			                                	</td>
			                                	<td style="text-align:center; border:1px solid #c2c2c2;" id="vidSaveDt" name="vidSaveDt">
			                                	</td>
			                                </tr>
		                                </thead>
		                                <tbody id="trFeeRegInfo"  style="width: 100%;">
	                                </tbody> 
	                                <tbody id="trFeeInfo" style="display: none; width: 100%;"> </tbody>
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
                                      <th><spring:message code='IMS_BIM_BM_0419'/></th>
                                      <td colspan="4" id="rsRate" style="border:1px solid #c2c2c2; background-color:white;"></td>
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

    /* function fnPostSearch(chk) {
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
    } */

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
