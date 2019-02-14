package egov.linkpay.ims.calcuMgmt.service;

import java.util.List;
import java.util.Map;

public interface PurchaseMgmtService
{
	//보류/해제/별도가감 리스트
	Map<String, Object> selectPurchaseVeriList(Map<String, Object> objMap) throws Exception;
	
	// 차이건
	List<Map<String,Object>> selectAcqGap(Map<String, Object> paramMap) throws Exception;
	int selectAcqGapTotal(Map<String, Object> paramMap) throws Exception;
	//매입결과 tid별 리스트 조회
	List<Map<String,Object>> selectAcqTidRsltList(Map<String, Object> paramMap) throws Exception;
	int selectAcqTidRsltListTotal(Map<String, Object> paramMap) throws Exception;
	//매입결과 tid별 정보 조회
	Map<String,Object> selectAcqTidRsltInfo(Map<String, Object> paramMap) throws Exception;
	//매입결과 결과 리스트 조회
	List<Map<String,Object>> selectAcqRsltList(Map<String, Object> paramMap) throws Exception;
	int selectAcqRsltListTotal(Map<String, Object> paramMap) throws Exception;
	//반송조회/처리 결과 리스트 조회
	List<Map<String,Object>> selectAcqRetList(Map<String, Object> paramMap) throws Exception;
	int selectAcqRetListTotal(Map<String, Object> paramMap) throws Exception;
	//반송조회/처리 업데이트 
	Map<String,Object> updateRetProc(Map<String, Object> paramMap) throws Exception;
}
