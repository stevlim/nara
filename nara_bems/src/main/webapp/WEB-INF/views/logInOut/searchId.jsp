<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	
    //fnInitEvent();
    //fnLoginProc();
});


</script>

<div class="mmslogin">
	<div class="topintro">
		<a class="btnback" href="/logIn.do"><span class="icon-farr-left"></span></a>
		<div class="boxintro">
			<span class="logomms"><img src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/img/nara/login/C-BEMS_logo.png" alt="epay" /></span>
			<h1>Building Energy Management System</h1>
		</div>
	</div>
	<div class="loginpg">
		<div class="formlogin">
			<h2 class="titleforgotid"><span>Forgot my ID ?</span></h2>
			<div class="hotlinecontact">
				<p>Please contact our Hotline</p>
				<h3 class="titlhotline">19006470</h3>
				<p>for support</p>
			</div>
		</div>
		<div class="botlogin">
			Copyright © 2019 C-BEMS. All Rights Reserved.
		</div>
	</div>
</div>
