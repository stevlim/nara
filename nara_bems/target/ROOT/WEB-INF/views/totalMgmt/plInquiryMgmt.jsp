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
   
    $("#btnSearch").on("click", function() {
    	fnInquiry();
    });
}

function fnSetDDLB() {
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
    IONPay.Utils.fnHideSearchOptionArea();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.PROFIT_AND_LOSS }'/></a> </li>
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
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0180'/></label> 
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
		                            </div>
		                            <div class="row form-row"  style="padding:0 0 10px 0;">
			                                <div class="col-md-3" >
			                                	<div class="checkbox check-success"  >
			                                        <input type="checkbox" id="depDt"  name="depDt" checked="checked">
			                                        <label for="depDt" class="form-label"><spring:message code='IMS_BIM_BM_0329'/></label>
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
		                                    <div id="divSearchDateType7" class="col-md-3" style="padding-top:5px; ">
		                                        <label class="form-label">&nbsp;</label>
		                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>                                       
		                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
		                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
		                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
		                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
		                                    </div>
				                          <div class="col-md-3" style="padding-top:5px; ">
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
                                            <table id="" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0176'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0280'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0281'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0282'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0283'/></th>            
                                                 </tr>
                                            	</thead>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0160'/></td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0330'/></td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0331'/></td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0332'/></td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            		<td>0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0333'/></td>
                                            		<td colspan="5">0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0334'/></td>
                                            		<td colspan="5">0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0335'/></td>
                                            		<td colspan="5">0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0336'/></td>
                                            		<td colspan="5">0</td>
                                            	</tr>
                                            	<tr style="text-align: right;">
                                            		<td style="text-align: center;"><spring:message code='IMS_BIM_BM_0337'/></td>
                                            		<td colspan="5">0</td>
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
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
