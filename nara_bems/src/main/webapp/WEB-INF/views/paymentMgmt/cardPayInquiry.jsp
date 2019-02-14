<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strType;
var map= new Map();
$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    //fnModalSerTid();
});

function fnInitEvent() {
    $("select[name=searchFlg]").on("change", function(){
    	if ($.trim(this.value) == "ALL") {
    		$("#txtSearch").val("");
    		$("#txtSearch").attr("readonly", true);
    	}
    	else {
    		$("#txtSearch").attr("readonly", false);
    	}
    });
    $("select[name=flagChk]").on("change", function(){
    	if ($.trim(this.value) == "") {
    		$("#flag").val("");
    		$("#flag").attr("readonly", true);
    	}
    	else {
    		$("#flag").attr("readonly", false);
    	}
    });
    $("#btnSearch").on("click", function() {
    	testSearchClick();
    });
    $("#btnExcel").on("click", function() {
    	strType = "EXCEL";
    	//엑셀은 리스트만 조회해오면 됨
    	fnInquiry(strType);
    });
    $("#btnSumSearch").on("click", function() {
    	var fromDt = $("#txtFromDate").val();
    	var toDt = $("#txtToDate").val();
    	var date = $("#txtToDate").val() +"~"+ $("#txtFromDate").val();
    	$("#date").html(date);
    	fnSelectCardInfoTotAmt();
    	fnSumInquiry();
    });
}

function testSearchClick() {
    /* if (typeof objMessageMgmtDT == "undefined") {
        objMessageMgmtDT = IONPay.Ajax.CreateDataTable("#helloArea", true, {
            //url: "/messageMgmt/messageMgmt/selectMessageMgmtList.do",
            url: "/paymentMgmt/card/selectCardInfoAmt.do",
            data: function() {
                return $("#frmSearch").serializeObject();
            },
            columns: [                
                { "class" : "column20c", "data" : "APP_DT"  }
            ]
        });
    } else {
        objMessageMgmtDT.clearPipeline();
        objMessageMgmtDT.ajax.reload();
    } */
    
    //IONPay.Utils.fnShowSearchArea();
	IONPay.Ajax.CreateDataTable("#helloArea", true, {
        //url: "/messageMgmt/messageMgmt/selectMessageMgmtList.do",
        
        url: "/paymentMgmt/card/selectCardInfoAmt.do",
        data: function() {
            return $("#frmSearch").serializeObject();
        },
        
        columns: [
 	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_DT} }
 	            ]
 		    }, true);
	
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CREDIT_CARD }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                
                hello world! <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_MM_MM_0009'/></button>
                <form id="frmSearch"></form>
                <table id="helloArea" class="table" style="width:100%;">
                        <thead>
                            <tr>
                                <th>Hello Test</th>
                            </tr>
                        </thead>                                                
                    </table>    
                </div></div>
            </div>
            <!-- END PAGE -->
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->

<!-- BEGIN MODAL -->

		<div class="modal fade" id="modalPwChk"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code="IMS_AM_UAM_0027"/></h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		            	<form id="frmPwChk">
			                <div class="row form-row">
			                	<input type="hidden" name="tid">
			                    <table class="table" id="tbPwdChk" style="width:100%; border:1px solid #ddd;">
	                                <thead >
	                                  <tr>
	                                      <td>
	                                      	<input type="password" name='pwd'  onkeydown="return captureReturnKey(event)"  class='form-control'  >
	                                      </td>
	                                      <td>
	                                      	<button type="button" name='btnSave'  onclick="fnPwCheck();" class='btn btn-success btn-cons' ><spring:message code="IMS_BIM_BM_0538"/></button>
	                                      </td>
	                                  </tr>
	                                 </thead>
	                           </table>
	                         </div>
                         </form>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
		            </div>
	            </div>
	        </div>
	    </div>

		<!-- END MODAL -->