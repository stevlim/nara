package egov.linkpay.ims.common.resolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.resolver
 * File Name      : CustomExceptionResolver.java
 * Description    : Global Exception Resolver
 * Author         : yangjeongmo, 2015. 11. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CustomExceptionResolver implements HandlerExceptionResolver {
    private static final Logger logger = Logger.getLogger(CustomExceptionResolver.class);
    
    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object object, Exception ex){
        logger.debug("Global Exception Message : " + ex.getMessage() + ", Exception : " + ex);
        
        //return new ModelAndView("/error/error500");
        return new ModelAndView("/");
    }
}