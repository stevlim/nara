package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface AffMgmtService
{
	//tb_code 조회
	List<Map<String, String>> selectCodeCl(String CodeCl) throws Exception;
	
	//제휴사 신용카드 조회
	List<Map<String,Object>> selectCreditCardList(Map< String, Object > paramMap) throws Exception;
	Object selectCreditCardListTotal(Map< String, Object> paramMap) throws Exception;

	//제휴사 신용카드 등록
	void insertCreditCardInfo(Map< String, Object > paramMap) throws Exception;
	
	//제휴사 신용카드 정보삭제
	Map< String, Object > deleteCardInfo(Map< String, Object > paramMap) throws Exception;
	
	//제휴사 신용카드 설정정보 조회 
	List<Map<String,Object>> selectCardSetData(Map< String, Object > paramMap) throws Exception;
	Object selectCardSetDataTotal(Map< String, Object > paramMap) throws Exception;
	
	//제휴사 신용카드 HISTORY 전조회
	List<Map<String,Object>> selectCardInfo(Map< String, Object > paramMap) throws Exception;
	Object selectCardInfoTotal(Map< String, Object > paramMap) throws Exception;
	
	//제휴사 신용카드 HISTORY 조회
	List<Map<String,Object>> selectCardHistory(Map< String, Object > paramMap) throws Exception;
	Object selectCardHistoryTotal(Map< String, Object > paramMap) throws Exception;

	//제휴사 VAN 터미널 등록  
	void insertVanTer(Map< String, Object > paramMap) throws Exception;
	
	//제휴사 VAN LIST 조회
	List<Map<String,Object>> selectVanTerInfo(Map< String, Object > paramMap) throws Exception;
	Object selectVanTerInfoTotal(Map< String, Object > paramMap) throws Exception;
}
