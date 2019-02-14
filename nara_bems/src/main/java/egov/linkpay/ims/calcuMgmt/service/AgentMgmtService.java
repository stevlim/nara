package egov.linkpay.ims.calcuMgmt.service;

import java.util.List;
import java.util.Map;

public interface AgentMgmtService
{
	//정산재생성
	Map<String,Object> selectAgentStmtList(Map<String, Object> paramMap) throws Exception;
	//보류/해제/별도가감/이월 보류 잔액
	long selectAgentResrRemainAmt(Map<String, Object> paramMap) throws Exception;
	//보류/해제/별도가감/이월 리스트 조회
	List<Map<String,Object>> selectAgentResrEtcList(Map<String, Object> paramMap) throws Exception;
	int selectAgentResrEtcListTotal(Map<String, Object> paramMap) throws Exception;
	//보류/해제/별도가감/이월 등록
	Map<String,Object> insertAgentResrEtc(Map<String, Object> paramMap) throws Exception;
	//보류/해제/별도가감/이월 삭제	
	Map<String,Object> deleteAgentResrExtra(Map<String, Object> paramMap) throws Exception;
	//보류/해제/별도가감/이월 수정
		Map<String,Object> updateAgentResrEtc(Map<String, Object> paramMap) throws Exception;
	//반송조회/처리 결과 리스트 조회
	Map<String,Object> selectAgentStmtConfList(Map<String, Object> paramMap) throws Exception;
	//정산보고서발송 리스트 조회
	List<Map<String,Object>> selectAgentStmtReportList(Map<String, Object> paramMap) throws Exception;
	int selectAgentStmtReportListTotal(Map<String, Object> paramMap) throws Exception;
	//정산보고서 발송전 정보 조회]
	List<Map<String,Object>> selectVidInfo(String param) throws Exception;
	//정산보고서 발송
	Map<String,Object> sendAgentStmtTaxAccount(Map<String, Object> paramMap) throws Exception;
	//정산보고서작성 상세정보 리스트 조회
	List<Map<String,Object>> selectAgentCompPayAmtListDetail(Map<String, Object> paramMap) throws Exception;
	int selectAgentCompPayAmtListDetailTotal(Map<String, Object> paramMap) throws Exception;
	//정산보고서작성 리스트 조회
	List<Map<String,Object>> selectAgentStmtConfirmList(Map<String, Object> paramMap) throws Exception;
	int selectAgentStmtConfirmListTotal(Map<String, Object> paramMap) throws Exception;
	//정산 보고서 확정 
	Map<String,Object> updateAgentStmtAdSave(Map<String, Object> paramMap) throws Exception;
	//정산 보고서 확정취소
	Map<String,Object> updateAgentStmtAdCancel(Map<String, Object> paramMap) throws Exception;
	//정산보고서확정 등록비배분 상세내역 리스트 조회
	Map<String,Object> selectAgentCoPayAmtDetail(Map<String, Object> paramMap) throws Exception;
	//정산보고서확정 이월내역 상세 리스트 조회
	Map<String,Object> selectAgentStmtCarryDetail(Map<String, Object> paramMap) throws Exception;
	//정산보고서확정 확정취소
	Map<String,Object> updateConfStmtSave(Map<String, Object> paramMap) throws Exception;
}
