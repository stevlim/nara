package egov.linkpay.ims.authoritymgmt;

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

import com.google.gson.JsonParser;

import egov.linkpay.ims.authoritymgmt.service.UserAccountMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.AffMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt
 * File Name      : UserAccountMgmtController.java
 * Description    : 권한관리 - 사용자관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/businessMgmt/userAccountMgmt")
public class UserAccountMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="userAccountMgmtService")
    private UserAccountMgmtService userAccountMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : userAccountMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/userAccountMgmt.do")
    public String userAccountMgmt(Model model, CommonMap commonMap, HttpServletRequest request) throws Exception {
        List<Map<String,Object>> objMerchantIDList = userAccountMgmtService.selectMerchantMgmtList();
               
        model.addAttribute("MENU",                 commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",              commonMap.get("MENU_NO"));
        model.addAttribute("MASTER_CD",              commonMap.get("MASTER_CD"));
        model.addAttribute("MENU_TITLE",           CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE",   CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",              commonMap.get("AUTH_CD"));
        model.addAttribute("USR_ACCT_STATUS_TYPE", CommonDDLB.userAcctStatusType(DDLBType.SEARCH));
        //model.addAttribute("USR_TYPE",             CommonDDLB.menuType(DDLBType.EDIT));
        model.addAttribute("MERCHANT_ID",          CommonDDLB.menuMerchantID(objMerchantIDList));
        //model.addAttribute("USR_TYPE_FOR_SEARCH",  CommonDDLB.menuType(DDLBType.SEARCH));
        
     
    	HttpSession session = request.getSession(false);
    	String merid = "";
    	merid = session.getAttribute("MER_ID").toString();
    	model.addAttribute("MID", merid);
 
        
        return "/businessMgmt/userAccountMgmt/userAccountMgmt";
    }
    

    /**--------------------------------------------------
     * Method Name    : selectAuthTypeList
     * Description    : 메뉴 역할 리스트 조회
     * Author         : yangjeongmo, 2015. 10. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectAuthTypeList.do", method=RequestMethod.POST)
    public ModelAndView selectAuthTypeList(@RequestBody String strJsonParameter) throws Exception {
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
                
                objList = userAccountMgmtService.selectMenuAuthList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectAuthTypeList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectUserAccountMgmtList
     * Description    : 이용자 리스트 조회
     * Author         : yangjeongmo, 2015. 10. 15.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectUserAccountMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectUserAccountMgmtList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try { 
            objMap = CommonUtils.jsonToMap(strJsonParameter);
            
            CommonUtils.initSearchRange(objMap);
            
            objList         = userAccountMgmtService.selectUserAccountMgmtList(objMap);
            intPageTotalCnt = Integer.parseInt(userAccountMgmtService.selectUserAccountMgmtListCnt(objMap).toString());
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
    
    /**--------------------------------------------------
     * Method Name    : selectUserID
     * Description    : 아이디 조회 - 중복 아이디 확인
     * Author         : yangjeongmo, 2015. 10. 15.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectUserID.do", method=RequestMethod.POST)
    public ModelAndView selectUserID(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv   = new ModelAndView();
        Map<String, Object> objMap  = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                CommonUtils.initSearchRange(objMap);
                
                intResultCode = Integer.parseInt(userAccountMgmtService.selectUserID(objMap).toString());
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectUserID.do exception : " + ex.getMessage());
        }  finally {
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
     * Method Name    : insertUserAccountMgmt
     * Description    : 이용자 등록
     * Author         : yangjeongmo, 2015. 10. 15.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/insertUserAccountMgmt.do", method=RequestMethod.POST)
    public ModelAndView insertUserAccountMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                // pswd validation
                if(!CommonUtils.pswdValidation(objMap.get("PSWD").toString())){
                	intResultCode = 1;
                	strResultMessage = CommonMessage.MSG_ERR_PSWD_VALID;
                } else {
                	objMap.put("PSWD",      CommonUtils.encryptSHA512HashKey(objMap.get("PSWD").toString()));
                    objMap.put("WORKER",    commonMap.get("USR_ID"));
                    objMap.put("WORKER_IP", commonMap.get("USR_IP"));
                    
                    userAccountMgmtService.insertUserAccountMgmt(objMap);
                }
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("insertUserAccountMgmt.do exception : " + ex.getMessage());
        }  finally {
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
     * Method Name    : updateUserPSWD
     * Description    : 이용자 비밀번호 초기화
     * Author         : yangjeongmo, 2015. 11. 19.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/updateUserPSWD.do", method=RequestMethod.POST)
    public ModelAndView updateUserPSWD(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        String rndPwd = CommonUtils.GetRndPwd();
        
        try {
            objMap = CommonUtils.jsonToMap(strJsonParameter);
            
            objMap.put("USR_ID",     objMap.get("USR_ID"));
            objMap.put("USRNEWPSWD", CommonUtils.encryptSHA512HashKey(rndPwd));   
            objMap.put("DE_PSWD",   rndPwd);
            objMap.put("EMAIL",   objMap.get("EMAIL"));
            
            
            
            userAccountMgmtService.updateUserPSWD(objMap);
            
            objMap.put("CONTENT",   objMap.get("USR_ID").toString() + "|" +objMap.get("DE_PSWD").toString());
            userAccountMgmtService.insertPwInitSendMail(objMap);
            
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateUserPSWD.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
                objMv.addObject("objMap", objMap);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectUserAccountDtl
     * Description    : 이용자 상세 정보 조회
     * Author         : yangjeongmo, 2015. 10. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectUserAccountDtl.do", method=RequestMethod.POST)
    public ModelAndView selectUserAccountDtl(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        int    intMerchantCount = 0;
        
        String strResultMessage = "";
        String strIMIDs         = "";
        String strMERNMs        = "";
        
        String strArrIMIDs[];
        String strArrMERNMs[];
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                CommonUtils.initSearchRange(objMap);
                
                objMap.put("DTL_USR_ID", objMap.get("USR_ID"));
                //objMap.put("USR_TYPE", objMap.get("USR_TYPE"));
                objMap.put("STATUS", objMap.get("USR_STATUS"));
                
                objList          = userAccountMgmtService.selectUserAccountMgmtList(objMap);
                intMerchantCount = Integer.parseInt(userAccountMgmtService.selectUserIMIDsCount(objMap).toString());
                
                if(intMerchantCount > 0){
                    strIMIDs     = userAccountMgmtService.selectUserIMIDs(objMap).toString();
                    strMERNMs    = userAccountMgmtService.selectUserMERNMs(objMap).toString();
                    strArrIMIDs  = strIMIDs.split("=");
                    strArrMERNMs = strMERNMs.split("=");
                    strIMIDs     = strArrIMIDs[1].substring(0, strArrIMIDs[1].length()-1);
                    
                    strMERNMs    = strArrMERNMs[1].substring(0, strArrMERNMs[1].length()-1);
                }
                
                objMv.addObject("IMIDs", strIMIDs);
                objMv.addObject("MERNMs", strMERNMs);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectUserAccountDtl.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : updateUserAccountMgmt
     * Description    : 이용자 정보 수정
     * Author         : yangjeongmo, 2015. 10. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/updateUserAccountMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateUserAccountMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                objMap.put("PSWD",      CommonUtils.encryptSHA512HashKey(objMap.get("PSWD").toString()));
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                objMap.put("WORKER_IP", commonMap.get("USR_IP"));
                
                userAccountMgmtService.updateUserAccountMgmt(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateUserAccountMgmt.do exception : " + ex.getMessage());
        }  finally {
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
