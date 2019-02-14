<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objListInquriy;
var objResultListInquriy;
$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
    $("#btnSearchInfo").on("click", function() {
    	if($("#division").val() != "ALL" && $("#id").val().length < 10){
    		IONPay.Msg.fnAlert('10자의 처리 ID를 입력하세요');
    		$("#id").focus();
    		return;
    	}
    	$("#div_search").show(200);
    });

}
function fnSetDDLB(){
	$("select[name=overCl]").html("<c:out value='${OVER_CL}' escapeXml='false' />");
	$("select[name=status]").html("<c:out value='${STATUS}' escapeXml='false' />");
	$("select[name=cardCd]").html("<c:out value='${CARD_LIST}' escapeXml='false' />");
}
function fnInquiryInfo(strType){
	if(strType == "SEARCH"){
		$("#div_searchInfo").css("display", "block");
		$("#div_searchResultR").css("display", "block");
		$("#div_searchResultInfo").css("display", "none");
		fnAcqTidRsltInfo();
		fnAcqTidRsltList("SEARCH");
	}else{
		fnAcqTidRsltList("EXCEL");
	}
	
}
function fnInquiryResult(strType){
	if(strType == "SEARCH"){
		$("#div_searchInfo").css("display", "none");
		$("#div_searchResultR").css("display", "none");
		$("#div_searchResultInfo").css("display", "block");
		fnAcqRsltList("SEARCH");
	}else{
		fnAcqRsltList("EXCEL");
	}
	
}
function fnChkChange(obj){
	var chkProc = document.getElementsByName('chkProc');
    
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
function fnAcqTidRsltInfo(){
	arrParameter = $("#frmSearch").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/purchaseMgmt/selectAcqTidRsltInfo.do";
    strCallBack  = "fnAcqTidRsltInfoRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnAcqTidRsltInfoRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data != null){
			var str = "";
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.APPCNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.APPAMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CCCNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.CCAMT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.TOTCNT+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>"+objJson.data.TOTAMT+"</td>";
			str += "</tr>";
			$("#tbody_info").html(str);
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
function fnAcqTidRsltList(strType){
	if(strType == "SEARCH"){
	   	if (typeof objListInquriy == "undefined") {
	   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbSearchList", true, {
	               url: "/calcuMgmt/purchaseMgmt/selectAcqTidRsltList.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM==null?"":data.RNUM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.OVER_FLG_NM==null?"":data.OVER_FLG_NM} },
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.ACQ_DT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_NM==null?"":data.CARD_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STATE_NM==null?"":data.STATE_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO==null?"":data.MBS_NO} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TID==null?"":data.TID} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.APP_NO==null?"":data.APP_NO} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACQ_AMT==null?"":data.ACQ_AMT} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STATE_NM==null?"":data.STATE_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.QUOTA_MON==null?"":data.QUOTA_MON} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FEE==null?"":data.FEE} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.POINT_FEE==null?"":data.POINT_FEE} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.DPST_AMT==null?"":data.DPST_AMT} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.DPST_DT==null?"":data.DPST_DT} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STATUS==null?"":data.STATUS} }
	               ]
	       }, true);
	    } else {
	       objListInquriy.clearPipeline();
	       objListInquriy.ajax.reload();
	    }
	
		IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/purchaseMgmt/selectAcqTidRsltListExcel.do");
	}
}
function fnAcqRsltList(strType){
	if(strType == "SEARCH"){
		if (typeof objResultListInquriy == "undefined") {
			objResultListInquriy = IONPay.Ajax.CreateDataTable("#tbSearchResultList", true, {
	               url: "/calcuMgmt/purchaseMgmt/selectAcqRsltList.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
	  					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM==null?"":data.RNUM} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO==null?"":data.MBS_NO} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RECV_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.RECV_DT)} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_NM==null?"":data.CARD_NM} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.VAN_NM==null?"":data.VAN_NM} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RECV_CNT==null?"":data.RECV_CNT} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RECV_AMT==null?"": IONPay.Utils.fnAddComma(data.RECV_AMT)} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RET_CNT==null?"":data.RET_CNT} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RET_AMT==null?"": IONPay.Utils.fnAddComma(data.RET_AMT)} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_CNT==null?"":data.RESR_CNT} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_AMT==null?"": IONPay.Utils.fnAddComma(data.RESR_AMT)} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STMT_CNT==null?"":data.STMT_CNT} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STMT_AMT==null?"": IONPay.Utils.fnAddComma(data.STMT_AMT)} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACQ_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.ACQ_DT)} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FEE==null?"":data.FEE} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.DPST_AMT==null?"": IONPay.Utils.fnAddComma(data.DPST_AMT)} },
						   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.DPST_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.DPST_DT)} }

				  ]
	       }, true);
	    } else {
	    	objResultListInquriy.clearPipeline();
	    	objResultListInquriy.ajax.reload();
	    }
	
		IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/purchaseMgmt/selectAcqRsltListExcel.do");
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.PURCHASE_MANAGEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0117'/></span></h3>
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
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0565'/></label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding" >
                                                <input type="text" id=txtFromDate name="txtFromDate" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="txtToDate" name="txtToDate" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
	                                    <div class="col-md-6"></div>
                                    </div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;" >
                                    	<div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label>
                                        	<input type="text" id=mbsNo name="mbsNo" maxlength='20'  class="form-control">
	                                   	</div>
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0078" /></label>
                                        	<select id="status" name="status"  class="select2 form-control">
                                       		</select>
	                                   	</div>
	                                    <div class="col-md-6" ></div>
                                    </div>
                                     <div class="row form-row"  style="padding:0 0 10px 0;" >
                                    	<div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0178" /></label>
                                        	<select id="cardCd" name="cardCd"  class="select2 form-control">
                                       		</select>
	                                   	</div>
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0309" /></label>
                                        	<select id="overCl" name="overCl"  class="select2 form-control">
                                       		</select>
	                                   	</div>
	                                   	<div class="col-md-3" style="margin-top: -1.2%;">	
                                  			<div >
				                                  <button type="button" onclick="fnInquiryInfo('SEARCH');" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0604'/></button>
				                                  <button type="button" onclick="fnInquiryResult('SEARCH');" id="btnSearchResult" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0605'/></button>
                                  			</div>
				                              <div>
				                                  <button type="button" onclick="fnInquiryInfo('EXCEL');" id="btnExcel" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0606'/></button>
				                                  <button type="button" onclick="fnInquiryResult('EXCEL');" id="btnExcelResult" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0607'/></button>
				                              </div>
			                            </div>
	                                    <div class="col-md-3" ></div>
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
                                <div id="div_searchInfo"  style="display: none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbSearchInfo" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
	                                                    <th colspan='2'><spring:message code='IMS_BIM_BM_0511'/></th>
	                                                    <th colspan='2'><spring:message code='IMS_BIM_BM_0517'/></th>
	                                                    <th colspan='2'><spring:message code='IMS_BIM_BM_0608'/></th>
                                                 	</tr>
                                                 	<tr>
	                                                    <th ><spring:message code='IMS_TV_TH_0008'/></th>
	                                                    <th ><spring:message code='IMS_TV_TH_0009'/></th>
	                                                    <th ><spring:message code='IMS_TV_TH_0008'/></th>
	                                                    <th ><spring:message code='IMS_TV_TH_0009'/></th>
	                                                    <th ><spring:message code='IMS_TV_TH_0007'/></th>
	                                                    <th ><spring:message code='IMS_TV_TH_0007'/></th>
                                                 	</tr>
                                            	</thead>
                                            	<tbody id="tbody_info"></tbody>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                                <div id="div_searchResultR" style="display: none;" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbSearchList" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0309'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0306'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0178'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0163'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                                     <th ><spring:message code='IMS_PW_DE_12'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0164'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0160'/></th>
                                                     <th ><spring:message code='IMS_TV_TH_0020'/></th>
                                                     <th ><spring:message code='IMS_TV_TH_0016'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0310'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0681'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0557'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0609'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0590'/></th>
                                                    </tr>
                                            	</thead>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                                <div id="div_searchResultInfo" style="display: none;" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbSearchResultList" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                                     <th ><spring:message code='IMS_BM_CM_0055'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0178'/></th>
                                                     <th ><spring:message code='IMS_BIM_BIM_0011'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0610'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0611'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0612'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0613'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0614'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0692'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0693'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0615'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0601'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0310'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0557'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0307'/></th>
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
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    	<!-- END CONTAINER -->
