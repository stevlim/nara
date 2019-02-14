<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objExRateInfoInquiry;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#CURRENCY_SEARCH").html("<c:out value='${CURRENCY_SEARCH}' escapeXml='false' />");
	$("#currencyType").html("<c:out value='${CURRENCY_SEARCH1}' escapeXml='false' />");
}

function fnInit(){
	if($("#SearchCollapse").hasClass("collapse") === true)
    	$("#SearchCollapse").click();
	$("#Search").hide();
	if($("#registCollapse").hasClass("collapse") === true)
    	$("#registCollapse").click();
	$("#Regist").hide();
}

function fnInitEvent() {	    
    $("#btnSearch").on("click", function(){
    	if($("#SearchCollapse").hasClass("collapse") === false)
        	$("#SearchCollapse").click();
    	if($("#registCollapse").hasClass("collapse") === true)
	    	$("#registCollapse").click();
    	$("#Regist").hide();
    	/* if($("#registCollapse").hasClass("collapse") === true)
        	$("#registCollapse").click();
    	$("#Regist").hide();
	    IONPay.Utils.fnHideSearchOptionArea();
    	$("#Search").show();
    	if($("#SearchCollapse").hasClass("collapse") === false)
	    	$("#SearchCollapse").click(); */
    	fnSelectExRateInfoList();
    	$("#Search").show();
    });
    
    $("#btnRegist").on("click", function(){
	    $("#baseDt").html($("#frmSearch #txtToDate").val());
    	if($("#SearchCollapse").hasClass("collapse") === true)
        	$("#SearchCollapse").click();
    	$("#Search").hide();
	    IONPay.Utils.fnHideSearchOptionArea();
    	$("#Regist").show();
    	if($("#registCollapse").hasClass("collapse") === false)
	    	$("#registCollapse").click();
    });
}
//환율  REGIST
function fnExRateRegist(){
	arrParameter = $("#frmExRateRegist").serializeObject();
	arrParameter["baseDt"] = $("#txtToDate").val();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/baseInfoMgmt/exchangeRateMgmt/insertExRateInfo.do";
	strCallBack  = "fnRegistRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnRegistRet(objJson){
	if (objJson.resultCode == 0) {
        IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
        IONPay.Utils.fnJumpToPageTop();
    } else {
    	IONPay.Msg.fnAlert(objJson.resultMessage);	
    }
}
//환율 inquiry 
function fnSelectExRateInfoList(){
	if (typeof objExRateInfoInquiry == "undefined") {
        objExRateInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbExRateSearch", true, {
            url: "/baseInfoMgmt/exchangeRateMgmt/selectExRateInfo.do",
            data: function() {	
                return $("#frmSearch").serializeObject();
            },
            columns: [
                { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.BASE_DT)} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CURRENCY_TYPE} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.BUY_CASH_AMT}},
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.SALE_CASH_AMT} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REMIT_SEND_AMT} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.REMIT_RECV_AMT} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.BASE_AMT} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.USE_EXCH_RATE} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER==null?strWorker:data.WORKER} }
                ]
        }, true);
    } else {
        objExRateInfoInquiry .clearPipeline();
        objExRateInfoInquiry .ajax.reload();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.EXCHANGE_RATE_MANAGEMENT }'/></a> </li>
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
                            		<div class = "col-md-12">                  
		                                <div class="row form-row" style="padding:5px 0 5px 0;">
			                                <div class="col-md-3">
							                   <label class="form-label"><spring:message code="IMS_BIM_ER_0003"/></label>
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
			                                <div id="divSearchDateType4" class="col-md-6">
		                                    	<label class="form-label">&nbsp;</label>    
			                                    <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0054" /></button>                                       
			                                    <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0055" /></button> 
			                                    <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code="IMS_TV_TH_0056" /></button>                        
			                                    <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code="IMS_BIM_BM_0011" /></button>                                      
			                                    <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code="IMS_BIM_BM_0012" /></button>  
			                                </div>
		                                </div>
	                            		<div class = "row form-row" style = "padding:0 0 5px 0;" >
	                            			<div class = "col-md-3">
		                                        <label class="form-label"><spring:message code="IMS_BIM_ER_0001" /></label> 
	                            				<select id = "CURRENCY_SEARCH" name = "CURRENCY_SEARCH" class = "select2 form-control">
	                            				</select>
	                            			</div>
		                                    <div class="col-md-6">
		                                    </div>                
		                                    <div class="col-md-3">
			                                    <div class="col-md-1">                         
				                                    <label class="form-label">&nbsp;</label>    
		                                    		<button type="button" id="btnSearch" class="btn btn-primary btn-cons" style=""><spring:message code="IMS_TV_TH_0053" /></button>   
			                                    </div>  
			                                    <div class="col-md-1"></div>
			                                    <div class="col-md-1">                         
				                                    <label class="form-label">&nbsp;</label>    
		                                    		<button type="button" id="btnRegist"   class="btn btn-primary btn-cons" style=""><spring:message code="IMS_SM_SRM_0053" /></button>   
			                                    </div>  
		                                    </div>         
	                            		</div>         
	                                </div>
                            	</form>
                            </div>
                		</div>
                	</div>
                </div>
                <!-- END VIEW OPTION AREA -->
                <!-- BEGIN Search VIEW AREA -->
	                <div class = "row" id = "Search">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal red">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_MENU_0015" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="SearchCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                            <table class="table" id="tbExRateSearch" width="100%">
	                                <thead>
	                                 <tr>
	                                     <th><spring:message code="IMS_BIM_ER_0003" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0004" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0005" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0006" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0007" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0008" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0009" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0010" /></th>
	                                     <th><spring:message code="IMS_BIM_ER_0011" /></th>
	                                 </tr>
	                                </thead>
	                            </table>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END Search VIEW AREA -->  
                <!-- BEGIN Regist VIEW AREA -->
	                <div class = "row" id = "Regist">
	                	<div class = "col-md-12">
	                      <div class="grid simple horizontal yellow">
	                        <div class="grid-title">
	                          <h4><span class="semi-bold"><spring:message code="IMS_MENU_0015" /></span></h4>
	                          <div class="tools"> <a href="javascript:;" id="registCollapse" class="collapse"></a></div>
	                        </div>
	                        <div class="grid-body">
	                          <div class="row">
	                          	<form id="frmExRateRegist" name="frmExRateRegist">
		                            <table class="table" id="tbRegist" width="100%">
		                                <thead>
		                                 <tr>
		                                     <th><spring:message code="IMS_BIM_ER_0003" /></th>
		                                     <th><spring:message code="IMS_BIM_ER_0004" /></th>
		                                     <th><spring:message code="IMS_BIM_ER_0005" /></th>
		                                     <th><spring:message code="IMS_BIM_ER_0006" /></th>
		                                     <th><spring:message code="IMS_BIM_ER_0007" /></th>
		                                     <th><spring:message code="IMS_BIM_ER_0008" /></th>
		                                     <th><spring:message code="IMS_BIM_ER_0009" /></th>
		                                     <th><spring:message code="IMS_BIM_ER_0010" /></th>
		                                     <th><spring:message code="IMS_DM_CPR_0020" /></th>
		                                 </tr>
		                                </thead>
		                                <tbody>
		                                	<tr>
		                                		<td id="baseDt" style="text-align:center; border:1px solid #c2c2c2;">
	                                         		<!-- <input type="text" name="baseDt" class="form-control" style="text-align:right;"> -->
	                                         	</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
		                            				<select class = "select2 form-control" name="currencyType" id="currencyType">
		                            				</select>
	                            				</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
	                                         		<input type="text" name="buyAmt" class="form-control" style="text-align:right;">
	                                         	</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
	                                         		<input type="text" name="saleAmt" class="form-control" style="text-align:right;">
	                                         	</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
	                                         		<input type="text" name="sendAmt" class="form-control" style="text-align:right;">
	                                         	</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
	                                         		<input type="text" name="recvAmt" class="form-control" style="text-align:right;">
	                                         	</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
	                                         		<input type="text" name="baseAmt" class="form-control" style="text-align:right;">
	                                         	</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
	                                         		<input type="text" name="usdExchRate" class="form-control" style="text-align:right;">
	                                         	</td>
												<td style="text-align:center; border:1px solid #c2c2c2;">
			                                     	<button type='button' onclick="fnExRateRegist();" class='btn btn-info btn-xs btn-mini btn-cons' style='border:1px solid #c2c2c2; cursor:default; margin:0px;background-color:white; color:#666'>
			                                     		<span class="glyphicon glyphicon-stop" style="color:orange;" aria-hidden="true"></span>
			                                     		<spring:message code="IMS_DM_CPR_0020"/>
			                                     	</button>
	                                         	</td>
		                                	</tr>
		                                </tbody>
		                            </table>
	                            </form>
	                          </div>
	                        </div>
	                	</div>
	                </div>
	           </div> 
               <!-- END Regist VIEW AREA -->  
           </div>
           <!-- END PAGE --> 
        </div>
        <!-- END CONTAINER -->
    <!-- Modal Menu Insert Area -->