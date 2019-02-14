<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objDepReportInquiry;
var objReceiveDeferSearch;
var objDifferenceAmtSearch;

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
    	selectDepReport();
    });
    
    $("#btnHold").on("click", function(){
    	if (typeof objReceiveDeferSearch == "undefined") {
	    	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	    	objReceiveDeferSearch = IONPay.Ajax.CreateDataTable("#receiveDeferTable", true, {
	               url: "/calcuMgmt/calcuCard/receiveDeferSearch.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
	                   { "class" : "columnc all",         "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnAddComma(data.RNUM)} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.OVER_FLG_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO}},
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.ACQ_DT)} },
	                   { "class" : "columnc all",         "data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.DPST_DT)} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REASON_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TID} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MEMO} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.AMT} },
	                   {
	                	 "class" : "columnc all",
	                     "render": function ( data, type, row ) {
	                    	 if("00" == row.ST_TYPE && "0" == row.ST_TYPE) {
                					return "<input type='button' name='' value='해 제'  onclick=\"javascript:setLayShow(event.x-250,event.y + document.body.scrollTop, '" + row.SEQ + "');\"  class='btn btn-success btn-cons'>";
	                   		   } else if("00" == row.REASON && "1" == row.REASON) {
	                               	return "해제완료";
	                   		   } else {
	                               	return "&nbsp;";
	                   		   }
	                       },
	                       className: "dt-body-center"
	                   },
	                   {
	                  	 "class" : "columnc all",
	                       "render": function ( data, type, row ) {
	                    	   	return "<input type='button' name='' value='삭 제'  onclick=\"delData('" + row.SEQ + "');\"  class='btn btn-success btn-cons'>";
	                         },
	                         className: "dt-body-center"
	                     }
	               ]
	       }, true);
	    } else {
	    	objReceiveDeferSearch.clearPipeline();
	    	objReceiveDeferSearch.ajax.reload();
	    	$("#modalReceiveDeferSearch").hide();
	    }
    	
		IONPay.Utils.fnShowSearchArea();
    	//IONPay.Utils.fnHideSearchOptionArea();
    	$("#modalReceiveDeferSearch").modal().delay(1000);
	
    });
    
    $("#btnEtc").on("click", function(){
    	if (typeof objDifferenceAmtSearch == "undefined") {
	    	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	    	objDifferenceAmtSearch = IONPay.Ajax.CreateDataTable("#differenceAmtTable", true, {
	               url: "/calcuMgmt/calcuCard/differenceAmtSearch.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
	                   { "class" : "columnc all",         "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnAddComma(data.RNUM)} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_NM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO}},
	                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.ACQ_DT)} },
	                   { "class" : "columnc all",         "data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.DPST_DT)} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MEMO} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.AMT} },
	                   {
	                  	 "class" : "columnc all",
	                       "render": function ( data, type, row ) {
	                    	   	return "<input type='button' name='' value='삭 제'  onclick=\"delData('" + row.SEQ + "');\"  class='btn btn-success btn-cons'>";
	                         },
	                         className: "dt-body-center"
	                     }
	               ]
	       }, true);
	    	
	    } else {
	    	objDifferenceAmtSearch.clearPipeline();
	    	objDifferenceAmtSearch.ajax.reload();
	    	$("#modalDifferenceAmtSearch").hide();
	    }
	
		IONPay.Utils.fnShowSearchArea();
    	//IONPay.Utils.fnHideSearchOptionArea();
    	$("#modalDifferenceAmtSearch").modal();
    });
}

function delData(seq) {
    var f = document.mainForm;

    if(confirm('삭제 후 복구가 불가능합니다.\n진짜 삭제하겠습니까?')) {
    	arrParameter["seq"] = seq;
        strCallUrl   = "/calcuMgmt/calcuCard/differenceAmtDel.do";
        strCallBack  = "fnDelDataRet";
        
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    }
}

function fnDelDataRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("삭제 되었습니다.");
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnSetDDLB() {
	$("select[name=MER_TYPE]").html("<c:out value='${MER_TYPE}' escapeXml='false' />");
	$("select[name=inOutChk]").html("<c:out value='${inOutChk}' escapeXml='false' />");
	$("select[name=CardCompanyList]").html("<c:out value='${CardCompanyList}' escapeXml='false' />");
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

function selectDepReport(){
   	if (typeof objDepReportInquiry == "undefined") {
   		objDepReportInquiry = IONPay.Ajax.CreateDataTable("#tbDepReportListSearch", true, {
               url: "/calcuMgmt/calcuCard/selectDepReport.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnAddComma(data.RNUM)} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.ACQ_DT)} },
                   { "class" : "columnc all",         "data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.DPST_DT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.FN_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TR_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ORG_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACQ_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RE_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RTN_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ETC_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.DPST_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RESR_AMT} },
                   //{ "class" : "columnc all", 			"data" : null, "render":function(data){return data.EXP_AMT} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.GAP_AMT} },
                   {
                	 "class" : "columnc all",
                     "render": function ( data, type, row ) {
                           if ( type === 'display' ) {
                               return '<input type="checkbox" id="chkBox' + row.RNUM + '" name="chkBox' + row.RNUM + '" class="editor-active">';
                           }
                           return data;
                       },
                       className: "dt-body-center"
                   }
               ]
       }, true);
    } else {
       objDepReportInquiry.clearPipeline();
       objDepReportInquiry.ajax.reload();
    }

	IONPay.Utils.fnShowSearchArea();
    //IONPay.Utils.fnHideSearchOptionArea();
}

function fnInquiry() {
    
    $("#div_searchResult").serializeObject();
    $("#div_searchResult").show(200);    
    $("#div_searchSumResult").hide();
    //IONPay.Utils.fnHideSearchOptionArea();
    
    arrParameter = $("#frmSearch").serializeObject();
	//arrParameter["MID"] = $("#MID").val()+"m";
	//arrParameter["SMS_PUSH_FLG"] = smsPush;
	strCallUrl   = "/calcuMgmt/calcuCard/selectDepReport.do";
	strCallBack  = "fnUpdateRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CREDIT_CARD_DEPORIT_MANAGEMENT }'/></a> </li>
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
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0058'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <div class="row form-row"   >
		                                <div class="col-md-3" >
		                                	<div class="checkbox check-success"  >
		                                        <input type="checkbox"  id="phaDt" name="phaDt"  checked="checked">
		                                        <label for="phaDt" class="form-label"><spring:message code='IMS_BIM_BM_0306'/></label>
		                                        <div class="input-append success date col-md-10 col-lg-10 no-padding">
		                                            <input type="text" id="txtFromDate" name="fromdate" class="form-control">
		                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
		                                        </div>                                      
	                                        </div> 
	                                    </div>
	                                    <div class="col-md-3" style="padding-top:5px; ">
	                                       <label class="form-label">&nbsp;</label>
	                                       <div class="input-append success date col-md-10 col-lg-10 no-padding">
	                                           <input type="text" id="txtToDate" name="todate" class="form-control">
	                                           <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
	                                       </div>
	                                    </div> 
	                                    <div id="divSearchDateType4" class="col-md-4" style="padding-top:5px; ">
	                                        <label class="form-label">&nbsp;</label>
	                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>                                       
	                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
	                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
	                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
	                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
	                                    </div>
	                            	</div>
		                            <div class="row form-row"  style="padding:0 0 10px 0;">
			                                <div class="col-md-3" >
			                                	<div class="checkbox check-success"  >
			                                        <input type="checkbox" id="depDt"  name="depDt">
			                                        <label for="depDt" class="form-label"><spring:message code='IMS_BIM_BM_0307'/></label>
			                                        <div class="input-append success date col-md-10 col-lg-10 no-padding">
			                                            <input type="text" id="txtFromDate1" name="fromdate" class="form-control">
			                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
			                                        </div>                                      
		                                        </div> 
		                                    </div>
		                                    <div class="col-md-3" style="padding-top:5px; ">
		                                       <label class="form-label">&nbsp;</label>
		                                       <div class="input-append success date col-md-10 col-lg-10 no-padding">
		                                           <input type="text" id="txtToDate1" name="todate" class="form-control">
		                                           <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
		                                       </div>
		                                    </div> 
		                                    <div id="divSearchDateType7" class="col-md-4" style="padding-top:5px; ">
		                                        <label class="form-label">&nbsp;</label>
		                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>                                       
		                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
		                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
		                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
		                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
		                                    </div>
		                            	</div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;">
                                        <div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0308'/></label>	
                                            <select id="MER_TYPE" name="MER_TYPE" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0309'/></label>	
                                            <select id="inOutChk" name="inOutChk" class="select2 form-control">
                                            </select>
                                        </div>             
                                    </div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0178'/></label> 
                                            <select id="CardCompanyList" name="CardCompanyList" class="select2 form-control">
                                            </select>
                                        </div>
                                      	<div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0179'/></label>
                                             <input type="text" id="merNo" name="merNo" class="form-control">
                                        </div>  
                                        <div class="col-md-3"></div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
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
                                        	<div class="col-md-10" ><spring:message code='IMS_BIM_BM_0318'/></div>
                                        	<div class="col-md-2" >
                                        		<button type="button" id="btnHold" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0319'/></button>
                                        		<button type="button" id="btnEtc" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0320'/></button>
                                        	</div>
                                            <table id="tbDepReportListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                 	 <th >NO</th>
                                                     <th ><spring:message code='IMS_BIM_BM_0306'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0307'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0178'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0160'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0310'/></th>            
                                                     <th ><spring:message code='IMS_BIM_BM_0311'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0093'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0312'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0313'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0314'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0315'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0316'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0317'/></th>
                                                     <th ><input type="checkbox"  id="chkBox" name="chkBox" ></th>
                                                 </tr>
                                            	</thead>
                                            	<tr style="text-align: center;">
                                            		<td colspan="16"><spring:message code='IMS_BIM_BM_0177'/></td>
                                            	</tr>
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
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    	<!-- END CONTAINER -->

    	<!-- BEGIN MODAL -->
		<div class="modal fade" id="modalReceiveDeferSearch"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold">입금보류/해제내역조회</h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="receiveDeferTable" style="width:100%; border:1px solid #ddd;">
                                <thead>
									<tr>
										<th>NO</th>
										<th><spring:message code='IMS_BIM_BM_0309' /></th>
										<th><spring:message code='IMS_BIM_BM_0178' /></th>
										<th><spring:message code='IMS_BIM_BM_0179' /></th>
										<th><spring:message code='IMS_BIM_BM_0306' /></th>
										<th><spring:message code='IMS_BIM_BM_0307' /></th>
										<th><spring:message code='IMS_BIM_BM_0101' /></th>
										<th><spring:message code='IMS_PW_DE_12' /></th>
										<th><spring:message code='IMS_BIM_BM_0321' /></th>
										<th><spring:message code='IMS_BIM_BM_0131' /></th>
										<th><spring:message code='IMS_BIM_BM_0078' /></th>
										<th><spring:message code='IMS_BIM_BM_0322' /></th>
									</tr>
								</thead>
								<tr style="text-align: center;">
									<td colspan="12"><spring:message code='IMS_BIM_BM_0177' /></td>
								</tr>
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
		<div class="modal fade" id="modalDifferenceAmtSearch"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold">차액내역조회</h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="differenceAmtTable" style="width:100%; border:1px solid #ddd;">
								<thead>
                               		<tr>
                                    	<th >NO</th>
                                        <th ><spring:message code='IMS_BIM_BM_0082'/></th>
                                        <th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                        <th ><spring:message code='IMS_BIM_BM_0306'/></th>
                                        <th ><spring:message code='IMS_BIM_BM_0307'/></th>
                                        <th ><spring:message code='IMS_BIM_BM_0321'/></th>
                               			<th ><spring:message code='IMS_BIM_BM_0131'/></th>            
                                        <th ><spring:message code='IMS_BIM_BM_0322'/></th>
                                    </tr>
                               	</thead>
                               	<tr style="text-align: center;">
                               		<td colspan="8"><spring:message code='IMS_BIM_BM_0177'/></td>
                               	</tr>
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