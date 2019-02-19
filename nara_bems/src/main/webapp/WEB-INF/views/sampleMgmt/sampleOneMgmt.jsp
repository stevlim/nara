<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	
	$("#hdingpgNm").text("Sample 01");
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
				<li><span class="subtitletabs">Settlement schedule</span></li>
				<li><span class="subtitletabs">Synthetic performance</span></li>
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
						<p>Total payment from MegaPay</p>
						<h3>22,000,000 vnd</h3>
					</div>
					<ul class="listdatepayment">
						<li class="adevent">
							<span class="spndatepay">15/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Payment</div>
									<div class="righttotalpay">10,000,000 VND</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All transaction method <span>10,100,000 VND</span></h3>
										<p>Domestic card <span>6,000,000 vnd</span></p>
										<p>International card <span>4,000,000 VND</span></p>
										<p>Dedicated account <span>0 VND</span></p>
										<h3>Exceptional payment <span>(100,000) VND</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">14/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Payment</div>
									<div class="righttotalpay">10,000,000 VND</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All transaction method <span>10,100,000 VND</span></h3>
										<p>Domestic card <span>6,000,000 vnd</span></p>
										<p>International card <span>4,000,000 VND</span></p>
										<p>Dedicated account <span>0 VND</span></p>
										<h3>Exceptional payment <span>(100,000) VND</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">13/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Payment</div>
									<div class="righttotalpay">10,000,000 VND</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All transaction method <span>10,100,000 VND</span></h3>
										<p>Domestic card <span>6,000,000 vnd</span></p>
										<p>International card <span>4,000,000 VND</span></p>
										<p>Dedicated account <span>0 VND</span></p>
										<h3>Exceptional payment <span>(100,000) VND</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">12/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Payment</div>
									<div class="righttotalpay">10,000,000 VND</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All transaction method <span>10,100,000 VND</span></h3>
										<p>Domestic card <span>6,000,000 vnd</span></p>
										<p>International card <span>4,000,000 VND</span></p>
										<p>Dedicated account <span>0 VND</span></p>
										<h3>Exceptional payment <span>(100,000) VND</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">11/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Payment</div>
									<div class="righttotalpay">10,000,000 VND</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All transaction method <span>10,100,000 VND</span></h3>
										<p>Domestic card <span>6,000,000 vnd</span></p>
										<p>International card <span>4,000,000 VND</span></p>
										<p>Dedicated account <span>0 VND</span></p>
										<h3>Exceptional payment <span>(100,000) VND</span></h3>
									</div>
								</div>
							</div>
						</li>
						<li class="adevent">
							<span class="spndatepay">10/12</span>
							<div class="boxpaymoney">
								<div class="rowpaymoney">
									<div class="lefttotalpay">Total Payment</div>
									<div class="righttotalpay">10,000,000 VND</div>
								</div>
								<div class="rowallpay">
									<div class="innerrowallpay">
										<h3>All transaction method <span>10,100,000 VND</span></h3>
										<p>Domestic card <span>6,000,000 vnd</span></p>
										<p>International card <span>4,000,000 VND</span></p>
										<p>Dedicated account <span>0 VND</span></p>
										<h3>Exceptional payment <span>(100,000) VND</span></h3>
									</div>
								</div>
							</div>
						</li>
					</ul>
				</div>
				<div class="subcontentsett">
					fsdfsd
				</div>
			</div>
		</div>
	</div>
</div>
