package egov.linkpay.ims.common.common;

import java.util.Locale;

import org.springframework.context.MessageSource;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonMessageDic.java
 * Description    : 
 * Author         : yangjeongmo, 2015. 12. 1.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CommonMessageDic {    
    private static MessageSource messages;
    
    public void setMessages(MessageSource messages){
        CommonMessageDic.messages = messages;
    }
    
    public static String getMessage(String key){
        String strMessage = "";
        
        try{
            strMessage = CommonMessageDic.messages.getMessage(key, null, Locale.getDefault());
        } catch(Exception ex) {
            return key;
        }
        
        return strMessage;
    }
    
    public static String getMessage(String key, Locale locale){
        String strMessage = "";
        
        try{
            strMessage = CommonMessageDic.messages.getMessage(key, null, locale);
        } catch(Exception ex) {
            return key;
        }
        
        return strMessage;
    }
}
