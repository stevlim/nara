package egov.linkpay.ims.sampleMgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.sampleMgmt.dao
 * File Name      : SampleMgmtDAO.java
 * Description    : SampleMgmtDAO
 * Author         : st.lim, 2019. 02. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("sampleMgmtDAO")
public class SampleMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectFaqMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("sampleMgmt.selectFaqMgmtList", objMap);
    }

    public Object selectFaqMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("sampleMgmt.selectFaqMgmtListTotal", objMap);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectFaqMgmt(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("sampleMgmt.selectFaqMgmt", objMap);
    }
    
    public void insertFaqMgmt(Map<String, Object> objMap) throws Exception {
        insert("sampleMgmt.insertFaqMgmt", objMap); 
    }

    public void updateFaqMgmt(Map<String, Object> objMap) throws Exception {
        update("sampleMgmt.updateFaqMgmt", objMap); 
    }
}