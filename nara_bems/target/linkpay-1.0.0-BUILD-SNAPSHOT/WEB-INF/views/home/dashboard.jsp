<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<%
	String merId = session.getAttribute("MER_ID").toString();
	String merIdType = session.getAttribute("MER_ID_TYPE").toString();
%>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">

$(document).ready(function(){
	fnInitEvent();
});

function fnInitEvent(){
	var strInitPSWDFlag = "${sessionScope['IMSAdminPasswordChangeSession']}";

   // param : 결제수단, 일/월(금액/TR)
	fnSummaryList("EromMoney",1);
	
	//공지사항
	fnInformList();
	
	//1:1 문의내역
	fnQnaList();

	//오늘의 입금액
	fnTodayInput();
	
    // SummaryList 금액/TR 버튼
    $("button[name^='btnErom']").click(function(){
    	var intSummaryType = $(this).data("type");
    	fnSummaryList("EromMoney", intSummaryType);
    	fnToggleSummaryList(intSummaryType, "#div-erom-amt", "#div-erom-trx");
    });

}

/**
 *  거래 요약 리스트 금액/TRX 토글 기능
 */
function fnToggleSummaryList(intSummaryType, selAmt, selTrx){
	if (Number(intSummaryType) === 1) {
		$(selAmt).css("display", "block");
		$(selTrx).css("display", "none");
	} else {
		$(selTrx).css("display", "block");
		$(selAmt).css("display", "none");
	}
}

/**------------------------------------------------------------
* 대시보드 Summary List
* param : 결제수단, (금액/TR)
------------------------------------------------------------*/
function fnSummaryList(strListType, intSummaryType){
    var strCallUrl   = "/home/dashboard/selectDashBoardSummaryList.do";
    if(intSummaryType == 1){
	    var strCallBack  = "fnSummaryListRet";
    }else{
    	var strCallBack  = "fnSummaryListRet2";
    }
    var objParam     = {};

    objParam["LIST_TYPE"]    = strListType;
    objParam["SUMMARY_TYPE"] = intSummaryType;
    objParam["MER_ID"] = '<%=merId%>';
    objParam["MERID_TYPE"] = '<%=merIdType%>';
    
    objParam["ISLOADING"]    = false;

    IONPay.Ajax.fnRequest(objParam, strCallUrl, strCallBack);
}

function fnSummaryListRet(objJson){
	if(objJson.resultCode == 0){
		var $strFirstID  = "#sp"+objJson.LIST_TYPE+"FirstNum";
		var $strSecondID = "#sp"+objJson.LIST_TYPE+"SecondNum";

		$($strFirstID).animateNumbers(objJson.data[0].FIRST_NUM, true, parseInt(1000, 10));
		$($strSecondID).animateNumbers(objJson.data[0].SECOND_NUM, true, parseInt(1000, 10));
    }else{
        IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}

function fnSummaryListRet2(objJson){
	if(objJson.resultCode == 0){
		var $strFirstID  = "#tr"+objJson.LIST_TYPE+"FirstNum";
		var $strSecondID = "#tr"+objJson.LIST_TYPE+"SecondNum";

		$($strFirstID).animateNumbers(objJson.data[0].FIRST_NUM, true, parseInt(1000, 10));
		$($strSecondID).animateNumbers(objJson.data[0].SECOND_NUM, true, parseInt(1000, 10));
    }else{
        IONPay.Msg.fnAlert(objJson.resultMessage);
    }
}

/**------------------------------------------------------------
* 공지사항 리스트
------------------------------------------------------------*/
function fnInformList() {
    if (typeof objDashBoardInfromTable == "undefined") {
    	
    	objDashBoardInfromTable = IONPay.Ajax.CreateDataTable("#tbDashBoardInform", false, {
            url: '/home/dashboard/selectDashBoardInformList.do',
            data: function () {var objParam = {};return objParam;},
            columns: [
				{ "data": "RNUM", "class" : "column5c" },
				{ "data": "NOTI_NM", "class" : "column10c" },
				{ "data": null, "class" : "column40c", "render": fnHrefTitleNotice },
				{ "data": "REG_DT", "class" : "column15c" },
            ],
            ordering : false,
            paging: false,
            searching: false
        });
    }
    else{
    	objDashBoardInfromTable.clearPipeline();
    	objDashBoardInfromTable.ajax.reload();
    }
}

function fnHrefTitleNotice(data){
	var strHtml = "";
	
	strHtml = "<a href = '/businessMgmt/noticeMgmt/noticeMgmt.do?seq=" + data.SEQ + "'>" +data.TITLE+ "</a>";
	
	return strHtml;
}

/**------------------------------------------------------------
* 공지사항 리스트
------------------------------------------------------------*/
function fnQnaList() {
    if (typeof objDashBoardQnaTable == "undefined") {
    	
    	objDashBoardQnaTable = IONPay.Ajax.CreateDataTable("#tbDashBoardQna", false, {
            url: '/home/dashboard/selectDashBoardQnaList.do',
            data: function () {var objParam = {}; objParam["MER_ID"] = '<%=merId%>'; return objParam;},
            columns: [
                      { "data": "RNUM", "class" : "column5c" },
                      { "data": "QNA_TYPE", "class" : "column10c" },
                      { "data": null, "class" : "column40c", "render": fnHrefTitleQna },
                      { "data": null, "class" : "column15c", "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.REQ_DT)} },
                      { "data": null, "class" : "column15c", "render": function(data){return IONPay.Utils.fnStringToDateFormat(data.RES_DT)} },
            ],
            ordering : false,
            paging: false,
            searching: false
        });
    }
    else{
    	objDashBoardQnaTable.clearPipeline();
    	objDashBoardQnaTable.ajax.reload();
    }
}

function fnHrefTitleQna(data){
	var strHtml = "";
	
	strHtml = "<a href = '/businessMgmt/qnaMgmt/qnaMgmt.do?seq=" + data.SEQ + "'>" +data.HEAD+ "</a>";
	
	return strHtml;
}

/**------------------------------------------------------------
* 오늘의 입금액
------------------------------------------------------------*/
function fnTodayInput() {
	var strCallUrl   = "/home/dashboard/selectTodayInput.do";  //selectDashBoardSummaryList
	var strCallBack  = "fnTodayInoutRet";
    
    var objParam     = {};

    objParam["MER_ID"]     = '<%=merId%>';
    objParam["MERID_TYPE"] = '<%=merIdType%>';
    
    objParam["ISLOADING"]    = false;

    IONPay.Ajax.fnRequest(objParam, strCallUrl, strCallBack);
    
}

function fnTodayInoutRet(objJson){
	$("#spTodayInput").text(objJson.data[0].DPST_AMT + ' 원');
}
</script>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;" class="active"><spring:message code="IMS_DASHBOARD_0006" /></a></li>
                </ul>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
                <div class="row" style="margin-left:0px">
                    <div class="col-md-15">
                          <div class="row">
                            <!-- BEGIN CREDIT CARD -->
		                    <div class="col-md-5 col-vlg-5 m-b-10">
					            <div class="m-b-10">
					              <div class="tiles-body pay-method">
					              <div class="controller">
					              </div>
					                <div class="tiles-title">
					                	<div>
						                	<i class="fa fa-credit-card" aria-hidden="true"></i>
						                   	이롬머니
						                   	<div class="btn-group pull-right" data-toggle="buttons-radio">
						                       <button class="btn btn-xs btn-mini active" name="btnErom" data-type="1"><i class="fa fa-krw" aria-hidden="true"></i></button>
						                       <button class="btn btn-xs btn-mini" name="btnErom" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></i></button>
	                                       	</div>
					                	</div>
					                </div>
					                <div id="div-erom-amt" class="status-box">
						                <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper transparent">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span>
					                        <span id="spEromMoneyFirstNum" class="item-count animate-number semi-bold" data-url="/" data-value="0" data-animation-duration="0" style="cursor: pointer;">
					                        0
					                        </span>
					                      </div>
					                    </div>
					                    <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper last">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> 
					                        <span id="spEromMoneySecondNum" class="item-count animate-number semi-bold" data-url="/" data-value="0" data-animation-duration="0" style="cursor: pointer;">
					                        0
					                        </span>
					                     </div>
					                    </div>
					                </div>
					                <div id="div-erom-trx" class="status-box" style="display: none; ">
						                <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper transparent">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span>
					                        <span id="trEromMoneyFirstNum" class="item-count animate-number semi-bold" data-url="/" data-value="0" data-animation-duration="0" style="cursor: pointer;">
					                        0
					                        </span>
					                      </div>
					                    </div>
					                    <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper last">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> 
					                        <span id="trEromMoneySecondNum" class="item-count animate-number semi-bold" data-url="/" data-value="0" data-animation-duration="0" style="cursor: pointer;">
					                        0
					                        </span>
					                     </div>
					                    </div>
					                </div>
					              </div>
					            </div>
		                    </div>
		                    <!-- END CREDIT CARD -->
		                    <div class="col-md-5 col-vlg-5 m-b-10">
					            <div class="m-b-10">
					              <div class="tiles-body pay-method">
					              <div class="controller">
					              </div>
					                <div class="tiles-title">
					                	<div>
						                	<i class="fa fa-university" aria-hidden="true"></i>
						                   	오늘의 입금액
					                	</div>
					                </div>
					                <div id="div-credit-amt" class="status-box">
					                	<div style="text-align: center;padding-top: 20px;font-size: 20px;font-weight: bold">
					                    	<span id="spTodayInput" class=""data-value="0" data-animation-duration="0" style="cursor: pointer;">
					                    	0 원
					                    	</span>
					                    </div>
					                </div>
					                
					              </div>
					            </div>
		                    </div>
		                   
                          </div>
                     </div>
                </div>
                
                <!--  화원사 잔여한도 -->
<!--                 <div class="row" > -->
<!-- 	                <div class="col-md-12" style="padding: 0px;"> -->
<!-- 	                <div class="grid simple horizontal yellow"> -->
<!--                         <div class="grid-title"> -->
<!--                           <h4>회원사 잔여한도 </h4> -->
<!--                           <div class="tools"> <a href="javascript:;" class="collapse"></a></div> -->
<!--                         </div> -->
<!--                         <div class="grid-body"> -->
<!--                           	<div id="div-credit-amt" class="status-box"> -->
<!-- 		                		<div style="text-align: center;padding-top: 20px;font-size: 20px;"> -->
<!-- 		                			<span id="spTodayInput" class=""  data-value="0" data-animation-duration="0" style="cursor: pointer;padding-right:20px;"> -->
<!-- 				                    	회원사 현재 잔여한도 -->
<!-- 			                    	</span> -->
<!-- 			                    	<span id="spTodayInput" class=""  data-value="0" data-animation-duration="0" style="cursor: pointer; font-weight: bold"> -->
<!-- 			                    		0 원 -->
<!-- 			                    	</span> -->
			                    			                    	
<!-- 			                    </div> -->
<!-- 			                    <div style="float:right;padding-top:20px"> -->
<!-- 			                    	<button type="button" class="btn btn-primary btn-md">증액요청</button> 	 -->
<!-- 			                    </div> -->
<!-- 			                </div> -->
<!--                         </div> -->
<!--                       </div> -->
<!--                 </div> -->
                
                <!-- BEGIN Inform -->
			    <div class="row">
                   <div class="col-md-12">
                      <div class="grid simple horizontal yellow">
                        
                        <div class="grid-title"> 
                          <h4><span class="semi-bold">공지사항</span></h4>
                          <div class="tools"> <a href="javascript:;" class="collapse"></a></div>
                        </div>
                        <div style="float:right;padding:10px">
                        	<span style="font-weight:bold;color: blue"><a href = '/businessMgmt/noticeMgmt/noticeMgmt.do?pageCl="moreInfo"'>+더보기</a></span> 
                        </div>
                        <div class="grid-body">
                          <div class="row">
                            <table class="table" id="tbDashBoardInform" width="100%">
                                <thead>
                                 <tr>
                                     <th>순번</th>
                                     <th>구분</th>
                                     <th>제목</th>
                                     <th>일자</th>
                                 </tr>
                                </thead>
                            </table>
                          </div>
                        </div>
                      </div>
                    </div>
                </div>
                <!-- END Inform -->
                
                <!-- BEGIN Qna -->
			    <div class="row">
                   <div class="col-md-12">
                      <div class="grid simple horizontal yellow">
                        <div class="grid-title">
                          <h4><span class="semi-bold">1:1 상담이력</span></h4>
                          <div class="tools"> <a href="javascript:;" class="collapse"></a></div>
                        </div>
                        <div style="float:right;padding:10px">
                        	<span style="font-weight:bold;color: blue"><a href = '/businessMgmt/qnaMgmt/qnaMgmt.do?pageCl="moreInfo"'>+더보기</a></span> 
                        </div>
                        <div class="grid-body">
                          <div class="row">
                            <table class="table" id="tbDashBoardQna" width="100%">
                                <thead>
                                 <tr>
                                     <th>순번</th>
                                     <th>구분</th>
                                     <th>제목</th>
                                     <th>문의일자</th>
                                     <th>답변일자</th>
                                 </tr>
                                </thead>
                            </table>
                          </div>
                        </div>
                      </div>
                    </div>
                </div>
                <!-- END Inform -->
           </div>
           <!-- END PAGE -->
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
