package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

public interface SubMallService
{
	//서브몰 제휴사 카드 리스트 조회 
  	Map<String, Object> selectCardStatusList(Map<String, Object> objMap) throws Exception;
  	
  	//서브몰 제휴사 카드 리스트 total
  	Object selectCardStatusListTotal(Map<String, Object> objMap) throws Exception;
  	
  	//서브몰 제휴사 카드 정보
  	Object selectCardSubMallInfo(Map<String, Object> objMap) throws Exception;
  	//서브몰 제휴사 카드 등록
  	int insertSubCardReg(Map<String, Object> objMap) throws Exception;
}
