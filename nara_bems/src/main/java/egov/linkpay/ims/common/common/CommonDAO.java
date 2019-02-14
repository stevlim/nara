package egov.linkpay.ims.common.common;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonDAO.java
 * Description    : Common DAO
 * Author         : yangjeongmo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("commonDAO")
public class CommonDAO extends BaseDAO {
    public void insertUserWorkLog(Map<String, Object> objMap) throws Exception { 
        insert("common.insertUserWorkLog", objMap);
    }
    
    public Object selectChkAuthUserMenu(Map<String, Object> objMap) throws Exception {
        return selectOne("common.selectChkAuthUserMenu", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectAuthUserMenu(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>)selectOne("common.selectAuthUserMenu", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectAuthUserMenuList(Map<String, Object> objMap) throws Exception {
        return selectList("common.selectAuthUserMenuList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectAuthUserMenuGrpList(Map<String, Object> objMap) throws Exception {
        return selectList("common.selectAuthUserMenuGrpList", objMap);
    }
    
    public Object selectChkMenu(String strMenuLink) throws Exception {
        return selectOne("common.selectChkMenu", strMenuLink);
    }

    public Object selectUserPSWD(String strUsrID) throws Exception {
        return selectOne("common.selectUserPSWD", strUsrID);
    }
}
