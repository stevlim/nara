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
    
    $("select[name=searchPayFlg]").on("change", function(){
    	if ($.trim(this.value) == "ALL") {
    		$("#txtPaySearch").val("");
    		$("#txtPaySearch").attr("readonly", true);
    	}
    	else {
    		$("#txtPaySearch").attr("readonly", false);
    	}
    });
    
    $("#btnSearch").on("click", function() {
    	$("#divTidList").css("display", "none");
    	$("#div_search").css("display", "block");
    	 strType = "SEARCH";

        fnInquiry(strType);
    });
    $("#btnExcel").on("click", function() {
    	strType = "EXCEL";
    	//엑셀은 리스트만 조회해오면 됨
    	fnInquiry(strType);
    });
    /* $("#btnSumSearch").on("click", function() {
    	$("#div_searchResult").hide();
    	$("#divTidList").hide();
    	$("#div_search").show();
    	
    	fnSelectCardInfoTotAmt();
    	//fnSumInquiry();
    }); */
}

function fnSetDDLB() {
    $("#sendCategorySearch").html("<c:out value='${sendCategorySearch}' escapeXml='false' />");
    
    $("#yyyyMmSearch").datepicker({
        autoclose: true,
        minViewMode: 1,
        format: 'yyyy-mm'
    }).on('changeDate', function(selected){
            startDate = new Date(selected.date.valueOf());
            startDate.setDate(startDate.getDate(new Date(selected.date.valueOf())));
            $('.to').datepicker('setStartDate', startDate);
        }); 
}


function fnInquiry(strType) {

    if(strType == "SEARCH"){
	    $("#div_searchResult").serializeObject();
	    $("#div_searchResult").show(200);
		if (typeof objCoMInfoInquiry == "undefined") {
			objCoMInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbCardTransList", true, {
	        url: "/settlementViews/settlementCalender/selectTaxInvoiceList.do",
	        data: function() {
	            return $("#frmSearch").serializeObject();
	        },
	        columns: [
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ID} },	             
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM} },
	             
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  IONPay.Utils.fnStringToMonthDateFormat(data.TAX_DT)} },
	             { "class" : "columnr all",         "data" : null, "render": function(data){return  IONPay.Utils.fnAddComma(data.SUPP_AMT+'원')} },	             
	             { "class" : "columnr all",         "data" : null, "render": function(data){return  IONPay.Utils.fnAddComma(data.VAT+'원')} },
	             { "class" : "columnr all",         "data" : null, "render": function(data){return  IONPay.Utils.fnAddComma(data.TAX_AMT+'원')} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ITEM_NM} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RECPT_TYPE} },
	             
	             { "class" : "columnc all",         "data" : null, "render": 
	            	 function(data){
	            	 	if(data.IO_TYPE == '미납'){
	            	 		return '<input type="button" id="btnSendMail"'+data.DT_SEQ+'" value="변경" class="btn btn-info btn-sm btn-cons"  onClick="changeSettlmntCl(\'' + data.SEQ + '\')" />'
	            	 	}
	            	 	return  data.IO_TYPE
	            	 } 
	             },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MEMO} }
	             
	            ]
		    }, true);


		} else {
			objCoMInfoInquiry.clearPipeline();
			objCoMInfoInquiry.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();

		}
	else{
		var $objFrmData = $("#frmSearch").serializeObject();

        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
        IONPay.Ajax.fnRequestExcel(arrParameter, "/settlementViews/settlementCalender/selectTaxInvoiceListExcel.do");
        //IONPay.Ajax.fnRequestExcel(arrParameter, "/paymentMgmt/card/selectCardTransInfoListExcel.do");
	}
    
    $('.th-list').css('vertical-align', 'middle');
}

function changeSettlmntCl(seq){
	
	IONPay.Msg.fnConfirm("변경(미입급/미지급 상태)하시겠습니까?", function () {	        	       
		var objInputParam = {};
        objInputParam["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();	        
        objInputParam["seq"] = seq;
        
        $.post("/taxCalcuMgmt/taxInvoiceInquiry/updateTax.do", $.param(objInputParam)).done(function (objJson) {
            if (objJson.resultCode != "0") {
            	IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
            } else {
            	IONPay.Msg.fnAlert("입금여부 상태(미입금/미지급)가 변경 되었습니다.");
            	strType = "SEARCH";
                fnInquiry(strType);
            }
        }).fail(function (XMLHttpRequest) {
            if(XMLHttpRequest.status == 901) {
                location.href = IONPay.LOGINURL;
            } else {
                IONPay.Msg.fnAlert(IONPay.AJAXERRORMSG);
            }
        });
    });
}



//mid로 변환 후 다시 조회
function fnSerMID(mid){
	$("#frmSearch #searchFlg").select2("val", "1");
	$("#frmSearch #txtSearch").val(mid);
	strType="SEARCH";
	fnInquiry(strType);
}
//모달 창 생성 후  tid 로  조회

function fnDecCardNo(tid){
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalPwChk #tid").val(tid);
	$("#modalPwChk").modal();
}
function captureReturnKey(e) {
	if(e.keyCode==13) return false;
}
function fnPwCheck(){
	strModalID = "modalPwChk";
	arrParameter = $("#frmPwChk").serializeObject();
	arrParameter["cont"] = "cardNoDec";
	arrParameter["worker"] = strWorker;

    strCallUrl   = "/paymentMgmt/card/selectPwChk.do";
    strCallBack  = "fnPwCheckRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnPwCheckRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.data.resultCd == "success"){
			$("#div2 #unMaskNo_0").html(objJson.data.data);
			$("#modalPwChk .close").click();

		}else{
			IONPay.Msg.fnAlertWithModal(objJson.data.resultMsg, "modalPwChk");
		}
	}else{
		IONPay.Msg.fnAlertWithModal("비밀번호 확인에 실패하였습니다" + objJson.resultMessage, "modalPwChk");
	}
}



/* function fnSelectCardInfoTotAmt(){
	arrParameter = $("#frmSearch").serializeObject();
    //strCallUrl   = "/paymentMgmt/card/selectCardTotalAmt.do";
    strCallUrl   = "/taxCalcuMgmt/handWriteMng/selectHandWriteSendInfo.do";
    strCallBack  = "fnSelectCardInfoTotAmtRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
} */

//메일 재발송 api
function sendMail(index){

}
//신규메일 발송 api
function sendNewMail(){

}
function listShow(){
	$("#div_searchResult").show();
	$("#tbMailReSendInfo").hide();
}
/* function fnSelectCardInfoTotAmtRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#div_searchSumResult").css("display", "block");

		$("#tbCardTransTotalAmt #rAppCnt").html(objJson.data[0].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #rAppAmt").html(IONPay.Utils.fnAddComma(objJson.data[0].TRAN_AMT)+"원");
		
		$("#tbCardTransTotalAmt #totAppCnt").html(objJson.data[0].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #totAppAmt").html(IONPay.Utils.fnAddComma(objJson.data[0].TRAN_AMT)+"원");

		$("#tbCardTransTotalAmt #rCanCnt").html(objJson.data[0].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #rCanAmt").html(IONPay.Utils.fnAddComma(objJson.data[0].TRAN_AMT)+"원");
		
		$("#tbCardTransTotalAmt #totCanCnt").html(objJson.data[0].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #totCanAmt").html(IONPay.Utils.fnAddComma(objJson.data[0].TRAN_AMT)+"원");
		
		
		$("#tbCardTransTotalAmt #rTotCnt").html(  (objJson.data[0].TRAN_CNT + objJson.data[0].TRAN_CNT)  +"건");
		$("#tbCardTransTotalAmt #rTotAmt").html(  IONPay.Utils.fnAddComma(  objJson.data[0].TRAN_AMT - objJson.data[0].TRAN_AMT  )  +"원");
		$("#tbCardTransTotalAmt #totTotCnt").html(  (objJson.data[0].TRAN_CNT + objJson.data[0].TRAN_CNT)  +"건");
		$("#tbCardTransTotalAmt #totTotAmt").html(  IONPay.Utils.fnAddComma(  objJson.data[0].TRAN_AMT - objJson.data[0].TRAN_AMT  )  +"원");

	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		//$("#tbCardAmtInfo").hide();
	}
} */


</script>


<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <div class="content">
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><c:out value="${SUBMENU }" /></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${SUBMENU }" /></span></h3>
                </div>
                
                <input type="hidden" id="USR_ID" value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>" />
                <input type="hidden" id="receiptBgImg" value="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Images/receipt.png" />
                
                <!-- END PAGE TITLE -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0058'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border" id="searchBar">
                                <form id="frmSearch" name="frmsearch">
                                    <div class="row form-row" >
                                    	<div class="col-md-3">
	                                            <label class="form-label">발행월</label> 
	                                            <div id="yyyyMmSearch" class="input-append success date col-md-10 col-lg-10 no-padding" >
	                                                <input type="text" id=txtFromDate name="txtFromDate" class="form-control" autocomplete="off">
	                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
	                                            </div>
	                                        </div>
	                                        
	                                        <div class="col-md-3" style="width: 300px">
	                                        	<label class="form-label">청구구분</label> 
	                                            <select id="sendCategorySearch" name="sendCategorySearch" class="select2 form-control">
	                                            </select>
	                                        </div>
	                                        
	                                        <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
				                                  <button type="button" id="btnExcel" class="btn btn-primary btn-cons">EXCEL</button>
				                                  <!-- <button type="button" id="btnDown" class="btn btn-primary btn-cons">DOWN</button> -->
				                                  
				                                  <!-- <button type="button" id="btnSumSearch" class="btn btn-primary btn-cons">수기발행</button> -->
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
                                        
                                    
                                            <table id="tbCardTransList" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
	                                                 	 <th >NO</th>
	                                                 	 <th >ID</th>
	                                                 	 <th >상호</th>
	                                                     <th >발행월</th>
	                                                     <th >공급가액</th>
	                                                     <th >VAT</th>
	                                                     <th >합계</th>
	                                                     <th >품목</th>
	                                                     <th >영수구분</th>
	                                                     <th >입금여부</th>
	                                                     <th >메모</th>
	                                                     
	                                                 </tr>
                                                 
                                            	</thead>
                                            </table>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>
                                </div>
                                
                                <%-- <div id="div_searchSumResult" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                       		세금계산서 수기발행
                                       		
                                       		<form id="frmSendSearch" name="frmSendSearch">
	                                       		<table id="tbCardTransTotalAmt2" class="table" style="width:100%; text-align: center;">
	                                       			<tr>
	                                                     <th width="15%">발행일</th>
	                                                     <td width="30%" >
	                                                     	<div class="input-append success date col-md-10 col-lg-10 no-padding">
					                                            <input type="text" id="sendDate" name="fromdate" class="form-control">
					                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
					                                        </div>
	                                                     </td>
	                                                     <th width="15%" >발행대상 ID</th>
	                                                     <td width="30%" >
	                                                     	<input type="text" id="sendId" name="sendId">
	                                                     </td>
	                                                     <td width="10%">
	                                                     	<button type="button" id="btnSendSearch" class="btn btn-primary btn-cons" style="margin: 0px;"><spring:message code='IMS_BM_CM_0061'/></button>
	                                                     </td>
	                                                     
	                                                 </tr>
	                                       		</table>
                                       		</form>
                                       		
                                            <table id="tbCardTransTotalAmt" class="table" style="width:100%; text-align: center;">
                                                 <tr style="text-align: center;">
                                                     <th width="10%">상호</th>
                                                     <td width="20%" colspan="2"></td>
                                                     <th width="10%">사업자번호</th>
                                                     <td width="60%"></td>
                                                 </tr>
                                                 
                                                 <tr style="text-align: center;">
                                                     <th>품목</th>
                                                     <td colspan="2">
                                                     	<select id="amtSendTypeSearch" name="amtSendTypeSearch" class="select2 form-control">
	                                            		</select>
                                                     </td>
                                                     <th>구분</th>
                                                     <td>
                                                     	<select id="sendCategorySearch" name="sendCategorySearch" class="select2 form-control">
	                                            		</select>
                                                     </td>
                                                 </tr>
                                                 
                                                 <tr style="text-align: center;">
                                                     <th>공급가</th>
                                                     <th>VAT</th>
                                                     <th>합계</th>
                                                     <td rowspan="2">
                                                     	합계금액은 자동계산
                                                     </td>
                                                 </tr>
                                                 
                                                 <tr style="text-align: center;">
                                                     <td>
                                                     	<input type="text" id="sendId1" name="sendId1">
                                                     </td>
                                                     <td>
                                                     	<input type="text" id="sendId2" name="sendId2">
                                                     </td>
                                                     <td>
                                                     	<input type="text" id="sendId3" name="sendId3">
                                                     </td>
                                                 </tr>
                                                 
                                                 <tr style="text-align: center;">
                                                     <th>비고</th>
                                                     <td colspan="4">
                                                     	<input type="text" id="sendId4" name="sendId4">
                                                     </td>
                                                 </tr>
                                                 
                                                 <tr style="text-align: center;">
                                                     <td colspan="5">
                                                     	<button type="button" id="btnSend" class="btn btn-primary btn-cons" style="margin: 0px;">발행</button>
                                                     </td>
                                                 </tr>
                                                 
                                            </table>
                                            
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>
                                </div> --%>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END SEARCH LIST AREA -->


                </div></div>
            <!-- END PAGE -->
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->


		
		
		