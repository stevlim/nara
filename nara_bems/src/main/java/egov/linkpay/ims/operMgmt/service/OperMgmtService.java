package egov.linkpay.ims.operMgmt.service;

import java.util.List;
import java.util.Map;

public interface OperMgmtService
{
	//현금영수증 실패 처리 
	List<Map<String, Object>> uploadCashFailReReq(Map<String, Object> objMap) throws Exception;
}
