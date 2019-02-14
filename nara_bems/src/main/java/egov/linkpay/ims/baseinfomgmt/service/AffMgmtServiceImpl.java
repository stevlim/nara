package egov.linkpay.ims.baseinfomgmt.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.AffMgmtDAO;
import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;

@Service("affMgmtService")
public class AffMgmtServiceImpl implements AffMgmtService 
{
	 Logger log = Logger.getLogger(this.getClass());
	 
	@Resource(name="affMgmtDAO")
	private AffMgmtDAO affMgmtDAO;
	
	@Resource(name="historySearchDAO")
    private HistorySearchDAO historySearchDAO;
	
	@Override
    public List< Map< String, String > > selectCodeCl(String CodeCl) throws Exception {
    	return affMgmtDAO.selectCodeCl( CodeCl );
    }
	
	@Override
    public List<Map<String,Object>> selectCreditCardList(Map< String, Object > paramMap) throws Exception {
    	return affMgmtDAO.selectCreditCardList( paramMap );
    }
	@Override
    public Object selectCreditCardListTotal(Map< String, Object > paramMap) throws Exception {
    	return affMgmtDAO.selectCreditCardListTotal( paramMap );
    }
	
	@Override
    public void insertCreditCardInfo(Map< String, Object > paramMap) throws Exception {
    	
		affMgmtDAO.insertCreditCardInfo( paramMap );
    }
	@Override
	public Map<String, Object> deleteCardInfo(Map<String, Object> paramMap) throws Exception{
		List<Map< String, Object >> dataList = new ArrayList<Map< String , Object >>();
		Map<String, Object> resultMap = new HashMap< String, Object >();
		String resultCd = "";
		int cnt =0;
		//먼저 정보 조회 
		log.info( "카드 삭제 전 정보 조회 " );
		try
		{
			dataList = affMgmtDAO.cardInfoSettingCnt( paramMap );
			
			if(dataList.size() == 0)
			{
				log.info( "조회된 정보 없음" );
				resultCd = "9999";
			}
			else
			{
				int dataSetCnt = ((BigDecimal)dataList.get( 0 ).get( "CNT" )).intValue() ;
				int acquCnt = ((BigDecimal)dataList.get( 0 ).get( "ACQU_CNT" )).intValue() ;
				int terminalCnt = ((BigDecimal)dataList.get( 0 ).get( "TERMINAL_CNT" ) ).intValue();
				String nointFlg = (String)dataList.get( 0 ).get( "NOINT_FLG" );
				
				if(dataSetCnt > 0 || acquCnt > 0 || terminalCnt > 0){
					// 기존에 설정된 데이터가 존재함(삭제 불가)
					resultCd = "-999";
					String mbsNo = (String)dataList.get( 0 ).get( "MBS_NO" );
					String cardCd = (String)dataList.get( 0 ).get( "CARD_CD" );
					log.info( "mbs_no : " + mbsNo + "  , card_cd :  "+ cardCd);
					resultMap.put( "mbsNo", mbsNo );
					resultMap.put( "cardCd", cardCd );
					
					log.info( "기존 데이터 존재 -> 삭제 불가 " );
				}
				else
				{
					// 설정된 데이터 없음(삭제 가능)
					if("1".equals(nointFlg))
					{
						//무이자 설정일때
						log.info( "무이자 설정일 때" );
						cnt =  affMgmtDAO.insertDeleteCardFeeInfo(paramMap);
						if(cnt>0)
						{
							cnt = affMgmtDAO.deleteNoneUseCardFee(paramMap);
						}
							
						cnt = affMgmtDAO.insertDelCardInfo(paramMap);
						
						if(cnt >0 )
						{
							cnt = affMgmtDAO.deleteNoneUseCardInfo(paramMap);
						}
						resultCd = "0000";
					}
					else
					{
						//일반 설정일때 
						log.info( "일반 설정일 때" );
						cnt = affMgmtDAO.insertDelCardInfo(paramMap);
						
						if(cnt > 0 )
						{
							cnt = affMgmtDAO.deleteNoneUseCardInfo(paramMap);
						}
						resultCd = "0000";
					}
				}
			}
		}
		catch(Exception e)
		{
			log.error( "Exception : " , e );
		}
		resultMap.put( "resultCd", resultCd );

		return resultMap;
	}
	@Override
    public List<Map<String,Object>> selectCardSetData(Map< String, Object > paramMap) throws Exception {
		return affMgmtDAO.selectCardSetData( paramMap );
    }
	@Override
    public Object selectCardSetDataTotal(Map< String, Object > paramMap) throws Exception {
    	return affMgmtDAO.selectCardSetDataTotal( paramMap );
    }
	@Override
    public List<Map<String,Object>> selectCardInfo(Map< String, Object > paramMap) throws Exception {
		return affMgmtDAO.selectCardInfo( paramMap );
    }
	@Override
    public Object selectCardInfoTotal(Map< String, Object > paramMap) throws Exception {
    	return affMgmtDAO.selectCardInfoTotal( paramMap );
    }
	@Override
    public List<Map<String,Object>> selectCardHistory(Map< String, Object > paramMap) throws Exception {
		return affMgmtDAO.selectCardHistory( paramMap );
    }
	@Override
    public Object selectCardHistoryTotal(Map< String, Object > paramMap) throws Exception {
    	return affMgmtDAO.selectCardHistoryTotal( paramMap );
    }
	//VAN TERMINAL
	@Override
    public void insertVanTer(Map< String, Object > paramMap) throws Exception 
	{
		List< Map<String, Object> > objList = new ArrayList<Map<String, Object>>();
		try
		{
			log.info( "카드사 - 가맹점 번호 매칭 여부 " );
			int cnt = (Integer)affMgmtDAO.mbsNoMatchChk(paramMap);
			if(cnt != 0 )
			{
				objList = affMgmtDAO.selectCardInfo(paramMap);
				
				if(objList.size() > 0)
				{
					affMgmtDAO.insertVanTer(paramMap);
				}
			}
		}
		catch(Exception e)
		{
			log.error( "Exception : " ,e  );
		}
	}
	@Override
    public List<Map<String,Object>> selectVanTerInfo(Map< String, Object > paramMap) throws Exception {
		return affMgmtDAO.selectVanTerInfo( paramMap );
    }
	public Object selectVanTerInfoTotal(Map< String, Object > paramMap) throws Exception {
		return affMgmtDAO.selectVanTerInfoTotal( paramMap );
    }
}
