package egov.linkpay.ims.sampleMgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.sampleMgmt.service
 * File Name      : SampleMgmtService.java
 * Description    : SampleMgmtService
 * Author         : st.lim, 2019. 02. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface SampleMgmtService {
    List<Map<String, Object>> selectFaqMgmtList(Map<String, Object> objMap) throws Exception;
    
    Object selectFaqMgmtListTotal(Map<String, Object> objMap) throws Exception;

    Map<String, Object> selectFaqMgmt(Map<String, Object> objMap) throws Exception;
    
    void insertFaqMgmt(Map<String, Object> objMap) throws Exception;

    void updateFaqMgmt(Map<String, Object> objMap) throws Exception;
}