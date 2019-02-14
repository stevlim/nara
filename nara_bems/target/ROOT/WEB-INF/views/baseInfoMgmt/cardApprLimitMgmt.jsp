<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objCardAppInquiry;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strType;
$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
    fnSetValidate();
    
    $("#btnSearch").on("click", function() {
    	$( '#tbCardAppLmt > tbody').empty();
    	
    	strType = "SEARCH";
    	fnCardAppInquiry(strType);
    });
    $("#btnExcel").on("click", function() {
    	strType="EXCEL";
    	fnCardAppInquiry(strType);
    });
}

function fnSetDDLB() {
    $("#cardCd").html("<c:out value='${CardCompanyList}' escapeXml='false' />");
    $("#inquiryFlg").html("<c:out value='${INQUIRY_OPTION}' escapeXml='false' />");
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


function fnCardAppInquiry(strType) {
	/* if(strType == "SEARCH"){
		if (typeof objCardAppInquiry == "undefined") {
			   objCardAppInquiry = IONPay.Ajax.CreateDataTable("#tbCardAppLmt", true, {
		        url: "/baseInfoMgmt/creditCardBINMgmt/selectAppLmtList.do",
		        data: function() {	
		            return $("#frmSearch").serializeObject();
		        },
		        columns:[
				            { "class" : "columnc all",         "data" : null, "render": function(data,row){return  data.LIMIT_APP_ACQU=="2" ? data.CARD_NM : null , 2} },
				            { "class" : "columnc all",         "data" : "일시불" },
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MBS_NO} },
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_AMT==null?"0":data.APP_AMT} },
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.LIMIT_LUMP_AMT==null?"0":data.LIMIT_LUMP_AMT} },
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REMAIN_AMT==null?"0":data.REMAIN_AMT} }, 
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.DAILY_APP_AMT==null?"0":data.DAILY_APP_AMT} },
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MONTH_APP_AMT==null?"0":data.MONTH_APP_AMT} },
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MONTH_REMAIN_AMT==null?"0":data.MONTH_REMAIN_AMT} }, 
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REMAIN_DAY==null? "0": data.REMAIN_DAY} },
				            { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_PER==null?"0" : data.APP_PER} },
			   			]
				             ,[	
							{ "class" : "columnc all",         "data" : "할부" },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MBS_NO} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.INST_AMT==null?"0":data.INST_AMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.LIMIT_INSTMNT_AMT==null?"0":data.LIMIT_INSTMNT_AMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.REMAIN_INST_AMT==null?"0":data.REMAIN_INST_AMT} }, 
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.DAILY_APP_INST_AMT==null?"0":data.DAILY_APP_INST_AMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MONTH_APP_INST_AMT==null?"0":data.MONTH_APP_INST_AMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MONTH_REMAIN_INST_AMT==null?"0":data.MONTH_REMAIN_INST_AMT} }, 
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.REMAIN_INST_DAY==null? "0": data.REMAIN_INST_DAY} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_INST_PER==null?"0" : data.APP_INST_PER} },	        		  
		        		  
		        		  ],
		        		[
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.CARD_NM} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.LIMIT_NM} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MBS_NO} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.LIMIT_APP_ACQU=="0"?data.TOT_APP_AMT:data.CAN_BFT_AMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MB_LMT==null?"0":data.MB_LMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.REMAIN_AMT==null?"0":data.REMAIN_AMT} }, 
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.DAILY_APP_AMT==null?"0":data.DAILY_APP_AMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MONTH_APP_AMT==null?"0":data.MONTH_APP_AMT} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MONTH_REMAIN_AMT==null?"0":data.MONTH_REMAIN_AMT} }, 
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.REMAIN_DAY==null? "0": data.REMAIN_DAY} },
							{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_PER==null?"0" : data.APP_PER} },	        		  
		        		  
		        		  ] 
			   }, true);
			} else {
				   objCardAppInquiry.clearPipeline();
			    objCardAppInquiry.ajax.reload();
			}
			
			IONPay.Utils.fnShowSearchArea();
			IONPay.Utils.fnHideSearchOptionArea();
	}else */ 
	if(strType == "SEARCH"){
		var $objFrmData = $("#frmSearch").serializeObject();
    	arrParameter = $objFrmData;
		strCallUrl   = "/baseInfoMgmt/creditCardBINMgmt/selectAppLmtList.do";
		strCallBack  = "fnSelectAppLmtListRet";
		
    	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}
	else{
		var $objFrmData = $("#frmSearch").serializeObject();
		        
	    arrParameter = $objFrmData;
	    arrParameter["EXCEL_TYPE"]                  = strType;
	    arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
	    IONPay.Ajax.fnRequestExcel(arrParameter, "/baseInfoMgmt/creditCardBINMgmt/selectAppLmtListExcel.do");
}
}
function fnSelectAppLmtListRet(objJson){
	if(objJson.resultCode==0){
		console.log(objJson.data);
		var data = [];
		data = objJson.data;
		if(objJson.data != null){
			if(objJson.data.length > 0 ){
				for(var i=0; i<objJson.data.length;i++){
					
					if(data[i].LIMIT_APP_ACQU == "2"){
						var str = "";
							str += "<tbody><tr style='text-align: center;' > ";
							str += "<td style='border:1px solid #ddd; ' rowspan='2'>" + data[i].CARD_NM + "</td>";
							str += "<td style='border:1px solid #ddd; '>" + "일시불" + "</td>";
							str += "<td style='border:1px solid #ddd; '>" + data[i].MBS_NO+ "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].APP_AMT==null?"0":data[i].APP_AMT) + "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].LIMIT_LUMP_AMT==null?"0":data[i].LIMIT_LUMP_AMT) + "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].REMAIN_AMT==null?"0": data[i].REMAIN_AMT) +"</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].DAILY_APP_AMT==null?"0": data[i].DAILY_APP_AMT)+ "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].MONTH_APP_AMT==null?"0":data[i].MONTH_APP_AMT)+ "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].MONTH_REMAIN_AMT==null?"0":data[i].MONTH_REMAIN_AMT)+"</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].REMAIN_DAY==null?"0":data[i].REMAIN_DAY) + "</td>";
		 					str += "<td style='border:1px solid #ddd; '>" + (data[i].APP_PER==null?"0":data[i].APP_PER) + "</td>";
							str += "</tr><tr style='text-align: center;'>"
							str += "<td style='border:1px solid #ddd; '>" + "할부" + "</td>";
							str += "<td style='border:1px solid #ddd; '>" + data[i].MBS_NO+ "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].INST_AMT==null?"0":data[i].INST_AMT) + "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].LIMIT_INSTMNT_AMT==null?"0":data[i].LIMIT_INSTMNT_AMT) + "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].REMAIN_INST_AMT==null?"0":data[i].REMAIN_INST_AMT) +"</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].DAILY_APP_INST_AMT==null?"0":data[i].DAILY_APP_INST_AMT)+ "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].MONTH_APP_INST_AMT==null?"0":data[i].MONTH_APP_INST_AMT)+ "</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].MONTH_REMAIN_INST_AMT==null?"0":data[i].MONTH_REMAIN_INST_AMT)+"</td>";
							str += "<td style='border:1px solid #ddd; '>" + (data[i].REMAIN_INST_DAY==null? "0": data[i].REMAIN_INST_DAY) + "</td>";
		 					str += "<td style='border:1px solid #ddd; '>" + (data[i].APP_INST_PER==null?"0" : data[i].APP_INST_PER) + "</td>";
							str += "</tr></tbody>"
							$("#tbCardAppLmt").append(str);
					}else{
						var str = "";
						str += "<tbody><tr style='text-align: center;' > ";
						str += "<td style='border:1px solid #ddd; ' rowspan='2'>" + data[i].CARD_NM + "</td>";
						str += "<td style='border:1px solid #ddd; '>" + "일시불" + "</td>";
						str += "<td style='border:1px solid #ddd; '>" + data[i].MBS_NO+ "</td>";
						str += "<td style='border:1px solid #ddd; '>" + (data[i].APP_AMT==null?"0":data[i].APP_AMT) + "</td>";
						str += "<td style='border:1px solid #ddd; '>" + (data[i].LIMIT_LUMP_AMT==null?"0":data[i].LIMIT_LUMP_AMT) + "</td>";
						str += "<td style='border:1px solid #ddd; '>" + (data[i].REMAIN_AMT==null?"0": data[i].REMAIN_AMT) +"</td>";
						str += "<td style='border:1px solid #ddd; '>" + (data[i].DAILY_APP_AMT==null?"0": data[i].DAILY_APP_AMT)+ "</td>";
						str += "<td style='border:1px solid #ddd; '>" + (data[i].MONTH_APP_AMT==null?"0":data[i].MONTH_APP_AMT)+ "</td>";
						str += "<td style='border:1px solid #ddd; '>" + (data[i].MONTH_REMAIN_AMT==null?"0":data[i].MONTH_REMAIN_AMT)+"</td>";
						str += "<td style='border:1px solid #ddd; '>" + (data[i].REMAIN_DAY==null?"0":data[i].REMAIN_DAY) + "</td>";
	 					str += "<td style='border:1px solid #ddd; '>" + (data[i].APP_PER==null?"0":data[i].APP_PER) + "</td>";
						str += "</tr></tbody>"
						$("#tbCardAppLmt").append(str);
						}
				}
					$("#div_search").css("display", "block");
					$("#div_search").show();
			}else{
				var str = "";
				str += "<tbody><tr style='text-align: center;' > ";
				str += "<td style='border:1px solid #ddd;'  colspan='11'><spring:message code='IMS_BIM_BM_0177'/></td>";
				str += "</tr></tbody>"
				$("#tbCardAppLmt").append(str);		
				$("#div_search").css("display", "block");
				$("#div_search").show();
			}
		}
	}else{
		var str = "";
		str += "<tbody><tr style='text-align: center;' > ";
		str += "<td style='border:1px solid #ddd;'  colspan='11'><spring:message code='IMS_BIM_BM_0177'/></td>";
		str += "</tr></tbody>"
		$("#tbCardAppLmt").append(str);		
		$("#div_search").css("display", "block");
		$("#div_search").show();
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CREDIT_CARD_SUPPORT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0097'/></span></h3>
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
                                            <label class="form-label"><spring:message code="IMS_BIM_BM_0082" /></label> 
	                                        <select class="select2 form-control" id="cardCd" name="cardCd">
	                                        </select>
                                        </div>
                                        <div class="col-md-3">
                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label>
                                            <input type="text" id="merNo" name="merNo" class="form-control" >
                                        </div>             
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0363'/></label> 
                                            <select id="inquiryFlg" name="inquiryFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row form-row" > 
					                       <div class="col-md-2">
					                       	   <label class="form-label"><spring:message code='IMS_BIM_BM_0261'/></label>
				                              <div class="input-append success date col-md-10 col-lg-10 no-padding">
				                                  <input type="text" id="txtFromDate" name="frDt" class="form-control">
				                                  <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
				                              </div>                                      
				                          	</div>
				                          <div class="col-md-7">
				                          </div>
				                          <div class="col-md-3">
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
                <div id="div_search" class="row" style="display:none;">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <div id="div_searchResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbCardAppLmt" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0082'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0364'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0365'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0366'/></th>            
                                                     <th ><spring:message code='IMS_BIM_BM_0367'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0368'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0369'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0370'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0371'/></th>
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
                <!-- END SEARCH LIST AREA -->
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
