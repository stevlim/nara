package egov.linkpay.ims.calcuMgmt.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.BaseInfoRegistrationDAO;
import egov.linkpay.ims.calcuMgmt.dao.AgentMgmtDAO;

@Service("agentMgmtService")
public class AgentMgmtServiceImpl implements AgentMgmtService
{
	Logger log = Logger.getLogger(this.getClass());
    
	@Resource(name="agentMgmtDAO")
    private AgentMgmtDAO agentMgmtDAO;
	
	@Resource(name="baseInfoRegistrationDAO")
    private BaseInfoRegistrationDAO baseInfoRegistrationDAO;
	
	//정산재생성 리스트 조회
	@Override
    public  Map<String, Object> selectAgentStmtList(Map<String,Object> paramMap) throws Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		
		log.info( "정산 재생성 리스트 조회 START" );
		try
		{
			//기생성건 확인
			log.info( "정산 재생성 리스트 조회 - 기생성건 확인" );
			dataMap = ( Map< String, Object > ) agentMgmtDAO.selectAgentStmtCnt(paramMap);
			
			int cnt = (dataMap.get( "CNT" )==null?0:(( BigDecimal ) dataMap.get( "CNT" )).intValue());
			int confCnt = (dataMap.get( "CONF_CNT" )==null?0:((BigDecimal)dataMap.get( "CONF_CNT" )).intValue());
			if(confCnt > 0)
			{
				log.info( "정산재생성 리스트 조회 - 이미 확정 또는 이월된 정산 데이터가 존재 " );
				resultMap.put( "resulCd", "9999" );
				resultMap.put( "resulMsg", "이미 확정 또는 이월된 정산 데이터가 존재합니다. 확정 취소 후 이용해주세요." );
				return resultMap;
			}
			else
			{
				if(cnt > 0)
				{
					log.info( "정산재생성 리스트 조회 - 해당 VID는 이미 정산 데이터가 존재 " );
					//기생성건 삭제 
					agentMgmtDAO.deleteAgentStmt(paramMap);
				}
				// 기 생성건이 존재할 경우 삭제 Flag로 iRtn 사용. (0 보다 크면 삭제)
			    // 정산 생성
				log.info( "정산재생성 리스트 조회 - 정산 생성 " );
				agentMgmtDAO.insertReAgentStmt(paramMap);
				
				//생성내역 조회
				log.info( "정산재생성 리스트 조회 - 정산 생성내역 조회" );
				List<Map<String,Object>> list  = agentMgmtDAO.selectReAgentStmt(paramMap);
				resultMap.put( "list", list );
			}
		}
		catch(Exception e)
		{
			log.error( "Exception error : " , e );
			resultMap.put( "resultCd", "9999"  );
			resultMap.put( "resultMsg", "Exception Error" );
			return resultMap;
		}
		
		resultMap.put( "resultCd", "0000" );
		
		return resultMap;
	}
	//보류/해제/별도가감/이월 보류잔액
	public  long selectAgentResrRemainAmt(Map<String,Object> paramMap) throws Exception {
		return agentMgmtDAO.selectAgentResrRemainAmt(paramMap);
	}
	//보류/해제/별도가감/이월 보류잔액 리스트조회
	@Override
	public  List<Map<String, Object>> selectAgentResrEtcList(Map<String,Object> paramMap) throws Exception {
		String frDt = (String)paramMap.get( "frYear" )+(String)paramMap.get( "frMon" );
		String toDt = (String)paramMap.get( "toYear" )+(String)paramMap.get( "toMon" );
		paramMap.put( "frDt", frDt );
		paramMap.put( "toDt", toDt );
		return agentMgmtDAO.selectAgentResrEtcList(paramMap);
	}
	public  int selectAgentResrEtcListTotal(Map<String,Object> paramMap) throws Exception {
		String frDt = (String)paramMap.get( "frYear" )+(String)paramMap.get( "frMon" );
		String toDt = (String)paramMap.get( "toYear" )+(String)paramMap.get( "toMon" );
		paramMap.put( "frDt", frDt );
		paramMap.put( "toDt", toDt );
		return agentMgmtDAO.selectAgentResrEtcListTotal(paramMap);
	}
	//보류/해제/별도가감/이월 등록 
	@Override
    public  Map<String, Object> insertAgentResrEtc(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0;
		int rtn = 0;
		try
		{
			log.info( "보류/해제/별도가감/이월 등록 전 VID 존재여부 체크 " );
			cnt = agentMgmtDAO.selectExistChkVid(paramMap);
			if(cnt > 0 )
			{
				int iCnt = 0;
				log.info( "보류/해제/별도가감/이월 등록 대리점 지정 날짜 확정건 카운트  " );
				iCnt = agentMgmtDAO.selectAgentResrConfSearchCnt(paramMap);
				//확정건일 경우
				if(iCnt > 0 )
				{
					log.info( "보류/해제/별도가감/이월 - 확정건일 경우" );
					resultMap.put( "resultCd", "-4" );
					resultMap.put( "resultMsg", "해당 지급월에 이미 확정/이뤌된 건이 존재합니다.\n개발팀과 협의하세요." );
					return resultMap;
				}
				//지급보류
				if(paramMap.get( "selCD1" ).equals( "01" ))
				{
					log.info( "보류/해제/별도가감/이월 - 지급보류" );
					agentMgmtDAO.insertAgentResrSet(paramMap);
//					paramMap.put( "seq", seq );
					rtn = agentMgmtDAO.insertAgentResr(paramMap);
				}
				//보류해제
				else if(paramMap.get( "selCD1" ).equals( "02" ))
				{
					log.info( "보류/해제/별도가감/이월 - 지급보류" );
					// 보류 해제 ID의 보류 금액 확인
					int resrTot = agentMgmtDAO.selectAgentResrSumOfId(paramMap);
					//해제 금액
					int ccAmt = Integer.parseInt((paramMap.get( "amt" ).toString()));
					if(resrTot == 0 )
					{
						//해제 금액 x
						resultMap.put( "resultCd", "-1" );
						resultMap.put( "resultMsg", "보류 금액이 0원 입니다." );
						return resultMap;
					}
					else if(resrTot < 0 && ccAmt < 0 && resrTot > ccAmt)
					{
						//해제금액은 보류금액보다 클 수 없다
						resultMap.put( "resultCd", "-2" );
						resultMap.put( "resultMsg", "해제 금액은 보류 금액의 합보다 클 수 없습니다." );
						return resultMap;
					}
					else if(resrTot > 0 && ccAmt > 0 && resrTot < ccAmt)
					{
						//둘다 마이너스일 경우 
						resultMap.put( "resultCd", "-2" );
						resultMap.put( "resultMsg", "해제 금액은 보류 금액의 합보다 클 수 없습니다." );
						return resultMap;
					}
					else if(resrTot < 0 && ccAmt < 0 && resrTot > ccAmt)
					{
						// 둘다 플러스일 경우 
						resultMap.put( "resultCd", "-3" );
						resultMap.put( "resultMsg", "해제 금액과 보류 금액의 합의 부호가 다릅니다.\n개발팀과 협의하세요." );
						return resultMap;
					}
					else if((resrTot > 0 && ccAmt < 0) || (resrTot < 0 && ccAmt > 0))
					{
						// 부호가 다를 경우  처리불가
						resultMap.put( "resultCd", "-2" );
						resultMap.put( "resultMsg", "해제 금액은 보류 금액의 합보다 클 수 없습니다." );
						return resultMap;
					}
					else
					{
						// 보류 리스트 조회
						List<Map<String,Object>> list = agentMgmtDAO.selectAgentResrSearchOfId(paramMap);
						if(list.size() > 0 )
						{
							for(int i=0;i<list.size();i++)
							{
								Map<String,Object> dataMap = list.get( i );
								int seq = ( int ) dataMap.get( "SEQ" );
								int resrAmt = ( int ) dataMap.get( "RESR_AMT" );
								paramMap.put( "seq", seq );
								// 보류 금액이 작거나 같은 경우 보류 금액만큼 해제
								if(Math.abs(resrAmt) <= Math.abs(ccAmt)) {
									paramMap.put("setAmt", resrAmt);
                    
									rtn = agentMgmtDAO.updateAgentResrCcPart(paramMap);
									rtn = agentMgmtDAO.insertAgentResrCcPart(paramMap);
									
									ccAmt = ccAmt - resrAmt;
								}
								// 보류 금액이 클 경우 전체(해제금액 만큼) 해제
								else {
									paramMap.put("set_amt", ccAmt);
                    
									rtn = agentMgmtDAO.updateAgentResrCcAll(paramMap);
									rtn = agentMgmtDAO.insertAgentResrCcAll(paramMap);
									
									ccAmt = 0;
                  
									break;
								}
							}
						}
					}
				}
				//별도가감
				else
				{
					rtn = agentMgmtDAO.insertAgentExtra(paramMap);
				}
					
			}
			else
			{
				resultMap.put( "resultCd", "9999" );
				resultMap.put( "resultMsg", "저장 실패! 개발팀에 문의하세요" );
				return resultMap;
			}
			
		}
		catch(Exception e)
		{
			log.error( "Exception Error : " ,e );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Error" );
			return resultMap;
		}
		resultMap.put( "resultCd", "0000" );
		return resultMap;
	}
	//보류/해제/별도가감/이월 삭제
	public  Map<String, Object> deleteAgentResrExtra(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		int cnt = 0;
		try
		{
			String frDt = paramMap.get( "frYear" ).toString()+paramMap.get( "frMon" ).toString();
			String toDt = paramMap.get( "toYear" ).toString()+paramMap.get( "toMon" ).toString();
			paramMap.put( "frDt", frDt );
			paramMap.put( "toDt", toDt );
			if(paramMap.get( "resrCl" ).equals( "03" ))
			{
				// 별도가감 삭제
				cnt = agentMgmtDAO.updateAgentExtraHistory(paramMap);
			}
			else
			{
				if(paramMap.get( "resrCl" ).equals( "01" ))
				{
					// 지급보류 설정 변경(삭제분만큼 차감) - 보류건
					// 해당 seq의 resr_set_seq에 해당하는 보류해제 건 수를 가져와 0보다 크면 에러, 아니면 tb_reserve_set 데이터 삭제처리
					int iCnt = agentMgmtDAO.selectAgentResrEtcSearchCnt(paramMap);
					if(iCnt > 0)
					{
						resultMap.put( "resultCd", "9999" );
						resultMap.put( "resultMsg", "해당 ID의 보류해제 건을 먼저 삭제한 후 보류 내역을 삭제해주세요." );
					}
					else
					{
						cnt = agentMgmtDAO.updateAgentReserveSet(paramMap);
					}
				}
				else
				{
					// 지급보류 설정 변경(삭제분만큼 차감) - 해제건
					cnt = agentMgmtDAO.updateAgentReserveSetCc(paramMap);
				}
				// 지급보류/해제 삭제
				cnt = agentMgmtDAO.updateAgentReserve(paramMap);
			}
			if(cnt > 0 )
			{
				resultMap.put( "resultCd", "0000" );
				resultMap.put( "resultMsg", "삭제 되었습니다." );
			}
		}
		catch(Exception e)
		{
			log.error( "Exception Error : " ,e );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Error" );
			return resultMap;
		}
		
		return resultMap;
	}
	//보류/해제/별도가감/이월 수정
	public  Map<String, Object> updateAgentResrEtc(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		int cnt= 0;
		int ccCnt= 0;
		try
		{
			log.info( "보류/해제/별도가감/이월 수정 전 VID 존재여부 체크 " );
			paramMap.put( "frDt", paramMap.get( "payDt" ));
			paramMap.put( "toDt", paramMap.get( "payDt" ) );
			
			ccCnt = agentMgmtDAO.selectExistChkVid(paramMap);
			// 확정 건일 경우
			if(ccCnt > 0)
			{
				//-4
				resultMap.put( "resultCd", "9999" );
				resultMap.put( "resultMsg", "Exception Error" );
			}
			// 1. 삭제 처리 후
			if(paramMap.get( "oldSelCD1" ).equals( "03" ))
			{
				//별도가감 삭제
				cnt = agentMgmtDAO.updateAgentExtraHistory(paramMap);
			}
			else
			{
				if(paramMap.get( "oldSelCD1" ).equals( "01" ))
				{
					// 지급보류 설정 변경(삭제분만큼 차감) - 보류건
					// 해당 seq의 resr_set_seq에 해당하는 보류해제 건 수를 가져와 0보다 크면 에러, 아니면 tb_agent_reserve_set 데이터 삭제처리
					int iCnt = agentMgmtDAO.selectAgentResrEtcSearchCnt( paramMap );
					
					if(iCnt > 0)
					{
						//-4
						resultMap.put( "resultCd", "9999" );
						resultMap.put( "resultMsg", "Exception Error" );
					}
					else
					{
						cnt = agentMgmtDAO.updateAgentReserveSet( paramMap );
					}
				}
				else
				{
					// 지급보류 설정 변경(삭제분만큼 차감) - 해제건
					cnt = agentMgmtDAO.updateAgentReserveSetCc( paramMap );
				}
			}
			//지급보류
			if(paramMap.get( "selCD1" ).equals( "01" ))
			{
				int seq = agentMgmtDAO.insertAgentResrSet( paramMap );
				paramMap.put( "seq", seq );
				
				cnt = agentMgmtDAO.insertAgentResr( paramMap );
			}
			//보류해제
			else if(paramMap.get( "selCD1" ).equals( "02" ))
			{
				// 보류 해제 ID의 보류 금액 확인
				int resrTot = agentMgmtDAO.selectAgentResrSumOfId( paramMap );
				
				// 해제 금액
				int ccAmt =  Integer.parseInt( paramMap.get( "amt" ).toString() );
				
				if(paramMap.get( "oldSelCD1" ).equals( "01" ))
				{
					resrTot = resrTot - (Integer.parseInt( paramMap.get( "amt" ).toString()));
				}
				else if(resrTot < 0 && ccAmt < 0 && resrTot > ccAmt)
				{
					//해제금액은 보류금액보다 클 수 없다
					resultMap.put( "resultCd", "-2" );
					resultMap.put( "resultMsg", "해제 금액은 보류 금액의 합보다 클 수 없습니다." );
					return resultMap;
				}
				else if(resrTot > 0 && ccAmt > 0 && resrTot < ccAmt)
				{
					//둘다 마이너스일 경우 
					resultMap.put( "resultCd", "-2" );
					resultMap.put( "resultMsg", "해제 금액은 보류 금액의 합보다 클 수 없습니다." );
					return resultMap;
				}
				else if(resrTot < 0 && ccAmt < 0 && resrTot > ccAmt)
				{
					// 둘다 플러스일 경우 
					resultMap.put( "resultCd", "-3" );
					resultMap.put( "resultMsg", "해제 금액과 보류 금액의 합의 부호가 다릅니다.\n개발팀과 협의하세요." );
					return resultMap;
				}
				else 
				{
					// 보류 리스트 조회
					List<Map<String,Object>> list = agentMgmtDAO.selectAgentResrSearchOfId( paramMap );
					if(list.size() > 0)
					{
						for(int i=0; i<list.size(); i++)
						{
							Map<String,Object> dataMap = list.get( i );
							
							if(dataMap != null)
							{
								int seq = ( int ) dataMap.get( "SEQ" );
								int resrAmt = ( int ) dataMap.get( "RESR_AMT" );
								
								paramMap.put( "seq", seq );
								
								// 이전단계에서 무조건 삭제후 입력이기 때문에 해당 건은 udpate x
								if(paramMap.get( "oldSelCD1" ).equals( "01" ) && paramMap.get( "oldSetSeq" ).equals( seq ))
								{
									continue;
								}
								//보류 금액이 작거나 같은 경우 보류 금액만큼 해제
								if(Math.abs(resrAmt) <= Math.abs(ccAmt)) {
									paramMap.put("setAmt", resrAmt);
									cnt = agentMgmtDAO.updateAgentResrCcPart(paramMap);
									
									cnt = agentMgmtDAO.insertAgentResrCcPart(paramMap);
									
									ccAmt = ccAmt - resrAmt;
								}else{
									//보류 금액이 클 경우 전체(해제금액 만큼) 해제
									paramMap.put("set_amt", ccAmt);
									cnt = agentMgmtDAO.updateAgentResrCcAll(paramMap);
									cnt = agentMgmtDAO.insertAgentResrCcAll(paramMap);
									ccAmt = 0;
									break;
								}
							}
						}
					}
				}
			}
			else
			{
				cnt = agentMgmtDAO.insertAgentExtra(paramMap);
			}
				
		}
		catch(Exception e)
		{
			log.error( "Exception Error : " ,e );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Error" );
			return resultMap;
		}
		resultMap.put( "resultCd", "0000" );
		return resultMap;
	}
	//정산보고서발송 리스트 조회
	@Override
    public  List<Map<String, Object>> selectAgentStmtReportList(Map<String,Object> paramMap) throws Exception {
		return agentMgmtDAO.selectAgentStmtReportList(paramMap);
	}
	public  int selectAgentStmtReportListTotal(Map<String,Object> paramMap) throws Exception {
		return agentMgmtDAO.selectAgentStmtReportListTotal(paramMap);
	}
	//정산보고서발송 상세정보 리스트 조회
	@Override
    public  List<Map<String, Object>> selectAgentCompPayAmtListDetail(Map<String,Object> paramMap) throws Exception {
		return agentMgmtDAO.selectAgentCompPayAmtListDetail(paramMap);
	}
	public  int selectAgentCompPayAmtListDetailTotal(Map<String,Object> paramMap) throws Exception {
		return agentMgmtDAO.selectAgentCompPayAmtListDetailTotal(paramMap);
	}
	//정산보고서발송 발송전 정보리스트 조회
	@Override
    public  List<Map<String,Object>> selectVidInfo(String param) throws Exception {
		return baseInfoRegistrationDAO.selectVidInfo(param);
	}
	//정산보고서 발송 
	@Override
    public  Map<String, Object> sendAgentStmtTaxAccount(Map<String,Object> paramMap) throws Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		
		try
		{
			paramMap.put( "mon", "201707" );
			dataMap = ( Map< String, Object > ) agentMgmtDAO.selectAgentStmtTaxAccount(paramMap);
	 
			if(dataMap==null)
			{
				resultMap.put( "resultCd", "9999" );
				resultMap.put( "resultMsg", "Data not exist." );
				return resultMap;
			}
			
			Properties props = new Properties();
            props.setProperty("mail.transport.protocol", "smtp");
            props.setProperty("mail.host", "smtp.gmail.com");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.socketFactory.fallback", "false");
            props.setProperty("mail.smtp.quitwait", "false");
             
            Authenticator auth = new Authenticator(){
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication("khj77790@gmail.com", "oulpxaxnicexpnev");
                }
            };
        
            Session session = Session.getDefaultInstance(props,auth);
             
            MimeMessage message = new MimeMessage(session);
            message.setSender(new InternetAddress("khj77790@gmail.com"));
            message.setSubject("test");
     
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(paramMap.get( "email" ).toString()));
             
            Multipart mp = new MimeMultipart();
            MimeBodyPart mbp1 = new MimeBodyPart();
            String strMail  = "";
            strMail += "IMG_PATH			: https://test.test.co.kr"+"\n" ;
            strMail += "STMT_MON			: "+ dataMap.get( "STMT_MON" ) +"\n" ;
            strMail += "TAX_YEAR				: "+ dataMap.get( "TAX_YEAR" ) +"\n" ;
            strMail += "TAX_MONTH			: "+ dataMap.get( "TAX_MONTH" ) +"\n" ;
            strMail += "TAX_LAST_DAY		: "+ dataMap.get( "TAX_LAST_DAY" ) +"\n" ;
            strMail += "DUE_DT				: "+ dataMap.get( "DUE_DT" ) +"\n" ;
            strMail += "CO_NM					: "+ dataMap.get( "CO_NM" ) +"\n" ;
            strMail += "SUPP_AMT			: "+ dataMap.get( "SUPP_AMT" ) +"\n" ;
            strMail += "VAT						: "+ dataMap.get( "VAT" ) +"\n" ;
            strMail += "SMS_FEE				: "+ dataMap.get( "SMS_FEE" ) +"\n" ;
            strMail += "TAX_AMT				: "+ dataMap.get( "TAX_AMT" ) +"\n" ;
            strMail += "EXTRA_FEE			: "+ dataMap.get( "EXTRA_FEE" ) +"\n" ;
            strMail += "EXTRA_VAT			: "+ dataMap.get( "EXTRA_VAT" ) +"\n" ;
            strMail += "EMAIL					: "+ paramMap.get( "email" ) +"\n" ;
            
            mbp1.setText(strMail);
            mp.addBodyPart(mbp1);
             
            message.setContent(mp);
             
            Transport.send(message);
		}
		catch(Exception e)
		{
			log.error( "Exception Fail : " ,e  );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Error" );
			return resultMap;
		}
		resultMap.put( "resultCd", "0000" );
		return resultMap;
	}
	//정산보고서작성 리스트 조회
    public  List<Map<String, Object>> selectAgentStmtConfirmList(Map<String,Object> paramMap) throws Exception {
		return agentMgmtDAO.selectAgentStmtConfirmList(paramMap);
	}
	public  int selectAgentStmtConfirmListTotal(Map<String,Object> paramMap) throws Exception {
		return agentMgmtDAO.selectAgentStmtConfirmListTotal(paramMap);
	}
	//정산보고서확정 조회
	@Override
    public  Map<String, Object> selectAgentStmtConfList(Map<String,Object> paramMap) throws Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		Map<String,Object> totMap = new HashMap<>();
		try
		{
			String confDt = paramMap.get( "year" ).toString() + paramMap.get( "mon" );
			paramMap.put( "confDt", confDt);
			//대리점 정산 보고서 확정 내역, 조회
			List<Map<String,Object>> list = agentMgmtDAO.selectAgentStmtConfList(paramMap);
			//정산 보고서 확정자 내역 
			List<Map<String,Object>> listInfo = agentMgmtDAO.selectAgentStmtUserRecord(paramMap);
			Map<String,Object> dataMap = listInfo.get( 0 );
			if(list.size() > 0)
			{
				long sumTranAmt = 0;
				long sumFee = 0;
				long sumPayAmt = 0;
				long sumVat = 0;
				long sumPVat = 0;
				long sumResrAmt = 0;
				long sumExtraAmt = 0;
				long sumSmsFee = 0;
				long sumDepositAmt = 0;
				long size = list.size();
				for(int i=0; i<list.size(); i++)
				{
					long tranAmt = (( BigDecimal ) list.get( i ).get( "TRANAMT" )).longValue();
					long fee = (( BigDecimal ) list.get( i ).get( "FEE" )).longValue();
					long payAmt = (( BigDecimal ) list.get( i ).get( "PAY_AMT" )).longValue();
					long vat = (( BigDecimal ) list.get( i ).get( "VAT" )).longValue();
					long payVat = (( BigDecimal ) list.get( i ).get( "PAY_VAT" )).longValue();
					long resrAmt = (( BigDecimal ) list.get( i ).get( "RESR_AMT" )).longValue();
					long extraAmt = (( BigDecimal ) list.get( i ).get( "EXTRA_AMT" )).longValue();
					long smsFee= (( BigDecimal ) list.get( i ).get( "SMSFEE" )).longValue();
					long dpstAmt = (( BigDecimal ) list.get( i ).get( "DPST_AMT" )).longValue();
					sumTranAmt += tranAmt;
					sumFee += fee ;
					sumPayAmt +=payAmt ;
					sumVat += vat;
					sumPVat += payVat;
					sumResrAmt += resrAmt;
					sumExtraAmt += extraAmt;
					sumSmsFee += smsFee;
					sumDepositAmt += dpstAmt;
					
				}
				totMap.put( "sumTranAmt", sumTranAmt );
				totMap.put( "sumFee", sumFee );
				totMap.put( "sumPayAmt", sumPayAmt );
				totMap.put( "sumVat", sumVat );
				totMap.put( "sumPVat", sumPVat );
				totMap.put( "sumResrAmt", sumResrAmt );
				totMap.put( "sumExtraAmt", sumExtraAmt );
				totMap.put( "sumSmsFee", sumSmsFee );
				totMap.put( "sumDepositAmt", sumDepositAmt );
				totMap.put( "size", size );
			}
			
			resultMap.put( "list", list );
			resultMap.put( "data", dataMap);
			resultMap.put( "tot", totMap);
		}
		catch(Exception e)
		{
			log.error( "Exception Error : " , e );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Error" );
			return resultMap;
		}
		
		resultMap.put( "resultCd", "0000" );
		
		return resultMap;
	}
	//정산보고서확정 저장
	@Override
    public  Map<String, Object> updateAgentStmtAdSave(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		int cnt = 0;
		try
		{
			if(paramMap.get( "degree" ).equals( "2" ))
			{
				List<Map<String,Object>> list = agentMgmtDAO.selectAgentStmtCarryConfVid(paramMap); //getAgentSettlmntCarryConfirmAid
				
				if(list.size() > 0)
				{
					for(int i=0; i<list.size(); i++)
					{
						Map<String,Object> dataMap = list.get( i );
						String vid = dataMap.get( "VID" ).toString();
						paramMap.put( "vid" , vid);
						
						// 이전 이월 내역 확정
						cnt = agentMgmtDAO.updateConfAgentStmtCarry(paramMap);  
					}
				}
				cnt = agentMgmtDAO.updateConfStmtSecEmp(paramMap); 
			}
			else if(paramMap.get( "degree" ).equals( "3" ))
			{
				cnt =agentMgmtDAO.updateConfStmtThrEmp(paramMap); 
			}
			
			if(cnt > 0)
			{
				resultMap.put( "resultCd", "0000" );
			}
			else
			{
				resultMap.put( "resultCd", "9999" );
				resultMap.put( "resultMsg", "확정 실패하였습니다.");
			}
		}
		catch(Exception e)
		{
			log.error( "Exception Error :  " , e );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Error.");
		}
		return resultMap;
	}
	//정산보고서확정 확정취소
	@Override
    public  Map<String, Object> updateAgentStmtAdCancel(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		int cnt = 0;
		try
		{
			//취소 차수 
			if(paramMap.get( "degree").equals( "1" ))
			{
				cnt = agentMgmtDAO.updateConfStmtFirEmp(paramMap);
			}
			else if(paramMap.get( "degree" ).equals( "2" ))
			{
				List<Map<String,Object>> list = agentMgmtDAO.selectAgentStmtCarryCanVid(paramMap);
				
				if(list.size() > 0)
				{
					for(int i=0;i<list.size();i++)
					{
						Map<String,Object> dataMap = list.get( i );
						String vid = dataMap.get( "VID" ).toString();
						String confTm = dataMap.get( "CONF_TM" ).toString();
						paramMap.put( "vid", vid );
						paramMap.put( "confTm", confTm );
						
						//이전 이월 내역 확정 
						cnt = agentMgmtDAO.updateConfAgentStmtCarryCan(paramMap); 
					}
				}
				cnt = agentMgmtDAO.updateConfCanSecEmp(paramMap);
			}
			else
			{
				cnt = agentMgmtDAO.updateConfCanThrEmp(paramMap);
			}
			
			if(cnt > 0)
			{
				resultMap.put( "resultCd", "0000" );
			}
			else
			{
				resultMap.put( "resultCd", "9999" );
				resultMap.put( "resultMsg", "확정 실패하였습니다.");
			}
		}
		catch(Exception e)
		{
			log.error( "Exception Error :  " , e );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Error.");
		}
		
		return resultMap;
	}
	//정산보고서확정 등록비 배분 상세 리스트 조회
    public  Map<String, Object> selectAgentCoPayAmtDetail(Map<String,Object> paramMap) throws Exception {
    	Map<String, Object> resultMap = new HashMap<String,Object>();
    	Map<String, Object> totMap = new HashMap<String,Object>();
    	try
    	{
    		List<Map<String,Object>> list = agentMgmtDAO.selectAgentCoPayAmtDetail(paramMap);
    		long totRPayAmt = 0;
    		long totRPayVat = 0;
    		
    		for(int i=0; i<list.size(); i++)
    		{
    			Map<String,Object> dataMap = list.get( i );
    			long rPayAmt = dataMap.get( "RPAY_AMT" )==null?0:((BigDecimal)dataMap.get( "RPAY_AMT" )).longValue();
    			long rPayVat = dataMap.get( "RPAY_VAT" )==null?0:((BigDecimal)dataMap.get( "RPAY_VAT" )).longValue();
    			
    			totRPayAmt += rPayAmt;
    			totRPayVat += rPayVat;
    		}
    		
    		totMap.put( "totRPayAmt", totRPayAmt );
    		totMap.put( "totRPayVat", totRPayVat );
    		resultMap.put( "totMap", totMap );
    		resultMap.put( "list", list );
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception Error : " , e );
    		resultMap.put( "resultCd", "9999" );
    		resultMap.put( "resultMsg", "Exception Error " );
    		return resultMap;
    	}
    	
    	resultMap.put( "resultCd", "0000" );
    	
		return resultMap;
	}
  //정산보고서확정 이월내역 상세 리스트 조회
    public  Map<String, Object> selectAgentStmtCarryDetail(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
    	Map<String, Object> totMap = new HashMap<String,Object>();
    	try
    	{
    		List<Map<String,Object>> list = agentMgmtDAO.selectAgentStmtCarryDetail(paramMap);
    		long totTrAmt = 0;
    	  	long totFee = 0;
    	  	long totVat = 0;
    	  	long totDepositAmt = 0;
    		
    		for(int i=0; i<list.size(); i++)
    		{
    			Map<String,Object> dataMap = list.get( i );
    			long fee = dataMap.get( "FEE" )==null?0:((BigDecimal)dataMap.get( "FEE" )).longValue();
    			long vat = dataMap.get( "VAT" )==null?0:((BigDecimal)dataMap.get( "VAT" )).longValue();
    			long depositAmt = dataMap.get( "DPST_AMT" )==null?0:((BigDecimal)dataMap.get( "DPST_AMT" )).longValue();
    			long trAmt = dataMap.get( "TR_AMT" )==null?0:((BigDecimal)dataMap.get( "TR_AMT" )).longValue();
    			
    			totFee += fee;
    			totVat += vat;
    			totDepositAmt += depositAmt;
    			totTrAmt += trAmt;
    		}
    		
    		totMap.put( "totFee", totFee );
    		totMap.put( "totVat", totVat );
    		totMap.put( "totDepositAmt", totDepositAmt );
    		totMap.put( "totTrAmt", totTrAmt );
    		resultMap.put( "totMap", totMap );
    		resultMap.put( "list", list );
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception Error : " , e );
    		resultMap.put( "resultCd", "9999" );
    		resultMap.put( "resultMsg", "Exception Error " );
    		return resultMap;
    	}
    	
    	resultMap.put( "resultCd", "0000" );
    	
		return resultMap;
	}
  //정산보고서확정 이월내역 상세 리스트 조회
    public  Map<String, Object> updateConfStmtSave(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
    	Map<String, Object> totMap = new HashMap<String,Object>();
    	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
    	int cnt =0;
    	
    	try
    	{
    		//확정 로직
    		if(paramMap.get( "saveType" ).equals( "0" ))
    		{
    			//팀장 확인
    			int status = agentMgmtDAO.selectStatusCurMonStmt(paramMap);
    			
    			if(status > 1)
    			{
    				//입력 불가(해당 월에 확정된 내역이 있음)
    				//-1
    				resultMap.put( "resultCd", "9999" );
    	    		resultMap.put( "resultMsg", "Exception Error " );
    	    		return resultMap;
    			}
    			else
    			{
    				String strConfirmChkProc = ( String ) paramMap.get("confirmChkProc");
    				
    				for(int i = 0; i < strConfirmChkProc.length(); i++) {
    				    Map<String,Object> map = new HashMap<String,Object>();
    				    
    				    String strStatus = strConfirmChkProc.substring(0, 1);
    				    String strstmtDt = strConfirmChkProc.substring(1, 9);
    				    String strVid= strConfirmChkProc.substring(9, 19);
    				    String strIndex = strConfirmChkProc.substring(19, strConfirmChkProc.length());
    				    
    				    if("1".equals(strStatus)) continue; // 현재 담당자 확정건 다시 담당자 확정 불가
    				    
    				    map.put("taxDt", paramMap.get("taxDt_"+strIndex));
    				    map.put("stmtDt", strstmtDt); // 정산일자
    				    map.put("vid", strVid); // 정산 ID

    				    list.add(map);
    				    cnt = agentMgmtDAO.updateConfStmtSave(map);
    				  }
    				
    			}
    			
    			if(cnt > 0)
    			{
    				resultMap.put( "resultCd", "0000" );
    				resultMap.put( "resultMsg", "정산 보고서 확정 성공" );
    	    		return resultMap;
    			}
    			else if(cnt == 0)
    			{
    				resultMap.put( "resultCd", "9999" );
    	    		resultMap.put( "resultMsg", "정산보고서 확정중 오류가 발생 하였습니다. " );
    	    		return resultMap;
    			}
    			else if (cnt < 0) 
    			{
    				resultMap.put( "resultCd", "9999" );
    	    		resultMap.put( "resultMsg", "당월 확정 진행중인 정산 내역이 존재합니다." );
    	    		return resultMap;
    			}
    		}
    		//확정 취소
    		else if(paramMap.get( "saveType" ).equals( "1" ))
    		{
    			//이월내역 확정 취소
    			cnt = agentMgmtDAO.updateConfStmtCancel(paramMap);
    			
    			//확정 취소 
    			cnt = agentMgmtDAO.updateConfStmtCancel(paramMap);
    			
    			if(cnt > 0)
    			{
    				resultMap.put( "resultCd", "0000" );
    				resultMap.put( "resultMsg", "정산 보고서 취소 성공" );
    	    		return resultMap;
    			}
    			else if(cnt == 0)
    			{
    				resultMap.put( "resultCd", "9999" );
    	    		resultMap.put( "resultMsg", "정산보고서 취소중 오류가 발생 하였습니다." );
    	    		return resultMap;
    			}
    		}
    		//이월ㄹ로직
    		else if(paramMap.get( "saveType" ).equals( "2" ))
    		{
    			//팀장 확인
    			int status = agentMgmtDAO.selectStatusCurMonStmt(paramMap);
    			if(status > 1)
    			{
    				//입력 불가(해당 월에 확정된 내역이 있음)
    				resultMap.put( "resultCd", "9999" );
    	    		resultMap.put( "resultMsg", "입력 불가(해당 월에 확정된 내역이 있음)" );
    	    		return resultMap;
    			}
    			else
    			{
    				String strCarryChkProc = ( String ) paramMap.get("carryChkProc");
    				
    				for(int i = 0; i < strCarryChkProc.length(); i++) {
    				    Map<String,Object> map = new HashMap<String,Object>();
    				    
    				    String strStatus = strCarryChkProc.substring(0, 1);
    				    String strstmtDt = strCarryChkProc.substring(1, 9);
    				    String strVid= strCarryChkProc.substring(9, 19);
    				    String strIndex = strCarryChkProc.substring(19, strCarryChkProc.length());
    				    
    				    if("1".equals(strStatus)) continue; // 현재 담당자 확정건 다시 담당자 확정 불가
    				    
    				    map.put("stmtDt", strstmtDt); // 정산일자
    				    map.put("vid", strVid); // 정산 ID

    				    list.add(map);
    				  }
    				
    				for(int i = 0; i < list.size(); i++) 
    				{
    					
    					Map<String,Object> map = list.get( i );
    					
    					if(agentMgmtDAO.selectAgentStmtCarryCnt(map) > 0)
    					{
    						cnt = agentMgmtDAO.updateAgentStmtCarry(map);
    					}
    					else
    					{
    						cnt = agentMgmtDAO.insertAgentStmtCarry(map);
    					}
    					if(cnt > 0)
    					{
    						cnt =agentMgmtDAO.updateAgentStmtCarrySum(map);
    					}
    				}	
    			}
    			if(cnt > 0)
    			{
    				resultMap.put( "resultCd", "0000" );
    				resultMap.put( "resultMsg", "정산 보고서 이월 성공" );
    	    		return resultMap;
    			}
    			else if(cnt == 0)
    			{
    				resultMap.put( "resultCd", "9999" );
    	    		resultMap.put( "resultMsg", "정산보고서 이월중 오류가 발생 하였습니다." );
    	    		return resultMap;
    			}
    		}
    		//이월취소로직
    		else if(paramMap.get( "saveType" ).equals( "3" ))
    		{
    			cnt =agentMgmtDAO.updateCarryStmtCancel(paramMap);
    			if(cnt > 0)
    			{
    				resultMap.put( "resultCd", "0000" );
    				resultMap.put( "resultMsg", "정산 보고서 이월 취소 성공" );
    	    		return resultMap;
    			}
    			else if(cnt == 0)
    			{
    				resultMap.put( "resultCd", "9999" );
    	    		resultMap.put( "resultMsg", "정산보고서 이월 취소중 오류가 발생 하였습니다." );
    	    		return resultMap;
    			}
    		}
    	}
    	catch(Exception e)
    	{
    		log.error( "EXCEPTION FAIL :  " , e );
    		resultMap.put( "resultCd", "9999" );
    		resultMap.put( "resultMsg", "Exception Error " );
    		return resultMap;
    	}
    	resultMap.put( "resultCd", "0000" );
    	return resultMap;
    }
    public static void main(String[] args){
        try{
        	Properties props = new Properties();
            props.setProperty("mail.transport.protocol", "smtp");
            props.setProperty("mail.host", "smtp.gmail.com");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.socketFactory.fallback", "false");
            props.setProperty("mail.smtp.quitwait", "false");
             
            Authenticator auth = new Authenticator(){
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication("khj77790@gmail.com", "oulpxaxnicexpnev");
                }
            };
        
            Session session = Session.getDefaultInstance(props,auth);
             
            MimeMessage message = new MimeMessage(session);
            message.setSender(new InternetAddress("khj77790@gmail.com"));
            message.setSubject("test");
     
            message.setRecipient(Message.RecipientType.TO, new InternetAddress("hoho3773@naver.com"));
             
            Multipart mp = new MimeMultipart();
            MimeBodyPart mbp1 = new MimeBodyPart();
            mbp1.setText("Test Contents");
            mp.addBodyPart(mbp1);
             
            message.setContent(mp);
             
            Transport.send(message);
            System.out.println("success");
        }catch(Exception e){
            System.out.println("Error"+e);
        }
    }

}
