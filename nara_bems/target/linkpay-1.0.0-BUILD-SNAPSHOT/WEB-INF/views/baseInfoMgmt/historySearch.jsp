<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objBaseInfoInquiry;
var objFeeInquiry;
var objSettleCycleInquiry;
var objCoInquiry;
var objAffInquiry;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#MER_SEARCH").html("<c:out value='${MER_SEARCH}' escapeXml='false' />");
	$("#HISTORY_TYPE").html("<c:out value='${HISTORY_TYPE}' escapeXml='false' />");	
}

function fnInit(){
	$("#BaseInfoListSearch").hide();
	$("#FeeInfoListSearch").hide();
	$("#SettleCycleInfoListSearch").hide();
	$("#CoInfoListSearch").hide();
	$("#AffInfoListSearch").hide();
}

function fnInitEvent() {	    
    $("#btnSearch").on("click", function(){
	    ////IONPay.Utils.fnHideSearchOptionArea();
    	if($("#HISTORY_TYPE option:selected").val() == "1"){
    		//기본정보	
    		if($("#SEARCH_TEXT").val() == ""){
    			IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + "을 입력하시오");
    			return;
    		}else{
    		$("#BaseInfoListSearch").show();
    		$("#FeeInfoListSearch").hide();
    		$("#SettleCycleInfoListSearch").hide();
    		$("#CoInfoListSearch").hide();
    		$("#AffInfoListSearch").hide();
    		
    		fnSelectBaseInfoList();
    		}
    		
    	}else if($("#HISTORY_TYPE option:selected").val() == "2"){
    		//기본정보	
    		if($("#SEARCH_TEXT").val() == ""){
    			IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + "을 입력하시오");
    			return;
    		}else{
    		//수수료정보
    		$("#BaseInfoListSearch").hide();
    		$("#FeeInfoListSearch").show();
    		$("#SettleCycleInfoListSearch").hide();
    		$("#CoInfoListSearch").hide();
    		$("#AffInfoListSearch").hide();
    		fnSelectFeeInfoList();
    		}
    	}else if($("#HISTORY_TYPE option:selected").val() == "3"){
    		//정산주기
    		if($("#SEARCH_TEXT").val() == ""){
    			IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + "을 입력하시오");
    			return;
    		}else{
    		$("#BaseInfoListSearch").hide();
    		$("#FeeInfoListSearch").hide();
    		$("#SettleCycleInfoListSearch").show();
    		$("#CoInfoListSearch").hide();
    		$("#AffInfoListSearch").hide();
    		fnSelectSettleCycleInfoList();
    		}
    	}else if($("#HISTORY_TYPE option:selected").val() == "4"){
    		//사업자입금
    		if($("#SEARCH_TEXT").val() == ""){
    			IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + "울 입력하시오");
    			return;
    		}else{
    		$("#BaseInfoListSearch").hide();
    		$("#FeeInfoListSearch").hide();
    		$("#SettleCycleInfoListSearch").hide();
    		$("#CoInfoListSearch").show();
    		$("#AffInfoListSearch").hide();
    		fnSelectCoInfoList();
    		}
    	}else if($("#HISTORY_TYPE option:selected").val() == "5"){
    		//제휴사연동정보
    		if($("#SEARCH_TEXT").val() == ""){
    			IONPay.Msg.fnAlert($("#MER_SEARCH option:selected").text() + "울 입력하시오");
    			return;
    		}else{
    		$("#BaseInfoListSearch").hide();
    		$("#FeeInfoListSearch").hide();
    		$("#SettleCycleInfoListSearch").hide();
    		$("#CoInfoListSearch").hide();
    		$("#AffInfoListSearch").show();
    		fnSelectAffInfoList();
    		}
    	}
    });
}
   function fnSelectBaseInfoList(){
   	if (typeof objBaseInfoInquiry == "undefined") {
           objBaseInfoInquiry = IONPay.Ajax.CreateDataTable("#tbBaseInfoListSearch", true, {
               url: "/baseInfoMgmt/historySearch/selectBaseInfoList.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data,type, full, meta){return IONPay.Utils.fnStringToDateFormat(data.REG_DNT)} },
                   { "class" : "columnc all",         "data" : null, "render":function(data,type, full, meta){return (data.ID_CD=="1"? "사업자번호": (data.ID_CD=="2" ? "MID" : (data.ID_CD=="3"?"GID":"VID")))} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.COL_V} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.COL_BEFORE}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.COL_AFTER} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER==null ? strWorker : data.WORKER} },
                   ],
               "paging": true,
               "bPaginate":true
           }, true);
       } else {
           objBaseInfoInquiry.clearPipeline();
           objBaseInfoInquiry.ajax.reload();
       }

       IONPay.Utils.fnShowSearchArea();
       //IONPay.Utils.fnHideSearchOptionArea();
   }
   
   function fnSelectFeeInfoList(){
   	if (typeof objFeeInquiry == "undefined") {
   		objFeeInquiry = IONPay.Ajax.CreateDataTable("#tbFeeInfoListSearch", true, {
               url: "/baseInfoMgmt/historySearch/selectFeeInfo.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.REG_DNT)} },
                   { "class" : "columnc all",         "data" : null, "render":function(data){return data.CP_CD} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SPM_CD} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ID_CD}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MIN_FEE} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FEE_TYPE_CD} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FEE} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FR_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TO_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FR_DT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TO_DT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER==null ? strWorker : data.WORKER} },
                   ]
           }, true);
       } else {
       	objFeeInquiry.clearPipeline();
       	objFeeInquiry.ajax.reload();
       }

       IONPay.Utils.fnShowSearchArea();
       //IONPay.Utils.fnHideSearchOptionArea();
   }
   function fnSelectSettleCycleInfoList(){
   	if (typeof objSettleCycleInquiry == "undefined") {
   		objSettleCycleInquiry  = IONPay.Ajax.CreateDataTable("#tbSettleCycleInfoListSearch", true, {
               url: "/baseInfoMgmt/historySearch/selectSettleCycleInfo.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.UPD_DNT==null?data.REG_DNT:data.UPD_DNT)} },
                   { "class" : "columnc all",         "data" : null, "render":function(data){return data.PM_CD} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SPM_CD} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STMT_NM}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STMT_CYCLE_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FR_DT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TO_DT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER==null ? strWorker : data.WORKER} },
                   ]
           }, true);
       } else {
       	objSettleCycleInquiry .clearPipeline();
       	objSettleCycleInquiry .ajax.reload();
       }

       IONPay.Utils.fnShowSearchArea();
       //IONPay.Utils.fnHideSearchOptionArea();
   }
   function fnSelectCoInfoList(){
   	if (typeof objCoInquiry == "undefined") {
   		objCoInquiry  = IONPay.Ajax.CreateDataTable("#tbCoInfoListSearch", true, {
               url: "/baseInfoMgmt/historySearch/selectCoInfo.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.UPD_DNT==null?data.REG_DNT:data.UPD_DNT)} },
                   { "class" : "columnc all",         "data" : null, "render":function(data){return data.PAY_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.EXP_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REQ_AMT}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.PAY_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.PAY_ST_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.DEL_FLG} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FR_DT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TO_DT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER==null ? strWorker : data.WORKER} },
                   ]
           }, true);
       } else {
       	objCoInquiry .clearPipeline();
       	objCoInquiry .ajax.reload();
       }

       IONPay.Utils.fnShowSearchArea();
       //IONPay.Utils.fnHideSearchOptionArea();
   }
   function fnSelectAffInfoList(){
	   	if (typeof objAffInquiry == "undefined") {
	   		objAffInquiry  = IONPay.Ajax.CreateDataTable("#tbAffInfoListSearch", true, {
	               url: "/baseInfoMgmt/historySearch/selectAffInfo.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
						{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
						{ "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.UPD_DNT==null?data.REG_DNT:data.UPD_DNT)} },
						{ "class" : "columnc all",         "data" : null, "render":function(data){return data.PM_CD} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.SPM_CD} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.CP_NM}},
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.FT_DT} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.TO_DT} },
						{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER==null ? strWorker : data.WORKER} },
	                   ]
	           }, true);
	       } else {
	       	objAffInquiry .clearPipeline();
	       	objAffInquiry .ajax.reload();
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
		                                        <label class="form-label"><spring:message code="IMS_BIM_MM_0006" /></label> 
		                                        <select id="HISTORY_TYPE" name="HISTORY_TYPE" class="select2 form-control">
		                                        </select>
		                                    </div>                
		                                    <div class="col-md-3">
		                                        <div class="input-with-icon  right">
		                                       		<label class="form-label">&nbsp;</label>
		                                            <input type="text" id="SEARCH_TEXT" name="SEARCH_TEXT" class="form-control">
		                                        </div>
		                                    </div>         
	                            		</div>                           
		                                <div class="row form-row" style="padding:5px 0 5px 0;">
			                                <div class="col-md-3">
							                   <label class="form-label"><spring:message code="IMS_BIM_MM_0100"/></label>
			                                    <div class="input-append success date col-md-10 col-lg-10 no-padding">
			                                        <input type="text" id="txtFromDate" name="txtFromDate" class="form-control">
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
			                                <div id="divSearchDateType4" class="col-md-3">
		                                    	<label class="form-label">&nbsp;</label>    
			                                    <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0054" /></button>                                       
			                                    <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0055" /></button> 
			                                    <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0056" /></button>                        
			                                    <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code="IMS_BIM_BM_0011" /></button>                                      
			                                    <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code="IMS_BIM_BM_0012" /></button>  
			                                </div>
			                                <div class="col-md-2"></div>
		                                    <div class="col-md-1">        
		                                    	<label class="form-label">&nbsp;</label>
	                                    		<button type="button" id="btnSearch" class="btn btn-primary btn-cons" style=""><spring:message code="IMS_TV_TH_0053" /></button>                            
		                                    </div>
		                                </div>
                            	</form>
                            </div>
                		</div>
                	</div>
                </div>
                <!-- END VIEW OPTION AREA -->
                <!-- BEGIN BASE_INFO LIST Search VIEW AREA -->
	                <div class = "row" id = "BaseInfoListSearch">
	                	<div class = "col-md-12">
	                		<div class="grid simple">
		                      <div class="grid simple">
	                            <div class="grid-title no-border">
	                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
	                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
	                            </div>
	                            <div class="grid-body no-border">
	                                <div id="div_searchResult" style="display:none;">
	                                	<div class="grid simple" >
					                        <div class="grid-body" id="div_baseInfo">
					                            <table class="table" id="tbBaseInfoListSearch" style="width:100%">
					                                <thead>
					                                 <tr>
					                                     <th><spring:message code="IMS_DASHBOARD_0029" /></th>
					                                     <th><spring:message code="IMS_BIM_HS_0001" /></th>
					                                     <th><spring:message code="IMS_BIM_HS_0002"/></th>
					                                     <th><spring:message code="IMS_BIM_HS_0003" /></th>
					                                     <th><spring:message code="IMS_BIM_HS_0004" /></th>
					                                     <th><spring:message code="IMS_BIM_HS_0005" /></th>
					                                     <th><spring:message code="IMS_BIM_HS_0006" /></th>
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
               <!-- END BASE_INFO LIST Search VIEW AREA -->  
               <!-- BEGIN FEE_INFO LIST Search VIEW AREA -->
	                <div class = "row" id = "FeeInfoListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0057" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="listFeeInfoCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbFeeInfoListSearch" style="width:100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_DASHBOARD_0029" /></th>
	                                     <th><spring:message code="IMS_BIM_HS_0001" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0245"/></th>
	                                     <th><spring:message code="IMS_BIM_BM_0443" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0444" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0445" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0446" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0310" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0447" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0448" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0400" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0268" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0123" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END FEE INFO LIST Search VIEW AREA -->  
               <!-- BEGIN SETTLE_CYCLE_INFO LIST Search VIEW AREA -->
	                <div class = "row" id = "SettleCycleInfoListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0057" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="listSettleCycleInfoCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbSettleCycleInfoListSearch" style="width:100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_DASHBOARD_0029" /></th>
	                                     <th><spring:message code="IMS_BIM_HS_0001" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0245"/></th>
	                                     <th><spring:message code="IMS_BIM_BM_0443" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0449" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0450" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0400" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0268" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0123" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END SETTLE_CYCLE_INFO INFO LIST Search VIEW AREA -->  
               <!-- BEGIN CO_INFO LIST Search VIEW AREA -->
	                <div class = "row" id = "CoInfoListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0057" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="listCoInfoCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbCoInfoListSearch" style="width:100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_DASHBOARD_0029" /></th>
	                                     <th><spring:message code="IMS_BIM_HS_0001" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0451"/></th>
	                                     <th><spring:message code="IMS_BIM_BM_0452" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0453" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0454" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0078" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0455" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0400" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0268" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0123" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END CO_INFO LIST Search VIEW AREA -->  
               <!-- BEGIN AFFILIATES_INFO LIST Search VIEW AREA -->
	                <div class = "row" id = "AffInfoListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0057" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="listAffInfoCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbAffInfoListSearch" style="width:100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_DASHBOARD_0029" /></th>
	                                     <th><spring:message code="IMS_BIM_HS_0001" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0245"/></th>
	                                     <th><spring:message code="IMS_BIM_BM_0443" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0444" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0456" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0400" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0268" /></th>
	                                     <th><spring:message code="IMS_BIM_BM_0123" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END AFFILIATES_INFO LIST Search VIEW AREA -->
           </div>
           <!-- END PAGE --> 
        </div>
        <!-- END CONTAINER -->
    <!-- Modal Menu Insert Area -->