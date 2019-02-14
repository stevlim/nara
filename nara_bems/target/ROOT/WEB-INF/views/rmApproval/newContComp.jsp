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
    	fnInquiry("SEARCH");
    });
    $("#btnExcel").on("click", function() {
    	fnInquiry("EXCEL");
    });

}

function fnSetDDLB() {
    $("#frmSearch #searchFlg").html("<c:out value='${SEARCH_FLG}' escapeXml='false' />");
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

function fnInquiry(strType) {

    $("#div_searchResult").serializeObject();
    $("#div_searchResult").show(200);
    $("#div_searchSumResult").hide();

    if(strType == "SEARCH"){
	   	if (typeof objApproLimitList == "undefined") {
	   		objApproLimitList = IONPay.Ajax.CreateDataTable("#tbContCompListSearch", true, {
	               url: "/rmApproval/newContComp/selectContCompList.do",
	               data: function() {
	                   return $("#frmSearch").serializeObject();
	               },
	               columns: [
	                   { "class" : "columnc all",         	"data" : null, "render":function(data){return data.RNUM} },
	                   { "class" : "columnc all", 			"data" : null, "render":function(data){return IONPay.Utils.fnStringToDateFormat(data.TO_DT)} },
	               ]
	       }, true);
	    } else {
	    	objApproLimitList.clearPipeline();
	    	objApproLimitList.ajax.reload();
	    }
	   	IONPay.Utils.fnShowSearchArea();
	    IONPay.Utils.fnHideSearchOptionArea();
    }else{
    	var $objFrmData = $("#frmSearch").serializeObject();

        arrParameter = $objFrmData;
        arrParameter["EXCEL_TYPE"]                  = strType;
        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
        IONPay.Ajax.fnRequestExcel(arrParameter, "/rmApproval/approvalLimit/tbContCompListSearchExcel.do");
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
                                            <input type="text" id="search" name="search" class="form-control"  readonly>
                                        </div>
                                    </div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;">
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0099'/></label>
                                            <select id="salesManager" name="salesManager" class="select2 form-control">
                                            	<option value="0"><spring:message code='IMS_BIM_BM_0079'/></option>
                                            </select>
                                        </div>
                                      	<div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0215'/></label>
                                             <input type="text" id="merLevel" name="merLevel" class="form-control" style="width: 75%;  float: left;">
                                             <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0229'/></p>
                                        </div>
                                         <div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0219'/></label>
                                           <input type="text" id="approLimit" name="approLimit" class="form-control" style="width: 75%;  float: left;">
                                           <p style="float:left;  margin: 14px 10px;"> <spring:message code='IMS_BIM_BM_0230'/> </p>
                                        </div>
                                    </div>
                                    <div class="row form-row"  style="padding:0 0 10px 0;">
                                    	<div class="col-md-3">
                                           <label class="form-label"><spring:message code='IMS_BIM_BM_0216'/></label>
                                           <input type="text" id="fRegMoney1" name="fRegMoney" class="form-control" style="width: 45%;  float: left;">
                                           <p style="float:left;  margin: 8px 8px;"> ~ </p>
                                           <input type="text" id="fRegMoney2" name="fRegMoney" class="form-control" style="width: 45%; float: left;">
                                        </div>
                                        <div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0217'/></label>
                                           <input type="text" id="yMoney1" name="yMoney" class="form-control" style="width: 45%;  float: left;">
                                           <p style="float:left;  margin: 8px 8px;"> ~ </p>
                                           <input type="text" id="yMoney2" name="yMoney" class="form-control" style="width: 45%; float: left;">
                                        </div>
		                            	<div class="col-md-3">
                                        	<label class="form-label"><spring:message code='IMS_BIM_BM_0218'/></label>
                                           <input type="text" id="insurMoney1" name="insurMoney" class="form-control" style="width: 45%;  float: left;">
                                           <p style="float:left;  margin: 8px 8px;"> ~ </p>
                                           <input type="text" id="insurMoney2" name="insurMoney" class="form-control" style="width: 45%; float: left;">
                                        </div>
	                                 </div>
		                             <div class="row form-row" >
				                          <div class="col-md-2">
					                          <label class="form-label">&nbsp;</label>
					                           <select id="dateChk" name="dateChk" class="select2 form-control">
			                                  </select>
				                          </div>
				                       <div class="col-md-2">
				                              <label class="form-label">&nbsp;</label>
				                              <div class="input-append success date col-md-10 col-lg-10 no-padding">
				                                  <input type="text" id="txtFromDate" name="fromdate" class="form-control">
				                                  <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
				                              </div>
				                          </div>
				                          <div class="col-md-2">
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
                                            <table id="tbContCompListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                 	 <th >No</th>
                                                     <th ><spring:message code='IMS_BIM_BM_0083'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0142'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0231'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0232'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0233'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0085'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0234'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0235'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0107'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0108'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0236'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0237'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0238'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0239'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0219'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tr style="text-align: center;">
                                            		<td colspan="16"><spring:message code='IMS_BIM_BM_0177'/></td>
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
