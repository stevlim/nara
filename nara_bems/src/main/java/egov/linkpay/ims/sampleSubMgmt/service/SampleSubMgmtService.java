package egov.linkpay.ims.sampleSubMgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.sampleSubMgmt.service
 * File Name      : SampleSubMgmtService.java
 * Description    : SampleSubMgmtService
 * Author         : st.lim, 2019. 02. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface SampleSubMgmtService {
    List<Map<String, Object>> selectFaqMgmtList(Map<String, Object> objMap) throws Exception;
    
    Object selectFaqMgmtListTotal(Map<String, Object> objMap) throws Exception;

    Map<String, Object> selectFaqMgmt(Map<String, Object> objMap) throws Exception;
    
    void insertFaqMgmt(Map<String, Object> objMap) throws Exception;

    void updateFaqMgmt(Map<String, Object> objMap) throws Exception;
}