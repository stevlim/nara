package egov.linkpay.ims.common.crypt_src.common;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import egov.linkpay.ims.common.common.PayProp;
import egov.linkpay.ims.common.crypt_src.common.crypter.handler.CryptApiHandler;
import egov.linkpay.ims.common.crypt_src.common.crypter.impl.CryptAesServiceImpl;
import egov.linkpay.ims.common.crypt_src.common.crypter.impl.CryptRsaServiceImpl;
import egov.linkpay.ims.common.crypt_src.common.crypter.model.KeyInfo;



@Component
@Qualifier("CryptUtils")
public class CryptUtils {

	private static SimpleDateFormat sdfDt  = new SimpleDateFormat("yyyyMMdd");
	private static SimpleDateFormat sdfTm  = new SimpleDateFormat("HHmmss");
	   
	@Autowired
	@Qualifier("CryptAesService")
	CryptAesServiceImpl aesService;

	@Autowired
	@Qualifier("CryptRsaService")
	CryptRsaServiceImpl rsaService;

	@Autowired
	@Qualifier("CryptApiHandler")
	CryptApiHandler cryptHandler;

	private static Vector<KeyInfo> keySet = new Vector<KeyInfo>();

	public String encrypt(String data) throws Exception {
		String symKey = null;
		String iv = null;
		String index = null;

		if (data == null || "".equals(data)) {
			return "";
		}

		KeyInfo keyInfo = getkeyInfo(null);
		if (keyInfo != null) {
			index = keyInfo.getIndex();
			symKey = keyInfo.getSymKey();
			iv = keyInfo.getIv();
		} else {
			throw new Exception("key not found");
		}

		if (symKey != null && iv != null) {
			return index + encData(data, symKey, iv);
		} else {
			throw new Exception("key not found");
		}

	}

	public String decrypt(String data) throws Exception {
		String symKey = null;
		String iv = null;
		String index = null;
		String encText = null;
		if (data == null || "".equals(data)) {
			return "";
		} else {
			index = data.substring(0, 2);
			encText = data.substring(2);

			KeyInfo keyInfo = getkeyInfo(index);
			if (keyInfo != null) {
				symKey = keyInfo.getSymKey();
				iv = keyInfo.getIv();
			} else {
				return "[암호화적용전DATA]" + data;
			}

			if (symKey != null && iv != null) {
				return decData(encText, symKey, iv);
			} else {
				System.out.println("key not found");
				return "";
			}
		}
	}

	private KeyInfo getkeyInfo(String index) throws Exception {


		Calendar cal = Calendar.getInstance();
	      
		String apiDt = sdfDt.format(cal.getTime());
		String apiTm = sdfTm.format(cal.getTime());

		if (keySet.size() > 0) {
			for (KeyInfo keyInfo : keySet) {
				int strDt = Integer.parseInt(keyInfo.getStrDt());
				int endDt = Integer.parseInt(keyInfo.getEndDt());
				String idx = keyInfo.getIndex();

				if (index != null) {
					// index로 가져오기
					if (idx.equals(index)) {
						return keyInfo;
					}
				} else {
					// 날짜로 가져오기
					if (strDt <= Integer.parseInt(apiDt) && Integer.parseInt(apiDt) <= endDt) {
						return keyInfo;
					}
				}
			}
		}
		// 데이터가 없으면 통신
		HashMap keyMap = getKeyInfo(apiDt, apiTm, index);
		KeyInfo keyInfo = new KeyInfo();

		try {
			keyInfo.setIndex((String) keyMap.get("index"));
			keyInfo.setSymKey(rsaService.decrypt((String) keyMap.get("symKey"), null, null));
			keyInfo.setIv(rsaService.decrypt((String) keyMap.get("iv"), null, null));
			keyInfo.setStrDt((String) keyMap.get("strDt"));
			keyInfo.setEndDt((String) keyMap.get("endDt"));
		} catch (IllegalArgumentException iae) {
			// null 일 경우
			return null;
		} catch (NullPointerException npe) {
			// null 일 경우
			return null;
		} 

		keySet.add(keyInfo);
		return keyInfo;
	}

	private HashMap getKeyInfo(String apiDt, String apiTm, String index) throws Exception {
		HashMap request = new HashMap();
		request.put("apiType", "02");
		request.put("apiDt", apiDt);
		request.put("apiTm", apiTm);
		request.put("index", index);
		request.put("rsaPubKey", rsaService.getPubKey());
		//request.put("ip", java.net.InetAddress.getLocalHost().getHostAddress());
		
		request.put("ip", PayProp.getProp("SEND_IP"));
		
		request.put("hash", genHash(apiDt + apiTm));

		
		request.put("kms_ip", PayProp.getProp("KMS_IP"));
		request.put("kms_port", PayProp.getProp("KMS_PORT"));
		request.put("kms_timeout", PayProp.getProp("KMS_TIMEOUT"));
		
		
		HashMap response = cryptHandler.doProcess(request);
		return response;
	}

	private final String encData(String input, String symKey, String iv) throws Exception {
		if (input == null || "".equals(input)) {
			return "";
		} else {
			return aesService.encrypt(input, symKey, iv);
		}
	}

	private final String decData(String input, String symKey, String iv) throws Exception {
		if (input == null || "".equals(input)) {
			return "";
		} else {
			return aesService.decrypt(input, symKey, iv);
		}
	}

	// generate merchant token
	private String genHash(String apiDt) throws Exception {

		StringBuffer generateToken = new StringBuffer();

		generateToken.append(apiDt);
		//generateToken.append(java.net.InetAddress.getLocalHost().getHostAddress());
		generateToken.append(PayProp.getProp("SEND_IP"));
		System.out.println(java.net.InetAddress.getLocalHost().getHostAddress());
		return getSHAString(generateToken.toString(), "SHA-256");

	}

	 public static String getSHAString(String str, String mode) throws Exception {
		 String SHA = ""; 
	      try{
	         MessageDigest sh = MessageDigest.getInstance("SHA-256"); 
	         sh.update(str.getBytes()); 
	         byte byteData[] = sh.digest();
	         StringBuffer sb = new StringBuffer(); 
	         for(int i = 0 ; i < byteData.length ; i++){
	            sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
	         }
	         SHA = sb.toString();
	         
	      }catch(NoSuchAlgorithmException e){
	         e.printStackTrace(); 
	         SHA = null; 
	      }
	      return SHA;

	   }

//	public static void main(String[] args) {
//		
//		
//		CryptUtils test = new CryptUtils();
//		try {
//			System.out.println(test.encrypt("test"));
//			
//			System.out.println(test.decrypt("01217dca0b052ba072649dbe5535abaa50"));
//			
//		} catch (Exception e) {
//			e.printStackTrace();
//			// TODO: handle exception
//		}
//	}
	
}