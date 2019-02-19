<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	
	$("#hdingpgNm").text("Power History (Sample 01)");
    //fnInitEvent();
    //fnSetDDLB();
    //fnEditFaqMgmt();
});

/**------------------------------------------------------------
* FAQ 등록/수정
------------------------------------------------------------*/
function fnEditFaqMgmt() {
    alert("123123213123777777");
        var editMode = "insert";
        
		// 구분 - CTGR : division
		// 표시 - NOTI_TYPE : flag
		// Question - TITLE : TITLE 
		// Ask - BODY : $("#MEMO_EDITOR").data("wysihtml5").editor.getValue();
		arrParameter = {
	        "CTGR" 		 : "26",
	        "NOTI_TYPE"  : "26",
	        "TITLE"      : "26",
	        "BODY"       : "23",
	        "SEQ_NO"     : "23",
        };
		//"STATUS"	 : $.trim($("#STATUS").val()),
        strCallUrl  = (editMode == "insert" ? "/sampleMgmt/sampleOneMgmt/insertFaqMgmt.do" : "/sampleMgmt/sampleOneMgmt/updateFaqMgmt.do");
        strCallBack = "fnEditFaqMgmtRet";
         
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    
}

function fnEditFaqMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearHideForm();
        fnFaqMgmtListDT();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);      
    }
}

</script>
<!-- Sample 01 -->
<div class="transpg">
	<ul class="tabsett tabtrans">
		<li class="selected"><a href="settlement1.html" class="titletabs">Settlement<br />schedule</a></li>
		<li><a href="settlement2.html" class="titletabs">Exceptional<br />payment</a></li>
		<li><a href="settlement3.html" class="titletabs">Receivables by<br />transaction</a></li>
	</ul>
	<div class="tab_content">
		<div class="transcontent">
			<ul class="subtabsett">
				<li><span class="subtitletabs">Energy System schedule</span></li>
				<li><span class="subtitletabs">Energy Chart</span></li>
			</ul>
			<div class="tab_content_sett">
				<div class="subcontentsett">
					<div class="rowslidemonth">
						<ul id="slide_month" class="content-slider">
							<li>
								<div class="settmonth">
									<span class="spnthismonth">12/2018</span>
								</div>
							</li>
							<li>
								<div class="settmonth">
									<span class="spnthismonth">12/2018</span>
								</div>
							</li>
						</ul>
					</div>
					<div class="totalpay">
						<p>Total Power From Building</p>
						<h3>22,000,000 kW</h3>
					</div>
					<ul class="listdatepayment">
						<li class="adevent">
							<span class="spndatepay">15/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Power</div>
									<div class="righttotalpay">10,000,000 kW</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All Power Value <span>10,100,000 kW</span></h3>
										<p>Area 01 <span>6,000,000 kW</span></p>
										<p>Area 02 <span>4,000,000 kW</span></p>
										<p>Area 03 <span>0 kW</span></p>
										<h3>Exceptional Power Value <span>(100,000) kW</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">14/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Power</div>
									<div class="righttotalpay">10,000,000 kW</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All Power Value <span>10,100,000 kW</span></h3>
										<p>Area 01 <span>6,000,000 kW</span></p>
										<p>Area 02 <span>4,000,000 kW</span></p>
										<p>Area 03 <span>0 kW</span></p>
										<h3>Exceptional Power Value <span>(100,000) kW</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">13/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Power</div>
									<div class="righttotalpay">10,000,000 kW</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All Power Value <span>10,100,000 kW</span></h3>
										<p>Area 01 <span>6,000,000 kW</span></p>
										<p>Area 02 <span>4,000,000 kW</span></p>
										<p>Area 03 <span>0 kW</span></p>
										<h3>Exceptional Power Value <span>(100,000) kW</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">12/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Power</div>
									<div class="righttotalpay">10,000,000 kW</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All Power Value <span>10,100,000 kW</span></h3>
										<p>Area 01 <span>6,000,000 kW</span></p>
										<p>Area 02 <span>4,000,000 kW</span></p>
										<p>Area 03 <span>0 kW</span></p>
										<h3>Exceptional Power Value <span>(100,000) kW</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">11/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Power</div>
									<div class="righttotalpay">10,000,000 kW</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All Power Value <span>10,100,000 kW</span></h3>
										<p>Area 01 <span>6,000,000 kW</span></p>
										<p>Area 02 <span>4,000,000 kW</span></p>
										<p>Area 03 <span>0 kW</span></p>
										<h3>Exceptional Power Value <span>(100,000) kW</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">10/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Power</div>
									<div class="righttotalpay">10,000,000 kW</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All Power Value <span>10,100,000 kW</span></h3>
										<p>Area 01 <span>6,000,000 kW</span></p>
										<p>Area 02 <span>4,000,000 kW</span></p>
										<p>Area 03 <span>0 kW</span></p>
										<h3>Exceptional Power Value <span>(100,000) kW</span></h3>
									</div>
								</div>
							</div>
						</li>
					</ul>
				</div>
				<div class="subcontentsett">
					Not Developed
				</div>
			</div>
		</div>
	</div>
</div>
