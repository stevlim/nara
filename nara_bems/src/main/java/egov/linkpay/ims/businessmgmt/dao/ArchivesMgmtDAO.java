package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.dao
 * File Name      : ArchivesMgmtDAO.java
 * Description    : 영업관리 - 가맹점관리 - 자료실
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("archivesMgmtDAO")
public class ArchivesMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectArchivesMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("archivesMgmt.selectArchivesMgmtList", objMap);
    }

    public Object selectArchivesMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("archivesMgmt.selectArchivesMgmtListTotal", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectArchivesMgmt(Map<String, Object> objMap) {
        return (Map<String, Object>) selectOne("archivesMgmt.selectArchivesMgmt", objMap);
    }
    
    public void insertArchivesMgmt(Map<String, Object> objMap) throws Exception {
        insert("archivesMgmt.insertArchivesMgmt", objMap); 
    }
    
    public void updateArchivesMgmt(Map<String, Object> objMap) {
        update("archivesMgmt.updateArchivesMgmt", objMap); 
    }   

    public void deleteArchivesMgmt(Map<String, Object> objMap) throws Exception {
        delete("archivesMgmt.deleteArchivesMgmt", objMap);         
    }

    public Object selectFileArchivesMgmt(Map<String, Object> objMap) {
        return selectOne("archivesMgmt.selectFileArchivesMgmt", objMap);
    }     
}