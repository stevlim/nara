package egov.linkpay.ims.common.logger;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.util.NestedServletException;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.logger
 * File Name      : LoggerException.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@ControllerAdvice
public class LoggerException {
    private static final Logger logger = Logger.getLogger(LoggerException.class);
    
    /**--------------------------------------------------
     * Method Name    : handleSQLException
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @ExceptionHandler(SQLException.class)
    public String handleSQLException(HttpServletRequest request, Exception ex) {
        logger.debug("SQLException Occured URL \t: " + request.getRequestURL());
        logger.debug("SQLException Occured Exception \t: " + ex.toString());
        
        return "/error/error500";
    }
    
    /**--------------------------------------------------
     * Method Name    : handleIOException
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @ExceptionHandler(IOException.class)
    public String handleIOException(HttpServletRequest request, Exception ex) {
        logger.debug("IOException Occured URL \t: " + request.getRequestURL());
        logger.debug("IOException Occured Exception \t: " + ex.toString());
        
        return "/error/error500";
    }
    
    /**--------------------------------------------------
     * Method Name    : handleException
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @ExceptionHandler(Exception.class)
    public String handleException(HttpServletRequest request, Exception ex) {
        logger.debug("Exception Occured URL \t: " + request.getRequestURL());
        logger.debug("Exception Occured Exception \t: " + ex.toString());
        
        return "/error/error500";
    }
    
    /**--------------------------------------------------
     * Method Name    : handleClassCastException
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @ExceptionHandler(ClassCastException.class)
    public String handleClassCastException(HttpServletRequest request, Exception ex) {
        logger.debug("ClassCastException Occured :: URL = " + request.getRequestURL());
        logger.debug("ClassCastException Occured :: Exception = " + ex.toString());
        return "/error/error500";
    }
    
    /**--------------------------------------------------
     * Method Name    : handleNestedServletException
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @ExceptionHandler(NestedServletException.class)
    public String handleNestedServletException(HttpServletRequest request, Exception ex) {
        logger.debug("NestedServletException Occured :: URL = " + request.getRequestURL());
        logger.debug("NestedServletException Occured :: Exception = " + ex.toString());
        
        return "/error/error500";
    }
}