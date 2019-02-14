package egov.linkpay.ims.authoritymgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : MenuGroupMgmtService.java
 * Description    : 권한관리 - 메뉴그룹관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface MenuGroupMgmtService {
    List<Map<String, Object>> selectMenuGroupMgmtList(Map<String, Object> objMap) throws Exception;
    
    void updateMenuGroupMgmt(Map<String, Object> objMap) throws Exception;
    
    void deleteMenuGroupMgmt(Map<String, Object> objMap) throws Exception;
    
    void insertMenuMgmt(Map<String, Object> objMap) throws Exception;
}
