package egov.linkpay.ims.messagemgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.messagemgmt.service
 * File Name      : MessageMgmtService.java
 * Description    : 다국어관리 - 메시지관리
 * Author         : ymjo, 2015. 11. 27.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface MessageMgmtService {

    List<Map<String, Object>> selectMessageMgmtList(Map<String, Object> objMap) throws Exception;

    Object selectMessageMgmtListTotal(Map<String, Object> objMap) throws Exception;

    void insertMessageMgmt(Map<String, Object> objMap) throws Exception;

    void updateMessageMgmt(Map<String, Object> objMap) throws Exception;

    Map<String, Object> selectMessageMgmtInfo(Map<String, Object> objMap) throws Exception;

    List<Map<String, Object>> selectLanguage(Map<String, Object> objMap)  throws Exception;
}
