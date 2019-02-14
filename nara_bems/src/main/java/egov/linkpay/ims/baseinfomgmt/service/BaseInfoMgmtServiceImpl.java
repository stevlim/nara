package egov.linkpay.ims.baseinfomgmt.service;

import java.math.BigDecimal;
import java.sql.SQLException;
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
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.util.SHA256Util;
import egov.linkpay.ims.util.StringUtils;

@Service("baseInfoMgmtService")
public class BaseInfoMgmtServiceImpl implements BaseInfoMgmtService
{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="baseInfoMgmtDAO")
    private BaseInfoMgmtDAO baseInfoMgmtDAO;
	
	@Resource(name="baseInfoRegistrationDAO")
    private BaseInfoRegistrationDAO baseInfoRegistrationDAO;	
	
	
	
	 //기본정보조회 테스트
    @Override
    public Map<String, Object> baseInfo(Map<String, Object> paramMap) throws Exception 
    {
    	int logCount=0;
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	List< Map<String, Object>>	objList = new ArrayList<Map<String, Object>>();
    	List< Map< String, String > >	cateList = new ArrayList<Map< String, String >>();
    	log.info( "기본정보조회 START" );
    	try
    	{
    		objList = baseInfoMgmtDAO.selectMidInfo(paramMap);
			if(objList.size() == 0 )
			{
				log.info( "기본정보조회-" +(logCount++) +"- MID정보 없음" );
				resultMap.put( "resultCd", "9999" );
				return resultMap;
			}
			else 
			{
				log.info( "기본정보조회-" +(logCount++) +  "- MID정보data : " + ToStringBuilder.reflectionToString( objList ) );
					
				resultMap.put( "midInfo", objList );
				
			}	
			
    		
    		resultMap.put( "resultCd", "0000" );
    	}
    	catch(Exception e)
    	{
    		 log.error( "기본정보조회-EXCEPTION : " , e );
    	}
    	
    	return resultMap;
    }
    @Override
    public List<Map<String,Object>> selectBaseInfoList(Map< String, Object > paramMap) throws Exception {
    	return baseInfoMgmtDAO.selectBaseInfoList( paramMap );
    }
    @Override
    public int selectBaseInfoListTotal(Map< String, Object > paramMap) throws Exception {
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
    public List< Map< String, Object > > selectEmpAuthSearch(Map<String, Object> paramMap) throws Exception {
        return baseInfoMgmtDAO.selectEmpAuthSearch(paramMap);
    }
    @Override
    public List< Map< String, Object > > selectVMid(Map<String, Object> paramMap) throws Exception {
        return baseInfoMgmtDAO.selectVMid(paramMap);
    }
    
    @Override
    public List<Map<String,Object>> insertMultiRegist(Map< String, Object > paramMap) throws Exception {
    	//String filedir = (String)paramMap.get( "fileDir" );
    	//String filename = (String)paramMap.get( "fileNm" );
    	String filePath = (String)paramMap.get( "filePath" );
    	List<Map<String,Object>> uploadList = StringUtils.excelToListMap(filePath, 0, 4);
      	ArrayList<Map<String,Object>> resultLst = new ArrayList<Map<String,Object>>();
    	log.info("excel upload list : [{}]"+uploadList);
      	
      	
      	String[] aSvcCd = {"01", "02", "03", "05"};//지불수단 - 01:신용카드, 02:계좌이체, 03:가상계좌, 05:휴대폰, 06:휴대폰빌링, 07:일반빌링, 08:안심빌링
        String[] aSvcPrdtCd = {"01"}; //지불매체 - 01:온라인, 03:스마트폰, 04:MO, 05:빌링
        String[] aCpCd = {"01","02","03","04","06","07","08","12","99"};//카드사 - 01:비씨, 02:국민, 03:외환, 04:삼성, 06:신한, 07:현대, 08:롯데, 12:농협 
        String[] aFnVB = {"003","004","005","007","011","020","023","027","031","032","034","037","039","045","071","081","088"};//가상계좌 은행 
        String[] aInst = {"01", "02"};//무이자 여부
        String[] aAccntStep = {"01", "02"};//수수료
        String[] aCPID = {"02", "05"};
        
        log.info( "uploadList size : " + uploadList.size() );
      	for(Map<String,Object> rowModel : uploadList){
      		Map<String,Object> rtnMap = new HashMap<String,Object>();
      		
      		String strCoNo = (String)((rowModel.get("3")==null)?"":rowModel.get("3"));	//사업자번호
      		rtnMap.put( "MER_ID", strCoNo );
      		
      		Map<String,Object> compInfo = new HashMap<String,Object>();
      		Map<String,Object> feeInfo = new HashMap<String,Object>();
      		
      		if(strCoNo!=null && !"".equals(strCoNo)){
    	  		List<Map<String, Object>> aLst = baseInfoMgmtDAO.selectCoInfo((String)rtnMap.get( "MER_ID" ));
    	  		if(aLst.size() > 0) {
    	  			compInfo = (Map<String,Object>)aLst.get(0);
    	  			
    	  			if(!(compInfo.get("CONT_ST_CD")==null?"00":compInfo.get("CONT_ST_CD")).equals( "88" )
    	  					&& !(compInfo.get("CONT_ST_CD")==null?"00":compInfo.get("CONT_ST_CD")).equals( "89" )){
    		  			rowModel.put("insertMIDInfo", "N");
    		  			rowModel.put("resultMsg", "해당 사업자번호 계완 미완료 상태");
    		  			resultLst.add(rowModel);
    		  			continue;
    	  			}
    	  		}else{
    	  			rowModel.put("insertMIDInfo", "N");
    	  			rowModel.put("resultMsg", "해당 사업자번호 계약 미진행");
    	  			resultLst.add(rowModel);
    	  			continue;
    	  		}
    	  		List<Map<String, Object>> aLstF = baseInfoMgmtDAO.selectCompFee(rtnMap);
    	  		if(aLstF.size() > 0) {
    	  			feeInfo = (Map<String,Object>)aLstF.get(0);
    	  		}	
      		}else{
      			rowModel.put("insertMIDInfo", "N");
      			rowModel.put("resultMsg", "사업자번호 미입력");
      			resultLst.add(rowModel);
      			continue;
      		}
      		
      		log.info("excel row_model : [{}]" + rowModel);
      		  		
      		//gid가 없으면 gid 생성
      		
      		String mid = (String)(rowModel.get("0")==null||rowModel.get("0")==""?"":rowModel.get("0"));
      		String gid = (String)(rowModel.get("1")==null||rowModel.get("1")==""?"":rowModel.get("1"));
      		String vid = (String)(rowModel.get("2")==null||rowModel.get("2")==""?"000000000v":rowModel.get("2"));
      		
      		log.info( "mid : " + vid );
      		log.info( "gid : " + gid );
      		log.info( "vid : " + vid );
      		
      		if(mid==null || "".equals(mid)){
      			rowModel.put("insertMIDInfo", "N");
      			rowModel.put("resultMsg", "mid 미입력");
      			resultLst.add(rowModel);
      			continue;
      		}else{
      			 if(mid.length() !=10){
      				rowModel.put("insertMIDInfo", "N");
      				rowModel.put("resultMsg", "mid 길이 오류(10자리)");
      	  			resultLst.add(rowModel);
      	  			continue;
      			 }
      		}
      		
      		if(gid==null || "".equals(gid)){
      			rowModel.put("insertMIDInfo", "N");
      			rowModel.put("resultMsg", "gid 미입력");
      			resultLst.add(rowModel);
      			continue;
      		}else{
      			 if(gid.length() !=10){
      				rowModel.put("insertMIDInfo", "N");
      				rowModel.put("resultMsg", "gid 길이 오류(10자리)");
      				resultLst.add(rowModel);
      	  			continue;
      			 }
      		}
      		
      		if(vid==null || "".equals(vid)){
      			rowModel.put("insertMIDInfo", "N");
      			rowModel.put("resultMsg", "vid 미입력");
      			resultLst.add(rowModel);
      			continue;
      		}else{
      			 if(vid.length() !=10){
      				rowModel.put("insertMIDInfo", "N");
      				rowModel.put("resultMsg", "vid 길이 오류(10자리)");
      	  			resultLst.add(rowModel);
      	  			continue;
      			 }
      			 
      			List<Map<String, Object>> lstvid = baseInfoRegistrationDAO.selectVidInfo(vid);
      			ArrayList aLstvid = (ArrayList)lstvid;
      			
      			if(aLstvid==null || aLstvid.size()==0){
      				rowModel.put("insertMIDInfo", "N");
      				rowModel.put("resultMsg", "미등록 vid");
      				resultLst.add(rowModel);
      	  			continue;				
      			}
      		}		  		
      		
      		
      		rowModel.put("MID", mid);
      		rowModel.put("U_ID", mid.length() == 10 ? mid.substring(0,9) : "");
      		
      		rowModel.put("CO_NO", (rowModel.get("3")==null || rowModel.get("3")=="")?"":rowModel.get("3"));
      		rowModel.put("CO_NM", (rowModel.get("4")==null||rowModel.get("4")=="")?"":rowModel.get("4"));
      		rowModel.put("REP_MM", compInfo.get("REP_NM")==null?"":compInfo.get( "REP_NM" ));
      		rowModel.put("GID", gid);
      		rowModel.put("VID", vid);
      		
      		//rowModel.put("addrCl", "");
      		
      		String midUrl = (String)(compInfo.get("CO_URL")==null?"":compInfo.get( "CO_URL" ));
      		
      		rowModel.put("URL", midUrl);
      		rowModel.put("USE_CL", "0");
      		rowModel.put("TEL_NO", compInfo.get("TEL_NO")==null?"":compInfo.get("TEL_NO"));
      		rowModel.put("FAX_NO", compInfo.get("FAX_NO")==null?"":compInfo.get("FAX_NO"));
      		rowModel.put("EMAIL", compInfo.get("EMAIL")==null?"":compInfo.get("EMAIL"));
      		rowModel.put("CONT_EMP_NM", compInfo.get("CONT_NM")==null?"":compInfo.get("CONT_NM"));
      		rowModel.put("CONT_EMP_TEL", compInfo.get("CONT_TEL")==null?"":compInfo.get("CONT_TEL"));
      		rowModel.put("CONT_EMP_HP", compInfo.get("CONT_CP")==null?"":compInfo.get("CONT_CP"));
      		rowModel.put("CONT_EMP_EMAIL", compInfo.get("CONT_EMAIL")==null?"":compInfo.get("CONT_EMAIL"));
      		rowModel.put("STMT_EMP_NM", compInfo.get("SETT_NM")==null?"":compInfo.get("SETT_NM"));
      		rowModel.put("STMT_EMP_TEL", compInfo.get("SETT_TEL")==null?"":compInfo.get("SETT_TEL"));
      		rowModel.put("STMT_EMP_EMAIL", compInfo.get("SETT_EMAIL")==null?"":compInfo.get("SETT_EMAIL"));
      		rowModel.put("POST_NO", compInfo.get("POST_NO")==null?"":compInfo.get("POST_NO"));
      		rowModel.put("ADDR_NO1", compInfo.get("ADDR_NO1")==null?"":compInfo.get("ADDR_NO1"));
      		rowModel.put("ADDR_NO2", compInfo.get("ADDR_NO2")==null?"":compInfo.get("ADDR_NO2"));
      		rowModel.put("RPOST_NO", compInfo.get("RPOST_NO")==null?"":compInfo.get("RPOST_NO"));
      		rowModel.put("RADDR_NO1", compInfo.get("RADDR_NO1")==null?"":compInfo.get("RADDR_NO1"));
      		rowModel.put("RADDR_NO2", compInfo.get("RADDR_NO2")==null?"":compInfo.get("RADDR_NO2"));
      		rowModel.put("BS_KIND", compInfo.get("BS_KIND")==null?"":compInfo.get("BS_KIND"));
      		rowModel.put("GD_KIND", compInfo.get("GD_KIND")==null?"":compInfo.get("GD_KIND"));
      		rowModel.put("CONT_EMP_NO", compInfo.get("CONT_EMP_NO")==null?"":compInfo.get("CONT_EMP_NO"));
      		rowModel.put("MGR1_EMP_NO", compInfo.get("MGR1_EMP_NO")==null?"":compInfo.get("MGR1_EMP_NO"));
      		rowModel.put("MBS_TYPE_CD", (rowModel.get("7")==null||rowModel.get("7")=="")?"1":rowModel.get("7"));
      		rowModel.put("OM_SETT_CL", "0");
      		rowModel.put("CompanyType", "0");
      		rowModel.put("CONT_DT", compInfo.get("CONT_DT")==null?"":compInfo.get("CONT_DT"));
      		rowModel.put("bsKind", (rowModel.get("6")==null||rowModel.get("6")=="")?"0000:0000":rowModel.get("6"));
      		rowModel.put("RECV_CH_CD", compInfo.get("RECV_CH_CD")==null?"0000":compInfo.get("RECV_CH_CD"));
      		rowModel.put("WORKER", paramMap.get( "worker" ));
      		//rowModel.put("sido", "");
      		//rowModel.put("gugun", "");
      		//rowModel.put("dong", "");
      		rowModel.put("ACCNT_RISK_GRADE", "1");
      		rowModel.put("bsKindCd", (rowModel.get("16")==null||rowModel.get("16")=="")?"2":rowModel.get("16"));
      		
      		String signNm = (String)((rowModel.get("5")==null||rowModel.get("5")=="")?"":rowModel.get("5"));
      		if(signNm==null || "".equals(signNm)){
      			signNm = (String)((rowModel.get("4")==null||rowModel.get("4")=="")?"":rowModel.get("4"));
      		}
      		rowModel.put("SIGN_NM", signNm);
      		//rowModel.put("appCoNo", rowModel.get("3")==null?"":rowModel.get("3"));
      		rowModel.put("MMS_PAY_FLG", "0");
      		rowModel.put("SMS_PUSH_FLG", "0");
      		
      		rtnMap.put( "MER_ID", mid );
      		List<Map<String,Object>> midList = baseInfoMgmtDAO.selectMidInfo(rtnMap);
      		
      		int iRtn = 0;
    		String oldEscrowRegNo = "";
      		if(midList!=null && midList.size()>0){
      			Map<String,Object> midMap = (Map<String,Object>)midList.get(0);
      			//oldEscrowRegNo = (String)(midMap.get("escrow_reg_no")==null?"":midMap.get("escrow_reg_no"));
      			iRtn = 1;
      		}else{
      	  		//기본정보 등록
      	  	  	iRtn = baseInfoRegistrationDAO.insertMidInfo(rowModel);  			
      		}
      		
      	  	if(iRtn > 0){
      	  		  	  		
    	  	  	rowModel.put("insertMIDInfo", "Y");		//기본정보 등록성공여부
      	  		
    	  	  	rowModel.put("ORD_NO_DUP_FLG", "0");
    	  	  	
      	  		//기타정보
      			rowModel.put("CSHRCPT_AUTO_FLG", (rowModel.get("8")==null||rowModel.get("8")=="")?"0":rowModel.get("8"));	//현금영수증 자동발급
      			rowModel.put("PAY_NOTI_CD", "01");	//결제공지
      			rowModel.put("RCPT_PRT_TYPE", "0");			//신용카드매출전표 발행
      			
      			if(((rowModel.get("9")==null||rowModel.get("9")=="")?"0":rowModel.get("9")).equals( "0" )){				//부가가치세 별도표시/미표시
      				rowModel.put("VAT_MARK_FLG","0");
      				rowModel.put("VAT_SEPARATE_FLG","0");
      			}else if(((rowModel.get("9")==null||rowModel.get("9")=="")?"0":rowModel.get("9")).equals( "1" )){
      				rowModel.put("VAT_MARK_FLG","1");
      				rowModel.put("VAT_SEPARATE_FLG","0");
      			}
      			rowModel.put("VACCT_LMT_DAY", (rowModel.get("11")==null||rowModel.get("11")=="")?"0":rowModel.get("11"));		//가상계좌 입금제한일자
      			rowModel.put("VACCT_ISS_TYPE", (rowModel.get("12")==null||rowModel.get("12")=="")?"1":rowModel.get("12"));		//가상계좌 채번형태
      			rowModel.put("APP_VAN1_CD", "04");		//승인밴1 JTNET
      			rowModel.put("APP_VAN2_CD", "04");		//승인밴1 JTNET
      			rowModel.put("ACQ_VAN_CD", "04");		//매입밴	JTNET	
//      			rowModel.put("CP_SLIDING_TYPE", "0");		//휴대폰 인증여부
      			rowModel.put("ESCROW_USE_FLG", (rowModel.get("14")==null||rowModel.get("14")=="")?"0":rowModel.get("14"));		//에스크로 사용여부
      			
      			/*String strEscrowCl = ( String ) ((rowModel.get("14")==null?"0":rowModel.get("14"));
      			if("1".equals(strEscrowCl) && "".equals(oldEscrowRegNo)){
      				rowModel.put("escrow_reg_no", "1");
      			}*/
      			//rowModel.put("billType", "");			
      			//rowModel.put("safeBillCd", "");
      			//rowModel.put("reqAuthCl", "");
      			rowModel.put("MBS_KEY_AUTH_FLG", "0");		//merchant키 수정권한
//      			rowModel.put("vaccCl", rowModel.get("15")==null?"0":rowModel.get("15"));		//가상계좌 발금메뉴 사용여부
      			//rowModel.put("smsCl", "");
//      			rowModel.put("smart_app_cl", "");
      			rowModel.put("PUSH_PAY_CD", "0");		//푸시페이 사용여부
      			//rowModel.put("appCoNo", "");			
      			rowModel.put("MMS_PAY_FLG", "0");			//mms 결제권한
      			rowModel.put("AUTO_CANCEL_FLG", rowModel.get("13")==null?"1":rowModel.get("13"));		//미통보자동취소 default 1: 미적용
      			//rowModel.put("worker", "");
      	  	  	
      	  		//정산정보
      			rowModel.put("ACQ_CL_CD", "0");				//매입방법
      			rowModel.put("BANK_CD", (rowModel.get("18")==null||rowModel.get("18")=="")?"":rowModel.get("18"));			//계좌은행
      			rowModel.put("ACCNT_NO", (rowModel.get("19")==null || rowModel.get("19")=="")?"":( ( String ) rowModel.get("19") ).trim());			//계좌번호
      			if(rowModel.get("19") != null || rowModel.get("19")!= "")
      			{
      				String encAcctNo = SHA256Util.encrypt( (String)rowModel.get( "19" ));
      				rowModel.put("ACCNT_NO_ENC", encAcctNo.trim());		//계좌번호 암호화
      			}
      			else
      			{
      				rowModel.put("ACCNT_NO_ENC", "");
      			}
      			rowModel.put("ACCNT_NM", (rowModel.get("20")==null||rowModel.get("20")=="")?"":rowModel.get("20"));			//계좌주명
      			rowModel.put("AUTH_TYPE", (rowModel.get("21")==null||rowModel.get("21")=="")?"0":rowModel.get("21"));		//가맹점인증타입
      			
      			rowModel.put("CC_CL_CD", "0");
      			rowModel.put("CC_CHK_FLG", "1");
      			rowModel.put("AUTO_CAL_FLG", (rowModel.get("17")==null||rowModel.get("17")=="")?"0":rowModel.get("17"));		//자동상계
      			
      			String partCancel = ( String ) ((rowModel.get("10")==null||rowModel.get("10")=="")?"3":rowModel.get("10"));			//부분취소 권한
      			if("3".equals(partCancel)){
      				partCancel = "110";
      			}else if("2".equals(partCancel)){
      				partCancel = "010";
      			}else if("1".equals(partCancel)){
      				partCancel = "100";
      			}else if("0".equals(partCancel)){
      				partCancel = "000";
      			}else{
      				partCancel = "000";
      			}
      			rowModel.put("CC_PART_CL", partCancel);
      			rowModel.put("CP_SLIDING_TYPE", "1");
      			
      			rowModel.put("settl_pm_0001", "00");				//정산유형
      			rowModel.put("settl_pm_old_0001", "");
      			
      			rowModel.put("settl_pm_0005", "01");
      			rowModel.put("settl_pm_old_0005", "");
      										 	
      			String fn23 = (String)((rowModel.get("23")==null||rowModel.get("23")=="")?"":rowModel.get("23"));	
      			String fn24 = (String)((rowModel.get("24")==null||rowModel.get("24")=="")?"":rowModel.get("24"));	
      			String fn25 = (String)((rowModel.get("25")==null||rowModel.get("25")=="")?"":rowModel.get("25"));	
      			String fn26 = (String)((rowModel.get("26")==null||rowModel.get("26")=="")?"":rowModel.get("26"));	
      			String fn27 = (String)((rowModel.get("27")==null||rowModel.get("27")=="")?"":rowModel.get("27"));	
      			String fn28 = (String)((rowModel.get("28")==null||rowModel.get("28")=="")?"":rowModel.get("28"));	
      			String fn29 = (String)((rowModel.get("29")==null||rowModel.get("29")=="")?"":rowModel.get("29"));	
      			String fn30 = (String)((rowModel.get("30")==null||rowModel.get("30")=="")?"":rowModel.get("30"));		
      			String fn31 = (String)((rowModel.get("31")==null||rowModel.get("31")=="")?"":rowModel.get("31"));	
      			
      	  		if(fn25!=null && !"".equals(fn25) && !"00000000".equals(fn25) && fn25.length() < 11){
      	  			fn25 = String.format("%011d", Integer.parseInt(fn25));
      	  		}
      	  		
      	  		if(fn26!=null && !"".equals(fn26) && !"00000000".equals(fn26) && fn26.length() < 11){
      	  			fn26 = String.format("%011d", Integer.parseInt(fn26));
      	  		}  	  		

      			// 신용카드 일반
      			
      			rowModel.put("mbsNo_010104", (rowModel.get("23")==null||rowModel.get("23")=="")?"":rowModel.get("23"));				//삼성카드 
      			rowModel.put("mbsNo_010104_old", "");		//삼성카드_old
      			rowModel.put("mbsNo_010101", (rowModel.get("24")==null||rowModel.get("24")=="")?"":rowModel.get("24"));					//비씨카드 
      			rowModel.put("mbsNo_010101_old", "");		//비씨카드_old
      			rowModel.put("mbsNo_010102", fn25);				//국민카드 
      			rowModel.put("mbsNo_010102_old", "");		//국민카드_old
      			rowModel.put("mbsNo_010103", fn26);				//하나(외환)카드 
      			rowModel.put("mbsNo_010103_old", "");		//하나(외환)카드_old
      			rowModel.put("mbsNo_010106", (rowModel.get("27")==null||rowModel.get("27")=="")?"":rowModel.get("27"));					//신한카드 
      			rowModel.put("mbsNo_010106_old", "");		//신한카드_old
      			rowModel.put("mbsNo_010107", (rowModel.get("28")==null||rowModel.get("28")=="")?"":rowModel.get("28"));					//현대카드 
      			rowModel.put("mbsNo_010107_old", "");		//현대카드_old
      			rowModel.put("mbsNo_010108", (rowModel.get("29")==null||rowModel.get("29")=="")?"":rowModel.get("29"));					//롯데카드 
      			rowModel.put("mbsNo_010108_old", "");		//롯데카드_old
      			rowModel.put("mbsNo_010112", (rowModel.get("30")==null||rowModel.get("30")=="")?"":rowModel.get("30"));					//NH카드 
      			rowModel.put("mbsNo_010112_old", "");		//NH카드_old

      			rowModel.put("mbsNo_010125", (rowModel.get("31")==null||rowModel.get("31")=="")?"":rowModel.get("31"));				//해외카드 
      			rowModel.put("mbsNo_010125_old", "");		//해외카드_old
      			rowModel.put("mbsNo_010126", (rowModel.get("31")==null||rowModel.get("31")=="")?"":rowModel.get("31"));				//해외카드 
      			rowModel.put("mbsNo_010126_old", "");		//해외카드_old
      			rowModel.put("mbsNo_010127", (rowModel.get("31")==null||rowModel.get("31")=="")?"":rowModel.get("31"));				//해외카드 
      			rowModel.put("mbsNo_010127_old", "");		//해외카드_old
      			rowModel.put("mbsNo_010129", (rowModel.get("31")==null||rowModel.get("31")=="")?"":rowModel.get("31"));					//해외카드 
      			rowModel.put("mbsNo_010129_old", "");		//해외카드_old

      			rowModel.put("termNo_010104", (rowModel.get("32")==null||rowModel.get("32")=="")?"":rowModel.get("32"));			//삼성카드 
      			rowModel.put("termNo_010104_old", "");		//삼성카드_old
      			rowModel.put("termNo_010101",(rowModel.get("33")==null||rowModel.get("33")=="")?"":rowModel.get("33"));;			//비씨카드 
      			rowModel.put("termNo_010101_old", "");		//비씨카드_old
      			rowModel.put("termNo_010102", (rowModel.get("34")==null||rowModel.get("34")=="")?"":rowModel.get("34"));			//국민카드 
      			rowModel.put("termNo_010102_old", "");		//국민카드_old
      			rowModel.put("termNo_010103", (rowModel.get("35")==null||rowModel.get("35")=="")?"":rowModel.get("35"));			//하나(외환)카드 
      			rowModel.put("termNo_010103_old", "");		//하나(외환)카드_old
      			rowModel.put("termNo_010106", (rowModel.get("36")==null||rowModel.get("36")=="")?"":rowModel.get("36"));			//신한카드 
      			rowModel.put("termNo_010106_old", "");		//신한카드_old
      			rowModel.put("termNo_010107", (rowModel.get("37")==null||rowModel.get("37")=="")?"":rowModel.get("37"));			//현대카드 
      			rowModel.put("termNo_010107_old", "");		//현대카드_old
      			rowModel.put("termNo_010108", (rowModel.get("38")==null||rowModel.get("38")=="")?"":rowModel.get("38"));		//롯데카드 
      			rowModel.put("termNo_010108_old", "");		//롯데카드_old
      			rowModel.put("termNo_010112", (rowModel.get("39")==null||rowModel.get("39")=="")?"":rowModel.get("39"));			//NH카드 
      			rowModel.put("termNo_010112_old", "");		//NH카드_old
      			rowModel.put("termNo_010125", (rowModel.get("40")==null||rowModel.get("40")=="")?"":rowModel.get("40"));			//해외카드 
      			rowModel.put("termNo_010125_old", "");		//해외카드_old
      			rowModel.put("termNo_010126", (rowModel.get("40")==null||rowModel.get("40")=="")?"":rowModel.get("40"));			//해외카드 
      			rowModel.put("termNo_010126_old", "");		//해외카드_old
      			rowModel.put("termNo_010127", (rowModel.get("40")==null||rowModel.get("40")=="")?"":rowModel.get("40"));			//해외카드 
      			rowModel.put("termNo_010127_old", "");		//해외카드_old
      			rowModel.put("termNo_010129", (rowModel.get("40")==null||rowModel.get("40")=="")?"":rowModel.get("40"));		//해외카드 
      			rowModel.put("termNo_010129_old", "");		//해외카드_old
      			
      			for(int i=0; i< aCpCd.length; i++){
    				String strTermNo = (String)((rowModel.get("termNo_0101"+aCpCd)==null || rowModel.get("termNo_0101"+aCpCd)=="")?"":rowModel.get("termNo_0101"+aCpCd));
    				String strMbsNo = (String)((rowModel.get("mbsNo_0101"+aCpCd)==null || rowModel.get("mbsNo_0101"+aCpCd)=="")?"":rowModel.get("mbsNo_0101"+aCpCd));
    				
    				if((strMbsNo!=null && !strMbsNo.equals( "" )) || (strTermNo!=null && ! strTermNo.equals( "" ))){
    					
    					if(strMbsNo==null || strMbsNo.equals( "" )){
    		  				rowModel.put("resultMsg", "신용카드 가맹점번호 미입력 :"+aCpCd[i]);
    		  				resultLst.add(rowModel);
    		  	  			continue;	
    					}
    					if(strTermNo==null || strTermNo.equals( "" )){
    		  				rowModel.put("resultMsg", "신용카드 터미널번호 미입력:"+aCpCd[i]);
    		  				resultLst.add(rowModel);
    		  	  			continue;	
    					}					
    					
    					Map<String,Object> termMap = new HashMap<String,Object>();
    					termMap.put("mbsNo", strMbsNo);
    					termMap.put("termNo", strTermNo);

    					List<Map<String,Object>> aTermLst = (List<Map<String,Object>>)baseInfoMgmtDAO.getTermLst2(termMap);
    					
    					if(aTermLst!=null && aTermLst.size()>0){
    						Map<String,Object> termInfoMap = (Map<String,Object>)aTermLst.get(0);
    						
    						if(termInfoMap ==null || termInfoMap.isEmpty()){
    				  			rowModel.put("insertMIDInfo", "Y");
    				  			rowModel.put("resultMsg", "존재하지않는 터미널 정보:"+aCpCd[i]);
    				  			resultLst.add(rowModel);
    				  			continue;
    						}
    					}else{
    			  			rowModel.put("insertMIDInfo", "Y");
    			  			rowModel.put("resultMsg", "존재하지않는 터미널 정보:"+aCpCd[i]);
    			  			resultLst.add(rowModel);
    			  			continue;						
    					}
    				}
    				
      			}
      			
      			// 사용전환
      			rowModel.put("use_cl_0101", ((rowModel.get("22")==null || rowModel.get("22")=="")?"1":rowModel.get("22")));			//신용카드 사용여부 
      			rowModel.put("use_cl_0201", ((rowModel.get("54")==null || rowModel.get("54")=="")?"1":rowModel.get("54")));			//계좌이체 사용여부  
      			rowModel.put("use_cl_0301", ((rowModel.get("59")==null || rowModel.get("59")=="")?"1":rowModel.get("59")));			//가상계좌 사용여부   
      			rowModel.put("use_cl_0501", ((rowModel.get("62")==null || rowModel.get("62")=="")?"1":rowModel.get("62")));			//휴대폰 사용여부 
      			
      			// 정산주기
      			rowModel.put("stmtCycle_0101", (rowModel.get("50")==null||rowModel.get("50")=="")?"":rowModel.get("50"));			//신용카드 정산주기
      			rowModel.put("stmtType_0101", "0");								//신용카드 승인정산/입금정산
      			
      			rowModel.put("stmtCycle_0201", (rowModel.get("56")==null||rowModel.get("56")=="")?"":rowModel.get("56"));			//계좌이체 정산주기
      			rowModel.put("stmtType_0201", "0");								//계좌이체 승인정산/입금정산
      			
      			rowModel.put("stmtCycle_0301", (rowModel.get("61")==null||rowModel.get("56")=="")?"":rowModel.get("61"));			//가상계좌 정산주기
      			rowModel.put("stmtType_0301", "0");								//가상계좌 승인정산/입금정산
      			
      			rowModel.put("stmtCycle_0501", (rowModel.get("63")==null||rowModel.get("63")=="")?"":rowModel.get("63"));			//휴대폰 정산주기
      			rowModel.put("stmtType_0501", (rowModel.get("66")==null||rowModel.get("66")=="")?"1":rowModel.get("66"));			//휴대폰 승인정산/입금정산
      			
      			// 계좌이체 / 휴대폰 CPID
      			rowModel.put("cpid_0201", rowModel.put("55",""));				//계좌이체 CPID
      			rowModel.put("cpid_0501", rowModel.put("64",""));				//휴대폰 CPID
      			rowModel.put("subcpid_0501", rowModel.put("65",""));			//휴대폰 SUB CPID
      			
      			
      				 	
      		 	//카드 사용여부 && 할부개월제한
      		    rowModel.put("cardUse", (rowModel.get("52")==null||rowModel.get("52")=="")?"01:02:03:04:06:07:08:12":rowModel.get("52"));			//사용카드사
      			rowModel.put("cardBlock", (rowModel.get("53")==null||rowModel.get("53")=="")?"":rowModel.get("53"));		//사용불가카드사
      			rowModel.put("limitInst", (rowModel.get("51")==null||rowModel.get("51")=="")?"12":rowModel.get("51"));		//할부개월제한
      		    
      		    String[] fnCd_cellIdx = { "42", "43", "44", "41", "45",	"46", "47", "48", "49" };
      		    
    	  		//신용카드 수수료
    	  		ArrayList<Map<String,Object>> fLst = new ArrayList<Map<String,Object>>();
    	  		

      		    for(int k = 0; k < aCpCd.length; k++) {
      		    	Map<String,Object> rmap01 = new HashMap<String,Object>();
    		    	
     		    	String fee01 = ( String ) ( rowModel.get(fnCd_cellIdx[k])==null?"":rowModel.get(fnCd_cellIdx[k]) );
     		    	
     		    	if(fee01.equals( "" )){
     		    		String compfee01 = "";
     		    		if(aCpCd[k] != "99"){
     		    			compfee01 = (((BigDecimal)feeInfo.get("FEE_0101"+aCpCd[k])).toString()!=null?"":((BigDecimal)feeInfo.get("FEE_0101"+aCpCd[k])).toString());
     		    		}
      	  		    	
      	  		    	if(compfee01.equals( "" )){
      	  		    		continue;
      	  		    	}
      	  		    	
      	  		    	if(aCpCd[k].equals( "99" )){	  	  		        
    	  	  		        rmap01.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	  	  		        rmap01.put("idCd", "1");
    	  	  		        rmap01.put("pmCd", "01");
    	  	  		        rmap01.put("spmCd", "01");
    	  	  		        rmap01.put("cpCd", "25");
    	  	  		        rmap01.put("frDt", "toDay");
    	  	  		        rmap01.put("feeTypeCd", "2");
    	  	  		        rmap01.put("fee", compfee01);
    	  	  		        rmap01.put("frAmt", 1);
    	  	  		        rmap01.put("status", "1");
    	  	  		        fLst.add(rmap01);
    	  	  		        
    	  	  		        Map<String,Object> rmap26 = new HashMap<String,Object>();
    	  	  		    	rmap26.put("id",(rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	  	  		        rmap26.put("idCd", "1");
    	  	  		        rmap26.put("pmCd", "01");
    	  	  		        rmap26.put("spmCd", "01");
    	  	  		        rmap26.put("cpCd", "26");
    	  	  		        rmap26.put("frDt", "toDay");
    	  	  		        rmap26.put("feeTypeCd", "2");
    	  	  		        rmap26.put("fee", compfee01);
    	  	  		        rmap26.put("frAmt", 1);
    	  	  		        rmap26.put("status", "1");
    	  	  		        fLst.add(rmap26);
    	  	  		        
    	  	  		    	Map<String,Object> rmap27 = new HashMap<String,Object>();
    	  	  		        rmap27.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	  	  		        rmap27.put("idCd", "1");
    	  	  		        rmap27.put("pmCd", "01");
    	  	  		        rmap27.put("spmCd", "01");
    	  	  		        rmap27.put("cpCd", "27");
    	  	  		        rmap27.put("frDt", "toDay");
    	  	  		        rmap27.put("feeTypeCd", "2");
    	  	  		        rmap27.put("fee", compfee01);
    	  	  		        rmap27.put("frAmt", 1);
    	  	  		        rmap27.put("status", "1");
    	  	  		        fLst.add(rmap27);
    	  	  		        
    	  	  		        Map<String,Object> rmap29 = new HashMap<String,Object>();
    	  	  		        rmap29.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	  	  		        rmap29.put("idCd", "1");
    	  	  		        rmap29.put("pmCd", "01");
    	  	  		        rmap29.put("spmCd", "01");
    	  	  		        rmap29.put("cpCd", "29");
    	  	  		        rmap29.put("frDt", "toDay");
    	  	  		        rmap29.put("feeTypeCd", "2");
    	  	  		        rmap29.put("fee", compfee01);
    	  	  		        rmap29.put("frAmt", 1);
    	  	  		        rmap29.put("status", "1");
    	  	  		        fLst.add(rmap29);	  	
    	  	  		        
      	  		    	}else{  	  		    	
    	  	  		        rmap01.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	  	  		        rmap01.put("idCd", "1");
    	  	  		        rmap01.put("pmCd", "01");
    	  	  		        rmap01.put("spmCd", "01");
    	  	  		        rmap01.put("cpCd", aCpCd[k]);
    	  	  		        rmap01.put("frDt", "toDay");
    	  	  		        rmap01.put("feeTypeCd", "2");
    	  	  		        rmap01.put("fee", compfee01);
    	  	  		        rmap01.put("frAmt", 1);
    	  	  		        rmap01.put("status", "1");
    	  	  		        fLst.add(rmap01);
      	  		    	}
     		    	}else{  		
    	 		        rmap01.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	 		        rmap01.put("idCd", "1");
    	 		        rmap01.put("pmCd", "01");
    	 		        rmap01.put("spmCd", "01");
    	 		        rmap01.put("cpCd", aCpCd[k]);
    	 		        rmap01.put("frDt", "toDay");
    	 		        rmap01.put("feeTypeCd", "2");
    	 		        rmap01.put("fee", (rowModel.get(fnCd_cellIdx[k])==null || rowModel.get(fnCd_cellIdx[k])=="")?"":rowModel.get(fnCd_cellIdx[k]));
    	 		        rmap01.put("frAmt", 1);
    	 		        rmap01.put("status", "1");
    	 		        fLst.add(rmap01);
     		    	}
      		    }
      	  		    
      	  		    
      	  		//계좌이체 수수료
      	  		String strFee01 = (String)((rowModel.get("57")==null||rowModel.get("57")=="")?"":rowModel.get("57"));		//계좌이체 수수료 구간1
      	  		String strFee02 = (String)((rowModel.get("58")==null||rowModel.get("58")=="")?"":rowModel.get("58"));		//계좌이체 수수료 구간2
      	  		    
      	  		if(!"".equals(strFee01)&&!"".equals(strFee02)){
      	  		   	Map<String,Object> rmap0201 = new HashMap<String,Object>();

      	  		   	rmap0201.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
     		        rmap0201.put("idCd", "1");
     		        rmap0201.put("pmCd", "02");
     		        rmap0201.put("spmCd", "01");
     		        rmap0201.put("cpCd", "00");
     		        rmap0201.put("frDt", "toDay");
     		        rmap0201.put("fee", strFee01);
     		        rmap0201.put("feeTypeCd", "3");
     		        rmap0201.put("frAmt", 1);
     		        rmap0201.put("status", "1");
     		        fLst.add(rmap0201);

    				Map<String,Object> rmap0202 = new HashMap<String,Object>();
      	  		    rmap0202.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
      	  		    rmap0202.put("idCd", "1");
      	  		    rmap0202.put("pmCd", "02");
      	  		    rmap0202.put("spmCd", "01");
      	  		    rmap0202.put("cpCd", "00");
      	  		    rmap0202.put("frDt", "toDay");
      	  		    rmap0202.put("fee", strFee02);
      	  		    rmap0202.put("feeTypeCd", "2");
      	  		    rmap0202.put("frAmt", 11601);
      	  		    rmap0202.put("status", "1");
      	  		    fLst.add(rmap0202);
      	  		    
    			}else if("".equals(strFee01) && "".equals(strFee02)){
      	  			String fee0201 = (String)(feeInfo.get("fee_020101")==null?"":feeInfo.get("fee_020101"));
      	  			String fee0202 = (String)(feeInfo.get("fee_020102")==null?"":feeInfo.get("fee_020102"));
        
      	  		    if(fee0201!=null && !"".equals(fee0201)){
      	  		    	Map<String,Object> rmap02 = new HashMap<String,Object>();
      	  		        rmap02.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
      	  		        rmap02.put("idCd", "1");
      	  		        rmap02.put("pmCd", "02");
      	  		        rmap02.put("spmCd", "01");
      	  		        rmap02.put("cpCd", "00");
      	  		        rmap02.put("frDt", "toDay");
      	  		        rmap02.put("fee", fee0201);
      	  		        rmap02.put("feeTypeCd", "3");
      	  		        rmap02.put("frAmt", 1);
      	  		        rmap02.put("status", "1");
      	  		        fLst.add(rmap02);
      	  		    }
      	  		    
    	  	  		if(fee0202!=null && !"".equals(fee0202)){
    					Map<String,Object> rmap02 = new HashMap<String,Object>();
    	  	  		    rmap02.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	  	  		    rmap02.put("idCd", "1");
    	  	  		    rmap02.put("pmCd", "02");
    	  	  		    rmap02.put("spmCd", "01");
    	  	  		    rmap02.put("cpCd", "00");
    	  	  		    rmap02.put("frDt", "toDay");
    	  	  		    rmap02.put("fee", fee0202);
    	  	  		    rmap02.put("feeTypeCd", "2");
    	  	  		    rmap02.put("frAmt", 11601);
    	  	  		    rmap02.put("status", "1");
    	  	  		    fLst.add(rmap02);
    	  	  		}				
    			}else{
      	  		   	Map<String,Object> rmap0201 = new HashMap<String,Object>();

      	  		   	if(!"".equals(strFee01)){
    	  	  		   	rmap0201.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	 		        rmap0201.put("idCd", "1");
    	 		        rmap0201.put("pmCd", "02");
    	 		        rmap0201.put("spmCd", "01");
    	 		        rmap0201.put("cpCd", "00");
    	 		        rmap0201.put("frDt", "toDay");
    	 		        rmap0201.put("fee", strFee01);
    	 		        rmap0201.put("feeTypeCd", "3");
    	 		        rmap0201.put("frAmt", 1);
    	 		        rmap0201.put("status", "1");
    	 		        fLst.add(rmap0201);
      	  		   	}
      	  		   	
      	  		   	if(!"".equals(strFee02)){
    					Map<String,Object> rmap0202 = new HashMap<String,Object>();
    	  	  		    rmap0202.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    	  	  		    rmap0202.put("idCd", "1");
    	  	  		    rmap0202.put("pmCd", "02");
    	  	  		    rmap0202.put("spmCd", "01");
    	  	  		    rmap0202.put("cpCd", "00");
    	  	  		    rmap0202.put("frDt", "toDay");
    	  	  		    rmap0202.put("fee", strFee02);
    	  	  		    rmap0202.put("feeTypeCd", "2");
    	  	  		    rmap0202.put("frAmt", 11601);
    	  	  		    rmap0202.put("status", "1");
    	  	  		    fLst.add(rmap0202);		
      	  		   	}
    			}
      	  		// 가상계좌
        	  	      
    			String strFee03 = (String)((rowModel.get("60")==null||rowModel.get("60")=="")?"":rowModel.get("60"));
    			
    			if(!"".equals(strFee03)){
    				for(int k = 0; k < aFnVB.length; k++) {
        	  	    	
    					Map<String,Object> rmap03 = new HashMap<String,Object>();
    						
    					rmap03.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    					rmap03.put("idCd", "1");
    					rmap03.put("pmCd", "03");
    					rmap03.put("spmCd", "01");
    					rmap03.put("cpCd", aFnVB[k]);
    					rmap03.put("frDt", "toDay");
    					rmap03.put("feeTypeCd", "3");
    					rmap03.put("fee", strFee03);        
    					rmap03.put("frAmt", 1);
    					rmap03.put("status", "1");
    						
    					fLst.add(rmap03);
    				}
    			}else{
    				// 가상계좌
    				for(int k = 0; k < aFnVB.length; k++) {
    					String strCompFee03 = (String)(feeInfo.get("fee_0301"+aFnVB[k])==null?"":feeInfo.get("fee_0301"+aFnVB[k]));
    						  	  
    					if(strCompFee03 == null || "".equals(strCompFee03)) continue;
    						  	      
    					Map<String,Object> rmap03 = new HashMap<String,Object>();
    						  	      
    					rmap03.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    					rmap03.put("idCd", "1");
    					rmap03.put("pmCd", "03");
    					rmap03.put("spmCd", "01");
    					rmap03.put("cpCd", aFnVB[k]);
    					rmap03.put("frDt", "toDay");
    					rmap03.put("feeTypeCd", "3");
    					rmap03.put("fee", strCompFee03);        
    					rmap03.put("frAmt", 1);
    					rmap03.put("status", "1");
    					  	      
    					fLst.add(rmap03);
    				}
    			}
      	  		    
    			
    			
    			
    			//휴대폰 수수료
      	  		String strCpFee01 = (String)((rowModel.get("67")==null||rowModel.get("67")=="")?"":rowModel.get("67"));		//휴대폰 수수료 기준1
      	  		String strCpFee02 = (String)((rowModel.get("69")==null||rowModel.get("69")=="")?"":rowModel.get("69"));	//휴대폰 수수료 기준2
      	  		String strCpFee01Type = (String)((rowModel.get("68")==null||rowModel.get("68")=="")?"2":rowModel.get("68"));		//휴대폰 수수료 기준1
      	  			
      	  		if(!"".equals(strCpFee01)){
      	  			if(!"".equals(strCpFee02)){
    	    		
      	  	  			rowModel.put("cpSlidingCl", "2");		//휴대폰수수료구간

    	 	  			Map<String,Object> rmap051 = new HashMap<String,Object>();
     	  				rmap051.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
     	  				rmap051.put("idCd", "1");
     	  				rmap051.put("pmCd", "05");
     	  				rmap051.put("spmCd", "01");
     	  				rmap051.put("cpCd", "00");
     	  				rmap051.put("frDt", "toDay");
     	  				rmap051.put("fee", strCpFee01);
     	  				rmap051.put("feeTypeCd", "2");
     	  				rmap051.put("frAmt", 1);
     	  				rmap051.put("status", "1");
     	  				fLst.add(rmap051);
     	  				
     	  				Map<String,Object> rmap052 = new HashMap<String,Object>();
     	  				rmap052.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
     	  				rmap052.put("idCd", "1");
     	  				rmap052.put("pmCd", "05");
     	  				rmap052.put("spmCd", "01");
     	  				rmap052.put("cpCd", "00");
     	  				rmap052.put("frDt", "toDay");
     	  				rmap052.put("fee", strCpFee02);
     	  				rmap052.put("feeTypeCd", "2");
     	  				rmap052.put("frAmt", 2001);
     	  				rmap052.put("status", "1");
     	  				fLst.add(rmap052);
    				}else{
      		    		rowModel.put("cpSlidingCl", "1");
      		    		
      	  	  			Map<String,Object> rmap053 = new HashMap<String,Object>();
      	  	  			rmap053.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
      	  	  			rmap053.put("idCd", "1");
      	  	  			rmap053.put("pmCd", "05");
      	  	  			rmap053.put("spmCd", "01");
      	  	  			rmap053.put("cpCd", "00");
      	  	  			rmap053.put("frDt", "toDay");
      	  	  			rmap053.put("fee", strCpFee01);
      	  	  			rmap053.put("feeTypeCd", "2");
      	  	  			rmap053.put("frAmt", 1);
      	  	  			rmap053.put("status", "1");
      	  	  			fLst.add(rmap053);
      	  		    }
    			}else{
    				   // 휴대폰
    			   	String strFee05 = (String)(feeInfo.get("fee_050101")==null?"":feeInfo.get("fee_050101"));
    			   
    				if(!"".equals(strFee05) && !"0".equals(strFee05)){
    					
    					String strFeeType05 = (String)(feeInfo.get("feeTypeCd_050101")==null?"":feeInfo.get("feeTypeCd_050101"));
    					
    					Map<String,Object> rmap05 = new HashMap<String,Object>();
    					
    					rmap05.put("id", (rowModel.get("0")==null||rowModel.get("0")=="")?"":rowModel.get("0"));
    					rmap05.put("idCd", "1");
    					rmap05.put("pmCd", "05");
    					rmap05.put("spmCd", "01");
    					rmap05.put("cpCd", "00");
    					rmap05.put("frDt", "toDay");
    					rmap05.put("fee", strFee05);
    					rmap05.put("feeTypeCd", strFeeType05);
    					rmap05.put("frAmt", 1);
    					rmap05.put("status", "1");
    			   
    					fLst.add(rmap05);
    				}				
    			}
      		      		
      			List<Map<String, Object>> lstGID = baseInfoRegistrationDAO.selectGidInfo(gid);
      			ArrayList aLstGID = (ArrayList)lstGID;
      			if(aLstGID == null || aLstGID.size() == 0){
      				rowModel.put("g_nm", signNm);
      				
      				//gid입력
      				baseInfoRegistrationDAO.insertGidRegist(rowModel);
      				
      				log.debug("gid 입력");
      			}
      			
      			updateMIDInfo(rowModel, "1");
      			deleteSettlmntInfo((rowModel.get("0")==null||rowModel.get("0")=="")?"":(String)rowModel.get("0"));
      		    
      			updateMIDInfo(rowModel, "all");
      		     		    
      			insertVIDSettlmntFeeInfo(fLst);	
      		    
      		    rowModel.put("resultMsg", "성공");
      	  		resultLst.add(rowModel);
      	  	}else{
      	  		rowModel.put("insertMIDInfo", "N");		//기본정보 등록성공여부
      	  		rowModel.put("resultMsg", "등록 실패");
      	  		resultLst.add(rowModel);
      	  	}
    	}
    	
    	return resultLst;
    }
    /**
	 * 상점정보 수정
	 *@param HashMap      : MID <br>
	 *@param String				: SaveType <br>
	 *@return             : Update Count <br>
	 *@throws SQLException <br>
	 *@throws Exception <br>
	 */
	public int updateMIDInfo(Map<String,Object> map, String type) throws SQLException, Exception {
		

		int iRtn = 1;

		try {

			if(type.equals("all")) {
				baseInfoRegistrationDAO.updateEtcInfo(map);
				baseInfoRegistrationDAO.updateSettleInfo(map);
				if(iRtn > 0) iRtn = updateSettlmntService(map);
				if(iRtn > 0) iRtn = updateMerchantSettlmnt(map, "01");
			}
			
			// 상점정보 수정 - 일반정보
			else if(type.equals("1")) {
				
				baseInfoRegistrationDAO.updateNormalInfo(map);
				
			}
			

		}catch(Exception e)
		{
			log.error( "Exception - " ,e  );
		}
		finally 
		{
		
		}

		return iRtn;

	}
	/**
	 * 기본정보 설정 삭제(사용/정산주기/수수료/정산서비스/제휴사연동정보)
	 *@param  String      : 조회 구분, 조회 값<br>
	 *@return int         : 조회<br>
	 *@throws SQLException <br>
	 *@throws Exception <br>
	 */
	public int deleteSettlmntInfo(String mid) throws SQLException, Exception{
		int iRtn = 0;
		
		try{
			
			iRtn = baseInfoMgmtDAO.delMassMerSvc(mid);
			iRtn = baseInfoMgmtDAO.delMassSettlmntCycle(mid);
			iRtn = baseInfoMgmtDAO.delMassJoinInfo(mid);
			iRtn = baseInfoMgmtDAO.delMassSettlmntFee(mid);
			iRtn = baseInfoMgmtDAO.delMassSettlmntSvc(mid);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return iRtn;
	}
    /**
	 * 상점정보 수정 - 사업자 수수료 등록
	 *@param HashMap      : 수수료 정보 <br>
	 *@return             : Update Count <br>
	 *@throws SQLException <br>
	 *@throws Exception <br>
	 */
	@SuppressWarnings("rawtypes")
	public int insertVIDSettlmntFeeInfo(ArrayList iLst) throws SQLException, Exception {

		int iRtn = 1;

		try {
			for(int i = 0 ; i < iLst.size() ; i++) {
				Map<String, Object>map = (Map<String, Object>)iLst.get(i);
				if(iRtn > 0) iRtn = baseInfoRegistrationDAO.insertVIDSettlmntFeeInfo(map);			}
		} finally {
		}

		return iRtn;
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
    						cnt = 1;
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
		String[] strPmCd  = {"01","02","03","05"};
		String[] strCPIDLst = {"02", "05"};
		
		ArrayList<Map<String, Object >> aLst1 = new ArrayList<Map<String, Object >>();
		ArrayList<Map<String, Object >> aLst2 = new ArrayList<Map<String, Object >>();
		ArrayList<Map<String, Object >> aLst3 = new ArrayList<Map<String, Object >>();
		ArrayList<Map<String, Object >> aLst4 = new ArrayList<Map<String, Object >>(); 
		Map<String, Object > map = new HashMap<String, Object>();
		map.put( "mid", paramMap.get( "MER_ID" ) );
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
				cardMap.put("fn_no", strTerNo);
				cardMap.put("fn_no_old", oldMbsNo);
				cardMap.put("ter_no", strTerNo);
				cardMap.put("ter_no_old", oldTerNo);
				cardMap.put("worker", paramMap.get( "worker" ));
				
				
				Map<String, Object> noMap= (Map<String, Object>)baseInfoRegistrationDAO.selectTodayCardInfo(cardMap);
				if(noMap == null){
					
				}else{
					oldMbsNo = (String)noMap.get( "MBS_NO" )==""?"":(String)noMap.get( "MBS_NO" );
					oldTerNo = (String)noMap.get( "TERM_NO" )==""?"":(String)noMap.get( "TERM_NO" );
					
				}
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
			String strCycle = (String)paramMap.get( "selCycle_"+ strPmCd[i]+spmCd )==null? "":(String)paramMap.get("stmtCycle_"+strPmCd[i]+spmCd);
			String strOldCycle = (String)paramMap.get("stmtCycle_"+strPmCd[i]+spmCd+"_old")==null? "":(String)paramMap.get("stmtCycle_"+strPmCd[i]+spmCd+"_old");
			log.debug("stmtCycle_"+strPmCd[i]+spmCd+":strCycle===>"+ strCycle +" : strOldCycle===>"+strOldCycle);
			
			String strType = (String)paramMap.get("stmtType_"+strPmCd[i]+spmCd)==null? "":(String)paramMap.get("stmtType_"+strPmCd[i]+spmCd);
			String oldType = (String)paramMap.get("stmtType_"+strPmCd[i]+spmCd+"_old")==null? "":(String)paramMap.get("stmtType_"+strPmCd[i]+spmCd+"_old");
			
			if("07".equals(strPmCd[i])){
				map.put("oldStmtCycle", strOldCycle);
				map.put("stmtCycle", strCycle);
			}
			
			log.debug("stmtType_"+strPmCd[i]+spmCd+":strType===>"+ strType +" : oldType===>"+oldType);
			
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
		
		// 사용전환
		for(int i = 0; i < strPmCd.length; i++) 
		{
			String strUseCl = (String)paramMap.get("use_cl_"+strPmCd[i]+spmCd);
			String oldUseCl = (String)paramMap.get("use_cl_"+strPmCd[i]+spmCd+"_old");
			
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
		cuMap.put("cardUse", paramMap.get( "cardUse" ));
		cuMap.put("cardBlock", paramMap.get( "cardBlock" ));
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
				String stmtCycle = ((String)dataMap.get("stmtCycle")==""?"0":(String)dataMap.get( "stmtCycle" ));
				
				if(dataMap.get( "stmtType" ) == null || dataMap.get( "stmtType" )  == "")
				{
					dataMap.put( "stmtType", "0");
				}
				if(dataMap.get( "stmtCycle" ).equals( stmtCycleCd ))
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
    
    //가맹점 key 조회
    @Override
    public List< Map< String, Object > > selectMerchantKeyInfo(Map<String, Object> paramMap) throws Exception {
        return baseInfoMgmtDAO.selectMerchantKeyInfo(paramMap);
    }
    
    @Override
    public List<Map<String, Object>> selectSettleReqList(Map<String, Object> objMap) throws Exception{
    	List<Map<String, Object>> dataList = new ArrayList<Map<String,Object>>();
    	List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();

    	
    	//dataList = cardPaymentMgmtDAO.selectTransFailInfoList( objMap );
    	dataList = baseInfoMgmtDAO.selectSettleReqList( objMap );
    	
    	if(dataList.size() > 0 )
    	{
    		log.info( "dataList size : " + dataList.size() );
    		for(int i=0; i<dataList.size();i++)
    		{
    			Map<String, Object > map = dataList.get( i );
    			

    			resultList.add( map );
    			log.info( "MAP : " + map );
    		}
    	}
    	return resultList;
	}

    @Override
    public Object selectSettleReqListTotal(Map<String, Object> objMap) throws Exception{
    	return baseInfoMgmtDAO.selectSettleReqListTotal( objMap );
	}
    
    @Override
    public void updateSettleReqStatus(Map< String, Object > paramMap) throws Exception {
    	/*Map<String, Object> changeMap = new HashMap<String, Object>();
    	String tableNm = "TB_MBS";
		paramMap.put( "TABLE_NM", tableNm );
		paramMap.put( "ID_CD_VAL", "1" );
		paramMap.put( "MER_ID", paramMap.get("MID") );*/
		
		int result = baseInfoMgmtDAO.updateSettleReqStatus( paramMap );
		
    }
    
    @Override
    public void updateNormalInfo(Map< String, Object > paramMap) throws Exception {
		
		int result = baseInfoMgmtDAO.updateNormalInfo( paramMap );
		
    }
    
    @Override
    public void updateNormalGidInfo(Map< String, Object > paramMap) throws Exception {
		
		int result = baseInfoMgmtDAO.updateNormalGidInfo( paramMap );
		
    }
    
    @Override
    public void updateNormalVidInfo(Map< String, Object > paramMap) throws Exception {
		
		int result = baseInfoMgmtDAO.updateNormalVidInfo( paramMap );
		
    }
    
    @Override
    public void updateCancelTransPw(Map< String, Object > paramMap) throws Exception {
		
		int result = baseInfoMgmtDAO.updateCancelTransPw( paramMap );
		
    }
    
    @Override
    public void updateNormalTelInfo(Map< String, Object > paramMap) throws Exception {
		
		int result = baseInfoMgmtDAO.updateNormalTelInfo( paramMap );
		
    }
    
    @Override
    public void insertNotiTransInfo(Map< String, Object > paramMap) throws Exception {
		
		int result = baseInfoMgmtDAO.insertNotiTransInfo( paramMap );
		
    }
    
    @Override
    public void updateNotiTransInfo(Map< String, Object > paramMap) throws Exception {
		
		int result = baseInfoMgmtDAO.updateNotiTransInfo( paramMap );
			
    }
    
    @Override
    public int selectNotiTransInfo(Map<String, Object> paramMap) throws Exception 
    {
    	int logCount=0;
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	List< Map<String, Object>>	objList = new ArrayList<Map<String, Object>>();
    	List< Map< String, String > >	cateList = new ArrayList<Map< String, String >>();
    	log.info( "selectNotiTransInfo START" );
    	try
    	{
    		objList = baseInfoMgmtDAO.selectNotiTransInfo(paramMap);
    		resultMap.put( "resultCd", "0000" );
    	}
    	catch(Exception e)
    	{
    		 log.error( "selectNotiTransInfo-EXCEPTION : " , e );
    	}
    	
    	return objList.size();
    }
    
    @Override
    public Map<String, Object> selectNormalInfo(Map<String, Object> paramMap) throws Exception 
    {
    	int logCount=0;
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	List< Map<String, Object>>	objList = new ArrayList<Map<String, Object>>();
    	List< Map< String, String > >	cateList = new ArrayList<Map< String, String >>();
    	log.info( "selectNormalInfo START" );
    	try
    	{
    		objList = baseInfoMgmtDAO.selectNormalInfo(paramMap);
			if(objList.size() == 0 )
			{
				log.info( "selectNormalInfo-" +(logCount++) +"- 정보 없음" );
				resultMap.put( "resultCd", "9999" );
				return resultMap;
			}
			else 
			{
				log.info( "selectNormalInfo-" +(logCount++) +  "- 정보data : " + ToStringBuilder.reflectionToString( objList ) );
					
				resultMap.put( "midInfo", objList );
				
			}	
			
    		
    		resultMap.put( "resultCd", "0000" );
    	}
    	catch(Exception e)
    	{
    		 log.error( "selectNormalInfo-EXCEPTION : " , e );
    	}
    	
    	return resultMap;
    }
    
    
    @Override
    public Map<String, Object> selectNormalGidInfo(Map<String, Object> paramMap) throws Exception 
    {
    	int logCount=0;
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	List< Map<String, Object>>	objList = new ArrayList<Map<String, Object>>();
    	List< Map< String, String > >	cateList = new ArrayList<Map< String, String >>();
    	log.info( "selectNormalInfo START" );
    	try
    	{
    		objList = baseInfoMgmtDAO.selectNormalGidInfo(paramMap);
			if(objList.size() == 0 )
			{
				log.info( "selectNormalInfo-" +(logCount++) +"- 정보 없음" );
				resultMap.put( "resultCd", "9999" );
				return resultMap;
			}
			else 
			{
				log.info( "selectNormalInfo-" +(logCount++) +  "- 정보data : " + ToStringBuilder.reflectionToString( objList ) );
					
				resultMap.put( "midInfo", objList );
				
			}	
			
    		
    		resultMap.put( "resultCd", "0000" );
    	}
    	catch(Exception e)
    	{
    		 log.error( "selectNormalInfo-EXCEPTION : " , e );
    	}
    	
    	return resultMap;
    }
    
    
    @Override
    public Map<String, Object> selectNormalVidInfo(Map<String, Object> paramMap) throws Exception 
    {
    	int logCount=0;
    	Map<String, Object> resultMap = new HashMap<String, Object>();
    	List< Map<String, Object>>	objList = new ArrayList<Map<String, Object>>();
    	List< Map< String, String > >	cateList = new ArrayList<Map< String, String >>();
    	log.info( "selectNormalInfo START" );
    	try
    	{
    		objList = baseInfoMgmtDAO.selectNormalVidInfo(paramMap);
			if(objList.size() == 0 )
			{
				log.info( "selectNormalInfo-" +(logCount++) +"- 정보 없음" );
				resultMap.put( "resultCd", "9999" );
				return resultMap;
			}
			else 
			{
				log.info( "selectNormalInfo-" +(logCount++) +  "- 정보data : " + ToStringBuilder.reflectionToString( objList ) );
					
				resultMap.put( "midInfo", objList );
				
			}	
			
    		
    		resultMap.put( "resultCd", "0000" );
    	}
    	catch(Exception e)
    	{
    		 log.error( "selectNormalInfo-EXCEPTION : " , e );
    	}
    	
    	return resultMap;
    }
    
}
