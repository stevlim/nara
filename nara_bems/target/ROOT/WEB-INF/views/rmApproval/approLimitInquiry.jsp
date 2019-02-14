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
   
    $("select[name=searchFlg]").on("change", function(){
    	if ($.trim(this.value) == "") {
    		$("#search").val("");
    		$("#search").attr("readonly", true);
    	}
    	else {    		
    		$("#search").attr("readonly", false);
    	}
    });
    
    $("#btnSearch").on("click", function() {
    	fnInquiry();
    });
    $("#btnExcel").on("click", function() {
    	IONPay.Msg.fnAlert("fail");
    });
    
}

function fnSetDDLB() {
    $("#frmSearch #searchFlg").html("<c:out value='${SEARCH_FLG}' escapeXml='false' />");
    $("#frmSearch #tranCutFlg").html("<c:out value='${Cut_Chk}' escapeXml='false' />");
    $("#frmSearch #payType").html("<c:out value='${PAY_TYPE}' escapeXml='false' />");
    $("#frmSearch #dateChk").html("<c:out value='${DATE_CHK}' escapeXml='false' />");
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.APPROVAL_LIMIT }'/></a> </li>
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
                                            <select id="searchFlg" name="searchFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" id="search" name="search" class="form-control" readonly>
                                        </div>             
                                    </div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0242'/></label> 
                                            <select id="tranCutFlg" name="tranCutFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                      	<div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0241'/></label>
                                             <select id="payType" name="payType" class="select2 form-control">
                                            </select>
                                        </div>  
                                    </div>
                                    <br>
		                             <div class="row form-row" >
			                             <div class="col-md-2">
                                            <select id="dateChk" name="dateChk" class="select2 form-control">
                                            </select>
	                                        </div>
					                       <div class="col-md-2">
				                              <div class="input-append success date col-md-10 col-lg-10 no-padding">
				                                  <input type="text" id="txtFromDate" name="fromdate" class="form-control">
				                                  <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
				                              </div>                                      
				                          	</div>
				                          <div class="col-md-5">
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
                                                 	 <th >NO</th>
                                                 	 <th >SEQ</th>
                                                     <th ><spring:message code='IMS_BIM_BM_0262'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0250'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0263'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0242'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0241'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0264'/></th>            
                                                     <th ><spring:message code='IMS_BIM_BM_0265'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0266'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0267'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0268'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0269'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0275'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0253'/></th>
                                                     <th ><spring:message code='IMS_BM_IM_0024'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tr style="text-align: center;">
                                            		<td colspan="17"><spring:message code='IMS_BIM_BM_0177'/></td>
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
