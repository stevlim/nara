<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="commonPageLibrary.jsp" %>

<div id="tiles-head-wrapper">
	<center>
		<div id='tiles-header'>
			<div class="headerpg">
				<h1 class="hdingpg" id="hdingpgNm">Dash Board</h1>
				<button class="btnmenu" id="btnmenu"><span class="icon-nav"></span></button>
			</div>
		</div>
	</center>
</div>

<div class="main_nav" id="main_nav">
	<div class="contentnav">
		<div class="headernav">
			<div class="thumbuser"><span class="icon-user1"></span></div>
			<h2 class="titlenav">Manager name
				<p>Company name</p>
			</h2>
			<a class="btnclosenav"><span class="icon-close"></span></a>
		</div>
		<div class="navservice">
			<h2>Service</h2>
			<ul class="listnavservice">
				<!-- <li>
					<a href="#0">
						<span class="icon-pay1"></span>Domestic card
					</a>
				</li>
				<li>
					<a href="#0">
						<span class="icon-pay2"></span>International card
					</a>
				</li> -->
				<li>
					<a href="/home/dashboard/dashboard.do">
						<span class="icon-pay3"></span>Dash Board
					</a>
				</li>
			</ul>
		</div>
		<div class="mainmenu">
			<h2 class="title_accmenu accmms">Energy Data Information</h2>
			<ul class="list_submenu pnl">				
				<li><a class="left_menu_nm" href="/sampleMgmt/sampleOneMgmt/sampleOneMgmt.do">Power History (Sample 01)</a></li>
				<li><a class="left_menu_nm" href="/sampleMgmt/sampleTwoMgmt/sampleTwoMgmt.do">RealTime Data Information (Sample 02)</a></li>
				<!-- <li><a href="/baseInfoMgmt/keyInfoMgmt/keyInfoMgmt.do">sample 03</a></li> -->
			</ul>
			<h2 class="title_accmenu accmms">Energy Charge information</h2>
			<ul class="list_submenu pnl">
				<li><a class="left_menu_nm" href="/sampleSubMgmt/sampleSubOneMgmt/sampleSubOneMgmt.do">Voltage History (Sample Sub 01)</a></li>
				<li><a class="left_menu_nm" href="/sampleSubMgmt/sampleSubTwoMgmt/sampleSubTwoMgmt.do">Energy Inquiry (Sample Sub 02)</a></li>
			</ul>
			<!-- <h2 class="title_accmenu accmms">Settlement information</h2>
			<ul class="list_submenu pnl">
				<li><a href="/businessMgmt/faqMgmt/faqMgmt.do">Settlement schedule</a></li>
				<li><a href="/businessMgmt/faqMgmt/faqMgmt.do">Exceptional payment</a></li>
				<li><a href="/businessMgmt/faqMgmt/faqMgmt.do">Receivables by transaction</a></li>
			</ul>
			<h2 class="title_accmenu accmms">Customer support</h2>
			<ul class="list_submenu pnl">
				<li><a href="/businessMgmt/faqMgmt/faqMgmt.do">Notifications</a></li>
				<li><a href="/businessMgmt/faqMgmt/faqMgmt.do">FAQ</a></li>
			</ul> -->
		</div>
	</div>
	<div class="botsetting">
		<ul class="listsetting">
			<li>
				<a href="/home/dashboard/dashboard.do">C-BEMS</a>
			</li>
			<li>
				<a href="#0"><span class="icon-setting"></span>Setting</a>
			</li>
			<li>
				<a href="<c:out value='/logOut.do'/>"><span class="icon-power"></span>Log-out</a>
			</li>
		</ul>
	</div>
</div>