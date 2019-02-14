<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objSelectNoInstCardEventList;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";

$(document).ready(function(){
	$("#div_frm1").hide();
	$("#div_frm2").hide();
	$("#div_search").hide();
	
	fnInitEvent();
    fnSetDDLB();
});

function fnInitEvent() {
    
    $("#btnSearch").on("click", function() {
    	$("#div_frm1").hide(200);
    	$("#div_frm2").hide(200);
    	$("#div_search").show(200);
    	fnSearchList();
    });
    
    $("#btnRegist").on("click", function() {
    	IONPay.Utils.fnClearForm("frmRegist");
    	$("#div_frm1").show(200);
    	$("#div_frm2").hide(200);
    	$("#div_search").hide(200);
    	var str = '';
		str += '<div class="checkbox check-success" style="padding-top:10px; padding-bottom:0; float: left; width: 68%;" >';
		for(var i=2;i<37;i++){
			if(i <10){
				str += '<input id="mm_0'+i+'"  name="mm_0'+i+'"  type="checkbox">';
				str += '<label for="mm_0'+i+'">'+i+'<spring:message code="DDLB_0058"/></label>';
			}else{
				str += '<input id="mm_'+i+'"  name="mm_'+i+'"  type="checkbox">';
				str += '<label for="mm_'+i+'">'+i+'<spring:message code="DDLB_0058"/></label>';
			}
		}
			str += '</div>';
		$("#divChkBox").html(str);
		
		//frDt, toDt 오늘 날짜 셋팅
		var toDay = fnToDay();
		$("#div_frm1 #frDt").val(dateLMaskOn(toDay));
		$("#div_frm1 #toDt").val(dateLMaskOn(toDay));
		
    });
    $("#btnEdit").on("click", function() {
    	var frDt = $("#div_frm1 #frDt").val();
    	var toDt = $("#div_frm1 #toDt").val();
    	if(dateLMaskOff(frDt) < fnToDay()){
    		IONPay.Msg.fnAlert('시작일자는 과거일자로 등록이 불가능합니다.');
    		$("#div_frm1 #frDt").focus();
    		return;
    	}
		if(dateLMaskOff(toDt) <= dateLMaskOff(frDt)){
			IONPay.Msg.fnAlert('종료일자는 시작일자+1일 이후여야 합니다.');
			$("#div_frm1 #toDt").focus();
		    return;
    	}
		fnRegist("insert");
    });
    $("#btnUpdate").on("click", function() {
    	var frDt = $("#div_frm2 #frDt").val();
    	var toDt = $("#div_frm2 #toDt").val();
    	
    	if($("#div_frm2 input[name=procCl]").val() == "2" &&$("#div_frm2 input[name=frDt]").val() != "" && $("#div_frm2 input[name=frDt]").val().length < 10 ){
    		IONPay.Msg.fnAlert('적용기간을 정확히 입력해주세요');
    		return;
    	}
    	if(toDt != "" && toDt.length < 10){
    		IONPay.Msg.fnAlert('적용기간을 정확히 입력해주세요');
    		return;
    	}
    	if($("#div_frm2 input[name=procCl]").val() == "2" && dateLMaskOff(frDt) < fnToDay()){
    		IONPay.Msg.fnAlert('시작일자는 과거일자로 등록이 불가능합니다.');
    		$("#div_frm2 #frDt").focus();
    		return;
    	}
    	if(dateLMaskOff(toDt) < fnToDay()){
    		IONPay.Msg.fnAlert('시작일자는 과거일자로 등록이 불가능합니다.');
    		$("#div_frm2 #frDt").focus();
    		return;
    	}
		if(dateLMaskOff(toDt) <= fnToDay(frDt)){
			IONPay.Msg.fnAlert('종료일자는 과거일자로 등록이 불가능합니다.');
			$("#div_frm2 #toDt").focus();
		    return;
    	}
		if($("#div_frm2 input[name=procCl]").val() == "2" && dateLMaskOff(toDt) <= dateLMaskOff(frDt)) {
		      IONPay.Msg.fnAlert('종료일자는 시작일자+1일 이후여야 합니다.');
		      $("#div_frm2 #toDt").focus();
		      return;
	    } else if ($("#div_frm2 input[name=procCl]").val() == "2" && dateSMaskOff(toDt) <= dateSMaskOff(frDt)) {
	    	IONPay.Msg.fnAlert('종료일자는 시작일자+1일 이후여야 합니다.');
	    	$("#div_frm2 #toDt").focus();
	        return;
	    }
		var iSum = 0;
		for(var i=2;i<37;i++){
			if(i < 10){
				if($("#div_frm2 input[name=mm_0"+i+"]").prop("checked") == true){
					iSum += 1;
					break;
				}
			}else{
				if($("#div_frm2 input[name=mm_"+i+"]").prop("checked") == true){
					iSum += 1;
					break;
				}
			}
		}
		if(iSum == 0) {
			IONPay.Msg.fnAlert('적어도 하나의 할부개월을 선택하셔야 합니다');
			return;
		}
		fnRegist("update");
    });
    
}
function fnRegChk(){
	if($("#divCard select[name=CARD_LIST]").val() == "11"){
		$("#frmRegist #cpCd").select2("val", $("#divCard #CARD_LIST").val());
	}else{
		$("#frmRegist #cpCd").select2("val", "01");
	}
}
function fnSetDDLB() {
    $("#divCard select[name=cardCd]").html("<c:out value='${CARD_LIST}' escapeXml='false' />");
    $("#frmRegist select[name=cpCd]").html("<c:out value='${CARD_LIST1}' escapeXml='false' />");
    $("#status").html("<c:out value='${STATUS}' escapeXml='false' />");
}

function fnSearchList(){
	
	if (typeof objSelectNoInstCardEventList == "undefined") {
		objSelectNoInstCardEventList  = IONPay.Ajax.CreateDataTable("#tbEventInfo", true, {
        url: "/baseInfoMgmt/cardNonInstMnt/selectNoInstCardEventList.do",
        data: function() {	
            return $("#frmSearch").serializeObject();
        },
        columns: [
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
             { "class" : "columnc all",         "data" : null, "render": function(data){return  "카드사"}},
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CARD_NM==null?"":data.CARD_NM} },
             { "class" : "columnc all",         "data" : null, "render":
            	 function(data){
           	 		if(data.PROC_CL == "0" || data.PROC_CL == "2"){
           	 			var str="";
           	 			str += "<a href='#' onclick='fnChgAction("+data.RNUM+", \""+data.CARD_CD+"\"," +"\""+data.CARD_NM+"\" ," +"\""+data.EVNT_FR_DT+"\" ," +"\""+data.INSTMN_MM+"\"," +"\""+data.PROC_CL+"\" );' >" +data.EVNT_FR_DT + " ~ " + data.EVNT_TO_DT+"</a>";
           	 			return str;
           	 		}else{
           	 			return data.EVNT_FR_DT + " ~ " + data.EVNT_TO_DT;
           	 		}
 				}
             },
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.INSTMN_MM==null?"":data.INSTMN_MM} },
             { "class" : "columnc all",         "data" : null, "render": 
            	 function(data){
            	 	var i = data.RNUM;
            	 	var str="";
            	 	str += "<input type='hidden' name='cardNm_"+i+"' value='"+data.CARD_NM+"'/>";
            	 	str += "<input type='hidden' name='cardCd_"+i+"' value='"+data.CARD_CD+"'/>";
            	 	str += "<input type='hidden' name='regDt_"+i+"' value='"+data.REG_DT+"'/>";
            	 	str += "<input type='hidden' name='frDt_"+i+"' value='"+data.EVNT_FR_DT+"'/>";
            	 	str += "<input type='hidden' name='toDt_"+i+"' value='"+data.EVNT_TO_DT+"'/>";
            	 	str += "<input type='hidden' name='eventAmt_"+i+"' value='"+data.EVNT_AMT+"'/>";
            	 	return  data.PROC_NM==null?"":(data.PROC_NM+str);
   	 			} 
             }
            ]
	    }, true);
	
	} else {
		objSelectNoInstCardEventList.clearPipeline();
		objSelectNoInstCardEventList.ajax.reload();
	}
	IONPay.Utils.fnShowSearchArea();
	IONPay.Utils.fnHideSearchOptionArea();
	
}
function fnSelTarget(target){
	if(target == "cardCo")
		$("#divMid1").css("display", "none");
	else
		$("#divMid1").css("display", "block");
}
//등록 
function fnRegist(flg){
	if(flg == "insert"){
		arrParameter = $("#frmRegist").serializeObject();
		arrParameter["worker"] = strWorker;
	    strCallUrl   = "/baseInfoMgmt/cardNonInstMnt/insertNoInstCardEvent.do";
	    strCallBack  = "fnRegistRet";
	}else{
		arrParameter = $("#frmModify").serializeObject();
		arrParameter["worker"] = strWorker;
	    strCallUrl   = "/baseInfoMgmt/cardNonInstMnt/updateNoInstCardEvent.do";
	    strCallBack  = "fnRegistRet";
	}
    
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnRegistRet(objJson){
	if(objJson.resultCode == 0 ){
		IONPay.Msg.fnAlert("Success");
		IONPay.Utils.fnClearForm("frmRegist");
		IONPay.Utils.fnClearForm("frmModify");
		$("#div_frm1").hide(200);
    	$("#div_frm2").hide(200);
    	$("#div_search").show(200);
		fnSearchList();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);		
	}
}
	function fnChgAction(index,cardCd, cardNm, frDt, instMm, procCl){
	$("#div_frm1").hide(200);
	$("#div_search").hide(200);
	$("#div_frm2").show(200);
	IONPay.Utils.fnClearForm("frmModify");
	$("#frmModify #txtCardCd").text($("#tbEventInfo input[name=cardNm_"+index+"]").val());
	$("#frmModify input[name=cardCd]").val($("#tbEventInfo input[name=cardCd_"+index+"]").val());
	$("#frmModify #frDt").val($("#tbEventInfo input[name=frDt_"+index+"]").val());
	$("#frmModify input[name=cpCd]").val($("#tbEventInfo input[name=cardCd_"+index+"]").val());
	$("#frmModify input[name=regDt]").val($("#tbEventInfo input[name=regDt_"+index+"]").val());
	$("#frmModify input[name=lfrDt]").val($("#tbEventInfo input[name=frDt_"+index+"]").val());
	$("#frmModify input[name=ltoDt]").val($("#tbEventInfo input[name=toDt_"+index+"]").val());
	$("#frmModify input[name=eventAmt]").val($("#tbEventInfo input[name=eventAmt_"+index+"]").val());
	$("#frmModify input[name=procCl]").val(procCl);
	
	var str = '';
	str += '<div class="checkbox check-success" style="padding-top:10px; padding-bottom:0; float: left; width: 68%;" >';
	for(var i=2;i<37;i++){
		if(i <10){
			str += '<input id="mm_0'+i+'"  name="mm_0'+i+'"  type="checkbox">';
			str += '<label for="mm_0'+i+'">'+i+'<spring:message code="DDLB_0058"/></label>';
		}else{
			str += '<input id="mm_'+i+'"  name="mm_'+i+'"  type="checkbox">';
			str += '<label for="mm_'+i+'">'+i+'<spring:message code="DDLB_0058"/></label>';
		}
	}
		str += '</div>';
	$("#frmModify #divChkBox").html(str);
	
	var inst =  instMm.split(":");
	for(var i=0; i<inst.length; i++){
		$("#frmModify #divChkBox input[name=mm_"+inst[i]+"]").prop("checked", true);
	}
	if(procCl == "2"){
		$("#frmModify #txtFrDt").css("display", "none");
		$("#frmModify #frDt").css("display", "block");
		$("#frmModify #frDt").val(dateLMaskOn(frDt))
	}else{
		$("#frmModify #frDt").css("display", "none")
		$("#frmModify #txtFrDt").css("display", "block")
		$("#frmModify #txtFrDt").text(dateLMaskOn(frDt))
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
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
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
		                                	<div class="col-md-3">
		                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0545" /></label>
		                                    	<label class="form-label">&nbsp;<spring:message code="IMS_BIM_BM_0178" /></label>
	                                        </div>
	                                        <div class="col-md-9">
	                                        </div>
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0;">
	                                        <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0178" /></label>
	                                            <select id="cpCd" name="cpCd"  class="select2 form-control">
                                        		</select>
	                                        </div> 
	                                        <div class="col-md-9">
	                                        </div>
                               		 	</div>
                        		 		<div class="row form-row" style="padding: 0 0 10px 0;">
                        		 			<div class="col-md-12">
                        		 				<label class="form-label" ><spring:message code="IMS_BIM_BM_0266" /></label>
                        		 				<div id="divChkBox"></div>
                        		 			</div>
                        		 		</div>
                        		 		<div class="row form-row" style="padding: 0 0 10px 0;">
	                                        <div class="col-md-6">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0267" /></label>
	                                        	<input type="text" id="frDt" name="frDt" maxlength="10" onkeyup="fnReplaceDate(this);"class="form-control"  style="float:left;  width:45%;">
	                                        	<span style="float:left; width:5%; margin-left:3%;margin-top:1%;">~</span>
	                                        	<input type="text" id="toDt" name="toDt" maxlength="10" onkeyup="fnReplaceDate(this);" class="form-control" style="float:left; width:45%;">
	                                        </div> 
	                                        <div class="col-md-3">
	                                        	<label class="form-label">&nbsp;</label>
	                                        </div>
	                                        <div class="col-md-3">
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
	            <!-- BEGIN PAGE FORM -->
	            <div id="div_frm2" class="row" >
	                <div class="col-md-12">
	                    <div class="grid simple">
	                        <div class="grid-title no-border">
	                            <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Modify</span></h4>
	                            <div class="tools"><a href="javascript:;" class="remove"></a></div>
	                        </div>                          
	                        <div class="grid-body no-border">
		                         <!-- BEGIN registTab1 AREA -->  
		                         <div id="registTab1" class="tab-pane" >
		                         	<form id="frmModify" name="frmModify">
		                         		<input type='hidden' name='cpCd' >
										<input type='hidden' name='regDt' >
										<input type='hidden' name='eventAmt' >
										<input type='hidden' name='eventInstmnSeq'>
										<input type='hidden' name='procCl' >
										<input type='hidden' name='lfrDt' >
										<input type='hidden' name='ltoDt' >
		                                <div class="row form-row" style="padding: 0 0 10px 0;">
		                                	<div class="col-md-3">
		                                    	<label class="form-label"><spring:message code="IMS_BIM_BM_0545" /></label>
		                                    	<label class="form-label">&nbsp;<spring:message code="IMS_BIM_BM_0178" /></label>
	                                        </div>
	                                        <div class="col-md-9">
	                                        </div>
                               		 	</div>
                               		 	<div class="row form-row" style="padding: 0 0 10px 0;">
	                                        <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0178" /></label>
	                                        	<input type="hidden" name="cardCd"  class="form-control" >
	                                            <label class="form-label" id="txtCardCd"></label>
	                                        </div> 
	                                        <div class="col-md-9">
	                                        </div>
                               		 	</div>
                        		 		<div class="row form-row" style="padding: 0 0 10px 0;">
                        		 			<div class="col-md-12">
                        		 				<label class="form-label" ><spring:message code="IMS_BIM_BM_0266" /></label>
                        		 				<div id="divChkBox"></div>
                        		 			</div>
                        		 		</div>
                        		 		<div class="row form-row" style="padding: 0 0 10px 0;">
	                                        <div class="col-md-6">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0267" /></label>
	                                        	<input type="text" id="frDt" name="frDt" maxlength="10" onkeyup="fnReplaceDate(this);"class="form-control"  style="float:left;  width:45%;">
	                                        	<label id="txtFrDt" class="form-control"  style="float:left;  width:45%;"></label>
	                                        	<span style="float:left; width:5%; margin-left:3%;margin-top:1%;">~</span>
	                                        	<input type="text" id="toDt" name="toDt" maxlength="10" onkeyup="fnReplaceDate(this);" class="form-control" style="float:left; width:45%;">
	                                        </div> 
	                                        <div class="col-md-3">
	                                        	<label class="form-label">&nbsp;</label>
	                                        </div>
	                                        <div class="col-md-3">
	                                        </div>
                               		 	</div>
		                         	</form>
	                             </div>
		                         <!-- END registTab1 AREA -->
	                        </div>
	                        <div class="grid-body no-border">
	                            <div class="row form-row">
	                                <div class="col-md-12" align="center" >
                                        <button type="button" id="btnUpdate"  class="btn btn-danger auth-all"  ><spring:message code="IMS_BIM_HM_0002" /></button>
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
                            <div class="grid-body no-border" id="divCard">
                                <form id="frmSearch" name="frmsearch">
                                    <div class="row form-row" > 
					                       <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0545" /></label>
	                                            <select name="tarEvent" id="tarEvent" onchange='fnSelTarget(this.value);'  class="select2 form-control">
	                                            	<option value="cardCo" selected="selected"><spring:message code="IMS_BIM_BM_0178" /></option>
	                                            	<option value="merchant"><spring:message code="IMS_BIM_BM_0546" /></option>
                                        		</select>
	                                        </div>
	                                        <div class="col-md-3" id="divMid1" style="display:none">
	                                        	<label class="form-label"><spring:message code="IMS_PW_DE_09" /></label>
	                                        	<input type="text" id="mid" name="mid" class="form-control" >
	                                        </div> 
				                          <div class="col-md-6">
				                          </div>
		                         	</div>
                                    <div class="row form-row" > 
					                       <div class="col-md-3">
	                                        	<label class="form-label"><spring:message code="IMS_BIM_BM_0178" /></label>
	                                            <select id="cardCd" name="cardCd" class="select2 form-control" onchange="fnRegChk();">
                                        		</select>
	                                        </div> 
				                          <div class="col-md-3">
				                          	<label class="form-label"><spring:message code="IMS_BIM_MM_0007" /></label>
	                                            <select name="status" id="status" class="select2 form-control">
                                        		</select>
				                          </div>
				                          <div class="col-md-3">
				                          </div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_CM_0061'/></button>
				                                  <button type="button" id="btnRegist" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_MM_0104'/></button>
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
                                        <div class="grid-body">
                                        	<div class="row">
				                             <table id="tbEventInfo" class="table" style="width:100%; border: 1px; border-color: black; text-align: center;">
                                                <thead>
	                                           		<tr>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_DASHBOARD_0029'/></th>
	                                                 	 <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0545'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0178'/></th>
	                                                 	 <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0465'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_BM_0550'/></th>
	                                                     <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code='IMS_BIM_MM_0007'/></th>
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
                </div>
                <!-- END SEARCH LIST AREA -->
            </div>   
            <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
