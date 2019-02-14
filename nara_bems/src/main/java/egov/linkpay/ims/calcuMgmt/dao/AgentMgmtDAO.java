package egov.linkpay.ims.calcuMgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("agentMgmtDAO")
public class AgentMgmtDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	//정산재생성 기생성건 확인
	public Object selectAgentStmtCnt(Map<String, Object> paramMap) throws Exception{
		return selectOne( "agentMgmt.selectAgentStmtCnt", paramMap );
	}
	//기생성건 삭제 
	public void deleteAgentStmt(Map<String, Object> paramMap) throws Exception{
		delete( "agentMgmt.deleteAgentStmt", paramMap );
	}
	//정산 재생성
	public void insertReAgentStmt(Map<String, Object> paramMap) throws Exception{
		insert( "agentMgmt.insertReAgentStmt", paramMap );
	}
	//정산재생성 생성리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectReAgentStmt(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectReAgentStmt", paramMap);
	}
	//보류/해제/별도가감/이월 보류잔액
	public long selectAgentResrRemainAmt(Map<String, Object> paramMap) throws Exception{
		return (long)selectOne( "agentMgmt.selectAgentResrRemainAmt", paramMap);
	}
	//보류/해제/별도가감/이월 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAgentResrEtcList(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentResrEtcList", paramMap);
	}
	public int selectAgentResrEtcListTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectAgentResrEtcListTotal", paramMap);
	}
	//보류/해제/별도가감/이월 등록 전 vid 조회
	public int selectExistChkVid(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectExistChkVid", paramMap);
	}
	//보류/해제/별도가감/이월 등록
	public int selectAgentResrConfSearchCnt(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectAgentResrConfSearchCnt", paramMap);
	}
	public int insertAgentResrSet(Map<String, Object> paramMap) throws Exception{
		return (Integer)insert( "agentMgmt.insertAgentResrSet", paramMap);
	}
	public int insertAgentResr(Map<String, Object> paramMap) throws Exception{
		return (Integer)insert( "agentMgmt.insertAgentResr", paramMap);
	}
	public int selectAgentResrSumOfId(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectAgentResrSumOfId", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAgentResrSearchOfId(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentResrSearchOfId", paramMap);
	}
	public int updateAgentResrCcPart(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentResrCcPart", paramMap);
	}
	public int insertAgentResrCcPart(Map<String, Object> paramMap) throws Exception{
		return (Integer)insert( "agentMgmt.insertAgentResrCcPart", paramMap);
	}
	public int updateAgentResrCcAll(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentResrCcAll", paramMap);
	}
	public int insertAgentResrCcAll(Map<String, Object> paramMap) throws Exception{
		return (Integer)insert( "agentMgmt.insertAgentResrCcAll", paramMap);
	}
	public int insertAgentExtra(Map<String, Object> paramMap) throws Exception{
		return (Integer)insert( "agentMgmt.insertAgentExtra", paramMap);
	}
	//보류/해제/별도가감/이월 삭제
	public int updateAgentExtraHistory(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentExtraHistory", paramMap);
	}
	public int selectAgentResrEtcSearchCnt(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectAgentResrEtcSearchCnt", paramMap);
	}
	public int updateAgentReserveSet(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentReserveSet", paramMap);
	}
	public int updateAgentReserveSetCc(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentReserveSetCc", paramMap);
	}
	public int updateAgentReserve(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentReserve", paramMap);
	}
	//정산보고서발송 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAgentStmtReportList(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentStmtReportList", paramMap);
	}
	public int selectAgentStmtReportListTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectAgentStmtReportListTotal", paramMap);
	}
	//정산보고서발송 상세정보 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAgentCompPayAmtListDetail(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentCompPayAmtListDetail", paramMap);
	}
	public int selectAgentCompPayAmtListDetailTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectAgentCompPayAmtListDetailTotal", paramMap);
	}
	//정산보고서발송 조회
	public Object selectAgentStmtTaxAccount(Map<String, Object> paramMap) throws Exception{
		return selectOne( "agentMgmt.selectAgentStmtTaxAccount", paramMap);
	}
	//정산보고서작성 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAgentStmtConfirmList(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentStmtConfirmList", paramMap);
	}
	public int selectAgentStmtConfirmListTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectAgentStmtConfirmListTotal", paramMap);
	}
	//반송조회/처리 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAgentStmtConfList(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentStmtConfList", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAgentStmtUserRecord(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentStmtUserRecord", paramMap);
	}
//	public int selectAgentStmtConfListTotal(Map<String, Object> paramMap) throws Exception{
//		return (Integer)selectOne( "agentMgmt.selectAgentStmtConfListTotal", paramMap);
//	}
	//보고서 확정 저장 
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectAgentStmtCarryConfVid(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentStmtCarryConfVid", paramMap);
	}
	public int updateConfAgentStmtCarry(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfAgentStmtCarry", paramMap);
	}
	public int updateConfStmtSecEmp(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfStmtSecEmp", paramMap);
	}
	public int updateConfStmtThrEmp(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfStmtThrEmp", paramMap);
	}
	//보고서 확정 취소 
	public int updateConfStmtFirEmp(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfStmtFirEmp", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectAgentStmtCarryCanVid(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentStmtCarryCanVid", paramMap);
	}
	public int updateConfAgentStmtCarryCan(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfAgentStmtCarryCan", paramMap);
	}
	public int updateConfCanSecEmp(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfCanSecEmp", paramMap);
	}
	public int updateConfCanThrEmp(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfCanThrEmp", paramMap);
	}
	//보고서 확정 등록비배분 상세 내역 리스트 조회 
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectAgentCoPayAmtDetail(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentCoPayAmtDetail", paramMap);
	}
	//보고서 확정 이월내역 상세 리스트 조회 
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectAgentStmtCarryDetail(Map<String, Object> paramMap) throws Exception{
		return selectList( "agentMgmt.selectAgentStmtCarryDetail", paramMap);
	}
	
	
	public int selectStatusCurMonStmt(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "agentMgmt.selectStatusCurMonStmt", paramMap);
	}
	public int updateConfStmtSave(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfStmtSave", paramMap);
	}
	public int updateConfStmtCancel(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfStmtCancel", paramMap);
	}
	public int updateConfAgentStmtCarryCance(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateConfAgentStmtCarryCance", paramMap);
	}
	public int selectAgentStmtCarryCnt(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.selectAgentStmtCarryCnt", paramMap);
	}
	public int updateAgentStmtCarry(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentStmtCarry", paramMap);
	}
	public int insertAgentStmtCarry(Map<String, Object> paramMap) throws Exception{
		return (Integer)insert( "agentMgmt.insertAgentStmtCarry", paramMap);
	}
	public int updateAgentStmtCarrySum(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateAgentStmtCarrySum", paramMap);
	}
	public int updateCarryStmtCancel(Map<String, Object> paramMap) throws Exception{
		return (Integer)update( "agentMgmt.updateCarryStmtCancel", paramMap);
	}
}
