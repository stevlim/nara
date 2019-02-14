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
    /* $("select[name=searchFlg]").on("change", function(){
    	if ($.trim(this.value) == "ALL") {
    		$("#txtSearch").val("");
    		$("#txtSearch").attr("readonly", true);
    	}
    	else {
    		$("#txtSearch").attr("readonly", false);
    	}
    }); */
    
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
    	var $FROM_DT = $("#txtFromDate");
        var $TO_DT   = $("#txtToDate");

        map.set("strDate" , $("#dateChk").val());

        var intFromDT = Number(IONPay.Utils.fnConvertDateFormat($FROM_DT.val()));
        var intToDT   = Number(IONPay.Utils.fnConvertDateFormat($TO_DT.val()));
        console.log(intFromDT);
        console.log(intToDT);
        if (intFromDT > intToDT) {
            IONPay.Msg.fnAlert(gMessage('IMS_BM_IM_0011'));
            return;
        }

        if (!IONPay.Utils.fnCheckSearchRange($("#txtFromDate"), $("#txtToDate"), "3")) {
            return;
        }
        fnSelectCardInfoAmt();
        fnInquiry(strType);
    });
    $("#btnExcel").on("click", function() {
    	strType = "EXCEL";
    	//엑셀은 리스트만 조회해오면 됨
    	fnInquiry(strType);
    });
    $("#btnSumSearch").on("click", function() {
    	$("#div_searchResult").hide();
    	$("#divTidList").hide();
    	$("#div_search").show();
    	
    	var fromDt = $("#txtFromDate").val();
    	var toDt = $("#txtToDate").val();
    	var date = $("#txtFromDate").val() +"~"+ $("#txtToDate").val();
    	$("#date").html(date);
    	fnSelectCardInfoTotAmt();
    	//fnSumInquiry();
    });
}

function fnSetDDLB() {
	var receiptBgImg = $("#receiptBgImg").val();
    //$("#frmSearch #searchFlg").html("<c:out value='${MER_SEARCH}' escapeXml='false' />");
    $("#frmSearch #searchPayFlg").html("<c:out value='${PAY_SEARCH}' escapeXml='false' />");
    $("#frmSearch #settleCycle").html("<c:out value='${SettleCycle}' escapeXml='false' />");
    $("#frmSearch #status").html("<c:out value='${Status}' escapeXml='false' />");
    $("#frmSearch #dateChk").html("<c:out value='${DateChk}' escapeXml='false' />");
    
    $("#receiptTemp").css('background-image', 'url("' + receiptBgImg + '")');
    $("#receiptTemp").css('background-size', '100%');
    $("#receiptTemp").css('width', '375px');
    $("#receiptTemp").css('height', '540px');
}

function fnSelectCardInfoAmt(){
	arrParameter = $("#frmSearch").serializeObject();
	strCallUrl   = "/paymentMgmt/payInquiry/selectCardInfoAmt.do";
    //strCallUrl   = "/paymentMgmt/card/selectCardInfoAmt.do";
    strCallBack  = "fnSelectCardInfoAmtRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}
function fnSelectCardInfoAmtRet(objJson){
	
	if(objJson.resultCode == 0 ){
		$("#div_searchResult").css("display", "block");
		$("#tbCardAmtInfo #appCnt").html(objJson.data[0].TRAN_CNT+"건");
		$("#tbCardAmtInfo #appAmt").html(IONPay.Utils.fnAddComma(objJson.data[0].TRAN_AMT)+"원");
		$("#tbCardAmtInfo #canCnt").html(objJson.data[1].TRAN_CNT+"건");
		$("#tbCardAmtInfo #canAmt").html(IONPay.Utils.fnAddComma(objJson.data[1].TRAN_AMT)+"원");
		$("#tbCardAmtInfo #cntSum").html(  (objJson.data[0].TRAN_CNT + objJson.data[1].TRAN_CNT)  +"건");
		$("#tbCardAmtInfo #amtSum").html(  IONPay.Utils.fnAddComma(  objJson.data[0].TRAN_AMT - objJson.data[1].TRAN_AMT  )  +"원");
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#tbCardAmtInfo").hide();
	}
}

function fnInquiry(strType) {

    if(strType == "SEARCH"){
	    $("#div_searchResult").serializeObject();
	    $("#div_searchResult").show(200);
	    $("#div_searchSumResult").hide();
		if (typeof objCoMInfoInquiry == "undefined") {
			objCoMInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbCardTransList", true, {
	        //url: "/paymentMgmt/card/selectTransInfoList.do",
	        url: "/paymentMgmt/payInquiry/selectTransInfoList.do",
	        data: function() {
	            return $("#frmSearch").serializeObject();
	        },
	        columns: [
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.RNUM} },
	             { "class" : "columnc all",         "data" : null, "render": fnCancelLink },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CO_NM==null?"":data.CO_NM} },
	             /* { "class" : "columnc all",         "data" : null, "render": function(data){map.set("appDt", data.APP_DT); return  IONPay.Utils.fnStringToDateFormat(data.APP_DT)==null?"":IONPay.Utils.fnStringToDateFormat(data.APP_DT) } }, */
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_DT==null?"":data.APP_DT} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.APP_DT_HIS==null?"":data.APP_DT_HIS} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CC_DT==null?"":data.CC_DT} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.CC_DT_HIS==null?"":data.CC_DT_HIS} },
	             //{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.MID==null?"": '<a href="#" onclick="fnSerMID(\''+data.MID+'\');return false;">'+data.MID+'</a>'} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.MID==null?"":data.MID} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.GOODS_NM==null?"":data.GOODS_NM} },
	             //{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.TID==null?"":'<a href="#" onclick="fnSerTID(\''+data.TID+'\');return false;">'+data.TID+'</a>'} },
				 
	             { "class" : "columnr all",         "data" : null, "render": function(data){return  data.GOODS_AMT==null?"":IONPay.Utils.fnAddComma(data.GOODS_AMT) + "원"} },
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ORD_NM_ENC==null?"":data.ORD_NM_ENC} },	//구매자	             	            
	             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.ORD_NM_ENC==null?"":data.UID} },	//고객 ID
	             { "class" : "columnc all",         "data" : null, "render": fnTrxSt },	//거래상태 0 승인, 1 전취소, 2 후취소
	             //{ "class" : "columnc all",         "data" : null, "render": function(data){return  data.ORD_NM_ENC==null?"":data.TID} },	
	             
	             //거래영수증
	             { "class" : "columnc all", 			"data" : null, "render":function(data, type, full, meta){
	            	return '<span name="btnReceipt"  value="거래영수증" style="color:blue; cursor:pointer;" ' 
	            	+ ' onClick="fnShowReceipt(\'' + data.ORD_NO + '\', \'' + data.APP_DT_FULL + '\', \'' + data.TID + '\', \'' + data.GOODS_NM + '\', \'' + data.PM_NM + '\', \'' + IONPay.Utils.fnAddComma(data.GOODS_AMT) + '\' '
            		+ ' , \'' + data.CO_NM + '\', \'' + data.CO_NO + '\', \'' + data.REP_NM + '\', \'' + data.ADDR + '\', \'' + data.TEL_NO + '\', \'' + data.UID + '\', \'' + data.CC_DT + '\', \'' + data.GOODS_SPL_AMT + '\', \'' + data.GOODS_VAT + '\', \'' + data.GOODS_SVC_FEE + '\')" >'
            		+ '거래영수증'
            		+ '</span>' ;
	            	}
	            	
	             }
	             
	            ]
		    }, true);


		} else {
			objCoMInfoInquiry.clearPipeline();
			objCoMInfoInquiry.ajax.reload();
		}
		IONPay.Utils.fnShowSearchArea();
		////IONPay.Utils.fnHideSearchOptionArea();

		}
		else{
			var $objFrmData = $("#frmSearch").serializeObject();

	        arrParameter = $objFrmData;
	        arrParameter["EXCEL_TYPE"]                  = strType;
	        arrParameter["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
	        IONPay.Ajax.fnRequestExcel(arrParameter, "/paymentMgmt/payInquiry/selectPayInfoListExcel.do");
	        //IONPay.Ajax.fnRequestExcel(arrParameter, "/paymentMgmt/card/selectCardTransInfoListExcel.do");
		}
}

//거래상태가 승인일 경우에만, 결제 취소 창이 열린다.
function fnCancelLink(data){
	var strHtml = "";
	
	strHtml = "<span data-tid='"+data.TID+"' onclick='fnSerTID(this);' style='color:blue; cursor:pointer;' >"+data.TID+"</span>";
	
	/* if(data.TRX_ST_CD == "0"){//승인
		strHtml = "<span data-tid='"+data.TID+"' onclick='fnSerTID(this);' style='color:blue; cursor:pointer;' >"+data.TID+"</span>";
	}else{
		strHtml = "<span>"+data.TID+"</span>";
	} */
		
	return strHtml;
}


//거래상태 구분 코드를 문자로 변환한다.
function fnTrxSt(data){
	var trxSt = data.TRX_ST_CD;
	var strHtml = "";
	
	if(trxSt == "0"){		//승인
		strHtml = "<spring:message code='FN_0006'/>";
	}else if(trxSt == "1"){	//전취소
		strHtml = "<spring:message code='FN_0022'/>";
	}else if(trxSt == "2"){ //후취소
		strHtml = "<spring:message code='FN_0024'/>";
	}
	
	return strHtml;
}

//mid로 변환 후 다시 조회
function fnSerMID(mid){
	//$("#frmSearch #searchFlg").select2("val", "1");
	//$("#frmSearch #txtSearch").val(mid);
	strType="SEARCH";
	fnInquiry(strType);
}
//모달 창 생성 후  tid 로  조회

function fnSerTID(data){
	map.set("TID", data.dataset.tid);
	strModalID = "modalSerTid";
	arrParameter["tid"] = data.dataset.tid;
	arrParameter["USR_ID"] = $("#USR_ID").val();
	//strCallUrl  = "/paymentMgmt/card/selectSerTidInfo.do";
    strCallUrl   = "/paymentMgmt/payInquiry/selectSerTidInfo.do";
    strCallBack  = "fnSerTidRet";
    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    
    /* arrParameter = {
        	"tid"   : tid,
        	"USR_ID"	: $("#USR_ID").val(),
        };
		//strCallUrl  = "/paymentMgmt/card/selectSerTidInfo.do";
		strCallUrl  = "/paymentMgmt/card/selectSerTidInfo.do";
		strCallBack = "fnSerTidRet";

		IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack); */
}
function fnSerTidRet(objJson){
	$("#divTidList #state0").hide();
	$("#divTidList #state51").hide();
	$("#divTidList #div_partCList").hide();
	$("#divTidList #div4").hide();

	if(objJson.resultCode == 0 ){
		var str = "";
		if(objJson.tidInfo != null){
			$("#div_search").css("display", "none");
			$("#divTidList").css("display", "block");

			var emp = strWorker;
			var clientIp = "<%=request.getRemoteAddr( )%>";

			$("#divTidList input[name=emp]").val(emp);
			$("#divTidList input[name=canIP]").val(clientIp);
			$("#divTidList input[name=canUID]").val(emp);

			$("#divTidList input[name=canMID]").val(objJson.tidInfo.MID);
			$("#divTidList input[name=canTID]").val(map.get("TID"));
			$("#divTidList input[name=canAmt]").val(objJson.tidInfo.GOODS_AMT);
			//$("#divTidList input[name=rid]").val(objJson.tidInfo.REQ_NO);
			$("#divTidList input[name=ccDt]").val(objJson.tidInfo.CC_DT);
			$("#divTidList input[name=ccTm]").val(objJson.tidInfo.CC_TM);
			
			
			$("#tb_serTid #tid").html(map.get("TID"));
			
			$("#tb_serTid #REASON_CD").select2("val", objJson.tidInfo.REASON_CD);
			$("#tb_serTid #CC_REG_ID").val(emp);
			$("#tb_serTid #CC_PASSWORD").val(objJson.tidInfo.CC_PASSWORD);			
			$("#tb_serTid #REASON_DESC").val(objJson.tidInfo.REASON_DESC);

			if(objJson.tidInfo.TRX_ST_CD == "0"){
				$("#tb_serTid #state0").show();	
			}else{
				$("#tb_serTid #state0").hide();
			}
			

			/* if(objJson.mngList[0].PAY_AUTH_FLG2 == "1"
				&& objJson.tidInfo.TRX_ST_CD == "0"){
				$("#tb_serTid #state0").show();
				$("#tb_serTid #remainAmt").html(objJson.tidInfo.remainAmt);
				$("#tb_serTid #canGoods").val(objJson.tidInfo.remainAmt==null?0:objJson.tidInfo.remainAmt);
				$("#tb_serTid #tid").html(map.get("TID"));
	
				//TEST
				$("#tb_serTid input[name=recNm]").val(objJson.mngList[0].EMP_NM);
	
			} */
			
			/* if(objJson.mngList[0].PAY_AUTH_FLG2 == "1"
					&& objJson.tidInfo.TRX_ST_CD == "0"){
				$("#tb_serTid #state0").show();
				$("#tb_serTid #remainAmt").html(objJson.tidInfo.remainAmt);
				$("#tb_serTid #canGoods").val(objJson.tidInfo.remainAmt==null?0:objJson.tidInfo.remainAmt);
				$("#tb_serTid #tid").html(map.get("TID"));

				//TEST
				$("#tb_serTid input[name=recNm]").val(objJson.mngList[0].EMP_NM);

			} */
			/* if(objJson.mngList[0].PAY_AUTH_FLG3 == "1" && objJson.tidInfo.TRX_ST_CD == "2"
					&& objJson.tidInfo.TRX_CC_HIST_CD == "51" 
					// &&objJson.tidInfo.CHKCARD_FLG != "1"
					&& objJson.tidDetailLst == null){
				$("#tb_serTid #state51").show();
				$("#tb_serTid input[name=recNm]").val(objJson.mngList[0].EMP_NM);

			} */
			var cseq = "-1";
			var str = "";
			if(objJson.tidDetailLst != null){
				$("#tb_serTid #div_partCList").show();
				for(var i=0; i<objJson.tidDetailLst.length;i++){
					cseq = objJson.tidDetailLst[i].CC_SEQ;

					str+="<tr>";
					if(i == 0 ){
						str+="<th style='text-align: center; border: 1px solid #ddd;background-color:#ecf0f2; '>원거래 TID</th>";
					}else{
						str+="<th style='text-align: center; border: 1px solid #ddd; background-color:#ecf0f2;'>부분취소 TID</th>";
					}
					str+="<td style='text-align: center; border: 1px solid #ddd; '><a href='#' onclick=fnSerTID(\'"+objJson.tidDetailLst[i].TID+"\');>"+objJson.tidDetailLst[i].TID+"</a></td>";
					if(i == 0 ){
						str+="<th style='text-align: center; border: 1px solid #ddd;background-color:#ecf0f2; '>원거래금액</th>";
					}else{
						str+="<th style='text-align: center; border: 1px solid #ddd; background-color:#ecf0f2;'>부분취소 후 잔액</th>";
					}
					str+="<td style='text-align: center; border: 1px solid #ddd;  '>"+objJson.tidDetailLst[i].REMAIN_AMT+"</td>";
					str+="</tr>";
				}

				$("#div_partCList #thForCseq").html(str);
			}
			$("#divTidList input[name=cseq]").val(cseq);
			$("#divTidList input[name=remainOrg]").val(objJson.tidInfo.remainAmt);


			$("#div1 #pmNm").html(objJson.tidInfo.PM_NM);
			$("#div1 #tidVal").html(objJson.tidInfo.TID);
			$("#div1 #mid").html(objJson.tidInfo.MID);
			$("#div1 #gid").html(objJson.tidInfo.GID);
			$("#div1 #vid").html(objJson.tidInfo.VID);
			
			$("#div2 #APP_REQ_DNT").html(objJson.tidInfo.APP_REQ_DNT);
			$("#div2 #APP_DNT").html(objJson.tidInfo.APP_DNT);
			$("#div2 #GOODS_NM").html(objJson.tidInfo.GOODS_NM);
			$("#div2 #GOODS_AMT").html(IONPay.Utils.fnAddComma(objJson.tidInfo.GOODS_AMT) + "원");
			$("#div2 #GOODS_SPL_AMT").html(IONPay.Utils.fnAddComma(objJson.tidInfo.GOODS_SPL_AMT) + "원");
			$("#div2 #GOODS_VAT").html(IONPay.Utils.fnAddComma(objJson.tidInfo.GOODS_VAT) + "원");
			
			$("#div2 #UID").html(objJson.tidInfo.UID);
			$("#div2 #ORD_NM").html(objJson.tidInfo.ORD_NM);
			$("#div2 #RSLT_CD").html(objJson.tidInfo.RSLT_CD);
			$("#div2 #PM_MTHD_CD").html(objJson.tidInfo.PM_MTHD_CD);
			$("#div2 #PGSW_VER").html(objJson.tidInfo.PGSW_VER);
			$("#div2 #MBS_DVC_ID").html(objJson.tidInfo.MBS_DVC_ID);
			
			
			$("#div2 #MBS_SCK_ID").html(objJson.tidInfo.MBS_SCK_ID);
			$("#div2 #RSLT_SND_ST").html(objJson.tidInfo.RSLT_SND_ST);
			$("#div2 #RSLT_SND_DNT").html(objJson.tidInfo.RSLT_SND_DNT_FULL);
			$("#div2 #AUTO_CHRG_CD").html(objJson.tidInfo.AUTO_CHRG_CD);
			$("#div2 #PNT_ID").html(objJson.tidInfo.PNT_ID);
			
			$("#div2 #RE_SND_FLG").html(objJson.tidInfo.RE_SND_FLG);
			$("#div2 #SND_DNT").html(objJson.tidInfo.SND_DNT_FULL);
			$("#div2 #RCV_DNT").html(objJson.tidInfo.RCV_DNT_FULL);
			
			//sendCancelBtn에 취소요청에 필요한 DATA set
			$("#sendCancelBtn").data("TID", objJson.tidInfo.TID);
			$("#sendCancelBtn").data("MID", objJson.tidInfo.MID);
			$("#sendCancelBtn").data("APP_NO", objJson.tidInfo.APP_NO);
			$("#sendCancelBtn").data("APP_DT", objJson.tidInfo.APP_DT);
			$("#sendCancelBtn").data("GOODS_AMT", objJson.tidInfo.GOODS_AMT);
			$("#sendCancelBtn").data("MBS_KEY", objJson.tidInfo.MBS_KEY);
			$("#sendCancelBtn").data("REG_ID", strWorker);
			
			//$("#div1 #connTypeNm").html(objJson.tidInfo.CONN_TYPE_NM);


			/* $("#div2 #app_dt").html(objJson.tidInfo.APP_DT+" "+objJson.tidInfo.APP_TM);
			$("#div2 #app_acqu_dt").html(objJson.tidInfo.APP_ACQ_DT);
			$("#div2 #app_ret_dt").html(
					(objJson.tidInfo.APP_RET_DT==null?"":objJson.tidInfo.APP_RET_DT)
					 + (objJson.tidInfo.APP_RET_CNT!=0 ? ("("+objJson.tidInfo.APP_RET_CNT+")" ): "0")
			);
			$("#div2 #app_rea_dt").html(
					(objJson.tidInfo.APP_REA_DT==null?"":objJson.tidInfo.APP_REA_DT)
						+ (objJson.tidInfo.APP_RET_CNT!=0 ? ("("+objJson.tidInfo.APP_RET_CNT+")" ): "0")
			);
			$("#div2 #app_settlmnt_dt").html(objJson.tidInfo.APP_STMT_DT);
			$("#div2 #app_van").html(objJson.tidInfo.APP_VAN);

			$("#div2 #cc_dt").html((objJson.tidInfo.CC_DT==null?"":objJson.tidInfo.CC_DT)+" "+(objJson.tidInfo.CC_TM==null?"":objJson.tidInfo.CC_TM));
			$("#div2 #cc_acqu_dt").html(objJson.tidInfo.CC_ACQ_DT);
			$("#div2 #cc_ret_dt").html(
					(objJson.tidInfo.CC_RET_DT==null?"":objJson.tidInfo.CC_RET_DT)
					 + (objJson.tidInfo.CC_RET_CNT!=0 ? ("("+objJson.tidInfo.CC_RET_CNT+")" ): "0")
			);
			$("#div2 #cc_rea_dt").html(
					(objJson.tidInfo.CC_REA_DT==null?"":objJson.tidInfo.CC_REA_DT)
					+ (objJson.tidInfo.CC_RET_CNT!=0 ? ("("+objJson.tidInfo.CC_RET_CNT+")" ): "0")
					);
			$("#div2 #acqu_van").html(objJson.tidInfo.ACQU_VAN);

			$("#div2 #cardNm").html(objJson.tidInfo.CARD_NM);
			$("#div2 #mbsNo").html(objJson.tidInfo.MBS_NO);

			if(objJson.mngList[0].EMP_NO == "linkpay"){
				$("#div2 #aChk").html(
						'<div id="maskNo_0"><a href="#" onclick="fnDecCardNo(\''+map.get("TID")+'\');">'+objJson.tidInfo.CARD_NO+'</a></div>'
			            +'<div id="unMaskNo_0"></div>'
				);
			}else{
				$("#div2 #aChk").html(objJson.tidInfo.CARD_NO);
			}
			$("#div2 #app_no").html(objJson.tidInfo.APP_NO);
			$("#div2 #mall_user_id").html(objJson.tidInfo.MBS_USR_ID);

			$("#div2 #goods_nm").html(objJson.tidInfo.GOODS_NM);
			$("#div2 #goods_amt").html(objJson.tidInfo.GOODS_AMT);
			$("#div2 #instmnt_mon").html(objJson.tidInfo.QUOTA_MON + "개월"
					+ (objJson.tidInfo.NOINT_FLG=="1"?"(무)":" "));
			//$("#div2 #card_cl").html(objJson.tidInfo.CHKCARD_FLG=="1"?"체크카드":"일반");
			$("#div2 #sales_cp").html(objJson.tidInfo.MBS_HP);
			$("#div2 #req_dt").html(objJson.tidInfo.REQ_DT);


			$("#div3 #state_nm").html(objJson.tidInfo.STATE_NM);
			$("#div3 #moid").html(objJson.tidInfo.ORD_NO);
			$("#div3 #cc_nm").html(objJson.tidInfo.CC_NM);
			$("#div3 #cc_msg").html(objJson.tidInfo.CC_MSG);

			if(objJson.tidInfo.TRX_CD == "1"){
				$("#tb_serTid #div4").show();
				$("#div4 #dev_reg_dt").html(objJson.tidInfo.DEV_REG_DT);
				$("#div4 #dev_cmp_dt").html(objJson.tidInfo.DEV_CMP_DT);
				$("#div4 #buy_conf_dt").html(objJson.tidInfo.BUY_CONF_DT);
				$("#div4 #buy_rej_dt").html(objJson.tidInfo.BUY_REJ_DT);
				$("#div4 #buy_rej_desc").html(objJson.tidInfo.BUY_REJ_DESC);

				$("#div4 #ord_soc_no").html(objJson.tidInfo.ORD_SOC_NO);
				$("#div4 #dev_co").html(objJson.tidInfo.DEV_CO);
				$("#div4 #dev_no").html(objJson.tidInfo.DEV_NO);
				$("#div4 #dev_addr").html(objJson.tidInfo.DEV_ADDR);
			} 

			$("#div5 #ORD_NM").html(objJson.tidInfo.ORD_SOC_NO);
			$("#div5 #dev_co").html(objJson.tidInfo.DEV_CO);
			$("#div5 #dev_no").html(objJson.tidInfo.DEV_NO);
			$("#div5 #dev_addr").html(objJson.tidInfo.DEV_ADDR);

			$("#div5 #rcvr_nm").html(objJson.tidInfo.RCVR_NM);
			$("#div5 #rcvr_cp").html(objJson.tidInfo.RCVR_CP);
			$("#div5 #rcvr_msg").html(objJson.tidInfo.RCVR_MSG);
			$("#div5 #strRcvAddrDec").html(objJson.tidInfo.RCVR_ADDR); */

		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}
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
// 			$("#modalPwChk #maskNo_0").css("display" , "none");
// 			$("#modalPwChk #unMaskNo_0").css("display" , "block");
			$("#div2 #maskNo_0").hide();
			$("#div2 #unMaskNo_0").show();
			$("#div2 #unMaskNo_0").html(objJson.data.data);
			$("#modalPwChk .close").click();

		}else{
			IONPay.Msg.fnAlertWithModal(objJson.data.resultMsg, "modalPwChk");
		}
	}else{
		IONPay.Msg.fnAlertWithModal("비밀번호 확인에 실패하였습니다" + objJson.resultMessage, "modalPwChk");
	}
}

function fnCancelTrans(){

	if($("#frmCardCC input[name=cseq]").val() == "-1" && $("#frmCardCC input[name=canFlag]").val() == "0"){
		IONPay.Msg.fnAlert("해당거래는 부분취소내역이 존재하므로 전체취소를 하실 수 없습니다.\n부분취소로 취소 해주시기 바랍니다.");
		$("#frmCardCC input[name=canFlag]").focus();
		return;
	}
	if($("#frmCardCC input[name=canGoods]").val() == "" || $("#frmCardCC input[name=canGoods]").val() <  0){
		IONPay.Msg.fnAlert("취소금액을 입력해주세요.");
		$("#frmCardCC input[name=canGoods]").focus();
		return;
	}
	if($("#frmCardCC input[name=remainOrg]").val() < $("#frmCardCC input[name=canGoods]").val()){
		IONPay.Msg.fnAlert("취소금액이 잔액보다 큽니다. 다시 입력해주세요.");
		$("#frmCardCC input[name=canGoods]").val("");
		$("#frmCardCC input[name=canGoods]").focus();
		return;
	}
	if($("#frmCardCC input[name=cseq]").val() == "-1" && $("#frmCardCC input[name=canFlag]").val() == "1"){
		if($("#frmCardCC input[name=remainOrg]").val() == $("#frmCardCC input[name=canGoods]").val()){
			IONPay.Msg.fnAlert("전체 금액에 대한 취소는 전체취소로 취소해주시기 바랍니다.");
			$("#frmCardCC input[name=canFlag]").focus();
			return;
		}
	}

	$("#frmCardCC input[name=canAmt]").val($("#frmCardCC input[name=canGoods]").val());
	$("#frmCardCC input[name=PartialCancelCode]").val($("#frmCardCC input[name=canFlag]").val());

	if($("#frmCardCC input[name=canNm]").val() == ""){
		IONPay.Msg.fnAlert("취소 작업자를 입력해주세요.");
		$("#frmCardCC input[name=canNm]").focus();
		return;
	}
	if($("#frmCardCC input[name=REASON_DESC]").val() == ""){
		IONPay.Msg.fnAlert("취소 사유를 입력해주세요.");
		$("#frmCardCC input[name=REASON_DESC]").focus();
		return;
	}

	if(confirm("강제 취소하시겠습니까?\n취소를 원하시면 확인 버튼을 클릭하십시오.") == false){
		return;
	}else {
		
		arrParameter["TID"] = $("#sendCancelBtn").data("TID");
		arrParameter["APP_NO"] = $("#sendCancelBtn").data("APP_NO");
		arrParameter["APP_DT"] = $("#sendCancelBtn").data("APP_DT");
		arrParameter["REG_ID"] = $("#sendCancelBtn").data("REG_ID");
		arrParameter["MID"] = $("#sendCancelBtn").data("MID");
		arrParameter["CC_PASSWORD"] = $("#CC_PASSWORD").val();
		arrParameter["GOODS_AMT"] = $("#sendCancelBtn").data("GOODS_AMT");
		arrParameter["REASON_DESC"] = $("#REASON_DESC").val();
		arrParameter["MBS_KEY"] = $("#sendCancelBtn").data("MBS_KEY");

	    strCallUrl   = "/paymentMgmt/payInquiry/sendCancelHandShake.do";
	    strCallBack  = "fnCancelHandShakeRet";

	    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	}

	/* if(confirm("강제 취소하시겠습니까?\n취소를 원하시면 확인 버튼을 클릭하십시오.") == false){
// 		return;
	}else{
		//결제취소 api ->common/cancel/payCancelProcess.jsp

		arrParameter = $("#frmCardCC").serializeObject();
		arrParameter = $("#frmSearch").serializeObject();
// 		arrParameter["fromdate"] = $("#frmSearch input[name=fromdate]").val();
// 		arrParameter["todate"] = $("#frmSearch input[name=todate]").val();
	    strCallUrl   = "/paymentMgmt/card/selectTransInfoTotalList.do";
	    strCallBack  = "fnSumInquiryRet";

	    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
	} */
}

function fnCancelHandShakeRet(objJson){
	
	var result = objJson.ret.result_code;
	
	if(result == "0000"){		
		//IONPay.Msg.fnAlert(objJson.ret.result_message);
		fnSendCancel(objJson.ret.cc_seq);
		//$("#divTidList #state0").hide();
	}else{
		IONPay.Msg.fnAlert(objJson.ret.result_message);
	}
}

function fnSendCancel(cc_seq){
	arrParameter["TID"] = $("#sendCancelBtn").data("TID");
	arrParameter["APP_NO"] = $("#sendCancelBtn").data("APP_NO");
	arrParameter["APP_DT"] = $("#sendCancelBtn").data("APP_DT");
	arrParameter["MID"] = $("#sendCancelBtn").data("MID");
	arrParameter["GOODS_AMT"] = $("#sendCancelBtn").data("GOODS_AMT");
	arrParameter["GOODS_AMT"] = $("#sendCancelBtn").data("GOODS_AMT");
	arrParameter["CC_SEQ"] = cc_seq;
	arrParameter["MBS_KEY"] = $("#sendCancelBtn").data("MBS_KEY");
	arrParameter["REG_ID"] = strWorker;

    strCallUrl   = "/paymentMgmt/payInquiry/sendCancel.do";
    strCallBack  = "fnCancelRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnCancelRet(objJson){
	var result = objJson.ret.result_code;
	
	if(result == "0000"){		
		IONPay.Msg.fnAlert(objJson.ret.result_message);
		$("#divTidList #state0").hide();
	}else{
		IONPay.Msg.fnAlert(objJson.ret.result_message);
	}
}

function fnRecTrans() {
	if($("#frmCardCC #recNm").val() == ""){
		IONPay.Msg.fnAlert("원복작업자를 입력해주세요");
		$("#frmCardCC #recNm").focus();
		return;
	}
	if($("#frmCardCC #recMsg").val() == ""){
		IONPay.Msg.fnAlert("원복사유를 입력해주세요");
		$("#frmCardCC #recMsg").focus();
		return;
	}

	if(confirm("후취소 원복하시겠습니까?\n원복하시려면 확인 버튼을 클릭하십시오.") == false){
		return;
	}else{
		//취소원복 api - > trans/ReCoverTrans.jsp



	}
  }
//APP_NO으로 모달 생성
function fnSerIssue(tid, appDt) {
		if( confirm("두가지 중 필요로 하는 것을 선택하세요(확인 : 거래확인서, 취소 : 소보법메일)") ) {
			// 거래확인서 출력 - > 서버에 쏘는 거 ????
// 			var	f	=	parent.formFrame.document.mainForm;
// 			var	status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,width=414,height=622";
// 			var trDoc = js_OpenWindow("about:blank", "popupIssue", 414, 622);
// 			//var trDoc = window.open("about:blank","popupIssue",status);
// 			f.target = "popupIssue";

// 			f.submit();
		} else {
			//소보법 메일 발송내역 조회
			arrParameter["tid"] = tid;
			arrParameter["pmCd"] = "01";
			arrParameter["appDt"] = appDt;
			arrParameter["strDate"] = map.get("strDate");
		    strCallUrl   = "/paymentMgmt/card/selectMailSendSearch.do";
		    strCallBack  = "fnMailSendSearchRet";

		    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
		}
	}
//소보법 메일 발송내역 조회
function fnMailSendSearch(){
	arrParameter = $("#frmSearch").serializeObject();
    strCallUrl   = "/paymentMgmt/card/selectMailSendSearch.do";
    strCallBack  = "fnMailSendSearchRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

//각각 버튼 누를때 발송, 재발송
function fnMailSendSearchRet(objJson){
	if(objJson.resultCode == 0 ){
		if(objJson.dataList != null){
			$("#div_mailReSend").css("display", "block");
			$("#div_searchResult").hide();
			$("#tbMailReSend").show();
			$("#tbMailReSendInfo").hide();

			var str = "";
			for(var i=0; i<objJson.dataList.length;i++){
				str += "<tr>";
				str += "<input type='hidden' name='Seq_"+(i+1)+"' value="+objJson.dataList[i].SEQ+">";
				str += "<input type='hidden' name='TableNm_"+(i+1)+"' value="+objJson.dataList[i].TABLE_NM+">";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].SEQ+"</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].SND_DT +"  " +objJson.dataList[i].SND_TM+ "</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].GOODS_NM+"</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'>"+objJson.dataList[i].ORD_NM+"</td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'><input type='text' name='Email_"+(i+1)+"' value='"+objJson.dataList[i].ORD_EMAIL+"' maxlength='60'></td>";
				str += "<td style='border:1px solid #c2c2c2; background-color:#ecf0f2;'><button type='button' onclick='sendMail('"+(i+1)+"');'>재발송</button></td>";
				str += "</tr>";
			}
			$("#tbody_reMailList").html(str);
		}else{
			if(objJson.data != null){
				$("#div_mailReSend").css("display", "block");
				$("#div_searchResult").hide();
				$("#tbMailReSend").hide();
				$("#tbMailReSendInfo").show();

				$("#tbMailReSendInfo #goodsNm").html(objJson.data.GOODS_NM);
				$("#tbMailReSendInfo #ordNm").html(objJson.data.ORD_NM);
				$("#tbMailReSendInfo #stateNm").html(objJson.data.stateNm==null?"":objJson.data.stateNm);
				$("#tbMailReSendInfo input[name=tid]").val(objJson.data.TID);
				$("#tbMailReSendInfo input[name=appDt]").val(objJson.data.APP_DT);
				$("#tbMailReSendInfo input[name=appTm]").val(objJson.data.APP_TM);
				$("#tbMailReSendInfo input[name=ccDt]").val(objJson.data.CC_DT);
				$("#tbMailReSendInfo input[name=ccTm]").val(objJson.data.CC_TM);
				$("#tbMailReSendInfo input[name=stateCd]").val(objJson.data.TRX_ST_CD);
				$("#tbMailReSendInfo input[name=pmCd]").val(objJson.data.PM_CD);
				///$("#tbMailReSendInfo input[name=spmCd]").val(objJson.data.SPM_CD);
				$("#tbMailReSendInfo input[name=amt]").val(objJson.data.GOODS_AMT);
				$("#tbMailReSendInfo input[name=goodsNm]").val(objJson.data.GOODS_NM);
				$("#tbMailReSendInfo input[name=ordNm]").val(objJson.data.ORD_NM);
				$("#tbMailReSendInfo input[name=ordTel]").val(objJson.data.ORD_TEL);
				$("#tbMailReSendInfo input[name=appNo]").val(objJson.data.APP_NO);
				$("#tbMailReSendInfo input[name=instmntMon]").val(objJson.data.QUOTA_MON);
				$("#tbMailReSendInfo input[name=noInterestCl]").val(objJson.data.NOINT_FLG);
				$("#tbMailReSendInfo input[name=moid]").val(objJson.data.ORD_NO);
				$("#tbMailReSendInfo input[name=cpCd]").val(objJson.data.CP_CD);
				$("#tbMailReSendInfo input[name=payNo]").val(objJson.data.PAY_NO);
				$("#tbMailReSendInfo input[name=mid]").val(objJson.data.MID);
			}
		}
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

function fnSelectCardInfoTotAmt(){
	arrParameter = $("#frmSearch").serializeObject();
    //strCallUrl   = "/paymentMgmt/card/selectCardTotalAmt.do";
    strCallUrl   = "/paymentMgmt/payInquiry/selectCardTotalAmt.do";
    strCallBack  = "fnSelectCardInfoTotAmtRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

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
function fnSelectCardInfoTotAmtRet(objJson){
	if(objJson.resultCode == 0 ){
		$("#div_searchSumResult").css("display", "block");

		$("#tbCardTransTotalAmt #rAppCnt").html(objJson.data[0].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #rAppAmt").html(IONPay.Utils.fnAddComma(objJson.data[0].TRAN_AMT)+"원");
		
		$("#tbCardTransTotalAmt #totAppCnt").html(objJson.data[0].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #totAppAmt").html(IONPay.Utils.fnAddComma(objJson.data[0].TRAN_AMT)+"원");

		$("#tbCardTransTotalAmt #rCanCnt").html(objJson.data[1].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #rCanAmt").html(IONPay.Utils.fnAddComma(objJson.data[1].TRAN_AMT)+"원");
		
		$("#tbCardTransTotalAmt #totCanCnt").html(objJson.data[1].TRAN_CNT+"건");
		$("#tbCardTransTotalAmt #totCanAmt").html(IONPay.Utils.fnAddComma(objJson.data[1].TRAN_AMT)+"원");
		
		
		$("#tbCardTransTotalAmt #rTotCnt").html(  (objJson.data[0].TRAN_CNT + objJson.data[1].TRAN_CNT)  +"건");
		$("#tbCardTransTotalAmt #rTotAmt").html(  IONPay.Utils.fnAddComma(  objJson.data[0].TRAN_AMT - objJson.data[1].TRAN_AMT  )  +"원");
		$("#tbCardTransTotalAmt #totTotCnt").html(  (objJson.data[0].TRAN_CNT + objJson.data[1].TRAN_CNT)  +"건");
		$("#tbCardTransTotalAmt #totTotAmt").html(  IONPay.Utils.fnAddComma(  objJson.data[0].TRAN_AMT - objJson.data[1].TRAN_AMT  )  +"원");

	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
		$("#tbCardAmtInfo").hide();
	}
}

function fnSumInquiry(){
	/* arrParameter = $("#frmSearch").serializeObject();
    strCallUrl   = "/paymentMgmt/card/selectTransInfoTotalList.do";
    strCallBack  = "fnSumInquiryRet";

    IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack); */
}
function fnSumInquiryRet(objJson){
	/* if(objJson.resultCode == 0 ){
		$("#div_searchResult").css("display", "none");
		$("#div_searchSumResult").css("display", "block");
		var str = "";
		for(var i =0; i<objJson.data.length ; i++ ){
			str += "<tr style='text-align: center;'><td rowspan='3'>" + objJson.data[i].TR_DT+ "</td>" ;
			str += "<td>승인</td>";
			str += "<td>"+ objJson.data[i].REALAPPCNT+"</td>";
			str += "<td>"+ objJson.data[i].REALAPPAMT+"</td>";
			str += "<td>"+ objJson.data[i].TESTAPPCNT+"</td>";
			str += "<td>"+ objJson.data[i].TESTAPPAMT+"</td></tr>";
			str += "<tr style='text-align: center;'><td>취소</td>";
			str += "<td>"+ objJson.data[i].REALCCCNT+"</td>";
			str += "<td>"+ objJson.data[i].REALCCAMT+"</td>";
			str += "<td>"+ objJson.data[i].TESTCCCNT+"</td>";
			str += "<td>"+ objJson.data[i].TESTCCAMT+"</td></tr>";
			str += "<tr  style='text-align: center;'><td>합계</td>";
			str += "<td>"+ objJson.data[i].REALTOTCNT+"</td>";
			str += "<td>"+ objJson.data[i].REALTOTAMT+"</td>";
			str += "<td>"+ objJson.data[i].TESTTOTCNT+"</td>";
			str += "<td>"+ objJson.data[i].TESTTOTAMT+"</td></tr>";

		}
		$("#tbCardTransTotalList #tbody_cardTotList").html(str);

		//IONPay.Utils.fnHideSearchOptionArea();
	}else{
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
 */
}
function fnSumInquiry1() {
    /* $("#div_searchResult").hide();
    $("#div_searchResult").css("display" , "none");

    $("#div_searchSumResult").serializeObject();
    $("#div_searchSumResult").show(200);

    if (typeof objCoMInfoInquiry == "undefined") {
		objCoMInfoInquiry  = IONPay.Ajax.CreateDataTable("#tbCardTransTotalList", true, {
        url: "/paymentMgmt/card/selectTransInfoTotalList.do",
        data: function() {
            return $("#frmSearch").serializeObject();
        },
        columns: [
			{ "class" : "columnc all",         "data" : null, "render": function(data,row){

				 return  data.FR_DT==null?"":data.REALTOTCNT

			} },
             { "class" : "columnc all",         "data" : null, "render": function(data){

            	 return  data.REALTOTCNT==null?"":data.REALTOTCNT

             } },
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REALTOTAMT==null?"":data.REALTOTAMT} },
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REALTOTCNT==null?"":data.REALTOTCNT} },
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REALTOTAMT==null?"":data.REALTOTAMT} },
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REALTOTCNT==null?"":data.REALTOTCNT} },
             { "class" : "columnc all",         "data" : null, "render": function(data){return  data.REALTOTAMT==null?"":data.REALTOTAMT} }
            ]
	    }, true);

	} else {
		objCoMInfoInquiry.clearPipeline();
		objCoMInfoInquiry.ajax.reload();
	}
	//IONPay.Utils.fnShowSearchArea();
	//IONPay.Utils.fnHideSearchOptionArea(); */



}

function fnShowReceipt(ordNo, payDate, payNo, goodsNm, payType, amt,
		coNm, coNo, repNm, addr, reqTel, uid, cc_dt, spl_amt, vat, svc_fee) {	
	$("#RC_ORD_NO").text(ordNo);
	$("#RC_USR_ID").text(uid);
	if(cc_dt == '' || cc_dt == null || cc_dt == undefined ){
		$("#RC_PAY_TYPE").text("승인");	
	}else{
		$("#RC_PAY_TYPE").text("취소");
	}
	
	
	$("#RC_SPL_AMT").text(IONPay.Utils.fnAddComma(spl_amt));
	$("#RC_VAT").text(IONPay.Utils.fnAddComma(vat));
	
	if(svc_fee == 'null' || svc_fee == null || svc_fee == undefined){
		$("#RC_SVC_FEE").text("0");	
	}else{
		$("#RC_SVC_FEE").text(IONPay.Utils.fnAddComma(svc_fee));
	}
	
	$("#RC_AMT").text(IONPay.Utils.fnAddComma(amt));
	
	$("#RC_PAY_DATE").text(payDate);
	$("#RC_PAY_NO").text(payNo);
	$("#RC_GOODS_NM").text(goodsNm);
	
	
	$("#RC_CO_NM").text(coNm);
	$("#RC_CO_NO").text(IONPay.Utils.fnStringToLicenseFormat(coNo));
	$("#RC_REP_NM").text(repNm);
	$("#RC_ADDR").text(addr);
	$("#RC_REQ_TEL").text(IONPay.Utils.fnStringToPhoneFormat(reqTel));
	
	$("#RC_SHOP_NM").text(coNm);
	
	//fnReceiptPopupOpen(payNo);
	$('#divApplyMerchantModal').modal('show');
}

function fnReceiptPopupOpen(tid) {	
	var url= "/paymentMgmt/payInquiry/payReceiptPopup.do?tid=" + tid;    //팝업창 페이지 URL
	var winWidth = 375;
    var winHeight = 540;
    var popupOption= "width="+winWidth+", height="+winHeight;    //팝업창 옵션(optoin)
	window.open(url,"",popupOption);
}

function fnCloseDetail() {
	$("#div_search").show();
	$("#divTidList").hide();
}

</script>

<style>
.receipt {
	border: 1px solid #999999;
}

.receipt-td {
	border-left: 0px;
	border-right: 0px;
	border-top: 1px solid #999999;
	border-bottom: 1px solid #999999;
	background-color: white;
	width: 40px;
}

.receipt-header {
	border-left: 1px solid #999999;
	border-right: 0px;
	border-top: 1px solid #999999;
	border-bottom: 1px solid #999999;
	background-color: white;
	width: 80px;
}

.receipt-mid {
	border-left: 0px;
	border-right: 0px;
	border-top: 1px solid #999999;
	border-bottom: 1px solid #999999;
	background-color: white;
	width: 1px;
}

.receipt-content {
	border-right: 1px solid #999999;
	color: black;
	text-align: left;
}

.receipt-content-sub {
	border-left: 0px;
	border-right: 0px;
	border-top: 1px solid #999999;
	border-bottom: 1px solid #999999;
	background-color: white;
	color: black;
	text-align: right;
}

.receipt-won {
	border-left: 0px;
	border-right: 1px solid #999999;
	border-top: 1px solid #999999;
	border-bottom: 1px solid #999999;
	background-color: white;
	color: black;
	width: 1px;
}

#receiptTempCenter {
	text-align:center;
}

.detail-th {
	background-color: #ecf0f2;
	color: black;
	font-weight: bold;
}

.detail-td {
	background-color: white;
	color: black;
	
}

.list-amt {
	text-align : right !important
}

</style>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <div class="content">
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.PAY_INQUIRY }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
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
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <!-- <div class="row form-row" >
                                        <div class="col-md-3">
                                            <select id="searchFlg" name="searchFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" id="txtSearch" name="txtSearch" class="form-control" readonly>
                                        </div>
                                    </div> -->
                                    
                                    <div class="row form-row" >
                                        <div class="col-md-3">
                                        	<label class="form-label">&nbsp;</label>
                                            <select id="searchPayFlg" name="searchPayFlg" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                        	<label class="form-label">&nbsp;</label>
                                            <input type="text" id="txtPaySearch" name="txtPaySearch" class="form-control" readonly>
                                        </div>
                                    <!-- </div>
                                    
                                    <div class="row form-row"  style="padding:0 0 10px 0;"> -->
                                    
                                        <%-- <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0082'/></label>
                                            <select id="cardFlg" name="cardFlg" class="select2 form-control">
                                            </select>
                                        </div> --%>
                                      	<div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_SM_SV_0017'/></label>
                                             <select id="settleCycle" name="settleCycle" class="select2 form-control">
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BIM_BM_0078'/></label>
                                            <select id="status" name="status" class="select2 form-control">
                                            </select>
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
				                                  <button type="button" id="btnSumSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BIM_BM_0151'/></button>
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
                                            <table id="tbCardAmtInfo" class="table" style="width:50%">
                                                <thead>
                                                 <tr>
                                                     <th ><spring:message code='IMS_BIM_BM_0152'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0153'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0154'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0155'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0156'/></th>
			                                         <th ><spring:message code='IMS_BIM_BM_0157'/></th>
                                                 </tr>
                                                </thead>
                                                <tr style="text-align: right;;">
                                                	<td class="list-amt" id="appCnt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
                                                	<td class="list-amt" id="appAmt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
                                                	<td class="list-amt" id="canCnt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
                                                	<td class="list-amt" id="canAmt" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
                                                	<td class="list-amt" id="cntSum" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
                                                	<td class="list-amt" id="amtSum" style='text-align: center; border: 1px solid #c2c2c2; background-color: #FFFFFF;'></td>
                                                </tr>
                                            </table>
                                            <table id="tbCardTransList" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                 	 <th >No</th>
                                                 	 <th ><spring:message code='IMS_PW_DE_12'/></th><%--TID --%>
                                                 	 <th >가맹점명</th>
                                                 	 
                                                     <th ><spring:message code='IMS_BIM_BM_0158'/></th>
                                                     <th >결제시간</th>
                                                     <th ><spring:message code='IMS_BIM_BM_0159'/></th>
                                                     <th >취소시간</th>
                                                     <%-- <th ><spring:message code='IMS_PW_DE_01'/></th> --%>
                                                     <th ><spring:message code='IMS_PW_DE_03'/></th>
                                                     <th >상품명</th>
                                                     
			                                         <th ><spring:message code='IMS_BIM_BM_0160'/></th>
                                                     <th ><spring:message code='IMS_SM_SR_0029'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0166'/></th>
                                                     <th ><spring:message code='IMS_TV_TH_0020'/></th>
                                                     <th ><spring:message code='IMS_MENU_SUB_0146'/></th>
                                                     
                                                 </tr>
                                            	</thead>
                                            </table>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>
                                </div>
                                <div id="div_searchSumResult" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbCardTransTotalAmt" class="table" style="width:100%">
                                                <thead>
                                                 <tr>
                                                     <th><spring:message code='IMS_BIM_BM_0167'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0101'/></th>
                                                     <th>이롬머니 거래 건수</th>
                                                     <th>이롬머니 거래 금액</th>
                                                     <%-- <th><spring:message code='IMS_BIM_BM_0170'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0171'/></th> --%>
                                                     <th><spring:message code='IMS_BIM_BM_0172'/></th>
                                                     <th><spring:message code='IMS_BIM_BM_0173'/></th>
                                                 </tr>
                                                </thead>
                                                <tr style="text-align: center;">
                                                	<td rowspan="3" id="date"></td>
                                                	<td><spring:message code='IMS_BIM_BM_0174'/></td><!-- 승인 -->
                                                	<td class="list-amt" id="rAppCnt"></td>
                                                	<td class="list-amt" id="rAppAmt"></td>
                                                	<!-- <td id="tAppCnt"></td>
                                                	<td id="tAppAmt"></td> -->
                                                	<td class="list-amt" id="totAppCnt"></td>
                                                	<td class="list-amt" id="totAppAmt"></td>
                                                </tr>
                                                <tr style="text-align: center;">
                                                	<td><spring:message code='IMS_BIM_BM_0175'/></td><!-- 취소  -->
                                                	<td class="list-amt" id="rCanCnt"></td>
                                                	<td class="list-amt" id="rCanAmt"></td>
                                                	<!-- <td id="tCanCnt"></td>
                                                	<td id="tCanAmt"></td> -->
                                                	<td class="list-amt" id="totCanCnt"></td>
                                                	<td class="list-amt" id="totCanAmt"></td>
                                                </tr>
                                                
                                                <!-- 환불  -->
                                                <%-- <tr style="text-align: center;">
                                                	<td><spring:message code='IMS_BIM_BM_0185'/></td>
                                                	<td id="rRefundCnt"></td>
                                                	<td id="rRefundAmt"></td>
                                                	<td id="tRefundCnt"></td>
                                                	<td id="tRefundAmt"></td>
                                                	<td id="totRefundCnt"></td>
                                                	<td id="totRefundAmt"></td>
                                                </tr> --%>
                                                
                                                <tr style="text-align: center;">
                                                	<td><spring:message code='IMS_BIM_BM_0176'/></td><!-- 합계 -->
                                                	<td class="list-amt" id="rTotCnt"></td>
                                                	<td class="list-amt" id="rTotAmt"></td>
                                                	<!-- <td id="tTotCnt"></td>
                                                	<td id="tTotAmt"></td> -->
                                                	<td class="list-amt" id="totTotCnt"></td>
                                                	<td class="list-amt" id="totTotAmt"></td>
                                                </tr>
                                            </table>
                                            <%-- <table id="tbCardTransTotalList" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <th ><spring:message code='IMS_PV_MP_0002'/></th>
                                                     <th ><spring:message code='IMS_BIM_CCS_0034'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0168'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0169'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0170'/></th>
                                                     <th ><spring:message code='IMS_BIM_BM_0171'/></th>
                                                 </tr>
                                            	</thead>
                                            	<tbody id="tbody_cardTotList"></tbody>
                                            </table> --%>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>
                                </div>
                                <form id="frmMailReSend">
                                <div id="div_mailReSend" style="display:none;">
                                    <div class="grid simple ">
                                        <div class="grid-body " id="">
                                            <table id="tbMailReSend" class="table" style="width:100%">
                                                <thead>
                                                	<tr >
												        <th align='center'>NO</th>
												        <th align='center'>발송일시</th>
												        <th align='center'>상품명</th>
												        <th align='center'>구매자</th>
												        <th align='center'>E-Mail</th>
												        <th align='center'>발송</th>
											        </tr>
                                                 </thead>
                                                 <tbody id="tbody_reMailList"></tbody>
                                           	</table>
                                            <table id="tbMailReSendInfo" class="table" style="width:100%">
                                            	<thead>
                                            		<tr>
                                                     <td align='center' style="border:1px solid #c2c2c2; background-color:#ecf0f2;">1</td>
											         <td align='center'  style="border:1px solid #c2c2c2; background-color:#ecf0f2;"></td>
											         <td align='left' id="goodsNm"  style="border:1px solid #c2c2c2; background-color:#ecf0f2;">&nbsp;</td>
											         <td align='left' id="ordNm" style="border:1px solid #c2c2c2; background-color:#ecf0f2;">&nbsp;</td>
											         <!-- <td align='center' id="stateNm"></td> -->
											         <td align='left' id="ordEmail" style="border:1px solid #c2c2c2; background-color:#ecf0f2;">&nbsp;&nbsp;
											         	<input type='text' name='ordEmail'  class="form-control" maxlength='60' ">
										         	 </td>
											         <td align='center'  style="border:1px solid #c2c2c2; background-color:#ecf0f2;">
											         	<button type='button' name='' onclick="sendNewMail();" class="btn btn-success btn-cons">발송 </button>
										         	 </td>
                                                 </tr>
                                            	</thead>
                                            	<input type='hidden' name='tid'  >
										        <input type='hidden' name='appDt' >
										        <input type='hidden' name='appTm' >
										        <input type='hidden' name='ccDt' >
										        <input type='hidden' name='ccTm' >
										        <input type='hidden' name='stateCd' >
										        <input type='hidden' name='status' value='0'>
										        <input type='hidden' name='pmCd' >
										        <input type='hidden' name='spmCd' >
										        <input type='hidden' name='amt' >
										        <input type='hidden' name='goodsNm' >
										        <input type='hidden' name='ordNm' >
										  	    <input type='hidden' name=ordTel >
										        <input type='hidden' name='appNo'>
										        <input type='hidden' name='instmntMon' >
										        <input type='hidden' name='nonInterestCl' >
										        <input type='hidden' name='moid' >
										        <input type='hidden' name='cpCd' >
										        <input type='hidden' name='payNo' >
										        <input type='hidden' name='mid' >
										        <input type='hidden' name='templateId' >
                                            </table>
                                            <table width='800' border='0' cellspacing='0' cellpadding='0'>
												<tr height='20'><td>&nbsp;</td></tr>
												<tr height='17'>
													<td align='right'>
														<button type='button' name='' class="btn btn-success btn-cons" onclick="listShow();">목록</button>
													</td>
												</tr>
												<tr height='20'><td>&nbsp;</td></tr>
											</table>
                                            <div class="col-md-9"></div>
                                        </div>
                                    </div>
                                </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END SEARCH LIST AREA -->



                 <!-- BEGIN SEARCH LIST AREA -->
                 <form id="frmCardCC">
                <div id="divTidList" class="row" style="display:none;">
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
						                	<input type='hidden' name='emp' >
											<input type='hidden' name='canMID'>
											<input type='hidden' name='canTID' >
											<input type='hidden' name='canPm'  value="Card">
											<input type='hidden' name='canAmt'>
											<input type='hidden' name='canIP' >
											<input type='hidden' name='canUID'>
											<input type="hidden" name='ServerNm'  value="IMS">
											<input type='hidden' name='PartialCancelCode' value='0'>
											<!-- <input type="hidden" name="rid"  > -->
											<input type='hidden' name='ccDt' >
											<input type='hidden' name='ccTm' >
                                        	
                                        	 
			                           		
				                           <!-- // 부분취소 리스트 출력부분  -->
			                           		<div id="div_partCList">
			                           		<table border="0" cellspacing="0" cellpadding="0">
										        <tr height='5'><td>&nbsp;</td></tr>
										      </table>
				                           		<div id="div0" style="display:block;">
				                           			<table class="table" >
								                    	<thead id="thForCseq">
								                    	</thead>
				                           			</table>
				                           		</div>
			                           		</div>
				                           		<input type="hidden" name="cseq" >
											    <input type="hidden" name="remainOrg">
											      
											      <table style="width: 100%">
											      	<tr>
											      		<td>
														    <div id="div1" style="display:block; ">
															<table class="table" width=100%>
																<tr>
																	<th style="width:20%; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															          	<spring:message code="IMS_BIM_BM_0241"/>
															        </th>
															        <th style="width:20%; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															          	TID		<%-- <spring:message code="IMS_TV_TH_0010"/> --%>
															        </th>
															        <th style="width:20%; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															          	<spring:message code="DDLB_0137"/>
															        </th>
															        <th style="width:20%; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															          	<spring:message code="DDLB_0138"/>
															        </th>
															        <th style="width:20%; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															          	<spring:message code="DDLB_0139"/>
															        </th>
															        
															     </tr>
															     <tr>
																	<td id="pmNm" style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															          	<spring:message code="IMS_BIM_BM_0280"/>
															        </td>
															        <td id="tidVal" style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															        </td>
															        <td id="mid"style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															        </td>
															        <td id="gid"  style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															        </td>
															        <td id="vid" style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
															        </td>
															        
															     </tr>
															</table>
															</div>
												
														</td>
													</tr>
												
													<tr>
														<td>
															<table class="table" id="tb_serTid" style="width:100%; border:1px solid #ddd;">
										                    	<tbody id="state0">
										                    			<th style="padding: 3px 5px !important; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code="IMS_BIM_BM_0504"/></th>
										                    			<td style="padding: 3px 5px !important; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><input type='text' id="CC_REG_ID" name='CC_REG_ID' style="min-height: 30px;" readonly></td>
										                    			<th style="padding: 3px 5px !important; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code="IMS_BIM_BM_0505"/></th>
										                    			<td style="padding: 3px 5px !important; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><input type="password" id="CC_PASSWORD" name='CC_PASSWORD' style="min-height: 30px;" maxlength=6></td>
										                    			
										                    			<th style="padding: 3px 5px !important; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><spring:message code="IMS_TV_TH_0068"/></th>
										                    			<td style="padding: 3px 5px !important; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;"><input type='text' id="REASON_DESC" name='REASON_DESC' style="min-height: 30px;" maxlength=100 ></td>
										                    			
										                    			<td style="padding: 3px 5px !important; border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
										                    				<button type="button" id="sendCancelBtn" value="취소" onclick="fnCancelTrans();"  class="btn btn-primary btn-cons" style="margin-top: 3px; margin-bottom: 3px;">
										                    					<spring:message code="IMS_BIM_BM_0175"/>
									                    					</button>
										                    			</td>
										                    		</tr>
										                    	</tbody>
										                    	
							                           		</table>
				                           		
				                           				</td>
				                           			</tr>
				                           		
				                           		</table>
				                           		
												
											    <div id="div2"  style="display: block;">
												<table class="table">
													<tr>
														<td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
												          	승인요청일시<%-- <spring:message code="IMS_BIM_BM_0510"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;  text-align: center;">
												          	승인일시<%-- <spring:message code="IMS_BIM_BM_0511"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2; text-align: center;">
												          	상품명<%-- <spring:message code="IMS_BIM_BM_0512"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;  text-align: center;">
												          	상품가격<%-- <spring:message code="IMS_BIM_BM_0513"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;  text-align: center;">
												          	공급가액<%-- <spring:message code="IMS_BIM_BM_0514"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;  text-align: center;">
												          	부가가치세<%-- <spring:message code="IMS_BIM_BM_0515"/> --%>
												        </td>
												     </tr>
												     <tr>
														<td class="detail-td" id="APP_REQ_DNT" style="border:1px solid #c2c2c2;  text-align: center;">

												        </td>
												        <td class="detail-td" id="APP_DNT" style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td" id="GOODS_NM"style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td list-amt" id="GOODS_AMT"  style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td list-amt" id="GOODS_SPL_AMT" style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td list-amt" id="GOODS_VAT" style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												     </tr>
													<tr>
														<td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	구매자 고유번호<%-- <spring:message code="IMS_BIM_BM_0516"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	구매자명<%-- <spring:message code="IMS_BIM_BM_0517"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	결제결과 코드<%-- <spring:message code="IMS_BIM_BM_0518"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	결제방식 코드<%-- <spring:message code="IMS_BIM_BM_0519"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	결제모듈버전<%-- <spring:message code="IMS_BIM_BM_0520"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	가맹점 기기 ID<%-- <spring:message code="IMS_BIM_BM_0521"/> --%>
												        </td>
												     </tr>
												     <tr>
														<td class="detail-td" id="UID" style="border:1px solid #c2c2c2;   text-align: center;">

												        </td>
												        <td class="detail-td" id="ORD_NM" style="border:1px solid #c2c2c2;  text-align: center;">
												        </td>
												        <td class="detail-td" id="RSLT_CD"style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td" id="PM_MTHD_CD"  style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td" id="PGSW_VER" style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td" id="MBS_DVC_ID" style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												     </tr>
											     	<tr>
														<td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	가맹점 소켓 ID<%-- <spring:message code="IMS_BIM_BM_0178"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;  text-align: center;">
												          	결과통보상태<%-- <spring:message code="IMS_BIM_BM_0179"/> --%>
												        </td>
												        <td class="detail-th" colspan="2" style="border:1px solid #c2c2c2;  text-align: center;">
												          	결과통보일시<%-- <spring:message code="IMS_BIM_BM_0205"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	자동충전여부<%-- <spring:message code="IMS_TV_TH_0015"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	포인트 충전내역 ID<%-- <spring:message code="IMS_BIM_BM_0522"/> --%>
												        </td>
												     </tr>
												     <tr>
														<td class="detail-td" id="MBS_SCK_ID" style="border:1px solid #c2c2c2;   text-align: center;">

												        </td>
												        <td class="detail-td" id="RSLT_SND_ST" style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td" id="RSLT_SND_DNT" colspan="2" style="border:1px solid #c2c2c2;   text-align: center;">


												        </td>
												        <td class="detail-td" id=AUTO_CHRG_CD  style="border:1px solid #c2c2c2;   text-align: center;">
												        </td>
												        <td class="detail-td" id="PNT_ID" style="border:1px solid #c2c2c2;  text-align: center;">
												        </td>
												     </tr>
												     <tr>
														<td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;">
												          	재통보여부<%-- <spring:message code="IMS_TV_TH_0079"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;" colspan='2'>
												          	등록전송일시<%-- <spring:message code="IMS_BIM_BM_0160"/> --%>
												        </td>
												        <td class="detail-th" style="border:1px solid #c2c2c2;   text-align: center;" colspan='3'>
												          	등록수신일시<%-- <spring:message code="DDLB_0068"/> --%>
												        </td>
												        <%-- <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
												          	<spring:message code="IMS_BIM_BM_0163"/>
												        </th>
												        <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
												          	<spring:message code="IMS_BIM_BM_0523"/>
												        </th>
												        <th style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
												          	<spring:message code="IMS_BIM_BM_0524"/>
												        </th> --%>
												     </tr>
												     <tr>
														<td class="detail-td" id="RE_SND_FLG" style="border:1px solid #c2c2c2;  text-align: center;">

												        </td>
												        <td class="detail-td" id="SND_DNT" style="border:1px solid #c2c2c2; text-align: center;" colspan='2'>
												        </td>
												        <td class="detail-td" id="RCV_DNT"style="border:1px solid #c2c2c2;  text-align: center;" colspan='3'>
												        </td>
												        <!-- <td id=""  style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
												        </td>
												        <td id="" style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
												        </td>
												        <td id="" style="border:1px solid #c2c2c2; background-color:#ecf0f2;  text-align: center;">
												        </td> -->
												     </tr>
												</table>
												</div>
												<table border="0" cellspacing="0" cellpadding="0" align="right">
													<tr height='5' >
														<td>
															<button type="button" id="btnCloseDetail" value="닫기" onclick="fnCloseDetail();"  class="btn btn-primary btn-cons">
					                    						닫기
					                    					</button>
														</td>
														
													</tr>
												</table>
												
												
                                        </div>
                                        
                                        
                                        
                                        
                                        
                                        
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </form>
                <!-- END SEARCH LIST AREA -->
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
		
		<!-- 거래 영수증 -->
		<div class="modal fade" id="divApplyMerchantModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">    
		    <div class="modal-dialog" style="width: 375px">
		        <div class="modal-content" style="width: 375px">
		            <div class="modal-header">
		                <button type="button" class="close" aria-hidden="true" data-dismiss="modal">x</button>
		                <br>
		                <%-- <i id="iconRegist" class="fa fa-pencil fa-2x"></i>
		                <i id="iconEdit" class="fa fa-edit fa-2x" style="display:none;"></i>
		                <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_MENU_SUB_0146'/></h4>
		                <br> --%>
		            </div>
		            
		            
		            <div class="modal-body" id="receiptTemp">
		                <form name="frmMerApply" id="frmMerApply">
		                	<h4 style="margin-left: 90px; color: black;"><b>이롬페이 매출전표</b></h4>
		                	<br>
		                	
		                	<table class="receipt" style="width: 93%; 
		                		text-align: center; color: black; border: 0px;margin: 0 auto">
		                		
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>회원ID</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_USR_ID" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>거래일시</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_PAY_DATE" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>거래유형</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_PAY_TYPE" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>승인번호</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_PAY_NO" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		
		                		<tr>
		                			<td>&nbsp;</td>
		                		</tr>
		                		
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>공급가액</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-content-sub" id="RC_SPL_AMT">
		                				
		                			</td>
		                			<td class="receipt-won">원
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>부가세</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-content-sub" id="RC_VAT">
		                				
		                			</td>
		                			<td class="receipt-won">원
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>봉사료</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-content-sub" id="RC_SVC_FEE">
		                				
		                			</td>
		                			<td class="receipt-won">원
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>결제금액</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-content-sub" id="RC_AMT">
		                				
		                			</td>
		                			<td class="receipt-won">원
		                			</td>
		                		</tr>
		                		
		                	
		                		<tr>
		                			<td>&nbsp;</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>가맹점상호</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_CO_NM" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>사업자번호</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_CO_NO" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>대표자명</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_REP_NM" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>전화번호</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_REQ_TEL" colspan="2">
		                				
		                			</td>
		                		</tr>
		                		<tr>
		                			<td class="receipt-header"><label class="form-label"><b>주소</b></label></td>
		                			<td class="receipt-mid"></td>
		                			<td class="receipt-td receipt-content" id="RC_ADDR" colspan="2">
		                				
		                			</td>
		                		</tr>
		                	</table>
		                	
		                    
		                </form>
		            </div>
		            
		                        
		            <div class="modal-footer">
		                <div class="pull-right">
		                     <button type="button" class="btn btn-default" data-dismiss="modal" onclick="javascript:IONPay.Msg.fnResetBodyClass();fnMerApplySuccessResult();">닫기</button>
		                </div>
		            </div>
		        </div>
		    </div>
		</div>
		
		
		
		