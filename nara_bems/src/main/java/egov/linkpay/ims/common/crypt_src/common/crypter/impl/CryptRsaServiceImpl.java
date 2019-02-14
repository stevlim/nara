package egov.linkpay.ims.common.crypt_src.common.crypter.impl;

import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Security;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import egov.linkpay.ims.common.crypt_src.common.crypter.CryptService;



@Component
@Qualifier("CryptRsaService")
public class CryptRsaServiceImpl extends CryptService {

	private static Key publicKey = null;
	private static Key privateKey = null;

	public CryptRsaServiceImpl() throws Exception {
		if (this.publicKey == null) {
			Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
			createKey();
		}
	}

	public String encrypt(String input, String key, String nm) throws Exception {
		Cipher cipher = Cipher.getInstance("RSA/None/NoPadding", "BC");

		// public key
		byte[] bytePubKey = hexToByteArray(key);

		X509EncodedKeySpec spec = new X509EncodedKeySpec(bytePubKey);
		KeyFactory kf = KeyFactory.getInstance("RSA");
		Key pubKey = kf.generatePublic(spec);

		// 공개키를 전달하여 암호화
		cipher.init(Cipher.ENCRYPT_MODE, pubKey);
		byte[] cipherText = cipher.doFinal(input.getBytes());

		return byteArrayToHex(cipherText);
	}

	public String decrypt(String input, String key, String iv) throws Exception {
		Cipher cipher = Cipher.getInstance("RSA/None/NoPadding", "BC");
		Key newPriKey = null;
		if (key == null) {
			newPriKey = privateKey;
		} else {
			PKCS8EncodedKeySpec spec2 = new PKCS8EncodedKeySpec(hexToByteArray(key));
			KeyFactory kf = KeyFactory.getInstance("RSA");
			newPriKey = kf.generatePrivate(spec2);
		}

		// 개인키를 가지고있는쪽에서 복호화
		cipher.init(Cipher.DECRYPT_MODE, newPriKey);
		byte[] plainText = cipher.doFinal(hexToByteArray(input));

		return new String(plainText);
	}

	public void createKey() throws Exception {
		Cipher cipher = Cipher.getInstance("RSA/None/NoPadding", "BC");
		SecureRandom random = new SecureRandom();
		KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA", "BC");

		generator.initialize(256, random); // 여기에서는 128 bit 키를 생성하였음
		KeyPair pair = generator.generateKeyPair();
		CryptRsaServiceImpl.publicKey = pair.getPublic(); // Kb(pub) 공개키
		CryptRsaServiceImpl.privateKey = pair.getPrivate();// Kb(pri) 개인키
	}

	public static PublicKey get(byte[] keys) throws Exception {

		X509EncodedKeySpec spec = new X509EncodedKeySpec(keys);
		KeyFactory kf = KeyFactory.getInstance("RSA");
		return kf.generatePublic(spec);
	}

	public String getPubKey() {
		byte[] beforePubKey = publicKey.getEncoded();
		String strPubKey = byteArrayToHex(beforePubKey);

		return strPubKey;
	}

	/**
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());

		String input = "12345678901234567890123456789012";

		CryptRsaServiceImpl rsaService = new CryptRsaServiceImpl();

		byte[] beforePubKey = publicKey.getEncoded();
		String strPubKey = byteArrayToHex(beforePubKey);

		String encText = rsaService.encrypt(input, strPubKey, null);

		System.out.println(encText);

		byte[] beforePriKey = privateKey.getEncoded();
		String strPriKey = byteArrayToHex(beforePriKey);

		String decText = rsaService.decrypt(encText, strPriKey, null);

		System.out.println(decText);
		
	}
}
