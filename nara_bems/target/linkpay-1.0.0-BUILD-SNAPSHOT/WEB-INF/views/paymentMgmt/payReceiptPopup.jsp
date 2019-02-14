<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%

String tid = (String) request.getAttribute("tid");
Map<String, Object> objMap = (Map<String, Object>)request.getAttribute("data");

String ordNo 	= (String)objMap.getOrDefault("ORD_NO", "");
String uid 		= (String)objMap.getOrDefault("UID", "");
String pay_type = (String)objMap.getOrDefault("CC_DT", "");
Object spl_amt 	= (Object)objMap.getOrDefault("GOODS_SPL_AMT", "0");
Object vat 		= (Object)objMap.getOrDefault("GOODS_VAT", "0");
Object svc_fee 	= (Object)objMap.getOrDefault("GOODS_SVC_FEE", "0");
Object amt 		= (Object)objMap.getOrDefault("GOODS_AMT", "0");
String payDate 	= (String)objMap.getOrDefault("APP_DT", "");
Object payNo 	= (Object)objMap.getOrDefault("TID", "");
String goodsNm 	= (String)objMap.getOrDefault("GOODS_NM", "");
String coNm 	= (String)objMap.getOrDefault("CO_NM", "");
String coNo 	= (String)objMap.getOrDefault("CO_NO", "");
String repNm 	= (String)objMap.getOrDefault("REP_NM", "");
String addr 	= (String)objMap.getOrDefault("ADDR", "");
String reqTel 	= (String)objMap.getOrDefault("TEL_NO", "");


if(pay_type == null || pay_type.equals("")){
	pay_type = "승인";
}else{
	pay_type = "취소";
}

%>
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
 
	$("#RC_ORD_NO").text("<%=ordNo%>");
	$("#RC_USR_ID").text("<%=uid%>");
	
	$("#RC_PAY_TYPE").text("<%=pay_type%>");
	
	$("#RC_SPL_AMT").text(IONPay.Utils.fnAddComma("<%=spl_amt%>"));
	$("#RC_VAT").text(IONPay.Utils.fnAddComma("<%=vat%>"));
	
	$("#RC_SVC_FEE").text(IONPay.Utils.fnAddComma("<%=svc_fee%>"));
	
	$("#RC_AMT").text(IONPay.Utils.fnAddComma("<%=amt%>"));
	
	$("#RC_PAY_DATE").text("<%=payDate%>");
	$("#RC_PAY_NO").text("<%=payNo%>");
	$("#RC_GOODS_NM").text("<%=goodsNm%>");
	
	
	$("#RC_CO_NM").text("<%=coNm%>");
	$("#RC_CO_NO").text(IONPay.Utils.fnStringToLicenseFormat("<%=coNo%>"));
	$("#RC_REP_NM").text("<%=repNm%>");
	$("#RC_ADDR").text("<%=addr%>");
	$("#RC_REQ_TEL").text(IONPay.Utils.fnStringToPhoneFormat("<%=reqTel%>"));
	
	$("#RC_SHOP_NM").text("<%=coNm%>");
	
}

function fnSetDDLB() {
	var receiptBgImg = $("#receiptBgImg").val();
	
	$("#receiptTemp").css('background-image', 'url("' + receiptBgImg + '")');
    $("#receiptTemp").css('background-size', '100%');
    $("#receiptTemp").css('width', '375px');
    $("#receiptTemp").css('height', '540px');
    
    $("#tiles-wrapper").hide();
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
</style>

<input type="hidden" id="receiptBgImg" value="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Images/receipt.png" />
<div class="modal-body" id="receiptTemp">
   	
       <!-- <form name="frmEditMenu" id="frmEditMenu"> -->
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
		                			<td class="receipt-mid">:</td>
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