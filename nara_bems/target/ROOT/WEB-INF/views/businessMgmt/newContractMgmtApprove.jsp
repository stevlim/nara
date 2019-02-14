<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strPw= "<%=CommonUtils.getSessionInfo(session, "PSWD")%>";
var objCoInfoInquiry;
var objCoMInfoInquiry;
var objCoVInfoInquiry;
var strType ;
$(document).ready(function(){
	fnSetDDLB();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#frmSearch select[name='division']").html("<c:out value='${DIVISION_SEARCH}' escapeXml='false' />");
	$("select[name='STATUS']").html("<c:out value='${STATUSL_EDIT}' escapeXml='false' />");
	$("select[name='RECV_CHANNEL']").html("<c:out value='${RECV_CHANNEL_EDIT}' escapeXml='false' />");
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

	$("#btnSearch").on("click", function(){
		strType ="SEARCH";
		if($("#frmSearch #flgValue").val() == "ALL"){
			/* $("#div_searchResult").css("display", "block");
			$("#div_searchMResult").css("display" , "none");
			$("#div_searchVResult").css("display" , "none"); */
			$("#div_search").css("display", "block");
			$("#div_mSearch").css("display", "none");
			$("#div_vSearch").css("display", "none");
			fnAllReg(strType);
		}else if($("#frmSearch #flgValue").val() == "MID"){
			$("#div_mSearch").css("display", "block");
			$("#div_search").css("display", "none");
			$("#div_vSearch").css("display", "none");
			/* $("#div_searchMResult").css("display", "block");
			$("#div_searchResult").css("display" , "none");
			$("#div_searchVResult").css("display" , "none"); */
			fnMReg(strType);
		}else if($("#frmSearch #flgValue").val() == "VID"){
			$("#div_vSearch").css("display", "block");
			$("#div_mSearch").css("display", "none");
			$("#div_search").css("display", "none");
			/* $("#div_searchVResult").css("display", "block");
			$("#div_searchResult").css("display" , "none");
			$("#div_searchMResult").css("display" , "none"); */
			fnVReg(strType);
		}
	});
	$("#btnExcel").on("click", function(){
		strType ="EXCEL";
		if($("#frmSearch #flgValue").val() == "ALL"){
			IONPay.Msg.fnAlert("구분값이 MID 또는 VID를 선택하셔야 가능합니다.");
			return;
		}else if($("#frmSearch #flgValue").val() == "MID"){
			fnMReg(strType);
		}else if($("#frmSearch #flgValue").val() == "VID"){
			fnVReg(strType);
		}
	});
}
function fnModalApprovalCont(coNo, id){
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalApprCont").modal();
	$("#frmModalApprCont input[name=coNo]").val(coNo);
	strModalID = "modalApprCont";
	/* arrParameter["coNo"] = coNo;
	arrParameter["id"] = id;
    strCallUrl   = "/businessMgmt/newContractMgmt/selectCardFeeInfo.do";
    strCallBack  = "fnModalApprovalContRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack); */
}
function btnApproval(approv){

	arrParameter["coNo"] = $("#frmModalApprCont input[name=coNo]").val();
	arrParameter["approv"] = approv;

	strCallUrl   = "/businessMgmt/newContractMgmt/updateCoApp.do";
    strCallBack  = "fnUpdateCoAppRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnUpdateCoAppRet(objJson){
	if(objJson.resultCode == 0){
		IONPay.Msg.fnAlert("update가 완료되었습니다.");
	} else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnView(coNo){
	strModalID = "modalCoView";
	arrParameter["coNo"] = coNo;
    strCallUrl   = "/businessMgmt/newContractMgmt/selectCoView.do";
    strCallBack  = "fnModalCoViewRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnModalCoViewRet(objJson){
	if(objJson.resultCode == 0 ){
		$("body").addClass("breakpoint-1024 pace-done modal-open ");
		$("#modalCoView").modal();
		if(objJson.coView != null){
			$("#tb_coInfo #registDt").html((typeof objJson.coView.RECV_DT== "undefined" || objJson.coView.RECV_DT==null) ?"":objJson.coView.RECV_DT);
			$("#tb_coInfo #coNo").html(objJson.coView.CO_NO);
			$("#tb_coInfo #coNm").html(objJson.coView.CO_NM);
			$("#tb_coInfo #contMng").html(objJson.coView.contMng);
			$("#tb_coInfo #settMng").html(objJson.coView.settMng);
			$("#tb_coInfo #onLst").html(objJson.coView.onList);
			$("#tb_coInfo #address").html(objJson.coView.address == null?"" :objJson.coView.address);
			$("#tb_coInfo #telNo").html(objJson.coView.TEL_NO);
			$("#tb_coInfo #faxNo").html(objJson.coView.FAX_NO);
			$("#tb_coInfo #email").html(objJson.coView.EMAIL);
			$("#tb_coInfo #startMoney").html(objJson.coView.FUND_AMT);
			$("#tb_coInfo #bsKind").html(objJson.coView.BS_KIND);
			$("#tb_coInfo #gdKind").html(objJson.coView.GD_KIND);
			$("#tb_coInfo #url").html(objJson.coView.CO_URL);
			$("#tb_coInfo #maItem").html(objJson.coView.MAIN_GOODS_NM);
			$("#tb_coInfo #contDt").html(objJson.coView.CONT_DT);
			$("#tb_coInfo #openDt").html(objJson.coView.OPEN_DT);
			$("#tb_coInfo #repNm").html(objJson.coView.REP_NM);
			$("#tb_coInfo #regAmt").html(objJson.coView.rAmt);
			$("#tb_coInfo #regFlg").html(objJson.coView.rFlg);
			$("#tb_coInfo #yAmt").html(objJson.coView.yAmt);
			$("#tb_coInfo #yFlg").html(objJson.coView.yFlg);
			$("#tb_coInfo #contChk").html(objJson.coView.CONTDOC_RCV_FLG=="0"?"미수취":"수취");
			$("#tb_coInfo #recvChan").html(objJson.coView.RECV_CH);
			$("#tb_coInfo #nowStatus").html(objJson.coView.CONT_ST);
			$("#tb_coInfo #on_ss").html(objJson.contFeeAllInfo.ON_SS);
			$("#tb_coInfo #on_bc").html(objJson.contFeeAllInfo.ON_BC);
			$("#tb_coInfo #on_kb").html(objJson.contFeeAllInfo.ON_KB);
			$("#tb_coInfo #on_ke").html(objJson.contFeeAllInfo.ON_KE);
			$("#tb_coInfo #on_sh").html(objJson.contFeeAllInfo.ON_SH);
			$("#tb_coInfo #on_hd").html(objJson.contFeeAllInfo.ON_HD);
			$("#tb_coInfo #on_lt").html(objJson.contFeeAllInfo.ON_LT);
			$("#tb_coInfo #on_nh").html(objJson.contFeeAllInfo.ON_NH);

			if(objJson.memoList != 0){
				var memoSize = objJson.memoList.length;
				var str = "";
				var time = "";
				str += "<tr><td colspan='2'> <spring:message code='IMS_BM_CM_0117'/></td></tr>";
				for(var i=0; i<memoSize; i++){
					time = objJson.memoList[i].WIRTE_TM;
					str += "<tr><td>"+objJson.memoList[i].WRITE_DT+"&nbsp;"+time.substring(0,2)+":"+time.substring(2,4)+":"+time.substring(4,6)+"<br><font color='gray' ["+objJson.memoList[i].WORKER+"]</font> </td>";
					str += "<td><div>"+objJson.memoList[i].MEMO+"</div></td></tr>";
				}

				$("#tb_memoInfo").html(str);
			}
		}else{
			IONPay.Msg.fnAlert("data no");
		}

	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}

}
function fnAllReg(strType) {
	  if(strType == "SEARCH"){
			if (typeof objCoInfoInquiry == "undefined") {
			   objCoInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbNewContractMgmt", true, {
		        url: "/businessMgmt/newContractMgmt/selectCoApprInfoList.do",
		        data: function() {
		            return $("#frmSearch").serializeObject();
		        },
		        columns: [
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RECV_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.RECV_DT) } },
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  "<a href='#' onClick='fnView(\""+data.CO_NO+"\")'>"+data.CO_NO} },
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM} },
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.PAY_CD == "1"?data.REQ_AMT:""} },
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.PAY_CD == "2"?data.REQ_AMT:""} },
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  "0"} }, //보증보험 금액
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  "0"} }, //증권외 담보 금액
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.AVG_FEE} },
		            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.EMP_NM} },
		            { "class" : "columnc all",         "data" : null, "render": function(data, mngList){
		            	var appBtn = data.CONT_ST_CD;

		            	if(appBtn == "20") {  // 승인 요청건인 경우
		      			  if(mngList.SALES_AUTH_FLQ4 == "1") {
		      				appBtn = "<input type='button' value='승인' class='cctnL02a' onclick='fnModalApprovalCont("+data.CO_NO+","+i+")'>";
		      			  } else {
		      			  	appBtn = "요청중";
		      			  }
		            		appBtn = "<input type='button' value='승인' class='cctnL02a' onclick='fnModalApprovalCont("+data.CO_NO+","+i+")'>";
		      			} else if(appBtn == "21") {  // 승인건인 경우
		      				appBtn = "승인";
		      			} else if(appBtn == "22") {	// 04 승인 반려건인 경우
		      				appBtn = "반려";
		      			} else if(appBtn == "88") {
		      				appBtn = "계약완료";
		      			} else if(appBtn == "89") {
		      				appBtn = "품의완료";
		      			} else {
		      				appBtn = "요청전";
		      			}
		            	var str = "";
		            	str += "<span id='btn_"+i+"'>"+appBtn+"</span>";
	            		return  str;
		            } }
		            ]
			    }, true);
			} else {
			    objCoInfoInquiry .clearPipeline();
			    objCoInfoInquiry .ajax.reload();
			}
			IONPay.Utils.fnShowSearchArea();
			IONPay.Utils.fnHideSearchOptionArea();

		}
  	}
  function fnMReg(strType) {
		if(strType == "SEARCH"){
		if (typeof objCoMInfoInquiry == "undefined") {
			objCoMInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbNewContractMMgmt", true, {
	        url: "/businessMgmt/newContractMgmt/selectCoApprMInfoList.do",
	        data: function() {
	            return $("#frmSearch").serializeObject();
	        },
	        columns: [
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	            //{ "class" : "columnc all",         "data" : null, "render": function(data){return  ""} }, 	//해외구분
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  "<a href='#' onClick='fnView(\""+data.CO_NO+"\")'>"+data.CO_NO} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.AGENT_CL_NM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MID_URL} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.AUTH_FLG_NM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MID} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MID_NM} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.TERM_NO} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CYCLE} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){
	            	var str = "";
	            	if(data.FEE01 != "") str += "%";
	            	else str += "";
 	            	return  '<a href="#" onClick="fnSerFeeView(\'01\', \'01\', \''+data.MID+'\');"">' + (data.FEE01==null?"":data.FEE01) + str} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){
	            	var str = "";
	            	var str1 = "";
	            	if(data.FEE0202 != ""){
	            		str += "원";
	            	}
	            	if(data.FEE0202 != null && data.FEE0202 != ""){
	            		str += "/";
	            	}
	            	if(data.FEE0201 != ""){
	            		str1 += "%";
	            	}
	            	return  (data.FEE0202==null?"":data.FEE0202)+ str + (data.FEE0201==null?"":data.FEE0201) + str1} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){
	            	var str = "";
	            	if(data.FEE03 != "") str += "원";
	            	return  (data.FEE03==null?"":data.FEE03) + str} },
            	{ "class" : "columnc all",         "data" : null, "render": function(data){
	            	var str = "";
	            	if(data.FEE05 != "") str += "%";
	            	return  (data.FEE05==null?"":data.FEE05) + str} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.VID} },
	            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.VGRP_NM} }
	            ]
		    }, true);
		} else {
			objCoMInfoInquiry.clearPipeline();
			objCoMInfoInquiry.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();
		IONPay.Utils.fnHideSearchOptionArea();

		}
		else{
			var $objFrmData = $("#frmSearch").serializeObject();

	        arrParameter = $objFrmData;
	        arrParameter["EXCEL_TYPE"]                  = strType;
	        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
	        IONPay.Ajax.fnRequestExcel(arrParameter, "/businessMgmt/newContractMgmt/selectCoApprMInfoListExcel.do");
		}
	}
  var map = new Map();
  function fnSerFeeView(pmCd, spmCd, mid){
	  map.set("pmCd", pmCd);
	  map.set("spmCd", spmCd);
	  map.set("mid", mid);

	  if(pmCd == "01"){
		 	strModalID = "modalSerFeeView";
			arrParameter["pmCd"] = pmCd;
			arrParameter["spmCd"] = spmCd;
			arrParameter["mid"] = mid;
		    strCallUrl   = "/businessMgmt/newContractMgmt/selectSerFeeView.do";
		    strCallBack  = "fnModalSerFeeViewRet";
		    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	  }
  }
  function fnModalSerFeeViewRet(objJson){
	  if(objJson.resultCode == 0 ){
		  if(objJson.cardList != null){
				$("body").addClass("breakpoint-1024 pace-done modal-open ");
				var str = "";
				for(var i=0; i<objJson.cardList.length; i++){
					var pmCd = map.get("pmCd");
					var spmCd = map.get("spmCd");
					var cpCd = (typeof objJson.feeList[0] == "undefined" ?"":objJson.feeList[0].CP_CD);
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
					var cardSize = objJson.cardList.length;
					var overCardSize = objJson.overCardList.length;
					var cardMap = new Map();
					for(var i=0; i<cardSize+overCardSize; i++){
						if(i<cardSize){
							cardMap = objJson.cardList[i];
						}else{
							cardMap = objJson.overCardList[i-cardSize];
						}

						str += "<tr style='text-align:center;'>";
						str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+cardMap.DESC1+"</td>";
						str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+feeVal+"%</td>";
						str += "<td style='text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+0+"%</td>";
						str += "</tr>";
					}

				}

				//화면 셋팅
				$("#tbody_modalSerFeeView").html(str);
				//모달
				$("#modalSerFeeView").modal();
			}else{
				IONPay.Msg.fnAlert("data not exist");
			}
	  }else{
		  IONPay.Msg.fnAlert(objJson.resultMessage);
	  }
  }
  function fnVReg(strType) {
		if(strType == "SEARCH"){
			if (typeof objCoVInfoInquiry == "undefined") {
				   objCoVInfoInquiry = IONPay.Ajax.CreateDataTable("#tbNewContractVMgmt", true, {
			        url: "/businessMgmt/newContractMgmt/selectCoApprVInfoList.do",
			        data: function() {
			            return $("#frmSearch").serializeObject();
			        },
	        columns: [
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  "<a href='#' onClick='fnView(\""+data.CO_NO+"\")'>"+data.CO_NO} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.AGENT_CL_NM} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.VID} },
					{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.VGRP_NM} } ,
					{ "class" : "columnc all",         "data" : null, "render": function(data){
		            	var str = "";
		            	if(data.FEE01_01 != "") str += "%";
		            	str+= "&nbsp;/&nbsp;" + (typeof data.FEE01_02 == "undefined" ?"" : data.FEE_01_02);
            			if(data.FEE01_02 != "") str += "원";
		            	return  (typeof data.FEE01_01 == "undefined" ?"" : data.FEE_01_01)+ str
					}},
		            { "class" : "columnc all",         "data" : null, "render": function(data){
		            	var str="";
		            	if(data.FEE02_01 != "") str += "원";
		            	str+= "&nbsp;/&nbsp;" + (typeof data.FEE02_02 == "undefined" ?"":data.FEE_02_02);
            			if(data.FEE02_02 != "") str += "%";

		            	return  (typeof data.FEE02_02 == "undefined" ?"":data.FEE02_02)+ str
	            	} },
		            { "class" : "columnc all",         "data" : null, "render": function(data){
		            	var str="";
		            	if(data.FEE03 != "") str += "원";
		            	return  (typeof data.FEE03 == "undefined" ?"":data.FEE03) + str
	            	} },
	            	{ "class" : "columnc all",         "data" : null, "render": function(data){
	            		var str="";
		            	if(data.FEE05_01 != "") str += "%";
		            	str+= "&nbsp;/&nbsp;" + (typeof data.FEE05_01 == "undefined" ?"":data.FEE_05_02);
            			if(data.FEE05_02 != "") str += "%";

		            	return  (typeof data.FEE05_01 == "undefined" ?"":data.FEE05_01 )+ str
	            	} },
	            ]
		    }, true);
		} else {
			objCoVInfoInquiry.clearPipeline();
			objCoVInfoInquiry.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();
		IONPay.Utils.fnHideSearchOptionArea();

		}
		else{
			var $objFrmData = $("#frmSearch").serializeObject();

	        arrParameter = $objFrmData;
	        arrParameter["EXCEL_TYPE"]                  = strType;
	        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
	        IONPay.Ajax.fnRequestExcel(arrParameter, "/businessMgmt/newContractMgmt/selectCoApprVInfoListExcel.do");
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
                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0473'/></label>
                                        <select id="flgValue" name="flgValue" class="select2 form-control">
                                        	<option value='ALL'><spring:message code='IMS_BIM_BM_0284'/></option>
                                        	<option value="MID"><spring:message code='DDLB_0137'/></option>
                                        	<option value="VID"><spring:message code='DDLB_0139'/></option>
                                        </select>
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
                                            <input type="text" id="txtFromDate" name="fromdate" class="form-control">
                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
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
                                            <button type="button" id="btnSearch"  class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
                                            <button type="button" id="btnExcel"  class="btn btn-primary btn-cons">Excel</button>
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
            <div id="div_search"  class="row" style="display:none;">
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
                                                <th><spring:message code='IMS_BM_CM_0095'/></th>
                                                <th><spring:message code='IMS_BIM_BM_0238'/></th>
                                                <th><spring:message code='IMS_BIM_BM_0474'/></th>
                                                <th><spring:message code='IMS_BM_CM_0041'/></th>
                                                <th><spring:message code='IMS_BIM_BM_0174'/></th>
                                             </tr>
                                            </thead>
                                            <tbody id="result"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             <div id="div_mSearch"  class="row" style="display:none;">
                <div class="col-md-12">
                    <div class="grid simple">
                        <div class="grid-title no-border">
                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_CM_0065'/></h4>
                            <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                        </div>
                        <div class="grid-body no-border" >
                            <div id="div_searchMResult">
                                <div class="grid simple ">
                                    <div class="grid-body ">
                                        <table class="table" id="tbNewContractMMgmt" style="width:100%">
                                            <thead>
                                             <tr>
                                             	<th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                <%-- <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_CCS_0026'/>/<spring:message code='IMS_BIM_CCS_0025'/></th> --%>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BM_CM_0032'/>/<spring:message code='IMS_BIM_BM_0475'/></th>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_BM_0142'/></th>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_BM_0476'/></th>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_BM_0477'/></th>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_BM_0478'/></th>
                                                <th colspan="8"><spring:message code='IMS_BIM_BM_0479'/></th>
                                                <th colspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_BM_0480'/></th>
                                                <%-- <th colspan="4"><spring:message code='IMS_BIM_BM_0481'/></th>
                                                <th rowspan="2"><spring:message code='IMS_BIM_BM_0482'/></th>--%>
                                             </tr>
                                             <tr>
                                             	<th><spring:message code='IMS_BIM_BM_0194'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0483'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0396'/></th>
                                             	<th><spring:message code='IMS_BM_CM_0079'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0280'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0281'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0282'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0283'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0195'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0434'/></th>
                                             	<%--
                                             	<th><spring:message code='IMS_BIM_BM_0101'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0484'/>/<spring:message code='IMS_BIM_BM_0485'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0486'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0487'/></th>--%>
                                             </tr>
                                            </thead>
                                            <tbody id="result"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             <div id="div_vSearch"  class="row" style="display:none;">
                <div class="col-md-12">
                    <div class="grid simple">
                        <div class="grid-title no-border">
                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_CM_0065'/></h4>
                            <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                        </div>
                        <div class="grid-body no-border" >
                            <div id="div_searchVResult">
                                <div class="grid simple ">
                                    <div class="grid-body ">
                                        <table class="table" id="tbNewContractVMgmt" style="width:100%">
                                            <thead>
                                             <tr>
                                             	<th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BM_CM_0032'/>/<spring:message code='IMS_BIM_BM_0475'/></th>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_BM_0142'/></th>
                                                <th rowspan="2" class="th_verticleLine" ><spring:message code='IMS_BIM_BM_0476'/></th>
                                                <th colspan="6"><spring:message code='IMS_BIM_BM_0479'/></th>
                                             </tr>
                                             <tr>
                                             	<th><spring:message code='IMS_BIM_BM_0195'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0434'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0488'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0281'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0282'/></th>
                                             	<th><spring:message code='IMS_BIM_BM_0489'/></th>
                                             </tr>
                                            </thead>
                                            <tbody id="result"></tbody>
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
    <!-- BEGIN MODAL -->
    <form id="frmModalApprCont">
		<input type='hidden' name='coNo' >
		<input type='hidden' name='approval' >
		<div class="modal fade" id="modalApprCont"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0490"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                	<tr>
                                		<td><button type="button" onclick="btnApproval(1);" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BIR_0010'/></button></td>
                                		<td><button type="button" onclick="btnApproval(0);" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BIR_0011'/></button></td>
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
  	</form>
	<!-- END MODAL -->
	<!-- BEGIN MODAL -->
	<div class="modal fade" id="modalCoView"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content" >
	            <div class="modal-header" style="background-color: #F3F5F6;">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	                <br />
	                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
	                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_TV_TH_0063"/></h4>
	                <br />
	            </div>
	            <div class="modal-body" style="background-color: #e5e9ec;">
	            	<table class="table" id="tb_coInfo" style="width:100%; border:1px solid #ddd; ">
	            	<thead>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0010'/></th>
	            			<td id="registDt" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0028'/></th>
							<td id="coNm" class="th_verticleLine" colspan='2' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;' ></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0088'/></th>
							<td id="coNo" class="th_verticleLine" colspan='3' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0084'/></th>
	            			<td id="openDt" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0085'/></th>
							<td id="startMoney" colspan='2' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0086'/></th>
							<td id="url" class="th_verticleLine" colspan='3' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0119'/></th>
	            			<td id="bsKind" class="th_verticleLine" colspan='4' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0120'/></th>
							<td id="gdKind" class="th_verticleLine" colspan='3' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0029'/></th>
	            			<td id="repNm" class="th_verticleLine" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0090'/></th>
							<td id="compYMD" class="th_verticleLine" colspan='2' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0087'/></th>
							<td id="inOutChk" class="th_verticleLine" colspan='3' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0093'/></th>
	            			<td id="maItem"  style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0094'/></th>
							<td id="contDt"  class="th_verticleLine"colspan='6' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0033'/></th>
	            			<td id="telNo" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0034'/></th>
							<td id="faxNo" colspan='2'  class="th_verticleLine"style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0035'/></th>
							<td id="email"  class="th_verticleLine"colspan='3' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0036'/></th>
	            			<td id="address"  class="th_verticleLine" colspan='8' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BIM_MM_0070'/></th>
	            			<td id="contMng" class="th_verticleLine" colspan='8' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BIM_BM_0491'/></th>
	            			<td id="settMng" class="th_verticleLine" colspan='8' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BIM_BM_0492'/></th>
	            			<td id="techMng"  class="th_verticleLine"colspan='8' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0109'/></th>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0110'/></th>
	            			<td id="onLst"  class="th_verticleLine"colspan='7' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine" rowspan='7'><spring:message code='IMS_BM_CM_0115'/></th>
	            			<th class="th_verticleLine" colspan='8'><spring:message code='IMS_BIM_BM_0280'/></th>
	            		</tr>
	            		<tr>
				          <th class="th_verticleLine">삼성</th>
				          <th class="th_verticleLine">비씨</th>
				          <th class="th_verticleLine">KB국민</th>
				          <th class="th_verticleLine">하나(외환)</th>
				          <th class="th_verticleLine">신한</th>
				          <th class="th_verticleLine">현대</th>
				          <th class="th_verticleLine">롯데</th>
				          <th class="th_verticleLine">NH채움</th>
				        </tr>
				        <tr>
				          <td id="on_ss" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				          <td id="on_bc" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				          <td id="on_kb" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				          <td id="on_ke" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				          <td id="on_sh" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				          <td id="on_hd" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				          <td id="on_lt" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				          <td id="on_nh" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
				        </tr>
				        <tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0046'/></th>
	            			<td id="regAmt" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<td id="regFlg" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<td colspan='6'  class="th_verticleLine"style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'>&nbsp;</td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0116'/></th>
	            			<td id="yAmt" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<td id="yFlg" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<td colspan='6' class="th_verticleLine" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'>&nbsp;</td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0051'/></th>
	            			<td id="contChk" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<!-- 접수 경로 -->
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0015'/></th>
	            			<td id="recvChan" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<!-- 현재상태 -->
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0014'/></th>
	            			<td id="nowStatus" colspan='3'  class="th_verticleLine"style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		<tr>
	            			<th class="th_verticleLine"><spring:message code='IMS_BM_CM_0041'/></th>
	            			<td id="contMng1" class="th_verticleLine" style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            			<th class="th_verticleLine"><spring:message code='IMS_BIM_BM_0099'/></th>
	            			<td id="salesMng" class="th_verticleLine" colspan='6' style='text-align:center; border:1px solid #c2c2c2; background-color:#F7F6F6;'></td>
	            		</tr>
	            		</thead>
	            	</table>
	            	<table class="table" id="tb_memoInfo" style="width:100%; border:1px solid #ddd;"></table>
            	</div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
	            </div>
            </div>
        </div>
    </div>
	<!-- END MODAL -->
	<!-- BEGIN FEE_REG_CARD_LIST MODAL -->
		<div class="modal fade" id="modalSerFeeView"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
		                    <table class="table" id="tb_modalSerFeeView" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                  <tr>
                                      <th><spring:message code='IMS_BIM_BM_0178'/></th>
                                      <th><spring:message code='IMS_BIM_BM_0310'/></th>
                                      <th><spring:message code='DDLB_0144'/></th>
                                  </tr>
                                 </thead>
                                 <tbody id="tbody_modalSerFeeView"></tbody>
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
