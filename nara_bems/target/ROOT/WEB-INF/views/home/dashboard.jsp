<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objDashBoardTopMerchantAmtTable;
var objDashBoardTopMerchantCntTable;
var objDashBoardInDecreaseTable;

$(document).ready(function(){
	fnInitEvent();
});

function fnInitEvent(){
	var strInitPSWDFlag = "${sessionScope['IMSAdminPasswordChangeSession']}";

    if(strInitPSWDFlag == "Y"){
//         $("body").addClass("breakpoint-1024 pace-done modal-open ");
       $("#btnModalPSWDChg").click();
    }

    $("#btnPSWDChgModalBtn").on("click", function(){
       // $("body").addClass("breakpoint-1024 pace-done modal-open ");
        $("#btnModalPW").click();
    });
	// param : 결제수단, 일/월(금액/TR)
	fnSummaryList("CreditCard",1);
	fnSummaryList("Vacct",1);

	// 가맹점 전체 거래 현황 (금액)
	fnTransactionChart(1, 1);

	// 상위 가맹점 차트
    fnTopMerchantChart(1);

	// 상위가맹점 리스트
    fnCreateDashBoardTopMerchantAmtDataTables();

	// 거래 급증감 현황
    fnCreateDashBoardInDecreaseDataTables();

    // SummaryList 금액/TR 버튼
    $("button[name^='btnCredit']").click(function(){
    	var intSummaryType = $(this).data("type");
    	fnSummaryList("CreditCard", intSummaryType);
    	fnToggleSummaryList(intSummaryType, "#div-credit-amt", "#div-credit-trx");
    });

	$("button[name^='btnVacct']").click(function(){
		var intSummaryType = $(this).data("type");
    	fnSummaryList("Vacct", intSummaryType);
    	fnToggleSummaryList(intSummaryType, "#div-vacct-amt", "#div-vacct-trx");
	});

	$("button[name^='btnSettlement']").click(function(){
		var intSummaryType = $(this).data("type");
    	fnSummaryList("Settlement", intSummaryType);
    	fnToggleSummaryList(intSummaryType, "#div-settlement-amt", "#div-settlement-trx");
	});

	$("button[name^='btnBusiness']").click(function(){
		var intSummaryType = $(this).data("type");
    	fnSummaryList("Business", intSummaryType);
    	fnToggleSummaryList(intSummaryType, "#div-business-amt", "#div-business-trx");
	});

    // success/fail/refund 버튼
    $("button[name^='btnTransaction']").on("click", function(){
        var intSummaryType = $(this).data("type");
        var trxType = $("button[name^='btnTrx'].active").data("type");

        fnTransactionChart(intSummaryType, trxType);
    });

    $("button[name^='btnTrx']").on("click", function(){
        var strChartType = $("button[name^='btnTransaction'].active").data("type");
        var strTrxType = $(this).data("type");

    	fnTransactionChart(strChartType, strTrxType);
    });

    // btnTopMerchant 상위가맹점 금액/TR 버튼
    $("button[name^='btnTopMerchant']").on("click", function(){
        var intChartType = $(this).data("type");

        if(intChartType == 1){
            $("#divDashBoardTopMerchantAmt").show();
            $("#divDashBoardTopMerchantCnt").hide();

            fnCreateDashBoardTopMerchantAmtDataTables();
        } else {

            $("#divDashBoardTopMerchantAmt").hide();
            $("#divDashBoardTopMerchantCnt").show();

            fnCreateDashBoardTopMerchantCntDataTables();
        }

        fnTopMerchantChart(intChartType);
    });

    // 상위가맹점 출력 테이블 (금액)
    $("#tbDashBoardTopMerchantAmt").on("click", "[type=button]#btnTopMerchantMID", function(){
        var intChartType = $("button[name^='btnTopMerchant'].active").data("type");
        var strMID      = $(this).data("mid");
        var strMerName   = $(this).text();

        fnTopMerchantChart(intChartType, strMID, strMerName);
    });

    // 상위가맹점 출력 테이블 (TR)
    $("#tbDashBoardTopMerchantCnt").on("click", "[type=button]#btnTopMerchantMID", function(){
        var intChartType = $("button[name^='btnTopMerchant'].active").data("type");
        var strMID      = $(this).data("mid");
        var strMerName   = $(this).text();

        fnTopMerchantChart(intChartType, strMID, strMerName);
    });

    // 거래 급증/감 현황
    $("#tbDashBoardInDecrease").on("click", "[type=button]#btnTopMerchantMerName", function(){
    	var strUrl = $(this).data("url");
        $(location).attr("href", strUrl);
    });

    // 거래요약에서 숫자클릭시
    $(".item-count.animate-number").on("click", function(){
    	var strUrl = $(this).data("url");
    	$(location).attr("href", strUrl);
    });
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
* 대시보드 Transaction Chart
------------------------------------------------------------*/
function fnTransactionChart(strChartType, strTrxType){
	var objChartOption = {};

	objChartOption.CallUrl       = "/home/dashboard/selectDashBoardChart.do?";
	objChartOption.ChartType     = strChartType;
	objChartOption.TrxType		 = strTrxType;
	objChartOption.ChartID       = "divFillupChart";
	objChartOption.Title         = "";

	objChartOption.TitleV1       = "Credit Card";
	objChartOption.FieldV1       = "CREDIT_CARD";
	objChartOption.TitleV2       = "Account";
    objChartOption.FieldV2       = "ACCNT";
	objChartOption.TitleV3       = "Transfer";
	objChartOption.FieldV3       = "TRANSFER";
	objChartOption.TitleV4       = "Cash receipts";
    objChartOption.FieldV4       = "CSHR";
	objChartOption.TitleV5       = "Mobile";
    objChartOption.FieldV5       = "HP";
    objChartOption.TitleV6       = "Domestic Card";
    objChartOption.FieldV6       = "DOMESTIC_CARD";

    objChartOption.CategoryField = "TR_DT";

    fnAMCharts(objChartOption);
}

/**------------------------------------------------------------
* 대시보드 Top Merchant Chart
------------------------------------------------------------*/
function fnTopMerchantChart(intChartType, strMID, strMerName) {
    var objChartOption = {};
    var strSubTitle    = intChartType == 1 ? gMessage("IMS_DASHBOARD_0001") : gMessage("IMS_DASHBOARD_0002");
    var strTitle       = typeof strMID == "undefined" ? gMessage("IMS_DASHBOARD_0003") + " ("+strSubTitle+")" : strMerName + " " + gMessage("IMS_DASHBOARD_0004") + "("+strSubTitle+")";

    objChartOption.CallUrl       = "/home/dashboard/selectDashBoardTopMerchantChart.do?";
    objChartOption.ChartType     = intChartType;
    objChartOption.MID           = strMID;
    objChartOption.ChartID       = "divTopMerchantChart";
    objChartOption.Title         = strTitle;

    objChartOption.TitleV1       = gMessage("IMS_DASHBOARD_0038");
	objChartOption.FieldV1       = "CREDIT_CARD";
	objChartOption.TitleV2       = "Account";
    objChartOption.FieldV2       = "ACCNT";
	objChartOption.TitleV3       = gMessage("IMS_DASHBOARD_0039");
	objChartOption.FieldV3       = "TRANSFER";
	objChartOption.TitleV4       = "Cash receipts";
    objChartOption.FieldV4       = "CSHR";
	objChartOption.TitleV5       = "Mobile";
    objChartOption.FieldV5       = "HP";
    objChartOption.TitleV6       = "Domestic Card";
    objChartOption.FieldV6       = "DOMESTIC_CARD";
    objChartOption.CategoryField = "TR_DT";

    fnAMCharts(objChartOption);
}
/**------------------------------------------------------------
* 대시보드 Chart
------------------------------------------------------------*/
function fnAMCharts(objOption) {
	var strCallUrl = objOption.CallUrl;
	var strTitle   = "";
	var objParam   = {};
	var objJson;

	// CHART_TYPE = 1: 성공, 2: 실패, 4: 취소
	if(typeof objOption.ChartType != "undefined"){
		objParam["CHART_TYPE"] = objOption.ChartType;
	}

	// TRX_TYPE = 1: 금액, 2: TR
	if(typeof objOption.TrxType != "undefined"){
        objParam["TRX_TYPE"] = objOption.TrxType;
    }

	if(typeof objOption.MID != "undefined"){
        objParam["MID"] = objOption.MID;
    }

    objJson = AmCharts.loadJSON(strCallUrl, objParam, "IMS");

    var columnMixChart = AmCharts.makeChart(objOption.ChartID,
    {
        "type": "serial",
        "theme": "none",
        "startDuration": 1,
        "pathToImages": "/Bootstrap/assets/plugins/amcharts/images/",
        "dataProvider": objJson.data,
        "legend": {
            "useGraphSettings": true,
            "valueWidth" : 0
        },
        "titles": [
        {
            "size": 15,
            "text": objOption.Title
        }],
        "valueAxes": [{
            "id": "v1",
            "axisColor": "#DADADA",
            "axisThickness": 2,
            "axisAlpha": 0,
            "lineAlpha": 1,
            "position": "left"
        }],
        "graphs": [ {
            "valueAxis": "v1",
            "lineColor": "#1e40bc",
            "balloonText" : "[[title]]<br><span style='font-size:14px'><b>[[value]]</b></span>",
            "bullet": "round",
            "bulletBorderThickness": 1,
            "hideBulletsCount": 30,
            "title": objOption.TitleV1,
            "valueField": objOption.FieldV1,
            "fillAlphas": 0,
            "lineThickness" : 2
        }, {
            "valueAxis": "v2",
            "lineColor": "#FCD202",
            "balloonText" : "[[title]]<br><span style='font-size:14px'><b>[[value]]</b></span>",
            "bullet": "round",
            "bulletBorderThickness": 1,
            "hideBulletsCount": 30,
            "title": objOption.TitleV2,
            "valueField": objOption.FieldV2,
            "fillAlphas": 0,
            "lineThickness" : 2
        }, {
            "valueAxis": "v3",
            "lineColor": "#D9418C",
            "balloonText" : "[[title]]<br><span style='font-size:14px'><b>[[value]]</b></span>",
            "bullet": "round",
            "bulletBorderThickness": 1,
            "hideBulletsCount": 30,
            "title": objOption.TitleV3,
            "valueField": objOption.FieldV3,
            "fillAlphas": 0,
            "lineThickness" : 2
        }, /*{
            "valueAxis": "v4",
            "lineColor": "#3DB7CC",
            "balloonText" : "[[title]]<br><span style='font-size:14px'><b>[[value]]</b></span>",
            "bullet": "round",
            "bulletBorderThickness": 1,
            "hideBulletsCount": 30,
            "title": objOption.TitleV4,
            "valueField": objOption.FieldV4,
            "fillAlphas": 0,
            "lineThickness" : 2
        }, {
            "valueAxis": "v5",
            "lineColor": "#47C83E",
            "balloonText" : "[[title]]<br><span style='font-size:14px'><b>[[value]]</b></span>",
            "bullet": "round",
            "bulletBorderThickness": 1,
            "hideBulletsCount": 30,
            "title": objOption.TitleV5,
            "valueField": objOption.FieldV5,
            "fillAlphas": 0,
            "lineThickness" : 2
        }*/],
        "chartScrollbar": {},
        "chartCursor": {
            "cursorPosition": "mouse"
        },
        "categoryField": objOption.CategoryField,
        "categoryAxis": {
        	"gridPosition" : "start",
            "labelRotation": "45",
            "gridAlpha": 0,
            "fillAlpha": 1,
            "axisColor": "#DADADA",
            "minorGridEnabled": true
        }
    });

    if (typeof columnMixChart.dataProvider.length == "undefined" || 0 == columnMixChart.dataProvider.length) {
        columnMixChart.valueAxes[0].minimum = 0;
        columnMixChart.valueAxes[0].maximum = 100;

        var dataPoint = {
            dummyValue: 0
        };

        dataPoint[columnMixChart.categoryField] = "";
        columnMixChart.dataProvider = [dataPoint];

        columnMixChart.addLabel(0, "50%", gMessage("IMS_DASHBOARD_0005"), "center");

        columnMixChart.chartDiv.style.opacity = 0.5;

        columnMixChart.validateNow();
    }
}

/**------------------------------------------------------------
* 대시보드 Pie Chart
------------------------------------------------------------*/
function fnPieAMCharts(objOption) {
    var strCallUrl = "/home/dashboard/selectDashBoardPieChart.do?";
    var strTitle   = "";
    var objParam   = {};
    var objJson;

    objParam["CHART_TYPE"]   = objOption.ChartType;
    objParam["SUMMARY_TYPE"] = objOption.SummaryType;
    objParam["TRANS_DT"]     = objOption.TransDT;
    objJson                  = AmCharts.loadJSON(strCallUrl, objParam, "IMS");

    var pieChart = AmCharts.makeChart(objOption.ChartID, {
    		"type": "pie",
            "theme": "light",
            "dataProvider": objJson.data,
            "titles": [
                {
                    "size": 15,
                    "text": objOption.Title,
                    "fontFamily": "맑은 고딕"
                }],
            "legend": {
                "markerType": "circle",
                "valueWidth" : 0
            },
            "colors" : ["#ACACFD","#FCD202"],
            "valueField": objOption.ValueField,
            "titleField": objOption.TitleField,
            "startEffect" : "elastic",
            "startDuration" : 2,
            "lableRadius" : 15,
            "radius" : "30%",
            "innerRadius" : "50%",
            "balloonText": "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",
            "export": {
            	"enabled": true
            }
    });

    if (typeof pieChart.dataProvider.length == "undefined" || 0 == pieChart.dataProvider.length) {

    	pieChart.addLabel(0, "50%", gMessage("IMS_DASHBOARD_0005"), "center");

    	pieChart.chartDiv.style.opacity = 0.5;

    	pieChart.validateNow();
    }
}

/**------------------------------------------------------------
* 거래 상위 가맹점 리스트(금액)
------------------------------------------------------------*/
function fnCreateDashBoardTopMerchantAmtDataTables() {
    if (typeof objDashBoardTopMerchantAmtTable == "undefined") {
    	objDashBoardTopMerchantAmtTable = IONPay.Ajax.CreateDataTable("#tbDashBoardTopMerchantAmt", false, {
            url: '/home/dashboard/selectDashBoardTopMerchantList.do',
            data: function () {
            	var objParam = {};
            	objParam["CHART_TYPE"] = 1;
            	return objParam;
            },
            columns: [
                { "data": "RK", "class" : "column10c" },
                { "data": null, "render": fnCreateRenderMID, "class" : "column30c" },
                { "data": "APP_AMT", "render": IONPay.Utils.fnNumber(0), "class" : "column60r" },
            ],
            ordering : false,
            paging: false,
            dom: "rt"
        });
    }
    else{
    	objDashBoardTopMerchantAmtTable.clearPipeline();
    	objDashBoardTopMerchantAmtTable.ajax.reload();
    }
}

/**------------------------------------------------------------
* 거래 상위 가맹점 리스트(건수)
------------------------------------------------------------*/
function fnCreateDashBoardTopMerchantCntDataTables() {
    if (typeof objDashBoardTopMerchantCntTable == "undefined") {
    	objDashBoardTopMerchantCntTable = IONPay.Ajax.CreateDataTable("#tbDashBoardTopMerchantCnt", false, {
            url: '/home/dashboard/selectDashBoardTopMerchantList.do',
            data: function () {
                var objParam = {};
                objParam["CHART_TYPE"] = 2;
                return objParam;
            },
            columns: [
                { "data": "RK", "class" : "column10c" },
                { "data": null, "render": fnCreateRenderMID, "class" : "column30c" },
                { "data": "TRX_CNT", "render": IONPay.Utils.fnNumber(0), "class" : "column60r" },
            ],
            ordering : false,
            paging: false,
            dom: "rt"
        });
    }
    else{
    	objDashBoardTopMerchantCntTable.clearPipeline();
    	objDashBoardTopMerchantCntTable.ajax.reload();
    }
}objDashBoardInDecreaseTable

/**------------------------------------------------------------
* 거래 상위 가맹점 리스트 MID Render
------------------------------------------------------------*/
function fnCreateRenderMID(data){
    var strHtml = "";
    strHtml = "<button id='btnTopMerchantMID' type='button' class='btn btn-link btn-cons no-margin' data-type='1' data-mid='" + data.MID + "'>" + data.BRAND_NM + "</button>";
    return strHtml;
}

/**------------------------------------------------------------
* 거래 급증/금감 현황
------------------------------------------------------------*/
function fnCreateDashBoardInDecreaseDataTables() {
    if (typeof objDashBoardInDecreaseTable == "undefined") {
    	objDashBoardInDecreaseTable = IONPay.Ajax.CreateDataTable("#tbDashBoardInDecrease", false, {
            url: '/home/dashboard/selectDashBoardInDecreaseList.do',
            data: function () {var objParam = {};return objParam;},
            columns: [
                { "data": "RNUM", "class" : "column10c" },
                { "data": null, "render": fnCreateRenderMerName, "class" : "column20c" },
                { "data": "MID", "class" : "column15c" },
                { "data": "CONT_EMP_NM", "class" : "column15c" },
                { "data": "VARIATION_AMT", "render": IONPay.Utils.fnNumber(0), "class" : "column20r" },
                { "data": null, "render": function(data){return IONPay.Utils.fnAddComma(data.VARIATION_RATE) + "%"}, "class" : "column20r" }
            ]
        });
    }
    else{
    	objDashBoardInDecreaseTable.clearPipeline();
    	objDashBoardInDecreaseTable.ajax.reload();
    }
}

/**------------------------------------------------------------
* 거래 상위 가맹점 리스트 Merchant Name Render
------------------------------------------------------------*/
function fnCreateRenderMerName(data){
    var strHtml = "";
    strHtml = "<button id='btnTopMerchantMerName' type='button' class='btn btn-link btn-cons no-margin' data-url='/riskMgmt/tradingSensitizedMgmt/tradingSensitizedMgmt.do?term=d&mername=" + data.MER_NAME + "' data-mid='" + data.MID + "'>" + data.BRAND_NM + "</button>";
    return strHtml;
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
                <div class="row">
                    <div class="col-md-12">
                          <div class="row">
                            <!-- BEGIN CREDIT CARD -->
		                    <div class="col-md-3 col-vlg-3 m-b-10">
					            <div class="m-b-10">
					              <div class="tiles-body pay-method">
					              <div class="controller">
					              </div>
					                <div class="tiles-title">
					                	<div>
						                	<i class="fa fa-credit-card" aria-hidden="true"></i>
						                   	<spring:message code="IMS_DASHBOARD_0007" />
						                   	<div class="btn-group pull-right" data-toggle="buttons-radio">
						                       <button class="btn btn-xs btn-mini active" name="btnCredit" data-type="1"><i class="fa fa-krw" aria-hidden="true"></i></button>
						                       <button class="btn btn-xs btn-mini" name="btnCredit" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></i></button>
	                                       	</div>
					                	</div>
					                </div>
					                <div id="div-credit-amt" class="status-box">
						                <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper transparent">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span><span id="spCreditCardFirstNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=c&term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
					                      </div>
					                    </div>
					                    <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper last">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="spCreditCardSecondNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=c&term=m" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
					                     </div>
					                    </div>
					                </div>
					                <div id="div-credit-trx" class="status-box" style="display: none; ">
						                <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper transparent">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span><span id="trCreditCardFirstNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=c&term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
					                      </div>
					                    </div>
					                    <div class="widget-stats text-center col-xs-6">
					                      <div class="wrapper last">
					                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="trCreditCardSecondNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=c&term=m" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
					                     </div>
					                    </div>
					                </div>
					              </div>
					            </div>
		                    </div>
		                    <!-- END CREDIT CARD -->
		                    <!-- BEGIN VACCT -->
		                    <div class="col-md-3 col-vlg-3 m-b-10">
                                <div class="m-b-10">
                                  <div class="tiles-body pay-method">
                                  <div class="controller"></div>
                                    <div class="tiles-title">
                                        <div>
                                        	<i class="fa fa-id-card-o" aria-hidden="true"></i>
	                                        <spring:message code="IMS_DASHBOARD_0012" />
	                                        <div class="btn-group pull-right" data-toggle="buttons-radio">
	                                           <button class="btn btn-xs btn-mini active" name="btnVacct" data-type="1"><i class="fa fa-krw" aria-hidden="true"></i></button>
						                       <button class="btn btn-xs btn-mini" name="btnVacct" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></i></button>
	                                        </div>
                                        </div>
                                    </div>
                                    <div id="div-vacct-amt" class="status-box">
	                                    <div class="widget-stats text-center col-xs-6">
	                                      <div class="wrapper transparent">
	                                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span> <span id="spVacctFirstNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=v&term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
	                                      </div>
	                                    </div>
	                                    <div class="widget-stats text-center col-xs-6">
	                                      <div class="wrapper last">
	                                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="spVacctSecondNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=v&term=m" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
	                                     </div>
	                                    </div>
                                    </div>
                                    <div id="div-vacct-trx" class="status-box" style="display: none;">
	                                    <div class="widget-stats text-center col-xs-6">
	                                      <div class="wrapper transparent">
	                                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span> <span id="trVacctFirstNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=v&term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
	                                      </div>
	                                    </div>
	                                    <div class="widget-stats text-center col-xs-6">
	                                      <div class="wrapper last">
	                                        <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="trVacctSecondNum" class="item-count animate-number semi-bold" data-url="/tradingViews/transactionHistory/transactionHistory.do?paymethod=v&term=m" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
	                                     </div>
	                                    </div>
                                    </div>
                                  </div>
                                </div>
		                    </div>
		                    <!-- END VACCT -->
		                    <!-- BEGIN SETTLEMENT -->
		                    <div class="col-md-3 col-vlg-3 m-b-10">
				                <div class="m-b-10">
                                  <div class="tiles-body pay-method">
                                  <div class="controller"></div>
                                    <div class="tiles-title">
                                    	<div>
	                                    	<i class="fa fa-calendar"></i>
	                                    	<spring:message code="IMS_DASHBOARD_0013" />
	                                    	<div class="btn-group pull-right" data-toggle="buttons-radio">
						                       <button class="btn btn-xs btn-mini active" name="btnSettlement" data-type="1"><i class="fa fa-krw" aria-hidden="true"></i></button>
						                       <button class="btn btn-xs btn-mini" name="btnSettlement" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></i></button>
	                                       	</div>
                                    	</div>
                                    </div>
                                    <div id="div-settlement-amt" class="status-box">
                                    	<div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper transparent">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span> <span id="spSettlementFirstNum" class="item-count animate-number semi-bold" data-url="/settlementMgmt/settlementReport/settlementReport.do?term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                          </div>
                                        </div>
                                        <div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper last">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="spSettlementSecondNum" class="item-count animate-number semi-bold" data-url="/depositMgmt/creditCardPaymentReport/creditCardPaymentReport.do" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                         </div>
                                        </div>
                                    </div>
                                    <div id="div-settlement-trx" class="status-box" style='display: none;'>
                                    	<div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper transparent">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span> <span id="trSettlementFirstNum" class="item-count animate-number semi-bold" data-url="/settlementMgmt/settlementReport/settlementReport.do?term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                          </div>
                                        </div>
                                        <div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper last">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="trSettlementSecondNum" class="item-count animate-number semi-bold" data-url="/depositMgmt/creditCardPaymentReport/creditCardPaymentReport.do" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                         </div>
                                        </div>
                                    </div>
                                  </div>
                                </div>
		                    </div>
		                    <!-- END SETTLEMENT -->
		                    <!-- BEGIN BUSINESS -->
		                    <div class="col-md-3 col-vlg-3 m-b-10">
                                <div class="m-b-10">
                                  <div class="tiles-body pay-method">
                                  <div class="controller"></div>
                                    <div class="tiles-title">
                                    	<div>
	                                    	<i class="fa fa-money"></i>
	                                    	<spring:message code="IMS_DASHBOARD_0016" />
	                                    	<div class="btn-group pull-right" data-toggle="buttons-radio">
						                       <button class="btn btn-xs btn-mini active" name="btnBusiness" data-type="1"><i class="fa fa-krw" aria-hidden="true"></i></button>
						                       <button class="btn btn-xs btn-mini" name="btnBusiness" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></button>
	                                       </div>
                                    	</div>
                                    </div>
                                    <div id="div-business-amt" class="status-box">
                                    	<div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper transparent">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span> <span id="spBusinessFirstNum" class="item-count animate-number semi-bold" data-url="/businessMgmt/newContractMgmt/newContractMgmt.do?term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                          </div>
                                        </div>
                                        <div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper last">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="spBusinessSecondNum" class="item-count animate-number semi-bold" data-url="/businessMgmt/newContractMgmt/newContractMgmt.do?term=m" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                         </div>
                                        </div>
                                    </div>
                                    <div id="div-business-trx" class="status-box" style="display: none;">
                                    	<div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper transparent">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0010" /></span> <span id="trBusinessFirstNum" class="item-count animate-number semi-bold" data-url="/businessMgmt/newContractMgmt/newContractMgmt.do?term=d" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                          </div>
                                        </div>
                                        <div class="widget-stats text-center col-xs-6">
                                          <div class="wrapper last">
                                            <span class="item-title"><spring:message code="IMS_DASHBOARD_0011" /></span> <span id="trBusinessSecondNum" class="item-count animate-number semi-bold" data-url="/businessMgmt/newContractMgmt/newContractMgmt.do?term=m" data-value="0" data-animation-duration="0" style="cursor: pointer;">0</span>
                                         </div>
                                        </div>
                                    </div>
                                  </div>
                                </div>
                            </div>
                            <!-- END BUSINESS -->
                          </div>
                     </div>
                </div>
                <!-- BEGIN TRANSACTION INCREASE/DECREASE -->
			    <div class="row">
                   <div class="col-md-12">
                      <div class="grid simple horizontal yellow">
                        <div class="grid-title">
                          <h4><spring:message code="IMS_DASHBOARD_0027" /> <span class="semi-bold"><spring:message code="IMS_DASHBOARD_0033" /></span></h4>
                          <div class="tools"> <a href="javascript:;" class="collapse"></a></div>
                        </div>
                        <div class="grid-body">
                          <div class="row">
                            <table class="table" id="tbDashBoardInDecrease" width="100%">
                                <thead>
                                 <tr>
                                     <th><spring:message code="IMS_DASHBOARD_0029" /></th>
                                     <th><spring:message code="IMS_DASHBOARD_0030" /></th>
                                     <%-- <th><spring:message code="IMS_DASHBOARD_0034" /></th> --%>
                                     <th>I-MID</th>
                                     <th><spring:message code="IMS_BM_CM_0049" /></th>
                                     <th><spring:message code="IMS_DASHBOARD_0035" /></th>
                                     <th><spring:message code="IMS_DASHBOARD_0036" /></th>
                                 </tr>
                                </thead>
                            </table>
                          </div>
                        </div>
                      </div>
                    </div>
                </div>
                <!-- END TRANSACTION INCREASE/DECREASE -->
                <!-- BEGIN TOP MERCHANT CHART -->
                <div class="row">
                    <div class="col-md-12">
                      <div class="grid simple horizontal red">
                        <div class="grid-title">
                          <h4><spring:message code="IMS_DASHBOARD_0027" /> <span class="semi-bold"><spring:message code="IMS_DASHBOARD_0028" /></span></h4>
                          <div class="tools">
                             <a href="javascript:;" class="collapse"></a>
                          </div>
                        </div>
                        <div class="grid-body">
                          <div class="row">
                            <div class="col-md-4">
                                <div class="semi-bold pull-left"><h4></h4></div>
                                <div class="btn-group pull-right p-b-30" data-toggle="buttons-radio">
                                   <button class="btn btn-xs btn-mini active" name="btnTopMerchant" data-type="1"><i class="fa fa-krw" aria-hidden="true"></i></button>
                                   <button class="btn btn-xs btn-mini" name="btnTopMerchant" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></button>
                                </div>
                                <div id="divDashBoardTopMerchantAmt">
                                    <table class="table" id="tbDashBoardTopMerchantAmt" width="100%">
	                                    <thead>
	                                     <tr>
	                                         <th><spring:message code="IMS_DASHBOARD_0029" /></th>
	                                         <th><spring:message code="IMS_DASHBOARD_0030" /></th>
	                                         <th><spring:message code="IMS_DASHBOARD_0031" /></th>
	                                     </tr>
	                                    </thead>
	                                </table>
                                </div>
                                <div id="divDashBoardTopMerchantCnt" style="display:none;">
                                    <table class="table" id="tbDashBoardTopMerchantCnt" width="100%">
                                        <thead>
                                         <tr>
                                             <th><spring:message code="IMS_DASHBOARD_0029" /></th>
                                             <th><spring:message code="IMS_DASHBOARD_0030" /></th>
                                             <th><spring:message code="IMS_DASHBOARD_0032" /></th>
                                         </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div id="divTopMerchantChart" style="width:100%;height:450px;"></div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                </div>
                <!-- END TOP MERCHANT CHART -->
                <!-- BEGIN CHART -->
                <div class="row">
                    <div class="col-md-12">
			          <div class="grid simple horizontal red">
			            <div class="grid-title">
			              <h4><spring:message code="IMS_DASHBOARD_0017" /> <span class="semi-bold"><spring:message code="IMS_DASHBOARD_0018" /></span></h4>
			              <div class="tools">
			                 <a href="javascript:;" class="collapse"></a>
			              </div>
			            </div>
			            <div class="grid-body">
			              <div class="row">
			              	<div class="btn-group pull-left p-b-30" data-toggle="buttons-radio">
                               <button class="btn btn-xs btn-mini active" name="btnTrx" data-type="1"><i class="fa fa-krw" aria-hidden="true"></i></button>
                               <button class="btn btn-xs btn-mini" name="btnTrx" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></button>
                            </div>
			                <div class="btn-group pull-right" data-toggle="buttons-radio">
                               <button class="btn btn-primary active" name="btnTransaction" data-type="1"><spring:message code="IMS_DASHBOARD_0019" /></button>
                               <button class="btn btn-warning" name="btnTransaction" data-type="2"><spring:message code="IMS_DASHBOARD_0020" /></button>
                               <button class="btn btn-danger" name="btnTransaction" data-type="4"><spring:message code="IMS_DASHBOARD_0022" /></button>
                            </div>
                            <div id="divFillupChart" style="width:100%;height:450px;"></div>
			              </div>
			            </div>
			          </div>
			        </div>
			    </div>
			    <!-- END CHART -->
			    <!-- BEGIN PAYMENT TYPE -->
			    <!--
			    <div class="row">
			       <div class="col-md-4">
                      <div class="grid simple horizontal green">
                        <div class="grid-title">
                          <h4><spring:message code="IMS_DASHBOARD_0023" /> <span class="semi-bold"><spring:message code="IMS_DASHBOARD_0024" /></span></h4>
                          <div class="tools"> <a href="javascript:;" class="collapse"></a></div>
                        </div>
                        <div class="grid-body">
                          <div class="row">
                            <div class="col-md-12">
                             <div class="no-padding pull-left">
	                             <div class="btn-group pull-left" data-toggle="buttons-radio">
	                                 <button class="btn btn-xs btn-mini active" name="btnPaymentType" data-type="1"><i class="fa fa-krw"></i></button>
	                                 <button class="btn btn-xs btn-mini" name="btnPaymentType" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></button>
	                             </div>
                             </div>
                             <div class="input-append success date col-md-4 pull-right p-r-30">
                                  <input type="text" id="txtPaymentTypeYMD" name="PAYMENT_TYPE_YMD" class="form-control" data-type="1">
                                  <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                             </div>
                             <div id="divPaymentTypePieChart" style="width:100%;height:450px;"></div>
                          </div>
                         </div>
                        </div>
                      </div>
                   </div>
                   <div class="col-md-8">
	                   <div class="grid simple horizontal purple">
	                       <div class="grid-title">
	                         <h4><spring:message code="IMS_DASHBOARD_0025" /> <span class="semi-bold"><spring:message code="IMS_DASHBOARD_0026" /></span></h4>
	                         <div class="tools"> <a href="javascript:;" class="collapse"></a></div>
	                       </div>
	                       <div class="grid-body">
	                         <div class="row">
	                           <div class="col-md-6">
	                                <div class="no-padding pull-left">
	                                    <div class="btn-group pull-left" data-toggle="buttons-radio">
	                                         <button class="btn btn-xs btn-mini active" name="btnTopBankCredit" data-type="1"><i class="fa fa-krw"></i></button>
	                                         <button class="btn btn-xs btn-mini" name="btnTopBankCredit" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></button>
	                                    </div>
	                                </div>
	                                <div class="input-append success date col-md-4 pull-right p-r-30">
	                                   <input type="text" id="txtCreditCardYMD" name="TOP_BANK_CREDIT_YMD" class="form-control" data-type="1">
	                                   <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
	                                </div>
	                                <div id="divCreditCardPieChart" style="width:100%;height:450px;"></div>
	                           </div>
	                           <div class="col-md-6">
	                                <div class="no-padding pull-left">
	                                    <div class="btn-group pull-left" data-toggle="buttons-radio">
	                                         <button class="btn btn-xs btn-mini active" name="btnTopBankTransfer" data-type="1"><i class="fa fa-krw"></i></button>
	                                         <button class="btn btn-xs btn-mini" name="btnTopBankTransfer" data-type="2"><spring:message code="IMS_DASHBOARD_0009" /></button>
	                                    </div>
	                                </div>
	                                <div class="input-append success date col-md-4 pull-right p-r-30">
	                                   <input type="text" id="txtTransferYMD" name="TOP_BANK_TRANSFER_YMD" class="form-control" data-type="1">
	                                   <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
	                                </div>
	                                <div id="divTransferPieChart" style="width:100%;height:450px;"></div>
                               </div>
	                         </div>
	                       </div>
	                   </div>
                   </div>
			    </div>
			     -->
			    <!-- END PAYMENT TYPE -->
                <!-- END PAGE FORM -->
           </div>
           <!-- END PAGE -->
        </div>
        <!-- BEGIN PAGE CONTAINER-->
    <!-- END CONTAINER -->
