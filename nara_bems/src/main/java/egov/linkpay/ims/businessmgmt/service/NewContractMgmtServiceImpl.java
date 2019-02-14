package egov.linkpay.ims.businessmgmt.service;

import java.math.BigDecimal;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import egov.linkpay.ims.baseinfomgmt.dao.BaseInfoMgmtDAO;
import egov.linkpay.ims.baseinfomgmt.dao.BaseInfoRegistrationDAO;
import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;
import egov.linkpay.ims.businessmgmt.dao.NewContractMgmtDAO;

import egov.linkpay.ims.common.common.CommonUtils;
/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.service
 * File Name      : NewContractMgmtServiceImpl.java
 * Description    : 영업관리 - 신규계약관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("newContractMgmtService")
public class NewContractMgmtServiceImpl implements NewContractMgmtService {
    Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="newContractMgmtDAO")
    private NewContractMgmtDAO newContractMgmtDAO;
    
    @Resource(name="baseInfoMgmtDAO")
    private BaseInfoMgmtDAO baseInfoMgmtDAO;

    @Resource(name="historySearchDAO")
    private HistorySearchDAO historySearchDAO;
    
    @Resource(name="baseInfoRegistrationDAO")
    private BaseInfoRegistrationDAO baseInfoRegistrationDAO;
    
    @Override
    public int uploadContImg(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
		try
		{
			log.info( "업로드 전 디비에 존재하는 지 조회 " );
			cnt = newContractMgmtDAO.selectContDocCnt(objMap);
			if(cnt  > 0)
			{
				log.info( "업로드 할 이미지 이미 존재 " );
				cnt = -1;
			}
			else
			{
				log.info( "이미지 업로드 " );
				cnt = newContractMgmtDAO.uploadContImg(objMap);
			}
		}
		catch(Exception e){
			log.error( "exception" , e );
			cnt = -1;
		}
    	
    	return cnt;
    }
    
    @Override
    public Map<String, Object> insertCoInfo(Map<String, Object> paramMap) throws Exception {
    	int logCount = 0;
    	int result = 0;
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	log.info( "INSERT CO INFO - START - " );
    	try
    	{
    		//date setting 
    		if(paramMap.get( "openDt" ) != null || paramMap.get( "openDt" ) != "")
            {
            	String openDt = CommonUtils.repYMD((String)paramMap.get("openDt"));
            	paramMap.put( "openDt",openDt );
            }
    		if(paramMap.get( "registDt" ) != null || paramMap.get( "registDt" ) != "")
    		{
    			String registDt = CommonUtils.repYMD((String)paramMap.get("registDt"));
    			paramMap.put( "registDt",registDt );
            }
    		if(paramMap.get( "contDt" ) != null || paramMap.get( "contDt" ) != "")
    		{
    			String contDt = CommonUtils.repYMD((String)paramMap.get("contDt"));
    			paramMap.put( "contDt",contDt );
    		}
    		
    		ArrayList<String> lst = new ArrayList<String>();
    		lst = ( ArrayList< String > ) paramMap.get( "checkOnPmCd" );

    		String[] checkOnPmCd = lst.toArray(new String[lst.size()]);
    		
    		String onPmCdLst = "";
    		String regPay = (String)paramMap.get( "registMoney" );
    		String yearPay = (String)paramMap.get( "yMoney" );
    		String state = (String)paramMap.get( "status" );
    		String bstate = "00";
    		String callMsg = (String)paramMap.get( "callMsg" );
    		String callTime = (String)paramMap.get( "callTime" );
    		String modify = (String)paramMap.get( "flg" );
    		boolean isComplete = false; //계약완료유무 
    		boolean isModify = modify.equals( "insert" )?false:true;  // 수정건 여부 modify.equals("T")
    		
    		
    		int i=0;
    		
    		List< Map<String, Object> > aLst = new ArrayList<Map<String,Object>>();
    		Map<String, Object> payRegMap = new HashMap<String, Object>();	// 입금 정보 등록비
    		Map<String, Object> payYearMap = new HashMap<String, Object>();	// 입금 정보 운영비
    		Map<String, Object> memoMap= new HashMap<String, Object>();		// 메모 정보
    		
    		if( checkOnPmCd!=null ) 
    		{
    			for(; i<checkOnPmCd.length; i++)	
    			{
    				onPmCdLst = onPmCdLst+checkOnPmCd[i]+","; // , 로 구분함.
    			}
    		} 
    		else 
    		{
    			onPmCdLst = "";
    		}
    		paramMap.put( "ON_SVC_LST", onPmCdLst );
    		log.info( "INSERT CO INFO - "+(logCount++)+"- 등록비 납부 셋팅 " );
    		// 등록비 납부
    		String uRPay = null;
    		if(regPay.equals( "none" ))
    		{
    			uRPay = "00";
    		} 
    		else if( regPay.equals("0"))
    		{   //   면제일경우
    			uRPay = "01";
    		}
    		else
    		{		 // 선택했을 경우, 선택하지 않았을 경우
    			if( regPay.equals("1"))
    			{   //   선택하지 않았을 경우.
    				regPay = "0";
    			}
    			else 
    			{
    				regPay = regPay+"0000";
    			}
    			uRPay	= "02";
    		}
    		paramMap.put( "registMoney", uRPay );
    		log.info( "INSERT CO INFO - "+(logCount++)+"- 연관리비 셋팅 " );
    		// 연 관리비
    		String uYPay = null;
    		if("none".equals(yearPay)) {
    			uYPay = "00";
    		} else if( yearPay.equals("0")){   //   면제일경우
    			uYPay = "01";
    		} else {		 // 선택했을 경우, 선택하지 않았을 경우
    			if( yearPay.equals("1")){   //   선택하지 않았을 경우.
    				yearPay = "0";
    			} else {
    				yearPay = yearPay+"0000";
    			}
    			uYPay	= "02";
    		}
    		paramMap.put( "yMoney", uYPay );
    		log.info( "INSERT CO INFO - "+(logCount++)+"- 승인상태 셋팅 " );
    		if( state!= null || state != "" ){
    			// 승인 완료 상태인 경우
    			if (state.equals("88") && !bstate.equals("88")){  // 88  : 계약완료
    				System.out.println(" ||||||||||||||||||||||||||| : "+state);			
    				isComplete = true;		
    			}
    		}
    		
    		aLst.add( paramMap );
    		
    		log.info( "INSERT CO INFO - "+(logCount++)+"- 메모 등록 " );
    		String strIp = "";
    		// == 메모 등록 START
    		//등록비
    		payRegMap.put( "coNo", paramMap.get( "coNo" ));
    		payRegMap.put( "payCd", "1");
    		payRegMap.put( "payAmt", regPay);
    		payRegMap.put( "worker", paramMap.get( "worker" ));
    		aLst.add( payRegMap );
    		//운영비
    		payYearMap.put( "coNo", paramMap.get( "coNo" ));
    		payYearMap.put( "payCd", "2" );
    		payYearMap.put( "payAmt", yearPay);
    		payYearMap.put( "worker", paramMap.get("worker"));
    		aLst.add( payYearMap );
    		
    		
    		boolean isMemo = false;
    		if( callMsg != null || callMsg != "" ){
    			isMemo = true;		
    			InetAddress local = InetAddress.getLocalHost();
    			String workIP = local.getHostAddress();
    			
    			String[] mTime = callTime.split(" "); 
    			mTime[0] = mTime[0].replace("/","");  // 일자 구분자
    			mTime[1] = mTime[1].replace(":","");  // 시간구분자
    			strIp = workIP;
    			
    			memoMap.put("wDt",mTime[0]);//  통화  일자
    			memoMap.put("wTm",mTime[1]);//  통화 시간		
    			memoMap.put("coNo",paramMap.get( "coNo" ));  // 사업자 번호		
    			memoMap.put("memo",callMsg); //   통화 내용
    			memoMap.put("worker",paramMap.get( "worker" ));	// 작업자 
    			memoMap.put("ip",strIp );	// 작업 IP 
    			
    			aLst.add(memoMap);
    		}
    		log.info( "INSERT CO INFO - "+(logCount++)+"- 카드 서브몰 등록 셋팅 " );
    		// == 카드 서브몰 등록 START
    		String[] cardList = null;
    		if( isComplete ){
    			/*
    		   Logic Flow
    		   1. 수수료(tb_settlmnt_fee) 테이블에서 등록된 카드 정보를 가져온다.
    		   2. 가져온 카드 정보를 카드사 서브몰 등록관리(tb_card_submall)에 등록한다. 
    			 */
    			// 미등록된 카드코드 가져오기
    			List<String> cardList1 = new ArrayList<String>();
    			String coNo = (String)paramMap.get( "coNo" );
    			cardList1 =newContractMgmtDAO.selectCardSubmallDupChkLst(coNo);
    			
    			int cardCnt = cardList1.size();		  
    			cardList = new String[cardCnt];
    			
    			// Debug
    			for( i = 0; i < cardCnt; i++) {
    				String list = cardList1.get( i );
    				cardList[i] = list;
    				log.info( "cardCd : " +  list);
    			}
    		}
    		log.info( "INSERT CO INFO - "+(logCount++)+"- 가맹점 등록 " );
    		if(paramMap.get("flg").equals( "modify" )){
    			Map<String,Object> changeMap = new HashMap<String ,Object>();
    			String tableNm = "TB_CO";
    			paramMap.put( "TABLE_NM", tableNm );
    			changeMap = updateBefore(paramMap);
    		}
    		log.info( "INSERT CO INFO - "+(logCount++)+"- 가맹점 등록 " );
    		
    		result = companyRegister(aLst, isMemo, isModify, cardList, (String)paramMap.get( "coNo" ));
    		log.info( "result : " + result );
    		resultMap.put("resultCd" , result);
    		//newContractMgmtDAO.insertCoInfo(paramMap);
    	}
    	catch(Exception e)
    	{
    		log.info( "INSERT CO INFO - Exception  : " , e );
    		result = -1;
    		resultMap.put("resultCd", result);
    	}
    	return resultMap;
    }
    
    
    @Override
    public Map<String, Object>selectCoIngView(Map<String, Object> objMap) throws Exception {
    	List<Map<String,Object>> dataList = new ArrayList<Map<String, Object>>();
		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> payMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();
		int logCount = 0;
		try
		{
			log.info( "selectCoView start " );
			dataMap = ( Map< String, Object > ) newContractMgmtDAO.selectCoView(objMap);
			log.info( "selectCoView  select : " +(logCount++)+ dataMap );
			// 초기등록비/연관리비 수납여부
			int i = 0;
			String strInitAmtFlgDesc = "미납";
			String strMngAmtFlgDesc = "미납";
			
			// 초기등록비/연관리비 금액	
			String strInitAmt = "none";
			String strMngAmt = "none";
			
			
			log.info( "초기등록비 : " + dataMap.get( "PAY_FRSTFEE_TYPE" ) );
			//등록비 
			if(dataMap.get( "PAY_FRSTFEE_TYPE" ).equals( "00" ) )
			{
				strInitAmtFlgDesc = "&nbsp;";
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("coNo",objMap.get( "coNo" ));
				map.put("payCd","1");
				payMap = ( Map< String, Object > ) newContractMgmtDAO.selectContPayInfo(map);
				log.info( "paymap : " + payMap );
				if ((payMap == null || payMap.size() < 1 || payMap.isEmpty()) || ((BigDecimal)payMap.get("REQ_AMT")).intValue() <= 10000) {
					strInitAmt = "none";
				} else {
					strInitAmt = String.valueOf((int)payMap.get("REQ_AMT")/10000);
				}
			}
			else if(dataMap.get( "PAY_FRSTFEE_TYPE" ).equals( "01" ))
			{
				strInitAmtFlgDesc = "면제";
				strInitAmt = "0";
			}
			else
			{
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("coNo",objMap.get( "coNo" ));
				map.put("payCd","1");
				payMap = ( Map< String, Object > ) newContractMgmtDAO.selectContPayInfo(map);
				log.info( "selectCoView  select  contPayInfo  : " +(logCount++)+ "success" );
				
				if (!(payMap == null || payMap.isEmpty()) && !( ((BigDecimal)payMap.get("REQ_AMT")).intValue() <= 10000 )) {
					strInitAmt = String.valueOf((int)payMap.get("REQ_AMT")/10000);
				}

				if("99".equals(dataMap.get("PAY_FRSTFEE_TYPE"))) {
					strInitAmtFlgDesc = "납부";      
				} else {
		    		strInitAmtFlgDesc = "대상";
				}
				
			}
			
			//연관리비
			if(dataMap.get( "PAY_YEARFEE_TYPE" ).equals( "00" ) )
			{
				strInitAmtFlgDesc = "&nbsp;";
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("coNo",objMap.get( "coNo" ));
				map.put("payCd","2");
				payMap = ( Map< String, Object > ) newContractMgmtDAO.selectContPayInfo(map);
				if ((payMap == null || payMap.size() < 1 || payMap.isEmpty()) || ((BigDecimal)payMap.get("REQ_AMT")).intValue() <= 10000) {
					strInitAmt = "none";
				} else {
					strInitAmt = String.valueOf((int)payMap.get("REQ_AMT")/10000);
				}
			}
			else if(dataMap.get( "PAY_FRSTFEE_TYPE" ).equals( "01" ))
			{
				strInitAmtFlgDesc = "면제";
				strInitAmt = "0";
			}
			else
			{
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("coNo",objMap.get( "coNo" ));
				map.put("payCd","2");
				payMap = ( Map< String, Object > ) newContractMgmtDAO.selectContPayInfo(map);
				log.info( "selectCoView  select  contPayInfo  : " +(logCount++)+ "success" );
				
				if (!(payMap == null || payMap.isEmpty()) && !( ((BigDecimal)payMap.get("REQ_AMT")).intValue() <= 10000 )) {
					strInitAmt = String.valueOf(((BigDecimal)payMap.get("REQ_AMT")).intValue()/10000);
				}

				if("99".equals(dataMap.get("PAY_YEARFEE_TYPE"))) {
					strInitAmtFlgDesc = "납부";      
				} else {
		    		strInitAmtFlgDesc = "대상";
				}
			}
			
			//수수료 
			Map<String, Object> feeMap = new HashMap<String, Object>();
			feeMap = getContFee((String)objMap.get( "coNo" ));
			
			log.info( "feeMap :  " + feeMap  );

			//온라인 서비스 리스트 
			String[] onChecked =  {"","","","","",""};  //  신용카드, 계좌이체, 가상계좌, 휴대폰 존재. -> 바로바로도 추가됨 
			log.info( "onLst : " +  dataMap.get( "ON_SVC_LST" ) );
			if(dataMap.get( "ON_SVC_LST" ) != null ){
				
				String[] onSvc = dataMap.get("ON_SVC_LST").toString().split(",");
				for ( i=0; i< onSvc.length; i++ ){	
					onChecked[Integer.parseInt(onSvc[i])-1] = "checked";
					log.info( "onChecked : " + onChecked[Integer.parseInt(onSvc[i])-1] );
				}
				dataMap.put( "onList", onChecked);
			}
			boolean isComplete = false; //20090421  계약완료유무 
			if (dataMap.get("CONT_ST_CD").equals("88")){  // 88  : 계약완료		
				isComplete = true;		
				log.info("계약 완료!!" );
			}	
			dataMap.put( "strInitAmtFlgDesc", strMngAmtFlgDesc );
			dataMap.put( "strMngAmtFlgDesc", strMngAmtFlgDesc );
			dataMap.put( "strInitAmt", strInitAmt );
			dataMap.put( "strMngAmt", strMngAmt );
			dataMap.put( "isComplete", isComplete );
			resultMap.put( "feeMap", feeMap );
			resultMap.put( "coView", dataMap );
		}
		catch(Exception e)
		{
			log.error( "selectCoView Exception : " ,  e  );
		}
		
        return resultMap;
    }
    /**
     * 수수료정보 가져오기 현황메인 한개의 값만.
     *@param   coNo     : 사업자번호
     *@return String[a][b]   : 수수료 정보 
     * <pre>              a > 0 : 온라인 
     *                        1 : 모바일
     *                    b > 0: 카드 수수료             
     *                        1: 계좌이체 수수료             
     *                        2: 가상계좌 수수료         
     *                        3: 휴대폰 수수료    
     * </pre>                       
     *@throws SQLException <br>
     *@throws Exception <br>
     */
  	public Map<String,Object> getContFee(String coNo) throws Exception {
  		String[][] feeInfo = {{"","","",""},{"","","",""}};		

  		List feeList = null;
  		ArrayList feeAl = null; 
  		int i=0;

  		Map<String,Object> rmap = new HashMap<String,Object>();
  		
  		// 온라인  -----------------------------------------------------------------
  		Map<String,Object> map = new HashMap<String,Object>();
  		map.put("coNo",coNo);
  		map.put("spmCd","01");  // 01: 온라인,  02: 모바일 		
  			
  		feeList = newContractMgmtDAO.selectCoFee( map );
  		feeAl = (ArrayList)feeList; 

  		//  code1  == fn_cd
  		if(feeAl.size() > 0) {
  			for( i = 0; i < feeAl.size(); i++) {
  				Map<String,Object> dm = (Map<String,Object>)feeAl.get(i); // fr_dt ,fee , fn_cd  // code1 , desc1
  			
  				String mname = (String)dm.get("PM_CD") + (String)dm.get("SPM_CD");
  			
  				rmap.put(mname, dm.get("FEE"));
  			}
  		}

  		// 모바일   ----------------------------------------------------------------
  		map = new HashMap<String,Object>();
  		map.put("coNo",coNo);
  		map.put("spmCd","02");  // 01: 온라인,  02: 모바일 		
  			
  		feeList = newContractMgmtDAO.selectCoFee( map );
  		feeAl = (ArrayList)feeList; 

  		//  code1  == fn_cd
  		if(feeAl.size() > 0) {
  			for( i = 0; i < feeAl.size(); i++) {
  				Map<String,Object> dm = (Map<String,Object>)feeAl.get(i); // fr_dt ,fee , fn_cd  // code1 , desc1
  			
  				String mname = (String)dm.get("PM_CD") + (String)dm.get("SPM_CD");
  			
  				rmap.put(mname, dm.get("FEE"));
  			}
  		}
  		return rmap;		  
  	}	
    
    @Override
    public List<Map<String, Object>> selectCoInfoList(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectCoInfoList(objMap);
    }
    public Object selectCoInfoListTotal(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectCoInfoListTotal(objMap);
    }
    @Override
    public List<Map<String, Object>> selectContImgList(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectContImgList(objMap);
    }
    public Object selectContImgListTotal(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectContImgListTotal(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectCoNo(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectCoNo(objMap);
    }

    @Override
    public List<Map<String, String>> selectCodeCl(String codeCl) throws Exception {
        return newContractMgmtDAO.selectCodeCl(codeCl);
    }
    @Override
    public List<Map<String, String>> selectEmplList(Map<String, Object> paramMap) throws Exception {
        return newContractMgmtDAO.selectEmplList(paramMap);
    }
    
    @Override
    public Map<String, Object> selectCardFeeInfo(Map<String, Object> paramMap) throws Exception {
    	Map< String, Object > dataMap = new HashMap<String, Object>();
    	Map< String, Object > cardMap = new HashMap<String, Object>();
    	Map< String, Object > overCardCd = new HashMap<String, Object>();
    	Map< String, Object > majorCardCd = new HashMap<String, Object>();
    	List< Map<String, Object>>	overCardCdList = new ArrayList<Map<String, Object>>();
    	List< Map<String, Object>>	majorCardCdList = new ArrayList<Map<String, Object>>();
    	Map< String, Object > feeMap = new HashMap<String, Object>();
    	List< Map<String, Object>>	objList = new ArrayList<Map<String, Object>>();
    	List<String[]> merIdList = new ArrayList<String[]>();
    	int logCount = 0 ;
    	//카드 코드 리스트 조회 
		paramMap.put( "code2", "over" );
		objList = baseInfoMgmtDAO.selectCardCd(paramMap);
		cardMap.put( "CODE1", "38" );
		cardMap.put( "DESC1", "은련" );
		objList.add( cardMap );
		if(objList.size() == 0)
		{
			log.info( "신규계약진행현황 -" +(logCount++) +"- 해외카드 코드 리스트 정보 없음" );
		}
		else
		{
			log.info( "신규계약진행현황-" +(logCount++) +  "-해외 카드 코드 리스트 정보 data : " + ToStringBuilder.reflectionToString( objList ) );
			for(int i=0; i<objList.size(); i++)
			{
				overCardCd = objList.get( i );
				overCardCdList.add( overCardCd  );
			}
			dataMap.put( "overCardCd", objList );
		}
		paramMap.put( "code2", "pur" );
		objList = baseInfoMgmtDAO.selectCardCd(paramMap);
		
		if(objList.size() == 0)
		{
			log.info( "신규계약진행현황-" +(logCount++) +"- major카드 코드 리스트 정보 없음" );
		}
		else
		{
			log.info( "신규계약진행현황-" +(logCount++) +  "- major카드 코드 리스트 정보 data : " + ToStringBuilder.reflectionToString( objList ) );
			for(int i=0; i<objList.size(); i++)
			{
				majorCardCd = objList.get( i );
				majorCardCdList.add( majorCardCd  );
			}
			
			dataMap.put( "majorCardCd", objList );
		}
		objList = newContractMgmtDAO.selectCoFeeInfo( paramMap );
		if(objList.size() == 0)
		{
			log.info( "신규계약진행현황-" +(logCount++) +"- 가맹점 수수료  리스트 정보 없음" );
		}
		else
		{
			log.info( "신규계약진행현황-" +(logCount++) +  "- 가맹점 수수료 리스트 정보 data : " + ToStringBuilder.reflectionToString( objList ) );
			int feeSize = objList.size();
			String[] matchId= {"",""};
			String[][] feeInfo = new String[feeSize][3];
			
			if(paramMap.get( "load" ) != null || paramMap.get( "load" ) != "")
			{
				int i = 0 ;
				for(i=0; i<feeSize; i++ ){
					feeMap = objList.get( i );
					BigDecimal bdFee = ( BigDecimal ) feeMap.get( "FEE" );
					feeInfo[i][0] = (String)feeMap.get( "CP_CD" );
					feeInfo[i][1] = bdFee.toString();
					feeInfo[i][2] = (String)feeMap.get( "FR_DT" );
				}
			}
			int overCardCdSize = overCardCdList.size();
			int majorCardCdSize = majorCardCdList.size();
			
			for(int i=0; i<overCardCdSize+majorCardCdSize; i++)
			{
				if(i < majorCardCdSize)
				{
					if(feeSize > 0)
					{
						// 저장된 정보가 있으면 불러온다.  ( 수수료, 적용기간 )
						matchId = matchFeeInfo(feeInfo, (String)majorCardCdList.get( i ).get( "CODE1" ));
					}
				}
				else
				{
					if(feeSize > 0)
					{
						// 저장된 정보가 있으면 불러온다.  ( 수수료, 적용기간 )
						matchId = matchFeeInfo(feeInfo, (String)overCardCdList.get( i - majorCardCdSize).get( "CODE1" ));
					}
				}
				merIdList.add( matchId );
			}
			dataMap.put( "merIdList", merIdList );
			
			dataMap.put( "coFeeList", objList );
		}
    	return dataMap;
    }
    public String[] matchFeeInfo(String[][] feeInfo, String fnCode){
    	String[] matchInfo = {"",""};
    	
    	for( int i=0; i<feeInfo.length; i++) {
    		if(feeInfo[i][0].equals(fnCode)){
    			// 수수료
    			matchInfo[0] = feeInfo[i][1];
    			// 적용기간   yyyMMdd  -> yyyy/MM/dd
    			matchInfo[1] =  feeInfo[i][2].substring(0,4)+"/"
    											+feeInfo[i][2].substring(4,6)+"/"
    											+feeInfo[i][2].substring(6,8);
    		}
    	}
    	return matchInfo;
    }
    //card fee insert
    public Map<String, Object> insertCardFeeReg(Map<String, Object> paramMap) throws Exception {
    	Map<String, Object> resultMap = new HashMap<String,Object>();
    	int cnt = 0 ;
    	int dSize = Integer.parseInt(paramMap.get("dSize").toString());	// 카드수
    	int i = 0; // loop cnt
    	String spmCd = (String)paramMap.get("spmCd");	// 01: 온라인, 02: 모바일 , 03:스마트폰  
    	String coNo = (String)paramMap.get("coNo");	// 사업자번호
    	String pmCd = (String)paramMap.get("pmCd");	// 지불수단  ( 01: 신용카드, 02 : 계좌이체, 03: 가상계좌, 05: 휴대폰, 06 : 휴대폰 빌링 )
    	String feeType = "";
    	String[] feeList = new String[dSize];	// 수수료
    	String[] codeList = new String[dSize];	// 은행 코드
    	String[] sDateList = new String[dSize];	// 적용기간
    	String  data = "";
    	for (; i<dSize ; i++ ){
    		data = (String)paramMap.get("date_"+i);
    		feeList[i] = (String)paramMap.get("fee_"+i);	
    		codeList[i] = (String)paramMap.get("code_"+i);	
    		sDateList[i] = data.replaceAll( "[^0-9]", "" );	
    	}

    	// 카드,계좌의 경우 실패시 rollback 진행필요.. control 에서 처리함.
    	ArrayList<Map<String, Object>> aLst = new ArrayList<Map<String, Object>>();
    	
    	// dSize 만큼 loop 를 돌면서 입력해야함.
    	for ( i=0; i < dSize ; i++ ){
    		// 수수료가 입력되어 있는 경우에만  insert 진행
    		if ( feeList[i] != null || feeList[i] != "") {
    			Map<String, Object> dataMap = new HashMap<String, Object>();

    			dataMap.put("pmCd",pmCd);	// 지불수단  ( 01: 신용카드, 02 : 계좌이체, 03: 가상계좌, 05 : 휴대폰, 06 : 휴대폰빌링 )
    			dataMap.put("spmCd",spmCd);	//   Sub지불수단 ( 01: 온라인,  02: 모바일, 03:스마트폰 )
    			dataMap.put("fee",feeList[i]);		// 수수료
    			dataMap.put("date",sDateList[i]);	// 적용일	(시작일자)
    			dataMap.put("worker", paramMap.get( "worker" ));	// LOGIN USER			
    			dataMap.put("coNo",coNo);	// 사업자 번호		
    			
    			// 제휴사( 신용카드 : 카드사코드, 계좌이체 : KFTC, 가상계좌 : sbnk,  )
    			if( pmCd.equals("01")){			// 카드사인 경우
    				dataMap.put("cpCd",codeList[i]);	
    				dataMap.put("feeType","2");		// 수수료유형		
    			
    			} else if( pmCd.equals("02")){	// 계좌이체 
    				dataMap.put("cpCd","00");	
    				dataMap.put("amtPart",i);	// 금액 영역	
    				if ( i==0 ){
    					dataMap.put("feeType","3");		// 수수료유형	 1-10000 구간만				
    				} else {
    					dataMap.put("feeType","2");		// 수수료유형					
    				}
    				
    			} else if( pmCd.equals("03")) {	// 가상계좌
    				dataMap.put("cpCd",codeList[i]);	
    				dataMap.put("feeType","3");		// 수수료유형		
    			}	else { // 휴대폰, 휴대폰빌링
    				dataMap.put("cpCd","00");
    			  	dataMap.put("feeType",feeType);
    			}
    			
    			aLst.add(dataMap);		
    	
    		}
    	}
    	cnt = feeReg(aLst);
    	
    	log.info("=======  result  : "+cnt); 
    	if( cnt > 0 )
    		cnt= 2;	// 성공
    	else
    		cnt = 1;	// 실패
    	
    	String dpFee = "";
    	if("02".equals(pmCd)) 
    	{
    		dpFee = feeList[1].toString(); 
		}
    	else 
    	{
    		dpFee = feeList[0].toString(); 
		}
    	
    	resultMap.put( "cnt", cnt );
    	resultMap.put( "dpFee", dpFee );
    	
        return resultMap;
    }
    public int feeReg(ArrayList<Map< String, Object >> aLst) throws Exception{
    	int aSize =aLst.size();
		int result = 0;				
		Map< String, Object > map = new HashMap<String, Object >();
		try 
		{
			// 계좌 혹은 카드 정보가 있을 경우의 처리
			for( int i=0; i< aSize; i++) 
			{	
				if( i!=0 ) 
				{
					map.clear(); 
				}
				
				map = (Map< String, Object >)aLst.get(i);
				
				map.put( "id", map.get( "coNo" ) );
				map.put( "idCd", '0');
				result = newContractMgmtDAO.selectFee( map );
				if(result >  0 )
				{
					result = (Integer)newContractMgmtDAO.updateFee(map);
					log.info("update result : "+result);
				}
				else
				{
					result = (Integer)newContractMgmtDAO.insertFee(map);
					log.info(" insert result : "+result);
				}
				
				if( result == 0 )
				{
					i = aSize;
				}				
			}				

			//  모두 등록이 되어야 된다.
			if( result > 0)
			{
				log.info(" --  등록 성공 : Commit ");
			} 
			else 
			{					
				log.info(" --  등록 실패 : RollBack ");		
			}			
			
		}
		catch (Exception e)
		{
			result =-1;
			log.error("Exception  -- registerUser   ERROR ", e);
		} 
		return result;		
    }
    
    public int companyRegister(List< Map< String, Object > > aLst, boolean isMemo, boolean isModify, String[] cardList, String coNo) throws Exception {
    	
    	int result = aLst.size();
		// 0 사업자정보, 1 등록비, 2 운영비, 3 통화정보 
		Map<String, Object> userMap = new HashMap<String, Object>();	
		Map<String, Object> payRegMap = new HashMap<String, Object>();
		Map<String, Object> payYearMap = new HashMap<String, Object>();
		Map<String, Object> memoMap = new HashMap<String, Object>();
		
		try 
		{
			userMap = aLst.get( 0 );
			payRegMap = aLst.get( 1 );
			payYearMap = aLst.get( 2 );
			memoMap = aLst.get( 3 );
			
			if( isModify ) { // 수정건인 경우  
				result = newContractMgmtDAO.updateCoInfo(userMap);
			} else { 		// 입력건인 경우
				result = newContractMgmtDAO.insertCoInfo(userMap);
			}
			
			/*******************************************************
			 * 등록비/연관리비 처리
			 * -----------------------------------------------------
			 * 납부 : P
			 * 존재 : E
			 * 미존재 : N
			 * 
			 * 등록비/연관리비 납부되었을 경우
			 * - 변경안됨
			 * 
			 * 등록비/연관리비가 존재(del_cl = '0')할 경우
			 * - Parameter가 none 
			 *   delete => del_cl = '1'
			 * - Parameter가 0
			 *   update => exp_cl = '1', req_amt = 0
			 * - Parameter Else
			 *   update => exp_cl = '0', req_amt = paramVal
			 *   
			 * 등록비/연관리비가 미존재할 경우
			 * - Parameter가 none : Action 없음
			 * - Else 생성
			 *******************************************************/
			
			String strRegChk = (String)newContractMgmtDAO.chkPayStatus(payRegMap); 
			String strYearChk = (String)newContractMgmtDAO.chkPayStatus(payYearMap);
			
			if(strRegChk.equals( "P" )) 
			{
			}
			else if(strRegChk.equals( "E" )) 
			{
				if(payRegMap.get( "payAmt" ) == null) 
				{
					// 삭제
					result = newContractMgmtDAO.paymentUpDel(payRegMap);
				}
				else 
				{
					// Update regPay 상태에 따라...
					result = newContractMgmtDAO.paymentUpdate(payRegMap);
				}
			}
			else 
			{
				if(payRegMap.get( "payAmt" )!=null) 
				{
					// 생성
					result = newContractMgmtDAO.insertPayment(payRegMap);
				}
			}
			
			if("P".equals(strYearChk)) 
			{
			} else if("E".equals(strYearChk)) 
			{
				if(payYearMap.get( "payAmt" )==null) 
				{
					// 삭제
					result = newContractMgmtDAO.paymentUpDel(payYearMap);
				} 
				else 
				{
					// Update regPay 상태에 따라...
					result = newContractMgmtDAO.paymentUpdate(payYearMap);
				}
			} 
			else 
			{
				if(payYearMap.get( "payAmt" )!=null) 
				{
					// 생성
					result = newContractMgmtDAO.insertPayment(payYearMap);
				}
			}
			
			System.out.println("---------------["+strRegChk+"]["+strYearChk+"]");


			// 통화정보
			if(isMemo && result >0 )
			{  
				//통화정보가 있는 경우에만.			
				result = newContractMgmtDAO.insertMemo(memoMap);
			}
			
			if ( result >0 && cardList!=null && cardList.length >0 )
			{
				// 카드정보가 있는 경우
				System.out.println("---------------- 카드 정보가 있다 -----------------------");
				
				for ( int i=0; i< cardList.length; i++)
				{
					Map<String, Object> cMap = new HashMap< String, Object >();
					cMap.put("coNo",coNo);  // 사업자 번호
					cMap.put("cpCd",cardList[i]);  // 카드코드
					cMap.put("worker",userMap.get( "worker" ));  // 로그인 유저
					System.out.println("  >>>> ["+i+"]  coNo : "+coNo+"   ,  fnCd  :"+cardList[i]+"  /  worker :"+userMap.get( "worker" ));
					result = newContractMgmtDAO.insertCardSub(cMap);
					if ( result==0 )
					{
						break;
					}
				}
			}

			//  모두 등록이 되어야 된다.
			if( result > 0){
				System.out.println(" --  전체 등록 성공 : Commit ");
			} else {					
				System.out.println(" --  등록 실패 : RollBack ");		
			}					
		
		} catch (Exception se){
			result =-1;
			System.out.println(" -- registerUser   ERROR ");
			se.printStackTrace();

		} 
		
		return result;
    }
    
    
    //신규계약 승인 리스트 조회
    @Override
    public List<Map<String, Object>>  selectCoApprInfoList(Map<String, Object> objMap) throws Exception {
    	return newContractMgmtDAO.selectCoApprInfoList(objMap);
    }
    @Override
    public Object selectCoApprInfoListTotal(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectCoApprInfoListTotal(objMap);
    }
    
  //신규계약 승인 리스트 조회 구분 MID
    @Override
    public List<Map<String, Object>>  selectCoApprMInfoList(Map<String, Object> objMap) throws Exception {
    	return newContractMgmtDAO.selectCoApprMInfoList(objMap);
    }
    @Override
    public Object selectCoApprMInfoListTotal(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectCoApprMInfoListTotal(objMap);
    }
    
  //신규계약 승인 리스트 조회 구분 VID
    @Override
    public List<Map<String, Object>>  selectCoApprVInfoList(Map<String, Object> objMap) throws Exception {
    	return newContractMgmtDAO.selectCoApprVInfoList(objMap);
    }
    @Override
    public Object selectCoApprVInfoListTotal(Map<String, Object> objMap) throws Exception {
        return newContractMgmtDAO.selectCoApprVInfoListTotal(objMap);
    }
    
    public void updateCoApp(Map<String, Object> objMap) throws Exception {
    	if(objMap.get( "approv" ).equals( "1" ))
    	{
    		objMap.put( "approv", "21" ); //승인
    	}
    	else
    	{
    		objMap.put( "approv", "22" ); //반려
    	}
    	
        newContractMgmtDAO.updateCoApp(objMap);
    }
    
    @Override
    public Map<String, Object>selectCoView(Map<String, Object> objMap) throws Exception {
    	List<Map<String,Object>> dataList = new ArrayList<Map<String, Object>>();
		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> payMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();
		int logCount = 0;
		String rAmt = "";
		String rFlg = "";
		String yAmt = "";
		String yFlg = "";
		try
		{
			log.info( "selectCoView start " );
			dataMap = ( Map< String, Object > ) newContractMgmtDAO.selectCoView(objMap);
			log.info( "selectCoView  select : " +(logCount++)+ dataMap );
			
			//등록비 
			if(dataMap.get( "PAY_FRSTFEE_TYPE" ).equals( "01" ) )
			{
				rAmt = "면제";
				rFlg = "면제"	;	
			}
			else
			{
				objMap.put( "payCd", "1");
				log.info( "selectCoView  select  contPayInfo  : " +(logCount++)+ "success" );
				payMap = ( Map< String, Object > ) newContractMgmtDAO.selectContPayInfo(objMap);
				if(payMap != null)
				{
					if(payMap.get( "PAY_ST_TYPE" ).equals( "0" ))
					{
						rFlg = "납부";
					}
					else
					{
						rFlg = "미납";
					}
					rAmt = (payMap.get("REQ_AMT")==null?"":((BigDecimal)payMap.get( "REQ_AMT" )).toString());
				}
				
			}
			dataMap.put( "rAmt", rAmt );
			dataMap.put( "rFlg", rFlg );
			
			
			//연관리비
			if(dataMap.get( "PAY_YEARFEE_TYPE" ).equals( "01" ) )
			{
				yAmt = "면제";
				yFlg = "면제"	;	
			}
			else
			{
				objMap.put( "payCd", "2");
				log.info( "selectCoView  select  contPayInfo  : " +(logCount++)+ "success" );
				payMap = ( Map< String, Object > ) newContractMgmtDAO.selectContPayInfo(objMap);
				if(payMap != null)
				{
					if(payMap.get( "PAY_ST_TYPE" ).equals( "0" ))
					{
						yFlg = "납부";
					}
					else
					{
						yFlg = "미납";
					}
					yAmt = (payMap.get("REQ_AMT")==null?"":((BigDecimal)payMap.get("REQ_AMT")).toString());
				}
				
			}
			dataMap.put( "yAmt", yAmt );
			dataMap.put( "yFlg", yFlg );
			
			// 회원사 계약담당
			String contInfo = "";	 
			if(dataMap.get( "CONT_NM" ) != null && dataMap.get( "CONT_NM" ) != "" )
			{
				contInfo = "&nbsp;&nbsp;성명 : "+dataMap.get("CONT_NM");	
			}
			if(dataMap.get( "CONT_TEL" ) != null &&dataMap.get( "CONT_TEL" ) != "" )
			{
				contInfo = "&nbsp;&nbsp;TEL : "+dataMap.get("CONT_TEL");	
			}
			if(dataMap.get( "CONT_CP" ) != null && dataMap.get( "CONT_CP" ) != "" )
			{
				contInfo = "&nbsp;&nbsp;CP : "+dataMap.get("CONT_CP");	
			}
			if(dataMap.get( "CONT_EMAIL" ) != null &&dataMap.get( "CONT_EMAIL" ) != "" )
			{
				contInfo = "&nbsp;&nbsp;EMAIL : "+dataMap.get("CONT_EMAIL");	
			}
			dataMap.put( "contMng" , contInfo );
			// 회원사 정산담당
			String settInfo = "&nbsp;";	 
			if(dataMap.get( "SETT_NM" ) != null &&dataMap.get( "SETT_NM" ) != "" )
			{
				settInfo = "&nbsp;&nbsp;성명 : "+dataMap.get("SETT_NM");	
			}
			if(dataMap.get( "SETT_TEL" ) != null && dataMap.get( "SETT_TEL" ) != "" )
			{
				settInfo = "&nbsp;&nbsp;TEL : "+dataMap.get("SETT_TEL");	
			}
			if(dataMap.get( "SETT_EMAIL" ) != null&&dataMap.get( "SETT_EMAIL" ) != "" )
			{
				settInfo = "&nbsp;&nbsp;EMAIL : "+dataMap.get("SETT_EMAIL");	
			}
			dataMap.put( "settMng" , settInfo );
			
			//온라인 서비스 리스트 
			String onList =  "&nbsp;"; 
			if(dataMap.get( "ON_SVC_LST" ) != null ){
				String[] onSvc = dataMap.get("ON_SVC_LST").toString().split(",");
				for ( int i=0; i< onSvc.length; i++ ){	
					switch ( Integer.parseInt( onSvc[i]) ) {
						case 1: onList= onList+"신용카드, "; break;
						case 2: onList= onList+"계좌이체, "; break;
						case 3: onList= onList+"가상계좌, "; break;				
						case 4: onList= onList+"현금영수증, "; break;
						case 5: onList= onList+"휴대폰, "; break;
					}
				}
				dataMap.put( "onList", onList);
			}
			
			//주소	
			log.info( "dataMap : " + dataMap );
			String addStr= "";	
			if(dataMap.get( "POST_NO" ) != null && dataMap.get( "POST_NO" ) != ""){
				addStr = "["+dataMap.get("POST_NO")+"]";
				log.info( "address : " +addStr );
			}
			if(dataMap.get( "ADDR_NO1" ) != null && dataMap.get( "ADDR_NO1" ) != ""){
				addStr = addStr + "  "+dataMap.get("ADDR_NO1");
				log.info( "address : " +addStr );
			}
			if(dataMap.get( "ADDR_NO2" ) != null && dataMap.get( "ADDR_NO2" ) != ""){
				addStr = addStr + "  "+dataMap.get("ADDR_NO2");
				log.info( "address : " +addStr );
			}
			log.info( "address : " +addStr );
			dataMap.put( "address" , addStr );
			
			
			
			resultMap.put( "coView", dataMap );
			
			dataList = newContractMgmtDAO.selectCoMemoList(objMap);
			log.info( "selectCoView  select  memo : " +(logCount++)+ "success" );
			resultMap.put( "memoList", dataList );
			
			Map<String,Object> feeAllMap = new HashMap<String, Object>();
			feeAllMap = ( Map< String, Object > ) newContractMgmtDAO.selectContFeeAllInfo(objMap);
			log.info( "selectCoView  select  contFeeAllInfo : " +(logCount++)+ "success" );
			String pmCd[] = {"on","sm"};
			String spmCd[] = {"cp","cpb"};
			String mark[] = {"","","",""};
			
			for(int j=0; j < pmCd.length; j++){
				for(int k=0; k < spmCd.length; k++){
					int index = j+k;
					if(k == 1) index++;
					
					if("2".equals(feeAllMap.get(pmCd[j]+"_"+spmCd[k]+"_TYPE"))) mark[index] = "%";
					else 	mark[index] = "원";
				}
			}
			log.info( "selectCoView 수수료 : " + mark );
			
			resultMap.put( "mark", mark );
			
			resultMap.put( "contFeeAllInfo", feeAllMap );
			
			
		}
		catch(Exception e)
		{
			log.error( "selectCoView Exception : " ,  e  );
		}
		
        return resultMap;
    }
    
    @Override
    public Map<String,Object> selectFeeViewCardLst(Map< String, Object > paramMap) throws Exception {
    	List<Map<String,Object>> dataList = new ArrayList<Map<String, Object>>();
    	List<Map<String,Object>> feeList = new ArrayList<Map<String, Object>>();
    	List<Map<String,Object>> feeAddList = new ArrayList<Map<String, Object>>();
    	Map<String, Object > dataMap = new HashMap<String, Object>();
    	Map<String, Object > cardMap = new HashMap<String, Object>();
    	Map<String, Object > feeMap = new HashMap<String, Object>();
    	Map<String, Object > feeAddMap = new HashMap<String, Object>();
    	String resultCd = "";
    	
    	paramMap.put( "code2", "pur" );
    	dataList = baseInfoRegistrationDAO.selectCardCd(paramMap);
    	
    	dataMap.put( "cardList", dataList );
    	
		paramMap.put( "code2", "over" );
    	dataList = baseInfoRegistrationDAO.selectCardCd(paramMap);
    	dataMap.put( "overCardList", dataList );
    	
    	if(paramMap.get( "mid" ) != null)
    	{
    		paramMap.put("inqy_cl","1");
    		paramMap.put("status" , "0");
    		paramMap.put("idCd" , "1");
    		feeList = newContractMgmtDAO.selectFeeViewCardLst(paramMap);
    		log.info( "feeList Size : " + feeList.size() );
    		for(int i=0; i<feeList.size(); i++)
    		{
    			feeMap = feeList.get( i );
    			
    			String id = (String)feeMap.get( "PM_CD" ) + (String)feeMap.get( "SPM_CD" ) + (String)feeMap.get( "CP_CD" ); 
    			feeAddMap.put( "FEE_"+id , feeMap.get( "FEE" ) );
    			feeAddMap.put( "FR_DT_"+id , feeMap.get( "FR_DT" ) );
    			log.info( "feeMap : "  + feeMap );
    			feeAddList.add( feeAddMap);
    			log.info( "feeAddMap : " + feeAddMap );
    		}
    		dataMap.put( "feeList", feeList );
    		dataMap.put( "feeAddList", feeAddList );
    	}
    	//return baseInfoRegistrationDAO.selectFeeRegOverCardLst( paramMap );
    	return dataMap;
    }
    public Map<String, Object> updateBefore(Map<String, Object> paramMap) throws Exception{
    	List<Map<String, Object>> changeList = new ArrayList<Map<String, Object>>();
		Map<String, Object> changeMap = new HashMap<String, Object>();
		int i=0;
		InetAddress local = InetAddress.getLocalHost();
		String workIP = local.getHostAddress();
		String groupSeq = "";
		
		changeList = historySearchDAO.selectChangeList(paramMap);
		if(changeList.size() > 0)
		{
			for(i=0; i<changeList.size(); i++)
			{
				changeMap = changeList.get( i );
				groupSeq = (String)historySearchDAO.selectChangeGrpSeq(paramMap);
				changeMap.put( "GRP_SEQ", groupSeq);
				changeMap.put( "WORK_IP", workIP );
				changeMap.put( "GUBUN_CL", "0");
				changeMap.put( "ID_CD", "2"); //MID
				changeMap.put( "ID", paramMap.get( "MER_ID" )); //MID
				if(changeMap.get("WHERE_INFO").equals("none")){
					changeMap.put("COL_VAL","(SELECT " + changeMap.get("COL_NM") +" FROM "+ changeMap.get("TABLE_NM") +" WHERE "+changeMap.get("ETC_NM")+" ='"+paramMap.get( "MID" )+"') ");
				}else if(changeMap.get("TABLE_NM").equals("TB_CO") && changeMap.get("WHERE_INFO").equals("none")){
					changeMap.put("COL_VAL","(SELECT " + changeMap.get("COL_NM") +" FROM "+ changeMap.get("TABLE_NM") +" "+changeMap.get("WHERE_INFO")+" AND "+changeMap.get("ETC_NM")+" ='"+paramMap.get( "MID" )+"') ");
				}
				changeMap.put( "WORKER", paramMap.get( "WORKER" ) == null ? null : paramMap.get( "WORKER" )); //MID
				
				log.info( "select 기본정보 변경 이력 : "+ ToStringBuilder.reflectionToString( changeMap  ) );
				
				historySearchDAO.insertChangeInfo(changeMap);
				log.info( "기본정보 변경 전 이력  insert success " );
			}
		}
		else
		{
			log.info( "히스토리 저장 대상 항목 조회 내역 없음" );
		}
		return changeMap;
    }
}

