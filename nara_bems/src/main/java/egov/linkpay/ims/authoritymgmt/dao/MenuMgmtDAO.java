package egov.linkpay.ims.authoritymgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.dao
 * File Name      : MenuMgmtDAO.java
 * Description    : 권한관리 - 메뉴관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("menuMgmtDAO")
public class MenuMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMenuGroupList(Map<String, Object> objMap) throws Exception {
        return selectList("menuMgmt.selectMenuGroupList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMenuMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("menuMgmt.selectMenuMgmtList", objMap);
    }
    
    public void updateMenuList(Map<String, Object> objMap) throws Exception {
        update("menuMgmt.updateMenuList", objMap);
    }
    
    public void insertMenuMgmt(Map<String, Object> objMap) throws Exception {
        insert("menuMgmt.insertMenuMgmt", objMap);
    }
    
    public void updateMenuMgmt(Map<String, Object> objMap) throws Exception {
        insert("menuMgmt.updateMenuMgmt", objMap);
    }
    
    public void deleteMenu(Map<String, Object> objMap) throws Exception {
        delete("menuMgmt.deleteMenu", objMap);
    }
    
    public void updateMenuSort(Map<String, Object> objMap) throws Exception {
        update("menuMgmt.updateMenuSort", objMap);
    }
}
