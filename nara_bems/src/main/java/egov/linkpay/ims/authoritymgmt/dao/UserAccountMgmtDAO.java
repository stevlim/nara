package egov.linkpay.ims.authoritymgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.dao
 * File Name      : UserAccountMgmtDAO.java
 * Description    : 권한관리 - 사용자관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("userAccountMgmtDAO")
public class UserAccountMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("userAccountMgmt.selectUserAccountMgmtList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMenuAuthList(Map<String, Object> objMap) throws Exception {
        return selectList("userAccountMgmt.selectMenuAuthList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMerchantMgmtList() throws Exception {
        return selectList("common.selectMerchantIDList");
    }
    
    public Object selectUserID(Map<String, Object> objMap) throws Exception {
        return selectOne("userAccountMgmt.selectUserID", objMap);
    }
    
    public Object insertUserAccountMgmt(Map<String, Object> objMap) throws Exception {
        return insert("userAccountMgmt.insertUserAccountMgmt", objMap);
    }
    
    public void insertUserIMID(Map<String, Object> objMap) throws Exception {
        insert("userAccountMgmt.insertUserIMID", objMap);
    }
    
    public void updateUserPSWD(Map<String, Object> objMap) throws Exception {
        insert("userAccountMgmt.updateUserPSWD", objMap);
    }
    
    public Object selectUserAccount(Map<String, Object> objMap) throws Exception {
        return selectOne("userAccountMgmt.selectUserAccount", objMap);
    }
    
    public Object selectUserIMIDs(Map<String, Object> objMap) throws Exception {
        return selectOne("userAccountMgmt.selectUserIMIDs", objMap);
    }
    
    public Object selectUserMERNMs(Map<String, Object> objMap) throws Exception {
        return selectOne("userAccountMgmt.selectUserMERNMs", objMap);
    }
    
    public void updateUserAccountMgmt(Map<String, Object> objMap) throws Exception {
        update("userAccountMgmt.updateUserAccountMgmt", objMap);
    }
    
    public void deleteUsrAuthDtl(Map<String, Object> objMap) throws Exception {
        delete("userAccountMgmt.deleteUsrAuthDtl", objMap);
    }
    
    public Object selectUserIMIDsCount(Map<String, Object> objMap) throws Exception {
        return selectOne("userAccountMgmt.selectUserIMIDsCount", objMap);
    }
    
    public Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception {
        return selectOne("userAccountMgmt.selectUserAccountMgmtListCnt", objMap);
    }
    
	public void insertPwInitSendMail(Map< String, Object > objMap) throws Exception{
		insert("userAccountMgmt.insertPwInitSendMail", objMap);
	}
}
