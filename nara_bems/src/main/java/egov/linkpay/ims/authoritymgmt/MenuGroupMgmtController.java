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

import egov.linkpay.ims.authoritymgmt.service.MenuGroupMgmtService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt
 * File Name      : MenuGroupMgmtController.java
 * Description    : 권한관리 - 메뉴그룹관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/authorityMgmt/menuGroupMgmt")
public class MenuGroupMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="menuGroupMgmtService")
    private MenuGroupMgmtService menuGroupMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : menuGroupMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/menuGroupMgmt.do")
    public String menuGroupMgmt(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));
        
        return "/authorityMgmt/menuGroupMgmt/menuGroupMgmt";
    }
   
    /**--------------------------------------------------
     * Method Name    : selectMenuGroupMgmtList
     * Description    : 메뉴 그룹 리스트 조회
     * Author         : yangjeongmo, 2015. 10. 12.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMenuGroupMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectMenuGroupMgmtList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt = 0;
        int    intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                CommonUtils.initSearchRange(objMap);
                
                objList = menuGroupMgmtService.selectMenuGroupMgmtList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMenuGroupMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : updateMenuGroupMgmt
     * Description    : 메뉴 그룹 리스트 수정
     * Author         : yangjeongmo, 2015. 10. 12.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/updateMenuGroupMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateMenuGroupMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        String strResultMessage  = "";
        String strMenuGroupNames = "";
        String strMenuGroupSorts = "";
        String strStatus         = "";
        
        int intResultCode       = 0;
        int intMenuGroupNameCnt = 0;
        int intMenuGroupSortCnt = 0;
        int intStatusCnt        = 0;
        
        ModelAndView objMv = new ModelAndView();
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.queryStringToMap(URLDecoder.decode(strJsonParameter, "UTF-8"));
                
                if(objMap == null || objMap.size() < 0){
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }
                
                strMenuGroupNames = objMap.get("menugroupnames").toString();
                strMenuGroupSorts = objMap.get("menugroupsorts").toString();
                strStatus         = objMap.get("stauts").toString();
                
                if(CommonUtils.isNullorEmpty(strMenuGroupNames) || CommonUtils.isNullorEmpty(strMenuGroupSorts) || CommonUtils.isNullorEmpty(strStatus)){
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }
                
                intMenuGroupNameCnt = strMenuGroupNames.split(",").length;
                intMenuGroupSortCnt = strMenuGroupSorts.split(",").length;
                intStatusCnt = strStatus.split(",").length;
                
                if(intMenuGroupNameCnt != intMenuGroupSortCnt || intMenuGroupNameCnt != intStatusCnt){
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }
                
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                objMap.put("WORKER_IP", commonMap.get("USR_IP"));
                
                menuGroupMgmtService.updateMenuGroupMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateMenuGroupMgmt.do exception : " + ex.getMessage());
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
     * Method Name    : deleteMenuGroupMgmt
     * Description    : 메뉴 그룹 삭제
     * Author         : yangjeongmo, 2015. 10. 12.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/deleteMenuGroupMgmt.do", method=RequestMethod.POST)
    public ModelAndView deleteMenuGroupMgmt(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView objMv = new ModelAndView();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.queryStringToMap(strJsonParameter);
                
                if(objMap == null || objMap.size() < 0){
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }
                
                menuGroupMgmtService.deleteMenuGroupMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("deleteMenuGroupMgmt.do exception : " + ex.getMessage());
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
     * Method Name    : insertMenuMgmt
     * Description    : 메뉴 등록
     * Author         : yangjeongmo, 2015. 10. 13.
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
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
                    return objMv;
                }

                objMap.put("WORKER",    commonMap.get("USR_ID"));
                objMap.put("WORKER_IP", commonMap.get("USR_IP"));
                
                menuGroupMgmtService.insertMenuMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("insertMenuMgmt.do exception : " + ex.getMessage());
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
