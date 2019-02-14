package egov.linkpay.ims.paymentMgmt.service;

import java.io.BufferedReader;
import java.io.FileReader;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;
import egov.linkpay.ims.calcuMgmt.dao.CalcuMgmtDAO;
import egov.linkpay.ims.common.common.CommonEncrypt;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.operMgmt.dao.OperMgmtDAO;
import egov.linkpay.ims.paymentMgmt.dao.CardPaymentMgmtDAO;
import egov.linkpay.ims.util.SHA256Util;
import egov.linkpay.ims.util.StringUtils;

@Service("cardPaymentMgmtService")
public class CardPaymentMgmtServiceImpl implements CardPaymentMgmtService
{
	Logger log = Logger.getLogger(this.getClass());

    @Resource(name="cardPaymentMgmtDAO")
    private CardPaymentMgmtDAO cardPaymentMgmtDAO;

    @Override
    public List<Map<String, Object>> selectTransInfoList(Map<String, Object> objMap) throws Exception{
    	List<Map<String, Object>> dataList = new ArrayList<Map<String,Object>>();
    	List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();

    	
    	dataList = cardPaymentMgmtDAO.selectTransInfoList( objMap );
    	if(dataList.size() > 0 )
    	{
    		log.info( "dataList size : " + dataList.size() );
    		for(int i=0; i<dataList.size();i++)
    		{
    			Map<String, Object > map = dataList.get( i );
    			/*String coNm = "";
    			coNm = (String)map.get( "CO_NM" );
    			coNm =  StringUtils.cutString( coNm, 18 );
    			map.put( "CO_NM", coNm );

    			String strStateCd = (String)map.get( "TRX_ST_CD" );
    			String strStateNm	=	"";

    			if(strStateCd.equals( "0" )) strStateNm	=	"승인";
    			else if(strStateCd.equals( "1" ))	strStateNm = "전취소";
    			else if(strStateCd.equals( "2" ))	strStateNm = "후취소";
    			else if(strStateCd.equals( "part" ))	strStateNm = "부분취소";

    			map.put( "TRX_ST_NM", strStateNm );

    			String strJoinTypeCl = (String)(map.get( "MBS_TYPE_CD" )==null?"0":map.get( "MBS_TYPE_CD" ));
    			String strJoinTypeNm = "";

    			if(strJoinTypeCl.equals( "1" ))strJoinTypeNm="대행";
    			else strJoinTypeNm="직가맹";

    			map.put( "MBS_TYPE_NM", strJoinTypeNm );

    			String strTrans_type = (String)map.get( "TRX_CD" );
    			if(strTrans_type.equals( "1" )) {
    				strTrans_type	= "Y";
    			} else {
    				strTrans_type = "N";
    			}
    			map.put( "TRX_NM", strTrans_type );

    			String strPartCcCl = (String)map.get( "PART_CANCEL_CL" );
    			String strPartCcNm = "";
    			if(strPartCcCl.equals( "0" )) strPartCcNm="Y";
    			else strPartCcNm = "";

    			map.put( "PART_CANCEL_NM", strPartCcNm );*/

    			resultList.add( map );
    			log.info( "MAP : " + map );
    		}
    	}
    	return resultList;
	}

    @Override
    public Object selectTransInfoListTotal(Map<String, Object> objMap) throws Exception{
    	return cardPaymentMgmtDAO.selectTransInfoListTotal( objMap );
	}
    
    @Override
    public List<Map<String, Object>> selectTransFailInfoList(Map<String, Object> objMap) throws Exception{
    	List<Map<String, Object>> dataList = new ArrayList<Map<String,Object>>();
    	List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();

    	
    	dataList = cardPaymentMgmtDAO.selectTransFailInfoList( objMap );
    	if(dataList.size() > 0 )
    	{
    		log.info( "dataList size : " + dataList.size() );
    		for(int i=0; i<dataList.size();i++)
    		{
    			Map<String, Object > map = dataList.get( i );
    			/*String coNm = "";
    			coNm = (String)map.get( "CO_NM" );
    			coNm =  StringUtils.cutString( coNm, 18 );
    			map.put( "CO_NM", coNm );

    			String strStateCd = (String)map.get( "TRX_ST_CD" );
    			String strStateNm	=	"";

    			if(strStateCd.equals( "0" )) strStateNm	=	"승인";
    			else if(strStateCd.equals( "1" ))	strStateNm = "전취소";
    			else if(strStateCd.equals( "2" ))	strStateNm = "후취소";
    			else if(strStateCd.equals( "part" ))	strStateNm = "부분취소";

    			map.put( "TRX_ST_NM", strStateNm );

    			String strJoinTypeCl = (String)(map.get( "MBS_TYPE_CD" )==null?"0":map.get( "MBS_TYPE_CD" ));
    			String strJoinTypeNm = "";

    			if(strJoinTypeCl.equals( "1" ))strJoinTypeNm="대행";
    			else strJoinTypeNm="직가맹";

    			map.put( "MBS_TYPE_NM", strJoinTypeNm );

    			String strTrans_type = (String)map.get( "TRX_CD" );
    			if(strTrans_type.equals( "1" )) {
    				strTrans_type	= "Y";
    			} else {
    				strTrans_type = "N";
    			}
    			map.put( "TRX_NM", strTrans_type );

    			String strPartCcCl = (String)map.get( "PART_CANCEL_CL" );
    			String strPartCcNm = "";
    			if(strPartCcCl.equals( "0" )) strPartCcNm="Y";
    			else strPartCcNm = "";

    			map.put( "PART_CANCEL_NM", strPartCcNm );*/

    			resultList.add( map );
    			log.info( "MAP : " + map );
    		}
    	}
    	return resultList;
	}

    @Override
    public Object selectTransFailInfoListTotal(Map<String, Object> objMap) throws Exception{
    	return cardPaymentMgmtDAO.selectTransFailInfoListTotal( objMap );
	}
    
    
    
    
    
    
    
    
    @Override
    public  List<Map<String, Object>> selectCardInfoAmt(Map<String, Object> objMap) throws Exception{
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	
    	List<Map<String, Object>> dataList  = new ArrayList<Map<String, Object>>();

    	
    	return cardPaymentMgmtDAO.selectCardInfoAmt(objMap);
	}

    public static void main(String[] args){
    	String oriPw = "123456";
    	String pw = CommonEncrypt.Base64EncodedMD5(oriPw);
		System.out.println( "pw md5 enc : " + pw );

    	pw = CommonEncrypt.encodedSHA512( oriPw );
    	System.out.println( "pw sha512: " + pw );


    	pw = SHA256Util.encrypt( oriPw );
    	System.out.println( "pw sha256: " + pw );
    }

    @Override
    public Map<String,Object> selectPwChk(Map<String, Object> objMap) throws Exception{
    	Map<String,Object> resultMap = new HashMap<String, Object>();
    	Map< String, Object > dataMap = new HashMap<String, Object>();
    	log.info( "비밀번호 확인 start" );
    	String strChkFlg = "n";
    	String cd = "";
    	String msg = "";
    	String data = "";
    	int iRtn = 0;

    	try
    	{
    		// 비밀번호 확인
    		String pw = CommonEncrypt.Base64EncodedMD5( (String)objMap.get( "pwd" ) );
    		//pw = CommonEncrypt.encodedSHA512( pw );

    		objMap.put( "hPw", pw );
    		strChkFlg = (String)cardPaymentMgmtDAO.chkEmpPW(objMap);

    		if("Y".equals(strChkFlg)) {
    			cd = "success";
    			msg = "비밀번호가 일치합니다.";

    			if("cardNoDec".equals((String)objMap.get( "cont" )))	data = getCardNo((String)objMap.get( "tid" ));

    		}else {
    			cd = "fail";
    			msg = "비밀번호가 올바르지 않습니다.";
    		}

    	}
    	catch(Exception e)
    	{
    		log.error( "비밀번호 확인 Exception - " , e );
    		resultMap.put( "resultCd", "9999" );
    	}

    	resultMap.put( "resultCd", cd );
    	resultMap.put( "resultMsg", msg );
    	resultMap.put( "data", data );

    	return resultMap;
	}

    private String getCardNo( String tid )
	{
    	Map< String, Object > dataMap = new HashMap<String, Object>();
    	String cardNo = "";

    	try
		{
			dataMap = (Map<String, Object>)cardPaymentMgmtDAO.selectTransCardNo(tid);
			log.info( "비밀번호 확인 cardInfo 조회 : " + dataMap );
			cardNo = ( String ) dataMap.get( "CARD_NO_ENC" );
		}
		catch( Exception e )
		{
			log.error( "Exception : " + e );
		}

		return cardNo;
	}
    //소보법 메일 발송 조회
    public Map<String, Object> selectMailSendSearch(Map<String, Object> objMap) throws Exception{
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	List<Map<String, Object>> dataList  = new ArrayList<Map<String, Object>>();

    	dataList = (List<Map<String, Object>>)cardPaymentMgmtDAO.selectMailSendSearch(objMap);
    	if(dataList.size() > 0 )
    	{
    		resultMap.put( "dataList", dataList );
    	}
    	else
    	{
    		//메일테이블에 존재하지 않을 때
    		log.info( "메일 테이블에 존재하지 않을 떄" );
    		Map<String, Object> mailMap = new HashMap<String, Object>();
    		mailMap.put( "frDt", objMap.get( "frDt" ) );
    		mailMap.put( "toDt", objMap.get( "toDt" ) );
    		mailMap.put( "flagChk", "TID");

    		if(!objMap.get( "pmCd" ).equals( "03" ))
    		{
    			mailMap.put( "flag", objMap.get("tid"));
    		}else{
    			mailMap.put( "flag", objMap.get("DTID"));
    		}

    		mailMap.put( "cardFlg", "ALL");
    		mailMap.put( "status", "ALL");
    		mailMap.put("searchFlg", "ALL");
		    mailMap.put("settleCycle", "ALL");
		    mailMap.put("spmCd", "ALL");
		    mailMap.put("cpCd", "ALL");
		    mailMap.put("receiptCl", "ALL");
		    mailMap.put("typeChk", "ALL");
		    mailMap.put("offCl", "ALL");
		    mailMap.put("connFlg", "ALL");
		    mailMap.put("certType", "ALL");
		    mailMap.put("escrow", "ALL");
		    mailMap.put( "dealFlg", "ALL" );
    		mailMap.put( "strDate", objMap.get( "strDate" ));
    		mailMap.put( "frDt", objMap.get( "frDt" ) );
    		mailMap.put( "toDt", objMap.get( "toDt" ) );
    		mailMap.put( "intPageStart", 0 );
    		mailMap.put( "intPageEnd", 1);


    		dataList = (List<Map<String, Object>>)cardPaymentMgmtDAO.selectTransInfoList(mailMap);
    		if(dataList.size() > 0 ){
    			dataMap = dataList.get( 0 );
    			log.info( "dataMap : " + dataMap );
    			String strGoodsNm = (String)dataMap.get("GOODS_NM");
				String strOrdNm = (String)dataMap.get("ORD_NM");
				String strOrdNmDec = (String)dataMap.get("ORD_NM_ENC");
				String strStateCd = (String)dataMap.get("TRX_ST_CD");
				String strSvcCd = (String)dataMap.get("PM_CD");
				String strOrdTel = (String)dataMap.get("ORD_TEL");
				String strOrdTelDec = (String)dataMap.get("ORD_TEL_ENC") ;

				String strTemplateId = "";
				String strStateNm = "";

				/*System.out.println("app Code : "+appCd);
				if("01".equals(strSvcCd) || "07".equals(strSvcCd) || "08".equals(strSvcCd) || "09".equals(strSvcCd) ){

					if("".equals(appCd)){
						if("0".equals(strStateCd)){
							strTemplateId = "0001";
							strStateNm = "거래승인";
						}else if("1".equals(strStateCd) || "2".equals(strStateCd)){
							strTemplateId = "0002";
							strStateNm = "거래취소";
						}
					}
					else{
						String appDiv = appCd.substring(2,6);
						System.out.println("app Code : "+appDiv);
						if("0000".equals(appDiv)){
							if("0".equals(strStateCd)){
								strTemplateId = "0012";
								strStateNm = "거래승인";
							}else if("1".equals(strStateCd) || "2".equals(strStateCd)){
								strTemplateId = "0013";
								strStateNm = "거래취소";
							}
						}else if("0012".equals(appDiv)){
							if("0".equals(strStateCd)){
								strTemplateId = "0010";
								strStateNm = "거래승인";
							}else if("1".equals(strStateCd) || "2".equals(strStateCd)){
								strTemplateId = "0011";
								strStateNm = "거래취소";
							}
						}else{
							if("0".equals(strStateCd)){
								strTemplateId = "0001";
								strStateNm = "거래승인";
							}else if("1".equals(strStateCd) || "2".equals(strStateCd)){
								strTemplateId = "0002";
								strStateNm = "거래취소";
							}
						}



					}

				}else if("02".equals(strSvcCd)){
					if("".equals(appCd)){
						if("0".equals(strStateCd)){
							strTemplateId = "0001";
							strStateNm = "거래승인";
						}else if("1".equals(strStateCd) || "2".equals(strStateCd)){
							strTemplateId = "0002";
							strStateNm = "거래취소";
						}
					}else{
						String appDiv = appCd.substring(2,6);
						System.out.println("app Code : "+appDiv);
						if("0000".equals(appDiv)){
							if("0".equals(strStateCd)){
								strTemplateId = "0012";
								strStateNm = "거래승인";
							}else if("1".equals(strStateCd)){
								strTemplateId = "0013";
								strStateNm = "거래취소";
							}else if("2".equals(strStateCd)){
								strTemplateId = "0013";
								strStateNm = "환불";
							}
						}else if("0012".equals(appDiv)){
							if("0".equals(strStateCd)){
								strTemplateId = "0010";
								strStateNm = "거래승인";
							}else if("1".equals(strStateCd)){
								strTemplateId = "0013";
								strStateNm = "거래취소";
							}else if("2".equals(strStateCd)){
								strTemplateId = "0013";
								strStateNm = "환불";
							}
						}else{
							if("0".equals(strStateCd)){
								strTemplateId = "0001";
								strStateNm = "거래승인";
							}else if("1".equals(strStateCd)){
								strTemplateId = "0013";
								strStateNm = "거래취소";
							}else if("2".equals(strStateCd)){
								strTemplateId = "0013";
								strStateNm = "환불";
							}
						}
					}

				}else if("03".equals(strSvcCd)){
					if("0".equals(strStateCd)){
						strTemplateId = "0003";
						strStateNm = "가상계좌 입금";
					}

				}else if("05".equals(strSvcCd) || "06".equals(strSvcCd)){
					if("0".equals(strStateCd)){
						strTemplateId = "0001";
						strStateNm = "거래승인";
					}else if("1".equals(strStateCd)){
						strTemplateId = "0002";
						strStateNm = "거래취소";
					}
				}*/

    			resultMap.put( "dataMap", dataMap );
    		}
    	}

    	return resultMap;
	}

	@Override
    public Map<String, Object> selectSerTidInfo(Map<String, Object> objMap) throws Exception{
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	List<Map<String, Object>> dataList  = new ArrayList<Map<String, Object>>();
    	log.info( "tid 세부 정보 조회 start" );

    	dataMap = ( Map< String, Object > ) cardPaymentMgmtDAO.selectDetailCardTid( objMap );
    	log.info( "세부 정보 조회 data : " + dataMap );

    	// 부분취소 리스트를 가져온다.
    	/*dataList = getTransPartDetail( objMap );
    	resultMap.put( "tidDetailLst", dataList );

    	// 부분취소 잔액을 가져온다.
    	int iRemainAmt = 0;
    	iRemainAmt = (Integer)cardPaymentMgmtDAO.selectTransPartRemain( objMap );
    	String sRemainAmt = Integer.toString( iRemainAmt );
    	log.info( "remainAmt : "  + sRemainAmt );
    	dataMap.put( "remainAmt", sRemainAmt );
    	log.info( "dataMap : " + dataMap );*/

    	resultMap.put( "tidInfo", dataMap );
    	return resultMap;
	}
    public List<Map<String, Object>> getTransPartDetail(Map<String, Object> objMap) throws Exception {
    	List<Map<String, Object>> dataList  = new ArrayList<Map<String, Object>>();
    	log.info( "부분취소	거래내역 상세	조회 start" );
    	int iCheck = 0;

    	iCheck = (Integer)cardPaymentMgmtDAO.selectTransPartCnt( objMap );
    	log.info( "부분취소	거래내역 상세	조회 데이터 cnt : " + iCheck  );

    	if(iCheck == 1 )
    	{
    		dataList = cardPaymentMgmtDAO.selectTransPartDetail( objMap );
    		log.info( "부분취소	거래내역 상세	조회 데이터 1개: " +dataList );
		}
    	else if(iCheck > 1 )
		{
    		dataList = cardPaymentMgmtDAO.selectTransPartOrgDetail( objMap );
    		log.info( "부분취소	거래내역 상세	조회 데이터 여러개 : " +dataList );
		}
    	else
    	{
    		log.info( "부분취소	거래내역 상세	조회 데이터 x ");
    		return null;
    	}

    	return dataList;
    }
    @Override
    public List<Map<String, Object>> selectTransInfoTotalList(Map<String, Object> objMap) throws Exception{
    	return cardPaymentMgmtDAO.selectTransInfoTotalList( objMap );
    }

    @Override
    public Object selectTransInfoTotalListTotal(Map<String, Object> objMap) throws Exception{
    	return cardPaymentMgmtDAO.selectTransInfoTotalListTotal( objMap );
	}
    @Override
    public List<Map<String, Object>> selectCardInfoTotAmt(Map<String, Object> objMap) throws Exception{
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	List< Map<String, Object>>	resultMapList = new ArrayList<Map<String, Object>>();
    	
    	resultMapList = cardPaymentMgmtDAO.selectCardTotAmt( objMap );

    	log.info( "selectCardInfoAmt data  : " + resultMapList  );

    	
    	/*int  realAppCnt = 	Integer.parseInt(resultMapList.get(0).get( "REALAPPCNT" ).toString());
    	int  realAppAmt = 	Integer.parseInt(resultMapList.get(0).get( "REALAPPAMT" ).toString());
    	int  realCcCnt = 	Integer.parseInt(resultMapList.get(0).get( "REALCCCNT" ).toString());
    	int  realCcAmt = 	Integer.parseInt(resultMapList.get(0).get( "REALCCAMT" ).toString());
    	int  realRfCnt = 	Integer.parseInt(resultMapList.get(0).get( "REALRFCNT" ).toString());
    	int  realRfAmt = 	Integer.parseInt(resultMapList.get(0).get( "REALRFAMT" ).toString());*/
    	
    	/*int  testAppCnt = 	Integer.parseInt(String.valueOf(resultMapList.get(0).get( "TESTAPPCNT" )));
    	int  testAppAmt = 	Integer.parseInt(String.valueOf(resultMapList.get(0).get( "TESTAPPAMT" )));
    	int  testCcCnt = 	Integer.parseInt(String.valueOf(resultMapList.get(0).get( "TESTCCCNT" )));
    	int  testCcAmt = 	Integer.parseInt(String.valueOf(resultMapList.get(0).get( "TESTCCAMT" )));
    	int  testRfCnt = 	Integer.parseInt(String.valueOf(resultMapList.get(0).get( "TESTRFCNT" )));
    	int  testRfAmt = 	Integer.parseInt(String.valueOf(resultMapList.get(0).get( "TESTRFAMT" )));*/
    	
    	/*int  realAppCnt = (( BigDecimal  ) resultMap.get( "REALAPPCNT" )).intValue();
    	int  realAppAmt = (( BigDecimal  ) resultMap.get( "REALAPPAMT" )).intValue();
    	int  realCcCnt = (( BigDecimal  ) resultMap.get( "REALCCCNT" )).intValue();
    	int  realCcAmt = (( BigDecimal  ) resultMap.get( "REALCCAMT" )).intValue();
    	int  realRfCnt = (( BigDecimal  ) resultMap.get( "REALRFCNT" )).intValue();
    	int  realRfAmt = (( BigDecimal  ) resultMap.get( "REALRFAMT" )).intValue();
    	
    	int  testAppCnt = (( BigDecimal  ) resultMap.get( "TESTAPPCNT" )).intValue();
    	int  testAppAmt = (( BigDecimal  ) resultMap.get( "TESTAPPAMT" )).intValue();
    	int  testCcCnt = (( BigDecimal  ) resultMap.get( "TESTCCCNT" )).intValue();
    	int  testCcAmt = (( BigDecimal  ) resultMap.get( "TESTCCAMT" )).intValue();
    	int  testRfCnt = (( BigDecimal  ) resultMap.get( "TESTRFCNT" )).intValue();
    	int  testRfAmt = (( BigDecimal  ) resultMap.get( "TESTRFAMT" )).intValue();*/


   		/*int totTotCnt =  realAppCnt+realCcCnt+realRfCnt;
   		int totTotAmt =  realAppAmt+realCcAmt+realRfAmt;
    	int realTotCnt =  realAppCnt+realCcCnt+realRfCnt;
    	int realTotAmt=  realAppAmt+realCcAmt+realRfAmt;
    	int testTotCnt =  testAppCnt+testCcCnt+testRfCnt;
    	int testTotAmt =  testAppAmt+testCcAmt+testRfAmt;

    	int totAppCnt =  realAppCnt;
    	int totAppAmt =  realAppAmt;
    	int totCcCnt =  realCcCnt;
    	int totCcAmt=  realCcAmt;
    	int totRfCnt =  realRfCnt;
    	int totRfAmt=  realRfAmt;


    	resultMap.put( "TOT_TOT_CNT", totTotCnt );
    	resultMap.put( "TOT_TOT_AMT", totTotAmt );
    	resultMap.put( "REAL_TOT_CNT", realTotCnt );
    	resultMap.put( "REAL_TOT_AMT", realTotAmt );
    	resultMap.put( "TEST_TOT_CNT", testTotCnt );
    	resultMap.put( "TEST_TOT_AMT", testTotAmt );


    	resultMap.put( "TOT_APP_CNT", totAppCnt );
    	resultMap.put( "TOT_APP_AMT", totAppAmt );
    	resultMap.put( "TOT_CC_CNT", totCcCnt );
    	resultMap.put( "TOT_CC_AMT", totCcAmt );
    	resultMap.put( "TOT_RF_CNT", totRfCnt );
    	resultMap.put( "TOT_RF_AMT", totRfAmt );*/

    	return resultMapList;
	}



    @Override
    public List<Map<String, Object>> selectCheckCardEventList(Map<String, Object> objMap) throws Exception{
    	return cardPaymentMgmtDAO.selectCheckCardEventList( objMap );
    }

    @Override
    public Object selectCheckCardEventListTotal(Map<String, Object> objMap) throws Exception{
    	return cardPaymentMgmtDAO.selectCheckCardEventListTotal( objMap );
	}
    
    @Override
    public Map<String, Object> selectSerTidFailInfo(Map<String, Object> objMap) throws Exception{
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	List<Map<String, Object>> dataList  = new ArrayList<Map<String, Object>>();
    	log.info( "tid 세부 정보 조회 start" );

    	//dataMap = ( Map< String, Object > ) cardPaymentMgmtDAO.selectDetailCardTid( objMap );
    	dataMap = ( Map< String, Object > ) cardPaymentMgmtDAO.selectDetailCardFailTid( objMap );
    	
    	log.info( "세부 정보 조회 data : " + dataMap );

    	// 부분취소 리스트를 가져온다.
    	/*dataList = getTransPartDetail( objMap );
    	resultMap.put( "tidDetailLst", dataList );

    	// 부분취소 잔액을 가져온다.
    	int iRemainAmt = 0;
    	iRemainAmt = (Integer)cardPaymentMgmtDAO.selectTransPartRemain( objMap );
    	String sRemainAmt = Integer.toString( iRemainAmt );
    	log.info( "remainAmt : "  + sRemainAmt );
    	dataMap.put( "remainAmt", sRemainAmt );
    	log.info( "dataMap : " + dataMap );*/

    	resultMap.put( "tidInfo", dataMap );
    	return resultMap;
	}

	@Override
	public Map<String, Object> selectRecpt(String tid) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> dataMap = ( Map< String, Object > ) cardPaymentMgmtDAO.selectRecpt(tid);
		
		return dataMap;
	}
}
