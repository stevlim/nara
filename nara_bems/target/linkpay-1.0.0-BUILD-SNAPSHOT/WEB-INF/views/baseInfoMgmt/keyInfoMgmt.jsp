<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objInquiryApprove;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var map = new Map();
var typeChk; 
$(document).ready(function(){
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetDDLB();
    fnInit();
    fnInitEvent();
});

function fnSetDDLB() {
}

function fnInit(){
}

function fnInitEvent() {	    
}


	
</script>
<style>
.checkbox_center label::after {
  left:1px;
}
</style>
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
                    <li><a href="javascript:;" class="active"><c:out value="${MENU_SUBMENU_TITLE }" /></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                
                <!-- BEGIN Information VIEW AREA -->
                <div id="midRegInfo"  >
                	<input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
	             
               <!-- END Information VIEW AREA -->  
                <!-- BEGIN Other Information VIEW AREA -->
	                <div class = "row" id = "OtherInformation">
	                	<div class = "col-md-12">
	                      	<div class="grid simple horizontal red">
	                        	<div class="grid-title">
	                          		<h4><span class="semi-bold">Key 관리</h4>
	                          		<div class="tools"><!--  <a href="javascript:;" id="otherInformationCollapse" class="collapse"></a> --></div>
	                        	</div>
	                        	<div class="grid-body">
	                          		<div class="row">
                            			<table class="table" id="tbOtherInformation" width="100%">
                                			<tbody>
                                				<tr>
	                                	 			<!-- MID -->
			                            			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 100px;">MID</td>
				                                    
				                               
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "inMid" name = "inMid">
				                                    	<c:out value="${MID }" />
			                            			</td>
                            			 
                            						<!-- 상호 -->
	                                    			<td style="text-align:center; border:1px solid #c2c2c2; background-color:#ecf0f2; width: 100px;">상호</td>
									
				                                    <td style="text-align:center; border:1px solid #c2c2c2;" id = "inCoNm" name = "inCoNm">
				                                    	<c:out value="${CO_NM }" />
			                            			</td>
	                                     
	                                			</tr>
	                                	
                                				<tr>
				                                	<!-- 가맹점 key -->
				                                    <td style="text-align:center; border:1px solid #c2c2c2; height: 100px" id="inMerKey" name="inMerKey" colspan="4">
				                                    	<c:out value="${MER_KEY }" />
			                            			</td>
			                            			
	                                			</tr>
	                                			<tr style="border: 0px;">
	                                				<td style="color: blue;" colspan="4">* 위의 Key를 복사하여 결제시 암호화 Key로 적용하시면 됩니다.</td>
	                                			</tr>
	                                	
	                                		</tbody>
	                            		</table>
	                          		</div>
	                        	</div>
	                		</div>
	                	</div>
	            	</div> 
               
	            </div>
              