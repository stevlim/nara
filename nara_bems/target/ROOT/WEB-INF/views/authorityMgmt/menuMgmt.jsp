<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objMenuTable;

$(document).ready(function(){
   $("body").tooltip({
        selector : "[data-toggle='tooltip']"
    });
   
	IONPay.Auth.Init("${AUTH_CD}");
	fnSetValidate();
	fnSetDDLB();
});

function fnSetDDLB() {
	$("#selMenuType").html("<c:out value='${MENU_TYPE}' escapeXml='false' />");  
}

/**------------------------------------------------------------
* 메뉴 등록 유효성 이벤트
------------------------------------------------------------*/
function fnSetValidate() {
    var arrValidate = {
                FORMID   : "frmEditMenu",
                VARIABLE : {
                	MENU_NM        : { required: true, maxlength:50 },
                    MENU_LINK      : { required: true, maxlength:100 },
                    MENU_URI_SGMNT : { required: true, maxlength:100 },
                    STATUS         : { required: true, maxlength:2 }
               }
    }
    
    IONPay.Utils.fnSetValidate(arrValidate);
}

/**------------------------------------------------------------
* 메뉴 리스트 조회
------------------------------------------------------------*/
var fnCreateDataTables = function () {
	var strAuthClass = "${AUTH_CD}" == "1" ? "column10c all" : "column10c never";
	
    if (typeof objMenuTable == "undefined") {
        objMenuTable = IONPay.Ajax.CreateDataTable("#tbMenuMgmt", false, {
            url: '/authorityMgmt/menuMgmt/selectMenuMgmtList.do',
            data: function () {
            	return $("#frmSearchMenu").serializeObject();
            },
            columns: [
                { "data": "RNUM", "class" : "column5c" },
                { "data": null, "render": fnCreateMenuNameRender, "class" : "column20c all" },
                { "data": "MENU_LINK", "class" : "column20c" },
                { "data": null, "render": fnSelectMenuSort, "class" : "column10c all" },
                { "data": null, "render": fnSelectStatus, "class" : "column10c all" },
                { "data": "WORKER", "class" : "column10c" },
                { "data": "MENU_NO", "class" : "column10c" },
                {
                 	 "class" : "column10c",
                      "render": function ( data, type, row ) {
                   	   	return (row.PARENT_MENU_NM == null ? '' : gMessage(row.PARENT_MENU_NM));
                      },
                      className: "dt-body-center"
                  },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.REG_DT)}, "class" : "column10c" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.UPD_DT)}, "class" : "column10c" },
                { "data": null, "render": fnCreateWork, "class" : strAuthClass }
            ],
            ordering : false,
            displayLength: -1,                  
            lengthChange: false,      
            paging: false, 
            createdRow: function (row, data, index) {
                $(row).find('td:last').attr('nowrap', 'nowrap');               
            }
        }, true);
    }
    else{
        objMenuTable.clearPipeline();
        objMenuTable.ajax.reload();
    }
}

/**------------------------------------------------------------
* 메뉴 그룹 리스트 명 Render
------------------------------------------------------------*/
var fnCreateMenuNameRender = function (data) {
    return "<span data-menuno='" + data.MENU_NO + "'>"+gMessage(data.MENU_NM)+"</span>";
}

/**------------------------------------------------------------
* 메뉴 리스트 정렬 Render
------------------------------------------------------------*/
var fnSelectMenuSort = function () {
    return "";
}

/**------------------------------------------------------------
* 메뉴 리스트 상태 Render
------------------------------------------------------------*/
var fnSelectStatus = function (data){
    var intFlag = data.STATUS;

    var strHtml = "<select name='useflagSelect' id='useflagSelect' class='form-control'>";
    strHtml += "<option id='1' class='userflagType' value='1' " + (intFlag == "1" ? "selected='selected'" : "") + ">" + gMessage('IMS_AM_MM_0001') + "</option>";
    strHtml += "<option id='2' class='userflagType' value='2' " + (intFlag == "2" ? "selected='selected'" : "") + ">" + gMessage('IMS_AM_MM_0002') + "</option>";
    strHtml += "</select>";

    return strHtml;                                                                                                                          
}

/**------------------------------------------------------------
* 메뉴 리스트 작업 Render
------------------------------------------------------------*/
var fnCreateWork = function (data){
    var strHtml = "<button type='button' id='btnEditMenu' data-toggle='modal' data-target='#divEditMenuModal' data-menuno='" + data.MENU_NO + "' class='btn btn-primary btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_MM_0003') + "</button>";
    strHtml += "&nbsp;&nbsp; <button type='button' id='btnDelMenu' data-menuno='" + data.MENU_NO + "' data-menuseq='" + data.MENU_SEQ + "' class='btn btn-danger btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_MM_0004') + "</button>";
    return strHtml;
}

/**------------------------------------------------------------
* 메뉴 정렬 순서 재배치
------------------------------------------------------------*/
var funcCreateSortSelect = function () {
    var intTotalCnt = $("#tbMenuMgmt tbody tr").size();
    var intCount    = 1;

    $("#tbMenuMgmt tbody tr td:nth-child(4)").each(function () {

        var strHtml = "";

        strHtml += "<select name='selMenuSortSelect' id='selMenuSortSelect" + intCount + "' class='form-control'>";

        for (var intSeqNo = 1; intSeqNo <= intTotalCnt; intSeqNo++) {
            if (intSeqNo == intCount) {
                strHtml += "<option id='" + intSeqNo + "' class='menuSort' value='" + intSeqNo + "' selected='selected' >" + intSeqNo + "</option>";
            }
            else {
                strHtml += "<option id='" + intSeqNo + "' class='menuSort' value='" + intSeqNo + "' >" + intSeqNo + "</option>";
            }
        }

        strHtml += "</select>";

        $(this).html(strHtml);

        intCount++;
    });

    $("[name=selMenuSortSelect]").keydown(function () {
        event.preventDefault();
    });
}

/**------------------------------------------------------------
* 메뉴 등록 Form Clear
------------------------------------------------------------*/
var fnRegMenuFrmClear = function () {
	var icon   = $('.input-with-icon').children('i');
    var parent = $('.input-with-icon');
    var span   = $('.input-with-icon').children('span');

    icon.removeClass("fa fa-exclamation").removeClass('fa fa-check');
    parent.removeClass('error-control').removeClass('success-control');
    span.html("");
    
	$("#txtInsMenuName").val("");
    $("#txtInsMenuLink").val("");
    $("#txtInsMenuURISgmnt").val("");
    $("#txtInsParentMenuNo").val("");
    $("#selInsMenuStatus").select2("val", $("#selInsMenuStatus option[selected]").val());
}

/**------------------------------------------------------------
* 메뉴 등록 결과
------------------------------------------------------------*/
function fnCBMenuInsSuccessResult() {
    fnRegMenuFrmClear();

    objMenuTable.ajax.reload();

    $('#divEditMenuModal').modal('hide');
}

/**------------------------------------------------------------
* 메뉴 등록 Form Clear
------------------------------------------------------------*/
function fnSelectMenuGroupListRet(objJson){
	if(objJson.resultCode == 0){
		var strHtml = "";
        $("#divMenuGroupSelector").show();
        
        strHtml = "<option value=''></option>";
        	
        for (var intIdx = 0; intIdx < objJson.data.length; intIdx++) {
        	strHtml += "<option value='" + objJson.data[intIdx].MENU_GRP_NO + "'>" + gMessage(objJson.data[intIdx].MENU_GRP_NM) + "</option>";
        }

        $("#selMenuGroupNo").html(strHtml);
        $("#selMenuGroupNo").select2("val", $("#selMenuGroupNo option[selected]").val());
	}else{
		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
	}
}

/**------------------------------------------------------------
* 메뉴 이벤트
------------------------------------------------------------*/
$(function () {
	IONPay.Ajax.GetAjaxLoadingWithCallback("", funcCreateSortSelect);
	
	$("#selMenuType").on("change", function(){
		$("#selMenuGroupNo").html("");
		
		if($(this).val() == "" || $(this).val() == "0"){
			$("#divGridArea").hide();
			$("#divMenuGroupSelector").hide();
			$("#divBtnRegist").hide();
		}else{
			$("#selMenuGroupNo").val() == null ?  $("#divBtnRegist").hide() : $("#divBtnRegist").show();
			
			var strCallUrl   = "/authorityMgmt/menuMgmt/selectMenuGroupList.do";
	        var strCallBack  = "fnSelectMenuGroupListRet";
	        var objPram = {};
	        
	        objPram["MENU_GRP_TYPE"] = $(this).val();
	        
	        IONPay.Ajax.fnRequest(objPram, strCallUrl, strCallBack);
		}
	});
	
	
    $("#selMenuGroupNo").on("change", function () {
        var intMenuGroupNo = $("#selMenuGroupNo").children('option').filter(':selected').val();
        var strMenuGroupName = $("#selMenuGroupNo").children('option').filter(':selected').text();
        
        if (intMenuGroupNo == "0" || intMenuGroupNo == "") {
        	$("#txtInsMenuGroupName").text("");
            $("#divGridArea").hide();
            $("#divBtnRegist").hide();
        }
        else {
        	$("#txtInsMenuGroupName").val(strMenuGroupName);
            $("#divGridArea").show();
            $("#divBtnRegist").show();

            fnCreateDataTables();
        }
    });
    
    $("#tbMenuMgmt").on("focus", "[name = 'selMenuSortSelect']", function () {
    	$(this).data("pre", $(this).children('option').filter(':selected').val());
    });

    $("#tbMenuMgmt").on("change", "[name = 'selMenuSortSelect']", function () {
        var $selectedValue           = this.value;
        var intPreviousSelectedValue = $(this).data("pre");
        
        $("[name = 'selMenuSortSelect']").each(function () {
            if ($selectedValue == this.value) {
                $("#" + this.id + " option:eq(" + (parseInt(intPreviousSelectedValue) - 1) + ")").prop("selected", "selected");
            }
        });

        $("#" + this.id + " option:eq(" + (parseInt($selectedValue) - 1) + ")").prop("selected", "selected");
        $(this).data("pre", $selectedValue);
        
        return false;
    });
    
    $('#btnEditMenuList').on("click", function () {
    	IONPay.Msg.fnConfirm(gMessage('IMS_AM_MM_0005'), function () {
            var objInputParam  = {};
            var strMenuNos     = "";
            var strMenuSorts   = "";
            var strMenuStatus  = "";

            $("#tbMenuMgmt tbody tr").each(function () {
                strMenuNos += (strMenuNos != "" ? "," + $(this).find("td:eq(1) span").data("menuno") : $(this).find("td:eq(1) span").data("menuno"));
                strMenuSorts += (strMenuSorts != "" ? "," + $(this).find("td:eq(3) select").val() : $(this).find("td:eq(3) select").val());
                strMenuStatus += (strMenuStatus != "" ? "," + $(this).find("td:eq(4) select").val() : $(this).find("td:eq(4) select").val());
            });
            
            objInputParam["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
            objInputParam["menunos"] = strMenuNos;
            objInputParam["menusorts"] = strMenuSorts;
            objInputParam["status"] = strMenuStatus;
            
            $.post("/authorityMgmt/menuMgmt/updateMenuList.do", $.param(objInputParam)).done(function (objJson) {
                if (objJson.resultCode != 0) {
                	IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
                } else {
                    objMenuTable.ajax.reload();
                }
            }).fail(function (XMLHttpRequest) {
                if(XMLHttpRequest.status == 901) {
                    location.href = IONPay.LOGINURL;
                } else {
                    IONPay.Msg.fnAlert(IONPay.AJAXERRORMSG);
                }
            });
        });
    });
    
    $('#btnRegistMenu').on("click", function () {
        $("#hidInsMenuNo").val("0");
        $("#iconRegist").show();
        $("#iconEdit").hide();
        
        fnRegMenuFrmClear();
    });
    
    $('#btnEditMenu').on("click", function () {
    	var intMenuNo  = $("#hidInsMenuNo").val();
        var strMethod  = (intMenuNo == "0") ? "insert" : "update";
        var strCallURI = "";
        
        if(strMethod == "insert")
        {
        	strCallURI = "/authorityMgmt/menuMgmt/insertMenuMgmt.do";
        }
        else
        {
        	strCallURI = "/authorityMgmt/menuMgmt/updateMenuMgmt.do";
        }
        
        if (!$("#frmEditMenu").valid()) {
            return false;
        }
        
        IONPay.Ajax.fnRequestPost(strCallURI, $("#frmEditMenu, #frmSearchMenu").serialize(), "divEditMenuModal", fnCBMenuInsSuccessResult);
    });
    
    $('#tbMenuMgmt').on("click", "[type=button]#btnEditMenu", function (event) {
        var intMenuNo = $(this).data("menuno");
        var strParam  = "MENU_NO=" + intMenuNo + "&IMSRequestVerificationToken=" + IONPay.AntiCSRF.getVerificationToken();
        
        $("#iconRegist").hide();
        $("#iconEdit").show();
        
        fnRegMenuFrmClear();
        $.post("/authorityMgmt/menuMgmt/selectMenuInfo.do", strParam).done(function (objJson) {
        	if(objJson.resultCode == 0){
        		if (objJson.data.length > 0) {
                    $("#hidInsMenuNo").val(objJson.data[0].MENU_NO);
                    $("#hidInsMenuSort").val(objJson.data[0].MENU_SEQ);
                    $("#txtInsMenuName").val(objJson.data[0].MENU_NM);
                    $("#txtInsMenuLink").val(objJson.data[0].MENU_LINK);
                    $("#txtInsMenuURISgmnt").val(objJson.data[0].MENU_URI_SGMNT);
                    $("#txtInsParentMenuNo").val(objJson.data[0].PARENT_MENU_NO);
                    $("#selInsMenuStatus").select2("val", objJson.data[0].STATUS);
                }
        	} else {
        		IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
        	}
        }).fail(function (XMLHttpRequest) {
            if(XMLHttpRequest.status == 901) {
                location.href = IONPay.LOGINURL;
            } else {
            	$('#divEditMenuModal').modal('hide');
                IONPay.Msg.fnAlert(IONPay.AJAXERRORMSG);
            }
        });
    });
    
    $('#tbMenuMgmt').on("click", "[type=button]#btnDelMenu", function (event) {
    	var intMenuNo   = $(this).data("menuno");
    	var intMenuSort = $(this).data("menuseq");
    	
    	IONPay.Msg.fnConfirm(gMessage('IMS_AM_MM_0006'), function () {
    		var objInputParam  = {};
            var intMenuGroupNo = $("#selMenuGroupNo").children('option').filter(':selected').val();
            
            objInputParam["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
            objInputParam["MENU_NO"] = intMenuNo;
            objInputParam["MENU_GRP_NO"] = intMenuGroupNo;
            objInputParam["MENU_SEQ"] = intMenuSort;
            
            $.post("/authorityMgmt/menuMgmt/deleteMenuMgmt.do", $.param(objInputParam)).done(function (objJson) {
                if (objJson.resultCode != 0) {
                	IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
                } else {
                	objMenuTable.ajax.reload();
                }
            }).fail(function (XMLHttpRequest) {
                if(XMLHttpRequest.status == 901) {
                    location.href = IONPay.LOGINURL;
                } else {
                    IONPay.Msg.fnAlert(IONPay.AJAXERRORMSG);
                }
            });
        });
    });
});
</script>
<!-- END PAGE JAVASCRIPT -->  
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;" class="active">${MENU_TITLE }</a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold">${MENU_SUBMENU_TITLE }</span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
                <div class="row">
                   <div class="col-md-12">
                       <div class="grid simple">
                          <div class="grid-title no-border">
                              <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_MM_0007'/></h4>
                              <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                          </div>
                          <div class="grid-body no-border">
                            <form id="frmSearchMenu" name="frmSearchMenu">
                                <div class="row form-row">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_AM_MM_0008'/></label> 
                                        <select name="MENU_TYPE" id="selMenuType" class="select2 form-control">
                                        </select>
                                    </div>
                                    <div id="divMenuGroupSelector" class="col-md-3" style="display:none;">
                                        <label class="form-label"><spring:message code='IMS_AM_MM_0009'/></label> 
                                        <select name="MENU_GRP_NO" id="selMenuGroupNo" class="select2 form-control">
                                        </select>
                                    </div>
                                    <div id="divBtnRegist" class="col-md-3" style="display:none;">
                                        <label class="form-label">&nbsp;</label> 
	                                    <div>
	                                       <button id="btnRegistMenu" type='button' class='btn btn-primary auth-all btn-cons' data-toggle='modal' data-target='#divEditMenuModal'><spring:message code='IMS_AM_MM_0010'/></button>
	                                    </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                       </div>
                   </div>
                </div>
                <div id="div_search" class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                           <div class="grid-title no-border">
                               <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_MM_0011'/></h4>
                               <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                           </div>
                           <div class="grid-body no-border">
                             <div class="grid simple ">
                               <div id="divGridArea" class="grid-body " style="display:none;">
	                                  <table class="table" id="tbMenuMgmt" width="100%">
	                                      <thead>
	                                       <tr>
	                                           <th>NO</th>
	                                           <th><spring:message code='IMS_AM_MM_0012'/></th>
	                                           <th><spring:message code='IMS_AM_MM_0013'/></th>
	                                           <th><spring:message code='IMS_AM_MM_0014'/></th>
	                                           <th><spring:message code='IMS_AM_MM_0015'/></th>
	                                           <th><spring:message code='IMS_AM_MM_0016'/></th>
	                                           <th>MENU_NO</th>
	                                           <th>PARENT_MENU_NM</th>
	                                           <th><spring:message code='IMS_AM_MM_0017'/></th>
	                                           <th><spring:message code='IMS_AM_MM_0018'/></th>
	                                           <th><spring:message code='IMS_AM_MM_0019'/></th>
	                                       </tr>
	                                      </thead>
	                                  </table>
		                              <br />
		                              <div class="panel panel-info auth-all">
		                                  <div class="panel-heading" style="text-align:right;">
		                                      <button id="btnEditMenuList" type='button' class='btn btn-danger auth-all'>모두 저장</button>
		                                  </div>
		                              </div>
		                          </div>    
                              </div>
                            </div>
                        </div>
                    </div>
                </div>              
                <!-- END PAGE FORM -->
           </div>   
           <!-- END PAGE --> 
        </div>
        <!-- END PAGE CONTAINER-->
    </div>
    <!-- Modal Menu Insert Area -->
    <div class="modal fade" id="divEditMenuModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">    
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" data-dismiss="modal">x</button>
                    <br>
                    <i id="iconRegist" class="fa fa-pencil fa-2x"></i>
                    <i id="iconEdit" class="fa fa-edit fa-2x" style="display:none;"></i>
                    <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_AM_MM_0020'/></h4>
                    <br>
                </div>
                <div class="modal-body">
                    <form name="frmEditMenu" id="frmEditMenu">
                        <input type="hidden" id="hidInsMenuNo" name="MENU_NO" class="form-control" required />
                        <input type="hidden" id="hidInsMenuSort" name="MENU_SEQ" class="form-control" value="0" />
                        <input type="hidden" id="IMSRequestVerificationToken" name="IMSRequestVerificationToken" value="<c:out value="${IMSRequestVerificationToken}"/>" />
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MM_0009'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuGroupName" name="menugroupname" class="form-control" disabled="disabled">                           
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MM_0012'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuName" data-toggle="tooltip" title="<spring:message code='IMS_AM_MM_0023'/>" name="MENU_NM" class="form-control" maxlength="50" required/>                                 
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MM_0013'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuLink" name="MENU_LINK" class="form-control" maxlength="100" required/>                                 
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MM_0021'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuURISgmnt" name="MENU_URI_SGMNT" class="form-control" maxlength="100" required/>                                
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">PARENT_MENU_NO</label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsParentMenuNo" name="PARENT_MENU_NO" class="form-control" maxlength="10"/>                                
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MM_0022'/></label>
                            <span class="help"></span>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <select id="selInsMenuStatus" name="STATUS" class="select2 form-control" required>
                                    <option value="1" selected><spring:message code='IMS_AM_MM_0001'/></option>
                                    <option value="2"><spring:message code='IMS_AM_MM_0002'/></option>
                                </select>
                            </div>
                        </div> 
                    </form>
                </div>            
                <div class="modal-footer">
                    <div class="pull-right">
                         <button type="button" id="btnEditMenu" class="btn btn-danger">저장</button>
                         <button type="button" class="btn btn-default" data-dismiss="modal" onclick="IONPay.Msg.fnResetBodyClass();">취소</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal Menu Insert Area -->