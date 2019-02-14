package egov.linkpay.ims.common.common;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonDDLB.java
 * Description    : Create DropDownLit
 * Author         : yangjeongmo, 2015. 10. 7.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CommonDDLB {
    /**------------------------------------------------------------
     * Package Name   : egov.linkpay.ims.common.common
     * File Name      : CommonDDLB.java
     * Description    : 
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ------------------------------------------------------------*/
    public enum DDLBType
    {        
        EDIT,
        SEARCH,
        ALL,
        CHECK,
        CHOICE,
        DEFAILT
    }
    
    /**--------------------------------------------------
     * Method Name    : GetMakeOption
     * Description    : Get Option Html
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : ymjo, 2015. 10. 28.
     ----------------------------------------------------*/
    private static String makeOption(String strOptionValue, String strOptionText) {
        return String.format("<option value='%s'>%s</option>", strOptionValue, strOptionText);
    }
    
    /**--------------------------------------------------
     * Method Name    : GetMakeOption Override
     * Description    : Get Option Html
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : ymjo, 2015. 10. 28.
     ----------------------------------------------------*/
    private static String makeOption(String strOptionValue, String strOptionText, boolean selected) {
        return String.format("<option value='%s' %s>%s</option>", strOptionValue, (selected ? "selected" : ""), strOptionText);
    }
    
    /**--------------------------------------------------
     * Method Name    : setDDLBType
     * Description    : 등록/수정/조회 구분에 다른 기본값 설정
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static StringBuilder setDDLBType(StringBuilder objSb, DDLBType ddlbType) {
        switch(ddlbType)
        {
            case EDIT :
                objSb.append(makeOption("", ""));
                break;
            
            case SEARCH :
                objSb.append(makeOption("ALL", CommonMessageDic.getMessage("DDLB_0001"), true));
                break;
            
            case ALL :
	            objSb.append(makeOption("ALL", CommonMessageDic.getMessage("IMS_BIM_BM_0284")));
	            break;
	       
            case CHECK :
	            objSb.append(makeOption("", CommonMessageDic.getMessage("IMS_BIM_BM_0144")));
	            break; 
            
            case CHOICE :
	            objSb.append(makeOption("", CommonMessageDic.getMessage("IMS_BIM_BM_0079")));
	            break;   
            
            case DEFAILT :
	            objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0001")));
	            break;   
	            
            default :
                objSb.append(makeOption("", ""));
                break;
        }
        
        return objSb;
    }
    
    /**--------------------------------------------------
     * Method Name    : baseInfo
     * Description    : Menu Group
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String baseInfo(List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("", ""));
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(makeOption(objMap.get("MENU_GRP_NO").toString(), CommonMessageDic.getMessage(objMap.get("MENU_GRP_NM").toString())));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : menuGroup
     * Description    : Menu Group
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String menuGroup(List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("", ""));
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(makeOption(objMap.get("MENU_GRP_NO").toString(), CommonMessageDic.getMessage(objMap.get("MENU_GRP_NM").toString())));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantID
     * Description    : Merchant List
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String menuMerchantID(List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(String.format("<li class='item' id='%s'>%s(%s)</li>", objMap.get("I_MID").toString(), objMap.get("I_MID").toString(), objMap.get("MER_NM").toString()));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : menuAuth
     * Description    : Menu Auth
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String menuAuth(List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("", ""));
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(makeOption(objMap.get("AUTH_NO").toString(), objMap.get("AUTH_NM").toString()));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : menuType
     * Description    : Menu Type
     * Author         : yangjeongmo, 2015. 10. 14.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String menuType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0002")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0003")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantID
     * Description    : Search Merchant ID
     * Author         : yangjeongmo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantID(DDLBType ddlbType, List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(makeOption(objMap.get("I_MID").toString(), objMap.get("MER_NM").toString() + "(" + objMap.get("I_MID").toString() + ")" ));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : BankCode
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String BankCode(DDLBType ddlbType, List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(makeOption(objMap.get("BANK_CD").toString(), objMap.get("BANK_NM").toString()));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : BMID
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String BMID(DDLBType ddlbType, List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("", CommonMessageDic.getMessage("DDLB_0101")));
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(makeOption(objMap.get("B_MID").toString(), objMap.get("B_MID").toString() + "(" + objMap.get("B_MID_NM").toString() + ")" ));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : settlmntBank
     * Description    : 
     * Author         : kwjang, 2015. 11. 12.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String settlmntBank(DDLBType ddlbType, List<Map<String,Object>> objList) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        if (objList != null && objList.size() > 0) {
            for (Map<String, Object> objMap : objList) {
                objSb.append(makeOption(objMap.get("CODE1").toString(), objMap.get("DESC2").toString()));
            }
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : userAcctStatusType
     * Description    : User Account Status Type
     * Author         : yangjeongmo, 2015. 10. 14.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String userAcctStatusType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0004")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0005")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : boardType
     * Description    : 구분
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String boardType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0006")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0007")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0008")));
        objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0009")));
        objSb.append(makeOption("5", CommonMessageDic.getMessage("DDLB_0010")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : boardTypeForNotice
     * Description    : 공지사항 - 구분
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String boardTypeForNotice(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0011")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0012")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0013")));
        objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0014")));
        objSb.append(makeOption("5", CommonMessageDic.getMessage("DDLB_0015")));
        objSb.append(makeOption("6", CommonMessageDic.getMessage("DDLB_0010")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : boardTypeForArchives
     * Description    : 자료실 - 구분
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String boardTypeForArchives(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0016")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0017")));
        
        return objSb.toString();
    }

    /**--------------------------------------------------
     * Method Name    : boardChannelForNotice
     * Description    : 공지사항 - 게시위치
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String boardChannelForNotice(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0018")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0019")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : boardChannelForInquiry
     * Description    : 문의 - 게시위치
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String boardChannelForInquiry(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0019")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0020")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0021")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : boardStatus
     * Description    : 공지사항 - 상태
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String boardStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0022")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0023")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : answerStatus
     * Description    : 문의 - 답변상태
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String answerStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0024")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0025")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : payMethod
     * Description    : 결제서비스
     * Author         : ymjo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String payMethod(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);

        objSb.append(makeOption("01", CommonMessageDic.getMessage("DDLB_0026")));
        objSb.append(makeOption("02", CommonMessageDic.getMessage("DDLB_0027")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : payMethodForBankInfoMgmt
     * Description    : 
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String payMethodForBankInfoMgmt(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();

        objSb.append(makeOption("01", CommonMessageDic.getMessage("DDLB_0026"), true));
        objSb.append(makeOption("02", CommonMessageDic.getMessage("DDLB_0027")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType1
     * Description    : Merchant Search Type 1
     * Author         : yangjeongmo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantType1(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
 
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0111")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0029")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0030")));
        objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0031")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType2
     * Description    : Merchant Search Type 2
     * Author         : hgkim, 2016. 06. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantType2(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_MM_0052")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0029")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0030")));
    	objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0031")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType2
     * Description    : Merchant Search Type 2
     * Author         : hgkim, 2016. 06. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantType3(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0137")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0138")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0139")));
    	objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_MM_0054")));
    	objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BM_CM_0012")));
    	
    	return objSb.toString();
    }
    public static String merchantType3_1() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0137")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0138")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0139")));
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_MM_0054")));
    	objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BM_CM_0012")));
    	
    	return objSb.toString();
    }
    /**--------------------------------------------------
     * Method Name    : merchantSearchType4
     * Description    : Merchant Search Type 4
     * Author         : ChoiIY, 2017. 04. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantType4(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0140")));
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0141")));
    	
    	return objSb.toString();
    }
    public static String merchantType4_1() {
    	StringBuilder objSb = new StringBuilder();

    	objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0140"), true));
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0141")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType5
     * Description    : Merchant Search Type 5
     * Author         : hgkim, 2016. 06. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantType5() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0137"), true));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0138")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0139")));
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_MM_0054")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType6
     * Description    : Merchant Search Type 6
     * Author         : ChoiIY, 2017. 04. 21.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantType6() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0137")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0138")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0139")));
    	
    	return objSb.toString();
    }
    
    
    public static String merchantType7(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0137")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0138")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0139")));
    	
    	return objSb.toString();
    }
    public static String merchantType8(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("mid", CommonMessageDic.getMessage("DDLB_0137")));
    	objSb.append(makeOption("gid", CommonMessageDic.getMessage("DDLB_0138")));
    	objSb.append(makeOption("vid", CommonMessageDic.getMessage("DDLB_0139")));
    	
    	return objSb.toString();
    }
    /**--------------------------------------------------
     * Method Name    : PaymentMethodSearchType
     * Description    : Payment Method Search Type
     * Author         : ChoiIY, 2017. 04. 20.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String paymentMethodSearchType(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);

    	objSb.append(makeOption("01", CommonMessageDic.getMessage("IMS_BM_MSG_0001")));	//이롬머니
    	/*objSb.append(makeOption("01", CommonMessageDic.getMessage("FN_0018")));
    	objSb.append(makeOption("02", CommonMessageDic.getMessage("IMS_BIM_MM_0150")));
    	objSb.append(makeOption("03", CommonMessageDic.getMessage("FN_0019")));
    	objSb.append(makeOption("04", CommonMessageDic.getMessage("IMS_BM_CM_0114")));
    	objSb.append(makeOption("05", CommonMessageDic.getMessage("IMS_BIM_MM_0151")));*/
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : NHCategoryList
     * Description    : NH Category List
     * Author         : ChoiIY, 2017. 04. 24.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String nHCategoryList() {
    	StringBuilder objSb = new StringBuilder();

    	for(int i = 0; i < 122;i++){
        	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("IMS_BIM_BIR_0" + String.format("%03d", i+42))));
    	}
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : currencyType
     * Description    : Currency Type
     * Author         : ChoiIY, 2017. 04. 25.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String currencyType(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_ER_0002")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : cardCompanyList
     * Description    : Card Company List
     * Author         : ChoiIY, 2017. 04. 26.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String cardCompanyList(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);

    	for(int i = 1; i < 9;i++){
        	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("IMS_BIM_CCS_001" + i)));
    	}
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : cardType
     * Description    : Card Type
     * Author         : ChoiIY, 2017. 04. 26.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String cardType(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);

    	for(int i = 1; i < 7;i++){
        	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("IMS_BIM_CCS_00" + String.format("%02d", i+18))));
    	}
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : foreignCardType
     * Description    : Foreign Card Type
     * Author         : ChoiIY, 2017. 04. 26.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String foreignCardType() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_CCS_0025")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_CCS_0026")));
    	
    	return objSb.toString();
    }
    
    public static String foreignCardTypeSet(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_CCS_0025")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_CCS_0026")));
    	
    	return objSb.toString();
    }
    
    //무이자 이벤트 상태
    public static String nonInstEventStatus(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("prev", CommonMessageDic.getMessage("IMS_BIM_BM_0547")));
    	objSb.append(makeOption("now", CommonMessageDic.getMessage("IMS_BIM_BM_0548")));
    	objSb.append(makeOption("end", CommonMessageDic.getMessage("IMS_BIM_BM_0549")));
    	return objSb.toString();
    }
    /**--------------------------------------------------
     * Method Name    : DepositLimit
     * Description    : Deposit Limit Days
     * Author         : ChoiIY, 2017. 04. 24.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String depositLimit() {
    	StringBuilder objSb = new StringBuilder();

    	for(int i = 175; i < 209;i++){
        	objSb.append(makeOption(Integer.toString(i-175), CommonMessageDic.getMessage("IMS_BIM_BIR_0" + String.format("%03d", i))));
    	}
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : HistoryType
     * Description    : History Type
     * Author         : ChoiIY, 2017. 04. 21.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String historyType() {
    	StringBuilder objSb = new StringBuilder();

    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_HS_0007"), true));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_HS_0008")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_HS_0009")));
    	objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_HS_0010")));
    	objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BIM_HS_0011")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : COMPANY_TYPE
     * Description    : Company Search Type
     * Author         : ChoiIY, 2017. 04. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String companyType(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_MM_0128")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("FN_0008")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("FN_0009")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : OPEN MARKET SETTLEMENT
     * Description    : OPEN MARKET SETTLEMENT Type
     * Author         : ChoiIY, 2017. 04. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String OM_SETTL_TYPE(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0048")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0047")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : SHOP TYPE
     * Description    : Shop Type
     * Author         : ChoiIY, 2017. 04. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String shopType(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_MM_0153")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_MM_0154")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : USE STATUS 2
     * Description    : Use Status 2
     * Author         : ChoiIY, 2017. 04. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String useStatus2(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_MM_0036")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_MM_0037")));
    	objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_MM_0038")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : notiStatus
     * Description    : notiStatus Search Type 2
     * Author         : hgkim, 2017. 02. 07.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String notiStatus() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0127")));
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0128")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0129"), true));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType2
     * Description    : Merchant Search Type 2
     * Author         : hgkim, 2016. 06. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String testMidYn() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0105"), true));
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0106")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType2
     * Description    : Merchant Search Type 2
     * Author         : yangjeongmo, 2015. 10. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantSearchType2(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
 
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0028")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0029")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0031")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantSearchType3
     * Description    : 
     * Author         : kwjang, 2015. 11. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantSearchType3(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
 
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0031")));
        //objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0111")));	// 브랜드명
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0028")));	// 가맹점명
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0032")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantType
     * Description    : Merchant Type
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", "MA"));
        objSb.append(makeOption("2", "PG"));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantTypeByDefaultEmpty
     * Description    : Merchant Type
     * Author         : hgkim, 2016. 05. 03.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantTypeByDefaultEmpty() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("", "", true));
    	objSb.append(makeOption("1", "MA"));
    	objSb.append(makeOption("2", "PG"));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantTypeForBankInfoMgmt
     * Description    : 
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantTypeForBaseInfoMgmt(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
 
        objSb.append(makeOption("1", "MA"));
        objSb.append(makeOption("2", "PG"));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : recieveChannel
     * Description    : 영업 채널
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String recieveChannel1(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0033")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0020")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0034")));
        objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0035")));
        
        return objSb.toString();
    }
    
    public static String recieveChannel2(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0033")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0020")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0034")));
        objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0035")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : contractDocRecieveFlag
     * Description    : 계약서 수취 여부
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String contractDocRecieveFlag(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0036")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0037")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : contractStatus
     * Description    : 계약 상태
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String contractStatus() {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0038")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0039")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : confirmLine
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String confirmLine(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0040"), true));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : settleCycleByCreditCard
     * Description    : 신용카드 정산 주기
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String settleCycleByCreditCard(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("D2",  "D+2"));
        objSb.append(makeOption("D3",  "D+3"));
        objSb.append(makeOption("D4",  "D+4"));
        objSb.append(makeOption("D5",  "D+5"));
        objSb.append(makeOption("D6",  "D+6"));
        objSb.append(makeOption("D7",  "D+7"));
        objSb.append(makeOption("D8",  "D+8"));
        objSb.append(makeOption("D9",  "D+9"));
        objSb.append(makeOption("D10", "D+10"));
        objSb.append(makeOption("W1",  CommonMessageDic.getMessage("DDLB_0041")));
        objSb.append(makeOption("M1",  CommonMessageDic.getMessage("DDLB_0042")));
        objSb.append(makeOption("M2",  CommonMessageDic.getMessage("DDLB_0043")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : settleCycleByVAcct
     * Description    : 가상계좌 정산 주기
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String settleCycleByVAcct(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("D1",  "D+1"));
        objSb.append(makeOption("D2",  "D+2"));
        objSb.append(makeOption("D3",  "D+3"));
        objSb.append(makeOption("D4",  "D+4"));
        objSb.append(makeOption("D5",  "D+5"));
        objSb.append(makeOption("D6",  "D+6"));
        objSb.append(makeOption("D7",  "D+7"));
        objSb.append(makeOption("D8",  "D+8"));
        objSb.append(makeOption("D9",  "D+9"));
        objSb.append(makeOption("D10", "D+10"));
        objSb.append(makeOption("W1",  CommonMessageDic.getMessage("DDLB_0041")));
        objSb.append(makeOption("M1",  CommonMessageDic.getMessage("DDLB_0042")));
        objSb.append(makeOption("M2",  CommonMessageDic.getMessage("DDLB_0043")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : corporateType
     * Description    : 법인 구분
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String corporateType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0044")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0045")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : merchantStatus
     * Description    : 가맹점 상태
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0004")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0005")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0046")));
        
        return objSb.toString();
    }
    
    public static String merchantStatusForMerchant(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0004"), true));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0005")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0046")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : applyFlag
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String applyFlag(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0047"), true));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0048")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : limitFlag
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String limitFlag(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0049"), true));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0050")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : settleMethod
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String settleMethod(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0051")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0030")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : taxIssueType
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String taxIssueType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0052")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0008")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : taxIssueMethod
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String taxIssueMethod(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0051")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0030")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0031")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : useStatus
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String useStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0004")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0053"), true));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : useStatus
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String useTopUpStatus() {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0053"), true));
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0004")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : authType
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String authType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", "VISA3D", true));
        objSb.append(makeOption("2", "KEYIN"));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : migs authType
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String migsAuthType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("3", "2.0 Party"));
        objSb.append(makeOption("4", "3.0 Party"));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : authTypeForBankInfoMgmt
     * Description    : 인증유형 - 은행정보관리
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String authTypeForBankInfoMgmt(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", "ISO(VISA3D)"));
        objSb.append(makeOption("2", "ISO(KEYIN)"));
        objSb.append(makeOption("3", "MIGS(2.0 Party)"));
        objSb.append(makeOption("4", "MIGS(3.0 Party)"));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : vacctType
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String vacctType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0054")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0055"), true));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0102")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : vacctTypeForBankInfoMgmt
     * Description    : 채번방식 - 은행정보관리
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String vacctTypeForBankInfoMgmt(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0054")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0055")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : depositTerm
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String depositTerm(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        for ( int i = 1; i < 31; i++) {
            objSb.append(makeOption(Integer.toString(i), "D+" + Integer.toString(i)));
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : vacctAmtChkCl
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String vacctAmtChkCl(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0056")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0057"), true));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : checkFlg
     * Description    : 체크 여부
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String checkFlg(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0056")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0057")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : installmentMonth
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String installmentMonth(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("", CommonMessageDic.getMessage("DDLB_0101")));
        
        for ( int i = 2; i < 25; i++) {
            objSb.append(makeOption(Integer.toString(i), Integer.toString(i) + CommonMessageDic.getMessage("DDLB_0058")));
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : feeType
     * Description    : 
     * Author         : kwjang, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String feeType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0059")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0060")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : transactionStatus
     * Description    : 통합거래조회 - 통합 상태
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String transactionStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
 
        objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0107")));
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0108")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0064")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : transactionCardStatus
     * Description    : 통합거래조회 - 신용카드 상태
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String transactionCardStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
 
        objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0052")));
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0063")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0064")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : transactionVacctStatus
     * Description    : 통합거래조회 - 가상계좌 상태
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String transactionVacctStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
         
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0065")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0066")));
        objSb.append(makeOption("3", "Reversal"));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : transactionVacctStatus
     * Description    : 통합거래조회 - 가상계좌 상태
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String transactionVacctStatusByNumber(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0065")));
    	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0066")));
    	objSb.append(makeOption("3", "Reversal"));
    	objSb.append(makeOption("4", CommonMessageDic.getMessage("FN_0032")));
    	objSb.append(makeOption("5", CommonMessageDic.getMessage("DDLB_0109")));
    	objSb.append(makeOption("6", CommonMessageDic.getMessage("DDLB_0100")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : payType
     * Description    : Pay Type
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String payType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0067")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0068")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : instmntType
     * Description    : Instmnt Type
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String instmntType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0069")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0011")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : instmntType
     * Description    : Instmnt Type
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String addNotUseInstmntType() {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0053")));
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0069")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0011")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : limitType
     * Description    : Limit Type
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String limitType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0052")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0070")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : transBlFlg
     * Description    : Trans Bl Flg
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String transBlFlg(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0071")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0072")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : limitTerm
     * Description    : Limit Term
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String limitTerm(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0073")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0074")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : alramRecvFlg
     * Description    : Alram Recv Flg
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String alramRecvFlg(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0075")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0076")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : increaseType
     * Description    : Increase Type
     * Author         : ywkim, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String increaseType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0077"), true));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0078")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectYear
     * Description    : selectYear
     * Author         : ymjo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectYear(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        Date currentDate    = new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyy");
        int intStartYear    = Integer.parseInt(df.format(currentDate));
        int intLoopYear     = 0;
        
        for (int i=1; i<=15; i++) {
            intLoopYear = intStartYear + i;
            objSb.append(makeOption(Integer.toString(intLoopYear), Integer.toString(intLoopYear) + CommonMessageDic.getMessage("DDLB_0091")));
        }
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectMonth
     * Description    : selectMonth
     * Author         : ymjo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectMonth(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("01", CommonMessageDic.getMessage("DDLB_0079")));
        objSb.append(makeOption("02", CommonMessageDic.getMessage("DDLB_0080")));
        objSb.append(makeOption("03", CommonMessageDic.getMessage("DDLB_0081")));
        objSb.append(makeOption("04", CommonMessageDic.getMessage("DDLB_0082")));
        objSb.append(makeOption("05", CommonMessageDic.getMessage("DDLB_0083")));
        objSb.append(makeOption("06", CommonMessageDic.getMessage("DDLB_0084")));
        objSb.append(makeOption("07", CommonMessageDic.getMessage("DDLB_0085")));
        objSb.append(makeOption("08", CommonMessageDic.getMessage("DDLB_0086")));
        objSb.append(makeOption("09", CommonMessageDic.getMessage("DDLB_0087")));
        objSb.append(makeOption("10", CommonMessageDic.getMessage("DDLB_0088")));
        objSb.append(makeOption("11", CommonMessageDic.getMessage("DDLB_0089")));
        objSb.append(makeOption("12", CommonMessageDic.getMessage("DDLB_0090")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectTypeByPerformanceMgmt
     * Description    : 
     * Author         : kwjang, 2015. 12. 15.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectTypeByPerformanceMgmt(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_PV_MP_0025"), true));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_PV_MP_0026")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_PV_MP_0027")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectTypeByPerformanceMgmt
     * Description    : 
     * Author         : hgkim, 2016. 03. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectTypeByAccountOption(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0103")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0104")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0115")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectTypeByAmountOption
     * Description    : 
     * Author         : hgkim, 2016. 03. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectTypeByAmountOption(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("0", "", true));
        objSb.append(makeOption("1", "Open Amount"));
        objSb.append(makeOption("2", "Close Amount"));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectTypeByAmountOptionBCA
     * Description    : 
     * Author         : hgkim, 2016. 05. 16.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectTypeByAmountOptionBCA(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	objSb.append(makeOption("0", "", true));
    	objSb.append(makeOption("1", "Open Amount"));
    	objSb.append(makeOption("2", "Close Amount"));
    	objSb.append(makeOption("3", "Variable Amount"));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectTypeByAccountOptionByAll
     * Description    : 
     * Author         : hgkim, 2016. 03. 28.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectTypeByAccountOptionByAll(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("", CommonMessageDic.getMessage("DDLB_0001"), true));
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0103")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0104")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0115")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : selectTypeByPerformanceMgmt
     * Description    : 
     * Author         : hgkim, 2016. 04. 12.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String selectTypeByChangePayment() {
        StringBuilder objSb = new StringBuilder();
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_MM_0036")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0053"), true));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : transactionStatus
     * Description    : 정산관리 - Reconcile 상태
     * Author         : yangjeongmo, 2015. 10. 7.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String reconsileStatus(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("FN_0030")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0112")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : va type
     * Description    : Bulk url mgmt - va type
     * Author         : jjho, 2016. 12. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String merchantVaType(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0125")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0126")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0116")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : emailType
     * Description    : emailTypeSelect
     * Author         : Ade Julianto, 2017. 01. 4.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String emailType1(DDLBType ddlbType) {
        StringBuilder objSb = new StringBuilder();
        
        setDDLBType(objSb, ddlbType);
        
        objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0117")));
        objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0118")));
        objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0119")));
        objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0130")));
        objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0131")));
        
        return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : useStatus
     * Description    : 
     * Author         : Ade Julianto, 2017. 01. 4.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String useEmailStatus(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0004"), true));
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0053")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : useStatus
     * Description    : 
     * Author         : jjho, 2017. 03. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String use_clStatus(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("0", CommonMessageDic.getMessage("DDLB_0004"), true));
    	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0053")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
     * Method Name    : UrlConnReqType
     * Description    : 
     * Author         : jjho, 2017. 01. 13.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public static String UrlConnReqType(DDLBType ddlbType) {
    	StringBuilder objSb = new StringBuilder();
    	
    	setDDLBType(objSb, ddlbType);
    	
    	objSb.append(makeOption("00", CommonMessageDic.getMessage("DDLB_0123")));
    	objSb.append(makeOption("01", CommonMessageDic.getMessage("DDLB_0124")));
    	
    	return objSb.toString();
    }
    
    /**--------------------------------------------------
    * Method Name    : country_cd
    * Description    : Search Country Code
    * Author         : Ade Julianto, 2017. 01. 12.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String countryCd(DDLBType ddlbType, List<Map<String,Object>> objList) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       if (objList != null && objList.size() > 0) {
           for (Map<String, Object> objMap : objList) {
           	if(!objMap.get("CTRY_VAL").equals("ID")){
           		objSb.append(makeOption(objMap.get("CTRY_VAL").toString(), objMap.get("DES").toString() + "(" + objMap.get("CTRY_CD").toString() + ")"));
           	}
           }
       }
       
       return objSb.toString();
   }
   
   /**--------------------------------------------------
    * Method Name    : cntLimit
    * Description    : Count Limit Select
    * Author         : Ade Julianto, 2017. 01. 4.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String countLimitSelect() {
   	StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", "1"));
       objSb.append(makeOption("2", "2"));
       objSb.append(makeOption("3", "3"));
       objSb.append(makeOption("4", "4"));
       objSb.append(makeOption("5", "5", true));
       
       return objSb.toString();
   }
   
   
   /**--------------------------------------------------
    * Method Name    : bizCd
    * Description    : Biz Code Select
    * Author         : Ade Julianto, 2017. 01. 17.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String bizCdSearch(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);

       objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0120")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0121")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0122")));
       
       return objSb.toString();
   }
   /**--------------------------------------------------
    * Method Name    : card certified list
    * Description    : card certified list
    * Author         : khj, 2017. 05. 02.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String cardCertList(DDLBType ddlbType) {
   	StringBuilder objSb = new StringBuilder();
   	
   	setDDLBType(objSb, ddlbType);
   	
   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BIR_0244")));
   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0208")));
   	objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0209")));
   	objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BM_0210")));
   	objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BIM_BM_0211")));
   	
   	return objSb.toString();
   }
   public static String merType(DDLBType ddlbType) {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	setDDLBType(objSb, ddlbType);
	   	
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0142")));
	   	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0143")));
	   	
	   	return objSb.toString();
	   }
   public static String pointType(DDLBType ddlbType) {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	setDDLBType(objSb, ddlbType);
	   	
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0142")));
	   	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0144")));
	   	
	   	return objSb.toString();
	   }
   public static String vanType(DDLBType ddlbType) {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	setDDLBType(objSb, ddlbType);
	   	
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BIR_0214")));
	   	
	   	return objSb.toString();
	   }
   public static String keyInList(DDLBType ddlbType) {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	setDDLBType(objSb, ddlbType);
	   	
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0393")));
	   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0394")));
	   	objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0395")));
	   	
	   	return objSb.toString();
	   }
   public static String depositCycle(DDLBType ddlbType) {
   	StringBuilder objSb = new StringBuilder();
   	
   	setDDLBType(objSb, ddlbType);

   	for(int i = 1; i < 9;i++){
       	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("DDLB_015" + i)));
   	}
   	
   	return objSb.toString();
   }
   public static String limitChk(DDLBType ddlbType) {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	setDDLBType(objSb, ddlbType);

	   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_PM_PV_0007"))); //승인
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0378")));//매입
	   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0391")));//일시불/한도
	   	
	   	return objSb.toString();
   }
   public static String typeFlg(DDLBType ddlbType) {
   	StringBuilder objSb = new StringBuilder();
   	
   	setDDLBType(objSb, ddlbType);
   	
   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0327")));
   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0328")));
   	
   	return objSb.toString();
   }
   public static String dateChk() {
	   	StringBuilder objSb = new StringBuilder();
	   	
//	   	setDDLBType(objSb, ddlbType);
	   	
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0307"), true));
	   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0306")));
	   	
	   	return objSb.toString();
   }
   //증권여부
   public static String flagChk() {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BM_CM_0121")));
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BM_CM_0122")));
	   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BM_CM_0123")));
	   	
	   	return objSb.toString();
  }
   //계약서 수취
   public static String contFlg() {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BM_CM_0001")));
	   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BM_CM_0002")));
	   	
	   	return objSb.toString();
  }
   //계약경로
   public static String contRoute() {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	for(int i = 3; i < 9;i++){
	       	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("IMS_BM_CM_013" + i)));
	   	}
	   	
	   	return objSb.toString();
  }
   //등록비 연운영비
   public static String useCash() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BM_CM_0121")));
       objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BM_CM_0142")));
       objSb.append(makeOption("10", CommonMessageDic.getMessage("IMS_BM_CM_0143")));
       objSb.append(makeOption("11", CommonMessageDic.getMessage("IMS_BM_CM_0144")));
       objSb.append(makeOption("15", CommonMessageDic.getMessage("IMS_BM_CM_0145")));
       objSb.append(makeOption("20", CommonMessageDic.getMessage("IMS_BM_CM_0146")));
       objSb.append(makeOption("22", CommonMessageDic.getMessage("IMS_BM_CM_0147")));
       
       return objSb.toString();
   }
   //공지사항 구분
   public static String notiDivision(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       for(int i = 1; i <7;i++){
	       	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("IMS_BM_NM_000" + i)));
	   	}
       objSb.append(makeOption("7", CommonMessageDic.getMessage("IMS_BM_NM_0030")));
       objSb.append(makeOption("8", CommonMessageDic.getMessage("IMS_BM_NM_0031")));
       return objSb.toString();
   }
   //공지사항 게시위치
   public static String notiLocation(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0019")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0020")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0021")));
       
       return objSb.toString();
   }
 //답변상태
   public static String askStatus(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       /*objSb.append(makeOption("00", CommonMessageDic.getMessage("IMS_BM_IM_0069")));
       objSb.append(makeOption("01", CommonMessageDic.getMessage("IMS_BM_IM_0070")));*/
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BM_IM_0009")));
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BM_IM_0010")));
       
       return objSb.toString();
   }
 //faq 구분
   public static String faqDivision(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BM_FAQ_0018")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BM_FAQ_0001")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BM_FAQ_0002")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BM_FAQ_0019")));
       objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BM_FAQ_0020")));
       objSb.append(makeOption("6", CommonMessageDic.getMessage("IMS_BM_FAQ_0004")));
       objSb.append(makeOption("7", CommonMessageDic.getMessage("IMS_BM_FAQ_0005")));
       return objSb.toString();
   }
 //faq 표시
   public static String faqFlag(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BM_FAQ_0022")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BM_FAQ_0023")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BM_FAQ_0024")));

       return objSb.toString();
   }
 //비밀번호 초기화 검색조건
   public static String searchFlg() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_PW_DE_09")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0195")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0142")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_MM_0054")));

       return objSb.toString();
   }
 //검색조건(계좌이체
   public static String OptionChk(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0204")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0160")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_PW_DE_12")));

       return objSb.toString();
   }
   //계좌이체 은행옵션
   public static String BankOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       for(int i = 0; i <9;i++){
	       	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("IMS_BIM_BM_022" + i)));
	   	}

       return objSb.toString();
   }
 //계좌이체 정산주기
   public static String SettleCycle(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0197")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0198")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0199")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BM_0200")));
       objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BIM_BM_0201")));
       objSb.append(makeOption("6", CommonMessageDic.getMessage("IMS_BIM_BM_0202")));
       objSb.append(makeOption("7", CommonMessageDic.getMessage("IMS_BIM_BM_0203")));

       return objSb.toString();
   }
 //계좌이체 상태
   public static String Status(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0174")));
       objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0063")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0064")));
       //objSb.append(makeOption("part", CommonMessageDic.getMessage("IMS_BIM_BM_0165")));

       return objSb.toString();
   }
 //계좌이체 에스크로
   public static String Escrow(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", "Y"));
       objSb.append(makeOption("0", "N"));

       return objSb.toString();
   }
 //계좌이체 경로
   public static String ConnFlg(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_MM_0154")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_MM_0033")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_MM_0034")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_MM_0006")));

       return objSb.toString();
   }
   //계좌이체 거래체크
   public static String DealFlg(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("real", CommonMessageDic.getMessage("IMS_BIM_BM_0206")));
       objSb.append(makeOption("test", CommonMessageDic.getMessage("IMS_BIM_BM_0207")));

       return objSb.toString();
   } 
   //계좌이체 거래체크
   public static String DateChk() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("trans", CommonMessageDic.getMessage("IMS_SM_SV_0010")));
       objSb.append(makeOption("app", CommonMessageDic.getMessage("IMS_BIM_BM_0212")));
       objSb.append(makeOption("cc", CommonMessageDic.getMessage("IMS_BIM_BM_0213")));
       
       return objSb.toString();
   } 
   //계좌이체 취소거래조건
   public static String RefSearchFlg(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0137")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0138")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0139")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BM_0083")));
       
       return objSb.toString();
   } 
   //계좌이체 취소거래옵션
   public static String RefOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0204")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0160")));
       
       return objSb.toString();
   } 
   //계좌이체 취소거래날짜체크
   public static String RefDateChk() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0213")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0189")));
       
       return objSb.toString();
   } 
 //신용카드 은행체크
   public static String CardSearch(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0088")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0089")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0090")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BM_0113")));
       objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BIM_BM_0114")));
       objSb.append(makeOption("6", CommonMessageDic.getMessage("IMS_BIM_BM_0115")));
       objSb.append(makeOption("7", CommonMessageDic.getMessage("IMS_BIM_BM_0116")));
       objSb.append(makeOption("8", CommonMessageDic.getMessage("IMS_BIM_BM_0117")));
       objSb.append(makeOption("9", CommonMessageDic.getMessage("IMS_BIM_BM_0118")));
       
       return objSb.toString();
   } 
 //신용카드 인증유형체크
   public static String FlgChk(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("AppNo", CommonMessageDic.getMessage("IMS_BIM_BM_0164")));
       objSb.append(makeOption("BuyerNm", CommonMessageDic.getMessage("IMS_BIM_BM_0204")));
       objSb.append(makeOption("GoodsAmt", CommonMessageDic.getMessage("IMS_BIM_BM_0160")));
       objSb.append(makeOption("CardNo", CommonMessageDic.getMessage("IMS_BIM_BM_0205")));
       objSb.append(makeOption("TID", CommonMessageDic.getMessage("IMS_PW_DE_12")));
       
       return objSb.toString();
   } 
 //승인한도 조회옵션
   public static String RMOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0083")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0142")));
       
       return objSb.toString();
   }
   //승인한도 날짜옵션
   public static String RMDateOption() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0276")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0277")));
       
       return objSb.toString();
   }
   //승인한도 등록옵션
   public static String RMRegOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0083")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0194")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0195")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BM_0196")));
       objSb.append(makeOption("5", CommonMessageDic.getMessage("IMS_BIM_BM_0285")));
      
       return objSb.toString();
   }
   //승인한도 거래차단여부
   public static String RMCutChk(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0278")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0279")));
       
       return objSb.toString();
   }
   //승인한도 결제수단
   public static String RMPayType(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("01", CommonMessageDic.getMessage("IMS_BIM_BM_0280")));
       objSb.append(makeOption("02", CommonMessageDic.getMessage("IMS_BIM_BM_0281")));
       objSb.append(makeOption("03", CommonMessageDic.getMessage("IMS_BIM_BM_0282")));
       objSb.append(makeOption("05", CommonMessageDic.getMessage("IMS_BIM_BM_0283")));
       
       return objSb.toString();
   }
   //승인한도 날짜옵션
   public static String RMDateChk() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0261")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0086")));
       
       return objSb.toString();
   }
 //승인한도 증액요청 조회 옵션
   public static String RMLimitOption() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0194")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0195")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0196")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BM_0083")));
       
       return objSb.toString();
   }
 //승인한도 증액요청 현재상태
   public static String RMStatus(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0286")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0287")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0288")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BM_0289")));
       
       return objSb.toString();
   }
 //승인한도 등록 안내소진율
   public static String RMExhRate(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0284")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0131")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0270")));
       
       return objSb.toString();
   }
 //승인한도 승인 개월수 
   public static String InstMon() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0290")));
       for(int i = 2; i <9;i++){
	       	objSb.append(makeOption(Integer.toString(i), CommonMessageDic.getMessage("IMS_BIM_BM_040" + i)));
	   	}
       objSb.append(makeOption("9", CommonMessageDic.getMessage("IMS_BIM_BM_0410")));
       objSb.append(makeOption("10", CommonMessageDic.getMessage("IMS_BIM_BM_0411")));
       objSb.append(makeOption("11", CommonMessageDic.getMessage("IMS_BIM_BM_0412")));
       
       return objSb.toString();
   }
 //승인한도 등록 금액제한
   public static String RMLimitCash() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0048")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0073")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0074")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("DDLB_0145")));
       
       return objSb.toString();
   }
 //승인한도 등록 횟수제한
   public static String RMLimitCount() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0048")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0073")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0074")));
       
       return objSb.toString();
   }
 //승인한도 발송체크
   public static String RMSendChk() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0296")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0414")));
       
       return objSb.toString();
   }
   //승인한도 안내대상
   public static String RMTarget() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0284")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0131")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0270")));
       
       return objSb.toString();
   }
 //통계 - 업체별 손익조회
   public static String TotalOption() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0194")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0196")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0083")));
       
       return objSb.toString();
   }
 //통계 - 업체별 손익조회 날짜체크
   public static String TotalDateChk() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0180")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0346")));
       
       return objSb.toString();
   }
 //통계 - 기간별 통계 조회옵션
   public static String EtcTotalOption() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0342")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0347")));
       
       return objSb.toString();
   }
   //카드승인한도 조회옵션
   public static String inquiryOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0376")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0377")));
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0378")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0379")));
       
       return objSb.toString();
   }
   //통화 
   public static String  CurrencyOptionSet(DDLBType ddlbType,List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();
	   setDDLBType(objSb, ddlbType);
	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "CODE1" ))));
       }
       
       return objSb.toString();
   }
   //통화
   public static String  CurrencyOption(List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();
	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "CODE1" ))));
       }
       
       return objSb.toString();
   }
   //카테고리(대) 
   public static String  ListOption(List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();
	   
	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC1" ))));
       }
       
       return objSb.toString();
   }
 //카테고리(소) 
   public static String  sListOption(List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();
       
	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE2" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC2" ))));
       }
       
       return objSb.toString();
   }
   //게시위치 all 제거  
   public static String  BoardList(List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();
	   
	   for(int i=1; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC1" ))));
       }
       
       return objSb.toString();
   }
   //tb_code code2 setting
   public static String  ListOptionCode2(List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   for(int i=0; i < listMap.size(); i++)
       {
		   if(i == 0 ){
			   objSb.append(makeOption(listMap.get( i ).get( "CODE2" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC2" ))));
		   }else{
			   objSb.append(makeOption(listMap.get( i ).get( "CODE2" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC2" ))));
		   }
       }
       
       return objSb.toString();
   }
   //tb_code code2 setting 
   public static String  ListOptionCode2Set(DDLBType ddlbType, List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   setDDLBType(objSb, ddlbType);

	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE2" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC2" ))));
       }
       
       return objSb.toString();
   }
   
   //tb_code setting 
   public static String  ListOptionSet(DDLBType ddlbType, List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   setDDLBType(objSb, ddlbType);

	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC1" ))));
       }
       
       return objSb.toString();
   }
   //tb_code setting 대리점 정산  이월내역 추가 세팅 
   public static String  ListOptionSetCode04(DDLBType ddlbType, List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   setDDLBType(objSb, ddlbType);

	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC1" ))));
       }
	   objSb.append(makeOption("04", CommonMessageDic.getMessage("IMS_BIM_BM_0629")));
       return objSb.toString();
   }
   //city bank 	tb_code setting 
   public static String  ListOptionSetCity(DDLBType ddlbType, List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   setDDLBType(objSb, ddlbType);

	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC1" ))));
       }
	   objSb.append(makeOption("11", CommonMessageDic.getMessage("IMS_BIM_BM_0551")));
	   objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BIR_0243")));
       return objSb.toString();
   }
   //city bank 	tb_code setting 
   public static String  ListOptionCity(List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   for(int i=0; i < listMap.size(); i++)
       {
       		objSb.append(makeOption(listMap.get( i ).get( "CODE1" ), CommonMessageDic.getMessage(listMap.get( i ).get( "DESC1" ))));
       }
	   objSb.append(makeOption("11", CommonMessageDic.getMessage("IMS_BIM_BM_0551")));
	   
       return objSb.toString();
   }
   //담당자 조회 
   public static String  MngOption(List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();
	   
	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "EMP_NO" ), CommonMessageDic.getMessage(listMap.get( i ).get( "EMP_NM" ))));
       }
       
       return objSb.toString();
   }
 //담당자 조회 
   public static String  MngOptionSet(DDLBType ddlbType, List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();
	   
	   setDDLBType(objSb, ddlbType);
	   
	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(listMap.get( i ).get( "EMP_NO" ), CommonMessageDic.getMessage(listMap.get( i ).get( "EMP_NM" ))));
       }
       
       return objSb.toString();
   }
   //acq_day
   public static String Acq_Day() {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	for(int i=1; i <= 10; i++)
       {
       	objSb.append(makeOption(Integer.toString(i), Integer.toString(i)));
       }
	   	
	   	return objSb.toString();
   }
   //gid list 
   public static String  GidListOption(DDLBType ddlbType, List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   setDDLBType(objSb, ddlbType);

	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(Integer.toString( i ), CommonMessageDic.getMessage(listMap.get( i ).get( "GID" ))));
       }
       
       return objSb.toString();
   }
 //vid list 
   public static String  VidListOption(DDLBType ddlbType, List< Map< String, String > > listMap) {
	   StringBuilder objSb = new StringBuilder();

	   setDDLBType(objSb, ddlbType);

	   for(int i=0; i < listMap.size(); i++)
       {
       	objSb.append(makeOption(Integer.toString( i ), CommonMessageDic.getMessage(listMap.get( i ).get( "VID" ))));
       }
       
       return objSb.toString();
   }
   //인증 방식 
   public static String AuthTypeOption(List< Map< String, String > > listMap) {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BIR_0243")));
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0540")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BIR_0244")));
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BIR_0244")+" " + CommonMessageDic.getMessage("IMS_BIM_BM_0540")));
       objSb.append(makeOption("4", CommonMessageDic.getMessage("IMS_BIM_BIR_0245")));
      
       return objSb.toString();
   }
   //취소 가능 여부  
   public static String CancelCdOption(List< Map< String, String > > listMap) {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0541")));
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0542")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0543")));
       objSb.append(makeOption("99", CommonMessageDic.getMessage("IMS_BIM_BM_0544")));
      
       return objSb.toString();
   }
   //보고서 작성 검색 조건   
   public static String ReportSearchOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("mid", CommonMessageDic.getMessage("IMS_BIM_BM_0194") , true));
       objSb.append(makeOption("gid", CommonMessageDic.getMessage("IMS_BIM_BM_0196")));
       objSb.append(makeOption("vid", CommonMessageDic.getMessage("IMS_BIM_BM_0195")));
      
       return objSb.toString();
   }
   
   //지급보고서 작성 조건   
   public static String TypeOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("none", CommonMessageDic.getMessage("IMS_SM_SRM_0032"), true));
       objSb.append(makeOption("resr", CommonMessageDic.getMessage("IMS_BIM_BM_0327")));
       objSb.append(makeOption("cc", CommonMessageDic.getMessage("IMS_BIM_BM_0328")));
       objSb.append(makeOption("extra", CommonMessageDic.getMessage("IMS_BIM_BM_0555")));
      
       return objSb.toString();
   }
   //지급보고서 작성 확정여부   
   public static String DecideOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0547")));//예정
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0568")));//담당확정
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0569")));//팀장확정
      
       return objSb.toString();
   }
   //지급보고서 작성 거래유형   
   public static String PayTypeOption() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("none", CommonMessageDic.getMessage("IMS_BIM_BM_0547")));//예정
       objSb.append(makeOption("om", CommonMessageDic.getMessage("IMS_BIM_BM_0568")));//담당확정
      
       return objSb.toString();
   }
   //미지급금등록 처리상태    
   public static String StatusOption(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0592")));//미지급
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0591")));//지급
      
       return objSb.toString();
   }
   //매입결과 처리상태    
   public static String StatusOption1(DDLBType ddlbType) {
       StringBuilder objSb = new StringBuilder();
       
       setDDLBType(objSb, ddlbType);
       
       objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0287")));//접수
       objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_BIM_BM_0093")));//반송
      
       return objSb.toString();
   }
   //반송조회/처리 거래구분
   public static String StateTypeOption(DDLBType ddlbType) {
   	StringBuilder objSb = new StringBuilder();
   	
   	setDDLBType(objSb, ddlbType);
   	
   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0174"))); //승인
   	objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0175"))); //취소
   	
   	return objSb.toString();
   }
   //대리점 정산 - 정산 재생성  검색조건 
   public static String SelectOption(DDLBType ddlbType) {
   	StringBuilder objSb = new StringBuilder();
   	
   	setDDLBType(objSb, ddlbType);
   	
   	objSb.append(makeOption("vid", CommonMessageDic.getMessage("DDLB_0139"), true)); //VID
   	
   	return objSb.toString();
   }
   //대리점 정산 - 보류/해제/별도가감/이월
   public static String YearOption() {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	Calendar cal = Calendar.getInstance();

	    int year = cal.get(Calendar.YEAR);
   		
	   	for(int i = 3; i >= 0; i--){
	       	objSb.append(makeOption(Integer.toString(year-i), Integer.toString(year-i)));
	   	}
	   	
	   	return objSb.toString();
   }
   public static String MonthOption() {
	   	StringBuilder objSb = new StringBuilder();

	   	String str = ""; 
	   	for(int i = 1; i <= 12;i++){
	   		str = String.format( "%02d", i);
	       	objSb.append(makeOption(str, str));
	   	}
	   	
	   	return objSb.toString();
  }
   //대리점 정산 - 정산 보고서 작성 구분값
   public static String TypeOption1(DDLBType ddlbType) {
   	StringBuilder objSb = new StringBuilder();
   	
   	setDDLBType(objSb, ddlbType);
   	
   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0574"))); //확정
   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0638"))); //미확정
   	
   	return objSb.toString();
   }
   //반송 조회/처리 - 입금보고서 구분값
   public static String AppDepRepOption() {
   		StringBuilder objSb = new StringBuilder();
   	
	   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_BM_0442"))); //반영
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0684"))); //미반영
	   	
	   	return objSb.toString();
   }
   //배치job 실행상태옵션 
   public static String JobUseOption() {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BAT_NM_0019"), true)); //미사용
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BAT_NM_0018"))); //사용
	   	
   	return objSb.toString();
   }
   //배치job 사용유무옵션
   public static String JobStateOption() {
	   	StringBuilder objSb = new StringBuilder();
	   	
	   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BAT_NM_0020"), true)); //대기중
	   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BAT_NM_0021"))); //실행중
	   	
   	return objSb.toString();
   }
   //배치job hist 성공여부
   public static String JobSuccessOption(DDLBType ddlbType) {
	   	StringBuilder objSb = new StringBuilder();
	   	
		setDDLBType(objSb, ddlbType);
	   	
	   	objSb.append(makeOption("Y", CommonMessageDic.getMessage("IMS_BAT_NM_0029"))); //성공
	   	objSb.append(makeOption("N", CommonMessageDic.getMessage("IMS_BAT_NM_0030"))); //실패
	   	
   	return objSb.toString();
   }
   
   /**--------------------------------------------------
    * Method Name    : paySearchType1
    * Description    : Pay Search Type 1
    * Author         : stlim, 2018. 09. 12.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String paySearchType1() {
   	StringBuilder objSb = new StringBuilder();
   	
   	objSb.append(makeOption("all", CommonMessageDic.getMessage("IMS_BIM_BM_0144"), true));	//선택하세요
   	objSb.append(makeOption("1", CommonMessageDic.getMessage("DDLB_0137")));
   	objSb.append(makeOption("2", CommonMessageDic.getMessage("DDLB_0138")));
   	objSb.append(makeOption("3", CommonMessageDic.getMessage("DDLB_0139")));
   	objSb.append(makeOption("0", CommonMessageDic.getMessage("IMS_BIM_MM_0054")));
   	
   	return objSb.toString();
   }
   
   /**--------------------------------------------------
    * Method Name    : paySearchType2
    * Description    : Pay Search Type 2
    * Author         : stlim, 2018. 09. 12.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String paySearchType2() {
   	StringBuilder objSb = new StringBuilder();
   	
   	objSb.append(makeOption("all", CommonMessageDic.getMessage("IMS_BIM_BM_0144"), true));	//선택하세요
   	objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0204")));	//구매자명
   	objSb.append(makeOption("2", "결제 시도금액"));	//결제 시도금액
   	objSb.append(makeOption("3", CommonMessageDic.getMessage("IMS_PW_DE_12")));		//TID
   	
   	return objSb.toString();
   }
   
   /**--------------------------------------------------
    * Method Name    : payFailDateChk
    * Description    : Pay Fail Search Date Type
    * Author         : stlim, 2018. 09. 12.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String payFailDateChk() {
       StringBuilder objSb = new StringBuilder();
       
       //objSb.append(makeOption("fail", CommonMessageDic.getMessage("IMS_BIM_BM_0706")));	//거래 실패일
       objSb.append(makeOption("fail", "거래 실패일"));
       /*objSb.append(makeOption("trans", CommonMessageDic.getMessage("IMS_SM_SV_0010")));
       objSb.append(makeOption("app", CommonMessageDic.getMessage("IMS_BIM_BM_0212")));
       objSb.append(makeOption("cc", CommonMessageDic.getMessage("IMS_BIM_BM_0213")));*/
       
       return objSb.toString();
   } 
   
   
   /**--------------------------------------------------
    * Method Name    : yyyyList
    * Description    : yyyyList
    * Author         : lim st, 2018. 10. 01.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String yyyyList() {
	   StringBuilder objSb = new StringBuilder();
	   Date today = new Date();
       
       SimpleDateFormat todayDate = new SimpleDateFormat("yyyy");
       String todayYyyy = todayDate.format(today);
   	
	   for(int i=2018; i<2051; i++) {
		   if(String.valueOf(i).equals(todayYyyy)) {
			   objSb.append(makeOption(String.valueOf(i), String.valueOf(i), true));
		   }else {
			   objSb.append(makeOption(String.valueOf(i), String.valueOf(i)));
		   }
	   }
	   
	   return objSb.toString();
   }
   
   /**--------------------------------------------------
    * Method Name    : mmList
    * Description    : mmList
    * Author         : lim st, 2018. 10. 01.
    * Modify History : Just Created.
    ----------------------------------------------------*/
   public static String mmList() {
	   StringBuilder objSb = new StringBuilder();
	   Date today = new Date();
       
       SimpleDateFormat todayDate = new SimpleDateFormat("MM");
       String todayMm = todayDate.format(today);
       
	   for(int i=1; i<13; i++) {
		   String month = "";
		   
		   if(i < 10) {
			   month = "0" + String.valueOf(i);
		   }else {
			   month = String.valueOf(i);
		   }
		   
		   if(month.equals(todayMm)) {
			   objSb.append(makeOption(month, String.valueOf(i), true));
		   }else {
			   objSb.append(makeOption(month, String.valueOf(i)));
		   }
	   }
	   
	   return objSb.toString();
   }
   
   //정산요청 날짜조회
   public static String settleReqDateChk() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("updDt", "수정일"));
       objSb.append(makeOption("appDt", "승인일", true));
       objSb.append(makeOption("ccDt", "취소일"));
       
       objSb.append(makeOption("appStmtDt", "승인 지급일"));
       objSb.append(makeOption("ccStmtDt", "취소 지급일"));
       
       objSb.append(makeOption("stmtReqDt", "정산 요청일"));
       objSb.append(makeOption("ccStmtReqDt", "취소정산 요청일"));
       
       return objSb.toString();
   } 
   
   //정산요청 ID 조회
   public static String settleReqId() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("all", CommonMessageDic.getMessage("IMS_BIM_BM_0144"), true));
       
       objSb.append(makeOption("tid", CommonMessageDic.getMessage("IMS_PW_DE_12")));
       objSb.append(makeOption("mid", CommonMessageDic.getMessage("IMS_BIM_BM_0194")));
       objSb.append(makeOption("gid", CommonMessageDic.getMessage("IMS_BIM_BM_0196")));
       objSb.append(makeOption("vid", CommonMessageDic.getMessage("IMS_BIM_BM_0195")));
       
       return objSb.toString();
   } 
   
   //정산요청 유형 조회
   public static String settleReqType() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("all", CommonMessageDic.getMessage("IMS_BIM_BM_0144"), true));
       
       objSb.append(makeOption("ordNm", "구매자"));
       objSb.append(makeOption("goodsNm", "상품명"));
       
       return objSb.toString();
   } 
   
   //일반정보등록 encoding 콤보박스
   public static String settleEncodingType() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("0", "EUC-KR"));
       objSb.append(makeOption("1", "UTF-8", true));
       
       return objSb.toString();
   }

    //수기발행 및 변경 구분 조회
   public static String handWriteSendCategoryAllType() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("all", CommonMessageDic.getMessage("DDLB_0001"), true));
       
       objSb.append(makeOption("0", "영수"));
       objSb.append(makeOption("1", "청구"));
       
       return objSb.toString();
   } 
   
   
   public static String depositReportSearchDateType() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("1", CommonMessageDic.getMessage("IMS_BIM_BM_0106")));
       objSb.append(makeOption("2", CommonMessageDic.getMessage("IMS_BIM_BM_0158")));
       
       return objSb.toString();
   }
   
   public static String depositCategorySearchType() {
       StringBuilder objSb = new StringBuilder();
       
       objSb.append(makeOption("all", "모두"));
       objSb.append(makeOption("01", "보류"));
       objSb.append(makeOption("02", "보류해제"));
       objSb.append(makeOption("03", "별도가감"));
       
       return objSb.toString();
   }
}