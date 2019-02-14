package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : net.ionpay.dashboard.businessmgmt.service
 * File Name      : InquiryMgmtService.java
 * Description    : 영업관리 - 가맹점관리 - 문의
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface InquiryMgmtService {
    List<Map<String, Object>> selectInquiryMgmtList(Map<String, Object> objMap) throws Exception;
    
    Object selectInquiryMgmtListTotal(Map<String, Object> objMap) throws Exception;
    
    Map<String, Object> selectInquiryMgmt(Map<String, Object> objMap) throws Exception;

    void updateInquiryMgmt(Map<String, Object> objMap) throws Exception;

    Map<String, Object> selectMerchantInfo(Map<String, Object> objMap) throws Exception;
}