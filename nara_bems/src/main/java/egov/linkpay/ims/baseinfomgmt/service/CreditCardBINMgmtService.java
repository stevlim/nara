package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface CreditCardBINMgmtService
{
	//카드 승인한도 리스트 
	List<Map<String,Object>> selectAppLmtList(Map< String, Object > paramMap) throws Exception;
	Object selectAppLmtListTotal(Map< String, Object > paramMap) throws Exception;
	//카드 BIN리스트 
	List<Map<String,Object>> selectCreditCardBINSearch(Map< String, Object > paramMap) throws Exception;
	Object selectCreditCardBINSearchTotal(Map< String, Object > paramMap) throws Exception;
}
