package egov.linkpay.ims.authoritymgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.dao
 * File Name      : MenuGroupMgmtDAO.java
 * Description    : 권한관리 - 메뉴그룹관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("menuGroupMgmtDAO")
public class MenuGroupMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMenuGroupMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("menuGroupMgmt.selectMenuGroupMgmtList", objMap);
    }
    
    public void updateMenuGroupMgmt(Map<String, Object> objMap) throws Exception {
        update("menuGroupMgmt.updateMenuGroupMgmt", objMap);
    }
    
    public void deleteUserAuthDtl(Map<String, Object> objMap) throws Exception {
        delete("menuGroupMgmt.deleteUserAuthDtl", objMap);
    }
    
    public void deleteMenu(Map<String, Object> objMap) throws Exception {
        delete("menuGroupMgmt.deleteMenu", objMap);
    }
    
    public void deleteGroupMenu(Map<String, Object> objMap) throws Exception {
        delete("menuGroupMgmt.deleteGroupMenu", objMap);
    }
    
    public void updateGroupMenuSort(Map<String, Object> objMap) throws Exception {
        update("menuGroupMgmt.updateGroupMenuSort", objMap);
    }
    
    public void insertMenuMgmt(Map<String, Object> objMap) throws Exception {
        insert("menuGroupMgmt.insertMenuMgmt", objMap);
    }
}
