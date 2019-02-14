package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : net.ionpay.dashboard.businessmgmt.service
 * File Name      : NewContractMgmtService.java
 * Description    : 영업관리 - 신규계약관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface NewContractMgmtService {
    
    List<Map<String, Object>> selectCoNo(Map<String, Object> objMap) throws Exception;

    List<Map<String, String>> selectCodeCl(String CodeCl) throws Exception;
    
    Map<String, Object> selectCoIngView(Map<String, Object> objMap) throws Exception;
    
  //기본정보조회-담당자 리스트 
  	List<Map<String,String>> selectEmplList(Map< String, Object > paramMap) throws Exception;
  	
  	//카드 수수료 정보 
  	Map<String, Object> selectCardFeeInfo(Map<String, Object> objMap) throws Exception;
  	//카드 수수료 insert
  	Map<String, Object>  insertCardFeeReg(Map<String, Object> objMap) throws Exception;
  	
  	//가맹점 list 조회
  	List<Map<String, Object>> selectCoInfoList(Map<String, Object> objMap) throws Exception;
  	
  	//가맹점 list 조회 total
  	Object selectCoInfoListTotal(Map<String, Object> objMap) throws Exception;
  	
  	//img list 조회
  	List<Map<String, Object>> selectContImgList(Map<String, Object> objMap) throws Exception;
  	
  	//img list 조회 total
  	Object selectContImgListTotal(Map<String, Object> objMap) throws Exception;
  	
  	//가맹점 insert
  	Map<String, Object> insertCoInfo(Map<String, Object> objMap) throws Exception;
  	
  	int uploadContImg(Map<String, Object> objMap) throws Exception;
  	
  	//가맹점 신규계약 승인 list 조회
  	List<Map<String, Object>> selectCoApprInfoList(Map<String, Object> objMap) throws Exception;
  	Object selectCoApprInfoListTotal(Map<String, Object> objMap) throws Exception;
  	
  	//가맹점 신규계약 승인 list 조회 구분 mid
  	List<Map<String, Object>> selectCoApprMInfoList(Map<String, Object> objMap) throws Exception;
  	Object selectCoApprMInfoListTotal(Map<String, Object> objMap) throws Exception;
  	
 	//가맹점 신규계약 승인 list 조회 구분 vid
  	List<Map<String, Object>> selectCoApprVInfoList(Map<String, Object> objMap) throws Exception;
  	Object selectCoApprVInfoListTotal(Map<String, Object> objMap) throws Exception;
  	
  	//가맹점 승인 반려 update
  	void updateCoApp(Map<String, Object> objMap) throws Exception;
  	
  	Map<String, Object> selectCoView(Map<String, Object> objMap) throws Exception;
  	
  	Map<String, Object> selectFeeViewCardLst(Map<String, Object> objMap) throws Exception;
}
