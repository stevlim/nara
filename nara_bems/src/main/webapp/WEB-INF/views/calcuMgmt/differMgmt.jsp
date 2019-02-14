<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

var objDifferenceAmtSearch;

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
    fnSetValidate();
   
    $("#btnSearch").on("click", function() {
    	fnInquiry();
    });
    $("#btnRegist").on("click", function() {
    	fnRegist();
    });
    $("#btnSave").on("click", function() {
    	fnSave();
    });
}

function fnSetDDLB() {
    $("select[id='CardCompanyList']").html("<c:out value='${CardCompanyList}' escapeXml='false' />");
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
	if (typeof objDifferenceAmtSearch == "undefined") {
    	objDifferenceAmtSearch = IONPay.Ajax.CreateDataTable("#differenceAmtTable", true, {
               url: "/calcuMgmt/calcuCard/differenceAmtSearch.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data, type, full, meta){return IONPay.Utils.fnAddComma(data.RNUM)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CARD_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MBS_NO}},
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.ACQ_DT)} },
                   { "class" : "columnc all",         "data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.DPST_DT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MEMO} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.AMT} },
                   {
                  	 "class" : "columnc all",
                       "render": function ( data, type, row ) {
                    	   	return "<input type='button' name='' value='삭 제'  onclick=\"delData('" + row.SEQ + "');\"  class='btn btn-success btn-cons'>";
                         },
                         className: "dt-body-center"
                     }
               ]
       }, true);
    } else {
    	objDifferenceAmtSearch.clearPipeline();
    	objDifferenceAmtSearch.ajax.reload();
    }
	
	IONPay.Utils.fnShowSearchArea();
	//IONPay.Utils.fnHideSearchOptionArea();
}

function fnRegist() {
	$("#div_regist").serializeObject();
	$("#div_regist").show(200);
	$("#div_searchResult").hide();
	//IONPay.Utils.fnHideSearchOptionArea();
}

function fnSave() {
	arrParameter = $("#frmEdit").serializeObject();
	arrParameter["worker"] = strWorker;
	strCallUrl = "/calcuMgmt/calcuCard/deferrenceRegist.do";
	strCallBack = "fnSaveRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnSaveRet(objJson) {
	if (objJson.resultCode == 0) {
		IONPay.Msg.fnAlert(IONPay.SAVESUCCESSMSG);
		IONPay.Utils.fnJumpToPageTop();
	} else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function dpAll(obj_name) {
	for (i = 2; i < 9; i++) {
		$("#" + obj_name + "_" + i).val($("#" + obj_name + "_1").val());
	}
}

function selAll(obj_name) {
	for (i = 1; i < 9; i++) {
		$("#" + obj_name + "_" + i).val($("#" + obj_name + "_0").val());
		$("#deferrenceRegistTable .select2-chosen").text($("#" + obj_name + "_0 option:selected").text());
	}
}

function getTIDData(index) {
	arrParameter["tid"] = $("#deferrenceRegistTable #tid_" + index).val();
	arrParameter["index"] = index;
	strCallUrl = "/calcuMgmt/calcuCard/getReceiveDeferGetTIDData.do";
	strCallBack = "fnTIDDataRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnTIDDataRet(objJson){
	if (objJson.resultCode == 0) {
		if(objJson.data != null ) {
			var index = objJson.data.index;
			if($("#deferrenceRegistTable #mbsNo_" + index).val() != null &&
			   $("#deferrenceRegistTable #mbsNo_" + index).val() != '' &&
			   objJson.data.MBS_NO != $("#deferrenceRegistTable #mbsNo_" + index).val()){
// 				IONPay.Msg.fnAlert('가맹점 번호가 다른 TID입니다. TID를 다시 입력해주세요.');
				$("#deferrenceRegistTable #tid_" + index).val('');
				$("#deferrenceRegistTable #tid_" + index).focus();
			}
			else{
				$("#deferrenceRegistTable #overFlg_" + index).val(objJson.data.OVER_FLG);
				$("#deferrenceRegistTable #overFlgNm_" + index).val(objJson.data.OVER_FLG_NM);
				$("#deferrenceRegistTable #mbsNm_" + index).val(objJson.data.MBS_NO);
				$("#deferrenceRegistTable #amt_" + index).val(objJson.data.GOODS_AMT);
			}
		}
		else{
			IONPay.Msg.fnAlert("잘못된 TID입니다. TID를 다시 입력해주세요.");	
			$("#deferrenceRegistTable #tid_" + index).val('');
			$("#deferrenceRegistTable #tid_" + index).focus();
		}
// 		IONPay.Utils.fnJumpToPageTop();
	} else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function delData(seq) {
    var f = document.mainForm;

    if(confirm('삭제 후 복구가 불가능합니다.\n진짜 삭제하겠습니까?')) {
    	arrParameter["seq"] = seq;
        strCallUrl   = "/calcuMgmt/calcuCard/differenceAmtDel.do";
        strCallBack  = "fnDelDataRet";
        
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    }
}

function fnDelDataRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("삭제 되었습니다.");
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.CREDIT_CARD_DEPORIT_MANAGEMENT }'/></a> </li>
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
	                                        <label class="form-label"><spring:message code='IMS_BIM_BM_0307'/></label> 
	                                        <div class="input-append success date col-md-10 col-lg-10 no-padding">
	                                            <input type="text" id="txtFromDate" name="fromdate" class="form-control">
	                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
	                                        </div>                                      
	                                    </div>
	                                    <div class="col-md-3">
	                                       <label class="form-label">&nbsp;</label>
	                                       <div class="input-append success date col-md-10 col-lg-10 no-padding">
	                                           <input type="text" id="txtToDate" name="todate" class="form-control">
	                                           <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
	                                       </div>
	                                    </div> 
	                                    <div id="divSearchDateType4" class="col-md-3">
	                                        <label class="form-label">&nbsp;</label>
	                                        <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0056'/></button>                                       
	                                        <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0057'/></button>
	                                        <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0058'/></button>
	                                        <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0059'/></button>
	                                        <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_CM_0060'/></button>
	                                    </div>
		                            </div>
                                    <div class="row form-row" >
                                        <div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0178'/></label>
                                            <select id="CardCompanyList" name="CardCompanyList" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0179'/></label>
                                            <input type="text" id="merNo" name="merNo" class="form-control" >
                                        </div>
                                      <div class="col-md-3"></div>               
			                          <div class="col-md-3">
			                              <label class="form-label">&nbsp;</label>
			                              <div>
			                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
			                                  <button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0062'/></button>
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
                                            <table id="differenceAmtTable" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                 	 <th >NO</th>
                                                     <th ><spring:message code='IMS_BIM_BM_0082'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0179'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0306'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0307'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0321'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0131'/></th>            
                                                     <th ><spring:message code='IMS_BIM_BM_0322'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tr style="text-align: center;">
                                            		<td colspan="8"><spring:message code='IMS_BIM_BM_0177'/></td>
                                            	</tr>
                                            </table>
                                        </div>
                                    </div>  
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
                <!-- END SEARCH LIST AREA -->
                <!-- REGIST AREA -->
                <div id="div_regist" class="row" style="display:none;">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Regist</span></h4>
                           		<div class="tools"><a href="javascript:;" class="remove"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <div id="divRegist" >
                                	<form id="frmEdit">
                                   <div class="grid simple ">
                                       <div class="grid-body " id="">
                                        	<div class="col-md-10" ><spring:message code='IMS_BIM_BM_0323'/></div>
                                           <table id="deferrenceRegistTable" class="table" style="width: 100%">
											<thead>
												<tr>
													<th><a href="javascript:dpAll('mbsNo');"><spring:message code='IMS_BIM_BM_0179' /></a></th>
													<th><a href="javascript:dpAll('acqDt');"><spring:message code='IMS_BIM_BM_0306' /></a></th>
													<th><a href="javascript:dpAll('dpstDt');"><spring:message code='IMS_BIM_BM_0307' /></a></th>
													<th><a href="javascript:dpAll('tid');"><spring:message code='IMS_PW_DE_12' /></a></th>
													<th><a href="javascript:dpAll('memo');"><spring:message code='IMS_BIM_BM_0321' /></a></th>
													<th><a href="javascript:dpAll('amt');"><spring:message code='IMS_BIM_BM_0131' /></a></th>
												</tr>
											</thead>
											<tr>
												<td><input type="text" id="mbsNo_1" name="mbsNo_1"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_1" name="acqDt_1"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_1" name="dpstDt_1"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_1" name="tid_1"
													maxlength='30' class="form-control" onblur="getTIDData('1');"></td>
												<td><input type="text" id="memo_1" name="memo_1"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_1" name="amt_1"
													maxlength='12' class="form-control"></td>
											</tr>
											<tr>
												<td><input type="text" id="mbsNo_2" name="mbsNo_2"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_2" name="acqDt_2"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_2" name="dpstDt_2"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_2" name="tid_2"
													maxlength='30' class="form-control" onblur="getTIDData('2');"></td>
												<td><input type="text" id="memo_2" name="memo_2"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_2" name="amt_2"
													maxlength='12' class="form-control"></td>
											</tr>
											<tr>
												<td><input type="text" id="mbsNo_3" name="mbsNo_3"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_3" name="acqDt_3"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_3" name="dpstDt_3"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_3" name="tid_3"
													maxlength='30' class="form-control" onblur="getTIDData('3');"></td>
												<td><input type="text" id="memo_3" name="memo_3"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_3" name="amt_3"
													maxlength='12' class="form-control"></td>
											</tr>
											<tr>
												<td><input type="text" id="mbsNo_4" name="mbsNo_4"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_4" name="acqDt_4"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_4" name="dpstDt_4"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_4" name="tid_4"
													maxlength='30' class="form-control" onblur="getTIDData('4');"></td>
												<td><input type="text" id="memo_4" name="memo_4"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_4" name="amt_4"
													maxlength='12' class="form-control"></td>
											</tr>
											<tr>
												<td><input type="text" id="mbsNo_5" name="mbsNo_5"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_5" name="acqDt_5"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_5" name="dpstDt_5"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_5" name="tid_5"
													maxlength='30' class="form-control" onblur="getTIDData('5');"></td>
												<td><input type="text" id="memo_5" name="memo_5"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_5" name="amt_5"
													maxlength='12' class="form-control"></td>
											</tr>
											<tr>
												<td><input type="text" id="mbsNo_6" name="mbsNo_6"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_6" name="acqDt_6"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_6" name="dpstDt_6"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_6" name="tid_6"
													maxlength='30' class="form-control" onblur="getTIDData('6');"></td>
												<td><input type="text" id="memo_6" name="memo_6"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_6" name="amt_6"
													maxlength='12' class="form-control"></td>
											</tr>
											<tr>
												<td><input type="text" id="mbsNo_7" name="mbsNo_7"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_7" name="acqDt_7"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_7" name="dpstDt_7"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_7" name="tid_7"
													maxlength='30' class="form-control" onblur="getTIDData('7');"></td>
												<td><input type="text" id="memo_7" name="memo_7"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_7" name="amt_7"
													maxlength='12' class="form-control"></td>
											</tr>
											<tr>
												<td><input type="text" id="mbsNo_8" name="mbsNo_8"
													maxlength="20" class="form-control"></td>
												<td><input type="text" id="acqDt_8" name="acqDt_8"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="dpstDt_8" name="dpstDt_8"
													maxlength='10' class="form-control"></td>
												<td><input type="text" id="tid_8" name="tid_8"
													maxlength='30' class="form-control" onblur="getTIDData('8');"></td>
												<td><input type="text" id="memo_8" name="memo_8"
													maxlength='200' class="form-control"></td>
												<td><input type="text" id="amt_8" name="amt_8"
													maxlength='12' class="form-control"></td>
											</tr>
										</table>
                                           <center><button type="button" id="btnSave" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0138'/></button></center>
                                       </div>
                                   	 </div> 
                                    </form> 
                                </div>
                            </div>
                        </div>
                    </div>                
                </div>
                <!-- END REGIST AREA -->
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
