<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
var objNoticeMgmtListDT;
var strWorker = "<%=CommonUtils.getSessionInfo(session, "USR_ID")%>";
var pageCl = <%= request.getParameter("pageCl")%>;
var detailSeq = <%= request.getParameter("seq")%>;

$(document).ready(function(){	
	fnInitEvent();
	fnSetDDLB();
	
});

window.onload = function(){
	if(pageCl == "moreInfo"){
		$("#btn1Month").click();
		fnNoticeMgmtListDT();
	}else if(detailSeq != null){
		fnSelectDetatil(detailSeq);
	}
}

function fnSelectDetatil(seq){
    var strCallURI = strCallURI = "/businessMgmt/noticeMgmt/selectNoticeMgmt.do";
    var strCallBack = "fnSelectDetatilRet";            	
    var objParam    = {};
	    
    objParam["SEQ"] = seq;
    
    IONPay.Ajax.fnRequest(objParam, strCallURI, strCallBack);
}

function fnSelectDetatilRet(data){
	IONPay.Utils.fnClearShowUpdateForm();
	$("#div_frm").css("display","block");
	$("#division1").val(data.rowData.NOTI_CD1);
	$("#TITLE1").val(data.rowData.TITLE);
	$("#MEMO_EDITOR1").val(data.rowData.BODY);
	$("#register1").val(data.rowData.WORKER);
	IONPay.Utils.fnJumpToPageTop();
}

function fnInitEvent() {
	$("#btnSearch").on("click", function() {
		fnNoticeMgmtListDT();
	});
	$("#btnRegist").on("click", function() {
		$("#div_frm").css("display","block");
		if($("input[name=editMode]").val() == "insert"){
			$("#frmEdit #div_status1").css("display", "none");
		}
		
	});
	$("#btnEdit").on("click", function() {		
		if (!$("#frmEdit").valid()) {
			  return;
		}
		var flg = $("#frmEdit #editMode1").val();
		if($("#frmEdit #division1").val() == ""){
			IONPay.Msg.fnAlert("구분을 선택해 주세요.");
			$("#frmEdit #division1").focus();
			 return;
		}
		if($("#frmEdit #notiLocation1").val() == ""){
			IONPay.Msg.fnAlert("게시위치를 선택해 주세요.");
			$("#frmEdit #notiLocation1").focus();
			 return;
		}
		if($("#frmEdit #TITLE1").val() == ""){
			IONPay.Msg.fnAlert("제목을 입력해 주세요.");
			$("#frmEdit #TITLE1").focus();
			 return;
		}
		if($("#frmEdit #MEMO_EDITOR1").val() == ""){
			IONPay.Msg.fnAlert("내용을 입력해 주세요.");
			$("#frmEdit #MEMO_EDITOR1").focus();
			 return;
		}
		if($("#frmEdit #register1").val() == ""){
			IONPay.Msg.fnAlert("등록자를 입력해 주세요.");
			$("#frmEdit #register1").focus();
			 return;
		}
		/* if($("#frmEdit #textImageCd").val() == ""){
			IONPay.Msg.fnAlert("텍스트/이미지 구분을 선택해 주세요.");
			$("#frmEdit #textImageCd").focus();
			 return;
		} */
		fnEditNoticeMgmt(flg);
		
	
	});

}

function fnSetDDLB() {
	$("#frmEdit select[name=division]").html("<c:out value='${notiDivision}' escapeXml='false' />");
	$("#frmEdit select[name=notiLocation]").html("<c:out value='${notiLocation}' escapeXml='false' />");
	/* $("#frmEdit select[name=textImageCd]").html("<c:out value='${textImageCd}' escapeXml='false' />"); */
	$("#frmUpdateEdit select[name=division]").html("<c:out value='${notiDivision}' escapeXml='false' />");
	$("#frmUpdateEdit select[name=notiLocation]").html("<c:out value='${notiLocation}' escapeXml='false' />");
	/* $("#frmUpdateEdit select[name=textImageCd]").html("<c:out value='${textImageCd}' escapeXml='false' />"); */
	$("#frmSearch select[name=BOARD_TYPE]").html("<c:out value='${BOARD_TYPE}' escapeXml='false' />");
	$("#frmSearch select[name=BOARD_CHANNEL]").html("<c:out value='${BOARD_CHANNEL}' escapeXml='false' />");
	/* $("#frmSearch select[name=textImageCd]").html("<c:out value='${textImageCd}' escapeXml='false' />"); */
}

function modalClose(){			
	$("#div_update_frm").css("display","none");			
}

/**------------------------------------------------------------
* 공지사항 리스트 조회
------------------------------------------------------------*/
function fnNoticeMgmtListDT() {
	var $FROM_DT = $("#txtFromDate");
    var $TO_DT   = $("#txtToDate");
    
	var intFromDT = Number(IONPay.Utils.fnConvertDateFormat($FROM_DT.val()));
    var intToDT   = Number(IONPay.Utils.fnConvertDateFormat($TO_DT.val()));
        
    if (intFromDT > intToDT) {
        IONPay.Msg.fnAlert(gMessage('IMS_BM_NM_0011'));
        return;
    }
    
    if (!IONPay.Utils.fnCheckSearchRange($("#txtFromDate"), $("#txtToDate"), "3")) {
        return;
   	}
   	if (typeof objNoticeMgmtListDT == "undefined") {
   		objNoticeMgmtListDT = IONPay.Ajax.CreateDataTable("#tbNoticeMgmtList", true, {
   	        url: "/businessMgmt/noticeMgmt/selectNoticeMgmtList.do",
   	        data: function() {	
   	            return $("#frmSearch").serializeObject();
   	        },
       	 	columns: [
				{ "class" : "column5c all",         "data" : null, "render": function(data){return  data.NO} },
	            { "class" : "column5c all",         "data" : null, "render": function(data){return  data.NOTI_CD1} },	            
	            { "class" : "column20l all",         "data" : null, "render": fnDetailLink },
	            { "class" : "column10c all",         "data" : null, "render": function(data){return  data.REG_DT} },
	            { "class" : "column10c all",         "data" : null, "render": function(data){return  data.WORKER} }
	            /* { "class" : "columnc all",         "data" : null, "render": function(data){return  data.NOTI_ST_CD1 } }, */	            	            
            ]
   	    }, true);
   	} else {
   		objNoticeMgmtListDT.clearPipeline();
   		objNoticeMgmtListDT.ajax.reload();
   	}
   	IONPay.Utils.fnShowSearchArea();
   	////IONPay.Utils.fnHideSearchOptionArea();
}

function fnDetailLink(data){
	var strHtml = "";
	
	strHtml += "<sapn data-no = '"+data.NO+"' ";
	strHtml += "data-seq = '"+data.SEQ+"' ";
	strHtml += "data-title = '"+data.TITLE+"' ";
	strHtml += "data-body = '"+data.BODY+"' ";
	strHtml += "data-regdt = '"+data.REG_DT+"' ";
	strHtml += "data-worker = '"+data.WORKER+"' ";
	strHtml += "data-noticd1 = '"+data.NOTI_CD1+"' ";
	strHtml += " onclick='fnViewFull(this);' style='cursor:pointer; color:blue;' >"+data.TITLE+"</span>";
	
	return strHtml;
}

function fnViewFull(data){	
	IONPay.Utils.fnClearShowUpdateForm();
	$("#div_frm").css("display","block");
	$("#division1").val(data.dataset.noticd1);
	$("#TITLE1").val(data.dataset.title);
	$("#MEMO_EDITOR1").val(data.dataset.body);
	$("#register1").val(data.dataset.worker);
	IONPay.Utils.fnJumpToPageTop();
}


</script>

        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">         
            <div class="content">
                <div class="clearfix"></div>
                <!-- BEGIN PAGE TITLE -->
                <ul class="breadcrumb">
                    <li><p>YOU ARE HERE</p></li>
                    <li><a href="javascript:;"><c:out value="${MENU_TITLE }" /></a> </li>
                    <li><a href="javascript:;" class="active"><spring:message code='${CommonMessage.BUSINESSMGMT_MERCHANTMGMT_TITLE }'/></a> </li>
                </ul>
                <div class="page-title"> <i class="icon-custom-left"></i>
                    <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
                </div>
                <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
                <div id="div_frm" class="row" style="display:none;">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <span id="spn_frm_title">Regist</span></h4>
                                <div class="tools"> <a href="javascript:;" class="remove"></a></div>
                            </div>
                            <form id="frmEdit">
                            <div class="grid-body no-border">
                                <input type="hidden" id="editMode1" name="editMode" value="insert" />
                                <input type="hidden" id="SEQ_NO1" />
                                <div class="row form-row" style="padding:0 0 10px 0;">
                                    <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0013'/></label>
                                        <div class="input-with-icon  right">
	                                        <i class=""></i>
	                                       <input  name="division" id="division1"  class="select2 form-control" readonly="readonly">
	                                       </input>
	                                    </div>
                                    </div>                                    
                                    <%-- <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0014'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select  name="notiLocation" id="notiLocation1"  class="select2 form-control">
	                                       </select>
                                        </div>
                                    </div> --%>
                                    <%-- <div class="col-md-3">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0038'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <select  name="textImageCd" id="textImageCd"  class="select2 form-control">
	                                       </select>
                                        </div>
                                    </div>  --%>                                   	
                                    <div class="col-md-6">
                                    </div>
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-6">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0015'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="TITLE1" name="TITLE" class="form-control" readonly="readonly">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                    </div>     
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">                                    
                                    <div class="col-md-12">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0016'/></label>
                                        <textarea id="MEMO_EDITOR1" name="MEMO_EDITOR" class="form-control" style="height:400px;" readonly="readonly"></textarea>
							        </div>
                                </div>
                                <div class="row form-row" style="border-top:1px dashed #c2c2c2; padding:5px 0 5px 0;">
                                    <div class="col-md-4">
                                        <label class="form-label"><spring:message code='IMS_BM_NM_0018'/></label>
                                        <div class="input-with-icon  right">
                                            <i class=""></i>
                                            <input type="text" id="register1" name="register" maxlength="10"class="form-control" readonly="readonly">
                                        </div>
                                    </div>
                                    <div class="col-md-4" style="display: none;" id="div_status1">
                                    	<label class="form-label"><spring:message code='IMS_BIM_BM_0078'/></label>
                                        <div class="input-with-icon  right" id="status" >
                                            <i class=""></i>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                    </div>   
                                </div>
                            </div>
                            <div class="grid-body no-border">
                                <div class="row form-row">
                                    <div class="col-md-12">
                                        <p class="pull-right">
                                            <!-- <button type="button" id="btnEdit" class="btn btn-danger auth-all">저장</button> -->
                                            <button type="button" id="btnEditCancel" class="btn btn-default"><spring:message code='IMS_RM_AL_0066'></spring:message></button>
                                        </p>
                                    </div>
                                </div>
                            </div>                          
                            </form>
                        </div>
                    </div>
                </div>                
                <!-- END PAGE FORM -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_NM_0019'/></h4>
                                <div class="tools"><a href="javascript:;" id="searchCollapse" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
	                                <div class="row form-row" style="padding:0 0 10px 0;">                                    
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_NM_0013'/></label>
                                            <select id="BOARD_TYPE" name="BOARD_TYPE" class="select2 form-control"
                                            	style="background-image: none;
    												   border-radius: 2px;
    												   border: 1px solid #505458;
    												   padding: 3px 9px;
    												   transition: border 0.2s linear 0s;
    												   height: 35px;"
                                            >                                             
                                            </select>
                                        </div>
                                        <%-- <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_NM_0014'/></label>
                                            <div class="input-with-icon  right">
                                                <i class=""></i>
                                                <select id="BOARD_CHANNEL" name="BOARD_CHANNEL" data-placeholder="" class="select2 form-control">
                                                </select>
                                            </div>
                                        </div> --%>                                       
                                        <div class="col-md-3">
                                        </div>	                                    
	                                </div> 
	                                <%-- <div class="row form-row" style="padding:0 0 10px 0;">
	                                	<div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_NM_0015'/></label>
                                            <input type = "text" id="NOTICE_TITLE" name="NOTICE_TITLE" class="form-control"> </input>
                                        </div>
	                                	<div class="col-md-3">
                                            <label class="form-label">작성자</label>
                                            <input type = "text" id="NOTICE_AUTHOR" name="NOTICE_AUTHOR" class="form-control"></input>
                                        </div>                                        
	                                </div> --%>                               
	                                <div class="row form-row" >
	                                    <div class="col-md-3">
                                            <label class="form-label"><spring:message code='IMS_BM_NM_0020'/></label> 
                                            <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                                <input type="text" id="txtFromDate" name="txtFromDate" class="form-control">
                                                <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>                                             
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                           <label class="form-label">&nbsp;</label>
                                           <div class="input-append success date col-md-10 col-lg-10 no-padding">
                                               <input type="text" id="txtToDate" name="txtToDate" class="form-control">
                                               <span class="add-on"><span class="arrow"></span><i class="fa fa-th"></i></span>
                                           </div>
                                        </div>
                                        <div id="divSearchDateType4" class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <button type="button" id="btnToday" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0021'/></button>                                       
                                            <button type="button" id="btn1Week" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0022'/></button>
                                            <button type="button" id="btn1Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0023'/></button>
                                            <button type="button" id="btn2Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0024'/></button>                                            
                                            <button type="button" id="btn3Month" class="btn btn-success btn-cons"><spring:message code='IMS_BM_NM_0025'/></button>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">&nbsp;</label>
                                            <div>
                                                <button type="button" id="btnSearch" class="btn btn-primary btn-cons"><spring:message code='IMS_BM_NM_0026'/></button>                                            
                                                <%-- <button type="button" id="btnRegist" class="btn btn-primary auth-all btn-cons"><spring:message code='IMS_BM_NM_0027'/></button> --%>
                                            </div>
                                        </div>	                                    
	                                </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END VIEW OPTION AREA -->
                <!-- BEGIN SEARCH LIST AREA -->
                <div id="div_search" class="row">
	                <div class="col-md-12">
	                    <div class="grid simple">
	                        <div class="grid-title no-border">
	                            <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_NM_0028'/></h4>
	                            <div class="tools"><a href="javascript:;" class="collapse"></a></div>
	                        </div>                        
	                        <div class="grid-body no-border" >
	                            <div id="div_searchResult" style="display:none;">	                            
	                                <div class="grid simple ">
	                                    <div class="grid-body ">
	                                        <table class="table" id="tbNoticeMgmtList" style="width:100%">
	                                            <thead>
													<tr>
													    <th>NO</th>
													    <th><spring:message code='IMS_BM_NM_0013'/></th>													    
													    <th><spring:message code='IMS_BM_NM_0015'/></th>
													    <th><spring:message code='IMS_BM_NM_0020'/></th>
													    <th><spring:message code='IMS_BM_NM_0018'/></th>
													    <%-- <th><spring:message code='IMS_BM_NM_0017'/></th> --%>													    
													</tr>
	                                            </thead>
	                                        </table>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                </div>                
	            </div>
                <!-- END SEARCH LIST AREA -->
           </div>   
           <!-- END PAGE --> 
        </div>
        <!-- BEGIN PAGE CONTAINER-->