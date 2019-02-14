package egov.linkpay.ims.common.common;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonEncrypt.java
 * Description    : AES암호화
 * Author         : ymjo, 2015. 10. 7.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CommonEncrypt {
    private String strIV   = "";
    private Key    keySpec = null;
 
    /**
     * 16자리의 키값을 입력하여 객체 생성
     * @param key 암/복호화를 위한 키값
     * @throws UnsupportedEncodingException 키값의 길이가 16이하일 경우 발생
     */
    public CommonEncrypt() throws UnsupportedEncodingException {
        this.strIV = CommonConstants.ENCRYPT_KEY;
        byte[] keyBytes = new byte[16];
        byte[] b = CommonConstants.ENCRYPT_KEY.getBytes("UTF-8");
        int len = b.length;
        
        if (len > keyBytes.length) {
            len = keyBytes.length;
        }
        
        System.arraycopy(b, 0, keyBytes, 0, len);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
 
        this.keySpec = keySpec;
    }
     
    /**--------------------------------------------------
     * Method Name    : encrypt
     * Description    : AES256 암호화 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public String encrypt(String str) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(strIV.getBytes()));
        byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
        String enStr = new String(Base64.encodeBase64(encrypted));
        
        return enStr;
    }
 
    
    /**--------------------------------------------------
     * Method Name    : decrypt
     * Description    : AES256 복호화
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public String decrypt(String str) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(strIV.getBytes()));
        byte[] byteStr = Base64.decodeBase64(str.getBytes());
        
        return new String(c.doFinal(byteStr), "UTF-8");
    }
    
    /**
     * 비밀번호 해쉬
     * @param String   : 대상 문자열
     * @return String  : 해쉬 문자열
     */
     public static final synchronized String Base64EncodedMD5(String strPW){ 
       
       String passACL = null;
       MessageDigest md = null;
       
       try {
         md = MessageDigest.getInstance("MD5");
       } catch(Exception e) {
         e.printStackTrace();
       }
       
       md.update(strPW.getBytes());
       byte[] raw = md.digest();
       byte[] encodedBytes = Base64.encodeBase64(raw);
       passACL = new String(encodedBytes);
       
       return passACL;
     }
     /**
      * 비밀번호 해쉬 SHA256
      * @param String   : 대상 문자열
      * @return String  : 해쉬 문자열
      */
      public static final synchronized String encodedSHA512(String strPW){ 
    	  MessageDigest md = null;
    	  String passACL = "";
    	    try {
    	        md = MessageDigest.getInstance("SHA-512");
    	      } catch(Exception e) {
    	        e.printStackTrace();
    	      }
    	      
    	      md.reset();
    	      md.update(strPW.getBytes());
    	      byte[] raw = md.digest();
    	      byte[] encodedBytes = Base64.encodeBase64(raw);
    	      passACL = new String(encodedBytes);
    	  
    	  
    	  return passACL;
      }
            
}