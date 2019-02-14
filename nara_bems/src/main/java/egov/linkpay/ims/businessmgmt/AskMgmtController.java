package egov.linkpay.ims.businessmgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.businessmgmt.service.AskMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.crypt_src.common.CryptUtils;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt
 * File Name      : FaqMgmtController.java
 * Description    : 영업관리 - 가맹점관리 - FAQ
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/businessMgmt/qnaMgmt")
public class AskMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="QnaMgmtService")
    private AskMgmtService qnaMgmtService;
    
    @Autowired
    private CryptUtils cryptUtils;
    /**--------------------------------------------------
     * Method Name    : faqMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/qnaMgmt.do")
    public String faqMgmt(Model model, CommonMap commonMap, HttpSession session) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("MENU_SUBMENU_SGMNT", CommonConstants.BUSINESSMGMT_MERCHANTMGMT_FAQ_SEGMNT);
        
        model.addAttribute("division",   CommonDDLB.faqDivision(DDLBType.EDIT));
        model.addAttribute("faqFlag",   CommonDDLB.faqFlag(DDLBType.EDIT));
        model.addAttribute("BOARD_TYPE",   CommonDDLB.faqDivision(DDLBType.SEARCH));
        model.addAttribute("MID", session.getAttribute("MER_ID").toString());
        
        return "/businessMgmt/qnaMgmt/qnaMgmt";
    }
    
    /**--------------------------------------------------
     * Method Name    : selectFaqMgmtList
     * Description    : QNA 리스트 조회
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectQnaMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectFaqMgmtList(@RequestBody String strJsonParameter, HttpSession session) throws Exception {
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
                objMap.put("MID", session.getAttribute("MER_ID").toString());
                objList = qnaMgmtService.selectQnaMgmtList(objMap);
                
                for( Map<String, Object> row : objList) {
                	if(row.get("BODY") instanceof java.sql.Clob) {
                		String body = CommonUtils.clobToString((java.sql.Clob)row.get("BODY"));
                		row.put("BODY", body);
                	}
                }
                
                
                intPageTotalCnt = (Integer)qnaMgmtService.selectQnaMgmtListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectQnaMgmtList.do exception : " + ex.getMessage());
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
    @RequestMapping(value="/selectQnaMgmt.do", method=RequestMethod.POST)
    public ModelAndView selectFaqMgmt(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRow = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objRow = qnaMgmtService.selectQnaMgmt(objMap);
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
            logger.debug("selectQnaMgmt.do exception : " + ex.getMessage());
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
     * Method Name    : insertQnaMgmt
     * Description    : QNA 등록
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/insertQnaMgmt.do", method=RequestMethod.POST)
    public ModelAndView insertFaqMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {            
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                
                //마스킹                
                objMap.put("USR_EMAIL",   CommonUtils.getMaskedStr(objMap.get("USR_EMAIL").toString(), "email") );
                objMap.put("USR_TEL",   CommonUtils.getMaskedStr(objMap.get("USR_TEL").toString(), "phone") );                
                                
                objMap.put("USR_EMAIL_ENC",   cryptUtils.encrypt( objMap.get("USR_EMAIL").toString() ) );
                objMap.put("USR_TEL_ENC",   cryptUtils.encrypt( objMap.get("USR_TEL").toString() ) );                
                
                qnaMgmtService.insertQnaMgmt(objMap);                
            } else {                
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
        logger.debug("insertQnaMgmt.do exception : " + ex.getMessage());
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
     * Method Name    : updateQnaMgmt
     * Description    : FAQ 수정
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/updateQnaMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateFaqMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                //마스킹                
                objMap.put("USR_EMAIL",   CommonUtils.getMaskedStr(objMap.get("USR_EMAIL").toString(), "email") );
                objMap.put("USR_TEL",   CommonUtils.getMaskedStr(objMap.get("USR_TEL").toString(), "phone") );                
                                
                objMap.put("USR_EMAIL_ENC",   cryptUtils.encrypt( objMap.get("USR_EMAIL").toString() ) );
                objMap.put("USR_TEL_ENC",   cryptUtils.encrypt( objMap.get("USR_TEL").toString() ) );
                
                qnaMgmtService.updateQnaMgmt(objMap);
                
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateQnaMgmt.do exception : " + ex.getMessage());
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
