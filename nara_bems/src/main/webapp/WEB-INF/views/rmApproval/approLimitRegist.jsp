<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objApproLimitList;

$(document).ready(function(){
	fnInitEvent();
	fnSetDDLB();
});

function fnInitEvent() {
    fnSetValidate();

    $("select[name=searchFlg]").on("change", function(){
    	if ($.trim(this.value) == "") {
    		$("#search").val("");
    		$("#search").attr("readonly", true);
    		$("#category").css("display", "none");
    		$("#seachDiv").css("display", "block");
    	}
    	else if($.trim(this.value) == "5")
    	{
    		//카테고리
    		$("#category").css("display", "block");
    		$("#seachDiv").css("display", "none");
    	}
    	else {    		
    		$("#search").attr("readonly", false);
    		$("#category").css("display", "none");
    		$("#seachDiv").css("display", "block");
    	}
    });
    
    $("#btnSearch").on("click", function() {
    	fnInquiry("SEARCH");
    });
    $("#btnEdit").on("click", function() {
    	fnSave();
    });    
    $("#btnExcel").on("click", function() {
    	fnInquiry("EXCEL");
    });
    $("#btnRegist").on("click", function() {
    	var flg = $("select[name=searchFlg]").val();
    	var schTxt = $("#searchFlg option:selected").text();
    	var schId = $("input[name=search]").val();
    	fnRegist(flg, schTxt,schId );
    });  
}

function fnSetDDLB() {
	$("#frmSearch #searchFlg").html("<c:out value='${SEARCH_FLG}' escapeXml='false' />");
    $("#frmSearch #tranCutFlg").html("<c:out value='${Cut_Chk}' escapeXml='false' />");
    $("#frmSearch #payType").html("<c:out value='${PAY_TYPE}' escapeXml='false' />");
    $("#frmSearch #dateChk").html("<c:out value='${DATE_CHK}' escapeXml='false' />");
    $("#frmSearch #exhRate").html("<c:out value='${EXHAUST_RATE}' escapeXml='false' />");
    $("#regist #searchFlg").html("<c:out value='${SEARCH_FLG}' escapeXml='false' />");
    $("#regist #tranCutFlg").html("<c:out value='${Cut_Chk1}' escapeXml='false' />");
    $("#regist #payType").html("<c:out value='${PAY_TYPE1}' escapeXml='false' />");
    $("#regist #instMon").html("<c:out value='${INST_MON}' escapeXml='false' />");
    $("#regist #cashLimit").html("<c:out value='${LIMIT_CASH}' escapeXml='false' />");
    $("#regist #countLimit").html("<c:out value='${LIMIT_COUNT}' escapeXml='false' />");
    $("#regist #sendChk").html("<c:out value='${SEND_CHK}' escapeXml='false' />");
    $("#regist #target").html("<c:out value='${TARGET}' escapeXml='false' />");
    
    $("#regist #detail").html("<c:out value='${CARDCD}' escapeXml='false' />");
    
    $("#frmSearch #cate").html("<c:out value='${CATE1}' escapeXml='false' />");
}

function fnSetValidate() {
    var arrValidate = {
                FORMID   : "frmEdit",
                VARIABLE : {                    
                    STATUS : {required: true}
                    }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

function changeAction(seq) {
	$("#btnRegist").trigger("click");
	
	fnEdit(seq);
}

function fnSubCategorySetting(codeCl){
	arrParameter["code1"] = codeCl;
	strCallUrl = "/rmApproval/approvalLimit/selectSubCategory.do";
	strCallBack = "fnSubCategorySettingRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSubCategorySettingRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.data != null ) {
			var htmlStr = "";
			for(var i=0; i < objJson.data.length; i++){
				htmlStr += "<option value='" + objJson.data[i].CODE2 + "'>" + objJson.data[i].DESC2 + "</option>";
			}
			
			$("#frmSearch #subCate").html(htmlStr);
		}
	}
	else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnSave() {
	arrParameter = $("#regist").serializeObject();
	arrParameter["worker"] = strWorker;
	arrParameter["idCd"] = $("#frmSearch #searchFlg").val();
	arrParameter["lmtId"] = $("#frmSearch #search").val();
	strCallUrl = "/rmApproval/approvalLimit/saveApproLimit.do";
	strCallBack = "fnSaveRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSaveRet(objJson) {
	if (objJson.resultCode == 0) {
		IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
		IONPay.Utils.fnJumpToPageTop();
		
		$("#div_frm .grid.simple").css("display", "none");
		$("#searchCollapse").css("display", "block");
	} else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnEdit(seq) {
	arrParameter = $("#regist").serializeObject();
	arrParameter["worker"] = strWorker;
	arrParameter["seqNo"] = seq;
	strCallUrl = "/rmApproval/approvalLimit/selectApproLimitDetail.do";
	strCallBack = "fnEditRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnEditRet(objJson) {
	if (objJson.resultCode == 0) {
		if(objJson.data != null ) {
			$("#regist #tranCutFlg").val(objJson.data.BLOCK_FLG);
			$("#regist #date").val(objJson.data.FR_DT);
			$("#regist #payType").val(objJson.data.PM_CD);
			$("#regist #instMon").val(objJson.data.INSTMN_DT);
			$("#regist #limitType").val(objJson.data.LMT_CD);
			$("#regist #detail").val(objJson.data.LMT_TYPE_CD);
			$("#regist #cashLimit").val(objJson.data.AMT_TYPE);
			$("#regist #limit").val(objJson.data.AMT_LMT);
			$("#regist #countLimit").val(objJson.data.CNT_TYPE);
			$("#regist #count").val(objJson.data.CNT_LMT);
			$("#regist #sendChk").val(objJson.data.NOTI_FLG);
			$("#regist #target").val(objJson.data.NOTI_TRG_TYPE);
			$("#regist #pac").val(objJson.data.NOTI_PCT);
			
			$("#regist #maxCount").val(objJson.data.MAX_SND_CNT);
			$("#regist #sendEmail").val(objJson.data.EMAIL_LIST);
			$("#regist #sendSms").val(objJson.data.SMS_LIST);
			$("#regist #regiReason").val(objJson.data.MEMO);
			$("#regist #registType").val("1");	
			$("#regist #seqNo").val(objJson.data.SEQ);	
		}
	} else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnInquiry(strType) {
    
    $("#div_searchResult").serializeObject();
    $("#div_searchResult").show(200);    
    if(strType == "SEARCH"){
	   	if (typeof objApproLimitList == "undefined") {
	   		objApproLimitList = IONPay.Ajax.CreateDataTable("#tbApproLimitListSearch", true, {
	               url: "/rmApproval/approvalLimit/selectApproLimitList.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
	                   { "class" : "columnc all",         	"data" : null, "render":function(data){return data.RNUM} },
// 	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SEQ} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TRX_ST_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.LMT_ID}},
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return ("5" == data.LMT_CD ? "["+data.CATE1+"]"+data.CATE2 : data.LMT_CD);} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.BLOCK_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.PM_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.LMT_CD_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return gMessage(data.LMT_TYPE_CD_NM)} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.INSTMN_DT} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){
	                	   if("Y" == data.MODIFY_YN) { 
	                		   return "<a href='#' onclick='changeAction(" + data.SEQ + ")'>"+ IONPay.Utils.fnStringToDateFormat(data.FR_DT) +"</a>"; 
	   					   }
						   else
	                	   	   return IONPay.Utils.fnStringToDateFormat(data.FR_DT);
	                	   } },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.TO_DT)} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.AMT_TYPE_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.AMT_LMT} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CNT_TYPE_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CNT_LMT} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.NOTI_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.NOTI_TRG_TYPE_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.NOTI_PCT} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.EMAIL_LIST} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SMS_LIST} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REG_DATE} }
	               ]
	       }, true);
	    } else {
	    	objApproLimitList.clearPipeline();
	    	objApproLimitList.ajax.reload();
	    }
	   	IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
    }else{
    	var $objFrmData = $("#frmSearch").serializeObject();
        
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/rmApproval/approvalLimit/selectApproLimitListExcel.do");
    }
}

function fnRegist(flg,schTxt,schId) {
	
	if(flg == "1")
	{
		/*	사업자 번호
		*/	
		if($("#frmSearch #search").val() == ""){
			IONPay.Msg.fnAlert("ID를 입력해주세요");	
			$("#div_frm .grid.simple").css("display", "none");
			$("#searchCollapse").css("display", "block");
		}else{
			$("#sDiv").html('<label class="form-label" id="searchId" >'+schTxt+'</label><div class="input-with-icon  right"><label class="form-label" id="searchId" style="font-weight:bold; font-size:16px;padding-left: 10px;">'+schId+'</label></div>');
			$("#div_frm .grid.simple").css("display", "block");
			//IONPay.Utils.fnHideSearchOptionArea();
		}
	}	
	else if(flg == "2")
	{
		/*	mid	*/
		if($("#frmSearch #search").val() == ""){
			IONPay.Msg.fnAlert("ID를 입력해주세요");	
			$("#div_frm .grid.simple").css("display", "none");
			$("#searchCollapse").css("display", "block");
		}else{
			$("#sDiv").html('<label class="form-label" id="searchId" >'+schTxt+'</label><div class="input-with-icon  right"><label class="form-label" id="searchId"  style="font-weight:bold; font-size:16px;padding-left: 10px;">'+schId+'</label></div>');
			$("#div_frm .grid.simple").css("display", "block");
			//IONPay.Utils.fnHideSearchOptionArea();
		}
	}
	else if(flg == "3")
	{
		/*	aid*/
		if($("#frmSearch #search").val() == ""){
			IONPay.Msg.fnAlert("ID를 입력해주세요");	
			$("#div_frm .grid.simple").css("display", "none");
			$("#searchCollapse").css("display", "block");
		}else{
			$("#sDiv").html('<label class="form-label" id="searchId" >'+schTxt+'</label><div class="input-with-icon  right"><label class="form-label" id="searchId"  style="font-weight:bold; font-size:16px;padding-left: 10px;">'+schId+'</label></div>');
			$("#div_frm .grid.simple").css("display", "block");
			//IONPay.Utils.fnHideSearchOptionArea();
		}
	}
	else if(flg == "4")
	{
		/*	gid */
		if($("#frmSearch #search").val() == ""){
			IONPay.Msg.fnAlert("ID를 입력해주세요");	
			$("#div_frm .grid.simple").css("display", "none");
			$("#searchCollapse").css("display", "block");
		}else{
			$("#sDiv").html('<label class="form-label" id="searchId" >'+schTxt+'</label><div class="input-with-icon  right"><label class="form-label" id="searchId"  style="font-weight:bold; font-size:16px;padding-left: 10px;">'+schId+'</label></div>');
			$("#div_frm .grid.simple").css("display", "block");
			//IONPay.Utils.fnHideSearchOptionArea();
		}
	}
	else if(flg=="ALL")
	{
		/* 모두 */
		IONPay.Msg.fnAlert("ID를 입력해주세요");	
		$("#div_frm .grid.simple").css("display", "none");
		$("#div_frm grid .grid_simple").css("display", "none");
		$("#searchCollapse").css("display", "block");
	}

}

function chgSelDt(value) {
	if(value == '1') {
		document.getElementById('divDt2').style.display = "none";
	} else {
		document.getElementById('divDt2').style.display = "";
	}
}

function selLimitType(val) {
	var svc_cd = $("#regist #payType").val();
	f.limitType.value = val;
	var limit_type = f.limitType.value;
	f.limitCd.value = '';
	
	document.getElementById('divCard').style.display = "none";
	document.getElementById('divVacct').style.display = "none";
	document.getElementById('divMobile').style.display = "none";
	document.getElementById('divEtc').style.display = "none";
	document.getElementById('divBlank').style.display = "none";
	
	if(limit_type == '0001' || limit_type == '0021') {
		document.getElementById('divCard').style.display = "";
		f.limitCd.value = f.selCard.value;
	} else if(limit_type == '0002') {
		document.getElementById('divVacct').style.display = "";
		f.limitCd.value = f.selVacct.value;
	} else if(limit_type == '0003') {
		document.getElementById('divMobile').style.display = "";
		f.limitCd.value = f.selMobile.value;
	} else if(limit_type == '9999') {
		document.getElementById('divBlank').style.display = "";
		f.limitCd.value = '99';
	} else {
		document.getElementById('divEtc').style.display = "";
		f.limitCd.focus();
		if(limit_type == '0010') {
			f.limitCd.maxLength = '16';
		} else if(limit_type == '0011') {
			f.limitCd.maxLength = '13';
		} else if(limit_type == '0012') {
			f.limitCd.maxLength = '11';
		}
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.APPROVAL_LIMIT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
            <div id="div_frm" class="row" style="display:none;">
                <div class="col-md-12">
                    <div class="grid simple">
                        <div class="grid-title no-border">
                            <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Regist</span></h4>
                            <div class="tools"><a href="javascript:;" class="remove"></a></div>
                        </div>                          
                        <div class="grid-body no-border">
	                         <!-- BEGIN registTab1 AREA -->  
	                         <div id="registTab1" class="tab-pane" >
	                         	<form id="regist">
	                         		<input type='hidden' name='stateCd' value='99'>
	                         		<input type='hidden' id='registType' name='registType' value='0'>
	                         		<input type='hidden' id='seqNo' name='seqNo'>
	                         		
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                    <div class="col-md-4" id="sDiv">
	                                        <label class="form-label" id="searchId" ></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                       </div>
	                                    </div>
	                                    <div class="col-md-8"></div>                                    
	                                </div>
	                                <div class="row form-row" style="padding: 0 0 10px 0;">
	                                	<div class="col-md-4">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0242'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="tranCutFlg" name="tranCutFlg" class="select2 form-control">
	                                            </select>
	                                       </div>
	                                    </div>
	                                    <div class="col-md-4">
	                                       <label class="form-label"><spring:message code='IMS_BIM_BM_0267'/></label>
	                                       <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <input type="text" id="date" name="date" class="form-control">
	                                       </div>
	                                    </div>
	                                    <div class="col-md-4"></div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0241'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="payType" name="payType" class="select2 form-control">
	                                            </select>
	                                       </div>
	                                    </div>                                    
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0266'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="instMon" name="instMon" class="select2 form-control">
	                                            </select>
	                                       </div>
	                                    </div>
	                                    <div class="col-md-4">
	                                    </div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0264'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="limitType" name="limitType" class="select2 form-control">
	                                            	<%-- <option value="0"><spring:message code='IMS_BIM_BM_0081'/></option> --%>
<!-- 	                                            	<option	value="9999">모 두</option> -->
													<option	value="0001">카드사</option>
													<option	value="0021">카드사(카드번호별)</option>
													<option	value="0010">카드번호</option>
	                                            </select>
	                                       </div>
	                                    </div>                                    
	                                    <div class="col-md-4">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0265'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <!-- <input type="text" id="detail" name="detail" class="form-control"  readonly="readonly"> -->
	                                           <select id="detail" name="detail" class="select2 form-control">
	                                            </select>
	                                       </div>
	                                    </div>
	                                    <div class="col-md-4">
	                                    </div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0291'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="cashLimit" name="cashLimit" class="select2 form-control">
	                                            </select>
	                                       </div>
	                                    </div>                                    
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0269'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <input type="text" id="limit" name="limit" class="form-control" style="width: 70%;  float: left;">
	                                            <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0293'/> </p>
	                                       </div>
	                                    </div>
	                                    <div class="col-md-3">
	                                    	<label class="form-label"><spring:message code='IMS_BIM_BM_0294'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="countLimit" name="countLimit" class="select2 form-control">
	                                            </select>
	                                    	</div>
	                                	</div>
	                                	<div class="col-md-3">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0271'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <input type="text" id="count" name="count" class="form-control" style="width: 70%;  float: left;">
	                                            <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0295'/> </p>
	                                       </div>
	                                    </div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0272'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="sendChk" name="sendChk" class="select2 form-control">
	                                            </select>
	                                       </div>
	                                    </div>  
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0255'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <select id="target" name="target" class="select2 form-control">
	                                            </select>
	                                       </div>
	                                    </div>                                  
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0256'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <input type="text" id="pac" name="pac" class="form-control" style="width: 70%;  float: left;">
	                                            <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0297'/> </p>
	                                       </div>
	                                    </div>
	                                    <div class="col-md-3">
	                                    </div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                    <div class="col-md-3">
	                                    	<label class="form-label"><spring:message code='IMS_BIM_BM_0300'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0301'/> </p>
	                                           <input type="text" id="maxCount" name="maxCount" class="form-control" style="width: 50%;  float: left;">
	                                           <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0302'/> </p>
	                                       </div>
	                                        <%-- <label class="form-label"><spring:message code='IMS_BIM_BM_0298'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0299'/> </p>
	                                           <input type="text" id="sendStandard" name="sendStandard" class="form-control" style="width: 50%;  float: left;">
	                                           <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0297'/> </p>
	                                       </div> --%>
	                                    </div>  
	                                    <div class="col-md-6">
	                                        <%-- <label class="form-label"><spring:message code='IMS_BIM_BM_0300'/></label>
	                                        <div class="input-with-icon  right">
	                                           <i class=""></i>
	                                           <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0301'/> </p>
	                                           <input type="text" id="maxCount" name="maxCount" class="form-control" style="width: 50%;  float: left;">
	                                           <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0302'/> </p>
	                                       </div> --%>
	                                    </div>                                  
	                                    <div class="col-md-3">
	                                    </div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                	<div class="col-md-12">
	                                		<label class="form-label"><spring:message code='IMS_BIM_BM_0273'/></label>
	                                		<input type="text" id="sendEmail" name="sendEmail" class="form-control" style="width: 80%;  float: left;">
	                                        <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0303'/> </p>
	                                	</div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                	<div class="col-md-12">
	                                		<label class="form-label"><spring:message code='IMS_BIM_BM_0274'/></label>
	                                		<input type="text" id="sendSms" name="sendSms" class="form-control" style="width: 80%;  float: left;">
	                                        <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0305'/> </p>
	                                	</div>
	                                </div>
	                                <div class="row form-row" style="padding:0 0 10px 0;">
	                                	<div class="col-md-12">
	                                		<label class="form-label"><spring:message code='IMS_BIM_BM_0304'/></label>
	                                		<input type="text" id="regiReason" name="regiReason" class="form-control">
	                                	</div>
	                                </div>
	                         	</form>
                             </div>
	                         <!-- END registTab1 AREA -->
                        </div>
                        <div class="grid-body no-border">
                            <div class="row form-row">
                                <div class="col-md-12">
                                    <p class="pull-right">
                                        <button type="button" id="btnEdit" class="btn btn-danger auth-all">저장</button>
                                        <button type="button" id="btnEditCancel" class="btn btn-default">닫기</button>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0058'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                	<input type='hidden' name='stateCd' value='99'>
                                    <div class="row form-row" >
                                        <div class="col-md-3">
                                            <select id="searchFlg" name="searchFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3"  id="seachDiv">
                                            <input type="text" id="search" name="search" class="form-control" readonly>
                                        </div>
                                        <div id="category" style="display: none;">
                                        <div class="col-md-2"  >
                                            <select id="cate" name="cate" onchange="fnSubCategorySetting(this.value)" class="select2 form-control">
                                            	<%-- <option value="0"><spring:message code='IMS_BIM_BM_0081'/></option> --%>
                                            </select>
                                        </div>  
                                         <div class="col-md-2" >
                                            <select id="subCate" name="subCate" class="select2 form-control">
                                            	<%-- <option value="0"><spring:message code='IMS_BIM_BM_0081'/></option> --%>
                                            </select>
                                        </div>
                                        </div>            
                                    </div>
                                    <div class="row form-row"  style="padding:10px 0 10px 0;">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0242'/></label> 
                                            <select id="tranCutFlg" name="tranCutFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                      	<div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0241'/></label>
                                             <select id="payType" name="payType" class="select2 form-control">
                                            </select>
                                        </div>  
                                        <div class="col-md-2">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0256'/></label> 
                                            <select id="exhRate" name="exhRate" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label> 
                                            <input type="text" id="rate" name="rate" class="form-control" style="width: 50%;  float: left;">
                                            <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0230'/> </p>
                                        </div>    
                                    </div>
		                             <div class="row form-row" >
			                             <div class="col-md-2">
                                            <select id="dateChk" name="dateChk" onchange="chgSelDt(this.value)" class="select2 form-control">
                                            </select>
	                                        </div>
					                       <div class="col-md-2">
				                              <div id="divDt1" class="input-append success date col-md-10 col-lg-10 no-padding">
				                                  <input type="text" id="txtFromDate" name="fromdate" class="form-control">
				                                  <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
				                              </div>
				                          	</div> 
				                          	<div class="col-md-2">
				                              <div id="divDt2" class="input-append success date col-md-10 col-lg-10 no-padding" style="display:none">
				                                  <input type="text" id="txtToDate" name="todate" class="form-control">
				                                  <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
				                              </div>
				                          	</div>
				                          <div class="col-md-3">
				                          </div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
				                                  <button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0062'/></button>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <div id="div_searchResult" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbApproLimitListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                 	 <th >NO</th>
<!--                                                  	 <th >SEQ</th> -->
                                                     <th ><spring:message code='IMS_BIM_BM_0262'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0250'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0263'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0242'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0241'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0264'/></th>            
                                                     <th ><spring:message code='IMS_BIM_BM_0265'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0266'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0267'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0268'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0269'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0270'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0271'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0272'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0255'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0256'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0273'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0274'/></th>
                                                     <th ><spring:message code='IMS_BM_NM_0018'/></th>
                                                     <th ><spring:message code='IMS_BM_IM_0024'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tr style="text-align: center;">
                                            		<td colspan="23"><spring:message code='IMS_BIM_BM_0177'/></td>
                                            	</tr>
                                            </table>
                                            <div class="col-md-9"></div>
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