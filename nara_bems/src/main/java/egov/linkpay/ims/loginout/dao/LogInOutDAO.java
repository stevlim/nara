package egov.linkpay.ims.loginout.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.loginout.dao
 * File Name      : LogInOutDAO.java
 * Description    : LogIn/Out DAO
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("logInOutDAO")
public class LogInOutDAO extends BaseDAO {    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectIMSNotice() {
        return (Map<String, Object>) selectOne("logInOut.selectIMSNotice");
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectAdminInfo(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("logInOut.selectAdminInfo", objMap);        
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectAdminInfo2(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("logInOut.selectAdminInfo2", objMap);        
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectPswdHistory(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("logInOut.selectPswdHistory", objMap);        
    }
    
    public void updateAdminPSWD(Map<String, Object> objMap) throws Exception {
        update("logInOut.updateAdminPSWD", objMap); 
    }
    
    public void updateFailCnt(Map<String, Object> objMap) throws Exception {
    	update("logInOut.updateFailCnt", objMap);
    }
    
    public void updateFailCntInit(Map<String, Object> objMap) throws Exception {
    	update("logInOut.updateFailCntInit", objMap);
    }
    
    public void insertLoginLog(Map<String, Object> objMap) throws Exception {
        insert("logInOut.insertLoginLog", objMap);
    }
    
    public void insertLogoutLog(Map<String, Object> objMap) throws Exception {
        insert("logInOut.insertLogoutLog", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectLoginMidInfo(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("logInOut.selectLoginMidInfo", objMap);        
    }
    
    public void insertMerchantApply(Map<String, Object> objMap) throws Exception {
        insert("logInOut.insertMerchantApply", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCoNoDupChk(Map<String, Object> objMap) {
        return (Map<String, Object>) selectOne("logInOut.selectCoNoDupChk", objMap);
    }
}