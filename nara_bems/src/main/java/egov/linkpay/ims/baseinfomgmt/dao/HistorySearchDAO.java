package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("historySearchDAO")
public class HistorySearchDAO extends BaseDAO
{
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectChangeList(Map<String, Object> objMap) throws Exception {
        return selectList("historySearch.selectChangeList", objMap);
    }
    public Object selectChangeGrpSeq(Map<String, Object> objMap) throws Exception {
        return selectOne("historySearch.selectChangeGrpSeq", objMap);
    }
    public void insertChangeInfo(Map< String, Object > dataMap) throws Exception {
		insert("historySearch.insertChangeInfo", dataMap);
	}
    public void insertChangeHistory(Map< String, Object > dataMap) throws Exception {
		insert("historySearch.insertChangeHistory", dataMap);
	}
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectChangeHistoryDetail(Map<String, Object> objMap) throws Exception {
        return selectList("historySearch.selectChangeHistoryDetail", objMap);
    }
	public Object selectChangeHistoryDetailTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("historySearch.selectChangeHistoryDetailTotal", objMap);
    }
	
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectFeeInfo(Map<String, Object> objMap) throws Exception {
        return selectList("historySearch.selectFeeInfo", objMap);
    }
    public Object selectFeeInfoTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("historySearch.selectFeeInfoTotal", objMap);
    }
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSettleCycleInfo(Map<String, Object> objMap) throws Exception {
        return selectList("historySearch.selectSettleCycleInfo", objMap);
    }
    public Object selectSettleCycleInfoTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("historySearch.selectSettleCycleInfoTotal", objMap);
    }
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoInfo(Map<String, Object> objMap) throws Exception {
        return selectList("historySearch.selectCoInfo", objMap);
    }
    public Object selectCoInfoTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("historySearch.selectCoInfoTotal", objMap);
    }
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectAffInfo(Map<String, Object> objMap) throws Exception {
        return selectList("historySearch.selectAffInfo", objMap);
    }
    public Object selectAffInfoTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("historySearch.selectAffInfoTotal", objMap);
    }
}
