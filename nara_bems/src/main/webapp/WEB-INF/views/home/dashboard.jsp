<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">

$(document).ready(function(){
	fnInitEvent();
});

function fnInitEvent(){
/* 	var strInitPSWDFlag = "${sessionScope['IMSAdminPasswordChangeSession']}";

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
 */
}

</script>


<div class="row_merchantname">
	Name of Merchant (Merchant ID)
</div>
<div class="row_slidemerchant">
	<ul id="slide_merchant" class="content-slider">
		<li>
			<div class="boxmerchant">
				<p class="title_merchant">14/02/2019 Today Power Value</p>
				<div class="infomerchant">
					<div class="prizemerchant">2,000,000 kW</div>
				</div>
			</div>
		</li>
		<li>
			<div class="boxmerchant">
				<p class="title_merchant">1 Week Power Value Chart</p>
				<div class="infomerchant">
					<div class="chart-wrapper">
						<div class="blueberryChart demo1"></div>
					</div>
					<p class="linedes"><span>All Power Value</span></p>
				</div>
			</div>
		</li>
	</ul>
</div>
<div class="row_today">
	<ul class="listtoday">
		<li>
			<a href="transaction.html" class="boxtoday">
				<p>Today Average Power
					<span>(Power)</span>
				</p>
				<h3 class="pricetoday">100 kW</h3>
			</a>
		</li>
		<li>
			<a href="transaction.htm" class="boxtoday">
				<p>Today Average Voltage
					<span>(volt)</span>
				</p>
				<h3 class="pricetoday">20 V</h3>
			</a>
		</li>
		<li>
			<a href="transaction.htm" class="boxtoday">
				<p>Today Average Current
					<span>(Current)</span>
				</p>
				<h3 class="pricetoday">2,500 A</h3>
			</a>
		</li>
	</ul>
</div>
<ul class="sett_tracs">
	<li><a href="settlement1.html">Temperature Value<br />history</a></li>
	<li><a href="transaction.html">Power Value<br />history</a></li>
</ul>
<div class="row_support">
	<span class="titlesupport">Customer support</span>
	<ul class="listsupport">
		<li>
			<a href="#0"><span class="icon-notice"></span>Notice</a>
		</li>
		<li>
			<a href="#0"><span class="icon-faq"></span>FAQ</a>
		</li>
		<li>
			<a href="#0"><span class="icon-phone"></span>0123456789</a>
		</li>
	</ul>
</div>
