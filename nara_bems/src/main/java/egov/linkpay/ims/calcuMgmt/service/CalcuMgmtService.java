package egov.linkpay.ims.calcuMgmt.service;

import java.util.List;
import java.util.Map;

public interface CalcuMgmtService
{
	//신용카드 입금보고서 Count
	Map<String, Object> getCardSettlmntLstCnt(Map<String, Object> params) throws Exception;
	
	//신용카드 입금보고서 List
	List<Map<String, Object>> getCardSettlmntLst(Map<String, Object> params) throws Exception;
	
	Map<String, Object> getReceiveDeferLstCnt(Map<String, Object> params) throws Exception;
	
	List<Map<String, Object>> getReceiveDeferLst(Map<String, Object> params) throws Exception;
	
	int delAcqSettExp(Map<String, Object> params) throws Exception;
	
	Map<String, Object> getCardSettlmntExpLstCnt(Map<String, Object> params) throws Exception;
	
	List<Map<String, Object>> getCardSettlmntExpLst(Map<String, Object> params) throws Exception;
	
	int insCardSettlmntRD(Map<String, Object> params) throws Exception;
	
	int insCardSettlmntExp(Map<String, Object> params) throws Exception;
	
	Map<String, Object> getReceiveDeferGetTIDData(String params) throws Exception;
	
	
	
	//입금보고서
	
	List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception;
	
	Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception;
	
	List<Map<String, Object>> selectUserAccountMgmtListDetail(Map<String, Object> objMap) throws Exception;
	
	Object selectUserAccountMgmtListCntDetail(Map<String, Object> objMap) throws Exception;
	
	List<Map<String, Object>> selectDepositSum(Map<String, Object> objMap) throws Exception;
	
	List<Map<String, Object>> selectTidDetail(Map<String, Object> objMap) throws Exception;
	
	
	
	//입금보류/해제/별도가감
	List<Map<String, Object>> selectEtcDepositList(Map<String, Object> objMap) throws Exception;

    Object selectEtcDepositListCnt(Map<String, Object> objMap) throws Exception;
	
}
