package egov.linkpay.ims.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.filter
 * File Name      : XSSFilter.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class XSSFilter implements Filter {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)

    throws IOException, ServletException {        
        chain.doFilter(new XSSRequestWrapper((HttpServletRequest) request), response);
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