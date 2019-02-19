<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	$("#hdingpgNm").text("RealTime Data Information (Sample 02)");
	setInterval("fnEdit()",1000);
	
	
    //fnInitEvent();
    //fnSetDDLB();
    //fnEditFaqMgmt();
});

function fnEdit() {
	//arrParameter = $("#regist").serializeObject();
	//arrParameter["worker"] = strWorker;
	
	strCallUrl = "/sampleMgmt/sampleTwoMgmt/selectApproLimitDetail.do";
	strCallBack = "fnEditRet";
	IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
}

function fnEditRet(objJson) {
	if (objJson.resultCode == 0) {
		if(objJson.data != null ) {
			$("#data01").text(objJson.data.DATA01);
			$("#data02").text(objJson.data.DATA02);
			$("#data03").text(objJson.data.DATA03);
			$("#data04").text(objJson.data.DATA04);
			$("#data05").text(objJson.data.DATA05);
			$("#data06").text(objJson.data.DATA06);
			$("#data07").text(objJson.data.DATA07);
			$("#data08").text(objJson.data.DATA08);
			$("#data09").text(objJson.data.DATA09);
			$("#data10").text(objJson.data.DATA10);
			$("#data11").text(objJson.data.DATA11);
			$("#data12").text(objJson.data.DATA12);
			
		}
	} else {
		IONPay.Msg.fnAlert(objJson.resultMessage);
	}
}

</script>

<!-- Sample 02 -->
<div class="transpg">
	<ul class="tabmerchant tabtrans">
		<li class="selected"><a href="#0" class="titletabs">Merchant<br />info</a></li>
		<li><a href="#0" class="titletabs">Settlement<br />info</a></li>
		<li><a href="#0" class="titletabs">Service<br />info</a></li>
		<li><a href="#0" class="titletabs">Limit<br />info</a></li>
	</ul>
	<div class="tab_content">
		<div class="contentmerchant transcontent">
			<h3 class="titlemerchant">Energy Data information</h3>
			<ul class="list_transhistory">
				<li>
					<span class="labeltranshistory">Charge Limit Temperature</span>
					<span class="infotranshistory" id="data01"></span>
				</li>
				<li>
					<span class="labeltranshistory">Charge Limit Power</span>
					<span class="infotranshistory" id="data02"></span>
				</li>
				<li>
					<span class="labeltranshistory">Discharge Limit Temperature</span>
					<span class="infotranshistory" id="data03"></span>
				</li>
				<li>
					<span class="labeltranshistory">Discharge Limit Power</span>
					<span class="infotranshistory" id="data04"></span>
				</li>
				<li>
					<span class="labeltranshistory">Max Charge Power</span>
					<span class="infotranshistory" id="data05"></span>
				</li>
				<li>
					<span class="labeltranshistory">Max Discharge Power</span>
					<span class="infotranshistory" id="data06"></span>
				</li>
				<li>
					<span class="labeltranshistory">Standard Frequency</span>
					<span class="infotranshistory" id="data07"></span>
				</li>
				<li>
					<span class="labeltranshistory">Standard Voltage</span>
					<span class="infotranshistory" id="data08"></span>
				</li>
				<li>
					<span class="labeltranshistory">Target Charge Value</span>
					<span class="infotranshistory" id="data09"></span>
				</li>
				<li>
					<span class="labeltranshistory">Target Power Value</span>
					<span class="infotranshistory" id="data10"></span>
				</li>
				<li>
					<span class="labeltranshistory">PV Power</span>
					<span class="infotranshistory" id="data11"></span>
				</li>
				<li>
					<span class="labeltranshistory">Battery Power</span>
					<span class="infotranshistory" id="data12"></span>
				</li>
			</ul>
		</div>
	</div>
</div>
