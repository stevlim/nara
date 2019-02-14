package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface HistorySearchService
{
	//히스토리 기준정보변경이력조회
	List<Map<String,Object>> selectChangeHistoryDetail(Map< String, Object > paramMap) throws Exception;
	Object selectChangeHistoryDetailTotal(Map< String, Object > paramMap) throws Exception;
	
	//히스토리 수수료정보이력조회
	List<Map<String,Object>> selectFeeInfo(Map< String, Object > paramMap) throws Exception;
	Object selectFeeInfoTotal(Map< String, Object > paramMap) throws Exception;
	
	//히스토리 정산주기조회
	List<Map<String,Object>> selectSettleCycleInfo(Map< String, Object > paramMap) throws Exception;
	Object selectSettleCycleInfoTotal(Map< String, Object > paramMap) throws Exception;
	
	//히스토리 사업자입금정보조회
	List<Map<String,Object>> selectCoInfo(Map< String, Object > paramMap) throws Exception;
	Object selectCoInfoTotal(Map< String, Object > paramMap) throws Exception;
	
	//히스토리 제휴사연동정보조회
	List<Map<String,Object>> selectAffInfo(Map< String, Object > paramMap) throws Exception;
	Object selectAffInfoTotal(Map< String, Object > paramMap) throws Exception;
}
