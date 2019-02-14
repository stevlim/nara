<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var strStmtFlg2 = "<c:out value='${SETT_AUTH_FLG2 }' escapeXml='false'/>";
var objListInquriy;

$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();

});

function fnInitEvent() {
	$("#div_search").hide();
	$("#div_frm1").hide();

   	$("select[name=division]").on("change", function(){
   		if($.trim(this.value)=="ALL"){
   			$("#id").val("");
   			$("#frmSearch #id").attr("readonly", true);
   		}else{
   			$("#frmSearch #id").attr("readonly", false);
   		}
   	});

    $("#btnSearch").on("click", function() {
    	if($("#division").val() != "ALL" && $("#id").val().length < 10){
    		IONPay.Msg.fnAlert('10자의 처리 ID를 입력하세요');
    		$("#id").focus();
    		return;
    	}
    	$("#div_search").show(200);
    });

    $("#btnRegist").on("click", function() {
    	$("#div_frm1").show(200);
    	$("#registTab1").css("display", "block");
    });

    $("#btnEdit").on("click", function(){

    	for (var k=0;k<4;k++){
  	      if($("input[name=orgStmtDt"+k+"]").val() == ''){
  	    	  IONPay.Msg.fnAlert('원지급일자를 등록해주세요.');
  	    	  $("input[name=orgStmtDt"+k+"]").focus();
  	    	  return;
  	      }
  	      if($("input[name=orgStmtDt"+k+"]").val() != ''){
    	 	 if(!dateChecked(getOnlyDigit($("input[name=orgStmtDt"+k+"]").val()))){
    	 		IONPay.Msg.fnAlert('날짜 형식이 부정확 합니다. 다시 입력해주세요.');
    	 		$("input[name=orgStmtDt"+k+"]").focus();
    	 		return;
    	 	 }
    	 	if($("input[name=orgStmtDt"+k+"]").val() != ''){
    	 		if($("input[name=mid"+k+"]").val() == ''){
    	 			IONPay.Msg.fnAlert('MID를 입력해주세요.');
    	 			$("input[name=mid"+k+"]").focus();
    	 			return;
    	 		}
    	 		if($("input[name=noPayAmt"+k+"]").val() == ''){
    	 			IONPay.Msg.fnAlert('미지급금액을 입력해주세요.');
    	 			$("input[name=noPayAmt"+k+"]").focus();
    	 			return;
    	 		}
    	 		if($("input[name=reason"+k+"]").val() == ''){
    	 			IONPay.Msg.fnAlert('미지급사유를 입력해주세요.');
    	 			$("input[name=reason"+k+"]").focus();
    	 			return;
    	 		}
    	 	}
  	      }

     }
	  	if(confirm('미지급금액을 등록하시겠습니까?') == false){
	  		return;
	  	}else{
	  		arrParameter = $("#frmRegist").serializeObject();
			arrParameter["worker"] = strWorker;
			strCallUrl   = "/calcuMgmt/reportMgmt/insertUnStmtReg.do";
		    strCallBack  = "fnStmtRegRet";
		    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	  	}
    });

}
function fnSetDDLB(){
	$("select[name=status]").html("<c:out value='${status}' escapeXml='false' />");
}
function fnStmtRegRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert('등록이 완료되었습니다.');
	}else{
		IONPay.Msg.fnAlert('미지급 등록이 실패되었습니다.');
	}
}
function fnReqUpdate(orgDt, mid, seq){
	var reDt = $("#tbListSearch  input[name=reStmtDt"+seq+"]").val();
	$("#div_search input[name=orgDt]").val(orgDt);
	$("#div_search input[name=orgMid]").val(mid);
	$("#div_search input[name=orgSeq]").val(seq);
	$("#div_search input[name=orgReDt]").val(dateLMaskOff(reDt));


	if($("#div_search input[name=orgReDt]").val() == ''){
		IONPay.Msg.fnAlert('재지급일을 입력해주세요.');
		$("#div_search input[name=reStmtDt"+seq+"]").focus();
		return;
	}if(!dateChecked($("#div_search input[name=orgReDt]").val())){
		IONPay.Msg.fnAlert('재지급일 일자 형식이 부정확합니다. 다시 입력해주세요.');
		$("#div_search input[name=reStmtDt"+seq+"]").focus();
		return
	}
	arrParameter["reStmtDt"] = $("#div_search input[name=orgReDt]").val();
	arrParameter["orgStmtDt"] = $("#div_search input[name=orgDt]").val();
	arrParameter["orgMid"] = $("#div_search input[name=orgMid]").val();
	arrParameter["worker"] = strWorker;
	strCallUrl   = "/calcuMgmt/reportMgmt/updateUnStmtReg.do";
    strCallBack  = "fnStmtUpdRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnStmtUpdRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert('저장이 완료되었습니다.');
	}else{
		IONPay.Msg.fnAlert('저장 실패되었습니다.');
	}
}
function fnInquiry(){
	if (typeof objListInquriy == "undefined") {
   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbListSearch", true, {
               url: "/calcuMgmt/reportMgmt/selectUnStmtRegList.do",
               data: function() {
                   return $("#frmSearch").serializeObject();
               },
               columns: [
                   { "class" : "columnc all",         "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.ORG_STMT_DT)} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.CO_NM} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.MID}},
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnAddComma(data.NOPAY_AMT)} },
                   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.NOPAY_REASON} },
                   { "class" : "columnc all", 			"data" : null, "render":
                	   function(data){
                	   		if((data.ST_TYPE==null?"":data.ST_TYPE) == "0"){
                	   			return "<input type='text' name='reStmtDt"+data.RNUM+"' maxlength='10' onkeyup='fnReplaceDate(this);'>";
                	   		}else{
	                	   		return IONPay.Utils.fnStringToDateFormat(data.RESR_DESC);
                	   		}
                	   }
                   },
                   { "class" : "columnc all", 			"data" : null, "render":
                	   function(data){
                	   		if(strStmtFlg2 == "1"){
                	   			if((data.ST_TYPE==null?"":data.ST_TYPE) == "0"){
                	   				return "<button type='button' onclick='fnReqUpdate(\""+data.ORG_STMT_DT+"\" ,\""+data.MID+"\", \""+data.RNUM+"\" );' class='btn btn-primary btn-cons'><spring:message code='IMS_AM_MM_0003'/></button>"
					   			}else{
					   				return "지급";
					   			}
                	   		}else{
                	   			return "권한없음";
                	   		}
                	   }
                   }
               ]
       }, true);
    } else {
       objListInquriy.clearPipeline();
       objListInquriy.ajax.reload();
    }

	IONPay.Utils.fnShowSearchArea();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.REPORT_CREATION }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0110'/></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
	            <div id="div_frm1" class="row" >
	                <div class="col-md-12">
	                    <div class="grid simple">
	                        <div class="grid-title no-border">
	                            <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title"><spring:message code="IMS_BIM_BM_0385" /></span></h4>
	                            <div class="tools"><a href="javascript:;" class="remove"></a></div>
	                        </div>
	                        <div class="grid-body no-border">
		                         <!-- BEGIN registTab1 AREA -->
		                         <div id="registTab1" class="tab-pane" >
		                         	<form id="frmRegist" name="frmRegist">
		                                <div class="row form-row" style="padding: 0 0 10px 0;">
		                                	<div class="col-md-12">
												<table class="table" style="width:100%">
													<thead>
														<tr>
															<th><spring:message code="IMS_BIM_BM_0593" /></th>
															<th><spring:message code="DDLB_0137" /></th>
															<th><spring:message code="IMS_BIM_BM_0594" /></th>
															<th><spring:message code="IMS_BIM_BM_0595" /></th>
														</tr>
														<tr>
															<td><input type="text" onkeyup="fnReplaceDate(this);"   name="orgStmtDt0" maxlength="10" class="form-control"  ></td>
															<td><input type="text" name="mid0" maxlength="10" class="form-control"  ></td>
															<td><input type="text" onkeyup="numberMaskOn(this);" name="noPayAmt0" class="form-control"  ></td>
															<td><input type="text" name="reason0" class="form-control"  ></td>
														</tr>
														<tr>
															<td><input type="text" onkeyup="fnReplaceDate(this);"   name="orgStmtDt1" maxlength="10" class="form-control"  ></td>
															<td><input type="text" name="mid1" maxlength="10" class="form-control"  ></td>
															<td><input type="text" onkeyup="numberMaskOn(this);" name="noPayAmt1" class="form-control"  ></td>
															<td><input type="text" name="reason1" class="form-control"  ></td>
														</tr>
														<tr>
															<td><input type="text" onkeyup="fnReplaceDate(this);"   name="orgStmtDt2" maxlength="10" class="form-control"  ></td>
															<td><input type="text" name="mid2" maxlength="10" class="form-control"  ></td>
															<td><input type="text" onkeyup="numberMaskOn(this);" name="noPayAmt2" class="form-control"  ></td>
															<td><input type="text" name="reason2" class="form-control"  ></td>
														</tr>
														<tr>
															<td><input type="text" onkeyup="fnReplaceDate(this);"   name="orgStmtDt3" maxlength="10" class="form-control"  ></td>
															<td><input type="text"  name="mid3" maxlength="10" class="form-control"  ></td>
															<td><input type="text" onkeyup="numberMaskOn(this);"name="noPayAmt3" class="form-control"  ></td>
															<td><input type="text" name="reason3"class="form-control"  ></td>
														</tr>
														<tr>
															<td><input type="text" onkeyup="fnReplaceDate(this);"   name="orgStmtDt4" maxlength="10" class="form-control"  ></td>
															<td><input type="text"  name="mid4" maxlength="10" class="form-control"  ></td>
															<td><input type="text" onkeyup="numberMaskOn(this);"name="noPayAmt4" maxlength="10" class="form-control"  ></td>
															<td><input type="text" name="reason4" maxlength="10" class="form-control"  ></td>
														</tr>
													</thead>
												</table>
	                                        </div>
                               		 	</div>
		                         	</form>
	                             </div>
		                         <!-- END registTab1 AREA -->
	                        </div>
	                        <div class="grid-body no-border">
	                            <div class="row form-row">
	                                <div class="col-md-12" align="center" >
                                        <button type="button" id="btnEdit"  class="btn btn-danger auth-all"  ><spring:message code="IMS_BIM_BM_0138" /></button>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <!-- END PAGE FORM -->
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
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code='DDLB_0137'/></label>
                                        	<input type="text" id="id" name="id" maxlength="10" class="form-control"  >
	                                    </div>
	                                    <div class="col-md-3" >
											<label class="form-label"><spring:message code="IMS_BIM_BM_0590" /></label>
                                        	<select id="status" name="status"  class="select2 form-control">
                                       		</select>
	                                    </div>

                                        <div class="col-md-6"></div>
									</div>
                                    <div class="row form-row" >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0558'/></label>
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="txtFromDate" name="txtFromDate" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                           <label class="form-label">&nbsp;</label>
                                           <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                               <input type="text" id="txtToDate" name="txtToDate" class="form-control">
                                               <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                                           </div>
                                        </div>
                                        <div id="divSearchDateType4" class="col-md-4">
                                            <label class="form-label">&nbsp;</label>
                                            <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0021'/></button>
                                            <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0022'/></button>
                                            <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0023'/></button>
                                            <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0024'/></button>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" onclick="fnInquiry();"  id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_NM_0026'/></button>
                                                <button type="button"  id="btnRegist" class="btn btn-primary auth-all btn-cons"><spring:message code='IMS_BM_NM_0027'/></button>
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
                                        	<input type="hidden" name="orgDt">
											<input type="hidden" name="orgMid">
											<input type="hidden" name="orgSeq">
											<input type="hidden" name="orgReDt">
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0593'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th ><spring:message code='DDLB_0137'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0594'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0595'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0596'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0138'/></th>
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
