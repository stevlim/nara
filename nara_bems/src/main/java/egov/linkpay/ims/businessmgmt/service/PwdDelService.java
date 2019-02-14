package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

public interface PwdDelService
{
	//비밀번호 초기화 list 조회
  	List<Map<String, Object>> selectPWDList(Map<String, Object> objMap) throws Exception;
  	
  	//비밀번호 초기화 list 조회 total
  	Object selectPWDListTotal(Map<String, Object> objMap) throws Exception;
  	
  	//비번 초기화 업데이트
  	void updatePwdInit(Map<String, Object> objMap) throws Exception;
  	//거래취소 비번 초기화 업데이트
  	void updateChangeCcPw(Map<String, Object> objMap) throws Exception;
  	
}
