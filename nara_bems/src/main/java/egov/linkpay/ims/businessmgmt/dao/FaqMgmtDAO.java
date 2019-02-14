package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.dao
 * File Name      : FaqMgmtDAO.java
 * Description    : 영업관리 - 가맹점관리 - FAQ
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("faqMgmtDAO")
public class FaqMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectFaqMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("faqMgmt.selectFaqMgmtList", objMap);
    }

    public Object selectFaqMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("faqMgmt.selectFaqMgmtListTotal", objMap);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectFaqMgmt(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("faqMgmt.selectFaqMgmt", objMap);
    }
    
    public void insertFaqMgmt(Map<String, Object> objMap) throws Exception {
        insert("faqMgmt.insertFaqMgmt", objMap); 
    }

    public void updateFaqMgmt(Map<String, Object> objMap) throws Exception {
        update("faqMgmt.updateFaqMgmt", objMap); 
    }
}