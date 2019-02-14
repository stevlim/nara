package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.dao
 * File Name      : QnaMgmtDAO.java
 * Description    : 영업관리 - 가맹점관리 - QnA
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("qnaMgmtDAO")
public class QnaMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectQnaMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("qnaMgmt.selectQnaMgmtList", objMap);
    }

    public Object selectQnaMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("qnaMgmt.selectQnaMgmtListTotal", objMap);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectQnaMgmt(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("qnaMgmt.selectQnaMgmt", objMap);
    }
    
    public void insertQnaMgmt(Map<String, Object> objMap) throws Exception {
        insert("qnaMgmt.insertQnaMgmt", objMap); 
    }

    public void updateQnaMgmt(Map<String, Object> objMap) throws Exception {
        update("qnaMgmt.updateQnaMgmt", objMap); 
    }
}