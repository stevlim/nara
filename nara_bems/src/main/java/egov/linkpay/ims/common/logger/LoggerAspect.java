package egov.linkpay.ims.common.logger;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
 
/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.logger
 * File Name      : LoggerAspect.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Aspect
public class LoggerAspect {
    protected Log log = LogFactory.getLog(LoggerAspect.class);
     
    /**--------------------------------------------------
     * Method Name    : logPrint
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @Around("execution(* egov.linkpay.ims..controller.*Controller.*(..)) or execution(* egov.linkpay.ims..service.*Impl.*(..)) or execution(* egov.linkpay.ims..dao.*DAO.*(..))")
    public Object logPrint(ProceedingJoinPoint joinPoint) throws Throwable {
        String strName = "";
        String strType = "";
        
        strType = joinPoint.getSignature().getDeclaringTypeName();
         
        if (strType.indexOf("Controller") > -1) {
            strName = "Controller \t:  ";
        } else if (strType.indexOf("Service") > -1) {
            strName = "ServiceImpl \t:  ";
        } else if (strType.indexOf("DAO") > -1) {
            strName = "DAO \t\t:  ";
        }
        
        log.debug(strName + strType + "." + joinPoint.getSignature().getName() + "()");
        
        return joinPoint.proceed();
    }
}