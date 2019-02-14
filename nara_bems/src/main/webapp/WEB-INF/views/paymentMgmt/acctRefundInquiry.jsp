<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

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
    	}
    	else {    		
    		$("#search").attr("readonly", false);
    	}
    });
    $("select[name=optionChk]").on("change", function(){
    	if ($.trim(this.value) == "") {
    		$("#option").val("");
    		$("#option").attr("readonly", true);
    	}
    	else {    		
    		$("#option").attr("readonly", false);
    	}
    });
    $("#btnSearch").on("click", function() {
    	fnInquiry();
    });
    $("#btnExcel").on("click", function() {
    	IONPay.Msg.fnAlert("fail");
    });
    $("#btnSumSearch").on("click", function() {
    	var fromDt = $("#txtFromDate").val();
    	var toDt = $("#txtToDate").val();
    	var date = $("#txtToDate").val() +"~"+ $("#txtFromDate").val();
    	$("#date").html(date);
    	fnSumInquiry();
    });  
}

function fnSetDDLB() {
    $("#frmSearch #escrow").html("<c:out value='${Escrow}' escapeXml='false' />");
    $("#frmSearch #searchFlg").html("<c:out value='${MER_SEARCH}' escapeXml='false' />");
    $("#frmSearch #optionChk").html("<c:out value='${Option_Chk}' escapeXml='false' />");
    $("#frmSearch #dateChk").html("<c:out value='${DateChk}' escapeXml='false' />");
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

function fnInquiry() {
    
    $("#div_searchResult").serializeObject();
    $("#div_searchResult").show(200);    
    $("#div_searchSumResult").hide();
    //IONPay.Utils.fnHideSearchOptionArea();
}

function fnSumInquiry() {
    
    $("#div_searchSumResult").serializeObject();
    $("#div_searchSumResult").show(200);
    $("#div_searchResult").hide();
    //IONPay.Utils.fnHideSearchOptionArea();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.BANK_TRANSFER }'/></a> </li>
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
                                    <div class="row form-row" >
                                        <div class="col-md-3">
                                            <select id="searchFlg" name="searchFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" id="search" name="search" class="form-control" readonly>
                                        </div>             
                                    </div>
                                    <div class="row form-row" >
                                        <div class="col-md-3">
                                        	<label class="form-label">&nbsp;</label>
                                            <select id="optionChk" name="optionChk" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                        	<label class="form-label">&nbsp;</label>
                                            <input type="text" id="option" name="option" class="form-control" readonly>
                                        </div>             
                                        <div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0147'/></label>
                                            <select id="escrow" name="escrow" class="select2 form-control">
                                            </select>
                                        </div> 
                                    </div>
		                             <div class="row form-row" >
				                          <div class="col-md-2">
				                          		<label class="form-label">&nbsp;</label>
				                           		<select id="dateChk" name="dateChk" class="select2 form-control">
				                                  </select>
				                          </div>
				                       <div class="col-md-2">
				                              <label class="form-label">&nbsp;</label> 
				                              <div class="input-append success date col-md-10 col-lg-10 no-padding">
				                                  <input type="text" id="txtFromDate" name="fromdate" class="form-control">
				                                  <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
				                              </div>                                      
				                          </div>
				                          <div class="col-md-2">
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
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
				                                  <button type="button" id="btnSumSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0151'/></button>
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
                                            <table id="" class="table" style="width:50%;">
                                                <thead>
                                                 <tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0187'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0188'/></th>
                                                 </tr>
                                                </thead>
                                                <tr style="text-align: right;">
                                                	<td>0</td>
                                                	<td>0</td>
                                                </tr>
                                            </table>
                                            <table id="" class="table"  style="width:100%">
                                            	<thead>
                                            		<tr> 
	                                                 	 <th rowspan="2"  id="th_verticleLine" class="th_verticleLine">No</th>
	                                                     <th rowspan="2"  class="th_verticleLine"><spring:message code='IMS_BIM_BM_0189'/></th>
	                                                     <th rowspan="2"  class="th_verticleLine"><spring:message code='IMS_BIM_BM_0180'/></th>
	                                                     <th rowspan="2"  class="th_verticleLine"><spring:message code='IMS_BIM_BM_0186'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_PW_DE_01'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_PW_DE_03'/></th>
				                                         <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_PW_DE_12'/></th>           
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0160'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0190'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0147'/></th>
	                                                   	 <th colspan="3" ><spring:message code='IMS_BIM_BM_0191'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0078'/></th>
	                                                     <th rowspan="2" class="th_verticleLine"><spring:message code='IMS_BIM_BM_0192'/></th>
	                                                     <th colspan="3"><spring:message code='IMS_BIM_BM_0193'/></th>
                                                 	</tr>
                                                 	<tr >
	                                                   	 <th><spring:message code='IMS_BIM_BIM_0027'/></th>
	                                                   	 <th><spring:message code='IMS_BIM_BM_0181'/></th>
	                                                   	 <th><spring:message code='IMS_BIM_MM_0075'/></th>
	                                                     <th><spring:message code='IMS_BIM_BIM_0027'/></th>
	                                                   	 <th><spring:message code='IMS_BIM_BM_0181'/></th>
	                                                   	 <th><spring:message code='IMS_BIM_MM_0075'/></th>
                                                 	</tr>
                                            	</thead>
                                            	<tr style="text-align: center;">
                                            		<td colspan="18"><spring:message code='IMS_BIM_BM_0177'/></td>
                                            	</tr>
                                            </table>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>  
                                </div>
                                <div id="div_searchSumResult" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="" class="table" style="width:100%">
                                                <thead>
                                                 <tr>
                                                     <th><spring:message code='IMS_BIM_BM_0187'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0188'/></th>
                                                 </tr>
                                                </thead>
                                                <tr style="text-align: right;">
                                                	<td>0</td>
                                                	<td>0</td>
                                                </tr>
                                            </table>
                                            <table id="" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
	                                                 <th><spring:message code='IMS_BIM_BM_0189'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0194'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tr  style="text-align: center;">
                                            		<td colspan="14" ><spring:message code='IMS_BIM_BM_0177'/></td>
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
