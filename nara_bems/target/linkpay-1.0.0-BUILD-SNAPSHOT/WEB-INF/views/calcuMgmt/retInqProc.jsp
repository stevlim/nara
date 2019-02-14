<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strStmtFlg3 = "<c:out value='${SETT_AUTH_FLG3}' escapeXml='false' />";
var objListInquriy;

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
	$("#div_search").hide();
	if(strStmtFlg3 == "1"){
		$("#divProcBtn").css("display", "block");
	}else{
		$("#divProcBtn").css("display", "none");
	}
	
   	$("select[name=division]").on("change", function(){
   		if($.trim(this.value)=="ALL"){
   			$("#id").val("");
   			$("#frmSearch #id").attr("readonly", true);
   		}else{
   			$("#frmSearch #id").attr("readonly", false);
   		}
   	});
    
    $("#btnProc").on("click", function() {
    	if($("#division").val() != "ALL" && $("#id").val().length < 10){
    		IONPay.Msg.fnAlert('10자의 처리 ID를 입력하세요');
    		$("#id").focus();
    		return;
    	}
    	$("#div_search").show(200);
    });

}
function fnSetDDLB(){
	$("select[name=joinType]").html("<c:out value='${MER_TYPE}' escapeXml='false' />");
	$("select[name=stateCd]").html("<c:out value='${STATE_CD}' escapeXml='false' />");
	$("select[name=cardCd]").html("<c:out value='${CARD_LIST}' escapeXml='false' />");
	$("select[name=procCd]").html("<c:out value='${PROC_CD}' escapeXml='false' />");
	
	
	$("#modalForm select[name=procCd]").html("<c:out value='${PROC_CD1}' escapeXml='false' />");
	$("select[name=appDepReport]").html("<c:out value='${APP_DEP_REP}' escapeXml='false' />");
	
}
function fnInquiryInfo(strType){
	if(strType == "SEARCH"){
		$("#div_search").show();
		   	if (typeof objListInquriy == "undefined") {
		   		objListInquriy  = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
	               url: "/calcuMgmt/purchaseMgmt/selectAcqRetList.do",
	               data: function() {	
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM==null?"":data.RNUM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACQ_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.ACQ_DT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TR_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.TR_DT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RET_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.RET_DT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_NM==null?"":data.CARD_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO==null?"":data.MBS_NO} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TID==null?"":data.TID} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACQ_AMT==null?"": IONPay.Utils.fnAddComma(data.ACQ_AMT)} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TRX_ST_NM==null?"":data.TRX_ST_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RET_CD==null?"":data.RET_CD} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RET_PROC_NM==null?"":data.RET_PROC_NM} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RET_PROC_DESC==null?"":data.RET_PROC_DESC} },
					   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RET_PROC_DT==null?"":IONPay.Utils.fnStringToDateFormat(data.RET_PROC_DT)} },
					   { "class" : "columnc all", 			"data" : null, "render":
						   	function(data){
						   		if(data.RET_PROC_CD == "00"){
						   			return "<input type='checkbox' name='chkProc' value='"+data.SEQ+"' >";
						   		}else{
						   			return "<input type='checkbox' name='chkProc' value='"+data.SEQ+"' disabled >";
						   		}
				   			}
					   }
	               ]
	       }, true);
	    } else {
	       objListInquriy .clearPipeline();
	       objListInquriy .ajax.reload();
	    }
		IONPay.Utils.fnShowSearchArea();
	    //IONPay.Utils.fnHideSearchOptionArea();
	}else{
		var $objFrmData = $("#frmSearch").serializeObject();
        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();        
        IONPay.Ajax.fnRequestExcel(arrParameter, "/calcuMgmt/purchaseMgmt/selectAcqRetListExcel.do");
	}
}

function fnChkChange(obj){
	var chkProc = $("div_searchResult input[name=chkAll]");
    
	  if(obj.checked) { 
	    for(i = 0; i < chkProc.length; i++) {
	    	if(!chkProc[i].disabled) chkProc[i].checked = true;
	    }
	  } else { 
	    for(i = 0; i < chkProc.length; i++) {
	      chkProc[i].checked = false;
	    }	  
	  }
}
function fnShow(){
	var chkProc = $("#tbListSearch input[name=chkProc]");
	var iChkCnt = 0;
	
	for(var i=0; i<chkProc.length;i++){
		if(chkProc[i].checked) iChkCnt++;
	}
	
// 	if(iChkCnt > 0){
// 		fnModalShow();
// 	}else{
// 		IONPay.Msg.fnAlert('선택된 항목이 없습니다. 최소 하나 이상을 선택후 처리해주세요.');
// 	}
	fnModalShow();
}
function fnModalShow(){
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalForm").modal();
}
function fnSave(){
	arrParameter = $("#frmModal").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/purchaseMgmt/updateRetProc.do";
    strCallBack  = "fnSaveRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSaveRet(objJson){
	if(objJson.resultCode == 0 ){
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.PURCHASE_MANAGEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0118'/></span></h3>
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
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0306'/></label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding" >
                                                <input type="text" id=txtFromDate" name="acqFrDt" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="txtToDate" name="acqToDt" class="form-control">
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
	                                    <div class="col-md-2"></div>
                                    </div>
                                    <div class="row form-row"   >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0616'/></label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding" >
                                                <input type="text" id=txtFromDate1 name="retFrDt" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="txtToDate1" name="retToDt" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div id="divSearchDateType7" class="col-md-4">
	                                        <label class="form-label">&nbsp;</label>
	                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>                                       
	                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
	                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
	                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
	                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
	                                    </div>
	                                    <div class="col-md-2"></div>
                                    </div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;" >
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0308" /></label>
                                        	<select id="selJoinType" name=joinType  class="select2 form-control">
                                       		</select>
	                                   	</div>
                                        <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0178" /></label>
                                        	<select id="selDecide" name="cardCd"  class="select2 form-control">
                                       		</select>
	                                    </div>
	                                    <div class="col-md-6" ></div>
                                    </div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;" >
                                    	<div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0179" /></label>
                                        	<input type="text" id=mbsNo name="mbsNo" maxlength='20'  class="form-control">
	                                   	</div>
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0617" /></label>
                                        	<select id="stateCd" name="stateCd"  class="select2 form-control">
                                       		</select>
	                                   	</div>
	                                    <div class="col-md-6" ></div>
                                    </div>
                                    <div class="row form-row"   >
                                        <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0590" /></label>
                                        	<select id="procCd" name="procCd"  class="select2 form-control">
                                       		</select>
	                                    </div>
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_PW_DE_12" /></label>
                                        	<input type="text" id="tid" name="tid" maxlength='30'  class="form-control">
	                                   	</div>
	                                    <div class="col-md-3" ></div>
	                                    <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" onclick="fnInquiryInfo('SEARCH');" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_MM_0103'/></button>
				                                  <button type="button" onclick="fnInquiryInfo('EXCEL');" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
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
                                <div id="div_searchResult" >
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0306'/></th>
                                                     <th ><spring:message code='IMS_SM_SV_0010'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0616'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0178'/></th>  
                                                     <th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                                     <th ><spring:message code='IMS_PW_DE_12'/></th>
                                                     <th ><spring:message code='IMS_BIM_CCS_0036'/></th>
                                                     <th ><spring:message code='IMS_BIM_CCS_0034'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0618'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0590'/></th>
													 <th ><spring:message code='IMS_BIM_BM_0619'/></th>
													 <th ><spring:message code='IMS_BIM_BM_0620'/></th>
													 <th>
													 	<div class="checkbox check-success" style="padding-top:10px; padding-bottom:0; float: left; width: 68%;" >
													 		<input id="chkAll"  name="chkAll"  type="checkbox"  onclick="fnChkChange(this);" >
									                   		<label for="chkAll"></label>
													 	</div>
													 </th>	                                                     
                                                 </tr>
                                            	</thead>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                            </div>
                            <div class="grid-body no-border" style="display: none;" id="divProcBtn">
                            	<div class="col-md-11"></div>
                            	<div class="col-md-1">
                            		<button type="button" onclick="fnShow();" class="btn btn-primary btn-cons">PROC</button>
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
    	<!-- BEGIN MODAL -->
	    <form id="frmModal">
			<div class="modal fade" id="modalForm"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content" >
			            <div class="modal-header" style="background-color: #F3F5F6;">
			                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			                <br />
			                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
			                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0685"/></h4>
			                <br />
			            </div>
			            <div class="modal-body" style="background-color: #e5e9ec;">
			                <div class="row form-row">
			                    <table class="table" style="width:100%; border:1px solid #ddd;">
	                                <thead >
	                                	<tr>
	                                		<th><spring:message code="IMS_BIM_BM_0682"/></th>
	                                		<th><spring:message code="IMS_BIM_BM_0683"/></th>
	                                		<th><spring:message code="IMS_BIM_BM_0619"/></th>
	                                	</tr>	
	                                	<tr>	
                                			<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                				<select name="procCd"  class="select2 form-control">
                                       			</select>
                                   			</td>
                                   			<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                				<select name="appDepReport"  class="select2 form-control">
                                       			</select>
                                   			</td>
                                   			<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>
                                   				<input type="text" id="procDesc" name="procDesc" maxlength='40'  class="form-control">
                                   			</td>
	                                	</tr>
	                                 </thead>
	                           </table>
	                         </div>
		            	</div>
			            <div class="modal-footer">
			            	<button type="button" class="btn btn-default"  onclick="fnSave();"	><spring:message code="IMS_BIM_BM_0138"/></button>
			                <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="IMS_BIM_BM_0175"/></button>
			            </div>
		            </div>
		        </div>
		    </div>
	  	</form>
		<!-- END MODAL -->
