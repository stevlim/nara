package egov.linkpay.ims.paymentMgmt.service;

import java.util.List;
import java.util.Map;

public interface CardPaymentMgmtService
{
	//결제처리조회리스트 
	List<Map<String, Object>> selectTransInfoList(Map<String, Object> objMap) throws Exception;
	
	Object selectTransInfoListTotal(Map<String, Object> objMap) throws Exception;
	
	List<Map<String, Object>> selectTransFailInfoList(Map<String, Object> objMap) throws Exception;
	
	Object selectTransFailInfoListTotal(Map<String, Object> objMap) throws Exception;
	
	List<Map<String, Object>> selectCardInfoAmt(Map<String, Object> objMap) throws Exception;
	
	Map<String, Object> selectSerTidInfo(Map<String, Object> objMap) throws Exception;
	
	//결제처리조회total리스트 
	List<Map<String, Object>> selectTransInfoTotalList(Map<String, Object> objMap) throws Exception;
	
	Object selectTransInfoTotalListTotal(Map<String, Object> objMap) throws Exception;
	List<Map<String, Object>> selectCardInfoTotAmt(Map<String, Object> objMap) throws Exception;
	
	
	//카드 이벤트 리스트
	List<Map<String, Object>> selectCheckCardEventList(Map<String, Object> objMap) throws Exception;
	
	Object selectCheckCardEventListTotal(Map<String, Object> objMap) throws Exception;
	
	
	Map<String,Object> selectPwChk(Map<String, Object> objMap) throws Exception;
	
	Map<String,Object> selectMailSendSearch(Map<String, Object> objMap) throws Exception;
	
	Map<String, Object> selectSerTidFailInfo(Map<String, Object> objMap) throws Exception;

	Map<String, Object> selectRecpt(String tid) throws Exception;
}
