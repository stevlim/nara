package egov.linkpay.ims.common.crypt_src.common.crypter.impl;

import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import egov.linkpay.ims.common.crypt_src.common.crypter.CryptService;


@Component
@Qualifier("CryptAesService")
public class CryptAesServiceImpl extends CryptService {

	public final String encrypt(String input, String key, String iv) throws Exception {
		byte[] ivbytes = iv.substring(0, 16).getBytes();
		IvParameterSpec ips = new IvParameterSpec(ivbytes);
		byte[] keybytes = hexToByteArray(key);
		byte[] crypted = null;

		Key skey = new SecretKeySpec(keybytes, "AES");

		Cipher cipher;

		try {
			cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			cipher.init(Cipher.ENCRYPT_MODE, skey, ips);
			byte[] ptext = input.getBytes();
			crypted = cipher.doFinal(ptext);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

		return byteArrayToHex(crypted);
	}

	public final String decrypt(String input, String key, String iv) throws Exception {
		IvParameterSpec ips = new IvParameterSpec(iv.substring(0, 16).getBytes());
		byte[] keybytes = hexToByteArray(key);
		byte[] output = null;
		try {
			Key skey = new SecretKeySpec(keybytes, "AES");
			Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			cipher.init(Cipher.DECRYPT_MODE, skey, ips);
			output = cipher.doFinal(hexToByteArray(input));
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return new String(output);
	}

}
