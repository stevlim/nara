package egov.linkpay.ims.common.resolver;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDAO;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonUtils;
 
/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.resolver
 * File Name      : CustomMapArgumentResolver.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CustomMapArgumentResolver implements HandlerMethodArgumentResolver {
    Logger logger = Logger.getLogger(this.getClass());
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return CommonMap.class.isAssignableFrom(parameter.getParameterType());
    }
        
    @Resource(name="commonDAO")
    private CommonDAO commonDAO;
 
    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        CommonMap commonMap = new CommonMap();
         
        HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
        HttpServletResponse response = (HttpServletResponse) webRequest.getNativeResponse();
        HttpSession session = request.getSession(false);
        Enumeration<?> enumeration = request.getParameterNames();

        String   strKey    = "";
        String[] arrValues = {};
        
        while(enumeration.hasMoreElements()) {
            strKey = (String) enumeration.nextElement();
            arrValues = request.getParameterValues(strKey);
            
            if(arrValues != null) {
                commonMap.put(strKey, (arrValues.length > 1) ? arrValues:arrValues[0]);
            }
        }
        
        String   strRequestURI   = request.getRequestURI();
        String[] arrMenuRUISgmnt = getMenuSgmt(strRequestURI.substring(1, request.getRequestURI().length()));
        String   strMenuURISgmnt = "/" + arrMenuRUISgmnt[0] + "/" + arrMenuRUISgmnt[1];
        String   strIP           = "";
        
        Map<String,Object> objMap = new HashMap<String,Object>();
        objMap.put("USR_ID",         CommonUtils.getSessionInfo(session, "USR_ID"));
        objMap.put("MENU_URI_SGMNT", strMenuURISgmnt);
        
        try{
            objMap = commonDAO.selectAuthUserMenu(objMap);
            
            strIP = CommonUtils.GetIPAddr(request);
            
            commonMap.put("MENU_GRP_NO", objMap.get("MENU_GRP_NO"));
            commonMap.put("MENU_NO",     objMap.get("MENU_NO"));
            commonMap.put("MENU_GRP_NM", objMap.get("MENU_GRP_NM"));
            commonMap.put("MENU_NM",     objMap.get("MENU_NM"));
            commonMap.put("AUTH_CD",     objMap.get("AUTH_CD"));
            commonMap.put("MASTER_CD",   objMap.get("MASTER_CD"));
            
            commonMap.put("USR_ID",      CommonUtils.getSessionInfo(session, "USR_ID"));
            commonMap.put("USR_IP",      strIP);
        }catch(Exception e){
            response.sendRedirect("/error/error404.do");
            request.getSession().removeAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY);
            return null;
        }finally{
            objMap = null;
        }
        
        return commonMap;
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
}