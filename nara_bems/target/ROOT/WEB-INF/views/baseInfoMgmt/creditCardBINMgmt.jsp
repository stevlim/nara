<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objBinInfoInquiry;

$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#cardCd").html("<c:out value='${CardCompanyList}' escapeXml='false' />");	
	$("#cardType").html("<c:out value='${CardType}' escapeXml='false' />");	
	$("#foreignCardType").html("<c:out value='${ForeignCardType}' escapeXml='false' />");	
}

function fnInit(){
	$("#binListSearch").hide();
	if($("#binListSearchCollapse").hasClass("collapse") === true)
    	$("#binListSearchCollapse").click();
}

function fnInitEvent() {	  
	$("#btnSearch").on("click", function(){
		$("#binListSearch").show();
		fnBinInfoSearch();
	});
}
function fnBinInfoSearch(){
   	if (typeof objBinInfoInquiry == "undefined") {
   			   objBinInfoInquiry = IONPay.Ajax.CreateDataTable("#tbBinListSearch", true, {
               url: "/baseInfoMgmt/creditCardBINMgmt/selectBinInfoList.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CARD_BIN} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CARD_CD_NM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CP_CD} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ISS_CP_CD} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CHKCARD_NM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CARD_TYPE_NM} },
                   { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CARD_INFO} }
                   ]
           }, true);
       } else {
    	   objBinInfoInquiry.clearPipeline();
           objBinInfoInquiry.ajax.reload();
       }

       IONPay.Utils.fnShowSearchArea();
       IONPay.Utils.fnHideSearchOptionArea();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CREDIT_CARD_SUPPORT }'/></a> </li>
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
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_BIM_CCS_0001" /></label> 
	                                        <select class="select2 form-control" id="cardCd" name="cardCd">
	                                        </select>
	                                    </div>                
	                                    <div class="col-md-3">
	                                        <div class="input-with-icon  right">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_CCS_0002" /></label> 
	                                            <input type="text" id="cardBin" name="cardBin" class="form-control">
	                                        </div>
	                                    </div>                                      
	                                    <div class="col-md-3">
                                        </div>    
                            		</div>         
                            		<div class = "row form-row" style = "padding:0 0 5px 0;">
	                                    <div class="col-md-3">
                                        	<label class="form-label"><spring:message code="IMS_BIM_CCS_0003" /></label> 
	                                        <select class="select2 form-control" id="cardType" name="cardType">
	                                        </select>
	                                    </div>                
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_BIM_CCS_0004" /></label> 
	                                        <select class="select2 form-control" id="foreignCardType" name="foreignCardType">
	                                        </select>
	                                    </div>                                      
	                                    <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch"  class="btn btn-primary btn-cons"><spring:message code="IMS_TV_TH_0053" /></button>                                   
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
	                <div class = "row" id = "binListSearch">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="IMS_TV_TH_0063" /></h4>
                                <div class="tools"><a href="javascript:;" id="binListSearchCollapse" class="collapse"></a></div>
                            </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbBinListSearch" width="100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_BIM_CCS_0006" /></th>
	                                     <th><spring:message code="IMS_BIM_CCS_0002" /></th>
	                                     <th><spring:message code="IMS_BIM_CCS_0007"/></th>
	                                     <th><spring:message code="IMS_BIM_CCS_0001" /></th>
	                                     <th><spring:message code="IMS_BIM_CCS_0008" /></th>
	                                     <th><spring:message code="IMS_BIM_CCS_0003" /></th>
	                                     <th><spring:message code="IMS_BIM_CCS_0009" /></th>
	                                     <th><spring:message code="IMS_BIM_CCS_0010" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END LIST Search VIEW AREA -->  
           </div>
           <!-- END PAGE --> 
        </div>
        <!-- END CONTAINER -->
    <!-- Modal Menu Insert Area -->