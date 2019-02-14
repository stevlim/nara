package egov.linkpay.ims.rmApproval.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("rmApprovalDAO")
public class RmApprovalDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	/* -----  newContComp controller  -------*/ 
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectContCompList(Map<String, Object> params) throws Exception {
		return selectList("contComp.selectContCompList", params);
    }
	@SuppressWarnings( "unchecked" )
	public Object selectContCompListCnt(Map<String, Object> params) throws Exception {
		return selectOne("contComp.selectContCompListCnt", params);
    }
	
	/* -----  ApproveLimit  controller  -------*/
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> getContLimitList(Map<String, Object> params) throws Exception {
		return (List<Map<String, Object>>) selectList("rmApproval.getContLimitList", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public Map<String, Object> getContLimitDetail(Map<String, Object> params) throws Exception {
		return (Map<String, Object>) selectOne("rmApproval.getContLimitDetail", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> getCateCodeList(Map<String, Object> params) throws Exception {
		return (List<Map<String, String>>) selectList("rmApproval.getCateCodeList", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> getSubCateCodeList(Map<String, Object> params) throws Exception {
		return (List<Map<String, String>>) selectList("rmApproval.getSubCateCodeList", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int getContLimitDulicateCnt(Map<String, Object> params) throws Exception {
		return (int) selectOne("rmApproval.getContLimitDulicateCnt", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int insContLimit(Map<String, Object> params) throws Exception {
		return (int)insert("rmApproval.insContLimit", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int insLimitNotiConfig(Map<String, Object> params) throws Exception {
		return (int)insert("rmApproval.insLimitNotiConfig", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int updateContLimit(Map<String, Object> params) throws Exception {
		return (int)update("rmApproval.updateContLimit", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int upLimitNotiConfig(Map<String, Object> params) throws Exception {
		return (int)update("rmApproval.upLimitNotiConfig", params);
    }
	
}
