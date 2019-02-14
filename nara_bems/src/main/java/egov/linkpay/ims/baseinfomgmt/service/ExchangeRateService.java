package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface ExchangeRateService
{
	//환율정보 insert
	void insertExRate(Map< String, Object > paramMap) throws Exception;
	//환율 조회
	List<Map<String,Object>> selectExRate(Map< String, Object > paramMap) throws Exception;
	Object selectExRateTotal(Map< String, Object > paramMap) throws Exception;
}
