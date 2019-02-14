package egov.linkpay.ims.authoritymgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : MenuRoleMgmtService.java
 * Description    : 권한관리 - 메뉴역할관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface MenuRoleMgmtService {
    List<Map<String, Object>> selectMenuRoleMgmtList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectMenuRoleMgmtDtl(Map<String, Object> objMap) throws Exception;
    
    void insertMenuRoleMgmt(Map<String, Object> objMap) throws Exception;
    
    void updateMenuRoleMgmt(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception;

    Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception;
}
