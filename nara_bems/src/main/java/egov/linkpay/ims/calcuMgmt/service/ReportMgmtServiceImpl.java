package egov.linkpay.ims.calcuMgmt.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.BaseInfoRegistrationDAO;
import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;
import egov.linkpay.ims.calcuMgmt.dao.CalcuMgmtDAO;
import egov.linkpay.ims.calcuMgmt.dao.ReportMgmtDAO;

@Service("reportMgmtService")
public class ReportMgmtServiceImpl implements ReportMgmtService
{
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name="reportMgmtDAO")
    private ReportMgmtDAO reportMgmtDAO;

	@Override
    public List<Map<String, String>> selectCode2List(Map<String,Object> paramMap) throws Exception {
        return reportMgmtDAO.selectCode2List(paramMap);
    }
	public Map<String, Object> stmtInfoChk(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		int idChk = 0;
		int cnt = 0;
		try
		{
			if(!paramMap.get( "division" ).equals( "ALL" ))
			{
				idChk = reportMgmtDAO.selectStmtIdChk( paramMap );
				if(idChk == 0 )
				{
					resultMap.put( "resultCd", "9999");
					resultMap.put( "resultMsg", "해당 ID는 정산 대상 ID가 아닙니다." );
				}
				else
				{
					cnt = reportMgmtDAO.selectStmtCnt( paramMap );
					if(cnt > 0 )
					{
						resultMap.put( "resultCd", "9999");
						resultMap.put( "resultMsg", "해당 ID는 이미 정산 데이터가 존재합니다." );
					}
				}
			}
		}
		catch(Exception e)
		{
			log.error( "Exception : " , e );
		}
		return resultMap;
	}
	public Map<String, Object> selectStmtList(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
		int idChk = 1;
		int cnt = 0;
		int total =0;
		try
		{
			if(!paramMap.get( "division" ).equals( "ALL" ))
			{
				idChk = reportMgmtDAO.selectStmtIdChk( paramMap );
				if(idChk == 0 )
				{
					resultMap.put( "resultCd", "9999");
					resultMap.put( "resultMsg", "해당 ID는 정산 대상 ID가 아닙니다." );
					return resultMap;
				}
				else
				{
					cnt = reportMgmtDAO.selectStmtCnt( paramMap );
//					if(cnt > 0 )
//					{
//						resultMap.put( "resultCd", "9999");
//						resultMap.put( "resultMsg", "해당 ID는 이미 정산 데이터가 존재합니다." );
//						return resultMap;
//					}else{
						//일단 삭제 테이블 없는고로 그 부분 체크해볼것
						listMap = reportMgmtDAO.selectStmtList( paramMap );
						resultMap.put( "listMap", listMap );
						total = reportMgmtDAO.selectStmtListTotal( paramMap );
						resultMap.put( "listCnt", total );
//					}
				}
			}
			else
			{
				cnt = reportMgmtDAO.selectStmtCnt( paramMap );
				listMap = reportMgmtDAO.selectStmtList( paramMap );
				resultMap.put( "listMap", listMap );
				total = reportMgmtDAO.selectStmtListTotal( paramMap );
				resultMap.put( "listCnt", total );
			}
		}
		catch(Exception e)
		{
			log.error( "Exception : " , e );
			resultMap.put( "resultCd", "9999");
		}
		resultMap.put( "resultCd", "0000");

        return resultMap;
    }
	//보류/해제/별도가감 리스트
	@Override
    public List<Map<String, Object>> selectResrList(Map<String,Object> paramMap) throws Exception {
        return reportMgmtDAO.selectResrList(paramMap);
    }
    public int selectResrListTotal(Map<String,Object> paramMap) throws Exception {
        return reportMgmtDAO.selectResrListTotal(paramMap);
    }
    //보류잔액 조회
    public int selectAmtChk(Map<String,Object> paramMap) throws Exception {
        return reportMgmtDAO.selectAmtChk(paramMap);
    }
    //보류/해제/별도가감 등록
    public Map<String, Object> insertResrExtra(Map<String,Object> paramMap) throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	int cnt =0;
    	int rtn = 0;
    	try
    	{
    		//사업자별 매출 집계 리스트(휴대폰)
    		cnt = reportMgmtDAO.selectConfSearCnt(paramMap);

    		//확정 건일 경우
    		if(cnt > 0 )
    		{
    			resultMap.put( "retCnt", -4 );
    			resultMap.put( "resultCd", "9999");
    			resultMap.put( "resultMsg", "이미 확정된 건입니다.\n개발팀과 협의하세요.");
    			return resultMap;
    		}
    		if(paramMap.get( "selCD1" ).equals( "01" ))
    		{
    			// 지급보류
    			log.info( "지급 보류 등록 " );
    			rtn = reportMgmtDAO.insertResrSet(paramMap);
    			String seq = String.valueOf( paramMap.get( "seq" ) );
    			log.info( "지급 보류 등록 seq : " + seq );
    			paramMap.put( "seq", seq );
    			rtn = reportMgmtDAO.insertResr(paramMap);
    		}
    		else if(paramMap.get( "selCD1" ).equals( "02" ))
    		{
    			// 보류해제 id의 보류 금액 확인
    			int resvTot = reportMgmtDAO.selectResrSumOfId(paramMap);
    			//해제 금액
    			int ccAmt = Integer.parseInt( paramMap.get( "amt" ).toString());

    			if(resvTot == 0 )
    			{
    				//해제할 금액이 없음
    				resultMap.put( "retCnt", -1 );
    				resultMap.put( "resultCd", "9999");
        			resultMap.put( "resultMsg", "보류 금액이 0원 입니다.");
        			return resultMap;
    			}
    			// 해제금액은 보류금액보다 클 수 없다
    			else if(resvTot < 0 && ccAmt <0 && resvTot > ccAmt)
    			{
    				// 둘다 마이너스일 경우
    				resultMap.put( "retCnt", -2 );
    				resultMap.put( "resultCd", "9999");
        			resultMap.put( "resultMsg", "해제 금액은 보류 금액의 합보다 클 수 없습니다.");
    			}
    			else if(resvTot < 0 && ccAmt <0 && resvTot > ccAmt)
    			{
    				// 둘다 플러스일 경우
    				resultMap.put( "retCnt", -2 );
    				resultMap.put( "resultCd", "9999");
        			resultMap.put( "resultMsg", "해제 금액은 보류 금액의 합보다 클 수 없습니다..");
    			}
    			else if((resvTot > 0 && ccAmt <0) && (resvTot < 0 && ccAmt > 0) )
    			{
    				// 부호가 다를 경우  처리불가
    				resultMap.put( "retCnt", -3 );
    				resultMap.put( "resultCd", "9999");
        			resultMap.put( "resultMsg", "해제 금액과 보류 금액의 합의 부호가 다릅니다.\n개발팀과 협의하세요..");
    			}
    			else
				{
    				//보류 리스트 조회
    				Map<String, Object> map = new HashMap<String, Object>();
    				list = reportMgmtDAO.selectResrSearchOfId(paramMap);
    				if(list.size() > 0 )
    				{
    					for(int i=0; i< list.size(); i++)
    					{
    						map = list.get(i);
    						int seq = ((BigDecimal)map.get("SEQ")).intValue();
    						int resrAmt = ((BigDecimal)map.get("RESR_AMT")).intValue();
    						paramMap.put( "seq", seq );
    						// 보류 금액이 작거나 같은 경우 보류 금액만큼 해제
							if(Math.abs(resrAmt) <= Math.abs(ccAmt)) {
								paramMap.put("setAmt", resrAmt);

								rtn = reportMgmtDAO.updateResrCcPart(paramMap);
								rtn = reportMgmtDAO.insertResrCcPart(paramMap);

								ccAmt = ccAmt - resrAmt;
							} else { // 보류 금액이 클 경우 전체(해제금액 만큼) 해제
								paramMap.put("setAmt", ccAmt);

								rtn = reportMgmtDAO.updateResrCcAll(paramMap);
								rtn = reportMgmtDAO.insertResrCcAll(paramMap);

								ccAmt = 0;
								break;
							}
    					}
    				}
				}
    		}
    		else
    		{
    			 // 별도가감
    			rtn = reportMgmtDAO.insertExtra(paramMap);
    		}
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception Error : " ,e );
    		resultMap.put( "resultCd", "9999" );
    		resultMap.put( "resultMsg", "저장 실패. 개발팀에 문의하세요" );
    		return resultMap;
    	}
    	resultMap.put( "resultCd", "0000" );
    	return resultMap;
    }
    //임의지급보류 등록
    public Map<String, Object> insertResrSet(Map<String,Object> paramMap) throws Exception {
    	Map<String, Object> resultMap = new HashMap<>();
    	int chk =0 ;
    	int cnt =0 ;
    	try
    	{
    		log.info( "임의지급보류 등록 - 임의지급보류등록여부체크 " );
    		chk = reportMgmtDAO.selectResrSetChk(paramMap);
    		if(chk == 0)
    		{
    			cnt = resrSetReg(paramMap);
    		}
    		if(cnt == 0 )
    		{
    			resultMap.put( "resultCd", "9999" );
    			resultMap.put( "resultMsg", "proc fail " );
    			return resultMap;
    		}
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception error : " , e );
    		resultMap.put( "resultCd", "9999" );
    		resultMap.put( "resultMsg", "Exception Error. " );
    		return resultMap;
    	}
    	resultMap.put( "resultCd", "0000" );

        return resultMap;
    }
    public int resrSetReg(Map<String,Object> paramMap) throws Exception {
    	int iChk = 0;
    	int cnt = 0;
    	log.info( "임의 지급 보류 등록 조회 " );
    	iChk = reportMgmtDAO.selectResrSet(paramMap);

    	try
    	{
    		//디비 존재시 update
    		if(iChk > 0 )
    		{
    			log.info( "임의지급보류 존재 업데이트" );
//    			if(paramMap.get( "" ).equals( "1" ))
//    			{
//    				cnt = reportMgmtDAO.updateResr(paramMap);
//    			}
//    			else if(paramMap.get( "" ).equals( "2" ))
//    			{
//    				cnt = reportMgmtDAO.updateResrCan(paramMap);
//    			}
//    			else if(paramMap.get( "" ).equals( "3" ))
//    			{
//    				cnt = reportMgmtDAO.updateResrDel(paramMap);
//    			}
    		}
    		else
    		{
    			log.info( "임의지급보류 존재 x " );
    			cnt = reportMgmtDAO.insertResrSetReg(paramMap);
    		}
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception error : " ,e );
    	}
    	return cnt;
    }
    //임의지급보류 리스트
    @Override
    public List<Map<String, Object>> selectResrSetList(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectResrSetList(paramMap);
    }
	public int selectResrSetListTotal(Map<String,Object> paramMap) throws Exception {
		return reportMgmtDAO.selectResrSetListTotal(paramMap);
	}
	//지급데이터 검증 리스트
	@Override
    public List<Map<String, Object>> selectStmtInsList(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectStmtInsList(paramMap);
    }
	@Override
	public List<Map<String, Object>> selectStmtFeeInsList(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectStmtFeeInsList(paramMap);
    }
	@Override
	public List<Map<String, Object>> selectStmtOffInsList(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectStmtOffInsList(paramMap);
    }
	//지급보고서작성 리스트
    @Override
    public List<Map<String, Object>> selectStmtPayRepList(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectStmtPayRepList(paramMap);
    }
	public int selectStmtPayRepListTotal(Map<String,Object> paramMap) throws Exception {
		if(paramMap.get( "id" ) == null || paramMap.get( "id" ).equals( "" ))
		{
			paramMap.put( "id", "ALL" );
		}
		return reportMgmtDAO.selectStmtPayRepListTotal(paramMap);
	}
	//송금보고서 확정 정보
    public Map<String, Object> selectReportSearch(Map<String,Object> paramMap) throws Exception {
    	Map<String, Object> resultMap = new HashMap<>();
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
    	try
    	{
    		list = reportMgmtDAO.selectSendPmReport(paramMap);
    		dataMap = list.get( 0 );
    		resultMap.put( "pmReport", dataMap );

    		list = reportMgmtDAO.selectSendReportConfData(paramMap);
    		dataMap = list.get( 0 );
    		resultMap.put( "confData", dataMap );

    		list = reportMgmtDAO.selectTransRefundCnt(paramMap);
    		dataMap = list.get( 0 );
    		resultMap.put( "refundCnt", dataMap );

    		resultMap.put( "resultCd", "0000" );
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception : " ,e );
    		resultMap.put( "resultCd", "9999" );
    		resultMap.put( "resultMsg", "Exception Fail" );
    	}

    	return resultMap;
    }
    //송금보고서확정 리스트
    @Override
    public List<Map<String, Object>> selectSendList(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectSendList(paramMap);
    }
    @Override
    public List<Map<String, Object>> selectSendReport(Map<String,Object> paramMap) throws Exception {
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
    	Map<String,Object> dataMap = new HashMap<String,Object>();
    	list = reportMgmtDAO.selectSendPmReport(paramMap);
    	dataMap = list.get( 0 );
    	resultList.add( 0, dataMap );

    	list = reportMgmtDAO.selectSendReportConfData(paramMap);
    	dataMap = list.get( 0 );
    	resultList.add( 1, dataMap );

    	return resultList;
    }
    @Override
    public List<Map<String, Object>> selectPgStmtDetail(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectPgStmtDetail(paramMap);
    }
    @Override
    public List<Map<String, Object>> selectSendRefund(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectTransRefund(paramMap);
    }
    //미지급금 등록
    public int insertUnStmtReg(Map<String,Object> paramMap) throws Exception {
    	int cnt = 0;


    	try
    	{
    		String orgStmtDt = "";
    		String mid = "";
    		String noPayAmt = "";
    		String reason = "";
    		Map<String, Object> dataMap = new HashMap<String,Object>();
    		for(int i=0; i<=4; i++ )
    		{
    			if(paramMap.get( "orgStmtDt"+i)==null){}
    			else{
    				orgStmtDt = (String)paramMap.get( "orgStmtDt"+i );
    				dataMap.put( "orgStmtDt", orgStmtDt.replaceAll( "/", "" ) );
				}
    			if(paramMap.get( "mid"+i)==null){}
    			else{
    				mid = (String)paramMap.get( "mid"+i );
    				dataMap.put( "mid", mid );
				}
    			if(paramMap.get( "noPayAmt"+i)==null){}
    			else{
    				noPayAmt = (String)paramMap.get( "noPayAmt"+i );
    				dataMap.put( "noPayAmt", noPayAmt.replaceAll( ",", "" ) );
				}
    			if(paramMap.get( "reason"+i)==null){}
    			else{
    				reason = (String)paramMap.get( "reason"+i );
    				dataMap.put( "reason", reason );
				}
    			dataMap.put( "worker", paramMap.get( "worker" ) );

    			cnt = reportMgmtDAO.insertUnStmtReg(dataMap);
    		}
    	}
    	catch(Exception e)
    	{
    		log.info( "Exception error : " , e  );
    		cnt = 9999;
    	}

        return cnt;
    }
    //미지급금 수정
    public int updateUnStmtReg(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.updateUnStmtReg(paramMap);
    }
  	//미지급금 리스트
    @Override
    public List<Map<String, Object>> selectUnStmtRegList(Map<String,Object> paramMap) throws Exception {
    	return reportMgmtDAO.selectUnStmtRegList(paramMap);
    }
	public int selectUnStmtRegListTotal(Map<String,Object> paramMap) throws Exception {
		return reportMgmtDAO.selectUnStmtRegListTotal(paramMap);
	}
}
