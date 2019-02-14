package egov.linkpay.ims.common.filter;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonUtils;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.filter
 * File Name      : CSRFFilter.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CSRFFilter implements Filter {
    private final static Logger logger = LoggerFactory.getLogger(CSRFFilter.class);
    private final static Pattern COMMA = Pattern.compile(",");

    private String       strCSRFTokenName               = "";
    private String       strOncePerRequestAttributeName = "";
    private String       strSessionToken                = "";
    
    private Set<String>  excludeURLs          = new HashSet<String>();
    private List<String> excludeStartWithURLs = new ArrayList<String>();
    private Set<String>  excludeFormURLs      = new HashSet<String>();
    private Random       random               = new SecureRandom();

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest  httpRequest  = (HttpServletRequest)request;
        HttpServletResponse httpResponse = (HttpServletResponse)response;
        HttpSession         session      = httpRequest.getSession();

        if (httpRequest.getAttribute(strOncePerRequestAttributeName) != null) {
            chain.doFilter(httpRequest, httpResponse);
        } else {
            httpRequest.setAttribute(strOncePerRequestAttributeName, Boolean.TRUE);
            
            try {
                doFilterInternal(httpRequest, httpResponse, chain, session);
            } finally {
                httpRequest.removeAttribute(strOncePerRequestAttributeName);
            }
        }
    }

    /**--------------------------------------------------
     * Method Name    : doFilterInternal
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private void doFilterInternal(HttpServletRequest httpRequest, HttpServletResponse httpResponse, FilterChain chain, HttpSession session) throws IOException, ServletException {
        if (!httpRequest.getMethod().equals("POST")) {
            if (excludeFormURLs.contains(httpRequest.getServletPath())) {
                chain.doFilter(httpRequest, httpResponse);
                
                return;
            }
            
            for (String curStart : excludeStartWithURLs) {
                if (httpRequest.getServletPath().startsWith(curStart)) {
                    chain.doFilter(httpRequest, httpResponse);
                    
                    return;
                }
            }
            
            String strToken = Long.toString(random.nextLong(), 36);
            
            session.setAttribute(CommonConstants.IMS_SESSION_CSRF_KEY, strToken);

            logger.debug("CSRF Security Token Generated : {}, path : {}", strToken, httpRequest.getServletPath());
            
            chain.doFilter(httpRequest, httpResponse);
            
            return;
        }

        if (excludeURLs.contains(httpRequest.getServletPath())) {
            chain.doFilter(httpRequest, httpResponse);
            
            return;
        }
        
        String strCSRFToken = httpRequest.getHeader(strCSRFTokenName);
        
        if (strCSRFToken == null) {
            strCSRFToken = httpRequest.getParameter(strCSRFTokenName);
        }
        
        if(httpRequest.getServletPath().indexOf("uploadFile") == -1) {
            if (strCSRFToken == null) {
                logger.debug("CSRF Security Token Not Found in POST request : {}", httpRequest.getServletPath());
                
                if (!httpResponse.isCommitted()) {
                    httpResponse.sendError(400);
                }
                
                return;
            }
            
            httpRequest.setAttribute(strCSRFTokenName, strCSRFToken);
    
            try {
                strSessionToken = session.getAttribute(CommonConstants.IMS_SESSION_CSRF_KEY).toString();
            } catch(Exception ex) {
                strSessionToken = "Token Is Empty";
                
                if (!httpResponse.isCommitted()) {
                    httpRequest.getSession().setAttribute(CommonConstants.IMS_SESSION_PREV_PAGE_KEY, httpRequest.getHeader("Referer"));
                    CommonUtils.SetCookie(CommonConstants.IMS_SESSION_EXP_KEY, CommonConstants.IMS_SESSION_EXP_VALUE, CommonConstants.IMS_SESSION_EXP, httpResponse);
                    httpResponse.sendError(901);
                }
            }
            
            if (strSessionToken.equals(strCSRFToken)) {
                chain.doFilter(httpRequest, httpResponse);
                
                return;
            } else {
                logger.debug("Mismatched CSRF Security Token - receive : {}, sessionToken : {}, path : {}", new Object[] { strCSRFToken, strSessionToken, httpRequest.getServletPath() });
                
                if (!httpResponse.isCommitted()) {
                    httpResponse.sendError(400);
                }
                
                return;
            }            
        }
        
        chain.doFilter(httpRequest, httpResponse);
        
        return;
    }

    public void init(FilterConfig config) throws ServletException {
        String strValue = config.getInitParameter("strCSRFTokenName");
        
        if (strValue == null || strValue.trim().length() == 0) {
            throw new ServletException("strCSRFTokenName parameter should be specified");
        }
        
        strCSRFTokenName = strValue;
        
        String excludedURLsStr = config.getInitParameter("exclude");
        
        if (excludedURLsStr != null) {
            String[] parts = COMMA.split(excludedURLsStr);
            excludeURLs = new HashSet<String>(parts.length);
            
            for (String cur : parts) {
                excludeURLs.add(cur);
            }
        } else {
            excludeURLs = new HashSet<String>(0);
        }
        
        String excludedFormURLsStr = config.getInitParameter("excludeGET");
        
        if (excludedFormURLsStr != null) {
            String[] parts = COMMA.split(excludedFormURLsStr);
            excludeFormURLs = new HashSet<String>(parts.length);
            
            for (String cur : parts) {
                excludeFormURLs.add(cur.trim());
            }
        } else {
            excludeFormURLs = new HashSet<String>(0);
        }
        
        String excludeStartWithURLsStr = config.getInitParameter("excludeGETStartWith");
        
        if (excludeStartWithURLsStr != null) {
            String[] parts = COMMA.split(excludeStartWithURLsStr);
            excludeStartWithURLs = new ArrayList<String>(parts.length);
        
            for (String curPart : parts) {
                excludeStartWithURLs.add(curPart.trim());
            }
        } else {
            excludeStartWithURLs = new ArrayList<String>(0);
        }
        
        strOncePerRequestAttributeName = getFirstTimeAttributeName();
    }
    
    /**--------------------------------------------------
     * Method Name    : getFirstTimeAttributeName
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String getFirstTimeAttributeName() {
        return CSRFFilter.class.getName() + ".ATTR";
    }

    public void destroy() {
        // Nothing to do
    }
}