package egov.linkpay.ims.sampleSubMgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : net.ionpay.dashboard.businessmgmt.service
 * File Name      : FaqMgmtService.java
 * Description    : 영업관리 - 가맹점관리 - FAQ
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface SampleSubMgmtService {
    List<Map<String, Object>> selectFaqMgmtList(Map<String, Object> objMap) throws Exception;
    
    Object selectFaqMgmtListTotal(Map<String, Object> objMap) throws Exception;

    Map<String, Object> selectFaqMgmt(Map<String, Object> objMap) throws Exception;
    
    void insertFaqMgmt(Map<String, Object> objMap) throws Exception;

    void updateFaqMgmt(Map<String, Object> objMap) throws Exception;
}