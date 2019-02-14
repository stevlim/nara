package egov.linkpay.ims.rmApproval.service;

import java.util.List;
import java.util.Map;

public interface RmApprovalService
{
	
	/* -----  newContComp controller  -------*/ 
	List<Map<String, Object>> selectContCompList(Map<String, Object> params) throws Exception;
	
	Object selectContCompListCnt(Map<String, Object> params) throws Exception;
	
	/* -----  ApproveLimit  controller  -------*/
	
	List<Map<String, Object>> getContLimitList(Map<String, Object> params) throws Exception;
	
	Map<String, Object> getContLimitDetail(Map<String, Object> params) throws Exception;
	
	List<Map<String, String>> getCateCodeList(Map<String, Object> params) throws Exception;
	
	List<Map<String, String>> getSubCateCodeList(Map<String, Object> params) throws Exception;
	
	int getContLimitDulicateCnt(Map<String, Object> params) throws Exception;
	
	int insContLimit(Map<String, Object> params) throws Exception;
	
	int insLimitNotiConfig(Map<String, Object> params) throws Exception;
	
	int updateContLimit(Map<String, Object> params) throws Exception;
	
	int upLimitNotiConfig(Map<String, Object> params) throws Exception;
	
}
