package egov.linkpay.ims.common.logger;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDAO;
import egov.linkpay.ims.common.common.CommonUtils;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.logger
 * File Name      : LoggerInterceptor.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class LoggerInterceptor extends HandlerInterceptorAdapter {
	protected Log logger = LogFactory.getLog(LoggerInterceptor.class);
	
	@Resource(name="commonDAO")
    private CommonDAO commonDAO;
	
	boolean isSuccess = true;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object objHandler) throws Exception {
		String   strRequestURI   = request.getRequestURI();
		String[] arrMenuRUISgmnt = {};
		String   strMenuURISgmnt = "";
		String   strIP           = "";
		String   strLanguageCode = "";
		
		String   strUserPSWD     = "";
		
		int      intUserAuth     = 0;
		int      intChkMenuCnt   = 0;
	    
	    if (logger.isDebugEnabled()) {
		    logger.debug("=================================       START      =================================");
		    logger.debug("Request URI \t:  " + strRequestURI);
		    logger.debug("Source IP \t:  " + CommonUtils.GetIPAddr(request));
		    logger.debug("System IP \t:  " + request.getLocalAddr());
		    logger.debug("User ID \t:  " + request.getSession().getAttribute("USR_ID"));
		}
		
		try
		{
		    if (request.getSession().getAttribute(CommonConstants.IMS_SESSION_LANGUAGE_KEY) == null) {
		        if (request.getCookies() != null) {
    		        for (Cookie curCookie : request.getCookies()) {
    	                if (curCookie.getName().equals(CommonConstants.IMS_SESSION_LANGUAGE_KEY)) {
    	                    strLanguageCode = curCookie.getValue();
    	                }
    	            }
		        }
		        
		        strLanguageCode = (strLanguageCode == "" ? CommonConstants.IMS_SESSION_DEFAULT_LANGUAGE_CODE : strLanguageCode);
		        request.getSession().setAttribute(CommonConstants.IMS_SESSION_LANGUAGE_KEY, strLanguageCode);
		        
	            CommonUtils.SetCookie(CommonConstants.IMS_SESSION_LANGUAGE_KEY, strLanguageCode, CommonConstants.IMS_SESSION_LANGUAGE_COOKIE_EXP, response);
	            
	            CommonUtils.SetLocale(strLanguageCode);	            
		    } else {
		        CommonUtils.SetLocale(request.getSession().getAttribute(CommonConstants.IMS_SESSION_LANGUAGE_KEY).toString());
		    }
		    
		    if ((strRequestURI.indexOf("/log") == -1 && strRequestURI.indexOf("/batch") == -1 && strRequestURI.indexOf("/error") == -1) && request.getSession().getAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY) == null) {
		        intChkMenuCnt = Integer.parseInt(commonDAO.selectChkMenu(strRequestURI).toString());
                
                if(intChkMenuCnt > 0){
                    //이전 페이지 담는 세션 생성
                    request.getSession().setAttribute(CommonConstants.IMS_SESSION_PREV_PAGE_KEY, strRequestURI);
                }
                
                CommonUtils.SetCookie(CommonConstants.IMS_SESSION_EXP_KEY, CommonConstants.IMS_SESSION_EXP_VALUE, CommonConstants.IMS_SESSION_EXP, response);
                
		        response.sendRedirect("/");
		        
		        return false;
		    } else {
		        for(int i=0; i<CommonConstants.FILTER_AJAX_EXCEPTION_URI_SGMNT.length; i++){
                    if(request.getRequestURI().indexOf(CommonConstants.FILTER_AJAX_EXCEPTION_URI_SGMNT[i]) != -1){
                        return true;
                    }
                }
		        
		        strUserPSWD = commonDAO.selectUserPSWD(CommonUtils.getSessionInfo(request.getSession(), "USR_ID")).toString();
                
                if(CommonConstants.DEFAULT_ENCRYPT_USER_PASSWORD.equals(strUserPSWD)){
                    request.getSession().setAttribute(CommonConstants.IMS_SESSION_PASSWORD_CHANGE_KEY, "Y");
                } else {
                    request.getSession().setAttribute(CommonConstants.IMS_SESSION_PASSWORD_CHANGE_KEY, "N");
                }
                
		        for(int i=0; i<CommonConstants.INTERCEPTER_EXCEPTION_URI_SGMNT.length; i++){
		            if(request.getRequestURI().indexOf(CommonConstants.INTERCEPTER_EXCEPTION_URI_SGMNT[i]) != -1){
		                return true;
		            }
		        }
		        
		        //이전 페이지 담는 세션 삭제
                request.getSession().removeAttribute(CommonConstants.IMS_SESSION_PREV_PAGE_KEY);
		        
		        arrMenuRUISgmnt = getMenuSgmt(strRequestURI.substring(1, request.getRequestURI().length()));
		        strMenuURISgmnt = "/" + arrMenuRUISgmnt[0] + "/" + arrMenuRUISgmnt[1];
		        strIP           = "";
		        intUserAuth     = 0;
		        
		        //이용자 권한 체크 파리미터 세팅
		        Map<String,Object> objMap = new HashMap<String,Object>();
		        objMap.put("USR_ID",         CommonUtils.getSessionInfo(request.getSession(), "USR_ID"));
		        objMap.put("MENU_URI_SGMNT", strMenuURISgmnt);
		        
		        //이용자 권한 메뉴 개수 확인
		        int intChkAuthMenuCnt = Integer.parseInt(commonDAO.selectChkAuthUserMenu(objMap).toString());
	            
	            if(intChkAuthMenuCnt > 0){
	                //이용자 메뉴 정보 권한 및 정보 검색
	                objMap = commonDAO.selectAuthUserMenu(objMap);
	                
	                strIP       = CommonUtils.GetIPAddr(request);
	                intUserAuth = Integer.parseInt(objMap.get("AUTH_CD").toString());
                    
	                
	                //권한 체크
	                if(!checkUserAuth(arrMenuRUISgmnt[2], intUserAuth)){
	                    response.sendRedirect("/error/error404.do");
	                    request.getSession().removeAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY);
	                    return false;
	                }
	                
	                objMap.put("USR_ID",    CommonUtils.getSessionInfo(request.getSession(), "USR_ID"));
	                objMap.put("METHOD_NM", GetMethod(arrMenuRUISgmnt[2]));
	                objMap.put("LOG_DESC",  GetMethodDesc(arrMenuRUISgmnt[2]));
	                objMap.put("WORKER_IP", strIP);
	                
	                //메뉴 접근 로그 입력
	                commonDAO.insertUserWorkLog(objMap);
	            } else {
	                response.sendRedirect("/error/error404.do");
	                request.getSession().removeAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY);
                    return false;
	            }
		    }
		} catch(Exception ex) {
		    logger.debug("preHandle : " + ex.getStackTrace());
		    response.sendRedirect("/error/error500.do");
		    isSuccess = false;
		    return false;
		}
		
		return super.preHandle(request, response, objHandler);
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object objHandler, ModelAndView modelAndView) throws Exception {
		if (logger.isDebugEnabled()) {
			if(isSuccess){
				logger.debug("===============================      SUCCESS  END      ===============================\n");
			} else {
				logger.debug("===============================      FAILURE  END      ===============================\n");
			}
		}
	}
	
	/**--------------------------------------------------
     * Method Name    : getMenuSgmt
     * Description    : get menu Segment
     * Author         : yangjeongmo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private String[] getMenuSgmt(String strRequestURI){
        String strMenuSgmt[] = strRequestURI.split("/");
        
        return strMenuSgmt;
    }
    
    /**--------------------------------------------------
     * Method Name    : checkUserAuth
     * Description    : Check User Authority
     * Author         : yangjeongmo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private boolean checkUserAuth(String strControllerName, int intUserAuth){
        if(intUserAuth == 1){
            return true;
        }
        
        if(strControllerName.toLowerCase().indexOf("insert") != -1 || strControllerName.toLowerCase().indexOf("update") != -1
        || strControllerName.toLowerCase().indexOf("upload") != -1 || strControllerName.toLowerCase().indexOf("delete") != -1){
            return false;
        }
        
        return true;
    }
    
    /**--------------------------------------------------
     * Method Name    : GetMethod
     * Description    : Get Method Name
     * Author         : yangjeongmo, 2015. 10. 19.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private String GetMethod(String strMethod){
        
        String arrMethod[] = strMethod.split("\\.");
        
        return arrMethod[0];
    }
    
    /**--------------------------------------------------
     * Method Name    : GetMethodDesc
     * Description    : Get Method Description
     * Author         : yangjeongmo, 2015. 10. 19.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private String GetMethodDesc(String strMethod){
        String strMethodDesc = "";
        
        if(strMethod.toLowerCase().indexOf("insert") !=-1){
            strMethodDesc = "Executed insert work.";
        }else if (strMethod.toLowerCase().indexOf("update") !=-1){
            strMethodDesc = "Executed update work.";
        }else if (strMethod.toLowerCase().indexOf("delete") !=-1){
            strMethodDesc = "Executed delete work.";
        }else if (strMethod.toLowerCase().indexOf("excel") !=-1){
            strMethodDesc = "Executed excel download work.";
        }else if (strMethod.toLowerCase().indexOf("upload") !=-1){
            strMethodDesc = "Executed file upload work.";
        }else if (strMethod.toLowerCase().indexOf("select") !=-1){
            strMethodDesc = "Executed search work.";
        }else{
            strMethodDesc = "Executed work.";
        }
        
        return strMethodDesc;
    }
}