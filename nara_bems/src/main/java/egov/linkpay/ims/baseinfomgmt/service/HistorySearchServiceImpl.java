package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;

@Service("historySearchService")
public class HistorySearchServiceImpl implements HistorySearchService
{
	@Resource(name="historySearchDAO")
	private HistorySearchDAO historySearchDAO;
	 
	@Override
    public List<Map<String,Object>> selectChangeHistoryDetail(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectChangeHistoryDetail( paramMap );
    }
	@Override
    public Object selectChangeHistoryDetailTotal(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectChangeHistoryDetailTotal( paramMap );
    }
	
	@Override
    public List<Map<String,Object>> selectFeeInfo(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectFeeInfo( paramMap );
    }
	@Override
    public Object selectFeeInfoTotal(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectFeeInfoTotal( paramMap );
    }
	
	@Override
    public List<Map<String,Object>> selectSettleCycleInfo(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectSettleCycleInfo( paramMap );
    }
	@Override
    public Object selectSettleCycleInfoTotal(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectSettleCycleInfoTotal( paramMap );
    }
	
	@Override
    public List<Map<String,Object>> selectCoInfo(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectCoInfo( paramMap );
    }
	@Override
    public Object selectCoInfoTotal(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectCoInfoTotal( paramMap );
    }
	
	@Override
    public List<Map<String,Object>> selectAffInfo(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectAffInfo( paramMap );
    }
	@Override
    public Object selectAffInfoTotal(Map< String, Object > paramMap) throws Exception {
    	return historySearchDAO.selectAffInfoTotal( paramMap );
    }
}
