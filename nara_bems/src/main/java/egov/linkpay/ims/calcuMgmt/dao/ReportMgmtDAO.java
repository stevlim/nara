package egov.linkpay.ims.calcuMgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("reportMgmtDAO")
public class ReportMgmtDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectCode2List(Map<String,Object> paramMap) throws Exception {
		return selectList( "common.selectCode2List", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectStmtList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectStmtList", paramMap);
    }
	public int selectStmtListTotal(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectStmtListTotal", paramMap);
		return cnt;
    }
	public int selectStmtIdChk(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectStmtIdChk", paramMap);
		return cnt;
    }
	public int selectStmtCnt(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectStmtCnt", paramMap);
		return cnt;
    }
	//보류/해제/별도가감 리스트 
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectResrList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectResrList", paramMap);
    }
	public int selectResrListTotal(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectResrListTotal", paramMap);
		return cnt;
    }
	//보류잔액조회
	public int selectAmtChk(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectAmtChk", paramMap);
		return cnt;
    }
	//보류/해제/별도가감 - 사업자별매출집계리스트(휴대폰)
	public int selectConfSearCnt(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectConfSearCnt", paramMap);
		return cnt;
    }
	//보류지급등록
	public int insertResrSet(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)insert( "reportMgmt.insertResrSet", paramMap);
		return cnt;
    }
	//보류지급업데이트
	public int insertResr(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)insert( "reportMgmt.insertResr", paramMap);
		return cnt;
    }
	// 보류해제 id의 보류 금액 확인 
	public int selectResrSumOfId(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectResrSumOfId", paramMap);
		return cnt;
    }
	//보류 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectResrSearchOfId(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectResrSearchOfId", paramMap);
    }
	// 보류 금액이 작거나 같은 경우 보류 금액만큼 해제 
	public int updateResrCcPart(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)update( "reportMgmt.updateResrCcPart", paramMap);
		return cnt;
    }
	public int insertResrCcPart(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)insert( "reportMgmt.insertResrCcPart", paramMap);
		return cnt;
    }
	// 보류 금액이 클 경우 전체(해제금액 만큼) 해제
	public int updateResrCcAll(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)update( "reportMgmt.updateResrCcAll", paramMap);
		return cnt;
    }
	public int insertResrCcAll(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)insert( "reportMgmt.insertResrCcAll", paramMap);
		return cnt;
    }
	//별도가감
	public int insertExtra(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)insert( "reportMgmt.insertExtra", paramMap);
		return cnt;
    }
	//임의지급보류등록여부체크 
	public int selectResrSetChk(Map<String,Object> paramMap) throws Exception {
		return (Integer)selectOne("reportMgmt.selectResrSetChk", paramMap);
    }
	//임의지급보류등록조회 
	public int selectResrSet(Map<String,Object> paramMap) throws Exception {
		return (Integer)selectOne("reportMgmt.selectResrSet", paramMap);
    }
	//임의지급보류등록 
	public int insertResrSetReg(Map<String,Object> paramMap) throws Exception {
		return (Integer)insert("reportMgmt.insertResrSetReg", paramMap);
    }
	//임의지급보류 리스트 
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectResrSetList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectResrSetList", paramMap);
    }
	public int selectResrSetListTotal(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectResrSetListTotal", paramMap);
		return cnt;
    }
	//지급데이터검증 리스트 
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectStmtInsList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectStmtInsList", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectStmtFeeInsList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectStmtFeeInsList", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectStmtOffInsList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectStmtOffInsList", paramMap);
    }
	//지급보고서 작성 리스트  
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectStmtPayRepList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectStmtPayRepList", paramMap);
    }
	public int selectStmtPayRepListTotal(Map<String,Object> paramMap) throws Exception {
		int cnt = 0;
		cnt =(Integer)selectOne( "reportMgmt.selectStmtPayRepListTotal", paramMap);
		return cnt;
    }
	//송금보고서확정  리스트  
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSendPmReport(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectSendPmReport", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSendReportConfData(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectSendReportConfData", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectTransRefundCnt(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectTransRefundCnt", paramMap);
	}
	//송금보고서확정  송금 내역 전송 파일 엑셀
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSendList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectSendList", paramMap);
	}
	//PG 정산 상세 내역
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectPgStmtDetail(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectPgStmtDetail", paramMap);
	}
	//송금보고서확정 직접환불내역
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectTransRefund(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectTransRefund", paramMap);
	}
	//미지급금 금액 등록 
	public int insertUnStmtReg(Map<String,Object> paramMap) throws Exception {
		return (Integer)insert("reportMgmt.insertUnStmtReg", paramMap);
    }
	//미지급금 금액 수정 
	public int updateUnStmtReg(Map<String,Object> paramMap) throws Exception {
		return (Integer)insert("reportMgmt.updateUnStmtReg", paramMap);
    }
	//미지급금 정산 리스트 
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectUnStmtRegList(Map<String,Object> paramMap) throws Exception {
		return selectList( "reportMgmt.selectUnStmtRegList", paramMap);
	}
	public int selectUnStmtRegListTotal(Map<String,Object> paramMap) throws Exception {
		return (Integer)insert("reportMgmt.selectUnStmtRegListTotal", paramMap);
    }
}
