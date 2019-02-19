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
	<div class="loginpg"  style="background-color: #f3f3f3;">
		<!-- <div class="formlogin">
			<h2 class="titleforgotid"><span>Reset password</span></h2>
			<div class="hotlinecontact">
				<p>Please contact our Hotline</p>
				<h3 class="titlhotline">19006470</h3>
				<p>for support</p>
			</div>
		</div> -->
		<div class="boxconfirm">
			<h2 class="titleconfirm">Please insert your new password</h2>
			<input type="text" class="uid" name="id" autocomplete="on" placeholder="New password (6-20 characters)" value="">
			<input type="text" class="uid" name="id" autocomplete="on" placeholder="Re-enter new password" value="">
			<p class="notereset">Your password must be a combination of 6-20 upper/lower case letters, numbers and special characters.</p>
			<button class="btnlogin">Confirm</button>
		</div>
		<div class="botlogin">
			Copyright © 2019 C-BEMS. All Rights Reserved.
		</div>
	</div>
</div>

<!-- <div class="headerpg">
	<a class="btnback" href="/logIn.do"><span class="icon-farr-left"></span></a>
	<h1 class="hdingpg">Reset password</h1>
	<button class="btnclosepg"><span class="icon-close"></span></button>
</div>
<div class="mmslogin">
	<div class="boxconfirm">
		<h2 class="titleconfirm">Please insert your new password</h2>
		<input type="text" class="uid" name="id" autocomplete="on" placeholder="New password (6-20 characters)" value="">
		<input type="text" class="uid" name="id" autocomplete="on" placeholder="Re-enter new password" value="">
		<p class="notereset">Your password must be a combination of 6-20 upper/lower case letters, numbers and special characters.</p>
		<button class="btnlogin">Confirm</button>
	</div>
</div>
 -->