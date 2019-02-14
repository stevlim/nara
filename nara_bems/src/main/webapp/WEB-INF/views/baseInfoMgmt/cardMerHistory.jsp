<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objSelectHistoryList;
var objSelectCardList;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
	   	 if($("#merNo").val() == ""){
	   		IONPay.Msg.fnAlert("가맹점 번호를 입력해 주세요.");
	   	 }else{
	   		fnSelectCardInfo();
	   		fnInquiry();
	   	 }
    });
    
    $("#btnExcel").on("click", function() {
    	IONPay.Msg.fnAlert("fail");
    });
}

function fnSetDDLB() {
    $("#CardType").html("<c:out value='${CardType}' escapeXml='false' />");
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
function fnSelectCardInfo(){
	arrParameter["MBS_NO"] = $("#MBS_NO").val();
    strCallUrl   = "/baseInfoMgmt/subMallMgmt/selectCardInfo.do";
    strCallBack  = "fnSelectCardInfoRet";
    
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectCardInfoRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#tbHistoryList #mbsNm").html(objJson.data[0]==null?"":gMessage(objJson.data[0].MBS_TYPE));
		$("#tbHistoryList #cardNm").html(objJson.data[0]==null?"":gMessage(objJson.data[0].CARD_NM));
		$("#tbHistoryList #mbsNo").html(objJson.data[0]==null?"":objJson.data[0].MBS_NO);
		$("#tbHistoryList #nointNm").html(objJson.data[0]==null?"":gMessage(objJson.data[0].NOINT_NM));
		$("#tbHistoryList #pointNm").html(objJson.data[0]==null?"":gMessage(objJson.data[0].POINT_NM)); 
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#tbHistoryList").hide();
	}
}
function fnInquiry() {
    if (typeof objSelectHistoryList == "undefined") {
    		objSelectHistoryList = IONPay.Ajax.CreateDataTable("#tbHistoryInfo", true, {
            url: "/baseInfoMgmt/subMallMgmt/selectCardHistory.do",
            data: function() {	
                return $("#frmSearch").serializeObject();
            },
            columns: [
                { "class" : "columnc all",         "data" : null, "render": function(data){return data.RNUM} },
                { "class" : "columnc all",         "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnStringToDateFormat(data.FR_DT)} },
                { "class" : "columnc all",         "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnStringToDateFormat(data.TO_DT)} },
                { "class" : "columnc all",         "data" : null, "render":function(data){return "D+"+data.DPST_CYCLE} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MB_LMT} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CP_FEE + "%"} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CHK_FEE + "%"}},
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.OVER_FEE + "%"} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MEMO} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.REG_DT)} },
                { "class" : "columnc all", 			"data" : null, "render":function(data){return data.WORKER == null ? strWorker : data.WORKER} }
                ]
        },true);
    } else {
    	objSelectHistoryList.clearPipeline();
    	objSelectHistoryList.ajax.reload();
    }
    
    IONPay.Utils.fnShowSearchArea();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.AFFILIATE_MANAGEMENT }'/></a> </li>
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
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label>
	                                            <input type="text" id="MBS_NO" name="MBS_NO" class="form-control" >
	                                        </div> 
				                          <div class="col-md-6">
				                          </div>
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
                                        <div class="grid-body">
                                        	<div class="row">
                                        	<table id="tbHistoryList" class="table" style="width:100%">
                                            	<tbody >
	                                           		<tr>
	                                                    <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0325'/>/<spring:message code='IMS_BIM_BM_0326'/></th>
	                                                    <td style="border:1px solid #c2c2c2; text-align: center;" id="mbsNm"></td>
	                                                    <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0178'/></th>
	                                                    <td style="border:1px solid #c2c2c2; text-align: center;" id="cardNm"></td>
	                                                    <th style="border:1px solid #c2c2c2; background-color:#ecf0f2; text-align: center;"><spring:message code='IMS_BIM_BM_0179'/></th>
	                                                    <td style="border:1px solid #c2c2c2; text-align: center;" id="mbsNo"></td>
	                                                </tr>
	                                                <tr>
	                                                	<th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0399'/></th>
	                                                	<td style="border:1px solid #c2c2c2; text-align: center;" id="nointNm"></td>
	                                                    <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0373'/></th>
	                                                    <td style="border:1px solid #c2c2c2; text-align: center;" id="pointNm"></td>
	                                                    <td style="border:1px solid #c2c2c2;" colspan="2"></td>
	                                                </tr>
	                                                <tr><td>&nbsp;</td></tr>
                                                </tbody > 
                                            </table>
				                             <table id="tbHistoryInfo" class="table" style="width:100%; border: 1px; border-color: black; text-align: center;">
                                                <thead>
	                                           		<tr>
	                                            		 <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">NO</th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0400'/></th>
	                                                 	 <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0268'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0374'/></th>
	                                                 	 <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0365'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0331'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0387'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0388'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0381'/></th>
	                                                 	 <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0401'/></th>
	                                                 	 <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0123'/></th>
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
                <!-- END SEARCH LIST AREA -->
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
