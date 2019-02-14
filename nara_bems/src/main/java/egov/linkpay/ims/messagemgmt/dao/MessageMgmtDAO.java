package egov.linkpay.ims.messagemgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.messagemgmt.dao
 * File Name      : MessageMgmtDAO.java
 * Description    : 다국어관리 - 메시지관리
 * Author         : kwjang, 2015. 11. 27.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("messageMgmtDAO")
public class MessageMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMessageMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("messageMgmt.selectMessageMgmtList", objMap);
    }

    public Object selectMessageMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("messageMgmt.selectMessageMgmtListTotal", objMap);
    }

    public void insertMessageMgmt(Map<String, Object> objMap) throws Exception {
        insert("messageMgmt.insertMessageMgmt", objMap);        
    }

    public void updateMessageMgmt(Map<String, Object> objMap) throws Exception {
        update("messageMgmt.updateMessageMgmt", objMap);        
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectMessageMgmtInfo(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("messageMgmt.selectMessageMgmtInfo", objMap);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectLanguage(Map<String, Object> objMap) {
        return selectList("messageMgmt.selectLanguage", objMap);
    }
}
