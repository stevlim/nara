package egov.linkpay.ims.calcuMgmt;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.authoritymgmt.service.MenuRoleMgmtService;
import egov.linkpay.ims.authoritymgmt.service.UserAccountMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.AffMgmtService;
import egov.linkpay.ims.calcuMgmt.service.CalcuMgmtService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt
 * File Name      : MenuRoleMgmtController.java
 * Description    : 권한관리 - 메뉴역할관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/depositEtcMgmt/depositEtcMgmt")
public class DepositEtcMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="menuRoleMgmtService")
    private MenuRoleMgmtService menuRoleMgmtService;
    
    @Resource(name="userAccountMgmtService")
    private UserAccountMgmtService userAccountMgmtService;
    
    @Resource(name="affMgmtService")
    private AffMgmtService affMgmtService;
    
    @Resource(name = "calcuMgmtService")
	private CalcuMgmtService calcuMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : menuRoleMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/depositEtcMgmt.do")
    public String menuRoleMgmt(HttpServletRequest request, Model model, CommonMap commonMap) throws Exception {
    	List<Map<String,Object>> objMerchantIDList = userAccountMgmtService.selectMerchantMgmtList();
        List< Map< String, String > > listMap = new ArrayList<>();
        String codeCl = "";
    	
    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("AUTH_TYPE",          CommonDDLB.menuType(DDLBType.EDIT));
        
        
        model.addAttribute("SEARCH_DATE_TYPE",  CommonDDLB.depositReportSearchDateType());
        
        model.addAttribute("CATEGORY_TYPE",  CommonDDLB.depositCategorySearchType());
        
        
        try
	   	{
	        HttpSession session = request.getSession(false);
	    	String merId = "";
		   		merId = session.getAttribute("MER_ID").toString();
	        model.addAttribute("MID", merId);
        
	        codeCl ="0022";
	    	listMap = affMgmtService.selectCodeCl(codeCl);
	        model.addAttribute("PM_CD_TYPE",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
	        //model.addAttribute("CardCompanyList1",          CommonDDLB.ListOption(listMap));
	        
	        
	        codeCl ="0012";
	    	listMap = affMgmtService.selectCodeCl(codeCl);
	        model.addAttribute("MBS_CD_TYPE",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
	        
	   	}
	   	catch(Exception e)
	   	{
	   		logger.error( "depositReport-Exception : ", e );
	   	}
        
        return "/calcuMgmt/calcuCard/depositEtcMgmt";
        //return "/authorityMgmt/menuRoleMgmt/menuRoleMgmt";
    }
    
    /**--------------------------------------------------
     * Method Name    : selectMenuRoleMgmtList
     * Description    : 메뉴 역할 리스트 조회
     * Author         : yangjeongmo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMenuRoleMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectMenuRoleMgmtList(@RequestBody String strJsonParameter) throws Exception {
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
                
                objList = menuRoleMgmtService.selectMenuRoleMgmtList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMenuRoleMgmtList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectMenuRoleMgmtDtl
     * Description    : 메뉴 역할 상세 정보 조회
     * Author         : yangjeongmo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectMenuRoleMgmtDtl.do", method=RequestMethod.POST)
    public ModelAndView selectMenuRoleMgmtDtl(@RequestBody String strJsonParameter) throws Exception {
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
                
                objList = menuRoleMgmtService.selectMenuRoleMgmtDtl(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectMenuRoleMgmtDtl.do exception : " + ex.getMessage());
        }   finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : insertMenuRoleMgmt
     * Description    : 메뉴 역할 등록
     * Author         : yangjeongmo, 2015. 10. 14.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/insertMenuRoleMgmt.do", method=RequestMethod.POST)
    public ModelAndView insertMenuRoleMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
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
                
                menuRoleMgmtService.insertMenuRoleMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = ex.getMessage();
            logger.debug("insertMenuRoleMgmt.do exception : " + ex.getMessage());
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
     * Method Name    : updateMenuRoleMgmt
     * Description    : 메뉴 역할 수정
     * Author         : yangjeongmo, 2015. 10. 14.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/updateMenuRoleMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateMenuRoleMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
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
                
                menuRoleMgmtService.updateMenuRoleMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateMenuRoleMgmt.do exception : " + ex.getMessage());
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
    
    
    @RequestMapping(value="/selectEtcDepositList.do", method=RequestMethod.POST)
    public ModelAndView selectEtcDepositList(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try { 
            objMap = CommonUtils.jsonToMap(strJsonParameter);
            
            CommonUtils.initSearchRange(objMap);
            
            HttpSession session = request.getSession(false);
	    	String merId = "";
	    	String merType = "";
	    	
		   	merId = session.getAttribute("MER_ID").toString();
		   	merType = session.getAttribute("MER_ID_TYPE").toString();

		   	objMap.put("MER_ID", merId);
	    	objMap.put("MER_TYPE", merType);
	    	
            objList         = calcuMgmtService.selectEtcDepositList(objMap);
            intPageTotalCnt = Integer.parseInt(calcuMgmtService.selectEtcDepositListCnt(objMap).toString());
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectUserAccountMgmtList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
}
