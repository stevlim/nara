package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface CreditCardVANMgmtService
{
	//van 이용실적
	List<Map<String, Object>> selectVanList(Map< String, Object > paramMap) throws Exception;
	//van 정보
	List<Map<String, Object>> selectVanInfoList(Map< String, Object > paramMap) throws Exception;
	Object selectVanInfoListTotal(Map< String, Object > paramMap) throws Exception;
}
