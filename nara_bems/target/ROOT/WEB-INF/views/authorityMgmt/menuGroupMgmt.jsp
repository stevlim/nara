<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>
<!-- BEGIN PAGE JAVASCRIPT -->
<script type="text/javascript">
var objMenuGroupTable;

$(document).ready(function(){
   $("body").tooltip({
        selector : "[data-toggle='tooltip']"
    });
   
    IONPay.Auth.Init("${AUTH_CD}");
    fnSetValidate();
    fnSetDDLB();
});

function fnSetDDLB() {
    $("#selMenuGroupType").html("<c:out value='${MENU_GROUP_TYPE}' escapeXml='false' />");
}

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
* 메뉴 그룹 조회
------------------------------------------------------------*/
var fnCreateDataTables = function () {
    var strAuthClass = "${AUTH_CD}" == "1" ? "column15c all" : "column15c never";
    
    if (typeof objMenuGroupTable == "undefined") {
        objMenuGroupTable = IONPay.Ajax.CreateDataTable("#tbMenuGroupMgmt", false, {
            url: '/authorityMgmt/menuGroupMgmt/selectMenuGroupMgmtList.do',
            data: function () { 
                return $("#frmSearch").serializeObject();
            },                               
            columns: [              
                { "data": "RNUM", "class" : "column5c all" },
                { "data": null, "render": fnInputMenuName, "class" : "column20c all" },
                { "data": null, "render": fnSelectMenuSort, "class" : "column10c all" },
                { "data": null, "render": fnSelectStatus, "class" : "column10c all" },
                { "data": "WORKER", "class" : "column15c" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.REG_DT)}, "class" : "column10c" },
                { "data" : null, "render": function(data){return IONPay.Utils.fnStringToDateTimeFormat(data.UPD_DT)}, "class" : "column10c" },
                { "data": null, "render": fnCreateWork, "class" : strAuthClass }
            ],
            ordering : false,
            paging: false,
            dom: "rt"
        }, true);
    } else {
        objMenuGroupTable.clearPipeline();
        objMenuGroupTable.ajax.reload();
    }
}

/**------------------------------------------------------------
* 메뉴 그룹 리스트 명 Render
------------------------------------------------------------*/
var fnInputMenuName = function (data) {
    return "<input type='text' value='" + gMessage(data.MENU_GRP_NM) + "' class='form-control' data-toggle='tooltip' title='" + gMessage("IMS_AM_MGM_0024") + "' data-menugrpno='" + data.MENU_GRP_NO + "' data-menugrpname='" + data.MENU_GRP_NM + "' maxlength='30' />";
}

/**------------------------------------------------------------
* 메뉴 그룹 리스트 정렬 Render
------------------------------------------------------------*/
var fnSelectMenuSort = function () {
    return "";
}

/**------------------------------------------------------------
* 메뉴 그룹 정렬 순서 재배치
------------------------------------------------------------*/
var funcCreateSortSelect = function () {
    var intTotalCnt = $("#tbMenuGroupMgmt tbody tr").size();
    var intCount    = 1;
    
    $("#tbMenuGroupMgmt tbody tr td:nth-child(3)").each(function () {
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

function fnDrawSortSelect(){
    var intTotalCnt = $("#tbMenuGroupMgmt tbody tr").size();
    var strHtml     = "";

    strHtml += "<select name='selMenuSortSelect' id='selMenuSortSelect" + intTotalCnt+1 + "' class='form-control'>";

    for (var intSeqNo = 1; intSeqNo <= intTotalCnt; intSeqNo++) {
        if (intSeqNo == intTotalCnt+1) {
            strHtml += "<option id='" + intSeqNo + "' class='menuSort' value='" + intSeqNo + "' selected='selected' >" + intSeqNo + "</option>";
        }
        else {
            strHtml += "<option id='" + intSeqNo + "' class='menuSort' value='" + intSeqNo + "' >" + intSeqNo + "</option>";
        }
    }
    strHtml += "</select>";
    
    return strHtml;
}

/**------------------------------------------------------------
* 메뉴 그룹 리스트 상태 Render
------------------------------------------------------------*/
var fnSelectStatus = function (data, type, full, meta) {
    var strSelectedText    = " selected='selected' ";
    var strYesSelectedText = "";
    var strNoSelectedText  = "";

    if (data.STATUS == "1") {
        strYesSelectedText = strSelectedText;
    }
    else {
        strNoSelectedText = strSelectedText;
    }

    var strHtml = "<select name='selSTATUS' id='selSTATUS' class='form-control'>";
    strHtml += "<option id='1' class='userflagType' value='1' " + strYesSelectedText + " >" + gMessage('IMS_AM_MGM_0001') + "</option>";
    strHtml += "<option id='2' class='userflagType' value='2' " + strNoSelectedText + " >" + gMessage('IMS_AM_MGM_0002') + "</option>";
    strHtml += "</select>";

    return strHtml;
}

/**------------------------------------------------------------
* 메뉴 그룹 리스트 작업 Render
------------------------------------------------------------*/
var fnCreateWork = function (data, type, full, meta) {
    //var strHtml = "<button id='btnRegistMenu' data-toggle='modal' type='button' data-target='#divEditMenuModal' data-menugrpno='" + data.MENU_GRP_NO + "' data-menugrpname='" + gMessage(data.MENU_GRP_NM) + "' class='btn btn-primary btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_MGM_0003') + "</button>";
    //strHtml += "&nbsp;&nbsp;<button id='btnDeleteMenuGroup' type='button' data-menugrpno='" + data.MENU_GRP_NO + "' data-menugrpseq='" + data.MENU_GRP_SEQ + "' class='btn btn-danger btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_MGM_0004') + "</button>";
    var strHtml = "&nbsp;&nbsp;<button id='btnDeleteMenuGroup' type='button' data-menugrpno='" + data.MENU_GRP_NO + "' data-menugrpseq='" + data.MENU_GRP_SEQ + "' class='btn btn-danger btn-xs btn-mini auth-all btn-cons'>" + gMessage('IMS_AM_MGM_0004') + "</button>";
    return strHtml;
}

/**------------------------------------------------------------
* 메뉴 그룹 등록 Form Clear
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
    $("#selInsMenuStatus").select2("val", $("#selInsMenuStatus option[selected]").val())
}

/**------------------------------------------------------------
* 메뉴 등록 결과
------------------------------------------------------------*/
function fnCBMenuInsSuccessResult() {
    fnRegMenuFrmClear();

    objMenuGroupTable.ajax.reload();

    $('#divEditMenuModal').modal('hide');
}

/**------------------------------------------------------------
* 메뉴 그룹 이벤트
------------------------------------------------------------*/
$(function () {
    IONPay.Ajax.GetAjaxLoadingWithCallback("", funcCreateSortSelect);
    
    $("#selMenuGroupType").on("change", function () {
        var intMenuGroupType = $("#selMenuGroupType").children('option').filter(':selected').val();
        
        if (intMenuGroupType == "0" || intMenuGroupType == "") {
            $("#divGridArea").hide();
            $("#divBtnRegist").hide();
        }
        else {
            $("#divGridArea").show();
            $("#divBtnRegist").show();

            fnCreateDataTables();
        }
    });
    
    $("#tbMenuGroupMgmt").on("focus", "[name = 'selMenuSortSelect']", function () {
        $(this).data("pre", $(this).children('option').filter(':selected').val());
    });

    $("#tbMenuGroupMgmt").on("change", "[name = 'selMenuSortSelect']", function () {
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
    
    $('#btnAddMenuGroup').on("click", function () {
        var strHtml = "";
        var intSelectCount = $("#tbMenuGroupMgmt tbody tr").size();
        var intSelectCellCount = $("#tbMenuGroupMgmt tbody tr td").size();
        
        if(intSelectCount > 0 && intSelectCellCount > 1){
            var strStatusHtml = "<select name='selSTATUS' id='selSTATUS' class='form-control'>";
            strStatusHtml += "<option id='1' class='userflagType' value='1' selected>" + gMessage('IMS_AM_MGM_0001') + "</option>";
            strStatusHtml += "<option id='2' class='userflagType' value='2' >" + gMessage('IMS_AM_MGM_0002') + "</option>";
            strStatusHtml += "</select>";
            
            strHmtl = "<tr class='odd'>";
            strHmtl += "<td class='column5c'></td>";
            strHmtl += "<td class='column20c'><input type='text' value='' class='form-control' data-toggle='tooltip' title='" + gMessage("IMS_AM_MGM_0024") + "' data-menugrpno='' data-menugrpname='' maxlength='30' /></td>";
            strHmtl += "<td class='column10c'>" + fnDrawSortSelect() + "</td>";
            strHmtl += "<td class='column10c'>" + strStatusHtml + "</td>";
            strHmtl += "<td class='column15c'></td>";
            
            strHmtl += "<td class='column10c'></td>";
            strHmtl += "<td class='column10c'></td>";
            strHmtl += "<td class='column15c'><button type='button' id='btnDelAddMenuGroup' name='close' class='btn btn-danger btn-xs btn-mini'>" + gMessage('IMS_AM_MGM_0004') + "</button></td></tr>";

            $("#tbMenuGroupMgmt tbody").append(strHmtl);
            
            $("#tbMenuGroupMgmt tbody [name = 'selMenuSortSelect']").each(function () {
                $(this).append("<option value='" + (intSelectCount + 1) + "'>" + (intSelectCount + 1) + "</option>");
            });

            $("#tbMenuGroupMgmt tbody tr:last td:eq(2) select option:last").attr("selected", "selected");
            $("#tbMenuGroupMgmt tbody tr:last td:eq(3) select option:first").attr("selected", "selected");
            
        }else{
            var strStatusHtml = "<select name='selSTATUS' id='selSTATUS' class='form-control'>";
            strStatusHtml += "<option id='1' class='userflagType' value='1' selected>" + gMessage('IMS_AM_MGM_0001') + "</option>";
            strStatusHtml += "<option id='2' class='userflagType' value='2' >" + gMessage('IMS_AM_MGM_0002') + "</option>";
            strStatusHtml += "</select>";
            
            strHmtl = "<tr class='odd'>";
            strHmtl += "<td class='column5c'></td>";
            strHmtl += "<td class='column20c'><input type='text' value='' class='form-control' data-toggle='tooltip' title='" + gMessage("IMS_AM_MGM_0024") + "' data-menugrpno='' data-menugrpname='' maxlength='30' /></td>";
            strHmtl += "<td class='column10c'></td>";
            strHmtl += "<td class='column10c'>" + strStatusHtml + "</td>";
            strHmtl += "<td class='column15c'></td>";
            
            strHmtl += "<td class='column10c'></td>";
            strHmtl += "<td class='column10c'></td>";
            strHmtl += "<td class='column15c'><button type='button' id='btnDelAddMenuGroup' name='close' class='btn btn-danger btn-xs btn-mini'>" + gMessage('IMS_AM_MGM_0004') + "</button></td></tr>";
            
            $("#tbMenuGroupMgmt tbody").html(strHmtl);
            
            funcCreateSortSelect();
        }
    });
    
    $('#tbMenuGroupMgmt').on("click", "[type=button]#btnDelAddMenuGroup", function () {
        $(this).parents("tr").remove();
        funcCreateSortSelect();
        
        var intSelectCount = $("#tbMenuGroupMgmt tbody tr").size();
        
        if(intSelectCount == 0){
            objMenuGroupTable.clearPipeline();
            objMenuGroupTable.ajax.reload();
        }
    });
    
    $('#btnEditMenuGroup').on("click", function () {
        IONPay.Msg.fnConfirm(gMessage('IMS_AM_MGM_0005'), function () {
            var bnlEmptyFlag     = false;
            var intMenuGroupType = $("#selMenuGroupType").children('option').filter(':selected').val();

            $("#tbMenuGroupMgmt tbody tr").each(function () {
                if ($(this).find("td:eq(1) input:text").val().trim() == "") {
                    bnlEmptyFlag = true;
                    return false;
                }
            });

            if (bnlEmptyFlag) {
                IONPay.Msg.fnAlert(gMessage('IMS_AM_MGM_0006'));
                return;
            }

            var objInputParam     = {};
            var strMenuGroupNos   = "";
            var strMenuGroupNames = "";
            var strMenuGroupSorts = "";
            var strStatus         = "";

            $("#tbMenuGroupMgmt tbody tr").each(function () {
                var intMenuGroupNo   = $(this).find("td:eq(1) input:text").data("menugrpno") == "" ? 0 : $(this).find("td:eq(1) input:text").data("menugrpno");
                var strMenuGroupName = $(this).find("td:eq(1) input:text").data("menugrpname") == "" ? $(this).find("td:eq(1) input:text").val() : 
                                       gMessage($(this).find("td:eq(1) input:text").data("menugrpname")) == $(this).find("td:eq(1) input:text").val() ? $(this).find("td:eq(1) input:text").data("menugrpname"): $(this).find("td:eq(1) input:text").val();
                
                strMenuGroupNos     += (strMenuGroupNos != "" ? "," + intMenuGroupNo : intMenuGroupNo);
                strMenuGroupNames   += (strMenuGroupNames != "" ? "," + strMenuGroupName : strMenuGroupName);
                strMenuGroupSorts   += (strMenuGroupSorts != "" ? "," + $(this).find("td:eq(2) select").val() : $(this).find("td:eq(2) select").val());
                strStatus           += (strStatus != "" ? "," + $(this).find("td:eq(3) select").val() : $(this).find("td:eq(3) select").val());
            });
            
            objInputParam["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
            objInputParam["menugroupnos"]               = strMenuGroupNos;
            objInputParam["menugroupnames"]             = strMenuGroupNames;
            objInputParam["menugroupsorts"]             = strMenuGroupSorts;
            objInputParam["menugrouptype"]              = intMenuGroupType;
            objInputParam["stauts"]                     = strStatus;
            
            $.post("/authorityMgmt/menuGroupMgmt/updateMenuGroupMgmt.do", $.param(objInputParam)).done(function (objJson) {
                if (objJson.resultCode != 0) {
                    IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
                } else {
                    objMenuGroupTable.ajax.reload();
                }
                
                IONPay.Msg.fnResetBodyClass();
            }).fail(function (XMLHttpRequest) {
                if(XMLHttpRequest.status == 901) {
                     location.href = IONPay.LOGINURL;
                } else {
                    IONPay.Msg.fnAlert(IONPay.AJAXERRORMSG);
                    IONPay.Msg.fnResetBodyClass();
                }
            });
        });
    });
    
    $('#tbMenuGroupMgmt').on("click", "[type=button]#btnDeleteMenuGroup", function (event) {
        var intMenuGroupNo   = $(this).data("menugrpno");
        var intMenuGroupSort = $(this).data("menugrpseq");
        
        IONPay.Msg.fnConfirm(gMessage('IMS_AM_MGM_0007'), function () {
            var objInputParam    = {};
            
            objInputParam["IMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();
            objInputParam["MENU_GRP_NO"]                = intMenuGroupNo;
            objInputParam["MENU_GRP_SEQ"]               = intMenuGroupSort;
            objInputParam["MENU_GRP_TYPE"]              = $("#selMenuGroupType").children('option').filter(':selected').val();
            
            $.post("/authorityMgmt/menuGroupMgmt/deleteMenuGroupMgmt.do", $.param(objInputParam)).done(function (objJson) {
                if (objJson.resultCode != 0) {
                    IONPay.Msg.fnAlert(IONPay.COMMONERRORMSG);
                }
                else {
                    objMenuGroupTable.ajax.reload();
                }
                
                IONPay.Msg.fnResetBodyClass();
            }).fail(function (XMLHttpRequest) {
                if(XMLHttpRequest.status == 901) {
                    location.href = IONPay.LOGINURL;
                } else {
                    IONPay.Msg.fnAlert(IONPay.AJAXERRORMSG);
                    IONPay.Msg.fnResetBodyClass();
                }
            });
        });
    });
    
    $('#tbMenuGroupMgmt').on("click", "[type=button]#btnRegistMenu", function (event) {
        var intMenuGroupNo   = $(this).data("menugrpno");
        var strMenuGroupName = $(this).data("menugrpname");
        var intMenuGroupType = $("#selMenuGroupType").children('option').filter(':selected').val();
        
        $("#hidInsMenuGroupNo").val(intMenuGroupNo);
        $("#txtInsMenuGroupName").val(strMenuGroupName);
        $("#hidInsMenuType").val(intMenuGroupType);
        
        fnRegMenuFrmClear();
    });
    
    $('#btnEditMenu').on("click", function () {
        if (!$("#frmEditMenu").valid()) {
            return;
      }
        
        IONPay.Ajax.fnRequestPost("/authorityMgmt/menuGroupMgmt/insertMenuMgmt.do", $("#frmEditMenu").serialize(), "divEditMenuModal", fnCBMenuInsSuccessResult, null);
    });
});
</script>
<!-- END PAGE JAVASCRIPT -->
        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">
            <!-- BEGIN PAGE -->         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;" class="active"><c:out value="${MENU_TITLE }" /></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
                <div class="row">
                   <div class="col-md-12">
                       <div class="grid simple">
                          <div class="grid-title no-border">
                              <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_MGM_0008'/></h4>
                              <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                          </div>
                          <div class="grid-body no-border">
                            <form id="frmSearch" name="frmsearch">
                                <div class="row form-row">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_AM_MGM_0009'/></label> 
                                        <select name="MENU_GRP_TYPE" id="selMenuGroupType" class="select2 form-control">
                                        </select>
                                    </div>
                                    <div id="divBtnRegist" class="col-md-3" style="display:none;">
                                        <label class="form-label">&nbsp;</label>
                                        <div>
                                            <button id="btnAddMenuGroup" type='button' class='btn btn-primary auth-all btn-cons'><spring:message code='IMS_AM_MGM_0010'/></button>
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
                               <h4><i class="fa fa-th-large"></i><spring:message code='IMS_AM_MGM_0011'/></h4>
                               <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                           </div>
                           <div class="grid-body no-border">
                              <div class="grid simple ">
                              <div id="divGridArea" class="grid-body " style="display:none;">
                                     <table class="table dt-responsive nowrap" id="tbMenuGroupMgmt" width="100%">
                                         <thead>
                                          <tr>
                                              <th>NO</th>
                                              <th><spring:message code='IMS_AM_MGM_0012'/></th>
                                              <th><spring:message code='IMS_AM_MGM_0013'/></th>
                                              <th><spring:message code='IMS_AM_MGM_0014'/></th>
                                              <th><spring:message code='IMS_AM_MGM_0015'/></th>
                                              <th><spring:message code='IMS_AM_MGM_0016'/></th>
                                              <th><spring:message code='IMS_AM_MGM_0017'/></th>
                                              <th><spring:message code='IMS_AM_MGM_0018'/></th>
                                          </tr>
                                         </thead>
                                     </table>
                                     <br />
                                     <div class="panel panel-info auth-all">
                                         <div class="panel-heading" style="text-align:right;">
                                             <button id="btnEditMenuGroup" type='button' class='btn btn-danger auth-all'>모두 저장</button>
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
        <!-- END CONTAINER -->
      </div>
    </div>
    <!-- Modal Menu Insert Area -->
    <div class="modal fade" id="divEditMenuModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">    
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" aria-hidden="true" data-dismiss="modal">x</button>
                    <br>
                    <i id="iconRegist" class="fa fa-pencil fa-2x"></i>
                    <h4 id="myModalLabel" class="semi-bold"><spring:message code='IMS_AM_MGM_0019'/></h4>
                    <br>
                </div>
                <div id="div_frm" class="modal-body">
                    <form id="frmEditMenu" name="frmEditMenu">
                        <input type="hidden" id="hidInsMenuGroupNo" name="MENU_GRP_NO" />
                        <input type="hidden" id="hidInsMenuType" name="MENU_TYPE" />
                        <input type="hidden" id="IMSRequestVerificationToken" name="IMSRequestVerificationToken" value="<c:out value="${IMSRequestVerificationToken}"/>" />
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MGM_0012'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuGroupName" name="MENU_GRP_NM" class="form-control" disabled="disabled">                           
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MGM_0020'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuName" data-toggle="tooltip" title="<spring:message code='IMS_AM_MGM_0024'/>" name="MENU_NM" class="form-control" maxlength="50"/>                                 
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MGM_0021'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuLink" name="MENU_LINK" class="form-control" maxlength="100"/>                                 
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MGM_0022'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <input type="text" id="txtInsMenuURISgmnt" name="MENU_URI_SGMNT" class="form-control" maxlength="100"/>                                
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label"><spring:message code='IMS_AM_MGM_0023'/></label>
                            <div class="input-with-icon  right">                                       
                                <i class=""></i>
                                <select id="selInsMenuStatus" name="STATUS" class="select2 form-control">
                                    <option value="1" selected><spring:message code='IMS_AM_MGM_0001'/></option>
                                    <option value="2"><spring:message code='IMS_AM_MGM_0002'/></option>
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