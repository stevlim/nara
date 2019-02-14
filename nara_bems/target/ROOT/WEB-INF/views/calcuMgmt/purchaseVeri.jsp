<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var objListInquiry;
$(document).ready(function(){
	fnInitEvent();
    fnSetDDLB();
    
});

function fnInitEvent() {
	$("#div_search").hide();
    
    $("#btnSearch").on("click", function() {
    	$("#div_search").show(200);
    	fnInquiry();
    	fnInquiryList();
    });

}
function fnSetDDLB(){
}
function fnInquiryList(){
	if (typeof objListInquriy == "undefined") {
   		objListInquriy = IONPay.Ajax.CreateDataTable("#tbListInqiry", true, {
               url: "/calcuMgmt/purchaseMgmt/selectAcqGap.do",
               data: function() {	
                   return $("#frmSearch").serializeObject();
               },
               columns: [
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.RNUM==null?"":data.RNUM} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.GAP_CL==null?"":data.GAP_CL} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.STATE_NM==null?"":data.STATE_NM} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.TID==null?"":data.TID} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACQ_AMT==null?"":data.ACQ_AMT} },
				   { "class" : "columnc all", 			"data" : null, "render":function(data){return data.ACQ_REG_CD==null?"":data.ACQ_REG_CD} }
               ]
       }, true);
    } else {
       objListInquriy.clearPipeline();
       objListInquriy.ajax.reload();
    }

	IONPay.Utils.fnShowSearchArea();
    IONPay.Utils.fnHideSearchOptionArea();
}
function fnInquiry(){
	arrParameter["worker"] = strWorker;
	arrParameter["acqDt"] = IONPay.Utils.fnConvertDateFormat($("#frmSearch #acqDt").val());
	strCallUrl   = "/calcuMgmt/purchaseMgmt/selectPurchaseVeriList.do";
    strCallBack  = "fnInquiryRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnInquiryRet(objJson){
	if(objJson.resultCode == 0 ){
			var str = ""; 
			str += "<tr style='text-align: center; '>";	
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;'>비인증</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_AUTO_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_AUTO_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_REQ_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_REQ_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_CNT_APP_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_KEYIN+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >ISP</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_AUTO_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_AUTO_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_REQ_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_REQ_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_ISP+"</td>";
			str += "</tr><t style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >VISA3D</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_AUTO_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_AUTO_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_REQ_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_REQ_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_CNT_APP_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_VISA3D+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >빌링</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_AUTO_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_AUTO_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_REQ_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_REQ_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_BILL_KEYIN+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >UPOP</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_AUTO_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_AUTO_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_REQ_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_REQ_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.TRANS_AMT_APP_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CNT_CAN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AMT_CAN_UPOP+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >합 계</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CntAutoTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AmtAutoTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CntReqTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AmtReqTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CntCanTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AmtCanTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CntTransTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AmtTransTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.CntTransCcTotal+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.transMap.AmtTransCcTotal+"</td>";
			str += "</tr>";
			
			$("#tbody_result").html(str);
			
			str = "";
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >비인증</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_IN_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_IN_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_IN_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_IN_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_OUT_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_OUT_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_OUT_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_OUT_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_APP_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_APP_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_CC_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_CC_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.CNT_HOLD_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.AMT_HOLD_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntAppKeyIn+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtAppKeyIn+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntCcKeyIn+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtCcKeyIn+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >ISP</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_IN_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_IN_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_IN_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_IN_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_OUT_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_OUT_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_OUT_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_OUT_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_APP_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_APP_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_CC_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_CC_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.CNT_HOLD_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.AMT_HOLD_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntAppIsp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtAppIsp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntCcIsp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtCcIsp+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >VISA3D</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_IN_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_IN_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_IN_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_IN_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_OUT_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_OUT_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_OUT_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_OUT_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_APP_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_APP_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_CC_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_CC_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.CNT_HOLD_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.AMT_HOLD_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntAppVisa3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtAppVisa3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntCcVisa3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtCcVisa3D+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >빌링</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_IN_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_IN_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_IN_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_IN_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_OUT_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_OUT_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_OUT_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_OUT_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_APP_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_APP_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_CC_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_CC_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.CNT_HOLD_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.AMT_HOLD_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntAppBillkeyin+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtAppBillkeyin+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntCcBillkeyin+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtCcBillkeyin+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >UPOP</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_APP_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_APP_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_CC_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_CC_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.CNT_HOLD_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.AMT_HOLD_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntAppUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtAppUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntCcUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtCcUpop+"</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >합계</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_IN_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_APP_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_APP_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.CNT_CC_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.AMT_CC_OUT_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_APP_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_APP_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.CNT_RE_CC_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.reMap.AMT_RE_CC_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.CNT_HOLD_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.canMap.AMT_HOLD_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntAppUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtAppUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcCntCcUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.EtcAmtCcUpop+"</td>";
			str += "</tr>";
			$("#tbody_result2").html(str);
		
			str = "";
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >비인증</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntAppKeyIn+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtAppKeyIn+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntCcKeyIn+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtCcKeyIn+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_APP_ACQ_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_APP_ACQ_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_CC_ACQ_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_CC_ACQ_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.CntAppKeyIn==0?objJson.listMap.CntAppKeyIn:"<font color='red'>"+objJson.listMap.CntAppKeyIn+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AmtAppKeyIn==0?objJson.listMap.AmtAppKeyIn:"<font color='red'>"+objJson.listMap.AmtAppKeyIn+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.CntAcqCcKeyIn==0?objJson.listMap.CntAcqCcKeyIn:"<font color='red'>"+objJson.listMap.CntAcqCcKeyIn+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.CntAppKeyIn==0?objJson.listMap.CntAppKeyIn:"<font color='red'>"+objJson.listMap.CntAppKeyIn+"</font>") + "</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >ISP</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntAppIsp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtAppIsp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntCcIsp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtCcIsp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_APP_ACQ_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_APP_ACQ_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_CC_ACQ_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_CC_ACQ_ISP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntAppIsp==0?objJson.listMap.AcqCntAppIsp:"<font color='red'>"+objJson.listMap.AcqCntAppIsp+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtAppIsp==0?objJson.listMap.AcqAmtAppIsp:"<font color='red'>"+objJson.listMap.AcqAmtAppIsp+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntCcIsp==0?objJson.listMap.AcqCntCcIsp:"<font color='red'>"+objJson.listMap.AcqCntCcIsp+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtCcIsp==0?objJson.listMap.AcqAmtCcIsp:"<font color='red'>"+objJson.listMap.AcqAmtCcIsp+"</font>") + "</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >VISA3D</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntAppVisa3d+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtAppVisa3d+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntCcVisa3d+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtCcVisa3d+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_APP_ACQ_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_APP_ACQ_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_CC_ACQ_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_CC_ACQ_VISA3D+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntAppVisa3d==0?objJson.listMap.AcqCntAppVisa3d:"<font color='red'>"+objJson.listMap.AcqCntAppVisa3d+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtAppVisa3d==0?objJson.listMap.AcqAmtAppVisa3d:"<font color='red'>"+objJson.listMap.AcqAmtAppVisa3d+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntCcVisa3d==0?objJson.listMap.AcqCntCcVisa3d:"<font color='red'>"+objJson.listMap.AcqCntCcVisa3d+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtCcVisa3d==0?objJson.listMap.AcqAmtCcVisa3d:"<font color='red'>"+objJson.listMap.AcqAmtCcVisa3d+"</font>") + "</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >빌링</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntAppBillKeyin+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtAppBillKeyin+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntCcBillKeyin+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtCcBillKeyin+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_APP_ACQ_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_APP_ACQ_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_CC_ACQ_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_CC_ACQ_BILL_KEYIN+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntAppBillKeyIn==0?objJson.listMap.AcqCntAppBillKeyIn:"<font color='red'>"+objJson.listMap.AcqCntAppBillKeyIn+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtAppBillKeyIn==0?objJson.listMap.AcqAmtAppBillKeyIn:"<font color='red'>"+objJson.listMap.AmtAppBillKeyIn+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntCcBillKeyIn==0?objJson.listMap.AcqCntCcBillKeyIn:"<font color='red'>"+objJson.listMap.AcqCntCcBillKeyIn+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtCcBillKeyIn==0?objJson.listMap.AcqAmtCcBillKeyIn:"<font color='red'>"+objJson.listMap.AcqAmtCcBillKeyIn+"</font>") + "</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >UPOP</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntAppUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtAppUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcCntCcUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.etcMap.SrcAmtCcUpop+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_APP_ACQ_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_APP_ACQ_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.CNT_CC_ACQ_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AMT_CC_ACQ_UPOP+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntAppUpop==0?objJson.listMap.AcqCntAppUpop:"<font color='red'>"+objJson.listMap.AcqCntAppUpop+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtAppUpop==0?objJson.listMap.AcqAmtAppUpop:"<font color='red'>"+objJson.listMap.AcqAmtAppUpop+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqCntCcUpop==0?objJson.listMap.AcqCntCcUpop:"<font color='red'>"+objJson.listMap.AcqCntCcUpop+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AcqAmtCcUpop==0?objJson.listMap.AcqAmtCcUpop:"<font color='red'>"+objJson.listMap.AcqAmtCcUpop+"</font>") + "</td>";
			str += "</tr><tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >합계</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.SrcCntApp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.SrcAmtApp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.SrcCntCc+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.SrcAmtCc+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AcqCntApp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AcqAmtApp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AcqCntCcApp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >"+objJson.listMap.AcqAmtCcApp+"</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.CntAppTotal==0?objJson.listMap.CntAppTotal:"<font color='red'>"+objJson.listMap.CntAppTotal+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AmtAppTotal==0?objJson.listMap.AmtAppTotal:"<font color='red'>"+objJson.listMap.AmtAppTotal+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.CntCcTotal==0?objJson.listMap.CntCcTotal:"<font color='red'>"+objJson.listMap.CntCcTotal+"</font>") + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + (objJson.listMap.AmtCcTotal==0?objJson.listMap.AmtCcTotal:"<font color='red'>"+objJson.listMap.AmtCcTotal+"</font>") + "</td>";
			str += "</tr>";
			$("#tbody_result3").html(str);
			
			str = "";
			str += "<tr style='text-align: center; '>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >JTNET</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + objJson.vanMap.JTNET_CNT + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + objJson.vanMap.JTNET_AMT + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >" + objJson.vanMap.JTNET_SEND_CNT + "</td>";
			str += "<td style='text-align:center; border:1px solid #ddd; background-color:#FAFAFA;' >";
			if(objJson.vanMap.JTNET_GAP != 0){
				str += "<font color='red'>"+objJson.vanMap.JTNET_GAP+"</font>";
			}else{
				str += objJson.vanMap.JTNET_GAP;
			}
			str += "</tr>";
			$("#tbody_result5").html(str);
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#div_search").hide();
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
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.PURCHASE_MANAGEMENT }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><spring:message code='IMS_MENU_SUB_0116'/></span></h3>
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
                                    <div class="row form-row"   >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0601'/></label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="acqDt" name="acqDt" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div class="col-md-3"></div>
				                          <div class="col-md-3">
				                              <label class="form-label">&nbsp;</label>
				                              <div>
				                                  <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_CCS_0005'/></button>
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
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0664'/></h6>
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th class="th_verticleLine" rowspan="3"><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th class="th_verticleLine" colspan="2" rowspan="2"><spring:message code='IMS_BIM_BM_0602'/></th>
                                                     <th class="th_verticleLine" colspan="2" rowspan="2"><spring:message code='IMS_BIM_BM_0603'/></th>
                                                     <th class="th_verticleLine" colspan="2" rowspan="2"><spring:message code='FN_0024'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0176'/></th>
                                                 </tr>
                                                 <tr>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 </tr>
                                                 <tr>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_result"></tbody>
                                            </table>
                                        </div>
                                        <div class="grid-body " id="">
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0665'/></h6>
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th class="th_verticleLine" rowspan="3"><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0666'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0667'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0668'/></th>
                                                     <th class="th_verticleLine" colspan="2" rowspan="2"><spring:message code='IMS_BIM_BM_0669'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0176'/></th>
                                                 </tr>
                                                 <tr>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 </tr>
                                                 <tr>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_result2"></tbody>
                                            </table>
                                        </div>
                                        <div class="grid-body " id="">
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0670'/></h6>
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th class="th_verticleLine" rowspan="3"><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0671'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0672'/></th>
                                                     <th class="th_verticleLine" colspan="4"><spring:message code='IMS_BIM_BM_0673'/></th>
                                                 </tr>
                                                 <tr>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0174'/></th>
                                                 	<th class="th_verticleLine" colspan="2"><spring:message code='IMS_BIM_BM_0175'/></th>
                                                 </tr>
                                                 <tr>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0362'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_result3"></tbody>
                                            </table>
                                        </div>
                                        <div class="grid-body " id="">
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0674'/></h6>
                                            <table id="tbListInqiry" class="table" style="width:100%">
                                            	<thead>
                                                 <tr>
                                                 	<th ><spring:message code='IMS_DASHBOARD_0029'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0101'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0078'/></th>
                                                 	<th ><spring:message code='IMS_PW_DE_12'/></th>
                                                 	<th ><spring:message code='IMS_BIM_CCS_0036'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0675'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_result4"></tbody>
                                            </table>
                                        </div>
                                        <div class="grid-body " id="">
                                        	<h6><i class="fa fa-th-large"></i> <spring:message code='IMS_BIM_BM_0676'/></h6>
                                            <table id="tbListSearch" class="table" style="width:100%">
                                            	<thead>
                                                 <tr>
                                                 	<th ><spring:message code='IMS_BIM_BM_0677'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0678'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0131'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0679'/></th>
                                                 	<th ><spring:message code='IMS_BIM_BM_0680'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_result5"></tbody>
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
