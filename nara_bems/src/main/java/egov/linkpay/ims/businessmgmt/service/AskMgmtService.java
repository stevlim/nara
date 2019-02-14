package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : net.ionpay.dashboard.businessmgmt.service
 * File Name      : QnaMgmtService.java
 * Description    : 영업관리 - 가맹점관리 - QnA
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface AskMgmtService {
    List<Map<String, Object>> selectQnaMgmtList(Map<String, Object> objMap) throws Exception;
    
    Object selectQnaMgmtListTotal(Map<String, Object> objMap) throws Exception;

    Map<String, Object> selectQnaMgmt(Map<String, Object> objMap) throws Exception;
    
    void insertQnaMgmt(Map<String, Object> objMap) throws Exception;

    void updateQnaMgmt(Map<String, Object> objMap) throws Exception;
}