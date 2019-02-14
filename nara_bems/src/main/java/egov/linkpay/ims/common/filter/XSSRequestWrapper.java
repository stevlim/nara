package egov.linkpay.ims.common.filter;

import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.log4j.Logger;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.filter
 * File Name      : XSSRequestWrapper.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class XSSRequestWrapper extends HttpServletRequestWrapper {
    Logger logger = Logger.getLogger(this.getClass());
    
    private static Pattern[] patterns = new Pattern[] {
            Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE),
            Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'",
                    Pattern.CASE_INSENSITIVE | Pattern.MULTILINE
                            | Pattern.DOTALL),
            Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"",
                    Pattern.CASE_INSENSITIVE | Pattern.MULTILINE
                            | Pattern.DOTALL),
            Pattern.compile("</script>", Pattern.CASE_INSENSITIVE),
            Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE
                    | Pattern.MULTILINE | Pattern.DOTALL),
            Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE
                    | Pattern.MULTILINE | Pattern.DOTALL),
            Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE
                    | Pattern.MULTILINE | Pattern.DOTALL),
            Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE),
            Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE),
            Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE
                    | Pattern.MULTILINE | Pattern.DOTALL)
    };

    public XSSRequestWrapper(HttpServletRequest servletRequest) {
        super(servletRequest);
    }

    @Override
    public String[] getParameterValues(String strParameter) {        
        String[] arrValues = super.getParameterValues(strParameter);

        if (arrValues == null) {
            return null;
        }

        int intCount = arrValues.length;

        String[] arrEncodedValues = new String[intCount];

        for (int i = 0; i < intCount; i++) {
            arrEncodedValues[i] = stripXSS(arrValues[i]);
        }

        return arrEncodedValues;
    }

    @Override
    public String getParameter(String strParameter) {        
        String strValue = super.getParameter(strParameter);
        
        return stripXSS(strValue);
    }

    @Override
    public String getHeader(String strName) {        
        String strValue = super.getHeader(strName);
        
        return stripXSS(strValue);

    }

    /**--------------------------------------------------
     * Method Name    : stripXSS
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private String stripXSS(String strValue) {        
        if (strValue != null) {
            // NOTE: It's highly recommended to use the ESAPI library and
            // uncomment the following line to
            // avoid encoded attacks.
            // value = ESAPI.encoder().canonicalize(value);
            // Avoid null characters

            strValue = strValue.replaceAll("\0", "");

            // Remove all sections that match a pattern
            for (Pattern scriptPattern : patterns) {
                if ( scriptPattern.matcher(strValue).matches() ) {                    
                    logger.debug("Find XSS \t:  " + strValue);
                    
                    strValue = strValue.replaceAll("<", "&lt;").replaceAll(">", "&gt;");        
                }
            }
        }
        
        return strValue;
    }
}