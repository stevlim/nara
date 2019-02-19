<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ include file="commonPageLibrary.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title><c:out value="${CommonMessage.BROWSER_TITLE }"/></title>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    <!-- BEGIN PLUGIN CSS -->
    <link rel="stylesheet" type="text/css" media="screen" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/pace/pace-theme-flash.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-tag/bootstrap-tagsinput.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-datepicker/css/datepicker.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-timepicker/css/bootstrap-timepicker.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrap-clockpicker/bootstrap-clockpicker.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-colorpicker/css/bootstrap-colorpicker.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-select2/select2.css"/>
    <link rel="stylesheet" type="text/css" media="screen" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrap-checkbox/css/bootstrap-checkbox.css" />
    <!-- END PLUGIN CSS -->
    <!-- BEGIN CORE CSS FRAMEWORK -->
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrapv3/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrapv3/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/font-awesome/css/font-awesome.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/animate.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-scrollbar/jquery.scrollbar.css"/>
    <!-- END CORE CSS FRAMEWORK -->
    <!-- BEGIN CSS TEMPLATE -->
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/style.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/responsive.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/custom-icon-set.css" />
    <%-- <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/common-LNB.css" /> --%>
    <%-- <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/dashboard.css" /> --%>
    
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/common-header.css" />
    
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/common-footer.css" />
    
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/font-awesome.min.css" />
    <!-- END CSS TEMPLATE -->
    <!-- BEGIN CSS DATATABLE -->
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/datatable/dataTables.bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/datatables-responsive/css/datatables.responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/datatables-responsive/css/responsive.bootstrap.min.css" />
    <!-- END CSS DATATABLE -->
    <!-- BEGIN CSS SORTABLE -->
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/sortable/sortable.css" />
    <!-- END CSS SORTABLE -->
    <!-- BEGIN CSS FULLCALENDER -->
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/fullcalendar/fullcalendar.css" />
    <!-- END CSS FULLCALENDER -->


	
    
    <!-- BEGIN jqGrid CSS -->
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/jqGrid/css/ui.jqgrid.css" />
    <!-- END jqGrid CSS -->
    <!-- BEGIN jqueryUi CSS -->
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/jqueryUi/jquery-ui.css" />
    <!-- END jqueryUi CSS -->


	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/header/global.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/header/private.css" />
    <link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/font/style.css" />
	<link rel="stylesheet" type="text/css" href="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/css/nara/lightslider/lightslider.css" />

    <!-- BEGIN CORE JS FRAMEWORK-->
    <%-- <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery-1.11.3.min.js"></script> --%>
    <!-- END CORE JS FRAMEWORK-->
    <!-- BEGIN I18N JS -->
    <%-- <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.i18n.properties-min-1.0.9.js"></script> --%>
    <!-- END I18N JS -->
    <!-- BEGIN IMS MSG JS -->
    <%-- <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/IONPayMSG.IMS.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script> --%>
    <!-- END IMS MSG JS -->
    
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery-3.3.1.min.js"></script>
    
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/js/nara/lightslider/lightslider.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/js/nara/header/main.js"></script>
    
</head>
<body class="">
<%--     <tiles:insertAttribute name="GNB" /> --%>
    <tiles:insertAttribute name="HEADER" />
    <tiles:insertAttribute name="BODY" />
    <tiles:insertAttribute name="FOOTER" />

    <!-- BEGIN MODAL -->
    <button id="btnModalMsg" data-toggle="modal" data-target="#alertModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="modalMsg" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" id="btnAlertModalTop" class="close" aria-hidden="true">×</button>
                    <br>
                    <i class="fa fa-info-circle fa-2x"></i>
                    <h4 id="modalMsg" class="semi-bold"></h4>
                    <br>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnAlertModalBottom" class="btn btn-default">닫기</button>
                </div>
            </div>
        </div>
    </div>
    <!-- END MODAL -->

    <!-- BEGIN CONFIRM MODAL -->
    <button id="btnModalConfirm" data-toggle="modal" data-target="#confirmModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="modalConfirm" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" id="btnConfirmModalTop" class="close" aria-hidden="true">×</button>
                    <br>
                    <i class="fa fa-exclamation fa-2x"></i>
                    <h4 id="modalConfirm" class="semi-bold"></h4>
                    <br>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" onclick="eval(strCallBackFN)();">확인</button>
                    <button type="button" id="btnConfirmModalBottm" class="btn btn-default">취소</button>
                </div>
            </div>
        </div>
    </div>
    <!-- END CONFIRM MODAL -->

    <!-- BEGIN RESET PWD CONFIRM MODAL -->
    <button id="btnModalResetPwdConfirm" data-toggle="modal" data-target="#resetPwdConfirmModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="resetPwdConfirmModal" tabindex="-1" role="dialog" aria-labelledby="modalConfirm" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" id="btnResetPwdConfirmModalTop" class="close" aria-hidden="true">×</button>
                    <br>
                    <i class="fa fa-exclamation fa-2x"></i>
                    <h4 id="modalResetPwdConfirm" class="semi-bold"></h4>
                    <br>
                    <h4 id="modalResetPwdNameConfirm" class="semi-bold"></h4>
                    <br>
                    <h4 id="modalResetEmailConfirm" class="semi-bold"></h4>
                    <br>
                    <form name="frmResetPwd" id="frmResetPwd">
                    	<div style = "width:60%; margin:0 auto;">
                    		<div class="input-with-icon right">
                    			<i class=""></i>
                    			<input id="inputEmail" name="EMAIL"  type="text"" value="" style="width:100%; text-align:center;" maxlength="60"  class=""/>
                    		</div>
                    	</div>
                    </form>
                    <br>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="eval(strCallBackFN)();">확인</button>
                    <button type="button" id="btnResetPwdConfirmModalBottm" class="btn btn-default">취소</button>
                </div>
            </div>
        </div>
    </div>
    <!-- END RESET PWD CONFIRM MODAL -->

    <!-- BEGIN PASSWORD CHANGE MODAL -->
    <button id="btnModalPSWDChg" data-toggle="modal" data-target="#passwordChgModal" style="width:0px; height:0px; display:none;"></button>
    <div class="modal fade" id="passwordChgModal" tabindex="-1" role="dialog" aria-labelledby="modalMsg" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" id="btnPSWDChgModalTop" class="close" aria-hidden="true" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass();">×</button>
                    <br>
                    <i class="fa fa-info-circle fa-2x"></i>
                    <h4 id="modalMsg" class="semi-bold"><spring:message code='IMS_LAYOUT_ADM_0001'/><br/><spring:message code='IMS_LAYOUT_ADM_0002'/></h4>
                    <br>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnPSWDChgModalBtn" class="btn btn-danger" data-dismiss="modal">Change</button>
                    <button type="button" id="btnPSWDChgModalBottom" class="btn btn-default" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass();">닫기</button>
                </div>
            </div>
        </div>
    </div>
    <!-- END PASSWORD CHANGE MODAL -->

    <!-- BEGIN AJAX LOADER -->
    <div id="divPageBlock" style="display:none;">
        <img src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Images/ajax_loader_02.gif">
    </div>
    <!-- END AJAX LOADER -->

    <!-- BEGIN CSRF TOKEN -->
    <input type="hidden" id="<c:out value="${CommonConstants.IMS_ID_CSRF}"/>" >
    <input type="hidden" id="audioUrl" value="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Audio/alram.wav">
    <!-- END CSRF TOKEN -->

    <!-- BEGIN CORE JS FRAMEWORK-->
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/breakpoints.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-unveil/jquery.unveil.min.js"></script>
	<!-- END CORE JS FRAMEWORK -->
	<!-- BEGIN IONPAY CORE JS FRAMEWORK-->
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.form.min.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.ajax-retry.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/IONPay.IMS.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/LinkPayCommon.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/LinkPayJqGrid.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script>
    <!-- END IONPAY CORE JS FRAMEWORK-->
	<!-- BEGIN DATATABLE CORE JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/dataTables.bootstrap.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/IONPay.plugins.custom.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/datatables-responsive/js/datatables.responsive.min.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/datatables-responsive/js/responsive.bootstrap.min.js"></script>
    <!-- END DATATABLE CORE JS -->
    <!-- BEGIN FILEDOWNLOAD CORE JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.fileDownload.js"></script>
    <!-- END FILEDOWNLOAD CORE JS -->
    <!-- BEGIN MULTISORTABLE CORE JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/IONPay/Js/jquery.multisortable.js"></script>
    <!-- END MULTISORTABLE CORE JS -->
	<!-- BEGIN PAGE LEVEL JS -->
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-scrollbar/jquery.scrollbar.min.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-numberAnimate/jquery.animateNumbers.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/pace/pace.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-block-ui/jqueryblockui.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-inputmask/jquery.inputmask.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-autonumeric/autoNumeric.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-select2/select2.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-wysihtml5/wysihtml5-0.3.0.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/bootstrap-tag/bootstrap-tagsinput.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrap-clockpicker/bootstrap-clockpicker.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/boostrap-form-wizard/js/jquery.bootstrap.wizard.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/filestyle/bootstrap-filestyle.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-validation/js/jquery.validate.min.js"></script>
	<!-- END PAGE LEVEL PLUGINS -->
	<!-- BEGIN CORE TEMPLATE JS -->
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/js/core.js?v=<fmt:formatDate pattern="yyyyMMddHHmmss" value="${date }" />"></script>
	<!-- END CORE TEMPLATE JS -->
	<!-- BEGIN AMCHARTS JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/amcharts/amcharts.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/amcharts/serial.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/amcharts/pie.js"></script>
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/amcharts/themes/light.js"></script>
    <!-- END AMCHARTS JS -->
    <!-- BEGIN FULLCALENDER JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/fullcalendar/fullcalendar.min.js"></script>
    <!-- END FULLCALENDER JS -->
    <!-- BEGIN PRINT JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/plugins/jquery-printarea/jquery.PrintArea.js"></script>
    <!-- END PRINT JS -->
    <!-- BEGIN VALIDATION JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/js/validation.js"></script>
    <!-- END VALIDATIONJS -->
    <!-- BEGIN COMMON JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/Bootstrap/assets/js/common.js"></script>
	<!-- END COMMON JS -->
	<!-- BEGIN jqueryUi  JS -->
<%--     <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/jqueryUi/jquery-ui.js"></script> --%>
	<!-- END jqueryUi JS -->
	<!-- BEGIN jqGrid JS -->
    <script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/jqGrid/js/jquery.jqGrid.min.js"></script>
	<script type="text/javascript" src="//<spring:eval expression="@config['SERVICE_DOMAIN']"/>/jqGrid/js/i18n/grid.locale-en.js"></script>
	<!-- END jqGrid JS -->

</body>
</html>