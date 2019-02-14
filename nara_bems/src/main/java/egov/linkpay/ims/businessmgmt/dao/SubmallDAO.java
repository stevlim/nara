package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;
@Repository("submallDAO")
public class SubmallDAO extends BaseDAO
{
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardStatusList(Map<String, Object> objMap) throws Exception {
        return selectList("submall.selectCardStatusList", objMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardStatusInfo(Map<String, Object> objMap) throws Exception {
        return selectList("submall.selectCardStatusInfo", objMap);
    }
	
	public Object selectCardStatusListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("submall.selectCardStatusListTotal", objMap);
    }
	
	public Object selectCardSubMallInfo(Map<String, Object> objMap) throws Exception {
        return selectOne("submall.selectCardSubMallInfo", objMap);
    }
	
	public Object insertSubMallRsltManual(Map<String, Object> objMap) throws Exception {
    	return insert("submall.insertSubMallRsltManual", objMap);
    }
	public int updateSubMallRsltManual(Map<String, Object> objMap) throws Exception {
		int cnt = 1;
		cnt = 	(int)insert("submall.updateSubMallRsltManual", objMap);
    	return cnt;
    }
}
