<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strType;
$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
    $("#btnSearch").on("click", function() {
    	var fromDt = $("#txtFromDate").val();
    	var toDt = $("#txtToDate").val();
    	var date = $("#txtToDate").val() +"~"+ $("#txtFromDate").val();
    	$("#date").html(date);
    	strType ="SEARCH";
    	fnInquiry(strType);
    });
    $("#btnExcel").on("click", function() {
    	strType ="EXCEL";
    	fnInquiry(strType);
    });
    $("#cardFlg").on("click", function() {
		document.getElementsByName("cardFlg");
	});
}

function fnSetDDLB() {
	$("#frmSearch #cardFlg").html("<c:out value='${CARD_SEARCH}' escapeXml='false' />");
}


function fnInquiry() {
	if(strType == "SEARCH"){
		if (typeof objCheckCardEvent == "undefined") {
			objCheckCardEvent  = IONPay.Ajax.CreateDataTable("#tbCheckCardEventList", true, {
	        url: "/paymentMgmt/card/selectCheckCardEventList.do",
	        data: function() {	
	            return $("#frmSearch").serializeObject();
	        },
	        columns: [
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CP_NM==null?"":data.CP_NM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MBS_NO==null?"":data.MBS_NO} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.NON_INTEREST_NM==null?"":data.NON_INTEREST_NM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APPCNT==null?"":data.APPCNT} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APPAMT==null?"":data.APPAMT} }
	            ]
		    }, true);
		
		} else {
			objCheckCardEvent.clearPipeline();
			objCheckCardEvent.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();
		IONPay.Utils.fnHideSearchOptionArea();
			
		}
		else{
			var $objFrmData = $("#frmSearch").serializeObject();
	        
	        arrParameter = $objFrmData;
	        arrParameter["EXCEL_TYPE"]                  = strType;
	        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
	        IONPay.Ajax.fnRequestExcel(arrParameter, "/paymentMgmt/card/selectCheckCardEventListExcel.do");
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CREDIT_CARD }'/></a> </li>
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
                                         	<label class="form-label"><spring:message code='IMS_BIM_BM_0178'/></label>
                                            <select id="cardFlg" name="cardFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0179'/></label>
                                            <input type="text" id="merNo" name="merNo" class="form-control">
                                        </div>             
                                    </div>
		                           <div class="row form-row" >
				                       <div class="col-md-2">
				                          	<label class="form-label"><spring:message code='IMS_BIM_BM_0180'/></label>
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
				                          <div id="divSearchDateType4" class="col-md-4">
				                              <label class="form-label">&nbsp;</label>
				                              <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>                                       
				                              <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
				                              <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
				                              <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
				                              <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
				                          </div>
				                          <div class="col-md-4">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
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
                                            <table id="tbCheckCardEventList" class="table" style="width:100%;">
                                                <thead>
                                                 <tr>
                                                     <th>NO</th>
                                                     <th><spring:message code='IMS_BIM_BM_0178'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0179'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0152'/></th>
			                                         <th><spring:message code='IMS_BIM_BM_0153'/></th> 
                                                 </tr>
                                                </thead>
                                                <tr>
                                                	<td colspan="6" style="text-align: center;"><spring:message code='IMS_BIM_BM_0177'/></td>
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