package egov.linkpay.ims.loginout.service;

import java.util.Map;

import javax.servlet.http.HttpSession;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.loginout.service
 * File Name      : LogInOutService.java
 * Description    : LogIn/Out Service
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface LogInOutService {
    Map<String, Object> selectIMSNotice() throws Exception;
    
    Map<String, Object> selectAdminInfo(Map<String, Object> objMap) throws Exception;
    
    Map<String, Object> selectAdminInfo2(Map<String, Object> objMap, HttpSession session) throws Exception;

    void updateAdminPSWD(Map<String, Object> objMap) throws Exception;
    
    void insertLogoutLog(Map<String, Object> objMap) throws Exception;
    
    void insertMerchantApply(Map<String, Object> objMap) throws Exception;
    
    Map<String, Object> selectCoNoDupChk(Map<String, Object> objMap) throws Exception;
    
    Boolean selectMerchantInfo(Map<String, Object> objMap) throws Exception;
}