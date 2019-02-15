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

<div class="main_nav">
	<div class="contentnav">
		<div class="headernav">
			<div class="thumbuser"><span class="icon-user1"></span></div>
			<h2 class="titlenav">Merchant name
				<p>Company name</p>
			</h2>
			<a class="btnclosenav"><span class="icon-close"></span></a>
		</div>
		<div class="navservice">
			<h2>Service</h2>
			<ul class="listnavservice">
				<li>
					<a href="#0">
						<span class="icon-pay1"></span>Domestic card
					</a>
				</li>
				<li>
					<a href="#0">
						<span class="icon-pay2"></span>International card
					</a>
				</li>
				<li>
					<a href="#0">
						<span class="icon-pay3"></span>Dedicated account
					</a>
				</li>
			</ul>
		</div>
		<div class="mainmenu">
			<h2 class="title_accmenu accmms">Merchant information</h2>
			<ul class="list_submenu pnl">
				<li class="active"><a href="#0">Merchant information</a></li>
				<li><a href="#0">Settlement information</a></li>
				<li><a href="#0">Service information</a></li>
				<li><a href="#0">Limit information</a></li>
			</ul>
			<h2 class="title_accmenu accmms">Transaction information</h2>
			<ul class="list_submenu pnl">
				<li><a href="#0">Total transaction history</a></li>
				<li><a href="#0">Failure transaction history</a></li>
			</ul>
			<h2 class="title_accmenu accmms">Settlement information</h2>
			<ul class="list_submenu pnl">
				<li><a href="#0">Settlement schedule</a></li>
				<li><a href="#0">Exceptional payment</a></li>
				<li><a href="#0">Receivables by transaction</a></li>
			</ul>
			<h2 class="title_accmenu accmms">Customer support</h2>
			<ul class="list_submenu pnl">
				<li><a href="#0">Notifications</a></li>
				<li><a href="#0">FAQ</a></li>
			</ul>
		</div>
	</div>
	<div class="botsetting">
		<ul class="listsetting">
			<li>
				<a href="#0">MegaPay</a>
			</li>
			<li>
				<a href="#0"><span class="icon-setting"></span>Setting</a>
			</li>
			<li>
				<a href="#0"><span class="icon-power"></span>Log-out</a>
			</li>
		</ul>
	</div>
</div>
<div class="headerpg">
	<a class="toplogo"><img src="img/epay-logo.png" alt="mms" /></a>
	<h1 class="hdingpg">MegaPay MMS</h1>
	<button class="btnmenu"><span class="icon-nav"></span></button>
</div>
<div class="row_merchantname">
	Name of Merchant (Merchant ID)
</div>
<div class="row_slidemerchant">
	<ul id="slide_merchant" class="content-slider">
		<li>
			<div class="boxmerchant">
				<p class="title_merchant">14/12/2019 Payment from MegaPay</p>
				<div class="infomerchant">
					<div class="prizemerchant">2,000,000 vnd</div>
				</div>
			</div>
		</li>
		<li>
			<div class="boxmerchant">
				<p class="title_merchant">1 Week Transaction Chart</p>
				<div class="infomerchant">
					<div class="chart-wrapper">
						<div class="blueberryChart demo1"></div>
					</div>
					<p class="linedes"><span>All payment methord</span></p>
				</div>
			</div>
		</li>
	</ul>
</div>
<div class="row_today">
	<ul class="listtoday">
		<li>
			<a href="transaction.html" class="boxtoday">
				<p>Today Approval
					<span>(Transaction)</span>
				</p>
				<h3 class="pricetoday">100</h3>
			</a>
		</li>
		<li>
			<a href="transaction.htm" class="boxtoday">
				<p>Today Refund
					<span>(Transaction)</span>
				</p>
				<h3 class="pricetoday">20</h3>
			</a>
		</li>
		<li>
			<a href="transaction.htm" class="boxtoday">
				<p>Today Performance
					<span>(1000 VND)</span>
				</p>
				<h3 class="pricetoday">2,500</h3>
			</a>
		</li>
	</ul>
</div>
<ul class="sett_tracs">
	<li><a href="settlement1.html">Settlement<br />information</a></li>
	<li><a href="transaction.html">Transaction<br />history</a></li>
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
