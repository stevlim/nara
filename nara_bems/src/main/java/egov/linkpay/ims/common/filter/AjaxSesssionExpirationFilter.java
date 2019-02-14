package egov.linkpay.ims.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import egov.linkpay.ims.common.common.CommonConstants;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.filter
 * File Name      : AjaxSesssionExpirationFilter.java
 * Description    : Ajax Session Expiration Filter
 * Author         : yangjeongmo, 2015. 11. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class AjaxSesssionExpirationFilter implements Filter {
    Logger logger = Logger.getLogger(this.getClass());
    
    private int intCustomSessionExpiredErrorCode = 901;
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest  httpRequest  = (HttpServletRequest)request;
        HttpServletResponse httpResponse = (HttpServletResponse)response;
        HttpSession         session      = ((HttpServletRequest)request).getSession(false);
        
        for(int i=0; i<CommonConstants.FILTER_AJAX_EXCEPTION_URI_SGMNT.length; i++){
            if(httpRequest.getRequestURI().indexOf(CommonConstants.FILTER_AJAX_EXCEPTION_URI_SGMNT[i]) != -1){
                chain.doFilter(httpRequest, httpResponse);
                return;
            }
        }
        
        if(session == null){
            String   strAjaxHeader   = ((HttpServletRequest) request).getHeader("X-Requested-With");
            String[] arrMenuRUISgmnt = {};
            
            arrMenuRUISgmnt = httpRequest.getRequestURI().split("/");
            
            if(3 > arrMenuRUISgmnt.length) {
                chain.doFilter(httpRequest, httpResponse);
                return;
            }
            
            if("XMLHttpRequest".equals(strAjaxHeader) || arrMenuRUISgmnt[2].toLowerCase().indexOf("excel") != -1){
                httpRequest.getSession().setAttribute(CommonConstants.IMS_SESSION_PREV_PAGE_KEY, httpRequest.getHeader("Referer"));
                httpResponse.sendError(intCustomSessionExpiredErrorCode);
            } else {
                chain.doFilter(httpRequest, httpResponse);
            }
        }
        else {
            chain.doFilter(httpRequest, httpResponse);
        }
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
      //Nothing to do
    }

    @Override
    public void destroy() {
        //Nothing to do
    }
}
