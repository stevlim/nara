package egov.linkpay.ims.common.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Clob;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

import egov.linkpay.ims.common.common.CommonUtils.DateFormat;
import egov.linkpay.ims.common.common.CommonUtils.PrintDateFormat;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : Utils.java
 * Description    : Common Utility Class
 * Author         : ymjo, 2015. 10. 2.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CommonUtils {
    /**--------------------------------------------------
     * Method Name    : jsonToMap
     * Description    : Json String To Map
     * Author         : ymjo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static Map<String,Object> jsonToMap(String strJson) {
    	
        Map<String,Object> objMap = null;
        try {
        	objMap = new Gson().fromJson(strJson, new TypeToken<HashMap<String, String>>() {}.getType());
		} catch (Exception e) {
			objMap = new Gson().fromJson(strJson, new TypeToken<HashMap<String, Object>>() {}.getType());
		}
        if (objMap == null) {
            objMap = new HashMap<String, Object>();
        }
        
        return objMap;
    }
    
    /**--------------------------------------------------
     * Method Name    : resultSuccess
     * Description    : Ajax Process Result Success
     * Author         : ymjo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static ModelAndView resultSuccess(ModelAndView objMv) {        
        objMv.addObject("resultCode", 0);
        objMv.addObject("resultMessage", "Success");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : resultFail
     * Description    : Ajax Process Result Fail
     * Author         : ymjo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static ModelAndView resultFail(ModelAndView objMv, String strResultMessage) {        
        objMv.addObject("resultCode", 1);
        objMv.addObject("resultMessage", strResultMessage);
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : isNullorEmpty
     * Description    : Check String is Null or Empty
     * Author         : ymjo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static boolean isNullorEmpty(String...strings) {
        for (String str : strings) {
            if (str == null || str.isEmpty()) {
                return true;
            }
        }
        
        return false;
    }
    
    /**--------------------------------------------------
     * Method Name    : getSessionInfo
     * Description    : 
     * Author         : ymjo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @SuppressWarnings("unchecked")
    public static String getSessionInfo(HttpSession session, String strKey) {
        return ((Map<String, Object>)session.getAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY)).get(strKey).toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : isPartialSearch
     * Description    : Check Partial Search
     * Author         : yangjeongmo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private static boolean isPartialSearch(Map<String, Object> objMap) {
        boolean blnFlag   = false;
        int     intLength = 0;
        
        try {
            if(objMap == null) {
                return false;
            }
            
            if(!objMap.containsKey("length")) {
                return false;
            }
            
            intLength = (int) Double.parseDouble(objMap.get("length").toString());
            
            if(intLength > 0) {
                return true;
            }
            
        } catch(Exception ex) {
            blnFlag = false;
        }
    
        return blnFlag;
    }
    
    /**--------------------------------------------------
     * Method Name    : initSearchRange
     * Description    : Set all/partial Paging Size
     * Author         : yangjeongmo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static void initSearchRange(Map<String, Object> objMap) {
        int intSearchStart  = 0;
        int intSearchLength = 0;
        int intPageNo       = 0;
        int intPageSize     = 0;
        int intPageStart    = 0;
        
        int intPageEnd      = 0;
        int intDraw         = 0;
        
        boolean blnMultipleSearchFlag = isPartialSearch(objMap);
        
        if(blnMultipleSearchFlag) {
                    
            intSearchStart  = (int) Double.parseDouble(objMap.get("start").toString());
            intSearchLength = (int) Double.parseDouble(objMap.get("length").toString());
            
            //Calculate Paging Nubmer&Size
            intPageNo   = (intSearchStart/intSearchLength) + 1;
            intPageSize = intSearchLength;
            
            //Variable for Search Multiple
            intDraw = (int) Double.parseDouble(objMap.get("draw").toString());
            objMap.put("draw", intDraw);
        } else {
            intPageNo   = 1;
            intPageSize = 10000;
        }
        
        intPageStart = (intPageNo - 1) * intPageSize + 1;
        intPageEnd   = (intPageNo - 1) * intPageSize + intPageSize;
        
        objMap.put("intPageStart", intPageStart);
        objMap.put("intPageEnd", intPageEnd);
        objMap.put("blnMultipleSearchFlag", blnMultipleSearchFlag);
    }
    
    /**--------------------------------------------------
     * Method Name    : resultList
     * Description    : Ajax List Result
     * Author         : yangjeongmo, 2015. 10. 5.
     * Modify History : Just Created.
     * 주석은 기존 리스트 로직 
     ----------------------------------------------------*/
    public static ModelAndView resultList(ModelAndView objMv, Map<String, Object> objMap, List<Map<String,Object>> objList, int intPageTotal, int intResultCode, String strResultMessage) {
        if (intResultCode != 0) {
            objMv.addObject("resultCode",    intResultCode);
            objMv.addObject("resultMessage", strResultMessage);
            objMv.addObject("data",          objList);
            return objMv;
        }
        
//        int     intDraw = 0;
//        boolean blnMultipleSearchFlag = (boolean)objMap.get("blnMultipleSearchFlag");
//        
//        if(blnMultipleSearchFlag) {
//            intDraw = (int)objMap.get("draw");
//        }

	    // Search Single
//	    objMv.addObject("draw",            intDraw);
	    objMv.addObject("data",            objList);     
//	    objMv.addObject("rows",          objMap.get( "rows" ));
	    objMv.addObject("recordsTotal",    intPageTotal);
	    objMv.addObject("recordsFiltered", intPageTotal);
	    objMv.addObject("resultCode",      intResultCode);
	    objMv.addObject("resultMessage",   strResultMessage);
        
        return objMv;
    }
//    public static ModelAndView resultList(ModelAndView objMv, Map<String, Object> objMap, List<Map<String,Object>> objList, int intPageTotal, int intResultCode, String strResultMessage) {
//        if (intResultCode != 0) {
//            objMv.addObject("resultCode",    intResultCode);
//            objMv.addObject("resultMessage", strResultMessage);
//            objMv.addObject("data",          objList);
//            return objMv;
//        }
//        
//        int     intDraw = 0;
//        boolean blnMultipleSearchFlag = (boolean)objMap.get("blnMultipleSearchFlag");
//        
//        if(blnMultipleSearchFlag) {
//            intDraw = (int)objMap.get("draw");
//        }
//
//        if(blnMultipleSearchFlag) {
//            // Search Multiple
//            objMv.addObject("draw",            intDraw);
//            objMv.addObject("data",            objList);            
//            objMv.addObject("recordsTotal",    intPageTotal);
//            objMv.addObject("recordsFiltered", intPageTotal);
//            objMv.addObject("resultCode",      intResultCode);
//            objMv.addObject("resultMessage",   strResultMessage);
//        } else {
//            // Search Single
//            objMv.addObject("data",          objList);
//            objMv.addObject("resultCode",    intResultCode);
//            objMv.addObject("resultMessage", strResultMessage);
//        }
//        
//        return objMv;
//    }
    
    /**--------------------------------------------------
     * Method Name    : queryStringToMap
     * Description    : Query String to Map
     * Author         : yangjeongmo, 2015. 10. 6.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static Map<String,Object> queryStringToMap(String strQueryString) {
        String[]           arrParams = strQueryString.split("&");
        Map<String,Object> objMap    = new HashMap<String,Object>();
        
        String strName  = "";
        String strValue = "";
        
        for (String strParam : arrParams) {
            try
            {
                strName  = strParam.split("=")[0];
                strValue = strParam.split("=")[1];                               
            } catch(Exception ex) {
                strName  = strParam.replace("=", "");
                strValue = "";
            } finally {
                objMap.put(strName, strValue);
            }
        }
        
        return objMap;
    }
    
    /**--------------------------------------------------
     * Method Name    : ConvertTime
     * Description    : 
     * Author         : ymjo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String ConvertTime(Object objValue) {
        String strRetValue = "";
        String strValue    = objValue.toString();
        
        strRetValue = strValue.replace(":", "").concat("00");
        
        return strRetValue;
    }
    
    /**--------------------------------------------------
     * Method Name    : ConvertAmt
     * Description    : 
     * Author         : ymjo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String ConvertAmt(Object objValue) {
        String strRetValue = "";
        String strValue    = objValue.toString();
        
        strRetValue = strValue.replace(",", "");
        
        return strRetValue;
    }
    
    /**--------------------------------------------------
     * Method Name    : ConvertDate
     * Description    : Client Dateformat -> Server Dateformat
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String ConvertDate(DateFormat format, String strType, Object objValue) {
        String   strRetValue = "";
        String   strValue    = objValue.toString();
        String[] arrValue    = strValue.split("-");
        
        if (strValue.length() == 10)  {
            // mm-dd-yyy 형태로 올라오는 경우
            switch(format) {
                case YYYYMMDD :
                    strRetValue = arrValue[0] + arrValue[1] + arrValue[2]; 
                    break;
                    
                case YYYYMMDDHH24MISS :
                    strRetValue = arrValue[0] + arrValue[1] + arrValue[2] + ("s".equals(strType) ? "000000" : "235959"); 
                    break;
                    
                case HH24MISS :
                    strRetValue = arrValue[0] + arrValue[1] + arrValue[2];
                    break;
                    
                default :
                    strRetValue = arrValue[0] + arrValue[1] + arrValue[2];
                    break;
            }
        } else if (strValue.length() == 7){
            switch(format) {
                case YYYYMM :
                    strRetValue = arrValue[0] + arrValue[1]; 
                    break;
                    
                default :
                    strRetValue = arrValue[1] + arrValue[2];
                    break;
            }
        } else {
            // 년월일시분초까지 올라오는 경우 추후 구현
        }
        
        return strRetValue;
    }
    
    /**--------------------------------------------------
     * Method Name    : ConvertPrintDate
     * Description    : 출력용
     * Author         : ymjo, 2015. 10. 30.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String ConvertPrintDate(PrintDateFormat format, Object objValue) {
        String   strRetValue = "";
        String   strValue    = objValue.toString();        
        
        if (strValue.length() == 8)  {
            switch(format) {
                case YYYYMMDD :
                    //strRetValue = strValue.substring(6, 8) + "-" + strValue.substring(4, 6)  + "-" +  strValue.substring(0, 4);
                	strRetValue = strValue.substring(0, 4) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(6, 8);
                    break;
                    
                default :
                    //strRetValue = strValue.substring(6, 8) + strValue.substring(4, 6) + strValue.substring(0, 4);
                	strRetValue = strValue.substring(0, 4) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(6, 8);
                    break;
            }
        } else if (strValue.length() == 14){
            switch(format) {
                case YYYYMMDDHH24MISS :
                    //strRetValue = strValue.substring(6, 8) + "-" + strValue.substring(4, 6)  + "-" +  strValue.substring(0, 4) + " " + strValue.substring(8, 10) + ":" + strValue.substring(10, 12) + ":" + strValue.substring(12, 14);
                	strRetValue = strValue.substring(0, 4) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(6, 8) + " " + strValue.substring(8, 10) + ":" + strValue.substring(10, 12) + ":" + strValue.substring(12, 14);
                    break;
                    
                default :
                    //strRetValue = strValue.substring(6, 8) + strValue.substring(4, 6) + strValue.substring(0, 4) + strValue.substring(8, 10) + strValue.substring(10, 12) + strValue.substring(12, 14);
                	strRetValue = strValue.substring(0, 4) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(6, 8) + " " + strValue.substring(8, 10) + ":" + strValue.substring(10, 12) + ":" + strValue.substring(12, 14);
                    break;
            }
        } else if (strValue.length() == 6){
            switch(format) {
                case YYYYMM :
                    //strRetValue = strValue.substring(6, 8) + "-" + strValue.substring(4, 6)  + "-" +  strValue.substring(0, 4) + " " + strValue.substring(8, 10) + ":" + strValue.substring(10, 12) + ":" + strValue.substring(12, 14);
                	strRetValue = strValue.substring(0, 4) + "-" + strValue.substring(4, 6);
                    break;
                    
                default :
                    //strRetValue = strValue.substring(6, 8) + strValue.substring(4, 6) + strValue.substring(0, 4) + strValue.substring(8, 10) + strValue.substring(10, 12) + strValue.substring(12, 14);
                	strRetValue = strValue.substring(0, 4) + "-" + strValue.substring(4, 6);
                    break;
            }
        } else {
            // 년월일시분초까지 올라오는 경우 추후 구현
        }
        
        return strRetValue;
    }
    
    /**------------------------------------------------------------
     * Package Name   : egov.linkpay.ims.common.common
     * File Name      : CommonUtils.java
     * Description    : For ConvertDate
     * Author         : ymjo, 2015. 10. 13.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
    public enum DateFormat
    {        
        YYYYMMDD,
        YYYYMM,
        YYYYMMDDHH24MISS,
        HH24MISS        
    }
    
    /**------------------------------------------------------------
     * Package Name   : egov.linkpay.ims.common.common
     * File Name      : CommonUtils.java
     * Description    : 
     * Author         : ymjo, 2015. 10. 30.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
    public enum PrintDateFormat
    {      
        YYYYMMDD,
        YYYYMMDDHH24MISS,
        YYYYMM
    }
    
    /**--------------------------------------------------
     * Method Name    : GetIPAddr
     * Description    : Get IP Address
     * Author         : yangjeongmo, 2015. 10. 14.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String GetIPAddr(HttpServletRequest req){
        String strIP = req.getHeader("X-FORWARDED-FOR");
        
        if(strIP == null){
            strIP = req.getRemoteAddr();
        }
        
        return strIP;
    }
    
    /**--------------------------------------------------
     * Method Name    : CoverCellStyle
     * Description    : Cover Cell Style
     * Author         : yangjeongmo, 2015. 10. 30.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static void CoverCellStyle(SXSSFWorkbook workbook, XSSFCellStyle cellStyle, XSSFFont font, short intAlign, short intVAlign, int intFontSize){
        cellStyle.setAlignment(intAlign);
        cellStyle.setVerticalAlignment(intVAlign);
        cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
        cellStyle.setTopBorderColor(IndexedColors.BLACK.index);
        cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
        cellStyle.setRightBorderColor(IndexedColors.BLACK.index);
        cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
        cellStyle.setBottomBorderColor(IndexedColors.BLACK.index);
        cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
        cellStyle.setLeftBorderColor(IndexedColors.BLACK.index);
        
        font.setFontName("Arial");
        font.setFontHeightInPoints((short) intFontSize);
        cellStyle.setFont(font);
    }
    
    /**--------------------------------------------------
     * Method Name    : CoverTitleCellStyle
     * Description    : Cover Cell Style
     * Author         : yangjeongmo, 2015. 10. 30.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static void CoverTitleCellStyle(SXSSFWorkbook workbook, XSSFCellStyle cellStyle, XSSFFont font, short intAlign, short intVAlign, int intFontSize){
        cellStyle.setAlignment(intAlign);
        cellStyle.setVerticalAlignment(intVAlign);
        
        font.setFontName("Arial");
        font.setFontHeightInPoints((short) intFontSize);
        cellStyle.setFont(font);
    }
    
    /**--------------------------------------------------
     * Method Name    : CoverCellStyle
     * Description    : Cover Cell Style
     * Author         : yangjeongmo, 2015. 10. 30.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static void CoverCellStyle(HSSFWorkbook workbook, HSSFCellStyle cellStyle, short intAlign, short intVAlign){
        cellStyle.setAlignment(intAlign);
        cellStyle.setVerticalAlignment(intVAlign);
        cellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
        cellStyle.setTopBorderColor(IndexedColors.BLACK.index);
        cellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
        cellStyle.setRightBorderColor(IndexedColors.BLACK.index);
        cellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
        cellStyle.setBottomBorderColor(IndexedColors.BLACK.index);
        cellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
        cellStyle.setLeftBorderColor(IndexedColors.BLACK.index);
    }
    
    /**--------------------------------------------------
     * Method Name    : CoverCellStyle
     * Description    : Cover Cell Style (Include Font Size)
     * Author         : yangjeongmo, 2015. 10. 30.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static void CoverCellStyle(HSSFWorkbook workbook, HSSFCellStyle cellStyle, HSSFFont font, short intAlign, short intVAlign, int intFontSize){
        cellStyle.setAlignment(intAlign);
        cellStyle.setVerticalAlignment(intVAlign);
        
        font.setFontHeightInPoints((short) intFontSize);
        cellStyle.setFont(font);
    }
    
    /**--------------------------------------------------
     * Method Name    : SetTCPMessage
     * Description    : 전문 생성
     * Author         : ymjo, 2015. 11. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String SetTCPMessage(Object objMessage, int intLen)
    {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(objMessage.toString());
        
        if (objSb.length() < intLen) {
            for(int i=0; i<(intLen - objSb.length()); i++) {
                objSb.append(" ");
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSHA512HashKey
     * Description    : 가맹점키 생성
     * Author         : ymjo, 2015. 11. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantSHA512HashKey() {
        String strRetValue  = "";
        Date currentDate    = new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMddhhmmss");
        
        try {
            strRetValue = Base64.encode(DigestUtils.sha512(CommonConstants.SHA512_SALT_KEY + df.format(currentDate)));            
        } catch(Exception ex) {
            strRetValue = "";
        }
        
        return strRetValue;
    }
    
    /**--------------------------------------------------
     * Method Name    : encryptSHA512HashKey
     * Description    : 이용자 비밀번호 생성
     * Author         : yangjeongmo, 2015. 12. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String encryptSHA512HashKey(String strUsrPSWD) {
        String strRetValue  = "";
        
        try {
            strRetValue = Base64.encode(DigestUtils.sha512(CommonConstants.ENCRYPT_KEY + strUsrPSWD));            
        } catch(Exception ex) {
            strRetValue = "";
        }
        
        return strRetValue;
    }
    
    /**--------------------------------------------------
     * Method Name    : mmsLoginToken
     * Description    : MMS 로그인 토큰
     * Author         : ymjo, 2015. 11. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String mmsLoginToken(String strIMID, String strExpireDateTime) {
        String strRetValue  = "";
        
        try {
            strRetValue = Base64.encode(DigestUtils.sha512(strIMID + CommonConstants.SHA512_SALT_KEY + strExpireDateTime));
        } catch(Exception ex) {
            strRetValue = "";
        }
        
        return strRetValue;
    }
    
    /**--------------------------------------------------
     * Method Name    : ConvertMessageDataToMap
     * Description    : 
     * Author         : ymjo, 2015. 11. 30.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static Map<String, String> ConvertMessageDataToMap(List<Map<String,Object>> objMapList) {
        Map<String, String> objRetMap = new HashMap<String, String>();
        
        try {
            for(Map<String, Object> objMap : objMapList) {
                objRetMap.put(objMap.get("MESSAGE_CODE").toString(), objMap.get("MESSAGE").toString());                
            }
        } catch(Exception ex) {
            objRetMap = new HashMap<String, String>();
        }
        
        return objRetMap;
    }
    
    /**--------------------------------------------------
     * Method Name    : SetLocale
     * Description    : 
     * Author         : ymjo, 2015. 12. 1.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static void SetLocale(String strLanguageCode) {
        switch(strLanguageCode) {
            case "en" :
                Locale.setDefault(Locale.ENGLISH);
                break;

            case "ko" :
                Locale.setDefault(Locale.KOREAN);
                break;

            case "in" :
                Locale locale = new Locale("in", "Indonesian");
                Locale.setDefault(locale);
                break;

            default :
                Locale.setDefault(Locale.ENGLISH);
                break;
        }
    }
    
    /**--------------------------------------------------
     * Method Name    : SetCookie
     * Description    : 
     * Author         : ymjo, 2015. 12. 21.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static void SetCookie(String strCookieName, String strCookieValue, int intCookieExp, HttpServletResponse response) {
        Cookie cookie = new Cookie(strCookieName, strCookieValue);
        cookie.setPath("/");
        cookie.setMaxAge(intCookieExp);
        response.addCookie(cookie);
    }
    
    /**--------------------------------------------------
     * Method Name    : CreateRandomPwd
     * Description    : 
     * Author         : jjho, 2016. 10. 25.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String GetRndPwd() {
    	Random rnd = new Random();		
		StringBuffer rndPwd =new StringBuffer();
		 
		for(int i=0;i<8;i++){
		    if(rnd.nextBoolean()){
		    	rndPwd.append((char)((int)(rnd.nextInt(26))+97));
		    }else{
		    	rndPwd.append((rnd.nextInt(10))); 
		    }
		}
    	
    	return rndPwd.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : check password validation
     * Description    : 
     * Author         : jjho, 2016. 11. 23.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static boolean pswdValidation(String pswd){
    	if(pswd.matches(".*[^a-zA-Z0-9\\!\\@\\#\\$\\%\\^\\&\\*].*")){	// Check if there is something other than
    		return false;
    	}
    	/*if(!pswd.matches(".*[A-Z].*")){	// check uppercase
    		return false;
    	}
    	if(!pswd.matches(".*[a-z].*")){	// check lowercase
    		return false;
    	}*/
    	if(!pswd.matches(".*[0-9].*")){	// check digit
    		return false;
    	}
		if(!pswd.matches(".*[\\!\\@\\#\\$\\%\\^\\&\\*].*")){	// check special character
			return false;
		}
		if(pswd.length() < 8 || pswd.length() > 20 ){	// check length
			return false;
		}
		
    	return true;
    }
    
    /**--------------------------------------------------
     * Method Name    : diffOfDate
     * Description    : diff of two days
     * Author         : jjho, 2016. 12. 02.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    
    public static long diffOfDate(String begin, String end) throws Exception {
      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
   
      Date beginDate = formatter.parse(begin);
      Date endDate = formatter.parse(end);
   
      long diff = endDate.getTime() - beginDate.getTime();
      long diffDays = diff / (24 * 60 * 60 * 1000);
   
      return diffDays;
    }
    
    /**--------------------------------------------------
     * Method Name    : strToday
     * Description    : return today to string('yyyymmdd')
     * Author         : jjho, 2016. 12. 02.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    
    public static String strToday(){
    	return new SimpleDateFormat("yyyyMMdd").format(new Date());
    }
    //yyyy/mm/dd -> yyymmdd 로 replace
    public static String repYMD(String strDate){
    	String date = null;
    	
    	date = strDate.replaceAll("(\\d+)/(\\d+)/(\\d+)", "$1$2$3" );
    	
    	return date;
    }
    
    
    /**
     * 사업자번호 및 주민번호(국내/외) 확인
     *@param String       : 대상 문자열<br>
     *@return boolean     : 자리수에 따라 유효할 경우 true<br>
     */
  	public boolean Regist_Check(String iDate){
  		
  		String reName = "";
  		boolean reBool = false;
  		int sum = 0;
  		int num = 0;
  		String  inx = "137137135";
  		int sidliy = 0;        
  		int sidchk = 0;    
  		if(iDate != null){
  			if(iDate.length() == 10){	// 사업자 번호 체크
  				
  				
  					for(int i=0; i<9; i++){
  						sum += Integer.parseInt(iDate.substring(i,i+1)) * Integer.parseInt(inx.substring(i,i+1));
  					}
  					
  					 sum = sum + (Integer.parseInt(iDate.substring(8,9))*5)/10;
  					 sidliy = sum % 10;        
  					 sidchk = 0;        
  					 if(sidliy != 0) { 
  					 	sidchk = 10 - sidliy; 
  					 }else { 
  					 	sidchk = 0; 
  					 }
  					 if(sidchk != Integer.parseInt(iDate.substring(9,10))) { 
  					 		reBool = false;
  					 }else{
  					 		reBool = true;
  					 }
  			}else if(iDate.length() == 13){ 	// 주민번호 체크
  				if(iDate.substring(6,7).equals("1")||iDate.substring(6,7).equals("2")||iDate.substring(6,7).equals("3")||iDate.substring(6,7).equals("4")){

  					for(int i=0;i<8;i++){ 
  						sum+=Integer.parseInt(iDate.substring(i,i+1))*(i+2); 
  					}
  					for(int i=8;i<12;i++){ 
  						sum+=Integer.parseInt(iDate.substring(i,i+1))*(i-6); 
  					}
  					sum=11-(sum%11);
  					if (sum>=10) { sum-=10; }
  					if (Integer.parseInt(iDate.substring(12,13)) != sum || (Integer.parseInt(iDate.substring(6,7)) !=1 && Integer.parseInt(iDate.substring(6,7)) != 2 && Integer.parseInt(iDate.substring(6,7)) != 3 && Integer.parseInt(iDate.substring(6,7)) != 4 ) ){
  						reBool = false;
  					}else{
  						reBool = true;
  					}
  				}else{	// 외국인 주민번호
  					sum=0; 
  					int odd=0; 
  					int i=0;
  					int j=0;
  					int[] buf = new int[13]; 
  					
  					for(i=0; i<13; i++) { buf[i]=Integer.parseInt(iDate.substring(i,i+1)); } 
  					odd = buf[7]*10 + buf[8]; 
  					if(odd%2 != 0) {	j++;	} 
  					if( (buf[11]!=6) && (buf[11]!=7) && (buf[11]!=8) && (buf[11]!=9) ) { j++;	}
  					
  					int multiplier[] = {2,3,4,5,6,7,8,9,2,3,4,5};
  					for(i=0, sum=0; i<12; i++) { 
  						sum += (buf[i] *= multiplier[i]); 
  					} 
  					sum = 11 - (sum%11); 
  					if(sum >= 10) { sum -= 10; }
  					sum += 2; 
  					if(sum >= 10) { sum -= 10; } 
  					if(sum != buf[12]) { j++; }
  					
  					if(j==0) reBool = true;
  				}
  			}
  		}
  		return reBool;
  	}
  	 /**
     * 숫자여부 확인
     *@param String       : 대상 문자열<br>
     *@return boolean     : 숫자만으로 이루어졌을경우 true<br>
     */
    public boolean ChkNum(String inStr) {
    
      boolean reBool = false;
      
      if(inStr.equals("") || inStr == null) return reBool;
    
     	for(int i = 0; i < inStr.length(); i++)
      {
        if(inStr.substring(i, i+1).compareTo("0") < 0 || inStr.substring(i, i+1).compareTo("9") > 0) return reBool;    
      }
    
      return true;
    }  
  	/**
    /**
     * 휴대폰 유효여부 확인
     *@param String       : 대상 문자열<br>
     *@return boolean     : 국번이 유효할 경우 true<br>
     */
    public boolean HhpNum_Check(String iDate) {
      String strTmp = iDate.substring(0, 3);
       boolean reBool = false;
    
    	if(ChkNum(iDate)) {
    
    		if(iDate.length() == 10 || iDate.length() == 11) {
    
    				  if(strTmp.equals("010") || strTmp.equals("011") ||
    					 strTmp.equals("016") || strTmp.equals("017") ||
    					 strTmp.equals("018") || strTmp.equals("019")){
    					 reBool = true;
    				  }
    		}
      }
      return reBool;
    }
    
	public static String clobToString(Clob clob) throws SQLException, IOException {

		if (clob == null) {
			return "";
		}

		StringBuffer strOut = new StringBuffer();

		String str = "";

		BufferedReader br = new BufferedReader(clob.getCharacterStream());

		while ((str = br.readLine()) != null) {
			strOut.append(str);
		}
		return strOut.toString();
	}
	
	public static String listmap_to_json_string(List<Map<String, Object>> list) {
		JSONArray json_arr = new JSONArray();
		for(Map<String, Object> map : list) {
			JSONObject json_obj = new JSONObject();
			for(Map.Entry<String, Object> entry : map.entrySet()) {
				String key = entry.getKey();
				Object value = entry.getValue();
				try {
					json_obj.put(key, value);
				}catch(JSONException e) {
					e.printStackTrace();
				}
			}
			json_arr.add(json_obj);
		}
		return json_arr.toString();
	}
	
	/**--------------------------------------------------
     * Method Name    : availMIDInquiry
     * Description    : MID 조회 권한 확인
     * Author         : ymjo, 2015. 11. 11.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static boolean availMIDInquiry(Object objMIDList, Object objReqMID) {
        boolean isInquiry = false;
        
        String strReqMID  = "";        
        String[] arrMIDList;
        
        try {
            arrMIDList = objMIDList.toString().split(",");
            strReqMID  = objReqMID.toString();
            
            for(int i=0; i<arrMIDList.length; i++) {
                if (arrMIDList[i].equals(strReqMID)) {
                    isInquiry = true;
                    break;
                }
            }            
        } catch(Exception ex) {
            isInquiry = false;
        }
        
        return isInquiry;
    }
	
    //mask_cd  고객명 : name, 이메일 : email, 전화번호 : phone
	public static String getMaskedStr(String strData, String mask_cd){
		
		String replaceStr =  "";
		String pattern = "";
		 
		if(strData != null || "".equals(strData) == false){
			switch (mask_cd) {
			case "name"://외자이름 : 이름 * 처리, 3글자 이상 : 성과 마지막 글자의 중간부분을 모두 마스킹 (ex: 김일 -> 김*, 김일이 -> 김*이, 김일이삼 -> 김**삼)
					if(strData.length() == 2){
						pattern = "^(.)(.+)$";
					}else{
						pattern = "^(.)(.+)(.)$";
					}
					
					Matcher matcher1 = Pattern.compile(pattern).matcher(strData);
					
					if(matcher1.matches()){
						replaceStr = "";
						
						for(int i=1; i<=matcher1.groupCount(); i++){
							String replaceTarget = matcher1.group(i);
							if(i == 2){
								char[] c = new char[replaceTarget.length()];
								Arrays.fill(c, '*');
								
								replaceStr = replaceStr + String.valueOf(c);
							}else{
								replaceStr = replaceStr + replaceTarget;
							}
						}
					}
				
				break;
			
			case "email"://앞 두 자리를 제외한 나머지 마스킹 (ex: abcd12@naver.com -> ab****@naver.com)					
					pattern = "\\b(\\S+)+@(\\S+.\\S+)";									
					Matcher matcher2 = Pattern.compile(pattern).matcher(strData);
					
					if(matcher2.find()){
						replaceStr = matcher2.group(1);					
						StringBuilder builder = new StringBuilder(replaceStr);
						
						for(int i=0; i < replaceStr.length(); i++){
							if(i >= 2){
								builder.setCharAt(i, '*');
							}
						}
						replaceStr = builder.toString() +"@"+ matcher2.group(2);											
					}
				break;
			
			case "phone"://뒤에서 세번째 자리부터 4자리 마스킹 (ex: 01012345678 -> 01012****78, 0212345678 -> 0212****78)
				replaceStr = strData.replaceAll("-", "");
				pattern = "^\\d+$";
				
				Matcher matcher3 = Pattern.compile(pattern).matcher(replaceStr);
				
				if(matcher3.matches()){
					StringBuilder builder = new StringBuilder(replaceStr);
					builder.replace(replaceStr.length()-6, replaceStr.length()-2, "****");
					replaceStr = builder.toString();
				}
				
				break;
			}
		}
		System.out.print(replaceStr);
		return replaceStr;
	}
	
	/**
	  * 숫자에 천단위마다 콤마 넣기
	  * @param int
	  * @return String
	  * */
	public static String amtCommaFormat(String num) {
	  DecimalFormat df = new DecimalFormat("#,###");
	  
	  return df.format(Integer.parseInt(num));
	 }
}