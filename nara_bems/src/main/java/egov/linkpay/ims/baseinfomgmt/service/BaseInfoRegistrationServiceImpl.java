package egov.linkpay.ims.baseinfomgmt.service;

import java.math.BigDecimal;
import java.net.InetAddress;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.rmi.CORBA.Util;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.aspectj.weaver.Utils;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.BaseInfoRegistrationDAO;
import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;
import egov.linkpay.ims.businessmgmt.dao.NewContractMgmtDAO;
import egov.linkpay.ims.common.common.CommonUtils;

@Service("baseInfoRegistrationService")
public class BaseInfoRegistrationServiceImpl implements BaseInfoRegistrationService
{
	Logger log = Logger.getLogger(this.getClass());

    @Resource(name="baseInfoRegistrationDAO")
    private BaseInfoRegistrationDAO baseInfoRegistrationDAO;

    @Resource(name="historySearchDAO")
    private HistorySearchDAO historySearchDAO;

    @Resource(name="newContractMgmtDAO")
    private NewContractMgmtDAO newContractMgmtDAO;

    @Override
    public List<Map<String, String>> selectKindCd() throws Exception {
        return baseInfoRegistrationDAO.selectKindCd();
    }
    @Override
    public List<Map<String, String>> selectSCateList() throws Exception {
        return baseInfoRegistrationDAO.selectSCateList();
    }
    @Override
    public List<Map<String, String>> selectEmplList(Map<String, Object> paramMap) throws Exception {
        return baseInfoRegistrationDAO.selectEmplList(paramMap);
    }
    @Override
    public List<Map<String, String>> selectMallTypeCd() throws Exception {
        return baseInfoRegistrationDAO.selectMallTypeCd();
    }
    @Override
    public List<Map<String, String>> selectCodeCl(String codeCl) throws Exception {
        return baseInfoRegistrationDAO.selectCodeCl(codeCl);
    }
    @Override
    public List<Map<String, String>> selectCardList(Map<String,Object> paramMap) throws Exception {
        return baseInfoRegistrationDAO.selectCardList(paramMap);
    }
    @Override
    public List<Map<String, String>> selectCateList(String param) throws Exception {
        return baseInfoRegistrationDAO.selectCateList(param);
    }
    @Override
    public List<Map<String,Object>> selectBaseInfo(Map< String, Object > paramMap) throws Exception {
    	return baseInfoRegistrationDAO.selectBaseInfo( paramMap );
    }
    @Override
    public List<Map<String,Object>> selectBaseInfoAll(Map< String, Object > paramMap) throws Exception {
    	return baseInfoRegistrationDAO.selectBaseInfoAll( paramMap );
    }
    @Override
    public List<Map<String,Object>> selectApproList(Map< String, Object > paramMap) throws Exception {
    	List<Map<String,Object>> dataList = new ArrayList<Map<String,Object>>();
    	Map<String,Object> dataMap = new HashMap<>();
    	if(paramMap.get( "MER_SEARCH" ).equals( "0" ))//mid
       	{
    		dataList = baseInfoRegistrationDAO.selectApproList( paramMap );
    		log.info( "dataCnt : " + dataList.size() );
    		for (int i =0; i < dataList.size(); i ++ )
    		{
    			dataMap = dataList.get( i );
    			log.info( "selectApproList : " +dataMap );
    			String mid = "MID";
    			String statusNm = (String)dataMap.get( "STATUS_NM" );
    			String feeType = (String)dataMap.get( "FEE_TYPE_CD" );
    			String befFeeType = (String)dataMap.get( "BEFORE_FEE_TYPE" );
    			String pmNm = (String)dataMap.get( "PM_NM" );
    			String overCl = "";

    			statusNm = dataMap.get( "STATUS" ).equals( "1")?"완료":"";
    			dataMap.put( "STATUS_NM", statusNm );

    			feeType = feeType.equals( "2" )? "%" : "원";
    			dataMap.put( "FEE_TYPE", feeType );

    			befFeeType =befFeeType != null ? ( befFeeType.equals( "2" )? "%" : "원") : "";
    			dataMap.put( "BEFORE_FEE_TYPE", befFeeType );

    			if(dataMap.get("PM_CD").equals( "01" ))
    			{
    				if(dataMap.get( "CP_CD" ).equals( "99" ))
    					pmNm += "(해외)";
    				else
    					pmNm += "(국내)";
    			}
    			else if(dataMap.get("PM_CD").equals( "02" ))
    			{
    				if(dataMap.get( "FR_AMT" ).equals( "1" ) && dataMap.get( "FEE_TYPE_CD" ).equals( "3" ))
    					pmNm += "(1원~11600원)";
    				else if(dataMap.get( "FR_AMT" ).equals( "1" ) && dataMap.get( "FEE_TYPE_CD" ).equals( "2" ))
    					pmNm += "(전구간)";
    				else if(dataMap.get( "FR_AMT" ).equals( "1" ))
    					pmNm += "(11601원~)";
    			}
    			else if (dataMap.get("PM_CD").equals( "05" ))
    			{
    				if(dataMap.get( "CP_CD" ).equals( "CONTENTS" ))
    					pmNm += "(컨텐츠)";
    				else if(dataMap.get( "CP_CD" ).equals( "GOODS" ))
    					pmNm += "(실물)";
    			}
    			dataMap.put( "PM_NM", pmNm );
    			String strShowBefChgFee = "";
				String strShowAftChgFee = "";
				BigDecimal befFee = (BigDecimal)dataMap.get( "BEFORE_AVG_FEE" );
				BigDecimal aftFee = (BigDecimal)dataMap.get( "AFTER_AVG_FEE" );
				if(dataMap.get( "PM_CD" ).equals( "01" ))
				{
					strShowBefChgFee = befFee.toString() +" "+(String)dataMap.get( "FEE_TYPE" );
					//if("00".equals(strOverCl)) strShowBefChgFee += " (포인트 "+beforePointFee+"%)";
					strShowAftChgFee = aftFee.toString() +" "+(String)dataMap.get( "FEE_TYPE" );
					//if("00".equals(strOverCl)) strShowBefChgFee += " (포인트 "+beforePointFee+"%)";
				}
				else
				{
					strShowBefChgFee = befFee.toString() +" "+(String)dataMap.get( "FEE_TYPE" );
					strShowAftChgFee = aftFee.toString() +" "+(String)dataMap.get( "FEE_TYPE" );
				}
				dataMap.put( "BEFORE_AVG_FEE", strShowBefChgFee );
				dataMap.put( "AFTER_AVG_FEE", strShowAftChgFee );
    		}
       	}
       	else if(paramMap.get( "MER_SEARCH" ).equals( "2" ))//vid
       	{
       		dataList = baseInfoRegistrationDAO.selectVidApproList( paramMap );
       		log.info( "dataCnt : " + dataList.size() );
    		for (int i =0; i < dataList.size(); i ++ )
    		{
    			dataMap = dataList.get( i );
    			log.info( "selectApproList : " +dataMap );
    			String vid = "VID";
    			String statusNm = (String)dataMap.get( "STATUS_NM" );
    			String feeType = (String)dataMap.get( "FEE_TYPE_CD" );
    			String befFeeType = (String)dataMap.get( "BEFORE_FEE_TYPE" );
    			String pmNm = (String)dataMap.get( "PM_NM" );
     			statusNm = dataMap.get( "STATUS" ).equals( "1")?"완료":"";
    			dataMap.put( "STATUS_NM", statusNm );

    			feeType = feeType.equals( "2" )? "%" : "원";
    			dataMap.put( "FEE_TYPE", feeType );

    			befFeeType = befFeeType.equals( "2" )? "%" : "원";
    			dataMap.put( "BEFORE_FEE_TYPE", befFeeType );

    			if(dataMap.get("PM_CD").equals( "01" ))
    			{
    				if(dataMap.get( "CP_CD" ).equals( "99" ))
    					pmNm += "(해외)";
    				else
    					pmNm += "(국내)";
    			}
    			else if(dataMap.get("PM_CD").equals( "02" ))
    			{
    				if(dataMap.get( "FR_AMT" ).equals( "1" ) && dataMap.get( "FEE_TYPE_CD" ).equals( "3" ))
    					pmNm += "(1원~11600원)";
    				else if(dataMap.get( "FR_AMT" ).equals( "1" ) && dataMap.get( "FEE_TYPE_CD" ).equals( "2" ))
    					pmNm += "(전구간)";
    				else if(dataMap.get( "FR_AMT" ).equals( "1" ))
    					pmNm += "(11601원~)";
    			}
    			else if (dataMap.get("PM_CD").equals( "05" ))
    			{
    				if(dataMap.get( "CP_CD" ).equals( "CONTENTS" ))
    					pmNm += "(컨텐츠)";
    				else if(dataMap.get( "CP_CD" ).equals( "GOODS" ))
    					pmNm += "(실물)";
    			}
    			dataMap.put( "PM_NM", pmNm );
    			String strShowBefChgFee = "";
				String strShowAftChgFee = "";
				BigDecimal befFee = (BigDecimal)dataMap.get( "BEFORE_AVG_FEE" );
				BigDecimal aftFee = (BigDecimal)dataMap.get( "AFTER_AVG_FEE" );
				if(dataMap.get( "PM_CD" ).equals( "01" ))
				{
					strShowBefChgFee = befFee.toString() +" "+(String)dataMap.get( "FEE_TYPE" ) + " (건당 "+dataMap.get( "BEFORE_ETC_FEE" ) +"원)";
					strShowAftChgFee = aftFee.toString() +" "+(String)dataMap.get( "FEE_TYPE" ) + " (건당 "+dataMap.get( "AFTER_ETC_FEE" ) +"원)";
				}
				else
				{
					strShowBefChgFee = befFee.toString()+" "+(String)dataMap.get( "FEE_TYPE" );
					strShowAftChgFee = aftFee.toString() +" "+(String)dataMap.get( "FEE_TYPE" );
				}
				dataMap.put( "BEFORE_AVG_FEE", strShowBefChgFee );
				dataMap.put( "AFTER_AVG_FEE", strShowAftChgFee );

    		}
       	}
    	return dataList;
    }
    @Override
    public int selectApproListTotal(Map< String, Object > paramMap) throws Exception {
    	int totCnt = 0;
    	if(paramMap.get( "MER_SEARCH" ).equals( "0" ))  //mid
    	{
    		totCnt = (Integer)baseInfoRegistrationDAO.selectApproListTotal( paramMap );
    	}
    	else if(paramMap.get( "MER_SEARCH" ).equals( "2" ))  //vid
    	{
    		totCnt = (Integer)baseInfoRegistrationDAO.selectApproListTotal( paramMap );
    	}
    	return totCnt;
    }
    @Override
    public List<Map<String,Object>> selectCardPay(Map< String, Object > paramMap) throws Exception {
    	return baseInfoRegistrationDAO.selectCardPay( paramMap );
    }
    @Override
    public List<Map<String,Object>> selectGidInfo(String param) throws Exception {
    	return baseInfoRegistrationDAO.selectGidInfo( param );
    }
    @Override
    public List<Map<String,Object>> selectVidInfo(String param) throws Exception {
    	return baseInfoRegistrationDAO.selectVidInfo( param );
    }
    @Override
    public List<Map<String,Object>> selectVidFeeInfo(Map< String, Object > paramMap) throws Exception {
    	return baseInfoRegistrationDAO.selectVidFeeInfo( paramMap );
    }
    public Integer dupIdChk(Map< String, Object > paramMap) throws Exception {
    	Object dupCnt = baseInfoRegistrationDAO.dupIdChk( paramMap );
    	int dupMidCnt = Integer.parseInt( dupCnt.toString() );
    	return dupMidCnt;
    }
    public List<Map<String, String>> selectGidList() throws Exception{
    	return baseInfoRegistrationDAO.selectGidList();
    }
    public List<Map<String, String>> selectVidList() throws Exception{
    	return baseInfoRegistrationDAO.selectVidList();
    }
    @Override
    public List<Map<String,Object>> selectCoNo(Map< String, Object > paramMap) throws Exception {
    	return baseInfoRegistrationDAO.selectCoNo( paramMap );
    }
    public String selectSettleCycleCode(Map<String, Object> paramMap) throws Exception {
    	String settleCycle="";
    	Object objCycle= baseInfoRegistrationDAO.selectSettleCycleCode( paramMap );

    	settleCycle = objCycle.toString();

    	return settleCycle;
    }
	@Override
    public void updateNormalInfo(Map< String, Object > paramMap) throws Exception {
		Map<String, Object> changeMap = new HashMap<String, Object>();

		String tableNm = "TB_MBS";
		paramMap.put( "TABLE_NM", tableNm );
		int cnt = 0;
		try
		{
			//UPDATE인지 INSERT 인지 체크
			cnt = (Integer)baseInfoRegistrationDAO.selectExistChk(paramMap);
			String[] aPmCd = {"01", "02", "03", "05", "11","12", "13"};//지불수단 - 01:신용카드, 02:계좌이체, 03:가상계좌, 05:휴대폰, 11:wechat
			String[] aSpmCd = {"01"}; //지불매체 - 01:온라인
			String[] aCpCd = {"01","02","03","04","06","07","08","12","25","26","27","28","29","38"};//카드사 - 01:비씨, 02:국민, 03:외환, 04:삼성, 06:신한, 07:현대, 08:롯데, 12:농협

			if(cnt > 0 )
			{
				log.info( "exist -> update " );
				changeMap =updateBefore(paramMap);

				//기본정보 update
				baseInfoRegistrationDAO.updateNormalInfo( paramMap );

				updateAfter(changeMap);
			}
			else
			{
				log.info( "not exist -> insert  " );
				//merchantKey 생성
		    	String merKey = CommonUtils.merchantSHA512HashKey();
		    	paramMap.put( "merKey", merKey );
		    	baseInfoRegistrationDAO.insertMerKey( paramMap );

		    	//기본정보 insert
		    	cnt = baseInfoRegistrationDAO.insertMidInfo( paramMap );
		    	for(int j = 0; j < aSpmCd.length; j++) {
	    			for(int k = 0; k < aCpCd.length; k++) {
				    	paramMap.put( "id", paramMap.get( "MID" ) );
				    	paramMap.put( "idCd", '1' );
		 				paramMap.put("pmCd", "01");
		 				paramMap.put("spmCd", aSpmCd[j]);
		 				paramMap.put("cpCd", aCpCd[k]);
		 				paramMap.put("feeTypeCd", "2");
		 				paramMap.put("fee", 0);
		 				paramMap.put("frAmt", 1);
		 				paramMap.put("status", "1");
	    			}
		    	}
		    	cnt = newContractMgmtDAO.insertFee( paramMap );

			}
		}
		catch(Exception e)
		{
			log.error( "Exception : ", e );
		}
    }
    @Override
    public void updateEtcInfo(Map< String, Object > paramMap) throws Exception {
    	Map<String, Object> changeMap = new HashMap<String, Object>();
    	String tableNm = "TB_MBS";
		paramMap.put( "TABLE_NM", tableNm );
		try
		{
			int cnt =0;
			//UPDATE인지 INSERT 인지 체크
			cnt = (Integer)baseInfoRegistrationDAO.selectExistChk(paramMap);

			if(cnt > 0 )
			{
				log.info( "exist -> update " );
				changeMap =updateBefore(paramMap);

				//기본정보 update
				baseInfoRegistrationDAO.updateEtcInfo( paramMap );

				updateAfter(changeMap);
			}
			else
			{
				log.info( "not exist -> insert  " );
		    	//update
				baseInfoRegistrationDAO.updateEtcInfo( paramMap );
			}
		}
		catch(Exception e)
		{
			log.error( "Exception : ", e );
		}
    }
    @Override
    public void updateSettleInfo(Map< String, Object > paramMap) throws Exception {
    	Map<String, Object> changeMap = new HashMap<String, Object>();
    	String tableNm = "TB_MBS";
		paramMap.put( "TABLE_NM", tableNm );
		try
		{
			int cnt =0;
			//UPDATE인지 INSERT 인지 체크
			cnt = (Integer)baseInfoRegistrationDAO.selectExistChk(paramMap);

			if(cnt > 0 )
			{
				log.info( "exist -> update " );
				changeMap =updateBefore(paramMap);

				//기본정보 update
				baseInfoRegistrationDAO.updateSettleInfo( paramMap );
				updateSettlmntService(paramMap);

				updateAfter(changeMap);
			}
			else
			{
				log.info( "not exist -> insert  " );
		    	//update
				baseInfoRegistrationDAO.updateSettleInfo( paramMap );
				updateSettlmntService(paramMap);
			}
		}
		catch(Exception e)
		{
			log.error( "Exception : ", e );
		}
    }
    @Override
    public void updatePayType(Map< String, Object > paramMap) throws Exception {
    	Map<String, Object> changeMap = new HashMap<String, Object>();
    	String tableNm = "TB_MBS";
		paramMap.put( "TABLE_NM", tableNm );
		try
		{	int cnt =0;
			//UPDATE인지 INSERT 인지 체크
			cnt = (Integer)baseInfoRegistrationDAO.selectExistChk(paramMap);

			if(cnt > 0 )
			{
				log.info( "exist -> update " );
				changeMap =updateBefore(paramMap);

				//기본정보 update
				//baseInfoRegistrationDAO.updatePayType( paramMap );
				updateMerchantSettlmnt(paramMap, "01");

				updateAfter(changeMap);
			}
			else
			{
				log.info( "not exist -> insert  " );
		    	//update
				updateMerchantSettlmnt(paramMap, "01");

			}
		}
		catch(Exception e)
		{
			log.error( "Exception : ", e );
		}
    }
    @Override
    public void insertBaseInfo(Map< String, Object > paramMap) throws Exception {
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	//resultMap = paramChk(paramMap);

    	//update 한 정보 insert
    	String tableNm = "TB_MBS";

    	Map<String, Object> changeMap = new HashMap<String, Object>();
		changeMap.put("ID_CD", "2");
		changeMap.put("ID", paramMap.get( "MER_ID" ));
		changeMap.put("TABLE_NM", tableNm);
		changeMap.put("MEMO", paramMap.get( "Memo" ));
		log.info( "기본정보 변경 후 이력  insert success " );

		// MID 중복체크 쿼리
		Object dupCnt = baseInfoRegistrationDAO.dupIdChk( paramMap );
    	int dupMidCnt = Integer.parseInt( dupCnt.toString() );

		int cnt = 0 ;
		if( dupMidCnt == 0 ) {
			String merKey = CommonUtils.merchantSHA512HashKey();
	    	paramMap.put( "merKey", merKey );
	    	baseInfoRegistrationDAO.insertMerKey( paramMap );

	    	cnt = baseInfoRegistrationDAO.insertBaseInfo( paramMap );
		}

    	if(cnt > 0)
    	{
    		cnt = updateMidInfo(paramMap, "all");
    	}
    	historySearchDAO.insertChangeHistory(changeMap);


    }
    @Override
    public void insertGidRegist(Map< String, Object > paramMap) throws Exception {

    	//update 한 정보 insert
    	String tableNm = "TB_GRP";

    	Map<String, Object> changeMap = new HashMap<String, Object>();
		changeMap.put("ID_CD", "3");
		changeMap.put("ID", paramMap.get( "MER_ID" ));
		changeMap.put("TABLE_NM", tableNm);
		changeMap.put("MEMO", paramMap.get( "Memo" ));
		historySearchDAO.insertChangeHistory(changeMap);
		log.info( "기본정보 변경 후 이력  insert success " );

    	baseInfoRegistrationDAO.insertGidRegist( paramMap );
    }
    @Override
    public void insertVidRegist(Map< String, Object > paramMap) throws Exception {

    	Map<String, Object> changeMap = new HashMap<String, Object>();
    	List<Map<String, Object>> changeList = new ArrayList<Map<String, Object>>();
    	ArrayList< String > list1 = new ArrayList<String>();
    	ArrayList< String > list2 = new ArrayList<String>();
    	String tableNm = "TB_VGRP";
		paramMap.put( "TABLE_NM", tableNm );
		paramMap.put( "MER_ID", paramMap.get( "VID" ) );
		try
		{
			int cnt =0;
			//UPDATE인지 INSERT 인지 체크
			cnt = (Integer)baseInfoRegistrationDAO.selectVidExistChk(paramMap);
			if(cnt > 0)
			{
				changeMap =updateBefore(paramMap);

				//기본정보 update
				baseInfoRegistrationDAO.updateVidInfo( paramMap );

				updateAfter(changeMap);
			}
			else
			{
		    	baseInfoRegistrationDAO.insertVidRegist( paramMap );
			}
			changeList = baseInfoRegistrationDAO.selectVidFeeInfo( paramMap );
			if(changeList.size() >0)
			{
				log.debug("===================update============");
				//map셋팅을 해야할듯...?

				//changeList.add(list1);
			}
			else
			{
				log.debug("===================insert============");
				//map셋팅을 해야할듯...?
				//changeList.add(paramMap);
			}
			cnt = updateVidStmtFeeInfo(list1, list2);
		}
		catch(Exception e)
		{
			log.error( "Exception : ", e );
		}
    }
    @Override
    public void updateGidInfo(Map< String, Object > paramMap) throws Exception {
    	Map<String, Object> changeMap = new HashMap<String, Object>();
    	String tableNm = "TB_GRP";
		paramMap.put( "TABLE_NM", tableNm );
		try
		{
				changeMap =updateBefore(paramMap);

				//기본정보 update
				baseInfoRegistrationDAO.updateGidInfo( paramMap );

				updateAfter(changeMap);
		}
		catch(Exception e)
		{
			log.error( "Exception : ", e );
		}
    }
    @Override
    public void updateVidInfo(Map< String, Object > paramMap) throws Exception {
    	Map<String, Object> changeMap = new HashMap<String, Object>();
    	String tableNm = "TB_VGRP";
		paramMap.put( "TABLE_NM", tableNm );
		try
		{
				changeMap =updateBefore(paramMap);

				//기본정보 update
				baseInfoRegistrationDAO.updateVidInfo( paramMap );

				updateAfter(changeMap);
		}
		catch(Exception e)
		{
			log.error( "Exception : ", e );
		}
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
    public void updateAfter(Map<String, Object> changeMap) throws Exception{
    	//update 한 정보 insert
		changeMap.put( "GUBUN_CL", "1");
		historySearchDAO.insertChangeInfo(changeMap);
    }
    @Override
    public Map<String,Object> merchantReg(Map< String, Object > paramMap) throws Exception {
    	Map< String, Object  > dataMap = new HashMap<String, Object>();
    	int cnt =0;
    	String resultCd = "";
    	if(paramMap.get( "MER_SEARCH" ).equals( "0" ))
    	{
    		paramMap.put("idCd", "2");

    		cnt = updateMerchantFeeReg( paramMap );
    		if(cnt > 0 ){
    			resultCd = "0000";
    		}else{
    			resultCd = "9999";
    		}
    	}
    	if(paramMap.get( "MER_SEARCH" ).equals( "2" ))
    	{
    		paramMap.put("idCd", "4");
    		cnt = updateVidMerchantFeeReg( paramMap );
    		if(cnt > 0 ){
    			resultCd = "0000";
    		}else{
    			resultCd = "9999";
    		}
    	}

    	dataMap.put( "resultCd", resultCd );

    	return dataMap ;
    }
    public int updateMidInfo(Map<String, Object > paramMap, String type ) throws Exception{
    	int cnt = 1;

		log.debug("***********type : "+type);
		try
		{
			if(type.equals("all"))
			{

				if(cnt > 0) cnt = updateSettlmntService(paramMap);
				if(cnt > 0) cnt = updateMerchantSettlmnt(paramMap, "01");
				//if(cnt > 0) cnt = updateMerchantSettlmntGlobal(paramMap, "01");
			}
			// 상점정보 수정 - 일반정보
			else if(type.equals("1")) {


			}
			// 상점정보 수정 - 기타정보
			else if(type.equals("2")) {
			}
			// 상점정보 수정 - 정산정보
			else if(type.equals("3")) {
			}
			// 상점정보 수정 - 결제수단별 정산정보, IPG
			else if(type.equals("4")) {
			}
			else if(type.equals("5")) {
			}

		} finally {
		}

    	return cnt;
    }
    public int updateSettlmntService(Map<String, Object > paramMap) throws SQLException, Exception{
    	int cnt = 0;
    	int todayInsertCnt = 0;
    	Map<String, Object > settMap = new HashMap<String, Object >();
    	List<Map<String, String >> dataList = new ArrayList<Map<String, String >>();

    	String codeCl = "0080";

    	dataList = baseInfoRegistrationDAO.selectCodeCl(codeCl);
    	for(int i=0; i<dataList.size(); i++)
    	{
    		log.info( "paramMap : " + paramMap );
    		String settPmCd = dataList.get( i ).get( "CODE1" );
    		String selSettPm = (String)paramMap.get( "settlSvc"+ settPmCd);
    		String oldSettPm = (String)paramMap.get( "oldSettlSvc"+ settPmCd); //글로벌
    		if(selSettPm == null)
    		{
    			selSettPm = "00";
    		}
    		settMap.put( "mid", paramMap.get("MID") );
    		settMap.put( "idCd", "1" );
    		settMap.put( "serviceCl", settPmCd );
    		settMap.put( "pmCd", "00"  );
    		settMap.put( "serviceVal",  selSettPm);
    		settMap.put( "worker", paramMap.get("WORKER") );

    		if(selSettPm != null && selSettPm != "")
    		{
    			if(oldSettPm != null && oldSettPm != "")
    			{
    				if(selSettPm.equals( oldSettPm ))
    				{
    					todayInsertCnt = (Integer)baseInfoRegistrationDAO.selectTodaySettPmInfo(settMap);
    					if(todayInsertCnt >0)
    					{
    						cnt = (Integer)baseInfoRegistrationDAO.updateTodaySettInfo(settMap);
    						cnt = 1;
    					}
    					else
    					{
    						cnt = (Integer)baseInfoRegistrationDAO.updateSettlmntPm(settMap);
    						if(cnt > 0)
    						{
    							cnt = (Integer)baseInfoRegistrationDAO.insertSettlmntPm(settMap);
    							return cnt;
    						}
    					}
    				}
    				else
    				{
    					cnt = 1;
    				}
    			}
    			else
    			{
    				//신규입력
    				cnt = (Integer)baseInfoRegistrationDAO.insertSettlmntPm(settMap);
    				return cnt;
    			}
    		}
    	}

    	return cnt;
    }
    //상점정보 수정 - 결제매체별 정산정보
    public int updateMerchantSettlmnt(Map<String, Object > paramMap, String spmCd) throws SQLException, Exception{
    	int cnt = 1;
    	Map<String,Object> typeMap = new HashMap<String, Object>();

    	typeMap = ( Map< String, Object > ) paramMap.get( "paramMap" );
    	String[] strCardCd = {"01","02","03","04","06","07","08","12","25","26","27","28","29","38"};
		//String[] strPmCd  = {"01","02","03","05"};
    	String[] strPmCd  = {"01"};
		String[] strCPIDLst = {"02", "05"};

		ArrayList<Map<String, Object >> aLst1 = new ArrayList<Map<String, Object >>();
		ArrayList<Map<String, Object >> aLst2 = new ArrayList<Map<String, Object >>();
		ArrayList<Map<String, Object >> aLst3 = new ArrayList<Map<String, Object >>();
		ArrayList<Map<String, Object >> aLst4 = new ArrayList<Map<String, Object >>();
		Map<String, Object > map = new HashMap<String, Object>();
		map.put( "mid", paramMap.get( "MER_ID" ) );
		// 카드 사용여부
    	String strCardUse = "";
    	strCardUse    += (String)paramMap.get("useMJCard_0101") == null ? "01:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0102") == null ? "02:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0103") == null ? "03:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0104") == null ? "04:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0106") == null ? "06:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0107") == null ? "07:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0108") == null ? "08:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0112") == null ? "12:" : ""; // 나라

    	if(strCardUse.length() > 0) strCardUse = strCardUse.substring(0, strCardUse.length()-1);

    	String strCardBlock = "";
    	strCardBlock    += (String)paramMap.get("useMICard_0111") == null ? "" : "11:";
    	//strCardBlock    += (String)paramMap.get("useMICard_0112") == null ? "" : "12:";// 나라
    	strCardBlock    += (String)paramMap.get("useMICard_0113") == null ? "" : "13:";
    	strCardBlock    += (String)paramMap.get("useMICard_0114") == null ? "" : "14:";
    	strCardBlock    += (String)paramMap.get("useMICard_0115") == null ? "" : "15:";
    	strCardBlock    += (String)paramMap.get("useMICard_0116") == null ? "" : "16:";
    	strCardBlock    += (String)paramMap.get("useMICard_0121") == null ? "" : "21:";
    	strCardBlock    += (String)paramMap.get("useMICard_0122") == null ? "" : "22:";
    	strCardBlock    += (String)paramMap.get("useMICard_0123") == null ? "" : "23:";
    	strCardBlock    += (String)paramMap.get("useMICard_0124") == null ? "" : "24:";
    	strCardBlock    += (String)paramMap.get("useMICard_0125") == null ? "" : "25:";
    	strCardBlock    += (String)paramMap.get("useMICard_0126") == null ? "" : "26:";
    	strCardBlock    += (String)paramMap.get("useMICard_0127") == null ? "" : "27:";
    	strCardBlock    += (String)paramMap.get("useMICard_0128") == null ? "" : "28:";
    	strCardBlock    += (String)paramMap.get("useMICard_0129") == null ? "" : "29:";
    	strCardBlock    += (String)paramMap.get("useMICard_0131") == null ? "" : "31:";
    	strCardBlock    += (String)paramMap.get("useMICard_0132") == null ? "" : "32:";
    	strCardBlock    += (String)paramMap.get("useMICard_0133") == null ? "" : "33:";
    	strCardBlock    += (String)paramMap.get("useMICard_0134") == null ? "" : "34:";
    	strCardBlock    += (String)paramMap.get("useMICard_0135") == null ? "" : "35:";
    	strCardBlock    += (String)paramMap.get("useMICard_0136") == null ? "" : "36:";
    	strCardBlock    += (String)paramMap.get("useMICard_0137") == null ? "" : "37:";
    	strCardBlock    += (String)paramMap.get("useMICard_0138") == null ? "" : "38:";

    	if(strCardBlock.length() > 0) strCardBlock = strCardBlock.substring(0, strCardBlock.length()-1);


    	String strSMCardUse = "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0301") == null ? "01:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0302") == null ? "02:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0303") == null ? "03:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0304") == null ? "04:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0306") == null ? "06:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0307") == null ? "07:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0308") == null ? "08:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0312") == null ? "12:" : "";// 나라

    	if(strSMCardUse.length() > 0) strSMCardUse = strSMCardUse.substring(0, strSMCardUse.length()-1);

    	String strSMCardBlock = "";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0311") == null ? "" : "11:";
    	//strSMCardBlock    += (String)paramMap.get("useMICard_0312") == null ? "" : "12:";// 나라
    	strSMCardBlock    += (String)paramMap.get("useMICard_0313") == null ? "" : "13:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0314") == null ? "" : "14:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0315") == null ? "" : "15:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0316") == null ? "" : "16:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0321") == null ? "" : "21:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0322") == null ? "" : "22:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0323") == null ? "" : "23:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0324") == null ? "" : "24:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0325") == null ? "" : "25:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0326") == null ? "" : "26:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0327") == null ? "" : "27:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0328") == null ? "" : "28:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0329") == null ? "" : "29:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0331") == null ? "" : "31:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0332") == null ? "" : "32:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0333") == null ? "" : "33:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0334") == null ? "" : "34:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0335") == null ? "" : "35:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0336") == null ? "" : "36:";

    	if(strSMCardBlock.length() > 0) strSMCardBlock = strSMCardBlock.substring(0, strSMCardBlock.length()-1);


    	String strBillCardUse = "";

    	strBillCardUse    += (String)paramMap.get("useMJCard_0501") == null ? "01:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0502") == null ? "02:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0503") == null ? "03:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0504") == null ? "04:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0506") == null ? "06:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0507") == null ? "07:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0508") == null ? "08:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0512") == null ? "12:" : "";// (전화주문결제 추가)
    	if(strBillCardUse.length() > 0) strBillCardUse = strBillCardUse.substring(0, strBillCardUse.length()-1);

    	String strBillCardBlock = "";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0511") == null ? "" : "11:";
    	//strBillCardBlock    += (String)paramMap.get("useMICard_0312") == null ? "" : "12:";// 나라
    	strBillCardBlock    += (String)paramMap.get("useMICard_0513") == null ? "" : "13:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0514") == null ? "" : "14:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0515") == null ? "" : "15:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0516") == null ? "" : "16:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0521") == null ? "" : "21:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0522") == null ? "" : "22:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0523") == null ? "" : "23:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0524") == null ? "" : "24:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0525") == null ? "" : "25:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0526") == null ? "" : "26:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0527") == null ? "" : "27:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0528") == null ? "" : "28:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0529") == null ? "" : "29:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0531") == null ? "" : "31:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0532") == null ? "" : "32:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0533") == null ? "" : "33:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0534") == null ? "" : "34:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0535") == null ? "" : "35:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0536") == null ? "" : "36:";

    	if(strBillCardBlock.length() > 0) strBillCardBlock = strBillCardBlock.substring(0, strBillCardBlock.length()-1);
		//신용카드 일반
		for(int i = 0; i < strCardCd.length; i++)
		{
			String strMbsNo = (String)paramMap.get("selMbsNo_01"+spmCd+strCardCd[i])==null?"":(String)paramMap.get("selMbsNo_01"+spmCd+strCardCd[i]);
			String oldMbsNo = (String)paramMap.get("mbsNo_01"+spmCd+strCardCd[i]+"_old")==null?"":(String)paramMap.get("mbsNo_01"+spmCd+strCardCd[i]+"_old");
			String strTerNo = (String)paramMap.get("selTermNo_01"+spmCd+strCardCd[i])==null?"":(String)paramMap.get("selTermNo_01"+spmCd+strCardCd[i]);
			String oldTerNo = (String)paramMap.get("termNo_01"+spmCd+strCardCd[i]+"_old")==null?"":(String)paramMap.get("termNo_01"+spmCd+strCardCd[i]+"_old");

			log.debug("mbsNo_01"+spmCd+strCardCd[i]+":strMbsNo===>"+ strMbsNo +" : oldMbsNo===>"+oldMbsNo);
			log.debug("termNo_01"+spmCd+strCardCd[i]+":strTerNo===>"+ strTerNo +" : oldTerNo===>"+oldTerNo);
			if(oldMbsNo.equals( "" ) && oldTerNo.equals("" ))
			{
				Map<String, Object > cardMap = new HashMap<String, Object>();
				cardMap.put("mid", paramMap.get("MID"));
				cardMap.put("coNo", paramMap.get( "CO_NO"));
				cardMap.put("cpCd", strCardCd[i]);
				cardMap.put("pmCd", "01");
				cardMap.put("spmCd", spmCd);

				Map<String, Object> noMap= (Map<String, Object>)baseInfoRegistrationDAO.selectTodayCardInfo(cardMap);
				if(noMap == null){

				}else{
					oldMbsNo = (String)noMap.get( "MBS_NO" )==""?"":(String)noMap.get( "MBS_NO" );
					oldTerNo = (String)noMap.get( "TERM_NO" )==""?"":(String)noMap.get( "TERM_NO" );

				}
			}

			if(!strMbsNo.equals(oldMbsNo) || !strTerNo.equals(oldTerNo))
			{
				log.debug("start update");
				Map<String, Object > dataMap = new HashMap<String, Object>();
				dataMap.put("mid", paramMap.get("MID"));
				dataMap.put("coNo", paramMap.get( "CO_NO"));
				dataMap.put("cpCd", strCardCd[i]);
				dataMap.put("pmCd", "01");
				dataMap.put("spmCd", spmCd);
				dataMap.put("mbsNo", strMbsNo.trim());
				dataMap.put("mbsNoOld", oldMbsNo);
				dataMap.put("termNo", strTerNo);
				dataMap.put("termNoOld", oldTerNo);
				dataMap.put("worker", paramMap.get("WORKER"));

				aLst1.add(dataMap);
			}
		}
		// 신용카드 무이자
		for(int i = 0; i < strCardCd.length; i++)
		{
			if("25".equals(strCardCd[i]) || "26".equals(strCardCd[i]) || "27".equals(strCardCd[i]) ||
					"28".equals(strCardCd[i]) || "29".equals(strCardCd[i]) || "38".equals(strCardCd[i]))	continue;

			String strMbsNo = (String)paramMap.get("selMbsNo_02"+spmCd+strCardCd[i])==null?"":(String)paramMap.get("selMbsNo_02"+spmCd+strCardCd[i]);
			String oldMbsNo = (String)paramMap.get("mbsNo_02"+spmCd+strCardCd[i]+"_old")==null?"":(String)paramMap.get("mbsNo_02"+spmCd+strCardCd[i]+"_old");
			String strTerNo = (String)paramMap.get("selTermNo_02"+spmCd+strCardCd[i])==null?"":(String)paramMap.get("selTermNo_02"+spmCd+strCardCd[i]);
			String oldTerNo = (String)paramMap.get("termNo_02"+spmCd+strCardCd[i]+"_old")==null?"":(String)paramMap.get("termNo_02"+spmCd+strCardCd[i]+"_old");
			log.debug("mbsNo_02"+spmCd+strCardCd[i]+":strMbsNo===>"+ strMbsNo +" : oldMbsNo===>"+oldMbsNo);
			log.debug("ter_no_02"+spmCd+strCardCd[i]+":strTerNo===>"+ strTerNo +" : oldTerNo===>"+oldTerNo);

			if(!strMbsNo.equals(oldMbsNo) || !strTerNo.equals(oldTerNo))
			{
				Map<String, Object > dataMap = new HashMap<String, Object>();
				dataMap.put("mid", paramMap.get("MID"));
				dataMap.put("coNo", paramMap.get( "CO_NO"));
				dataMap.put("cpCd", strCardCd[i]);
				dataMap.put("pmCd", "01");
				dataMap.put("spmCd", spmCd);
				dataMap.put("mbsNo", strMbsNo);
				dataMap.put("mbsNoOld", oldMbsNo);
				dataMap.put("termNo", strTerNo);
				dataMap.put("termNoOld", oldTerNo);
				dataMap.put("worker", paramMap.get("WORKER"));

				aLst1.add(dataMap);
			}
		}
		// 정산주기
		for(int i = 0; i < strPmCd.length; i++)
		{
			//String strCycle = (String)paramMap.get("stmtCycle_"+strPmCd[i]+spmCd)==null? "":(String)paramMap.get("stmtCycle_"+strPmCd[i]+spmCd);
			String strOldCycle = (String)paramMap.get("stmtCycle_"+strPmCd[i]+spmCd+"_old")==null? "":(String)paramMap.get("stmtCycle_"+strPmCd[i]+spmCd+"_old");
			String strCycle = (String)paramMap.get( "selCycle_0101" );
			log.debug("stmtCycle_"+strPmCd[i]+spmCd+":strCycle===>"+ strCycle +" : strOldCycle===>"+strOldCycle);

			String strType = (String)paramMap.get("stmtType_"+strPmCd[i]+spmCd)==null? "":(String)paramMap.get("stmtType_"+strPmCd[i]+spmCd);
			String oldType = (String)paramMap.get("stmtType_"+strPmCd[i]+spmCd+"_old")==null? "":(String)paramMap.get("stmtType_"+strPmCd[i]+spmCd+"_old");

			if("07".equals(strPmCd[i])){
				map.put("oldStmtCycle", strOldCycle);
				map.put("stmtCycle", strCycle);
			}

			log.debug("stmtType_"+strPmCd[i]+spmCd+":strType===>"+ strType +" : oldType===>"+oldType);

			if(strCycle != null) {
				if(!strCycle.equals(strOldCycle) || !strType.equals(oldType))
				{
					Map<String, Object > dataMap = new HashMap<String, Object>();
					dataMap.put("mid", paramMap.get("MID"));
					dataMap.put("pmCd", strPmCd[i]);
					dataMap.put("spmCd", spmCd);
					dataMap.put("useCl", paramMap.get("use_cl_"+strPmCd[i]+spmCd)==null?"":paramMap.get( "use_cl_"+strPmCd[i]+spmCd));
					dataMap.put("stmtCycle", strCycle);
					dataMap.put("stmtClCycle", strOldCycle);
					dataMap.put("stmtType", strType);
					dataMap.put("stmtTypeOld", oldType);
					dataMap.put("worker", paramMap.get("WORKER"));

					aLst2.add(dataMap);
				}
			}

		}

		// 사용전환
		for(int i = 0; i < strPmCd.length; i++)
		{
			String strUseCl = (String)typeMap.get("use_cl_"+strPmCd[i]+spmCd);
			String oldUseCl = (String)typeMap.get("use_cl_"+strPmCd[i]+spmCd+"_old");

			log.debug("use_cl_"+strPmCd[i]+spmCd+":strUseCl===>"+ strUseCl +" : oldUseCl===>"+oldUseCl);

			if(strUseCl != null)
			{
				if(!strUseCl.equals(oldUseCl))
				{
					Map<String, Object > dataMap = new HashMap<String, Object>();
					dataMap.put("mid", paramMap.get("MID"));
					dataMap.put("pmCd", strPmCd[i]);
					dataMap.put("spmCd", spmCd);
					dataMap.put("useCl", strUseCl);
					dataMap.put("useClOld", oldUseCl);
					dataMap.put("worker", paramMap.get("WORKER"));

					if("07".equals(strPmCd[i]))
					{
						map.put("oldUseCl", oldUseCl);
						map.put("useCl", strUseCl);
					}

					aLst3.add(dataMap);
				}
			}
		}

		// 계좌이체 / 휴대폰 CPID
		for(int i = 0; i < strCPIDLst.length; i++) {
			String strCPID = (String)map.get("CPID_"+strCPIDLst[i]+spmCd )==null?"":(String)map.get("CPID_"+strCPIDLst[i]+spmCd );
			String oldCPID = (String)map.get("CPID_"+strCPIDLst[i]+spmCd+"_OLD")==null?"":(String)map.get("CPID_"+strCPIDLst[i]+spmCd+"_OLD" );

			String strSubCPID = (String)map.get("SUBCPID_"+strCPIDLst[i]+spmCd)==null?"":(String)map.get("SUBCPID_"+strCPIDLst[i]+spmCd);
			String oldSubCPID = (String)map.get("SUBCPID_"+strCPIDLst[i]+spmCd+"_OLD")==null?"":(String)map.get("SUBCPID_"+strCPIDLst[i]+spmCd+"_OLD");

			log.debug("cpid_"+strCPIDLst[i]+spmCd+":strCPID===>"+ strCPID +" : oldCPID===>"+oldCPID);
			log.debug("sub cpid"+strCPIDLst[i]+spmCd+":strCPID===>"+ strSubCPID +" : oldCPID===>"+oldSubCPID);

			if(strCPID!=null || strSubCPID != null )
			{
				if(!strCPID.equals(oldCPID) || !strSubCPID.equals(oldSubCPID))
				{

					Map<String, Object > dataMap = new HashMap<String, Object>();

					dataMap.put("mid", paramMap.get("MID"));
					dataMap.put("coNo", paramMap.get("CO_NO"));

					if("02".equals(strCPIDLst[i]))
					{
						dataMap.put("cpCd", "KFTC");
					}
					else if("05".equals(strCPIDLst[i]))
					{
						dataMap.put("cpCd", "DNAL");
						dataMap.put("subId", strSubCPID);
						dataMap.put("subIdOld", oldSubCPID);
					}

					dataMap.put("pmCd", strCPIDLst[i]);
					dataMap.put("spmCd", spmCd);
					dataMap.put("mbsNo", strCPID);
					dataMap.put("mbsNoOld", oldCPID);
					dataMap.put("worker", paramMap.get( "WORKER" ));

					aLst4.add(dataMap);
				}
			}
		}

		// 카드 사용여부 && 할부개월제한
		Map<String, Object > cuMap = new HashMap<String,Object>();
		cuMap.put("mid", paramMap.get( "MID" ));
		cuMap.put("spmCd", spmCd);
		cuMap.put("cardUse", (strCardUse!=null?strCardUse:typeMap.get( "card_use" )));
		cuMap.put("cardBlock", (strCardBlock!=null?strCardBlock:typeMap.get( "card_block" )));
		//cuMap.put("cardUse", (typeMap.get("card_use")==null?"":typeMap.get( "card_use" )));
		//cuMap.put("cardBlock", (typeMap.get("card_block")==null?"":typeMap.get( "card_block" )));
		cuMap.put("limitInst", (paramMap.get("LMT_INSTMN")==null?"":paramMap.get("LMT_INSTMN")));
		cuMap.put("authFlg", (paramMap.get("selAuthFlg")==null?"":paramMap.get( "selAuthFlg" )));

		log.info( "type : " + paramMap );
		if(cnt > 0) cnt = baseInfoRegistrationDAO.updateCardInfo(cuMap);
		log.debug("*****cnt  updateCardUse:"+cnt);
		if(cnt > 0) cnt = updateCardMemberInfo(aLst1);
		log.debug("*****cnt  updateCardMemberInfo:"+cnt);
		if(cnt > 0) cnt = updateSettlmntCycleInfo(aLst2);
		log.debug("*****cnt  updateSettlmntCycleInfo:"+cnt);
		//if(cnt > 0) cnt = updateMerCPIDInfo(aLst4);
		log.debug("*****cnt  updateMerCPIDInfo:"+cnt);
		if(cnt > 0) cnt = updateMerSvcInfo(aLst3);
		log.debug("*****cnt  updateMerSvcInfo:"+cnt);
    	return cnt;
    }
    public int updateCardMemberInfo(ArrayList aLst) throws SQLException, Exception {
    	int cnt =1;

    	try
    	{
    		for(int i=0;i<aLst.size();i++)
    		{
    			Map< String, Object > dataMap = new HashMap<String, Object>();
    			dataMap = ( Map< String, Object > ) aLst.get( i );
    			log.info( "dataMap : " + dataMap );
    			// 현재 일자로 제휴사 정보 Setting 여부 판별
				int ct = (Integer)baseInfoRegistrationDAO.selectTodayCardInfoCnt(dataMap);

				if(cnt > 0 )
				{
					/* 과거 설정된 가맹점번호 */
					String mbsNoOld = (String)dataMap.get("mbsNoOld");

					if(mbsNoOld.length() > 0) {
						if(ct == 0) {
							log.debug("============ Nara fn_no_old, ter_no_old up_cl 0");
							dataMap.put("up_cl", "0");
							cnt = baseInfoRegistrationDAO.updateJoinInfo(dataMap);
							cnt = 1;
						}
					}

					/* 현재 설정된 가맹점번호 */
					if(dataMap.get( "mbsNo" ) == null || dataMap.get( "mbsNo" ).equals( "" ))
					{
						dataMap.put( "mbsNo" , "0");
					}
					if(!dataMap.get( "mbsNo" ).equals( "0" ))
					{
						if(ct > 0) {
							log.debug("============ Nara fn_no up_cl 1");
							dataMap.put("up_cl", "1");
							cnt = baseInfoRegistrationDAO.updateJoinInfo(dataMap);
							cnt = 1;
						} else {
							cnt = baseInfoRegistrationDAO.insertJoinInfo(dataMap);
						}
					}
				}
				else
				{
					break;
				}
    		}
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception : " ,e );
    	}
    	return cnt;
    }
    public int updateSettlmntCycleInfo(ArrayList aLst) throws SQLException, Exception {
    	int cnt =1;

    	try	{
			for(int i = 0; i < aLst.size(); i++) {
				Map<String,Object> dataMap = new HashMap<String, Object>();
				dataMap =(Map< String, Object >)aLst.get(i);
				log.info( "dataMap : " + dataMap );
				int ct = (Integer)baseInfoRegistrationDAO.selectStmtCycleCnt(dataMap);
				String stmtCycleCd = (String)baseInfoRegistrationDAO.selectStmtCycle(dataMap);
				String stmtCycle = (String)dataMap.get("stmtCycle")==null?"":(String)dataMap.get( "stmtCycle" );
				String stmtClCycle = (dataMap.get( "stmtClCycle" )==null || dataMap.get( "stmtClCycle" ) == "" ) ?"":dataMap.get( "stmtClCycle" ).toString();
				if(dataMap.get( "stmtType" ) == null || dataMap.get( "stmtType" ) == "")
				{
					dataMap.put( "stmtType", "0");
				}
				if(stmtClCycle.length() > 0)
				{
					dataMap.put("up_cl", "0");
					cnt = (Integer)baseInfoRegistrationDAO.updateStmtCycleInfo(dataMap);
					cnt = 1;
				}
				else if(!dataMap.get( "stmtCycle" ).equals( stmtCycleCd )){
					if(ct > 0) {
						dataMap.put("up_cl", "1");
						cnt = (Integer)baseInfoRegistrationDAO.updateStmtCycleInfo(dataMap);
						cnt = 1;
					} else {
						if(!stmtCycle.equals("0")) {
							cnt = (Integer)baseInfoRegistrationDAO.insertStmtCycleInfo(dataMap);
						}
					}
				}
				/*if(cnt > 0) {
					String stmtCycleOld = (String)dataMap.get("stmtCycleOld")==null?"":(String)dataMap.get( "stmtCycleOld" );
					String stmtCycle = (String)dataMap.get("stmtCycle")==null?"":(String)dataMap.get( "stmtCycle" );
					if(stmtCycleOld.length() > 0) {
						if(ct == 0) {
							dataMap.put("up_cl", "0");
							cnt = (Integer)baseInfoRegistrationDAO.updateStmtCycleInfo(dataMap);
						}
					}

					if(ct > 0) {
						dataMap.put("up_cl", "1");
						cnt = (Integer)baseInfoRegistrationDAO.updateStmtCycleInfo(dataMap);
					} else {
						if(!stmtCycle.equals("0")) {
							cnt = (Integer)baseInfoRegistrationDAO.insertStmtCycleInfo(dataMap);
						}
					}
				}*/
				else {
					break;
				}
			}
		}
		catch (Exception ex) {
			throw ex;
		}

    	return cnt;
    }
    //상점정보 수정 - 결제수단 사용여부
    public int updateMerSvcInfo(ArrayList aLst) throws SQLException, Exception {
    	int cnt = 1;

    	try
    	{
			for(int i = 0; i < aLst.size(); i++)
			{
				Map<String, Object > dataMap = new HashMap<String, Object>();
				dataMap = ( Map< String, Object > ) aLst.get( i );

				//String useClOld = (String)(dataMap.get( "useClOld" )==null?"":dataMap.get( "useClOld" ));
				String useClOld = (String)baseInfoRegistrationDAO.selectMerPmInfo(dataMap);
				if(useClOld==null)
				{
					log.info( "useClOld  not exist" );
					useClOld  = "";
				}
				else
				{
					log.info( "useClOld  exist" );
				}

				if(cnt>0)
				{
					if(useClOld.length() > 0 )
					{
						cnt = (Integer)baseInfoRegistrationDAO.updateMerPmInfo(dataMap);
					}
					else
					{
						cnt = (Integer)baseInfoRegistrationDAO.insertMerPmInfo(dataMap);
					}
				}
				else
				{
					break;
				}

				/*String useClOld = (String)baseInfoRegistrationDAO.selectMerPmInfo(dataMap);

				if(cnt > 0)
				{
					//String useClOld = (String)dataMap.get( "useClOld" );
					String useCl = (String)dataMap.get( "useCl" );
					if(useClOld != null)
					{
						if(useClOld.length() > 0)
						{
							cnt = (Integer)baseInfoRegistrationDAO.updateMerPmInfo(dataMap);
							cnt = 1;
						}
						else
						{
							if(useCl.equals("1"))
							{
								cnt = (Integer)baseInfoRegistrationDAO.insertMerPmInfo(dataMap);
							}
						}
					}
				}
				else {
					break;
				}*/
			}
		}
		catch (Exception ex) {
			throw ex;
		}

    	return cnt;
    }
    //AID 상점정보 수정 - 수수료
    public int updateVidStmtFeeInfo(ArrayList uLst,ArrayList iLst) throws SQLException, Exception {
    	int iRtn = 1;
    	List<Map< String, Object >> chMap = new ArrayList<Map<String,Object>>();
		try
		{
			for(int i = 0 ; i < uLst.size() ; i++)
			{
				Map<String, Object> map = ( Map< String, Object > ) uLst.get( i );
				map.put( "frDt", null );
				chMap = baseInfoRegistrationDAO.selectVidFeeInfo( map );
				ArrayList aLst = (ArrayList)chMap;

				Map< String, Object > res = ( Map< String, Object > ) aLst.get( 0 );
				map.put( "frDt", null );

				// 반려일 경우, History 등록
				if("2".equals(res.get("USE_ST_TYPE"))){
					map.put("status", "2");
					//iRtn = baseInfoRegistrationDAO.insertVidFee();
				}

				if(iRtn > 0) iRtn = baseInfoRegistrationDAO.updateVIDSettlmntFeeInfo(map);
			}

			for(int i = 0 ; i < iLst.size() ; i++) {
				Map<String, Object> map = ( Map< String, Object > ) iLst.get( i );
				map.put( "frDt", null );

				if(iRtn > 0) iRtn = baseInfoRegistrationDAO.insertVIDSettlmntFeeInfo(map);
			}


		} catch (Exception e ){
			log.error("error", e);
			iRtn = -1;
		} finally {
		}

		return iRtn;
    }
    public int updateMerchantFeeReg(Map<String,Object> paramMap) throws SQLException, Exception {
    	int iRtn = 0;
    	int getCnt = 0;
		String strFnLst = "";
		List lstRtn = null;
		try {

			// 처리 대기중인 fn_cd 리스트 가져오기
			lstRtn = baseInfoRegistrationDAO.selectMerchantFeeRegCnt(paramMap);
			ArrayList aLst = (ArrayList)lstRtn;

			// 승인(1) 처리
			if(aLst.size() > 0 && paramMap.get("status")!=( "2" ) ) {
				for(int i = 0; i < aLst.size(); i++) {
					String strFnCd = (String)aLst.get(i);

					if(i == 0) strFnLst += strFnCd;
					else strFnLst += ", " + strFnCd;
				}

				paramMap.put("fn_cd_lst", strFnLst);

				// 변경하려는 날짜이후에 이미 승인처리 된건 존재여부 확인
				getCnt = (Integer)baseInfoRegistrationDAO.selectAfterFeeRegCnt(paramMap);

				// 원하는 변경 적용 날짜 이후에 승인 된 수수료 변경 건이 없을 경우 승인 처리 성공, 아닐 경우 승인 처리 실패
				if(getCnt < 1) {

					// Update 건수
					/*if("02".equals(paramMap.get("pmCd"))){
						// 계좌이체: 전체 구간 or 비율제 적용했을 경우 fee_type 상관 없이 모두 update
						if("1".equals(paramMap.get("frAmt")) && "2".equals(paramMap.get("feeTypeCd"))){
							iRtn = baseInfoRegistrationDAO.updateMerchantBankFeeRegBefore1(paramMap);
						}else{
							iRtn = baseInfoRegistrationDAO.updateMerchantBankFeeRegBefore2(paramMap);
						}
					}else if("05".equals(paramMap.get("pmCd")) || "06".equals(paramMap.get("pmCd"))){
						iRtn = baseInfoRegistrationDAO.updateMerchantFeeRegBefore3(paramMap);
					}else{
						iRtn = baseInfoRegistrationDAO.updateMerchantFeeRegBefore(paramMap);
					}*/
					//카드만 먼저
					iRtn = baseInfoRegistrationDAO.updateMerchantFeeRegBefore(paramMap);

				} else {
					iRtn = -1;
				}

			} else {
				iRtn = 1;
			}

			if(iRtn > 0) {

				// 계좌 이체는 %와 건수 둘다 존재
				if(paramMap.get("pmCd").equals( "2" )) {
					paramMap.put("cp_cd_lst", "00");

					getCnt = (Integer)baseInfoRegistrationDAO.selectAfterFeeRegCnt(paramMap);
				}

				// 원하는 변경 적용 날짜 이후에 승인 된 수수료 변경 건이 없을 경우 승인 처리 성공, 아닐 경우 승인 처리 실패
				if(getCnt < 1) {
					iRtn = baseInfoRegistrationDAO.updateMerchantFeeReg(paramMap);
				} else {
					iRtn = -1;
				}
			}

		} finally {
		}
    	return iRtn;
    }
    public int updateVidMerchantFeeReg(Map<String,Object> paramMap) throws SQLException, Exception {
    	List lstRtn = baseInfoRegistrationDAO.selectVIDMerchantFeeRegCnt(paramMap);
		ArrayList aLst = (ArrayList)lstRtn;

		int iRtn = 0;
		int getCnt = 0;
		String strFnLst = "";

		try {
			if(aLst.size() > 0  && "1".equals(paramMap.get("status"))) {
				for(int i = 0; i < aLst.size(); i++) {
					String strFnCd = (String)aLst.get(i);

					if(i == 0) strFnLst += "'"+strFnCd+"'";
					else strFnLst += ", " + "'"+strFnCd+"'";
				}

				paramMap.put("cp_cd_lst", strFnLst);
				iRtn =  (Integer)baseInfoRegistrationDAO.selectAfterFeeRegCnt(paramMap);

				// 원하는 변경 적용 날짜 이후에 승인 된 수수료 변경 건이 없을 경우 승인 처리 성공, 아닐 경우 승인 처리 실패
				if(getCnt < 1) {
					// 승인인 경우, 기존거 종료. 반료인 경우, 처리 x
					iRtn =  baseInfoRegistrationDAO.updateVIDMerchantFeeRegBefore(paramMap);
				} else {
					iRtn = -1;
				}
			} else {
				iRtn = 1;
			}
			if(iRtn > 0) {
				iRtn =  baseInfoRegistrationDAO.updateVIDMerchantFeeReg(paramMap);
			}

		} catch (Exception e) {
			log.error("error", e);
			iRtn = -999;
		} finally {
		}

    	return iRtn;
    }
    //OVER CARD FEE LIST
    @Override
    public Map<String,Object> selectFeeRegOverCardLst(Map< String, Object > paramMap) throws Exception {
    	List<Map<String,Object>> dataList = new ArrayList<Map<String, Object>>();
    	List<Map<String,Object>> feeList = new ArrayList<Map<String, Object>>();
    	List<Map<String,Object>> feeAddList = new ArrayList<Map<String, Object>>();
    	Map<String, Object > dataMap = new HashMap<String, Object>();
    	Map<String, Object > cardMap = new HashMap<String, Object>();
    	Map<String, Object > feeMap = new HashMap<String, Object>();
    	Map<String, Object > feeAddMap = new HashMap<String, Object>();
    	String resultCd = "";

    	paramMap.put( "code2", "over" );
    	cardMap.put( "CODE1", "38" );
    	cardMap.put( "DESC1", "은련" );

    	dataList = baseInfoRegistrationDAO.selectCardCd(paramMap);
    	dataList .add( cardMap );

    	dataMap.put( "cardList", dataList );
    	if(paramMap.get( "id" ) != null)
    	{
    		paramMap.put("status" , "0");
    		paramMap.put("idCd" , "1");
    		feeList = baseInfoRegistrationDAO.selectFeeRegLst(paramMap);
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
  //OVER CARD FEE LIST
    @Override
    public Map<String,Object> selectFeeRegCardLst(Map< String, Object > paramMap) throws Exception {
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
    	if(paramMap.get( "id" ) != null)
    	{
    		paramMap.put("status" , "0");
    		paramMap.put("idCd" , "1");
    		feeList = baseInfoRegistrationDAO.selectFeeRegLst(paramMap);
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
    public Map<String,Object> parameterSetting(Map< String, Object > paramMap) throws Exception {
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	String resultCd = "";

    	String strSmsCl 			= paramMap.get("PushFailedSMS") == null ? "0" : "1";
    	//정산 서비스
    	String strSelSettlSvc0005	  = (String)paramMap.get("selSettlSvc0005");
    	String strOldSelSettlSvc0005  = (String)paramMap.get("oldSettlSvc0005");

    	//정산 서비스
    	String strSelSettlSvc0001	  = (String)paramMap.get("selSettlSvc0001");
    	String strOldSelSettlSvc0001  = (String)paramMap.get("oldSettlSvc0001");

    	// 부분취소 추가
    	String strClPartCancel  = "";
    	strClPartCancel    += (String)paramMap.get("PartialCancelFunctionCredit") == null ? "0" : "1";
    	//strClPartCancel    += (String)paramMap.get("PartialCancel") == null ? "0" : "1";
    	//strClPartCancel    += (String)paramMap.get("ccPartVacct") == null ? "0" : "1";
    	strClPartCancel	+= "0";

    	// 카드 사용여부
    	String strCardUse = "";
    	strCardUse    += (String)paramMap.get("useMJCard_0101") == null ? "01:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0102") == null ? "02:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0103") == null ? "03:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0104") == null ? "04:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0106") == null ? "06:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0107") == null ? "07:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0108") == null ? "08:" : "";
    	strCardUse    += (String)paramMap.get("useMJCard_0112") == null ? "12:" : ""; // 나라

    	if(strCardUse.length() > 0) strCardUse = strCardUse.substring(0, strCardUse.length()-1);

    	String strCardBlock = "";
    	strCardBlock    += (String)paramMap.get("useMICard_0111") == null ? "" : "11:";
    	//strCardBlock    += (String)paramMap.get("useMICard_0112") == null ? "" : "12:";// 나라
    	strCardBlock    += (String)paramMap.get("useMICard_0113") == null ? "" : "13:";
    	strCardBlock    += (String)paramMap.get("useMICard_0114") == null ? "" : "14:";
    	strCardBlock    += (String)paramMap.get("useMICard_0115") == null ? "" : "15:";
    	strCardBlock    += (String)paramMap.get("useMICard_0116") == null ? "" : "16:";
    	strCardBlock    += (String)paramMap.get("useMICard_0121") == null ? "" : "21:";
    	strCardBlock    += (String)paramMap.get("useMICard_0122") == null ? "" : "22:";
    	strCardBlock    += (String)paramMap.get("useMICard_0123") == null ? "" : "23:";
    	strCardBlock    += (String)paramMap.get("useMICard_0124") == null ? "" : "24:";
    	strCardBlock    += (String)paramMap.get("useMICard_0125") == null ? "" : "25:";
    	strCardBlock    += (String)paramMap.get("useMICard_0126") == null ? "" : "26:";
    	strCardBlock    += (String)paramMap.get("useMICard_0127") == null ? "" : "27:";
    	strCardBlock    += (String)paramMap.get("useMICard_0128") == null ? "" : "28:";
    	strCardBlock    += (String)paramMap.get("useMICard_0129") == null ? "" : "29:";
    	strCardBlock    += (String)paramMap.get("useMICard_0131") == null ? "" : "31:";
    	strCardBlock    += (String)paramMap.get("useMICard_0132") == null ? "" : "32:";
    	strCardBlock    += (String)paramMap.get("useMICard_0133") == null ? "" : "33:";
    	strCardBlock    += (String)paramMap.get("useMICard_0134") == null ? "" : "34:";
    	strCardBlock    += (String)paramMap.get("useMICard_0135") == null ? "" : "35:";
    	strCardBlock    += (String)paramMap.get("useMICard_0136") == null ? "" : "36:";
    	strCardBlock    += (String)paramMap.get("useMICard_0137") == null ? "" : "37:";
    	strCardBlock    += (String)paramMap.get("useMICard_0138") == null ? "" : "38:";

    	if(strCardBlock.length() > 0) strCardBlock = strCardBlock.substring(0, strCardBlock.length()-1);


    	String strSMCardUse = "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0301") == null ? "01:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0302") == null ? "02:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0303") == null ? "03:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0304") == null ? "04:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0306") == null ? "06:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0307") == null ? "07:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0308") == null ? "08:" : "";
    	strSMCardUse    += (String)paramMap.get("useMJCard_0312") == null ? "12:" : "";// 나라

    	if(strSMCardUse.length() > 0) strSMCardUse = strSMCardUse.substring(0, strSMCardUse.length()-1);

    	String strSMCardBlock = "";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0311") == null ? "" : "11:";
    	//strSMCardBlock    += (String)paramMap.get("useMICard_0312") == null ? "" : "12:";// 나라
    	strSMCardBlock    += (String)paramMap.get("useMICard_0313") == null ? "" : "13:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0314") == null ? "" : "14:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0315") == null ? "" : "15:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0316") == null ? "" : "16:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0321") == null ? "" : "21:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0322") == null ? "" : "22:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0323") == null ? "" : "23:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0324") == null ? "" : "24:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0325") == null ? "" : "25:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0326") == null ? "" : "26:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0327") == null ? "" : "27:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0328") == null ? "" : "28:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0329") == null ? "" : "29:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0331") == null ? "" : "31:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0332") == null ? "" : "32:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0333") == null ? "" : "33:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0334") == null ? "" : "34:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0335") == null ? "" : "35:";
    	strSMCardBlock    += (String)paramMap.get("useMICard_0336") == null ? "" : "36:";

    	if(strSMCardBlock.length() > 0) strSMCardBlock = strSMCardBlock.substring(0, strSMCardBlock.length()-1);


    	String strBillCardUse = "";

    	strBillCardUse    += (String)paramMap.get("useMJCard_0501") == null ? "01:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0502") == null ? "02:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0503") == null ? "03:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0504") == null ? "04:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0506") == null ? "06:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0507") == null ? "07:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0508") == null ? "08:" : "";
    	strBillCardUse    += (String)paramMap.get("useMJCard_0512") == null ? "12:" : "";// (전화주문결제 추가)
    	if(strBillCardUse.length() > 0) strBillCardUse = strBillCardUse.substring(0, strBillCardUse.length()-1);

    	String strBillCardBlock = "";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0511") == null ? "" : "11:";
    	//strBillCardBlock    += (String)paramMap.get("useMICard_0312") == null ? "" : "12:";// 나라
    	strBillCardBlock    += (String)paramMap.get("useMICard_0513") == null ? "" : "13:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0514") == null ? "" : "14:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0515") == null ? "" : "15:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0516") == null ? "" : "16:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0521") == null ? "" : "21:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0522") == null ? "" : "22:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0523") == null ? "" : "23:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0524") == null ? "" : "24:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0525") == null ? "" : "25:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0526") == null ? "" : "26:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0527") == null ? "" : "27:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0528") == null ? "" : "28:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0529") == null ? "" : "29:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0531") == null ? "" : "31:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0532") == null ? "" : "32:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0533") == null ? "" : "33:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0534") == null ? "" : "34:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0535") == null ? "" : "35:";
    	strBillCardBlock    += (String)paramMap.get("useMICard_0536") == null ? "" : "36:";

    	if(strBillCardBlock.length() > 0) strBillCardBlock = strBillCardBlock.substring(0, strBillCardBlock.length()-1);

    	// 할부개월사용제한
    	String strLimitInstmn01 = (String)paramMap.get("selCycle_0101");
    	String strLimitInstmn03 = (String)paramMap.get("selLimitInstmn03");
    	String strLimitInstmn05 = (String)paramMap.get("selLimitInstmn05");


    	dataMap.put("card_use", strCardUse);
    	dataMap.put("card_block", strCardBlock);
    	dataMap.put("limitInstmn", strLimitInstmn01);

    	dataMap.put("settl_pm_0005", strSelSettlSvc0005);
    	dataMap.put("settl_pm_old_0005", strOldSelSettlSvc0005);

    	dataMap.put("settl_pm_0001", strSelSettlSvc0001);
    	dataMap.put("settl_pm_old_0001", strOldSelSettlSvc0001);

    	String[] aPmCd = {"01", "02", "03", "05", "11","12", "13"};//지불수단 - 01:신용카드, 02:계좌이체, 03:가상계좌, 05:휴대폰, 11:wechat
    	String[] aSpmCd = {"01"}; //지불매체 - 01:온라인
    	String[] aCpCd = {"01","02","03","04","06","07","08","12","25","26","27","28","29","38"};//카드사 - 01:비씨, 02:국민, 03:외환, 04:삼성, 06:신한, 07:현대, 08:롯데, 12:농협
    	String[] aFnVB = {"003","004","005","007","011","020","023","027","031","032","034","037","039","045","071","081","088"};//가상계좌 은행
    	String[] aInst = {"01", "02"};//무이자 여부
    	String[] aAccntStep = {"01", "02"};//수수료
    	String[] aCPID = {"02", "05"};
    	String[] aGlobal = {"11", "12", "13"};

    	// 카드 가맹점 정보 (ex: fn_no_010101)
    	for(int i = 0; i < aInst.length; i++) {
    		for(int j = 0; j < aSpmCd.length; j++) {
    			for(int k = 0; k < aCpCd.length; k++) {

    				if("02".equals(aInst[i]) && 12 < Integer.parseInt(aCpCd[k]))	continue;

    				String pname1 = "selMbsNo_"+aInst[i]+aSpmCd[j]+aCpCd[k];
    				String mname1 = "mbsNo_"+aInst[i]+aSpmCd[j]+aCpCd[k];
    				String pname2 = "oldMbsNo_"+aInst[i]+aSpmCd[j]+aCpCd[k];
    				String mname2 = "mbsNo_"+aInst[i]+aSpmCd[j]+aCpCd[k]+"_old";
    				String pname3 = "selTermNo_"+aInst[i]+aSpmCd[j]+aCpCd[k];
    				String mname3 = "termNo_"+aInst[i]+aSpmCd[j]+aCpCd[k];
    				String pname4 = "oldTermNo_"+aInst[i]+aSpmCd[j]+aCpCd[k];
    				String mname4 = "termNo_"+aInst[i]+aSpmCd[j]+aCpCd[k]+"_old";


    				dataMap.put(mname1, (String)paramMap.get(pname1));
    				dataMap.put(mname2, (String)paramMap.get(pname2));
    				dataMap.put(mname3, (String)paramMap.get(pname3));
    				dataMap.put(mname4, (String)paramMap.get(pname4));
    			}
    		}
    	}

	    // 정산주기 (ex: stmtCycle_0101)
	    for(int i = 0; i < aPmCd.length; i++) {
	    	for(int j = 0; j < aSpmCd.length; j++) {
	    		String pname1 = "selCycle_"+aPmCd[i]+aSpmCd[j];
	    		String mname1 = "stmtCycle_"+aPmCd[i]+aSpmCd[j];
	    		String pname2 = "oldCycle_"+aPmCd[i]+aSpmCd[j];
	    		String mname2 = "stmtCycle_"+aPmCd[i]+aSpmCd[j]+"_old";
	    		dataMap.put(mname1, (String)paramMap.get(pname1));
	    		dataMap.put(mname2, (String)paramMap.get(pname2));

	    		// 정산기준
	    		String pname3 = "selSettType_"+aPmCd[i]+aSpmCd[j];
	    		String mname3 = "stmtType_"+aPmCd[i]+aSpmCd[j];
	    		String pname4 = "oldSettType_"+aPmCd[i]+aSpmCd[j];
	    		String mname4 = "stmtType_"+aPmCd[i]+aSpmCd[j]+"_old";
	    		dataMap.put(mname3, (String)paramMap.get(pname3));
	    		dataMap.put(mname4, (String)paramMap.get(pname4));
	      	}
	    }



	    // 결제수단 사용여부 (ex: use_cl_0101)
	    for(int i = 0; i < aPmCd.length; i++) {
	    	for(int j = 0; j < aSpmCd.length; j++) {
	    		String pname1 = "selUseCl_"+aPmCd[i]+aSpmCd[j];
	    		String mname1 = "use_cl_"+aPmCd[i]+aSpmCd[j];
	    		String pname2 = "oldUseCl_"+aPmCd[i]+aSpmCd[j];
	    		String mname2 = "use_cl_"+aPmCd[i]+aSpmCd[j]+"_old";
	    		dataMap.put(mname1, (String)paramMap.get(pname1));
	    		dataMap.put(mname2, (String)paramMap.get(pname2));
	    	}
	    }
	    int iRtn = 0;

	 // 사업자 기본 수수료로 수수료 등록
	 ArrayList<Map<String,Object>> fLst = new ArrayList<Map<String,Object>>();

	 if("false".equals((String)paramMap.get("defaultCoFee"))) {
	 	for(int j = 0; j < aSpmCd.length; j++) {
	 		// 신용카드
	 		for(int k = 0; k < aCpCd.length; k++) {
	 			String strFee01 = (String)paramMap.get("chgFee_01"+aSpmCd[j]+aCpCd[k]);

	 			if(strFee01 == null || "".equals(strFee01)) continue;

	 				Map<String,Object> rmap01 = new HashMap<String,Object>();

	 				rmap01.put("id", paramMap.get( "MID" ));
	 				rmap01.put("idCd", "1");
	 				rmap01.put("pmCd", "01");
	 				rmap01.put("spmCd", aSpmCd[j]);
	 				rmap01.put("cpCd", aCpCd[k]);
	 				rmap01.put("frDt", "toDay");
	 				rmap01.put("feeTypeCd", "2");
	 				rmap01.put("fee", strFee01);
	 				rmap01.put("frAmt", 1);
	 				rmap01.put("status", "1");

	 				fLst.add(rmap01);
	 			}

	 		/*// 계좌이체
	 		for(int k = 0; k < aAccntStep.length; k++) {
	 			String strFee02 = (String)paramMap.get("chgFee_02"+aSpmCd[j]+aAccntStep[k]);

	 			if(strFee02 == null || "".equals(strFee02)) continue;

	 			Map<String,Object> rmap02 = new Map<String,Object>();

	 			rmap02.put("id", strMID);
	 			rmap02.put("id_cl", "1");
	 			rmap02.put("svc_cd", "02");
	 			rmap02.put("svc_prdt_cd", aSpmCd[j]);
	 			rmap02.put("fn_cd", "00");
	 			rmap02.put("fr_dt", "toDay");
	 			rmap02.put("fee", strFee02);

	 			if(k == 0) {
	 				rmap02.put("fee_type", "3");
	 				rmap02.put("fr_amt", 1);
	 			} else {
	 				rmap02.put("fee_type", "2");
	 				rmap02.put("fr_amt", 11601);
	 			}

	 			rmap02.put("status", "1");
	 			fLst.add(rmap02);
	       	}

	       // 가상계좌
	 		for(int k = 0; k < aFnVB.length; k++) {
	 			String strFee03 = (String)paramMap.get("chgFee_03"+aSpmCd[j]+aFnVB[k]);

	 			if(strFee03 == null || "".equals(strFee03)) continue;

	 			Map<String,Object> rmap03 = new Map<String,Object>();

	 			rmap03.put("id", strMID);
	 			rmap03.put("id_cl", "1");
	 			rmap03.put("svc_cd", "03");
	 			rmap03.put("svc_prdt_cd", aSpmCd[j]);
	 			rmap03.put("fn_cd", aFnVB[k]);
	 			rmap03.put("fr_dt", "toDay");
	 			rmap03.put("fee_type", "3");
	 			rmap03.put("fee", strFee03);
	 			rmap03.put("fr_amt", 1);
	 			rmap03.put("status", "1");

	 			fLst.add(rmap03);
	 		}

	       // 휴대폰
	       String strFee05 = (String)paramMap.get("chgFee_05"+aSpmCd[j]+"01");

	       if(strFee05 == null || "".equals(strFee05)) continue;

	       String strFeeType05 = (String)paramMap.get("chgFee_type_05"+aSpmCd[j]+"01");

	       Map<String,Object> rmap05 = new Map<String,Object>();

	       rmap05.put("id", strMID);
	       rmap05.put("id_cl", "1");
	       rmap05.put("svc_cd", "05");
	       rmap05.put("svc_prdt_cd", aSpmCd[j]);
	       rmap05.put("fn_cd", "00");
	       rmap05.put("fr_dt", "toDay");
	       rmap05.put("fee", strFee05);
	       rmap05.put("fee_type", strFeeType05);
	       rmap05.put("fr_amt", 1);
	       rmap05.put("status", "1");

	       fLst.add(rmap05);

	       // 휴대폰빌링
	       String strFee06 = (String)paramMap.get("chgFee_06"+aSpmCd[j]+"01");

	       if(strFee06 == null || "".equals(strFee06)) continue;

	       String strFeeType06 = (String)paramMap.get("chgFee_type_06"+aSpmCd[j]+"01");

	       Map<String,Object> rmap06 = new Map<String,Object>();

	       rmap06.put("id", strMID);
	       rmap06.put("id_cl", "1");
	       rmap06.put("svc_cd", "06");
	       rmap06.put("svc_prdt_cd", aSpmCd[j]);
	       rmap06.put("fn_cd", "00");
	       rmap06.put("fr_dt", "toDay");
	       rmap06.put("fee", strFee06);
	       rmap06.put("fee_type", strFeeType06);
	       rmap06.put("fr_amt", 1);
	       rmap06.put("status", "1");

	       fLst.add(rmap06);*/

//	 		for(int i=0; i<fLst.size(); i++){
//	 			iRtn = baseInfoRegistrationDAO.insertStmtFeeInfo( paramMap );//mi.updateSettlmntFeeInfo(fLst);
//
//	 		}
	     }
	 	int cnt = 0 ;
    	for(int i=0;i<fLst.size(); i++){
    		Map<String, Object> listMap = fLst.get( i );
    		cnt = newContractMgmtDAO.selectFee(listMap);
    		if(cnt == 0 )
    		{
    			cnt = baseInfoRegistrationDAO.insertVIDSettlmntFeeInfo( listMap );//mi.updateSettlmntFeeInfo(fLst);
    		}
    	}

	   }
    	return dataMap;
    }
    public Map<String, Object> selectMbsNo(Map<String, Object> paramMap) throws Exception {
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	log.info( "paramMap : " + paramMap );
    	String cpCd = (String)paramMap.get( "cpCd" );

    	if(paramMap.get( "cpCd" ) == "")
    	{
    		paramMap.put( "cpCd", "0" );
    	}

    	return dataMap;
    }
}
