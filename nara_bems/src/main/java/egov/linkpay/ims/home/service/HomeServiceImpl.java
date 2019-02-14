package egov.linkpay.ims.home.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.home.dao.HomeDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.home.service
 * File Name      : HomeServiceImpl.java
 * Description    : Home Service Implement
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("homeService")
public class HomeServiceImpl implements HomeService {
    Logger logger = Logger.getLogger(this.getClass());

    @Resource(name="homeDAO")
    private HomeDAO homeDAO;

    @Override
    public List<Map<String, Object>> selectDashBoardChart(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardChart(objMap);
    }

    @Override
    public List<Map<String, Object>> selectTrxDashBoardChart(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectTrxDashBoardChart(objMap);
    }

    @Override
    public List<Map<String, Object>> selectDashBoardTopMerchantList(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardTopMerchantList(objMap);
    }

    @Override
    public List<Map<String, Object>> selectTodayInput(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectTodayInput(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectDashBoardPieChart(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardTopPieChart(objMap);
    }

    @Override
    public List<Map<String, Object>> selectDashBoardSummaryList(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardSummaryList(objMap);
    }

    @Override
    public List<Map<String, Object>> selectDashBoardTopMerchantChart(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardTopMerchantChart(objMap);
    }

    @Override
    public List<Map<String, Object>> selectDashBoardInDecreaseList(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardInDecreaseList(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectDashBoardInformList(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardInformList(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectDashBoardQnaList(Map<String, Object> objMap) throws Exception {
        return homeDAO.selectDashBoardQnaList(objMap);
    }
}