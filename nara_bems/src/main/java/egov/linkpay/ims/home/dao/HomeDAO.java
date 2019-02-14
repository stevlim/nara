package egov.linkpay.ims.home.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.home.dao
 * File Name      : HomeDAO.java
 * Description    : Home DAO
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("homeDAO")
public class HomeDAO extends BaseDAO {
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardChart(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardChart", objMap);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectTrxDashBoardChart(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectTrxDashBoardChart", objMap);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardTopMerchantList(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardTopMerchantList", objMap);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardTopPieChart(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardTopPieChart", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectTodayInput(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectTodayInput", objMap);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardSummaryList(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardSummaryList", objMap);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardTopMerchantChart(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardTopMerchantChart", objMap);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardInDecreaseList(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardInDecreaseList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardInformList(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardInformList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDashBoardQnaList(Map<String, Object> objMap) throws Exception {
        return selectList("home.selectDashBoardQnaList", objMap);
    }
}