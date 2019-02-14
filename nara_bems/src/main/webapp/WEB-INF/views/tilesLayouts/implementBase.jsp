<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">
$(document).ready(function(){    
    fnInitEvent();    
});

function fnInitEvent() {
}
</script>

        <!-- BEGIN PAGE CONTAINER-->
        <div class="page-content">         
            <div class="content">
                <div class="clearfix"></div>
            <!-- BEGIN PAGE TITLE -->
            <ul class="breadcrumb">
                <li><p>YOU ARE HERE</p></li>
                <li><a href="javascript:;" class="active"><c:out value="${MENU_TITLE }" /></a></li>                
            </ul>
            <div class="page-title"> <i class="icon-custom-left"></i>
                <h3><span class="semi-bold"><c:out value="${MENU_SUBMENU_TITLE }" /></span></h3>
            </div>
            <!-- END PAGE TITLE -->
                <!-- BEGIN PAGE FORM -->
                <div id="div_frm" class="row" style="display:none;">
                    <!-- 등록/수정에 따라 화면 구성 -->
                </div>                
                <!-- END PAGE FORM -->
                <!-- BEGIN VIEW OPTION AREA -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="grid simple">
                            <div class="grid-title no-border">
                                <h4><i class="fa fa-th-large"></i> <spring:message code='IMS_BM_NM_0019'/></h4>
                                <div class="tools"><a href="javascript:;" class="collapse"></a></div>
                            </div>
                            <div class="grid-body no-border">
                                <form id="frmSearch" name="frmsearch">
                                    <!-- 검색 조건에 따라 화면 구성 -->
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
                                                        <!-- 출력 필드에 따라 <th>번호</th> 작성 -->                                                        
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
    </div>
    <!-- END CONTAINER -->