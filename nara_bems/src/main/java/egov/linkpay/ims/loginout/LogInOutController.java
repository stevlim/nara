package egov.linkpay.ims.loginout;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonArray;

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDAO;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.loginout.service.LogInOutService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.loginout
 * File Name      : LogInOutController.java
 * Description    : LogIn/Out Controller
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="")
public class LogInOutController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="logInOutService")
    private LogInOutService logInOutService;

    @Resource(name="commonDAO")
    private CommonDAO commonDAO;
    
    @RequestMapping(value="/")
    public String Index(Model model, HttpSession session) throws UnsupportedEncodingException, NoSuchAlgorithmException, GeneralSecurityException {        
    	return "redirect:/logIn.do";     
    }
    
    /**--------------------------------------------------
     * Method Name    : logIn
     * Description    : View LogIn Page 
     * Author         : ymjo, 2015. 10. 5.
     * Modify History : Just Created.
     ----------------------------------------------------
     * @throws GeneralSecurityException 
     * @throws NoSuchAlgorithmException */     
    @RequestMapping(value="/logIn.do")
    public String logIn(Model model, HttpSession session) throws UnsupportedEncodingException, NoSuchAlgorithmException, GeneralSecurityException {        
    	if (session.getAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY) != null) {
            return "redirect:/home/dashboard/dashboard.do";
        } else {
            return "/logInOut/logIn";
        }     
    }
    
    /**--------------------------------------------------
     * Method Name    : logInIMSNotice
     * Description    : 공지사항 조회
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/logInIMSNotice.do", method=RequestMethod.POST)
    public ModelAndView logInIMSNotice() throws Exception {
        ModelAndView        objMv  = new ModelAndView();        
        Map<String, Object> objRow = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {            
            objRow = logInOutService.selectIMSNotice();
            objMv.addObject("rowData", objRow);            
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = ex.getMessage();
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
     * Method Name    : loginProc
     * Description    : LogIn Process
     * Author         : ymjo, 2015. 10. 5.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/logInProc.do", method=RequestMethod.POST)
    public ModelAndView loginProc(@RequestBody String strJsonParameter, HttpSession session, HttpServletRequest request) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRet = new HashMap<String, Object>();        
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        String ipAddress		= "";
        
        try {
            objMap.put("ResultMessage", "");
            
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                objMap.put("PSWD", CommonUtils.encryptSHA512HashKey(objMap.get("PSWD").toString()));
                
                ipAddress = request.getHeader("X-FORWARDED-FOR");
        		if (ipAddress == null) {
        			ipAddress = request.getRemoteAddr();
        		}
        		
        		objMap.put("WORKER_IP", ipAddress);
        		
                objRet = logInOutService.selectAdminInfo2(objMap, session);
                    
                session.setAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY, objRet);
                //메뉴 그룹 리스트 생성
                List<Map<String,Object>> objMerchantIDList = new ArrayList<Map<String,Object>>();
                /*List<Map<String,Object>> objMerchantIDGrpList = commonDAO.selectAuthUserMenuGrpList(objRet);
                List<Map<String,Object>> objMerchantIDItemList = commonDAO.selectAuthUserMenuList(objRet);
                
                for (Map<String, Object> map : objMerchantIDGrpList) {
                	objMerchantIDList.add(map);
                	for (Map<String, Object> map2 : objMerchantIDItemList) {
                		int menuNoItem = Integer.parseInt((String) map2.get("MENU_NO"));
                		int menuGrpNoItem = Integer.parseInt((String) map2.get("MENU_GRP_NO"));
                		int menuGrpNoGrp = Integer.parseInt((String) map.get("MENU_GRP_NO"));
                		int parentMenuGrpNoItem = Integer.parseInt((String) map2.get("PARENT_MENU_NO"));
                		
                		if(menuGrpNoItem==menuGrpNoGrp) {
                			if(parentMenuGrpNoItem==0){
								objMerchantIDList.add(map2);
								subMenuList(3, menuGrpNoItem, menuNoItem, objMerchantIDItemList, objMerchantIDList);
							}
						}
					}
				}*/
                
                session.setAttribute(CommonConstants.IMS_SESSION_MENU_KEY, objMerchantIDList);
                /*String menuJson = CommonUtils.listmap_to_json_string(objMerchantIDList);
                session.setAttribute("menuList", menuJson);*/
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = objMap.get("ResultMessage").toString().equals("") ? CommonMessage.MSG_ERR_EXCEPTION : objMap.get("ResultMessage").toString();
            
            logger.debug("loginProc.do exception : " + ex.getMessage());
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
    
    private List<Map<String,Object>> subMenuList(int depth, int grpNo, int menuNo, List<Map<String,Object>> itemList, List<Map<String,Object>> resultList){
    	for (Map<String, Object> map : itemList) {
			if(grpNo == Integer.parseInt((String) map.get("MENU_GRP_NO")) && menuNo == Integer.parseInt((String) map.get("PARENT_MENU_NO"))){
				map.put("DEPTH", depth);
				resultList.add(map);
				subMenuList(depth+1, Integer.parseInt((String) map.get("MENU_GRP_NO")), Integer.parseInt((String) map.get("MENU_NO")), itemList, resultList);
			}
		}
    	
    	return resultList;
    }
    
    /**--------------------------------------------------
     * Method Name    : logOut
     * Description    : LogOut Process 
     * Author         : ymjo, 2015. 10. 5.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/logOut.do")
    public String logOut(Model model, HttpSession session, HttpServletRequest request) {
        
    	logger.info("logOut.do start.");
    	
    	Map<String, Object> objMap = new HashMap<String, Object>();
    	objMap.put("USR_ID", session.getAttribute("USR_ID"));
    	String ipAddress = request.getHeader("X-FORWARDED-FOR");
		if (ipAddress == null) {
			ipAddress = request.getRemoteAddr();
		}
		objMap.put("USR_ID", session.getAttribute("USR_ID"));
		objMap.put("WORKER_IP", ipAddress);
		
		logger.info("logOut.do session delete start.");
		
    	session.removeAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY);
        session.removeAttribute(CommonConstants.IMS_SESSION_MENU_KEY);
        session.removeAttribute(CommonConstants.IMS_SESSION_PREV_PAGE_KEY);
        
        logger.info("logOut.do session delete end.");
        
        try {
        	logger.info("logOut.do insertLogoutLog start.");
			logInOutService.insertLogoutLog(objMap);
			logger.info("logOut.do insertLogoutLog end.");
		} catch (Exception e) {
			logger.debug("logOut.do exception : " + e.getMessage());
		}
        
        return "redirect:/logIn.do";
    }
    
    /**--------------------------------------------------
     * Method Name    : logInPasswordChangeProc
     * Description    : 비밀번호 변경
     * Author         : ymjo, 2015. 10. 15.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/logInPasswordChangeProc.do", method=RequestMethod.POST)
    public ModelAndView logInPasswordChangeProc(@RequestBody String strJsonParameter, HttpSession session) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRet = new HashMap<String, Object>();
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                objMap.put("USR_ID", CommonUtils.getSessionInfo(session, "USR_ID"));
                objMap.put("PSWD",   CommonUtils.encryptSHA512HashKey(objMap.get("CURPSWD").toString()));
                
                objRet = logInOutService.selectAdminInfo(objMap);

                if (objRet != null) {    
                	if(!CommonUtils.pswdValidation(objMap.get("NEWPSWD").toString())){
                		objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_PSWD_VALID);
                    } else {
                    	objMap.put("NEWPSWD", CommonUtils.encryptSHA512HashKey(objMap.get("NEWPSWD").toString()));
                        
                        logInOutService.updateAdminPSWD(objMap);
                        
                        objMv = CommonUtils.resultSuccess(objMv);
                    }
                } else {
                    objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_CURPSWD_WRONG);
                }
            } else {
                objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY);
            }
        } catch(Exception ex) {
            objMv = CommonUtils.resultFail(objMv, ex.getMessage());
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : /logInChangPasswordBeforeProc
     * Description    : 비밀번호 변경(로그인 전)
     * Author         : jjho, 2065. 12. 08.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    ///logInChangPasswordBeforeProc.do
    @RequestMapping(value="/logInChangePasswordBeforeProc.do", method=RequestMethod.POST)
    public ModelAndView logInChangePasswordBeforeProc(@RequestBody String strJsonParameter, HttpSession session) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRet = new HashMap<String, Object>();
        boolean objMerIdCheck = false;
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                objMap.put("PSWD",   CommonUtils.encryptSHA512HashKey(objMap.get("CURPSWD").toString()));
                
                objRet = logInOutService.selectAdminInfo(objMap);
                
                if (objRet != null) {
                	String chkTelNo = " ";
                	String chkNewPw = "";
                	
                	chkTelNo = objRet.get("TEL_NO").toString();
                	chkNewPw = objMap.get("NEWPSWD").toString();
                	
                	if(chkNewPw.indexOf(chkTelNo) != -1) {
                		objMv = CommonUtils.resultFail(objMv, "새 비밀번호에 연락처가 포함되어 있습니다.");
                		objMv.setViewName("jsonView");
                		return objMv;
                	}
                	
                	objMerIdCheck = logInOutService.selectMerchantInfo(objMap);
            		
            		if(objMerIdCheck) {
            			objMap.put("NEWPSWD",   CommonUtils.encryptSHA512HashKey(objMap.get("NEWPSWD").toString()));
                		logInOutService.updateAdminPSWD(objMap);
                		objMv = CommonUtils.resultSuccess(objMv);
            		}else {
            			objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_MID_EXIST);
            		}
            		
                	/*if(!CommonUtils.pswdValidation(objMap.get("NEWPSWD").toString())){
                		objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_PSWD_VALID);
                	} else {
                		objMerIdCheck = logInOutService.selectMerchantInfo(objMap);
                		
                		if(objMerIdCheck) {
                			objMap.put("NEWPSWD",   CommonUtils.encryptSHA512HashKey(objMap.get("NEWPSWD").toString()));
                    		logInOutService.updateAdminPSWD(objMap);
                    		objMv = CommonUtils.resultSuccess(objMv);
                		}else {
                			objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_MID_EXIST);
                		}
                		
                		
                	}*/
                } else {
                	objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_CURPSWD_WRONG);
                }
            } else {
                objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY);
            }
        } catch(Exception ex) {
            objMv = CommonUtils.resultFail(objMv, ex.getMessage());
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    
    
    /**--------------------------------------------------
     * Method Name    : logInGetSessionCsrfToken
     * Description    : 
     * Author         : ymjo, 2015. 11. 24.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/logInGetSessionCsrfToken.do", method=RequestMethod.POST)
    public ModelAndView logInGetSessionCsrfToken(HttpSession session) throws Exception {
        ModelAndView  objMv = new ModelAndView();      

        if (session.getAttribute(CommonConstants.IMS_SESSION_CSRF_KEY) != null) {
            objMv.addObject("CSRFToken", session.getAttribute(CommonConstants.IMS_SESSION_CSRF_KEY));
        } else {
            objMv.addObject("CSRFToken", "");
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : logInSessionLanguage
     * Description    : 
     * Author         : ymjo, 2015. 11. 24.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/logInSessionLanguage.do", method=RequestMethod.POST)
    public ModelAndView logInSessionLanguage(@RequestBody String strJsonParameter, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        String strLanguageCode = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                strLanguageCode = objMap.get("LANGUAGE_CODE").toString();
                
                strLanguageCode = (strLanguageCode == "" ? CommonConstants.IMS_SESSION_DEFAULT_LANGUAGE_CODE : strLanguageCode);
                session.setAttribute(CommonConstants.IMS_SESSION_LANGUAGE_KEY, strLanguageCode);
                
                Cookie cookie = new Cookie(CommonConstants.IMS_SESSION_LANGUAGE_KEY, strLanguageCode);
                cookie.setPath("/");
                cookie.setMaxAge(CommonConstants.IMS_SESSION_LANGUAGE_COOKIE_EXP);
                response.addCookie(cookie);
                
                CommonUtils.SetLocale(strLanguageCode);

                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY);
            }
        } catch(Exception ex) {
            objMv = CommonUtils.resultFail(objMv, ex.getMessage());
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : checkIsEmptySession
     * Description    : 이용자 세션 확인
     * Author         : yangjeongmo, 2015. 11. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/logInCheckIsEmptySession.do", method=RequestMethod.POST)
    public ModelAndView checkIsEmptySession(HttpSession session) throws Exception {
        ModelAndView  objMv  = new ModelAndView();      
        
        if (session.getAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY) != null) {
            objMv.addObject("IsEmptySession", false);
        } else {
            objMv.addObject("IsEmptySession", true);
        }        
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : error404
     * Description    : 404 Error Page Call 
     * Author         : ymjo, 2015. 10. 5.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/error/error404.do")
    public String error404(Model model) {        
        return "/error/error404";
    }
    
    /**--------------------------------------------------
     * Method Name    : error500
     * Description    : 500 Error Page Call 
     * Author         : ymjo, 2015. 10. 5.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/error/error500.do")
    public String error500(Model model) {        
        return "/error/error500";
    }    
    
    /**--------------------------------------------------
     * Method Name    : merchantApply
     * Description    : Merchant Apply Page 
     * Author         : lst, 2018. 08. 27.
     * Modify History : Just Created.
     ----------------------------------------------------
     * @throws Exception 
     */  
    @RequestMapping(value="/merchantApply.do", method=RequestMethod.POST)
    public void merchantApply(@RequestBody String strJsonParameter, HttpSession session, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	JSONObject outter = new JSONObject();
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                if(objMap == null || objMap.size() < 0){
                    outter.put("result", "n");
                }else {
                	logInOutService.insertMerchantApply(objMap);
                    outter.put("result", "y");
                }
                
            } else {
                outter.put("result", "n");
            }
            
        } catch(Exception ex) {
            logger.debug("merchantApply.do exception : " + ex.getMessage());
        } finally {
        	
        }
        
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(outter.toString());
    }
    
    /**--------------------------------------------------
     * Method Name    : coNoDupChk
     * Description    : Company Number Duplicate Check
     * Author         : lst, 2018. 08. 27.
     * Modify History : Just Created.
     ----------------------------------------------------
     * @throws Exception 
     */  
    @RequestMapping(value="/coNoDupChk.do", method=RequestMethod.POST)
    public void coNoDupChk(@RequestBody String strJsonParameter, HttpSession session, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	Map<String, Object> objRow = new HashMap<String, Object>();
    	JSONObject outter = new JSONObject();
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                Map<String,Object> objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                if(objMap == null || objMap.size() < 0){
                	outter.put("result", "e");
                }else {
                	objRow = logInOutService.selectCoNoDupChk(objMap);
                    
                    if(objRow == null) {
                    	outter.put("result", "n");
                    }else {
                    	outter.put("result", "y");
                    }
                }
            } else {
            	outter.put("result", "e");
            }
            
        } catch(Exception ex) {
            logger.debug("coNoDupChk.do exception : " + ex.getMessage());
        } finally {
          
        }
        
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(outter.toString());
    }
    
}