package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface CardNonInstEventService
{
	//환율정보 insert
	int insertNoInstCardEvent(Map< String, Object > paramMap) throws Exception;
	//환율정보 update
	int updateNoInstCardEvent(Map< String, Object > paramMap) throws Exception;
	//환율 조회
	List<Map<String,Object>> selectNoInstCardEventList(Map< String, Object > paramMap) throws Exception;
	Object selectNoInstCardEventListTotal(Map< String, Object > paramMap) throws Exception;
}
