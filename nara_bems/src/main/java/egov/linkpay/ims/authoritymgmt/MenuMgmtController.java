package egov.linkpay.ims.authoritymgmt;

import java.net.URLDecoder;
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

import egov.linkpay.ims.authoritymgmt.service.MenuMgmtService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt
 * File Name      : MenuMgmtController.java
 * Description    : 권한관리 - 메뉴관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/authorityMgmt/menuMgmt")
public class MenuMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="menuMgmtService")
    private MenuMgmtService menuMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : menuMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/menuMgmt.do")
    public String menuMgmt(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_TYPE",          CommonDDLB.menuType(DDLBType.EDIT));
        
        return "/authorityMgmt/menuMgmt/menuMgmt";
    }
    
    /**--------------------------------------------------
     * Method Name    : selectMenuGroupList
     * Description    : 메뉴 그룹 리스트 조회
     * Author         : yangjeongmo, 2015. 10. 14.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMenuGroupList.do", method=RequestMethod.POST)
    public ModelAndView selectMenuGroupList(@RequestBody String strJsonParameter) throws Exception {
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
                
                objList = menuMgmtService.selectMenuGroupList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMenuGroupList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectMenuMgmtList
     * Description    : 메뉴 리스트 조회
     * Author         : yangjeongmo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMenuMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectMenuMgmtList(@RequestBody String strJsonParameter) throws Exception {
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
                
                objList = menuMgmtService.selectMenuMgmtList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMenuMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : updateMenuList
     * Description    : 메뉴 리스트 수정
     * Author         : yangjeongmo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/updateMenuList.do", method=RequestMethod.POST)
    public ModelAndView updateMenuList(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        String strResultMessage = "";
        String strMenuNos       = "";
        String strMenuSorts     = "";
        String strStatuss       = "";
        
        int intResultCode  = 0;
        int intMenuNoCnt   = 0;
        int intMenuSortCnt = 0;
        int intStatusCnt   = 0;
        
        ModelAndView objMv = new ModelAndView();
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.queryStringToMap(URLDecoder.decode(strJsonParameter, "UTF-8"));
                
                if(objMap == null || objMap.size() < 0){
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }
                
                strMenuNos   = objMap.get("menunos").toString();
                strMenuSorts = objMap.get("menusorts").toString();
                strStatuss  = objMap.get("status").toString();
                
                if(CommonUtils.isNullorEmpty(strMenuNos) || CommonUtils.isNullorEmpty(strMenuSorts) || CommonUtils.isNullorEmpty(strStatuss)){
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }
                
                intMenuNoCnt   = strMenuNos.split(",").length;
                intMenuSortCnt = strMenuSorts.split(",").length;
                intStatusCnt   = strStatuss.split(",").length;
                
                if(intMenuNoCnt != intMenuSortCnt || intMenuNoCnt != intStatusCnt){
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }
                
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                objMap.put("WORKER_IP", commonMap.get("USR_IP"));
                
                menuMgmtService.updateMenuList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateMenuList.do exception : " + ex.getMessage());
        } finally{
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
            
            objMv.setViewName("jsonView");
        }
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : insertMenuMgmt
     * Description    : 메뉴 등록
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/insertMenuMgmt.do", method=RequestMethod.POST)
    public ModelAndView insertMenuMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView objMv = new ModelAndView();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.queryStringToMap(URLDecoder.decode(strJsonParameter, "UTF-8"));
                
                if(objMap == null || objMap.size() < 0){
                    objMv = CommonUtils.resultFail(objMv, "System Error.");
                    return objMv;
                }

                objMap.put("WORKER",    commonMap.get("USR_ID"));
                objMap.put("WORKER_IP", commonMap.get("USR_IP"));
                
                menuMgmtService.insertMenuMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("insertMenuMgmt.do exception : " + ex.getMessage());
        } finally{
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
     * Method Name    : selectMenuInfo
     * Description    : 메뉴 상세 정보
     * Author         : yangjeongmo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMenuInfo.do", method=RequestMethod.POST)
    public ModelAndView selectMenuInfo(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt = 0;
        int    intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.queryStringToMap(strJsonParameter);
                
                CommonUtils.initSearchRange(objMap);
                
                objList = menuMgmtService.selectMenuMgmtList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMenuInfo.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : updateMenuMgmt
     * Description    : 메뉴 수정
     * Author         : yangjeongmo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/updateMenuMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateMenuMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView objMv = new ModelAndView();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.queryStringToMap(URLDecoder.decode(strJsonParameter, "UTF-8"));
                
                if(objMap == null || objMap.size() < 0){
                    objMv = CommonUtils.resultFail(objMv, "System Error.");
                    return objMv;
                }

                objMap.put("WORKER",    commonMap.get("USR_ID"));
                objMap.put("WORKER_IP", commonMap.get("USR_IP"));
                
                menuMgmtService.updateMenuMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateMenuMgmt.do exception : " + ex.getMessage());
        } finally{
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
     * Method Name    : deleteMenuMgmt
     * Description    : 메뉴 삭제
     * Author         : yangjeongmo, 2015. 10. 12.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/deleteMenuMgmt.do", method=RequestMethod.POST)
    public ModelAndView deleteMenuMgmt(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView objMv = new ModelAndView();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.queryStringToMap(strJsonParameter);
                
                if(objMap == null || objMap.size() < 0){
                    objMv = CommonUtils.resultFail(objMv, "System Error.");
                    return objMv;
                }
                
                menuMgmtService.deleteMenuMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("deleteMenuMgmt.do exception : " + ex.getMessage());
        } finally{
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
