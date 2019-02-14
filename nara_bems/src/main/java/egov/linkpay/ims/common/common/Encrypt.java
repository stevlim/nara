package egov.linkpay.ims.common.common;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import java.util.Base64;

public class Encrypt {
    public String getAes256Message(String msg, String keyValue, String mode) throws Exception {

        String ret = "{}";

        if(msg != null && !msg.trim().isEmpty()) {

                   byte[] keyByte = keyValue.getBytes("US-ASCII");

                  

                   byte[] key = new byte[32];

                   System.arraycopy(keyByte, keyByte.length - 32, key, 0, key.length);

                   byte[] iv = new byte[16];

                   System.arraycopy(keyByte, 0, iv, 0, iv.length);

                  

                   SecretKey sKey = new SecretKeySpec(key, "AES");

                   Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");

                  

                   if("enc".equals(mode)) {

                             c.init(Cipher.ENCRYPT_MODE, sKey, new IvParameterSpec(iv));

                            

                             byte[] enc = c.doFinal(msg.getBytes("UTF-8"));

                             ret = new String(Base64.getEncoder().encode(enc));
                             	
                   }else if("dec".equals(mode)) {

                             c.init(Cipher.DECRYPT_MODE, sKey, new IvParameterSpec(iv));

                             byte[] decParam = Base64.getDecoder().decode(msg);

                             ret = new String(c.doFinal(decParam), "UTF-8");

                   }

        }

        return ret;
    }
}
