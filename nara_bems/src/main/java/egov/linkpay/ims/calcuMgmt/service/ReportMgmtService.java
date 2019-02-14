package egov.linkpay.ims.calcuMgmt.service;

import java.util.List;
import java.util.Map;

public interface ReportMgmtService
{
	//정산 구분
	List<Map<String, String>> selectCode2List(Map<String, Object> objMap) throws Exception;
	//정상 id 여부 확인 
	Map<String, Object> stmtInfoChk(Map<String, Object> params) throws Exception;
	//기생성건확인
	Map<String, Object> selectStmtList(Map<String, Object> paramMap) throws Exception;
	//보류/해제/별도가감 리스트
	List<Map<String, Object>> selectResrList(Map<String, Object> objMap) throws Exception;
	int selectResrListTotal(Map<String, Object> objMap) throws Exception;
	//보류잔액조회
	int selectAmtChk(Map<String, Object> objMap) throws Exception;
	//보류/해제/별도가감 등록
	Map<String, Object> insertResrExtra(Map<String, Object> params) throws Exception;
	//임의지급보류 등록
	Map<String, Object> insertResrSet(Map<String, Object> params) throws Exception;
	//임의지급보류 리스트
	List<Map<String, Object>> selectResrSetList(Map<String, Object> objMap) throws Exception;
	int selectResrSetListTotal(Map<String, Object> objMap) throws Exception;
	//지급데이터검증
	List<Map<String, Object>> selectStmtInsList(Map<String, Object> objMap) throws Exception;
	List<Map<String, Object>> selectStmtFeeInsList(Map<String, Object> objMap) throws Exception;
	List<Map<String, Object>> selectStmtOffInsList(Map<String, Object> objMap) throws Exception;
	//지급보고서작성 리스트
	List<Map<String, Object>> selectStmtPayRepList(Map<String, Object> objMap) throws Exception;
	int selectStmtPayRepListTotal(Map<String, Object> objMap) throws Exception;
	//송금보고서확정 정보
	Map<String, Object> selectReportSearch(Map<String, Object> params) throws Exception;
	//송금보고서확정 송금 엑셀
	List<Map<String, Object>> selectSendList(Map<String, Object> objMap) throws Exception;
	List<Map<String, Object>> selectSendReport(Map<String, Object> objMap) throws Exception;
	List<Map<String, Object>> selectPgStmtDetail(Map<String, Object> objMap) throws Exception;
	List<Map<String, Object>> selectSendRefund(Map<String, Object> objMap) throws Exception;
	//미지급금 금액 등록
	int insertUnStmtReg(Map<String, Object> objMap) throws Exception;
	//미지급금 금액 수정
	int updateUnStmtReg(Map<String, Object> objMap) throws Exception;
	//미지급금 리스트
	List<Map<String, Object>> selectUnStmtRegList(Map<String, Object> objMap) throws Exception;
	int selectUnStmtRegListTotal(Map<String, Object> objMap) throws Exception;
	
}
