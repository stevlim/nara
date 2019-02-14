package egov.linkpay.ims.common.common;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonMessage.java
 * Description    : Common Message
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CommonMessage {
    /* BEGIN BROSWER TITLE */
    public final static String BROWSER_TITLE = "EROMPAY - MMS SYSTEM";
    /* END BROSWER TITLE */
    
    /* BEGIN GNB SITE TITLE */
    public final static String GNB_TITLE = "EROMPAY";
    /* END GNB SITE TITLE */
    
    /* BEGIN DASHBOARD MENU TITLE */
    public final static String BUSINESSMGMT_MERCHANTMGMT_TITLE = "IMS_MENU_SUB_0019"; // 영업관리 - 가맹점 관리 메뉴의 경우 타이틀 관리
    public final static String SETTLEMENT_RECONCILE_TITLE = "IMS_MENU_SUB_0038"; // 대사 - 대사 메뉴의 경우 타이틀 관리
    public final static String REPORT_CREATION= "IMS_MENU_SUB_0104";  //정산 - 보고서 작성  
    public final static String PURCHASE_MANAGEMENT= "IMS_MENU_SUB_0115";  // 매입관리 
    public final static String CREDIT_CARD_DEPORIT_MANAGEMENT = "IMS_MENU_SUB_0059";  //신용카드 입금관리
    public final static String AGENCY_SETTLEMENT = "IMS_MENU_SUB_0119";   // 대리점 정산 
    public final static String CASH_RECEIPT_PROCESSING = "IMS_MENU_SUB_0087";   	//현금영수증 처리
    public final static String BATCH_MANAGEMENT = "IMS_MENU_SUB_0127";			// 배치 관리 
    public final static String NEW_CONTRACT_PROGRESS_HISTORY = "IMS_MENU_SUB_0018"; //신규계약 진행 현황
    public final static String AFFILIATE_SUB_MALL = "IMS_MENU_SUB_0075";			// 제휴사 서브몰 
    public final static String EXISTING_CORPORATE_MANAGEMENT = "IMS_MENU_SUB_0072";	//기존업체 관리
    public final static String CREDIT_CARD = "IMS_MENU_SUB_0073";			//신용카드
    public final static String BANK_TRANSFER = "IMS_MENU_SUB_0077";		//계좌이체
    public final static String BASIC_INFORMATION = "IMS_MENU_SUB_0048";	//기본정보
    public final static String CREDIT_CARD_SUPPORT = "IMS_MENU_SUB_0096";//신용카드 지원
    public final static String EXCHANGE_RATE_MANAGEMENT = "IMS_MENU_0015";//환율관리
    public final static String AFFILIATE_MANAGEMENT = "IMS_MENU_SUB_0099";//제휴사 관리
    public final static String APPROVAL_LIMIT = "IMS_MENU_SUB_0080";	//승인한도 
    public final static String PROFIT_AND_LOSS = "IMS_MENU_SUB_0063";	//손익조회
    public final static String OTHER_STATISTICS = "IMS_MENU_SUB_0065";	//기타 통계
    public final static String PAY_INQUIRY = "IMS_MENU_SUB_0078";	//결제내역 조회
    public final static String PAY_FAIL_INQUIRY = "IMS_MENU_SUB_0072";	//결제실패내역 조회
    public final static String MSG_ERR_USINGSTOP = "현재 사용이 중지된 아이디 입니다. 관계자에게 연락 바랍니다."; //사용중지 상태인 사용자 아이디
    
    /* END DASHBOARD MENU TITLE */
    
    /* BEGIN ERROR MESSAGE */
    public final static String MSG_ERR_LIMITED_ACCOUT       = "횟수가 제한되어있습니다. 관계자에게 연락 바랍니다..";//"Limited your account.Please check your account to administrator.";
    public final static String MSG_ERR_LOGIN_FAIL           = "ID와 비밀번호를 확인해주세요.";	//"Please Check Your Username And Password.";
    public final static String MSG_ERR_JSON_PARAMETER_EMPTY = "전달받은 Json 파라미터가 비어있습니다..";//"Receive Json Parameter is Empty.";
    public final static String MSG_ERR_CURPSWD_WRONG        = "현 비밀번호와 맞지 않습니다.";//"The Current Password Does Not Match.";
    public final static String MSG_ERR_EXCEPTION            = "요청하는동안 에러가 발생했습니다.";//"Error occurred during request";
    public final static String MSG_ERR_CARD_CANCEL          = "취소로 인해 가맹점 상태를 중단 할 수 없습니다.";//"The merchant status can not be stopped because of the cancellation.";
    public final static String MSG_ERR_CARD_ALL_CANCEL      = "가맹점을 취소할 수 없습니다.";//"The merchant can not be canceled.";
    public final static String MSG_ERR_CARD_PART_CANCEL     = "가맹점을 부분취소할 수 없습니다.";//"The merchant can not be partial cancellation.";
    public final static String MSG_ERR_CARD_PROTECT_CANCEL  = "가맹점을 취소할 수 없습니다. (부채 상환 제한)";//"The merchant can not be cancellation. (Debt cancellation prevent restrictions)";
    public final static String MSG_ERR_SEND_MAIL            = "메일 전송 실패.";//"Send Mail Fail.";
    public final static String MSG_ERR_PSWD_VALID           = "비밀번호는 영문, 숫자, 특수문자를 포함한 8-20자리여야 합니다.";//"Passwords must contain uppercase letters, lowercase letters, numbers, special characters(!@#$%^&*), and must be 8-20.";//"Passwords must contain uppercase letters, lowercase letters, numbers, special characters(!@#$%^&*), and must be 8-20.";
    public final static String MSG_ERR_PSWD_FAIL_CNT        = "비밀번호를 3회 잘못 입력하셨습니다. 관계자에게 연락 바랍니다.";
    public final static String MSG_ERR_PWSD_OVER_90         = "비밀번호를 변경한지 90일 넘었습니다. 비밀번호를 변경해 주세요.";//"Your password has been changed for more than 90 days. Please, change password.";
    public final static String MSG_ERR_PWSD_HISTORY         = "전에 사용했던 비밀번호는 사용할 수 없습니다.";//"The previously used password can not be used.";
    public final static String MSG_ERR_MID_EXIST         	= "I_MID가 존재하지 않습니다.";//"I_MID Not Exist.";
    
    public final static String MSG_ERR_FROMDATE             = "IMS_COM_MSG_0001";
    /* END ERROR MESSAGE */
    
    /* BEGIN NOTI MESSAGE */
    public final static String MSG_NOTI_SUBJECT				= "[EROMPAY] 비밀번호가 변경되었습니다.";//"[EROMPAY] Password was changed";
    public final static String MSG_NOTI_DATA_BIGIN			= " ";//"Dear ";
    public final static String MSG_NOTI_DATA				= "비밀번호가 변경되었습니다. ";//"Your password was change to ";
    public final static String MSG_NOTI_DATA_END			= "감사합니다.";//"Thank you";
    /* END NOTI MESSAGE */
    
    /* SETTLEMENT MESSAGE */
    public final static String MSG_ERR_PERMISSION           = "권한이 없습니다.";//"You do not have permission.";
    /* SETTLEMENT MESSAGE */
    
}