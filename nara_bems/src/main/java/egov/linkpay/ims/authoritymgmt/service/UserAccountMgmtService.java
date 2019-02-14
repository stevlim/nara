package egov.linkpay.ims.authoritymgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : UserAccountMgmtService.java
 * Description    : 권한관리 - 사용자관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface UserAccountMgmtService {
    List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectMenuAuthList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectMerchantMgmtList() throws Exception;
    
    Object selectUserID(Map<String, Object> objMap) throws Exception;
    
    void insertUserAccountMgmt(Map<String, Object> objMap) throws Exception;
    
    void updateUserPSWD(Map<String, Object> objMap) throws Exception;
    
    Object selectUserAccount(Map<String, Object> objMap) throws Exception;
    
    Object selectUserIMIDs(Map<String, Object> objMap) throws Exception;
    
    Object selectUserMERNMs(Map<String, Object> objMap) throws Exception;
    
    void updateUserAccountMgmt(Map<String, Object> objMap) throws Exception;
    
    Object selectUserIMIDsCount(Map<String, Object> objMap) throws Exception;
    
    Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception;
    
    void insertPwInitSendMail(Map< String, Object > objMap) throws Exception;
}
