package egov.linkpay.ims.authoritymgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.dao
 * File Name      : MenuRoleMgmtDAO.java
 * Description    : 권한관리 - 메뉴역할관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("menuRoleMgmtDAO")
public class MenuRoleMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMenuRoleMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("menuRoleMgmt.selectMenuRoleMgmtList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMenuRoleMgmtDtl(Map<String, Object> objMap) throws Exception {
        return selectList("menuRoleMgmt.selectMenuRoleMgmtDtl", objMap);
    }
    
    public void insertMenuRoleMgmt(Map<String, Object> objMap) throws Exception {
        insert("menuRoleMgmt.insertMenuRoleMgmt", objMap);
    }
    
    public void insertMenuRoleDtl(Map<String, Object> objMap) throws Exception {
    	if(objMap.containsKey("ADDLIST") && objMap.get("ADDLIST")!=null) {
    		objMap.put("ADDLIST_COUNT", objMap.get("ADDLIST").toString().split(",").length);
    		objMap.put("ADDLIST_ARR", objMap.get("ADDLIST").toString().split(","));
    	}else {
    		objMap.put("ADDLIST_COUNT", 0);
    	}
    	
    	if(objMap.containsKey("ALLLIST") && objMap.get("ALLLIST")!=null) {
    		objMap.put("ALLLIST_COUNT", objMap.get("ALLLIST").toString().split(",").length);
    		objMap.put("ALLLIST_ARR", objMap.get("ALLLIST").toString().split(","));
    	}else {
    		objMap.put("ALLLIST_COUNT", 0);
    	}
    	
    	if(objMap.containsKey("READLIST") && objMap.get("READLIST")!=null) {
    		objMap.put("READLIST_COUNT", objMap.get("READLIST").toString().split(",").length);
    		objMap.put("READLIST_ARR", objMap.get("READLIST").toString().split(","));
    	}else {
    		objMap.put("READLIST_COUNT", 0);
    	}
    	
    	
    	
    	
    	
        insert("menuRoleMgmt.insertMenuRoleDtl", objMap);
    }
    
    public void updateMenuRoleMgmt(Map<String, Object> objMap) throws Exception {
        update("menuRoleMgmt.updateMenuRoleMgmt", objMap);
    }
    
    public void deleteMenuRoleDtl(Map<String, Object> objMap) throws Exception {
        delete("menuRoleMgmt.deleteMenuRoleDtl", objMap);
    }
    
    public void updateAllMenuRoleDtl(Map<String, Object> objMap) throws Exception {
        update("menuRoleMgmt.updateAllMenuRoleDtl", objMap);
    }
    
    public void updateReadMenuRoleDtl(Map<String, Object> objMap) throws Exception {
        update("menuRoleMgmt.updateReadMenuRoleDtl", objMap);
    }
    
    public Object selectMenuRoleMerAuthTypeCnt() throws Exception {
        return selectOne("menuRoleMgmt.selectMenuRoleMerAuthTypeCnt");
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("menuRoleMgmt.selectUserAccountMgmtList", objMap);
    }
    
    public Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception {
        return selectOne("menuRoleMgmt.selectUserAccountMgmtListCnt", objMap);
    }
}
