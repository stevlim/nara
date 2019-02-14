<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
	$("#MER_SEARCH").html("<c:out value='${MER_SEARCH}' escapeXml='false' />");	
	$("#HISTORY_TYPE").html("<c:out value='${HISTORY_TYPE}' escapeXml='false' />");	
}

function fnInit(){
	if($("#listSearchCollapse").hasClass("collapse") === true)
    	$("#listSearchCollapse").click();
	$("#ListSearch").hide();
}

function fnInitEvent() {	    
    $("#btnRegist").on("click", function(){
	  	//등록 부분 
	  	if($("#listSearchCollapse").hasClass("collapse") === false)
    	$("#listSearchCollapse").click();
		$("#ListSearch").show();
	  	fnMultiRegist();
    });
}

function fnMultiRegist(){
	var $objForm = $("#frmSearch");
    var $objFormData = new FormData($objForm);
    $objFormData.append("worker",      $.trim(strWorker));
	$objFormData.append("DATA_FILE",  $("input[name=DATA_FILE]")[0].files[0]);
	IONPay.Ajax.fnRequestFile($objFormData, "/baseInfoMgmt/baseInfoMgmt/insertMultiRegist.do", "fnMultiRegistRet");
}
function fnMultiRegistRet(objJson) {
    if (objJson.resultCode == 0) {
    	var str = "";
    	for(var i=0; i<objJson.failList.length; i++){
    		console.log(objJson.failList.length);
    		str+="<tr>";
    		str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(i+1)+"</td>";
			str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(objJson.failList[i].MID==null?"":objJson.failList[i].MID)+"</td>";
			str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(objJson.failList[i].GID==null?"":objJson.failList[i].GID)+"</td>";
			str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(objJson.failList[i].VID==null?"":objJson.failList[i].VID)+"</td>";
			str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(objJson.failList[i].CO_NO==null?"":objJson.failList[i].CO_NO)+"</td>";
			str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(objJson.failList[i].CO_NM==null?"":objJson.failList[i].CO_NM)+"</td>";
			str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(objJson.failList[i].insertMIDInfo==null?"N":objJson.failList[i].insertMIDInfo)+"</td>";
			str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+(objJson.failList[i].resultMsg==null?"":objJson.failList[i].resultMsg)+"</td>";
			str+="</tr>";
    	}
    	$("#div_searchResult").css("display", "block");
    	$("#multiRegResult").html(str);
        IONPay.Utils.fnClearHideForm();
        //frmEdit.reset();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);
    }
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
                    <h3><span class="semi-bold"><spring:message code="IMS_MENU_SUB_0049" /></span></h3>
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
                            	<form id = "frmSearch" method="post" enctype="multipart/form-data" >
                            		<div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-4" >
                                        <label class="form-label">IPG</label> <!-- 일단 하드코딩  -->
                                        <div class="input-with-icon  right" >
                                           <i class=""></i>
  										<input type="file" id="DATA_FILE" name="DATA_FILE" class="filestyle" data-buttonName="btn-primary">
                                       </div>
                                    </div>
                                    <div class="col-md-6">
	                                        <label class="form-label">&nbsp;</label>
	                                        <div>
	                                            <button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BIR_0019'/></button>
	                                        </div>
	                                    </div>      
                              	 </div>
                            	</form>
                            </div>
                		</div>
                	</div>
                </div>
                <!-- END VIEW OPTION AREA -->
           <div id="div_search" class="row" >
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0061'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <div id="div_searchResult"  style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbCardAmtInfo" class="table" style="width:50%">
                                                <thead>
                                                 <tr>
                                                     <th ><spring:message code='IMS_BIM_CCS_0006'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0194'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0195'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0196'/></th>
                                                     <th ><spring:message code='IMS_BIM_MM_0054'/></th>
			                                         <th ><spring:message code='IMS_BM_CM_0012'/></th> 
			                                         <th ><spring:message code='IMS_BIM_BM_0194'/><br/><spring:message code='IMS_BIM_BM_0539'/></th> 
			                                         <th ><spring:message code='IMS_SM_SRM_0007'/></th> 
                                                 </tr>
                                                </thead>
                                                <tbody id="multiRegResult">
                                                </tbody>
                                            </table>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>  
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
           </div>
           <!-- END PAGE --> 
        </div>
        <!-- END CONTAINER -->
    <!-- Modal Menu Insert Area -->