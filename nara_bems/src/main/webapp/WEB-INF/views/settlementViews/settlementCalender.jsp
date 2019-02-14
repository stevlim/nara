<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<script type="text/javascript">
var gobjJson;

$(document).ready(function() {
    fnSetDDLB();
    fnInitEvent();
    modalClose();
});

function fnSetDDLB() {
    $("#selIMID").html("<c:out value='${MERCHANT_ID_FOR_SEARCH}' escapeXml='false' />");
    
    $("#yyyyList").html("<c:out value='${YYYY_LIST}' escapeXml='false' />");
    $("#mmList").html("<c:out value='${MM_LIST}' escapeXml='false' />");
    
    //alert($("#todayMm").val());
    $("#yyyyList").select2("val", $("#todayYyyy").val());
    $("#mmList").select2("val", $("#todayMm").val());
    
}

function fnInitEvent() {
    strDateFormat = "mm-yyyy";
    
    $("#btnSearch").on("click", function(){
        $("#divGridArea").show(200);
        //nicepay.Utils.fnHideSearchOptionArea();
        if ($("#searchCollapse").attr("class") == "collapse") {
            $("#searchCollapse").click();
        }
        
        //nicepay.Utils.fnShowSearchArea();
        el = jQuery("#div_search .grid .tools").parents(".grid").children(".grid-body");
	    jQuery("#div_search .grid .tools .expand").removeClass().addClass("collapse");
	    el.slideDown(200);
	    $("#div_searchResult").show(200);
	    
	    var queryDate = $("#yyyyList option:selected").val() + "-" + $("#mmList option:selected").val() + "-" + "01",
	    dateParts = queryDate.match(/(\d+)/g)
	    realDate = new Date(dateParts[0], dateParts[1] - 1, dateParts[2]);

	    $("#txtSetMonth").datepicker({
            format: strDateFormat,
            autoclose: true,
            todayHighlight: true
        }).datepicker("setDate", new Date (queryDate));
	       
	    var objParam       = {};
	    
	    objParam["SET_MONTH"] = $("#mmList option:selected").val() + "-" + $("#yyyyList option:selected").val();
        objParam["I_MID"]     = $("#selIMID").val();
        
        setTimeout(function(){//alert("213123123");
            //fnSetCalender();
        	fnSetCalender(objParam);
        }, 300);
    });
    
    $("#btnPrint").on("click", function(){
        fnPrint();
    });
    
    $("#btnDetailSettlement").on("click", function(){
        var objParam           = {};
        var strChkExcelCallUrl = "/settlementViews/settlementCalender/selectPerMerchantReportExcelCnt.do";
        var strExcelCallUrl    = "/settlementViews/settlementCalender/selectPerMerchantReportExcelList.do";
        
        objParam["MMSRequestVerificationToken"] = nicepay.AntiCSRF.getVerificationToken();
        objParam["SETTLMNT_DT"]                = $("#spSettlmntDT").text();
        objParam["I_MID"]                      = $("#selIMID").val();
        
        $.post(strChkExcelCallUrl, $.param(objParam)).done(function (objJson) {
            if (objJson.resultCode == 0) {
                if(objJson.ResultCnt > 50000) {
                	nicepay.Msg.fnAlertWithModal(gMessage("MMS_SV_SC_0018"), "divDetailSettleConfirm", true);
                }
                
                nicepay.Ajax.fnRequestExcel(objParam, strExcelCallUrl);
            } else {
                nicepay.Msg.fnAlertWithModal(nicepay.COMMONERRORMSG, "divDetailSettleConfirm", true);
            }
        }).fail(function () {
        	nicepay.Msg.fnAlertWithModal(nicepay.AJAXERRORMSG, "divDetailSettleConfirm", true);
        });
    });
    
    $("#calender-prev").click(function(){
    	//$("body").addClass("breakpoint-1024 pace-done modal-open ");
    	var objCurrentDate = "";
    	var objParam       = {};
    	
    	$("#divCalendar").fullCalendar("prev");
    	objCurrentDate = $("#divCalendar").fullCalendar("getDate");
    	
    	$("#txtSetMonth").datepicker({
            format: strDateFormat,
            autoclose: true,
            todayHighlight: true
        }).datepicker("setDate", objCurrentDate);
        
        objCurrentDate        = $("#divCalendar").fullCalendar("getDate");   
        objParam["SET_MONTH"] = $.fullCalendar.formatDate(objCurrentDate, "MM-yyyy");
        objParam["I_MID"]     = $("#selIMID").val();
        
        setTimeout(function(){
        	fnSetCalender(objParam);
        }, 300);
    });
    
    $("#calender-next").click(function(){
    	 var objCurrentDate = "";
         var objParam       = {};
        
        $("#divCalendar").fullCalendar("next");
        objCurrentDate = $("#divCalendar").fullCalendar("getDate");
        
        $("#txtSetMonth").datepicker({
            format: strDateFormat,
            autoclose: true,
            todayHighlight: true
        }).datepicker("setDate", objCurrentDate);
        
        objCurrentDate        = $("#divCalendar").fullCalendar("getDate");
        objParam["SET_MONTH"] = $.fullCalendar.formatDate(objCurrentDate, "MM-yyyy");
        objParam["I_MID"]     = $("#selIMID").val();
        
        setTimeout(function(){
            fnSetCalender(objParam);
        }, 300);
    });
    
    initStartCalender();
}

// 페이지 호출시 바로 달력이 보이게
function initStartCalender(){
	$("#divGridArea").show(200);
    //nicepay.Utils.fnHideSearchOptionArea();
    if ($("#searchCollapse").attr("class") == "collapse") {
            $("#searchCollapse").click();
        }
    
    //nicepay.Utils.fnShowSearchArea();
    	el = jQuery("#div_search .grid .tools").parents(".grid").children(".grid-body");
	    jQuery("#div_search .grid .tools .expand").removeClass().addClass("collapse");
	    el.slideDown(200);
	    $("#div_searchResult").show(200);
	    
    setTimeout(function(){
        fnSetCalender();
    }, 300);
}

/**------------------------------------------------------------
* 정산 달력 인쇄
------------------------------------------------------------*/
function fnPrint() {
	var objData      = {};
	var $objPrintDiv = $("#div_print");
	var strPrintHtml = $("#divCalendar").html(); // 정산 달력 원본 html
	var strHeadHtml  = "<html><head></head><body>";	
	var strEndHtml   = "</body></html>";
	var strHtml      = "";
	
	$objPrintDiv.html(strPrintHtml); // 인쇄용 Div에 정산 당력 원본 html 삽입
	
	$("#div_print .fc-event-container").remove(); // 인쇄용 Div에서 이벤트 영역 삭제
	
	$objPrintDiv.children(".fc-content").find("th, td").each(function() { // 인쇄용 Div 편집
		var strDate = $(this).attr("data-date");
	
		$(this).removeClass(); // 스타일 삭제
		$(this).attr("style", "border:1px solid black; width:14%;"); // td width 설정
		
		$(this).find("div").each(function() { // 달력 html table 내 div 편집
			var strClassName = $(this).attr("class");
		
			objData = fnGetDateContent(strDate);
		
			$(this).attr("style", ""); // min-height: 15px; 삭제
			
			if (strClassName == "fc-day-number") { // 일자 출력부 재설정
			    $(this).attr("style", "min-height: 15px; text-align:right; "+ (objData["ISHOLIDAY"] ? "color:red;" : "") +" font-weight:bold;");
			} else if (strClassName == "fc-day-content") { // 내용 출력부 재설정
			    $(this).attr("style", "min-height: 80px; paddint-top:10px;");
			    $(this).html(objData["SETTLMNT_AMT"] == "0" ? "" : objData["SETTLMNT_AMT"]);
			    $(this).append(objData["MEMO"] != undefined && objData["MEMO"] != "null" ? "<p>" + objData["MEMO"] + "</p>" : "");
			}			
		});
	});
	
	strHtml = strHeadHtml + $objPrintDiv.html() + strEndHtml;
	
	window.frames["print_frame"].document.body.innerHTML = strHtml;
	window.frames["print_frame"].window.print();
}

function fnGetDateContent(strDate) {
	var arrRetContent = {};
	var objData;
	
	try {	
		for(var i=0; i<gobjJson.data.length; i++) {
			objData = gobjJson.data[i];
			
			if (objData.START_DAY == strDate) {
				arrRetContent["ISHOLIDAY"]    = objData.HOLIDAY_TYPE == "2" ? true : false;
				arrRetContent["SETTLMNT_AMT"] = nicepay.Utils.fnAddComma(objData.SETTLMNT_AMT);
				arrRetContent["MEMO"]         = objData.MEMO;
				
				break;
			}
		}
	} catch(ex) {}
	
	return arrRetContent;
}

/**------------------------------------------------------------
* 정산 달력 출력
------------------------------------------------------------*/
function fnSetCalender(objParam) {
    $('#divCalendar').html("");
    
    $('#divCalendar').fullCalendar({
        header: {
        	left: 'prev,next today',
            center: 'title',
            right: ''
        },
        height:650,
        contentHeight:600,
        events: function(start, end, callback){
        	
        	arrParameter = $("#frmSettlementCalender").serializeObject();
        	arrParameter["worker"] = $("#WORKER").val();
        	
            strCallUrl   = "/settlementViews/settlementCalender/selectSettlementCalenderList.do";
            strCallBack  = "fnSetCalenderAfter";
            IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
            
        },
        eventClick: function(calEvent, jsEvent, view){
            if(typeof calEvent.backgroundColor == "undefined"){
                var strSettlmntDT = calEvent.start.format("dd-MM-yyyy");
                $("#spSettlmntDT").text(strSettlmntDT);
                $('#divDetailSettleConfirm').modal('show');
                fnSelectSettlementDetailList(strSettlmntDT);
                // 상세내역 클릭시 body 스크롤 제거
                $("html, body").css({'overflow' : "hidden", 'height': '100%'});
            }
        },
        editable: false,
        droppable: false, 
        drop: function(date, allDay) {
            var originalEventObject = $(this).data('eventObject');
            var copiedEventObject   = $.extend({}, originalEventObject);
            
            copiedEventObject.start  = date;
            copiedEventObject.allDay = allDay;
            
            $('#divCalendar').fullCalendar('renderEvent', copiedEventObject, true);
            
            if ($('#drop-remove').is(':checked')) {
                $(this).remove();
            }
        }
    });
    
}

function fnSetCalenderAfter(objJson){
	//success part
	var bgColor = ['#ff8080'
	               ,'#8080ff'
	               ,'#00cc44'
	               ,'#e600e6'
	               ,'#ffad33'

	               ,'#00b3b3'
	               ,'#77b300'
	               ,'#7575a3'
	               ,'#99994d'
	               ,'#e60073'];
	var events = [];
    //alert(objJson.resultCode);
    
    if(objJson.resultCode == 0){
    	//매출 리스트
    	for(var i=0; i<objJson.data.length; i++){
    		var objData = objJson.data[i];
    	
    		if(objData.STMT_DT!=null && objData.STMT_DT!="" && objData.DATA_TYPE=="S") {
    			var periodDtFormat = "";
    			periodDtFormat = objData.STMT_DT.substring(0, 4) + "-" + objData.STMT_DT.substring(4, 6) + "-" + objData.STMT_DT.substring(6, 8);
    		
    			$('.fc-day[data-date="'+ periodDtFormat +'"] div .fc-day-content').after("<div align='right' class='settle' name='" + objData.DPST_AMT 
        				+ "S' style='background-color: #8080ff; "
        		
        				+ " color: #ffffff;' "
        				
        				+ ' onClick="fnCalenderSettDetail(\'' + objData.MEMO + '\' '
        				+ ' , \'' + objData.DPST_AMT + '\', \'' + objData.APP_AMT + '\', \'' + objData.CC_AMT + '\', \'' + objData.TOT_AMT + '\', \'' + objData.RESR_AMT + '\' '		
        				+ ' , \'' + objData.RESR_CC_AMT + '\', \'' + objData.EXTRA_AMT + '\', \'' + objData.FEE + '\', \'' + objData.VAT + '\')" 	 '
        				
        				+ "'>" 
        				+ objData.MEMO + "<br>" 
        				+ IONPay.Utils.fnAddComma(objData.DPST_AMT) + "원" 
        				+ "</div>");
        	}	
    	}
    
    	//입금 리스트    
    	for(var i=0; i<objJson.data.length; i++){
    		var objData = objJson.data[i];
    	
    		if(objData.STMT_DT!=null && objData.STMT_DT!="" && objData.DATA_TYPE=="D") {
    			var periodDtFormat = "";
    			periodDtFormat = objData.STMT_DT.substring(0, 4) + "-" + objData.STMT_DT.substring(4, 6) + "-" + objData.STMT_DT.substring(6, 8);
    		
    			$('.fc-day[data-date="'+ periodDtFormat +'"] div .fc-day-content').after("<div align='right' class='deposit' name='" + objData.DPST_AMT 
        				+ "D' style='background-color: #ff8080; "
        		
        				+ " color: #ffffff;' "
        				
        				+ ' onClick="fnCalenderDetail(\'' + objData.MEMO + '\' '
        				+ ' , \'' + objData.DPST_AMT + '\', \'' + objData.APP_AMT + '\', \'' + objData.CC_AMT + '\', \'' + objData.TOT_AMT + '\', \'' + objData.RESR_AMT + '\' '		
        				+ ' , \'' + objData.RESR_CC_AMT + '\', \'' + objData.EXTRA_AMT + '\', \'' + objData.FEE + '\', \'' + objData.VAT + '\')" 	 '
        				
        				+ "'>" 
        				+ objData.MEMO + "<br>" 
        				+ IONPay.Utils.fnAddComma(objData.DPST_AMT) + "원" 
        				+ "</div>");
        	}
    	}
    	
        gobjJson = objJson;
        
        //callback(events);
        
        $(".fc-event-inner").hover(function(){$(this).css("cursor","pointer");});
       
        
        for(var dd=1; dd<32; dd++) {
    		var yyyyVal = "";
    		var mmVal = "";
    		var ddVal = "";
    		var yyyyMmDdVal = "";
    		
    		if(String(dd).length>1) {
    			ddVal = String(dd);
    		}else {
    			ddVal = "0" + String(dd);
    		}
    		
    		/* yyyyVal = $("#searchYyyy").val();
    		mmVal = $("#searchMm").val();
    		
    		if(yyyyVal == "") {
    			yyyyVal = $("#todayYyyy").val();
    		}
    		
    		if(mmVal == "") {
    			mmVal = $("#todayMm").val();
    		} */
    		
    		yyyyVal = $("#yyyyList").val();
    		mmVal = $("#mmList").val();
    		
    		
    		yyyyMmDdVal = yyyyVal + "-" + mmVal + "-" + ddVal;
    		//alert(yyyyMmDdVal + " : " + $('.fc-day[data-date="'+ yyyyMmDdVal +'"] div .deposit').length);
    		
    		
    		if($('.fc-day[data-date="'+ yyyyMmDdVal +'"] div .deposit').length < 1) {
    			//alert(yyyyMmDdVal + " : " + $('.fc-day[data-date="'+ yyyyMmDdVal +'"] div .deposit').length);
    			$('.fc-day[data-date="'+ yyyyMmDdVal +'"] div .fc-day-content').after("<div align='right' name='calDepositEmptySpace' " 
    	    			
    					+ "'>" 
    					+ "&nbsp;" + "<br>" 
    					+ "&nbsp;" 
    					+ "</div>"
    			);		
    		}
    		if($('.fc-day[data-date="'+ yyyyMmDdVal +'"] div .settle').length < 1) {
    			//alert(yyyyMmDdVal + " : " + $('.fc-day[data-date="'+ yyyyMmDdVal +'"] div .settle').length);
    			$('.fc-day[data-date="'+ yyyyMmDdVal +'"] div .fc-day-content').after("<div align='right' name='calSettleEmptySpace' " 
    	    			
    					+ "'>" 
    					+ "&nbsp;" + "<br>" 
    					+ "&nbsp;" 
    					+ "</div>"
    			);		
    		}
    	}
    }
        
	/* var events = [];
    
    if(objJson.resultCode == 0){
        for(var i=0; i<objJson.data.length; i++){
            var objData = objJson.data[i];
            
            if(objData.SETTLMNT_AMT != 0){
                events.push({
                    title : nicepay.Utils.fnAddComma(objData.SETTLMNT_AMT),
                    start : objData.START_DAY,
                    end   : objData.END_DAY
                });
            }
            
            if(objData.MEMO != null){
                events.push({
                     title : nicepay.Utils.fnAddComma(objData.MEMO),
                     start : objData.START_DAY,
                     end   : objData.END_DAY,
                     backgroundColor:"#ff0000"
                });
            }
            
            if(objData.HOLIDAY_TYPE == 2){
                $('.fc-day[data-date="'+objData.START_DAY+'"]').css("background-color", "#F3B3B9");
            }
        }
        
        gobjJson = objJson;
        
        callback(events);
        
        $(".fc-event-inner").hover(function(){$(this).css("cursor","pointer");}); */
        
        
        //after part
	
	//$('.fc-header').hide();
    
    var arrDateValue   = $("#txtSetMonth").val().split("-");
    var strSetDate     = arrDateValue[0] + "-" + "01-" + arrDateValue[1];
    var objDate        = new Date(strSetDate);
    var objCurrentDate;
    
    $("#divCalendar").fullCalendar("gotoDate", objDate);
    
    objCurrentDate = $("#divCalendar").fullCalendar("getDate");
    
    $("#calender-current-date").html($.fullCalendar.formatDate(objCurrentDate, "MMMM yyyy"));
    
    var monthEngVal = $.fullCalendar.formatDate(objCurrentDate, "MMM");
    var monthNumVal = "";
    var monthNumValAddZero = "";
    
    if(monthEngVal=="Jan"){monthNumVal = "1";}else if(monthEngVal=="Feb"){monthNumVal = "2";}else if(monthEngVal=="Mar"){monthNumVal = "3";}
    else if(monthEngVal=="Apr"){monthNumVal = "4";}else if(monthEngVal=="May"){monthNumVal = "5";}else if(monthEngVal=="Jun"){monthNumVal = "6";}
    else if(monthEngVal=="Jul"){monthNumVal = "7";}else if(monthEngVal=="Aug"){monthNumVal = "8";}else if(monthEngVal=="Sep"){monthNumVal = "9";}
    else if(monthEngVal=="Oct"){monthNumVal = "10";}else if(monthEngVal=="Nov"){monthNumVal = "11";}else if(monthEngVal=="Dec"){monthNumVal = "12";}
    
    if(monthEngVal=="Jan"){monthNumValAddZero = "01";}else if(monthEngVal=="Feb"){monthNumValAddZero = "02";}else if(monthEngVal=="Mar"){monthNumValAddZero = "03";}
    else if(monthEngVal=="Apr"){monthNumValAddZero = "04";}else if(monthEngVal=="May"){monthNumValAddZero = "05";}else if(monthEngVal=="Jun"){monthNumValAddZero = "06";}
    else if(monthEngVal=="Jul"){monthNumValAddZero = "07";}else if(monthEngVal=="Aug"){monthNumValAddZero = "08";}else if(monthEngVal=="Sep"){monthNumValAddZero = "09";}
    else if(monthEngVal=="Oct"){monthNumValAddZero = "10";}else if(monthEngVal=="Nov"){monthNumValAddZero = "11";}else if(monthEngVal=="Dec"){monthNumValAddZero = "12";}
    
    $("#calender-current-date-view").html($.fullCalendar.formatDate(objCurrentDate, "yyyy") + "년 " + monthNumVal + "월");
    
    $("#searchYyyy").val($.fullCalendar.formatDate(objCurrentDate, "yyyy"));
    $("#searchMm").val(monthNumValAddZero);
    
    $(".fc-content").find("th").attr("style", "width:14%; height:40px; padding-top:10px;")
    $(".fc-content").find("th, td").each(function(){
    	var strClass = $(this).attr("class");
    	
    	if (strClass.indexOf("fc-last") != -1) {
    		$(this).attr("style", $(this).attr("style") + "; border-right:1px solid #ddd;");
    	}
    });
    
    
    $(".search-bar").show();
    $(".fc-header-left").hide();
    $(".fc-header-center").hide();
}

// 상세내역조회 모달 제거시 body 스크롤 생성
function modalClose(){
	$("#divDetailSettleConfirm").on("hidden.bs.modal", function(){
		$("html, body").css({'overflow' : "auto", 'height': '100%'});
	});
}
/**------------------------------------------------------------
* 정산 달력 상세 정보 조회
------------------------------------------------------------*/
function fnSelectSettlementDetailList(strSettlmntDT) {
    var strCallUrl  = "/settlementViews/settlementCalender/selectSettlementDetailList.do";
    var strCallBack = "fnSelectSettlementDetailListRet";
    var objParam    = {};
    
    objParam["SETTLMNT_DT"] = strSettlmntDT;
    objParam["I_MID"]       = $("#selIMID").val();
    
    nicepay.Ajax.fnRequest(objParam, strCallUrl, strCallBack);
}

function fnSelectSettlementDetailListRet(objJson){
    var strHtml = "";
    if(objJson.resultCode == 0){
        if(objJson.data.length != 1){
            for(var i=0; i<objJson.data.length; i++){
                var objData = objJson.data[i];
                if(objData.PAY_METHOD == "TOTAL"){
                    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_SV_SC_0013") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.TRANS_AMT)+"</td>";
                    strHtml += "</tr>";
                }else if (objData.PAY_METHOD == "ADDROW"){
                	strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_SV_SC_0031") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.PG_FEE)+"</td>";
                    strHtml += "</tr>";
               	    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_SV_SC_0032") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.VAT)+"</td>";
                    strHtml += "</tr>";
                    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_SV_SC_0007") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.RESR_AMT)+"</td>";
                    strHtml += "</tr>";
                    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_SV_SC_0008") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.RESR_CC_AMT)+"</td>";
                    strHtml += "</tr>";
                    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_SV_SC_0009") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.OFF_AMT)+"</td>";
                    strHtml += "</tr>";
                    
                    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_DASHBOARD_0022") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.REFUND_AMT)+"</td>";
                    strHtml += "</tr>";
                    
                    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>" + gMessage("MMS_SV_SC_0010") + "</td>";
                    strHtml += "<td style='width:80%;text-align:right;border:1px solid #ddd;' colspan='4'>"+nicepay.Utils.fnAddComma(objData.SETTLMNT_AMT)+"</td>";
                    strHtml += "</tr>";
                }else{
                    strHtml += "<tr>";
                    strHtml += "<td style='width:20%;font-weight:bold;background-color:#ecf0f2;text-align:center;border:1px solid #ddd;'>"+fnCreateRenderPaymethod(objData)+"</td>";
                    strHtml += "<td style='width:20%;text-align:right;border:1px solid #ddd;'>"+nicepay.Utils.fnAddComma(objData.APP_CNT)+"</td>";
                    strHtml += "<td style='width:20%;text-align:right;border:1px solid #ddd;'>"+nicepay.Utils.fnAddComma(objData.APP_AMT)+"</td>";
                    strHtml += "<td style='width:20%;text-align:right;border:1px solid #ddd;'>"+nicepay.Utils.fnAddComma(objData.CC_CNT)+"</td>";
                    strHtml += "<td style='width:20%;text-align:right;border:1px solid #ddd;'>"+nicepay.Utils.fnAddComma(objData.CC_AMT)+"</td>";
                    strHtml += "</tr>";
                }
            }
            
            $("#tbodySettlementDetail").html(strHtml);
        }else{
            $("#divBtnArea").hide();
            strHtml = "<tr><td class='column100c' style='border:1px solid #ddd;' colspan='5' align='center'>No data available in table</td></tr>";
            $("#tbodySettlementDetail").html(strHtml);
        }
    }else{
        nicepay.Msg.fnAlertWithModal(objJson.resultMessage, "divEditUsrAcct");
    }
}

/**------------------------------------------------------------
* 정산 달력 결제수단 Render
------------------------------------------------------------*/
function fnCreateRenderPaymethod(data){
    var strHtml = "";
    if(data.PAY_METHOD == "FN_0018"){
    	strHtml += "<button class='btn btn-info btn-xs btn-mini' type='button' style='cursor:default;'>C.C</button>";
    }else if(data.PAY_METHOD  == "FN_0042"){
    	strHtml += "<button class='btn btn-center btn-xs btn-mini' type='button' style='cursor:default;'>D.C</button>";
    }else{
    	strHtml += "<button class='btn btn-warning btn-xs btn-mini' type='button' style='cursor:default;'>V.A</button>";
    }
    return strHtml;
}

function fnCalenderDetail(memo, dpstAmt, appAmt, ccAmt, totAmt
		, resrAmt, resrCcAmt, extraAmt, fee, vat){
	/* alert(memo + " : " + dpstAmt + " : " + appAmt + " : " + ccAmt + " : " + totAmt
			 + " : " + resrAmt + " : " + resrCcAmt + " : " + extraAmt + " : " + fee + " : " + vat); */
	
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalCalDetailInfo #detail_memo").html("<c:out value='"+memo+"' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_dpstAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(dpstAmt)+"원' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_appAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(appAmt)+"원' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_ccAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(ccAmt)+"원' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_totAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(totAmt)+"원' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_resrAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(resrAmt)+"원' escapeXml='false' />");
	
	$("#modalCalDetailInfo #detail_resrCcAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(resrCcAmt)+"원' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_extraAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(extraAmt)+"원' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_fee").html("<c:out value='"+IONPay.Utils.fnAddComma(fee)+"원' escapeXml='false' />");
	$("#modalCalDetailInfo #detail_vat").html("<c:out value='"+IONPay.Utils.fnAddComma(vat)+"원' escapeXml='false' />");
	
	$("#modalCalDetailInfo").modal();
	
	/* if(objJson.resultCode == 0 ){
			 
		
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#modalCalDetailInfo").hide();
	} */
}

function fnCalenderSettDetail(memo, dpstAmt, appAmt, ccAmt, totAmt
		, resrAmt, resrCcAmt, extraAmt, fee, vat){
	
	$("body").addClass("breakpoint-1024 pace-done modal-open ");
	$("#modalCalSettDetailInfo #detail_sett_dpstAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(dpstAmt)+"원' escapeXml='false' />");
	$("#modalCalSettDetailInfo #detail_sett_appAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(appAmt)+"원' escapeXml='false' />");
	$("#modalCalSettDetailInfo #detail_sett_ccAmt").html("<c:out value='"+IONPay.Utils.fnAddComma(ccAmt)+"원' escapeXml='false' />");
	
	$("#modalCalSettDetailInfo").modal();
}
</script>
	<input type="hidden" id="todayYyyy" value="${TODAY_YYYY}">
	<input type="hidden" id="todayMm" value="${TODAY_MM}">
	
	<input type="hidden" id="searchYyyy" value="">	<!-- 디폴트 값은 오늘날짜 -->
	<input type="hidden" id="searchMm" value="">
	
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;" class="active"><c:out value="${MENU_TITLE }" /></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE FORM -->
                <!-- BEGIN VIEW OPTION AREA -->
                <input type="hidden" id="WORKER" name="WORKER"  value="<%=CommonUtils.getSessionInfo(session, "USR_ID")%>"/>
                
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code="MMS_SV_SC_0019" /></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border search-bar">
                            <form id="frmSettlementCalender">
                            	<div class="row form-row" style="padding:0 0 5px 0; display: none;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code="MMS_SV_SC_0020" /></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>    
                                            <select id="selIMID" name="I_MID" maxlength="10" class="select2 form-control"></select>                         
                                        </div>
                                    </div>                                    
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code="MMS_SV_SC_0021" /></label> 
                                        <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                            <input type="text" id="txtSetMonth" name="SET_MONTH" class="form-control">
                                            <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                        </div>                   
                                    </div>
                                </div>
                                <div class="row form-row" style="padding:0 0 5px 0;">
                                    <div class="col-md-2">
                                        <label class="form-label">조회년월</label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>    
                                            <table style="width: 300px">
                                            	<tr>
                                            		<td>
                                            			<select id="yyyyList" name="yyyyList" class="select2 form-control"></select>
                                            		</td>
                                            		<td>&nbsp;&nbsp;&nbsp;년</td>
                                            	</tr>
                                            </table>                         
                                        </div>
                                    </div>                                   
                                    <div class="col-md-2">
                                        <label class="form-label">&nbsp;</label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>    
                                            <table style="width: 300px">
                                            	<tr>
                                            		<td>
                                            			<select id="mmList" name="mmList" class="select2 form-control"></select>
                                            		</td>
                                            		<td>&nbsp;&nbsp;&nbsp;월</td>
                                            	</tr>
                                            </table>
                                                                     
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">&nbsp;</label>
                                        <div>
                                            <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code="MMS_SV_SC_0022" /></button>
                                            <%-- <button type="button" id="btnPrint" class="btn btn-primary btn-cons"><spring:message code="MMS_SV_SC_0023" /></button> --%>
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
                               <h4><i class="fa fa-th-large"></i><spring:message code="MMS_SV_SC_0024" /></h4>
                               <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                           </div>
                           <div class="grid-body no-border">
	                           <div class="grid simple ">
	                             <div id="divGridArea" class="grid-body " style="display:none;">
	                                <div class="col-md-12">
	                                    <div class="tiles-body">
							              <div class="full-calender-header">
							                <div class="text-center">
		                                        <h2 id="calender-current-date" style="display: none;"></h2>
		                                        <h2 id="calender-current-date-view"></h2>
	                                        </div>
							                <div class="pull-left">
							                  <!-- <div class="btn-group ">
							                    <button class="btn btn-success" id="calender-prev"><i class="fa fa-angle-left"></i></button>
							                    <button class="btn btn-success" id="calender-next"><i class="fa fa-angle-right"></i></button>
							                  </div> -->
							                </div>
							                <div class="clearfix"></div>
							              </div>
							              <table>
							              	<tr>
							              		<td style="background-color: #ff8080">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							              		<td>&nbsp;: 입금</td>
							              	</tr>
							              	<tr>
							              		<td style="background-color: #8080ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							              		<td>&nbsp;: 매출</td>
							              	</tr>
							              </table>
							              <div id="divCalendar"></div>
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
        <div id="div_print" style="display:none;"></div>
        <iframe id="print_frame" name="print_frame" width="0" height="0" frameborder="0"></iframe>
    </div>
    <!-- END CONTAINER -->
    <!-- Modal Detail Settle Confirm Area -->
    <div class="modal fade over-hidden" id="divDetailSettleConfirm" tabindex="-1" role="dialog" aria-labelledby="modalDetailSettleConfirm" aria-hidden="true"  style="overflow-y:auto;">
      <div class="modal-dialog" style="width:50%;">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" aria-hidden="true" data-dismiss="modal">x</button>
            <br>
            <i class="fa fa-info-circle fa-2x"></i>
            <h4 class="semi-bold"><spring:message code="MMS_SV_SC_0025" /></h4>
            <br>
          </div>
          <div class="modal-body">
            <div class="row-fluid">
               <div class="span12">
                 <div class="grid simple ">
                    <div class="grid-title">
                      <h4><spring:message code="MMS_SV_SC_0002" /> : <span id="spSettlmntDT" class="semi-bold"></span></h4>
                      <div class="tools"><button type="button" id="btnDetailSettlement" class="btn btn-primary"><spring:message code="MMS_SV_SC_0026" /></button></div>
                    </div>
                    <div class="grid-body ">
                      <table id="tbSettlementDetail" class="table" width="100%">
                          <thead>
                            <tr>
                              <th><spring:message code="MMS_SV_SC_0004" /></th>
                              <th><spring:message code="MMS_SV_SC_0027" /></th>
                              <th><spring:message code="MMS_SV_SC_0028" /></th>
                              <th><spring:message code="MMS_SV_SC_0029" /></th>
                              <th><spring:message code="MMS_SV_SC_0030" /></th>
                            </tr>
                          </thead>
                          <tbody id="tbodySettlementDetail"></tbody>
                      </table>
                    </div>
                 </div>
               </div>
            </div>
            </div>            
            <div class="modal-footer">
                <div class="pull-right">
                     <button type="button" class="btn btn-default" data-dismiss="modal" onclick="nicepay.Msg.fnResetBodyClass();">닫기</button>
                </div>
            </div>
        </div>
      </div>
    </div>
    <!-- Modal Detail Settle Confirm Area -->
    
    
    
    <!-- BEGIN MODAL -->
		<div class="modal fade" id="modalCalDetailInfo"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog" style="width:500px">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel" class="semi-bold">입금내역 상세조회</h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="gidInfo" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                  
                                  <tr>
                                      <th style="width:300px;">입금액</th>
                                      <td id="detail_dpstAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;width:250px"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">승인금액</th>
                                      <td id="detail_appAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;width:250px"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">취소금액</th>
                                      <td id="detail_ccAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">총금액</th>
                                      <td id="detail_totAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  
                                  <tr>
                                      <th style="width:300px;">입금보류금액</th>
                                      <td id="detail_resrAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">보류해제금액</th>
                                      <td id="detail_resrCcAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">별도가감금액</th>
                                      <td id="detail_extraAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">수수료</th>
                                      <td id="detail_fee" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">VAT</th>
                                      <td id="detail_vat" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width:300px;">메모</th>
                                      <td id="detail_memo" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  
                                 </thead>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">확인</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END MODAL -->
		
		
		<!-- BEGIN MODAL -->
		<div class="modal fade" id="modalCalSettDetailInfo"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content" >
		            <div class="modal-header" style="background-color: #F3F5F6;">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <br />
		                <i id="icon_sett" class="fa fa-envelope-o fa-2x"></i>
		                <h4 id="myModalLabel_sett" class="semi-bold">매출내역 상세조회</h4>
		                <br />
		            </div>
		            <div class="modal-body" style="background-color: #e5e9ec;">
		                <div class="row form-row">
		                    <table class="table" id="gidInfo_sett" style="width:100%; border:1px solid #ddd;">
                                <thead >
                                  
                                  <tr>
                                      <th style="width: 200px;">승인금액</th>
                                      <td id="detail_sett_appAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width: 200px;">취소금액</th>
                                      <td id="detail_sett_ccAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  <tr>
                                      <th style="width: 200px;">매출합계</th>
                                      <td id="detail_sett_dpstAmt" style="border:1px solid #c2c2c2; background-color:white; text-align: right;"></td>
                                  </tr>
                                  
                                 </thead>
                           </table>
                         </div>
	            	</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-default" data-dismiss="modal">확인</button>
		            </div>
	            </div>
	        </div>
	    </div>
		<!-- END MODAL -->