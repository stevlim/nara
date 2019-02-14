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

import egov.linkpay.ims.businessmgmt.service.FaqMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt
 * File Name      : FaqMgmtController.java
 * Description    : 영업관리 - 가맹점관리 - FAQ
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/businessMgmt/faqMgmt")
public class FaqMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="faqMgmtService")
    private FaqMgmtService faqMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : faqMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/faqMgmt.do")
    public String faqMgmt(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("MENU_SUBMENU_SGMNT", CommonConstants.BUSINESSMGMT_MERCHANTMGMT_FAQ_SEGMNT);
        
        model.addAttribute("division",   CommonDDLB.faqDivision(DDLBType.EDIT));
        model.addAttribute("faqFlag",   CommonDDLB.faqFlag(DDLBType.EDIT));
        model.addAttribute("BOARD_TYPE",   CommonDDLB.faqDivision(DDLBType.SEARCH));
        
        return "/businessMgmt/faqMgmt/faqMgmt";
    }
    
    /**--------------------------------------------------
     * Method Name    : selectFaqMgmtList
     * Description    : FAQ 리스트 조회
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectFaqMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectFaqMgmtList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
               
                CommonUtils.initSearchRange(objMap);
    
                objList         = faqMgmtService.selectFaqMgmtList(objMap);
                for( Map<String, Object> row : objList) {
                	if(row.get("BODY") instanceof java.sql.Clob) {
                		String body = CommonUtils.clobToString((java.sql.Clob)row.get("BODY"));
                		row.put("BODY", body);
                	}
                }
                intPageTotalCnt = (Integer)faqMgmtService.selectFaqMgmtListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectFaqMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectFaqMgmt
     * Description    : FAQ 게시물 조회(업데이트를 위한 조회)
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectFaqMgmt.do", method=RequestMethod.POST)
    public ModelAndView selectFaqMgmt(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRow = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objRow = faqMgmtService.selectFaqMgmt(objMap);
                if(objRow.get("BODY") instanceof java.sql.Clob) {
            		String body = CommonUtils.clobToString((java.sql.Clob)objRow.get("BODY"));
            		objRow.put("BODY", body);
            	}
                objMv.addObject("rowData", objRow);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectFaqMgmt.do exception : " + ex.getMessage());
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
    
    /**--------------------------------------------------
     * Method Name    : insertFaqMgmt
     * Description    : FAQ 등록
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/insertFaqMgmt.do", method=RequestMethod.POST)
    public ModelAndView insertFaqMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {            
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                
                faqMgmtService.insertFaqMgmt(objMap);                
            } else {                
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("insertFaqMgmt.do exception : " + ex.getMessage());
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
    
    /**--------------------------------------------------
     * Method Name    : updateFaqMgmt
     * Description    : FAQ 수정
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/updateFaqMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateFaqMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                
                faqMgmtService.updateFaqMgmt(objMap);
                
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateFaqMgmt.do exception : " + ex.getMessage());
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
