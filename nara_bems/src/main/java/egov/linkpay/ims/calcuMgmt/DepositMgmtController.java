package egov.linkpay.ims.calcuMgmt;

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
import org.springframework.web.servlet.View;

import com.google.gson.JsonParser;

import egov.linkpay.ims.authoritymgmt.service.UserAccountMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.AffMgmtService;
import egov.linkpay.ims.calcuMgmt.service.CalcuMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.paymentMgmt.PayListExcelGenerator;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt
 * File Name      : UserAccountMgmtController.java
 * Description    : 권한관리 - 사용자관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/depositMgmt/depositReport")
public class DepositMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="userAccountMgmtService")
    private UserAccountMgmtService userAccountMgmtService;
    
    @Resource(name="affMgmtService")
    private AffMgmtService affMgmtService;
    
    @Resource(name = "calcuMgmtService")
	private CalcuMgmtService calcuMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : userAccountMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/depositReport.do")
    public String depositReport(HttpServletRequest request, Model model, CommonMap commonMap) throws Exception {
        List<Map<String,Object>> objMerchantIDList = userAccountMgmtService.selectMerchantMgmtList();
        List< Map< String, String > > listMap = new ArrayList<>();
        String codeCl = "";
        
        model.addAttribute("MENU",                 commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",              commonMap.get("MENU_NO"));
        
        //model.addAttribute("MENU_TITLE",           CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_TITLE",           CommonMessageDic.getMessage("IMS_MENU_SUB_0058"));
        
        model.addAttribute("MENU_SUBMENU_TITLE",   CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",              commonMap.get("AUTH_CD"));
        model.addAttribute("USR_ACCT_STATUS_TYPE", CommonDDLB.userAcctStatusType(DDLBType.SEARCH));
        model.addAttribute("USR_TYPE",             CommonDDLB.menuType(DDLBType.EDIT));
        model.addAttribute("MERCHANT_ID",          CommonDDLB.menuMerchantID(objMerchantIDList));
        model.addAttribute("USR_TYPE_FOR_SEARCH",  CommonDDLB.menuType(DDLBType.SEARCH));
        
        model.addAttribute("SEARCH_DATE_TYPE",  CommonDDLB.depositReportSearchDateType());
        
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
        
        return "/calcuMgmt/calcuCard/depositReport";
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
    public ModelAndView selectUserAccountMgmtList(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception {
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
	        //model.addAttribute("MID", merId);
            
            objList         = calcuMgmtService.selectUserAccountMgmtList(objMap);
            intPageTotalCnt = Integer.parseInt(calcuMgmtService.selectUserAccountMgmtListCnt(objMap).toString());
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
    
    @RequestMapping(value="/selectUserAccountMgmtListExcel.do", method=RequestMethod.POST)
    public View selectUserAccountMgmtListExcel(HttpServletRequest request, @RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        List<Map<String,Object>> objExcelTotalData = new ArrayList<Map<String, Object>>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            
            CommonUtils.initSearchRange(objMap);
            
            HttpSession session = request.getSession(false);
	    	String merId = "";
	    	String merType = "";
	    	
	    	merId = session.getAttribute("MER_ID").toString();
	    	merType = session.getAttribute("MER_ID_TYPE").toString();
	    	
	    	objMap.put("MER_ID", merId);
	    	objMap.put("MER_TYPE", merType);
	        //model.addAttribute("MID", merId);
            
	    	objExcelTotalData         = calcuMgmtService.selectDepositSum(objMap);
	    	objExcelData         = calcuMgmtService.selectUserAccountMgmtList(objMap);
            //intPageTotalCnt = Integer.parseInt(calcuMgmtService.selectUserAccountMgmtListCnt(objMap).toString());
        } catch(Exception ex) {
        	objExcelMap  = null;
            objExcelData = null;
            logger.error("selectCardTransInfoList.do exception : " , ex);
        }  finally {
        	objExcelMap.put("excelName", "deposit_report");
        	objExcelMap.put("excelTotalData", objExcelTotalData);
        	objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new DepositReportExcelGenerator();
    }
    
    @RequestMapping(value="/selectDepositSum.do", method=RequestMethod.POST)
    public ModelAndView selectDepositSum(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception {
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
	    	
            objList         = calcuMgmtService.selectDepositSum(objMap);
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
    
    @RequestMapping(value="/selectTidDetail.do", method=RequestMethod.POST)
    public ModelAndView selectTidDetail(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try { 
            objMap = CommonUtils.jsonToMap(strJsonParameter);
            
            CommonUtils.initSearchRange(objMap);
            
            objList         = calcuMgmtService.selectTidDetail(objMap);
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectTidDetail.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
        
    }
    
    
    
    
    
    
    @RequestMapping(value="/selectUserAccountMgmtListDetail.do", method=RequestMethod.POST)
    public ModelAndView selectUserAccountMgmtListDetail(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception {
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
	    	
            objList         = calcuMgmtService.selectUserAccountMgmtListDetail(objMap);
            intPageTotalCnt = Integer.parseInt(calcuMgmtService.selectUserAccountMgmtListCntDetail(objMap).toString());
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectUserAccountMgmtListDetail.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    @RequestMapping(value="/selectUserAccountMgmtListDetailExcel.do", method=RequestMethod.POST)
    public View selectUserAccountMgmtListDetailExcel(HttpServletRequest request, @RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            
            CommonUtils.initSearchRange(objMap);
            
            HttpSession session = request.getSession(false);
	    	String merId = "";
	    	String merType = "";
	    	
		   	merId = session.getAttribute("MER_ID").toString();
		   	merType = session.getAttribute("MER_ID_TYPE").toString();

		   	objMap.put("MER_ID", merId);
	    	objMap.put("MER_TYPE", merType);
	    	
	    	objExcelData         = calcuMgmtService.selectUserAccountMgmtListDetail(objMap);
            //intPageTotalCnt = Integer.parseInt(calcuMgmtService.selectUserAccountMgmtListCntDetail(objMap).toString());
        } catch(Exception ex) {
        	objExcelMap  = null;
            objExcelData = null;
            logger.error("selectCardTransInfoList.do exception : " , ex);
        }  finally {
        	objExcelMap.put("excelName", "deposit_detail_report");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new DepositDetailReportExcelGenerator();
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
