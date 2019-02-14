package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface BaseInfoMgmtService
{
	//기본정보조회 
	Map<String,Object> baseInfo(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-관리자 권한 조회 
	List<Map<String,Object>> selectEmpAuthSearch(Map< String, Object > paramMap) throws Exception;
	//기본정보조회 list
	List<Map<String,Object>> selectBaseInfoList(Map< String, Object > paramMap) throws Exception;
	int selectBaseInfoListTotal(Map< String, Object > paramMap) throws Exception;
	//기본정보조회 vid mid 정보
	List<Map<String,Object>> selectVMid(Map< String, Object > paramMap) throws Exception;
	
	// 다량등록 결과 리스트
	List<Map<String,Object>> insertMultiRegist(Map< String, Object > paramMap) throws Exception;
	
	//가맹점 key 조회
	List<Map<String,Object>> selectMerchantKeyInfo(Map< String, Object > paramMap) throws Exception;
	
	List<Map<String, Object>> selectSettleReqList(Map<String, Object> objMap) throws Exception;
	
	Object selectSettleReqListTotal(Map<String, Object> objMap) throws Exception;
	
	void updateSettleReqStatus(Map< String, Object > paramMap) throws Exception;
	
	//일반정보화면 일반정보 업데이트
	void updateNormalInfo(Map< String, Object > paramMap) throws Exception;
	
	void updateNormalGidInfo(Map< String, Object > paramMap) throws Exception;
	
	void updateNormalVidInfo(Map< String, Object > paramMap) throws Exception;
	
	//일반정보화면 거래취소비밀번호 등록
	void updateCancelTransPw(Map< String, Object > paramMap) throws Exception;
	
	//일반정보화면 담당자 연락처 업데이트
	void updateNormalTelInfo(Map< String, Object > paramMap) throws Exception;
		
	//일반정보화면 담당자 연락처 insert
	void insertNotiTransInfo(Map< String, Object > paramMap) throws Exception;
		
	//일반정보화면 결제 데이터 통보 업데이트
	void updateNotiTransInfo(Map< String, Object > paramMap) throws Exception;
	
	//일반정보화면 결제 데이터 통보 조회 
	int selectNotiTransInfo(Map< String, Object > paramMap) throws Exception;
		
	//일반정보조회 MID
	Map<String,Object> selectNormalInfo(Map< String, Object > paramMap) throws Exception;
	
	//일반정보조회 GID
	Map<String,Object> selectNormalGidInfo(Map< String, Object > paramMap) throws Exception;
		
	//일반정보조회 VID
	Map<String,Object> selectNormalVidInfo(Map< String, Object > paramMap) throws Exception;
}
