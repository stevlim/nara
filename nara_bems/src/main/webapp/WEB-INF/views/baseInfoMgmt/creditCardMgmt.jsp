<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objCardInfoList;
var objSettingList;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strType;

$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#frmRegist #CardCompanyList").html("<c:out value='${CardCompanyList1}' escapeXml='false' />");
	$("#frmRegist #MerTypeChk").html("<c:out value='${MerType1}' escapeXml='false' />");
	$("#frmRegist #CardCertList").html("<c:out value='${CardCertList1}' escapeXml='false' />");
	$("#frmRegist  #DepositCycle").html("<c:out value='${DepositCycle1}' escapeXml='false' />");
	$("#frmRegist  #PointType").html("<c:out value='${PointType1}' escapeXml='false' />");
	$("#frmRegist  #LimitChk").html("<c:out value='${LimitChk1}' escapeXml='false' />");
	$("#CardCompanyList1").html("<c:out value='${CardCompanyList}' escapeXml='false' />");
	$("#MerTypeChk1").html("<c:out value='${MerType}' escapeXml='false' />");
	$("#CardCertList1").html("<c:out value='${CardCertList}' escapeXml='false' />");
	$("#DepositCycle1").html("<c:out value='${DepositCycle}' escapeXml='false' />");
	$("#PointType1").html("<c:out value='${PointType}' escapeXml='false' />");
	$("#LimitChk1").html("<c:out value='${LimitChk}' escapeXml='false' />");
	$("select[name=MER_TYPE]").html("<c:out value='${MER_TYPE}' escapeXml='false' />");
	//$("select[name=MER_TYPE]").html("<c:out value='${MER_TYPE1}' escapeXml='false' />");
	$("select[name=KeyInList]").html("<c:out value='${KeyInList}' escapeXml='false' />");
}

function fnInit(){
	$("#ListSearch").hide();
	if($("#listSearchCollapse").hasClass("collapse") === true)
    	$("#listSearchCollapse").click();
	$("#SettingListSearch").hide();
	if($("#settingListSearchCollapse").hasClass("collapse") === true)
    	$("#settingListSearchCollapse").click();
}

function fnInitEvent() {	    
    $("#btnSearch").on("click", function(){
	    //IONPay.Utils.fnHideSearchOptionArea();
    	$("#ListSearch").show();
    	if($("#listSearchCollapse").hasClass("collapse") === false)
	    	$("#listSearchCollapse").click();
    	$("#SettingListSearch").hide();
    	if($("#settingListSearchCollapse").hasClass("collapse") === true)
        	$("#settingListSearchCollapse").click();
    	strType = "SEARCH";
    	$("#div_frm").hide();
    	fnCardInfoList(strType);
    });
    
    $("#btnExcel").on("click", function() {
    	strType="EXCEL";
    	fnCardInfoList(strType);
    });
    $("#btnRegist").on("click", function() {
    	
  	    //IONPay.Utils.fnHideSearchOptionArea();
      	$("#ListSearch").hide();
      	$("#SettingListSearch").hide();
      	$("#div_frm").show();
      	$("#registTab1").serializeObject();
		//IONPay.Utils.fnHideSearchOptionArea();
    });  
}
function fnCardRegist(){
	arrParameter = $("#frmRegist").serializeObject();
	arrParameter["WORKER"] = strWorker;
	strCallUrl   = "/baseInfoMgmt/subMallMgmt/insertCreditCardInfo.do";
	strCallBack  = "fnCardRegistRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnCardRegistRet(objJson){
	if (objJson.resultCode == 0) {
		IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
//         IONPay.Utils.fnJumpToPageTop();
        fnCardInfoList("SEARCH");
	}else if(objJson.resultCode == -999){
    	fnSettingList(objJson);
		$("#ListSearch").hide();
		if($("#listSearchCollapse").hasClass("collapse") === true)
	    	$("#listSearchCollapse").click();
		$("#SettingListSearch").show();
    	if($("#settingListSearchCollapse").hasClass("collapse") === false)
        	$("#settingListSearchCollapse").click();
	}
	else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnCardDelete(mbsNo, cardCd){
	var mNo = mbsNo.toString();
	var cCd = cardCd.toString();
	var z = '0';
	
	/* var diff = 15 - mNo.length;
	for(var i=0; i<diff; i++){
		mNo = z+mNo; 
	}
	*/
	var diff = 2 - cCd.length;
	for(var i=0; i<diff; i++){
		cCd = z+cCd; 
	} 
	
// 	arrParameter["mbsNo"] = mNo;
	arrParameter["mbsNo"] = mNo.toString();
	arrParameter["cardCd"] = cCd;
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/baseInfoMgmt/subMallMgmt/cardDelete.do";
	strCallBack  = "fnCardDeleteRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnCardDeleteRet(objJson){
	if (objJson.resultCode == 0) {
		IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
        IONPay.Utils.fnJumpToPageTop();
        fnCardInfoList("SEARCH");
	}else if(objJson.resultCode == -999){
    	fnSettingList(objJson);
		$("#ListSearch").hide();
		if($("#listSearchCollapse").hasClass("collapse") === true)
	    	$("#listSearchCollapse").click();
		$("#SettingListSearch").show();
    	if($("#settingListSearchCollapse").hasClass("collapse") === false)
        	$("#settingListSearchCollapse").click();
	}
	else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnCardInfoList(strType){
	if(strType == "SEARCH"){
		if (typeof objCardRegist == "undefined") {
			objCardRegist = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
	            url: "/baseInfoMgmt/subMallMgmt/selectCreditCardList.do",
	            data: function() {
	                return $("#frmSearch").serializeObject();
	            },
	            columns: [
	                { "class" : "columnc all",         "data" : null, "render": function(data){return data.NO} },
	                { "class" : "columnc all",         "data" : null, "render": function(data){return gMessage(data.MBS_TYPE_NM)} },
	                { "class" : "columnc all",         "data" : null, "render":function(data){return gMessage(data.CARD_NM)} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return gMessage(data.NOINT_NM)} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MEMO}},
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return "D+" + data.DPST_CYCLE} },
	                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.POINT_FLG==null?"":gMessage(data.POINT_NM)} },
	                { "class" : "columnc all", 			"data" : null, "render": function(data){return data.CP_FEE}},
	                { "class" : "columnc all", 			"data" : null, "render": function(data){return data.AUTH_TYPE_NM}}, 
	                { "class" : "columnc all", 			"data" : null, "render": function(data){return gMessage(data.LIMIT_DIV_NM)}}, 
	                { "class" : "columnc all", 			"data" : null, "render": function(data){return data.MB_LMT}},
	                { "class" : "columnc all", 			"data" : null, "render": function(data){return "<button type='button' class='btn btn-primary btn-cons' value='삭제' onclick='fnCardDelete("+ data.MBS_NO.toString()+","+ data.CARD_CD.toString()+");'><spring:message code='IMS_BIM_BM_0322' /></button>"}}
	                ]
	        }, true);
	    } else {
	    	objCardRegist.clearPipeline();
	    	objCardRegist.ajax.reload();
	    }

	    IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
		        
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/baseInfoMgmt/subMallMgmt/selectCreditCardListExcel.do");
	}
}
function fnSettingList(data){
		if (typeof objSettingList == "undefined") {
			objSettingList = IONPay.Ajax.CreateDataTable("#tbSettingListSearch", true, {
	            url: "/baseInfoMgmt/subMallMgmt/selectCardSetData.do",
	            data: function(){
	            	return data;	
	            },
	            columns: [
	                { "class" : "columnc all",         "data" : null, "render": function(data){return data.NO} },
	                { "class" : "columnc all",         "data" : null, "render": function(data){return gMessage(data.DATA_CL_NM)} },
	                { "class" : "columnc all",         "data" : null, "render":function(data){return data.DATA_CL=="0"?data.MID:(data.DATA_CL=="1"?data.ACQU_DT:data.TERM_NO)} },
	                ]
	        }, true);
	    } else {
	    	objSettingList.clearPipeline();
	    	objSettingList.ajax.reload();
	    }

	    IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.AFFILIATE_MANAGEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0100" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                 <!-- BEGIN PAGE FORM -->
	            <div id="div_frm" class="row" style="display:none;">
	                <div class="col-md-12">
	                    <div class="grid simple">
	                        <div class="grid-title no-border">
	                            <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title"><spring:message code="IMS_BIM_BM_0385" /></span></h4>
	                            <div class="tools"><a href="javascript:;" class="remove"></a></div>
	                        </div>                          
	                        <div class="grid-body no-border">
		                         <!-- BEGIN registTab1 AREA -->  
		                         <div id="registTab1" class="tab-pane" >
		                         	<form id="frmRegist" name="frmRegist">
		                                <div class="row form-row" style="padding: 0 0 10px 0;">
		                                	<div class="col-md-12" >
		                                		<spring:message code = 'IMS_BIM_BM_0386'/>
		                                	</div>
	                                        <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="DDLB_0140" />/<spring:message code="DDLB_0141" /></label> 
		                                        <select class="select2 form-control" id="MER_TYPE" name="MER_TYPE">
		                                        </select>
		                                    </div> 
		                                    <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0372" /></label> 
		                                        <select class="select2 form-control" id="MerTypeChk" name="MerTypeChk">
		                                        </select>
		                               		 </div>
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0;">
		                                	<div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_CCS_0001" /></label> 
		                                        <select class="select2 form-control" id="CardCompanyList" name="CardCompanyList">
		                                        </select>
		                                    </div> 
	                                         <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label> 
		                                        <input type="text" class="form-control"  id="merNo" name="merNo">
		                                    </div>
		                                    <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0374" /></label> 
		                                        <select class="select2 form-control" id="DepositCycle" name="DepositCycle">
		                                        </select>
		                                    </div>
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0; ">
		                                	<div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0331" /></label> 
		                                        <input type="text" class="form-control"  id="fee" name="fee"  placeholder="0.0" style="text-align: right;">
		                                    </div> 
	                                         <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0387" /></label> 
		                                        <input type="text" class="form-control"  id="chkFee" name="chkFee"  placeholder="0.0"   style="text-align: right;">
		                                    </div> 
		                                    <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0388" /></label> 
		                                        <input type="text" class="form-control"  id="abroadFee" name="abroadFee" placeholder="0.0"  style="text-align: right;">
		                                    </div> 
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0; ">
                               		 		 <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0373" /></label> 
		                                        <select class="select2 form-control" id="PointType" name="PointType">
		                                        </select>
		                                    </div>
		                                    <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0389" /></label> 
		                                        <input type="text" class="form-control"  id="pointFee" name="pointFee" placeholder="0.0"  style="text-align: right;">
		                                    </div> 
		                                    <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0163" /></label> 
		                                        <select class="select2 form-control" id="CardType" name="CardType">
		                                        	<option value='1' selected="true"><spring:message code="DDLB_0142" /></option>
                            						<option value='2'><spring:message code="DDLB_0159" /></option>
                            						<option value='3'><spring:message code="DDLB_0160" /></option>
		                                        </select>
		                                    </div>
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0; ">
                               		 		<div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0388" /></label> 
		                                        <input type="text" class="form-control"  id="toDt" name="toDt" >
		                                    </div> 
		                                    <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0390" /></label>
		                                        <div class="radio radio-success"  style="padding-top: 8px;">
		                                        <input type="radio" id="chk1"  name="chk1" checked="checked">
		                                        <label class="form-label" for="chk1" ><spring:message code='IMS_BIM_BM_0083'/></label>
		                                        <input type="radio" id="chk2"  name="chk1">
		                                        <label class="form-label" for="chk2"><spring:message code='IMS_BIM_BM_0179'/></label>
		                                        </div> 
		                                    </div>
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0; ">
                               		 		<div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0375" /></label> 
		                                        <select class="select2 form-control" id="LimitChk" name="LimitChk">
		                                        </select>
		                                    </div> 
		                                    <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0377" /></label> 
		                                        <input type="text" class="form-control"  id="approLimit" name="approLimit"  placeholder="0"  style="text-align: right;">
		                                    </div> 
		                                    <div class="col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0391" /></label> 
		                                        <input type="text" class="form-control"  id="" name=""  placeholder="0"  style="text-align: right; width: 45%; float: right;">
		                                        <span style="float: right; padding: 10px 10px 0 10px;;">/</span>
		                                        <input type="text" class="form-control"  id="" name=""  placeholder="0"  style="text-align: right; width: 45%;float: right;">
		                                    </div> 
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0; ">
                               		 		<div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BIR_0242" /></label> 
		                                        <select class="select2 form-control" id="CardCertList" name="CardCertList">
		                                        </select>
		                                    </div>
		                                    <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0392" /></label> 
		                                        <select class="select2 form-control" id="KeyInList" name="KeyInList">
		                                        </select>
		                                    </div>
                               		 	</div>
		                         		<div class="row form-row" style="padding: 0 0 10px 0; ">
		                                    <div class="col-md-12">
		                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0381" /></label> 
		                                        <input type="text" class="form-control"  id="memo" name="memo"  >
		                                    </div>
	                                    </div> 
		                         	</form>
	                             </div>
		                         <!-- END registTab1 AREA -->
	                        </div>
	                        <div class="grid-body no-border">
	                            <div class="row form-row">
	                                <div class="col-md-12" align="center" >
                                        <button type="button" id="btnEdit" class="btn btn-danger auth-all"  onclick="fnCardRegist();"><spring:message code="IMS_BIM_BM_0138" /></button>
	                                </div>
	                            </div>
	                        </div>                          
	                    </div>
	                </div>
	            </div>           
	            <!-- END PAGE FORM -->
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
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="DDLB_0141" />/<spring:message code="DDLB_0140" /></label> 
	                                        <select class="select2 form-control" id="MER_TYPE" name="MER_TYPE">
	                                        </select>
	                                    </div>               
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_BIM_CCS_0001" /></label> 
	                                        <select class="select2 form-control" id="CardCompanyList1" name="CardCompanyList">
	                                        </select>
	                                    </div> 
	                                    <div class="col-md-6">
                                        </div>    
                            		</div>         
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
	                                    <div class="col-md-3">
                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0372" /></label> 
	                                        <select class="select2 form-control" id="MerTypeChk1" name="MerTypeChk">
	                                        </select>
	                                    </div>                
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label> 
	                                        <input type="text" class="form-control"  id="merNo" name="merNo">
	                                    </div>
	                                    <div class="col-md-3">
                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0373" /></label> 
	                                        <select class="select2 form-control" id="PointType1" name="PointType">
	                                        </select>
	                                    </div>                                      
                            		</div>
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
	                                    <div class="col-md-3">
                                        	<label class="form-label"><spring:message code="IMS_BIM_BIR_0242" /></label> 
	                                        <select class="select2 form-control" id="CardCertList1" name="CardCertList">
	                                        </select>
	                                    </div>                
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_BIM_BM_0374" /></label> 
	                                        <select class="select2 form-control" id="DepositCycle1" name="DepositCycle">
	                                        </select>
	                                    </div>
	                                    <div class="col-md-3">
                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0375" /></label> 
	                                        <select class="select2 form-control" id="LimitChk1" name="LimitChk">
	                                        </select>
	                                    </div>                                      
                            		</div>
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">      
										<div class="col-md-9"></div>
	                                    <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_TV_TH_0053" /></button>
                                                <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
                                                <button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code="IMS_BIM_BM_0380" /></button>                                   
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
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_TV_TH_0063" /></h4>
                                <div class="tools"><a href="javascript:;" id="listSearchCollapse" class="collapse"></a></div>
                            </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbListSearch" style="width:100%">
	                                <thead>
	                                 <tr>
	                                     <th>No</th>
	                                     <th><spring:message code="IMS_BIM_BM_0325" />/<spring:message code="IMS_BIM_BM_0326" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0178"/></th>
	                                     <th><spring:message code="IMS_BIM_BM_0179" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0101" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0381" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0374" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0382" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0331" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0383" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0375" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0365" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0384" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END LIST Search VIEW AREA -->  
               <!-- START SETTING LIST Search VIEW AREA -->
	                <div class = "row" id = "SettingListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_TV_TH_0063" /></h4>
                                <div class="tools"><a href="javascript:;" id="settingListSearchCollapse" class="collapse"></a></div>
                            </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbSettingListSearch" style="width:100%">
	                                <thead>
	                                 <tr>
	                                     <th>No</th>
	                                     <th><spring:message code="IMS_BIM_BM_0101"/></th>
	                                     <th><spring:message code="IMS_BIM_BM_0463"/></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END SETTING LIST Search VIEW AREA -->  
           </div>
           <!-- END PAGE --> 
        </div>
        <!-- END CONTAINER -->
    <!-- Modal Menu Insert Area -->