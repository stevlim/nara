<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objMerFeeInquiry;

$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#PAY_CD").html("<c:out value='${PaymentMethod_SEARCH}' escapeXml='false' />");	
}

function fnInit(){
	$("#ListSearch").hide();
	if($("#listSearchCollapse").hasClass("collapse") === true)
    	$("#listSearchCollapse").click();
}

function fnInitEvent() {	    
    $("#btnSearch").on("click", function(){
    	if($("#MID").val() == '' ){
    		IONPay.Msg.fnAlert("MID CHECK");
   		}else{
    	fnMerFeeInquiry();
    	IONPay.Utils.fnHideSearchOptionArea();
    	$("#ListSearch").show();
    	if($("#listSearchCollapse").hasClass("collapse") === false)
	    	$("#listSearchCollapse").click(); 
   		}
	    
    });
}
function fnMerFeeInquiry(){
	if (typeof objMerFeeInquiry == "undefined") {
		objMerFeeInquiry = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
            url: "/baseInfoMgmt/merchantFeeInquiry/selectMerFeeList.do",
            data: function() {
                return $("#frmSearch").serializeObject();
            },
            columns: [
                { "class" : "columnc all",         "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnStringToDateFormat(data.REG_DT)} },
                { "class" : "columnc all",         "data" : null, "render": function(data){return data.CO_NO} },
                { "class" : "columnc all",         "data" : null, "render":function(data){return data.CO_NM} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MID} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SVC_NM}},
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.BEFORE_AVG_FEE} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.AFTER_AVG_FEE} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.FR_DT)} },
                { "class" : "columnc all", 			"data" : null, "render": function(data){return data.STATUS_NM}}
                ]
        }, true);
    } else {
    	objMerFeeInquiry.clearPipeline();
    	objMerFeeInquiry.ajax.reload();
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
	                                    <div class="col-md-3">
	                                        <div class="input-with-icon  right">
	                                        <label class="form-label"><spring:message code="DDLB_0137" /></label> 
	                                            <input type="text" id="MID" name="MID" class="form-control">
	                                        </div>
	                                    </div>                
	                                    <div class="col-md-3">
	                                        <label class="form-label"><spring:message code="IMS_DM_DM_0003" /></label> 
	                                        <select id="PAY_CD" name="PAY_CD" class="select2 form-control">
	                                        </select>
	                                    </div>                                      
	                                    <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code="IMS_TV_TH_0053" /></button>                                   
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
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0056" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="listSearchCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbListSearch" style="width:100%;">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_BIM_MFI_0001" /></th>
	                                     <th><spring:message code="IMS_BIM_MM_0054" /></th>
	                                     <th><spring:message code="IMS_BIM_MM_0051"/></th>
	                                     <th><spring:message code="DDLB_0137" /></th>
	                                     <th><spring:message code="IMS_DM_DM_0003" /></th>
	                                     <th><spring:message code="IMS_BIM_MFI_0002" /></th>
	                                     <th><spring:message code="IMS_BIM_MFI_0003" /></th>
	                                     <th><spring:message code="IMS_BIM_MFI_0004" /></th>
	                                     <th><spring:message code="IMS_BIM_MFI_0005" /></th>
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