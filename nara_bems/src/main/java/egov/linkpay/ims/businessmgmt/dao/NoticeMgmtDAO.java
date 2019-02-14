package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.dao
 * File Name      : NoticeMgmtDAO.java
 * Description    : 영업관리 - 가맹점관리 - 공지사항
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("noticeMgmtDAO")
public class NoticeMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectNoticeMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("noticeMgmt.selectNoticeMgmtList", objMap);
    }

    public Object selectNoticeMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("noticeMgmt.selectNoticeMgmtListTotal", objMap);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectNoticeMgmt(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("noticeMgmt.selectNoticeMgmt", objMap);
    }
    
    public int insertNoticeMgmt(Map<String, Object> objMap) throws Exception {
    	int result = 0;
    	result = (Integer) insert("noticeMgmt.insertNoticeMgmt", objMap);
        return result; 
    }

    public int updateNoticeMgmt(Map<String, Object> objMap) throws Exception {
        int result = 0;
    	result = (Integer)update("noticeMgmt.updateNoticeMgmt", objMap);
        return result; 
    }
    
}