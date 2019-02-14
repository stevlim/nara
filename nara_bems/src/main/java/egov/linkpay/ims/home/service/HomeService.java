package egov.linkpay.ims.home.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.home.service
 * File Name      : HomeService.java
 * Description    : Home Service
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface HomeService {
    List<Map<String, Object>> selectDashBoardChart(Map<String, Object> objMap) throws Exception;

    List<Map<String, Object>> selectTrxDashBoardChart(Map<String, Object> objMap) throws Exception;

    List<Map<String, Object>> selectDashBoardTopMerchantList(Map<String, Object> objMap) throws Exception;

    List<Map<String, Object>> selectDashBoardPieChart(Map<String, Object> objMap) throws Exception;

    List<Map<String, Object>> selectDashBoardSummaryList(Map<String, Object> objMap) throws Exception;

    List<Map<String, Object>> selectDashBoardTopMerchantChart(Map<String, Object> objMap) throws Exception;

    List<Map<String, Object>> selectDashBoardInDecreaseList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectDashBoardInformList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectDashBoardQnaList(Map<String, Object> objMap) throws Exception;

	List<Map<String, Object>> selectTodayInput(Map<String, Object> objMap) throws Exception;

}