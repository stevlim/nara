package egov.linkpay.ims.authoritymgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : MenuMgmtService.java
 * Description    : 권한관리 - 메뉴관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface MenuMgmtService {
    List<Map<String, Object>> selectMenuGroupList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectMenuMgmtList(Map<String, Object> objMap) throws Exception;
    
    void updateMenuList(Map<String, Object> objMap) throws Exception;
    
    void insertMenuMgmt(Map<String, Object> objMap) throws Exception;
    
    void updateMenuMgmt(Map<String, Object> objMap) throws Exception;
    
    void deleteMenuMgmt(Map<String, Object> objMap) throws Exception;
}
