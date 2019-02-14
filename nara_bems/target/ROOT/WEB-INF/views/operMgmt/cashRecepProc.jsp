<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var payAuth1= "<%=request.getAttribute("PAY_AUTH_FLG1")%>";
$(document).ready(function(){
	fnInitEvent();
    
});

function fnInitEvent() {
   
}



function fnReqFile(){
	if($("#frmSearch input[name=duplicateCheck]").val() == 0){
		if($("#frmSearch #DATA_FILE").val() == null || $("#frmSearch #DATA_FILE").val().length == 0 ){
			IONPay.Msg.fnAlert("파일을 선택하지 않았습니다.");
			$("#frmSearch #DATA_FILE").focus();
			return;
		}
		
		if(! confirm("현금영수증 실패건 처리를 진행하시겠습니까?")){
			return;
		}else{
			//start
			var dupChk = $("#frmSearch input[name=duplicateCheck]").val(1);
			var $objForm = $("#frmSearch");
	        var $objFormData = new FormData($objForm);
	        $objFormData.append("coNo",      $.trim($("#coNo").val()));
	        $objFormData.append("worker",      $.trim(strWorker));
	        $objFormData.append("dupChk",      $.trim(dupChk));
			$objFormData.append("DATA_FILE",  $("input[name=DATA_FILE]")[0].files[0]);
			
		    strCallUrl   = "/operMgmt/operMgmt/procFailCashRec.do";
		    strCallBack  = "fnReqFileRet";
		    IONPay.Ajax.fnRequestFile($objFormData, strCallUrl, strCallBack);
		}
	}else{
		IONPay.Msg.fnAlert("현재 현금영수증 생성중입니다. 기다려 주십시오.");
		return;
	}
		
}

function fnReqFileRet(objJson){
	$("#frmSearch input[name=duplicateCheck]").val("1");
	if(objJson.resultCode == 0 ){
		var str = "";
		if(objJson.failList != 0){
			$("body").addClass("breakpoint-1024 pace-done modal-open ");
			$("#modalFailRcpt").modal();
			for(var i=0; i<objJson.failList.length;i++){
				
				str += "<tr>";
				str += "<td style='text-align: center;font-weight: bold; border: 1px solid #ddd; background-color: white;'>"+objJson.failList[i].line+"</td>";
				str += "<td style='text-align: center;font-weight: bold; border: 1px solid #ddd; background-color: white;'>"+objJson.failList[i].desc+"</td>";
				str += "</tr>";
			}
		}else{
			str += "<tr><td colspan='2'>data not exist</td></tr>"; 	
		}
		//$("#div_search").css("display", "block");
		//$("#div_search #tbodyFail").html(str);
		$("#modalFailRcpt #tbodyFail").html(str);
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CASH_RECEIPT_PROCESSING }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-body no-border">
                            	<br>
                                <form id="frmSearch" name="frmsearch" method="post" enctype="multipart/form-data">
		                            <div class="row form-row" >
		                            	<div class="col-md-12">
		                            		<label class="form-label"><spring:message code='IMS_BIM_BM_0355'/></label>
		                            		<label class="form-label"><spring:message code='IMS_BIM_BM_0356'/></label>
		                            		<br>
		                            		<label class="form-label"><spring:message code='IMS_BIM_BM_0357'/></label>
		                            	</div>
		                            </div>
		                            <%if(request.getAttribute("PAY_AUTH_FLG1").equals( "1" )) {%>
		                            
		                            <!--  아래 dix 포함 시킬것  -->
		                            <%}%>
		                            <div class="row form-row"  style="padding: 0 0 10px 0;">
		                                <div class="col-md-6" >
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0354'/></label>
	                                        <div class="input-with-icon  right" >
	                                           <i class=""></i>
	  										<input type="file" id="DATA_FILE" name="DATA_FILE" class="filestyle" data-buttonName="btn-primary">
	                                       </div>
	                                    </div>
	                                    <div class="col-md-3"></div>
			                          	<div class="col-md-3" >
			                              <label class="form-label">&nbsp;</label>
			                              <div>
			                                  <button type="button" id="btnRetry" onclick="fnReqFile();" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0353'/></button>
			                              </div>
			                          </div>      
	                            	</div>
	                            	<input type="hidden" name="duplicateCheck" value="0" >
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END VIEW OPTION AREA -->
                <!-- BEGIN SEARCH LIST AREA -->
                <div id="div_search" class="row" style="display:none">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_IM_0032'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>                        
                            <div class="grid-body no-border" >
                                <div id="div_searchResult" >                               
                                    <div class="grid simple ">
                                        <div class="grid-body ">
                                            <table class="table" id="tbFailList" style="width:100%">
                                                <thead>
                                                    <tr>
                                                        <th><spring:message code='IMS_BIM_BM_0500'/></th>
                                                        <th><spring:message code='IMS_BIM_BM_0501'/></th>
                                                    </tr>
                                                </thead>
                                                <tbody id="tbodyFail"></tbody>
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
    <!-- BEGIN MODAL -->
		<div class="modal fade" id="modalFailRcpt"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_BIM_BM_0502"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                	<tr>
                                        <th><spring:message code='IMS_BIM_BM_0500'/></th>
                                        <th><spring:message code='IMS_BIM_BM_0501'/></th>
                                    </tr>
                                 </thead>
                                 <tbody id="tbodyFail"></tbody>
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