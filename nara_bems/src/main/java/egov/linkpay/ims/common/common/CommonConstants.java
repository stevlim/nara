package egov.linkpay.ims.common.common;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonConstants.java
 * Description    : Common Constants
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CommonConstants {
    /* BEGIN ENCRYPT INFO */
    public final static String ENCRYPT_KEY = "vke9erp65rcfboefugz33hqkd853d9e7i1r5kaafjn7yckvr";
    /* END ENCRYPT INFO */
    
    /* BEGIN SHA512Salt INFO */
    public final static String SHA512_SALT_KEY = "1d7c2s6ygt2ovrspz78xcbb7hciqoexvc3crbcxku7yq3pbq";
    /* END SHA512Salt INFO */
    
    /* BEGIN SESSION INFO */
    public final static String IMS_SESSION_LOGIN_KEY = "IMSAdminSession";
    /* END SESSION INFO */
    
    /* BEGIN MENU SESSION INFO */
    public final static String IMS_SESSION_MENU_KEY = "IMSAdminMenuSession";
    /* END MENU SESSION INFO */
    
    /* BEGIN PREV PAGE SESSION INFO */
    public final static String IMS_SESSION_PREV_PAGE_KEY = "IMSPrevPage";
    /* END PREV PAGE SESSION INFO */
    
    /* BEGIN PASSWORD CHANGE SESSION INFO */
    public final static String IMS_SESSION_PASSWORD_CHANGE_KEY = "IMSAdminPasswordChangeSession";
    /* END PASSWORD CHANGE SESSION INFO */
    
    /* BEGIN CSRF KEY INFO */
    public final static String IMS_SESSION_CSRF_KEY = "IMSCsrfKey";
    /* END CSRF KEY INFO */
    
    /* BEGIN LANGUAGE CODE INFO */
    public final static String IMS_SESSION_LANGUAGE_KEY          = "IMSLanguage";
    public final static String IMS_SESSION_DEFAULT_LANGUAGE_CODE = "ko"; //원래 en 
    public final static int    IMS_SESSION_LANGUAGE_COOKIE_EXP   = 157680000;
    /* END LANGUAGE CODE INFO */
    
    /* BEGIN SESSION EXP INFO */
    public final static String IMS_SESSION_EXP_KEY   = "IMSSessionExp";
    public final static String IMS_SESSION_EXP_VALUE = "true";
    public final static int    IMS_SESSION_EXP       = 3600;
    /* END SESSION EXP INFO */
    
    /* BEGIN COMMON URL */
    public final static String LOGIN_URL  = "/logIn.do";
    public final static String LOGOUT_URL = "/logOut.do";
    /* END COMMON URL */
    
    /* BEGIN CONSTANTS ID */
    public final static String IMS_ID_CSRF = "IMSRequestVerificationToken";
    /* END CONSTANTS ID */
    
    /* BEGIN DASHBOARD MENU URI SEGMNT */
    public final static String BUSINESSMGMT_MERCHANTMGMT_NOTICE_SEGMNT   = "/businessMgmt/noticeMgmt";
    public final static String BUSINESSMGMT_MERCHANTMGMT_INQUIRY_SEGMNT  = "/businessMgmt/inquiryMgmt";
    public final static String BUSINESSMGMT_MERCHANTMGMT_FAQ_SEGMNT      = "/businessMgmt/faqMgmt";
    public final static String BUSINESSMGMT_MERCHANTMGMT_ARCHIVES_SEGMNT = "/businessMgmt/archivesMgmt";
    
    public final static String SETTLEMENTMNT_RECONCILERESULT_SEMMNT= "/settlementMgmt/reconcileResult/";
    public final static String SETTLEMENTMNT_NOTMATCHINGTRXBNI_SEMMNT = "/settlementMgmt/notMatchingTrxBNI/";
    /* END DASHBOARD MENU URI SEGMNT */
    
    /* BEGIN EXCEPTION URI */
    public final static String[] INTERCEPTER_EXCEPTION_URI_SGMNT  = {"/logIn", "/logOut", "/home/dashboard", "/error"};
    /* END EXCEPTION URI */
    
    /* BEGIN AJAX EXCEPTION URI */
    public final static String[] FILTER_AJAX_EXCEPTION_URI_SGMNT  = {"/logIn", "/logOut", "/error"};
    /* END AJAX EXCEPTION URI */
    
    /* BEGIN EXCEL SIZE */
    public final static int EXCEL_PAGE_START_SIZE  = 1;
    public final static int EXCEL_PAGE_END_SIZE    = 50000;
    /* END EXCEL SIZE */
    
    /* BEGIN DEFAULT USER PASSWORD */
    public final static String DEFAULT_USER_PASSWORD  = "123456";
    /* END DEFAULT USER PASSWORD */
    
    /* BEGIN DEFAULT ENCRYPT USER PASSWORD */
    public final static String DEFAULT_ENCRYPT_USER_PASSWORD  = "gpAFym0vGYmGIcPz5dVDyoKprI+Uul4miEH7LLiJiLUWfESSk1egsFhb82DHyRZhHwbqaFjij9hhUfBSUgm4Yg==";
    /* END DEFAULT ENCRYPT USER PASSWORD */
}
