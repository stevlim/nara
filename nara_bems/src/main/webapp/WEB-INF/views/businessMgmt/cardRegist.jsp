<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp"%>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objCardList;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strType;
$(document).ready(function(){
	IONPay.Auth.Init("${AUTH_CD}");
	fnInitEvent();
    fnSetDDLB();
    fnInit();
});

function fnInit(){
	$("#div_search").css("display", "none");
} 
function fnInitEvent(){
    
    $("#btnSearch").on("click", function() { 
    	strType = "SEARCH";
    	fnCardListDT(strType);
   		$("#div_search").css("display", "block");
    });
    $("#btnExcel").on("click", function() {
    	strType = "EXCEL";
    	fnCardListDT(strType);
    });
}

function fnSetDDLB() {
    $("#frmEdit #STATUS").html("<c:out value='${STATUS_EDIT}' escapeXml='false' />");    
    $("select[name$='ORD_NO_DUP_CHK_FLG']").html("<c:out value='${ORD_NO_DUP_CHK_FLG_EDIT}' escapeXml='false' />");
    $("select[id='selInsSTATUS']").html("<c:out value='${MERCHANT_STATUS_EDIT}' escapeXml='false' />");
    $("#frmSearch #BOARD_TYPE").html("<c:out value='${BOARD_TYPE_SEARCH}' escapeXml='false' />");
    $("#frmSearch #BOARD_CHANNEL").html("<c:out value='${BOARD_CHANNEL_SEARCH}' escapeXml='false' />");
    
    
    $("#frmSearch #cardChk").html("<c:out value='${CARD_LIST}' escapeXml='false' />");
    $("#frmSearch #status").html("<c:out value='${STATUSL_EDIT}' escapeXml='false' />");
    $("#frmSearch #contManager").html("<c:out value='${EMP_MANAGER}' escapeXml='false' />");
    
}
/**------------------------------------------------------------
* 카드 리스트 조회
------------------------------------------------------------*/
function fnCardListDT(strType){
	if(strType == "SEARCH"){
		arrParameter = $("#frmSearch").serializeObject()
		strCallUrl   = "/businessMgmt/subMall/selectSubCardList.do";
	    strCallBack  = "fnCardListDTRet";
	    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/businessMgmt/subMall/selectSubCardListExcel.do");
	}
	
}
function fnCardListDTRet(objJson){
	if(objJson.resultCode == 0 ){
		var str = "";
		if(objJson.data.length > 0){
			for(var i=0; i<objJson.data.length; i++){
				str += "<tr>";
				str += "<input type='hidden' name='coNo_"+i+"' value='"+objJson.data[i].CO_NO+"'>" // 사업자 번호
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"+objJson.data[i].RNUM+"</td>"	// No
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"+objJson.data[i].CONT_DT+"</td>"
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"+objJson.data[i].REQ_DT+"</td>"
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"+objJson.data[i].CO_NO+"</td>"
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"+(objJson.data[i].CO_URL==null?"":objJson.data[i].CO_URL)+"</td>"
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"+(objJson.data[i].BS_KIND==null?"":objJson.data[i].BS_KIND)+"</td>"
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"+(objJson.data[i].EMP==null?"":objJson.data[i].EMP)+"</td>"
				if(objJson.cardLst.length > 0){
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[1]!=null) str += objJson.cardLst[1].status1;
						else str += "미등록";
					str += "</td>";
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[0]!=null) str += objJson.cardLst[0].status0;
						else str += "미등록";
					str += "</td>";
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[4]!=null) str += objJson.cardLst[4].status4;
						else str += "미등록";
					str += "</td>";
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[6]!=null) str += objJson.cardLst[6].status6;
						else str += "미등록";
					str += "</td>";
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[5]!=null) str += objJson.cardLst[5].status5;
						else str += "미등록";
					str += "</td>";
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[2]!=null) str += objJson.cardLst[2].status2;
						else str += "미등록";
					str += "</td>";
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[3]!=null) str += objJson.cardLst[3].status3;
						else str += "미등록";
					str += "</td>";
					str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'>"
						if(objJson.cardLst[7]!=null) str += objJson.cardLst[7].status7;
						else str += "미등록";
					str += "</td>";						
				}
				str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'><input type='button' id='btnReg' value='등록' class='btn btn-info btn-sm btn-cons' onclick='fnSubmallRegPop(\""+objJson.data[i].CO_NO+"\")'/> </td>"
				str += "</tr>"  
			}
		}else {   // 데이터가 없는 경우
			str += "<tr >"
			str += "<td colspan='17' style='text-align:center; border:1px solid #c2c2c2; background-color:#FFFFFF;'> 내역이 없습니다 </td>"
			str += "</tr>"
		}	
		
		$("#cardLst").html(str);
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}


function chkChangeVal(obj, oldSelName,cpCd){
		var oldValue = $("#frmSubCardReg input[name="+oldSelName+"]").val();
	  
	  if(oldValue != "" && oldValue != "00" && obj.value == "00"){
		  IONPay.Msg.fnAlert("심사상태 이후에는 미등록 상태로 변경하실 수 없습니다.");
		  obj.value = oldValue ;
		  
		  return false;
	  }
	  
}
function fnChgChkbox(obj){
	  var aCpCd = ["01","02","03","04","06","07","08","12"];
	  
	  for(var i =0; i < aCpCd.length; i++ ){
		  var chkObj = $("#frmSubCardReg input[name=chk"+aCpCd[i]+"]");
		  
		  if(obj.checked){
			  chkObj.prop("checked", true);
		  }else{
			  chkObj.prop("checked", false);
		  }
	  }
}
function allSelStatus(val){
	  var aCpCd = ["01","02","03","04","06","07","08","12"];
	  var old = $("#frmSubCardReg input[name=oldSel]");
	  var iCnt = 0;
	  for(var i =0; i < aCpCd.length; i++ ){
		  var oldObj = $("#frmSubCardReg input[name=oldSel"+aCpCd[i]+"]");
		  var selObj = $("#frmSubCardReg select[name=sel"+aCpCd[i]+"]");
		  var txtObj = $("#frmSubCardReg input[name=txt"+aCpCd[i]+"]");
		  var chkObj = $("#frmSubCardReg input[name=chk"+aCpCd[i]+"]");
		 
		  if(chkObj.is(":checked")){
			 if(oldObj.value != "" && oldObj.value != "00"){
				 if(val=="00"){
					 continue;
				 }
				 
				 if(selObj.value == val){
					 continue;
				 }
				 
				 selObj.select2("val", val);
			 }else{
				 selObj.select2("val", val);
				 
			 }
			 
	  	}else{
	  		iCnt++;
	  	}
	  }
	  
	  if(iCnt == aCpCd.length){
		  IONPay.Msg.fnAlert("체크박스를 선택해주세요.");
		  return;
	  }
}
var map = new Map();
function fnSubmallRegPop(coNo){
	map.set("coNo", coNo);
	arrParameter["coNo"] = coNo;
	strCallUrl   = "/businessMgmt/subMall/selectCardSubMallInfo.do";
    strCallBack  = "fnSubmallRegPopRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSubmallRegPopRet(objJson){
	if(objJson.resultCode ==0 ){
		if(objJson.data.CNT != 0){
			$("body").addClass("breakpoint-1024 pace-done modal-open ");
				if(objJson.data.SEL01!="")$("#frmSubCardReg select[name=sel01]").select2("val",objJson.data.SEL01) 
				else $("#frmSubCardReg select[name=sel01]").select2("val","00");
				if(objJson.data.SEL02!="")$("#frmSubCardReg select[name=sel02]").select2("val",objJson.data.SEL02)
				else $("#frmSubCardReg select[name=sel02]").select2("val","00");
				if(objJson.data.SEL03!="")$("#frmSubCardReg select[name=sel03]").select2("val",objJson.data.SEL03)
				else $("#frmSubCardReg select[name=sel03]").select2("val","00");
				if(objJson.data.SEL04!="")$("#frmSubCardReg select[name=sel04]").select2("val",objJson.data.SEL04)
				else $("#frmSubCardReg select[name=sel04]").select2("val","00");
				if(objJson.data.SEL05!="")$("#frmSubCardReg select[name=sel05]").select2("val",objJson.data.SEL05)
				else $("#frmSubCardReg select[name=sel05]").select2("val","00");
				if(objJson.data.SEL06!="")$("#frmSubCardReg select[name=sel06]").select2("val",objJson.data.SEL06)
				else $("#frmSubCardReg select[name=sel06]").select2("val","00");
				if(objJson.data.SEL07!="")$("#frmSubCardReg select[name=sel07]").select2("val",objJson.data.SEL07)
				else $("#frmSubCardReg select[name=sel07]").select2("val","00");
				if(objJson.data.SEL08!="")$("#frmSubCardReg select[name=sel08]").select2("val",objJson.data.SEL08) 
				else $("#frmSubCardReg select[name=sel08]").select2("val","00");
				if(objJson.data.SEL12!="")$("#frmSubCardReg select[name=sel12]").select2("val",objJson.data.SEL12)
				else $("#frmSubCardReg select[name=sel12]").select2("val","00");
				
				if(objJson.data.SEL01!="")$("#frmSubCardReg input[name=oldSel01]").val(objJson.data.SEL01);
				if(objJson.data.SEL02!="")$("#frmSubCardReg input[name=oldSel02]").val(objJson.data.SEL02);
				if(objJson.data.SEL03!="")$("#frmSubCardReg input[name=oldSel03]").val(objJson.data.SEL03);
				if(objJson.data.SEL04!="")$("#frmSubCardReg input[name=oldSel04]").val(objJson.data.SEL04);
				if(objJson.data.SEL05!="")$("#frmSubCardReg input[name=oldSel05]").val(objJson.data.SEL05);
				if(objJson.data.SEL06!="")$("#frmSubCardReg input[name=oldSel06]").val(objJson.data.SEL06);
				if(objJson.data.SEL07!="")$("#frmSubCardReg input[name=oldSel07]").val(objJson.data.SEL07);
				if(objJson.data.SEL08!="")$("#frmSubCardReg input[name=oldSel08]").val(objJson.data.SEL08);
				if(objJson.data.SEL12!="")$("#frmSubCardReg input[name=oldSel12]").val(objJson.data.SEL12);
				
				if(objJson.data.REQ_DT01!="")$("#frmSubCardReg input[name=req_dt01]").val(objJson.data.REQ_DT01);
				if(objJson.data.REQ_DT02!="")$("#frmSubCardReg input[name=req_dt02]").val(objJson.data.REQ_DT02);
				if(objJson.data.REQ_DT03!="")$("#frmSubCardReg input[name=req_dt03]").val(objJson.data.REQ_DT03);
				if(objJson.data.REQ_DT04!="")$("#frmSubCardReg input[name=req_dt04]").val(objJson.data.REQ_DT04);
				if(objJson.data.REQ_DT05!="")$("#frmSubCardReg input[name=req_dt05]").val(objJson.data.REQ_DT05);
				if(objJson.data.REQ_DT06!="")$("#frmSubCardReg input[name=req_dt06]").val(objJson.data.REQ_DT06);
				if(objJson.data.REQ_DT07!="")$("#frmSubCardReg input[name=req_dt07]").val(objJson.data.REQ_DT07);
				if(objJson.data.REQ_DT08!="")$("#frmSubCardReg input[name=req_dt08]").val(objJson.data.REQ_DT08);
				if(objJson.data.REQ_DT12!="")$("#frmSubCardReg input[name=req_dt12]").val(objJson.data.REQ_DT12);
				
				if(objJson.data.TXT01!="")$("#frmSubCardReg input[name=txt01]").val(objJson.data.TXT01);
				if(objJson.data.TXT02!="")$("#frmSubCardReg input[name=txt02]").val(objJson.data.TXT02);
				if(objJson.data.TXT03!="")$("#frmSubCardReg input[name=txt03]").val(objJson.data.TXT03);
				if(objJson.data.TXT04!="")$("#frmSubCardReg input[name=txt04]").val(objJson.data.TXT04);
				if(objJson.data.TXT05!="")$("#frmSubCardReg input[name=txt05]").val(objJson.data.TXT05);
				if(objJson.data.TXT06!="")$("#frmSubCardReg input[name=txt06]").val(objJson.data.TXT06);
				if(objJson.data.TXT07!="")$("#frmSubCardReg input[name=txt07]").val(objJson.data.TXT07);
				if(objJson.data.TXT08!="")$("#frmSubCardReg input[name=txt08]").val(objJson.data.TXT08);
				if(objJson.data.TXT12!="")$("#frmSubCardReg input[name=txt12]").val(objJson.data.TXT12);
				
				if(objJson.data.TXT01!="")$("#frmSubCardReg input[name=oldtxt01]").val(objJson.data.TXT01);
				if(objJson.data.TXT02!="")$("#frmSubCardReg input[name=oldtxt02]").val(objJson.data.TXT02);
				if(objJson.data.TXT03!="")$("#frmSubCardReg input[name=oldtxt03]").val(objJson.data.TXT03);
				if(objJson.data.TXT04!="")$("#frmSubCardReg input[name=oldtxt04]").val(objJson.data.TXT04);
				if(objJson.data.TXT05!="")$("#frmSubCardReg input[name=oldtxt05]").val(objJson.data.TXT05);
				if(objJson.data.TXT06!="")$("#frmSubCardReg input[name=oldtxt06]").val(objJson.data.TXT06);
				if(objJson.data.TXT07!="")$("#frmSubCardReg input[name=oldtxt07]").val(objJson.data.TXT07);
				if(objJson.data.TXT08!="")$("#frmSubCardReg input[name=oldtxt08]").val(objJson.data.TXT08);
				if(objJson.data.TXT12!="")$("#frmSubCardReg input[name=oldtxt12]").val(objJson.data.TXT12);
				
				if(objJson.data.RSLT_TM1!="")$("#frmSubCardReg input[name=rslt_dt01]").html(objJson.data.RSLT_TM1);
				if(objJson.data.RSLT_TM2!="")$("#frmSubCardReg input[name=rslt_dt02]").html(objJson.data.RSLT_TM2);
				if(objJson.data.RSLT_TM3!="")$("#frmSubCardReg input[name=rslt_dt03]").html(objJson.data.RSLT_TM3);
				if(objJson.data.RSLT_TM4!="")$("#frmSubCardReg input[name=rslt_dt04]").html(objJson.data.RSLT_TM4);
				if(objJson.data.RSLT_TM5!="")$("#frmSubCardReg input[name=rslt_dt05]").html(objJson.data.RSLT_TM5);
				if(objJson.data.RSLT_TM6!="")$("#frmSubCardReg input[name=rslt_dt06]").html(objJson.data.RSLT_TM6);
				if(objJson.data.RSLT_TM7!="")$("#frmSubCardReg input[name=rslt_dt07]").html(objJson.data.RSLT_TM7);
				if(objJson.data.RSLT_TM8!="")$("#frmSubCardReg input[name=rslt_dt08]").html(objJson.data.RSLT_TM8);
				if(objJson.data.RSLT_TM12!="")$("#frmSubCardReg input[name=rslt_dt12]").html(objJson.data.RSLT_TM12);
				
			$("#modalSubCard").modal();
		}else{
			IONPay.Msg.fnAlert("해당 사업자 번호는 서브몰 등록이 안된 사업자 번호입니다.");
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
//,제휴사 카드 수기 등록
function fnReg(){
	console.log(map.get("coNo"));
	var coNo = map.get("coNo");
	arrParameter = $("#frmSubCardReg").serializeObject();
	arrParameter["worker"] = strWorker;
	arrParameter["coNo"] = coNo;
	strCallUrl   = "/businessMgmt/subMall/insertSubCardReg.do";
    strCallBack  = "fnRegRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnRegRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert(objJson.resultMessage)
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
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
            <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.AFFILIATE_SUB_MALL }'/></a> </li>
		</ul>
		<div class="page-title">
			<i class="icon-custom-left"></i>
			<h3>
				<span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span>
			</h3>
		</div>
		<!-- END PAGE TITLE -->
		<!-- BEGIN VIEW OPTION AREA -->
		<div class="row">
			<div class="col-md-12">
				<div class="grid simple">
					<div class="grid-title no-border">
						<h4>
							<i class="fa fa-th-large"></i>
							<spring:message code='IMS_BIM_BM_0058' />
						</h4>
						<div class="tools">
							<a href="javascript:;" id="searchCollapse" class="collapse"></a>
						</div>
					</div>
					<div class="grid-body no-border">
						<form id="frmSearch" name="frmsearch">
							<div class="row form-row" style="padding: 0 0 10px 0;">
								<div class="col-md-3">
									<label class="form-label"><spring:message
											code='IMS_BIM_BM_0080' /></label> <select id="searchFlg"
										name="searchFlg" class="select2 form-control">
										<option value="0"><spring:message
												code='IMS_BIM_BM_0142' /></option>
										<option value="1"><spring:message
												code='IMS_BIM_BM_0083' /></option>
										<option value="2"><spring:message
												code='IMS_BIM_BM_0143' /></option>
									</select>
								</div>
								<div class="col-md-3">
									<label class="form-label">&nbsp;</label>
									<div class="input-with-icon  right">
										<i class=""></i> <input type="text" id="searchTxt"
											name="searchTxt" class="form-control">
									</div>
								</div>
								<div class="col-md-3">
									<label class="form-label"><spring:message
											code='IMS_BIM_BM_0082' /></label> <select id="cardChk" name="cardChk"
										class="select2 form-control">
									</select>
								</div>
								<div class="col-md-3"></div>
							</div>
							<div class="row form-row" style="padding: 0 0 10px 0;">
								<div class="col-md-4">
									<label class="form-label"><spring:message
											code='IMS_BIM_MM_0070' /></label> <select id="contManager"
										name="contManager" class="select2 form-control">
										<option value="0"><spring:message
												code='IMS_BIM_BM_0081' /></option>
									</select>
								</div>
								<div class="col-md-4">
									<label class="form-label"><spring:message
											code='IMS_BIM_MM_0007' /></label> <select id="status" name="status"
										class="select2 form-control">
									</select>
								</div>
							</div>
							<div class="row form-row">
								<div class="col-md-2">
									<label class="form-label">&nbsp;</label> <select id="dateFlg"
										name="dateFlg" class="select2 form-control">
										<option value="cont"><spring:message
												code='IMS_BIM_BM_0085' /></option>
										<option value="req"><spring:message
												code='IMS_BM_NM_0020' /></option>
									</select>
								</div>
								<div class="col-md-2">
									<label class="form-label">&nbsp;</label>
									<div
										class="input-append success date col-md-10 col-lg-10 no-padding">
										<input type="text" id="txtFromDate" name="fromdate"
											class="form-control"> <span class="add-on"><span
											class="arrow"></span><i class="fa fa-th"></i></span>
									</div>
								</div>
								<div class="col-md-2">
									<label class="form-label">&nbsp;</label>
									<div
										class="input-append success date col-md-10 col-lg-10 no-padding">
										<input type="text" id="txtToDate" name="todate"
											class="form-control"> <span class="add-on"><span
											class="arrow"></span><i class="fa fa-th"></i></span>
									</div>
								</div>
								<div id="divSearchDateType4" class="col-md-3">
									<label class="form-label">&nbsp;</label>
									<button type="button" id="btnToday"
										class="btn btn-success btn-cons">
										<spring:message code='IMS_BM_CM_0056' />
									</button>
									<button type="button" id="btn1Week"
										class="btn btn-success btn-cons">
										<spring:message code='IMS_BM_CM_0057' />
									</button>
									<button type="button" id="btn1Month"
										class="btn btn-success btn-cons">
										<spring:message code='IMS_BM_CM_0058' />
									</button>
									<button type="button" id="btn2Month"
										class="btn btn-success btn-cons">
										<spring:message code='IMS_BM_CM_0059' />
									</button>
									<button type="button" id="btn3Month"
										class="btn btn-success btn-cons">
										<spring:message code='IMS_BM_CM_0060' />
									</button>
								</div>
								<div class="col-md-3">
									<label class="form-label">&nbsp;</label>
									<div>
										<button type="button" id="btnSearch"
											class="btn btn-primary btn-cons">
											<spring:message code='IMS_BM_CM_0061' />
										</button>
										<button type="button" id="btnExcel"
											class="btn btn-primary btn-cons">Excel</button>
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
		<div id="div_search" class="row">
			<div class="col-md-12">
				<div class="grid simple">
					<div class="grid-title no-border">
						<h4>
							<i class="fa fa-th-large"></i>
							<spring:message code='IMS_BIM_BM_0061' />
						</h4>
						<div class="tools">
							<a href="javascript:;" class="collapse"></a>
						</div>
					</div>
					<div class="grid-body no-border">
						<div id="div_searchResult">
							<div class="grid simple ">
								<div class="grid-body">
									<table id="tbCreditCardMgmt" class="table" style="width: 100%">
										<thead>
											<tr>
												<th>NO</th>
												<th><spring:message code='IMS_BIM_BM_0085' /></th>
												<th><spring:message code='IMS_BIM_BM_0086' /></th>
												<th><spring:message code='IMS_BIM_BM_0110' /></th>
												<th>URL</th>
												<th><spring:message code='IMS_BIM_BM_0111' /></th>
												<th><spring:message code='IMS_BIM_BM_0112' /></th>
												<th><spring:message code='IMS_BIM_BM_0090' /></th>
												<th><spring:message code='IMS_BIM_BM_0113' /></th>
												<th><spring:message code='IMS_BIM_BM_0088' /></th>
												<th><spring:message code='IMS_BIM_BM_0114' /></th>
												<th><spring:message code='IMS_BIM_BM_0115' /></th>
												<th><spring:message code='IMS_BIM_BM_0116' /></th>
												<th><spring:message code='IMS_BIM_BM_0117' /></th>
												<th><spring:message code='IMS_BIM_BM_0118' /></th>
												<th><spring:message code='IMS_BIM_BM_0119' /></th>
											</tr>
										</thead>
										<tbody id="cardLst"></tbody>
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
	<!-- END PAGE -->
</div>
<!-- BEGIN PAGE CONTAINER-->
<!-- END CONTAINER -->
<!-- BEGIN MODAL -->
<div class="modal fade" id="modalSubCard" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<br /> <i id="icon" class="fa fa-envelope-o fa-2x"></i>
				<h4 id="myModalLabel" class="semi-bold">
					<spring:message code="IMS_BIM_BM_0496" />
				</h4>
				<br />
			</div>
			<form id="frmSubCardReg" name="frmSubCardReg">
				<div class="modal-body">
					<div class="row form-row">
						<table class="table" id="tbSubCard" style="width: 100%">
							<thead>
								<tr>
									<th id="cardNm"
										style="text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;">
										<input name="allChk" value="1" type="checkbox"
										class="checkbox check-success" onchange="fnChgChkbox(this);">
									</th>
									<th
										style="text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;"><spring:message
											code="IMS_BIM_BM_0178" /></th>
									<th
										style="text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;"><spring:message
											code="IMS_BIM_BM_0101" /></th>
									<th
										style="text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;"><spring:message
											code="IMS_BIM_BM_0497" /></th>
									<th
										style="text-align: center; border: 1px solid #c2c2c2; background-color: #ecf0f2;"><spring:message
											code="IMS_BIM_BM_0498" /></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input name="chk02" value="1" type="checkbox"
										class="checkbox check-success">
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<spring:message code="IMS_BIM_BIM_0034" />
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input type="hidden" name='oldSel02' value="" /> <select
										name="sel02" onChange="chkChangeVal(this, 'oldSel02','02');"
										class="select2 form-control">
											<option value="00">미등록</option>
											<option value="01">심사중</option>
											<option value="88">등록완료</option>
											<option value="02">반 송</option>
											<option value="03">제 외</option>
									</select> <input type="hidden" name="req_dt02" />
									</td>
									<td id="rslt_dt02"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
									</td>
									<td align="left"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>&nbsp;
										<input type="text" name="txt02" value="" maxlength="200"
										class="form-control"> <input type="hidden"
										name="oldtxt02" value="" />
									</td>
								</tr>
								<!-- 비씨카드 -->
								<tr>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input name="chk01" value="1" type="checkbox"
										class="checkbox check-success">
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<spring:message code="IMS_BIM_BIM_0033" />
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input type="hidden" name='oldSel01' value="" /> <select
										name="sel01" onChange="chkChangeVal(this, 'oldSel01','01');"
										class="select2 form-control">
											<option value="00">미등록</option>
											<option value="01">심사중</option>
											<option value="88">등록완료</option>
											<option value="02">반 송</option>
											<option value="03">제 외</option>
									</select> <input type="hidden" name="req_dt01" />
									</td>
									<td id="rslt_dt01"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
									</td>
									<td align="left"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>&nbsp;
										<input type="text" name="txt01" value="" maxlength="200"
										class="form-control"> <input type="hidden"
										name="oldtxt01" value="" />
									</td>
								</tr>
								<!-- 롯데  -->
								<tr>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input name="chk08" type="checkbox"
										class="checkbox check-success">
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<spring:message code="IMS_BIM_BIM_0038" />
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input type="hidden" name='oldSel08' value="" /> <select
										name="sel08" onChange="chkChangeVal(this, 'oldSel08','08');"
										class="select2 form-control">
											<option value="00">미등록</option>
											<option value="01">심사중</option>
											<option value="88">등록완료</option>
											<option value="02">반 송</option>
											<option value="03">제 외</option>
									</select> <input type="hidden" name="req_dt08" />
									</td>
									<td id="rslt_dt08"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
									</td>
									<td align="left"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>&nbsp;
										<input type="text" name="txt08" value="" maxlength="200"
										class="form-control"> <input type="hidden"
										name="oldtxt08" value="" />
									</td>
								</tr>
								<!--  하나(외환)  -->
								<tr>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input name="chk03" type="checkbox"
										class="checkbox check-success">
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<spring:message code="IMS_BIM_BIM_0035" />
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input type="hidden" name='oldSel03' value="" /> <select
										name="sel03" onChange="chkChangeVal(this, 'oldSel03','03');"
										class="select2 form-control">
											<option value="00">미등록</option>
											<option value="01">심사중</option>
											<option value="88">등록완료</option>
											<option value="02">반 송</option>
											<option value="03">제 외</option>
									</select> <input type="hidden" name="req_dt03" />
									</td>
									<td id="rslt_dt03"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
									</td>
									<td align="left"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>&nbsp;
										<input type="text" name="txt03" value="" maxlength="200"
										class="form-control"> <input type="hidden"
										name="oldtxt03" value="" />
									</td>
								</tr>
								<!-- 현대 -->
								<tr>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input name="chk07" type="checkbox"
										class="checkbox check-success">
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<spring:message code="IMS_BIM_BIM_0037" />
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input type="hidden" name='oldSel07' value="" /> <select
										name="sel07" onChange="chkChangeVal(this, 'oldSel07','07');"
										class="select2 form-control">
											<option value="00">미등록</option>
											<option value="01">심사중</option>
											<option value="88">등록완료</option>
											<option value="02">반 송</option>
											<option value="03">제 외</option>
									</select> <input type="hidden" name="req_dt07" />
									</td>
									<td id="rslt_dt07"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
									</td>
									<td align="left"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>&nbsp;
										<input type="text" name="txt07" value="" maxlength="200"
										class="form-control"> <input type="hidden"
										name="oldtxt07" value="" />
									</td>
								</tr>
								<!-- 삼성  -->
								<tr>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input name="chk04" type="checkbox"
										class="checkbox check-success">
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<spring:message code="IMS_BIM_BM_0117" />
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input type="hidden" name='oldSel04' value="" /> <select
										name="sel04" onChange="chkChangeVal(this, 'oldSel04','04');"
										class="select2 form-control">
											<option value="00">미등록</option>
											<option value="01">심사중</option>
											<option value="88">등록완료</option>
											<option value="02">반 송</option>
											<option value="03">제 외</option>
									</select> <input type="hidden" name="req_dt04" />
									</td>
									<td id="rslt_dt04"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
									</td>
									<td align="left"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>&nbsp;
										<input type="text" name="txt04" value="" maxlength="200"
										class="form-control"> <input type="hidden"
										name="oldtxt04" value="" />
									</td>
								</tr>
								<!-- 신한  -->
								<tr>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input name="chk06" type="checkbox"
										class="checkbox check-success">
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<spring:message code="IMS_BIM_BM_0088" />
									</td>
									<td
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
										<input type="hidden" name='oldSel06' value="" /> <select
										name="sel06" onChange="chkChangeVal(this, 'oldSel06','06');"
										class="select2 form-control">
											<option value="00">미등록</option>
											<option value="01">심사중</option>
											<option value="88">등록완료</option>
											<option value="02">반 송</option>
											<option value="03">제 외</option>
									</select> <input type="hidden" name="req_dt06" />
									</td>
									<td id="rslt_dt06"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>
									</td>
									<td align="left"
										style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'>&nbsp;
										<input type="text" name="txt06" value="" maxlength="200"
										class="form-control"> <input type="hidden"
										name="oldtxt06" value="" />
									</td>
								</tr>
							</tbody>
						</table>
						<table>
							<tr>
								<td></td>
							</tr>
						</table>
						<table>
							<tr>
								<td><span><spring:message code="IMS_BIM_BM_0499" /></span>
								</td>
								<td><select name="allSel" class="select2 form-control">
										<option value="00">미등록</option>
										<option value="01">심사중</option>
										<option value="88">등록완료</option>
										<option value="02">반 송</option>
										<option value="03">제 외</option>
								</select></td>
								<td><input name="" type="button" value="적용"
									onClick="allSelStatus(document.frmSubCardReg.allSel.value);" />
								</td>
							</tr>
						</table>
					</div>
				</div>
			</form>
			<div class="modal-footer">
				<button type="button" onclick="fnReg();" class="btn btn-default">저장</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- END MODAL -->