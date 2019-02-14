package egov.linkpay.ims.messagemgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.messagemgmt.service.MessageMgmtService;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.messagemgmt
 * File Name      : MessageMgmtController.java
 * Description    : 다국어관리 - 메시지관리
 * Author         : kwjang, 2015. 11. 27.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/messageMgmt/messageMgmt")
public class MessageMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="messageMgmtService")
    private MessageMgmtService messageMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : messageMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/messageMgmt.do")
    public String messageMgmt(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));        
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
 
        return "/messageMgmt/messageMgmt/messageMgmt";
    }
    
    /**--------------------------------------------------
     * Method Name    : selectMessageMgmtList
     * Description    : 메세지 리스트 조회
     * Author         : kwjang, 2015. 11. 27.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMessageMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectMessageMgmtList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int intPageTotalCnt = 0;
        int intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) { 
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                CommonUtils.initSearchRange(objMap);
                
                objList         = messageMgmtService.selectMessageMgmtList(objMap);
                intPageTotalCnt = (Integer)messageMgmtService.selectMessageMgmtListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMessageMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectMessageMgmtInfo
     * Description    : 메세지 조회(업데이트를 위한 조회)
     * Author         : kwjang, 2015. 11. 27.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMessageMgmtInfo.do", method=RequestMethod.POST)
    public ModelAndView selectMessageMgmtInfo(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRow = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objRow = messageMgmtService.selectMessageMgmtInfo(objMap);
                
                objMv.addObject("rowData", objRow);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMessageMgmtInfo.do exception : " + ex.getMessage());
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
     * Method Name    : insertMessageMgmt
     * Description    : 메세지 등록
     * Author         : kwjang, 2015. 11. 27.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/insertMessageMgmt.do", method=RequestMethod.POST)
    public ModelAndView insertMessageMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {            
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",      commonMap.get("USR_ID"));
                objMap.put("WORKER_IP",   commonMap.get("USR_IP"));
                
                messageMgmtService.insertMessageMgmt(objMap);
            } else {                
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = objMap.get("ResultMessage").toString().equals("") ? CommonMessage.MSG_ERR_EXCEPTION : objMap.get("ResultMessage").toString();
            logger.debug("insertMessageMgmt.do exception : " + ex.getMessage());
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
     * Method Name    : updateMessageMgmt
     * Description    : 메세지 수정
     * Author         : kwjang, 2015. 11. 27.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/updateMessageMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateMessageMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {            
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",      commonMap.get("USR_ID"));
                objMap.put("WORKER_IP",   commonMap.get("USR_IP"));
                
                messageMgmtService.updateMessageMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateMessageMgmt.do exception : " + ex.getMessage());
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
     * Method Name    : downLoadLanguage
     * Description    : 언어파일 다운로드
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/    
    @RequestMapping(value="/downLoadLanguage.do", method=RequestMethod.POST)
    @ResponseBody
    public byte[] downLoadArchivesMgmt(HttpServletRequest request, HttpServletResponse response) throws Exception {       
        Map<String, Object> objMap       = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        String strData     = "";
        String strLanguage = "";
        byte[] dataBytes   = new byte[0];        
        
        try {            
            objMap.put("TYPE",     request.getParameter("TYPE"));
            objMap.put("LANGUAGE", request.getParameter("LANGUAGE"));

            objList = messageMgmtService.selectLanguage(objMap);
            
            for(Map<String, Object> objData : objList) {
                strData += (strData == "" ? "" : "\n") + objData.get("MESSAGE_CODE").toString().trim() + "=" + objData.get("MESSAGE").toString().trim();                
            }            
            
            dataBytes = strData.getBytes();
            
            switch(objMap.get("LANGUAGE").toString()) {
                case "KOR" :
                    strLanguage = "ko";
                    break;
                
                case "ENG" :
                    strLanguage = "en";
                    break;
                    
                default :
                    strLanguage = "en";
                    break;
            }

            response.setHeader("Content-Disposition", "attachment; filename=\"message_" + strLanguage + ".properties" + "\"");
            response.setContentLength(dataBytes.length);
            response.setContentType("application/octet-stream");
        } catch(Exception ex) {
            logger.debug("downLoadLanguage.do exception : " + ex.getMessage());
        }
        
        return dataBytes;
    }
}