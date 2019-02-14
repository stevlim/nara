package egov.linkpay.ims.common.common;

import java. util.Properties ;

import javax.annotation.PostConstruct;
import javax. mail.Message ;
import javax. mail.PasswordAuthentication ;
import javax. mail.Session ;
import javax. mail.Transport ;
import javax. mail.internet.InternetAddress;
import javax. mail.internet.MimeMessage;
import javax. mail.internet.MimeUtility;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonMail.java
 * Description    : Send Mail
 * Author         : ymjo, 2015. 11. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Component
public class CommonMail {
    @Autowired
    private Properties config;
    
    private static Properties ionpayConfig;
    
    @PostConstruct
    public void init(){
        ionpayConfig = config;
    }
    
    public static String getProperties(String strKey){
    	
        return ionpayConfig.getProperty(strKey);
    }

    public static boolean sendSmtpMail(String strSubject, String strFromMail, String strToMail, String strContent) {
        boolean isSuccess = true;
        
        Properties  objProps       = null;
        Session     objMailSession = null;
        Message     objMsg         = null;
        
        try {
            objProps = new Properties();
            objProps.put("mail.smtp.starttls.enable",     "true");
            objProps.put("mail.transport.protocol",       "smtp");
            objProps.put("mail.smtp.host",                getProperties("SMTP_SERVER_IP"));
            objProps.put("mail.smtp.port",                getProperties("SMTP_SERVER_PORT"));
            objProps.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            objProps.put("mail.smtp.socketFactory.port", "465");
            objProps.put("mail.smtp.user",                strFromMail);
            objProps.put("mail.smtp.auth",                "true");
                
            objMailSession = Session.getInstance (objProps, new javax.mail. Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication () {
                    return new PasswordAuthentication(getProperties("SMTP_ACCOUNT"), getProperties("SMTP_ACCOUNT_PW"));
                    }
                });

            objMsg = new MimeMessage(objMailSession);
            objMailSession.setDebug(true);
            objMsg.setFrom(new InternetAddress(strFromMail, MimeUtility.encodeText(getProperties("SMTP_ACCOINT_NAME"), "UTF-8", "B")));
            InternetAddress[] arrAddress = { new InternetAddress(strToMail) };
            objMsg.setRecipients(Message.RecipientType.TO, arrAddress);
            objMsg.setSubject(strSubject);
            objMsg.setSentDate(new java.util.Date());
            objMsg.setContent(strContent, "text/html");
            
            Transport.send (objMsg);
            } catch (Exception ex) {
            	ex.printStackTrace();
                isSuccess = false;
            } finally {
                objMsg         = null;
                objMailSession = null;
                objProps       = null;
            }
        
        return isSuccess;
    }
}
