package egov.linkpay.ims.businessmgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.businessmgmt.service.NewContractMgmtService;
import egov.linkpay.ims.businessmgmt.service.NoticeMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonUtils.DateFormat;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt
 * File Name      : NoticeMgmtController.java
 * Description    : 영업관리 - 가맹점관리 - 공지사항
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/businessMgmt/noticeMgmt")
public class NoticeMgmtController {
    Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="noticeMgmtService")
    private NoticeMgmtService noticeMgmtService;
    
    @Resource(name="newContractMgmtService")
    private NewContractMgmtService newContractMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : noticeMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/noticeMgmt.do")
    public String noticeMgmt(Model model, CommonMap commonMap) throws Exception {
    	
    	String codeCl = "";
    	List< Map< String, String > > listMap = new ArrayList<>();
    	
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("MENU_SUBMENU_SGMNT", CommonConstants.BUSINESSMGMT_MERCHANTMGMT_NOTICE_SEGMNT);
        
        log.info( "공지사항 -1- 공지구분 조회" );
    	codeCl ="0027";
    	listMap = newContractMgmtService.selectCodeCl(codeCl);
    	model.addAttribute("BOARD_TYPE", CommonDDLB.ListOptionSet( DDLBType.DEFAILT, listMap ));
    	model.addAttribute("notiDivision", CommonDDLB.ListOption(listMap ));
    	log.info( "공지사항 -1- 공지대상 조회" );
    	codeCl ="0028";
    	listMap = newContractMgmtService.selectCodeCl(codeCl);
    	model.addAttribute("BOARD_CHANNEL", CommonDDLB.ListOption(listMap ));
    	model.addAttribute("notiLocation", CommonDDLB.BoardList(listMap ));
        
        
        return "/businessMgmt/noticeMgmt/noticeMgmt";
    }
    
    /**--------------------------------------------------
     * Method Name    : selectNoticeMgmtList
     * Description    : 공지사항 리스트 조회
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectNoticeMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectNoticeMgmtList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                objMap.put("frDt", CommonUtils.ConvertDate(DateFormat.YYYYMMDD, "", objMap.get("txtFromDate")));
                objMap.put("toDt",   CommonUtils.ConvertDate(DateFormat.YYYYMMDD, "", objMap.get("txtToDate")));
    
                CommonUtils.initSearchRange(objMap);
                log.info( "selectNoticeMgmtList objMap : " + objMap );
                objList         = noticeMgmtService.selectNoticeMgmtList(objMap);
                intPageTotalCnt = (Integer)noticeMgmtService.selectNoticeMgmtListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.debug("selectNoticeMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectNoticeMgmt
     * Description    : 공지사항 게시물 조회(업데이트를 위한 조회)
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectNoticeMgmt.do", method=RequestMethod.POST)
    public ModelAndView selectNoticeMgmt(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRow = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "selectNoticeMgmt objMap : " + objMap );
                
                objRow = noticeMgmtService.selectNoticeMgmt(objMap);
                
                objMv.addObject("rowData", objRow);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.debug("selectNoticeMgmt.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
      
}