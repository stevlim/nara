package egov.linkpay.ims.operMgmt.service;

import java.io.BufferedReader;
import java.io.FileReader;
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
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.operMgmt.dao.OperMgmtDAO;
import egov.linkpay.ims.util.SHA256Util;

@Service("operMgmtService")
public class OperMgmtServiceImpl implements OperMgmtService
{
	Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="operMgmtDAO")
    private OperMgmtDAO operMgmtDAO;
    
    @Override
    public List<Map<String, Object>> uploadCashFailReReq(Map<String, Object> objMap) throws Exception {
    	CommonUtils commonUtils = new CommonUtils();
    	log.info( "uploadCashFailReReq-START-" );
    	int logCount = 0 ;
    	List<Map<String, Object>> aLst = new ArrayList<Map<String, Object>>();
		
		String strFilePath = (String)objMap.get( "filePath" );
		log.info( "uploadCashFailReReq-"+(logCount++) + "filePath : " + strFilePath);	
		BufferedReader in = new BufferedReader(new FileReader(strFilePath));
			
		int iCnt = 1;
		int iRtn = 0;

	    try {
	              		
			for(String line; (line = in.readLine ()) != null;){
			    line = line.replace(",,", ", ,");
			    line = line.replace(",,", ", ,");
			    line = line + " ";
			    log.info( "line  : " + line );
			    StringTokenizer token = new StringTokenizer(line, ",");
	  			int cntToken = token.countTokens();

	  			
	  			String strOrgTID = "";
	  			String strReceiptType = "";
	  			String strPublishType = "";
	  			String strRcptId= "";
			  
	  			Map<String, Object> dataMap = new HashMap<String, Object>();
			  	Map<String, Object> map = new HashMap<String, Object>();
				
				  if(cntToken == 0){}
				  else if(cntToken ==4){		// 5 개의 인자가 모두 있다면 
					
	  				strOrgTID = token.nextToken().trim();
	  		        strReceiptType = token.nextToken().trim();	  		        
	  		        strPublishType = token.nextToken().trim();
	  		        strRcptId = token.nextToken().trim();
	  		        
	  		        log.info( "strOrgTID : " + strOrgTID );
	  		        log.info( "strReceiptType : " + strReceiptType );
	  		        log.info( "strPublishType : " + strPublishType );
	  		        log.info( "strRcptId : " + strRcptId );
	  		        	
	  		        map.put( "orgTid", strOrgTID );
	  		      /*  if(strReceiptSupplyAmt.length() < 1) strReceiptSupplyAmt = "0";
	  		        if(strReceiptVAT.length() < 1) strReceiptVAT = "0";
	  		        if(strReceiptServiceAmt.length() < 1) strReceiptServiceAmt = "0";
	  		        */
	  		        
	  		        // Chk Dup
	  		        if(Integer.parseInt(operMgmtDAO.selectCntRcptOrgTid(map).toString()) > 0) {
	  		        	dataMap.put("line", iCnt);
	  		        	dataMap.put("desc", "[[" + strOrgTID +"] 원거래에 대한 현금영수증 발행건이 존재합니다." );
	  		        	aLst.add(dataMap);
	  		        	log.info( "중복 체크 ERROR dataMap : "+ dataMap );
	  		        	iCnt++;
	  		        	
	  		        	continue;
	  		        }
	  		        /*			
				    // 결제금액 확인
	  		  	    if(strReceiptAmt.trim().length() == 0) {
	  		  	    	dataMap.put("line", iCnt);
	  		  	    	dataMap.put("desc", "[결제금액은 필수 입력 항목입니다.]");
	  		  	    	aLst.add(dataMap);
	  				      
	  		  	    	iCnt++;
	  				      			    
	  		  	    	continue;
	  		  	    }	  		        
	  				    // 공급가액 확인
	  		  	    if(strReceiptSupplyAmt.trim().length() == 0) {
	  		  	    	dataMap.put("line", iCnt);
	  			  	    dataMap.put("desc", "[공급가액은 필수 입력 항목입니다. 구분이 안될시에는 0을 입력하세요]");
	  			  	    aLst.add(dataMap);
	  				      
	  				      iCnt++;
	  				      
	  				      continue;
	  				    }
	  				    // VAT 확인
	  		  	    if(strReceiptVAT.trim().length() == 0) {
	  		  	    	dataMap.put("line", iCnt);
	  			  	    dataMap.put("desc", "[VAT는 필수 입력 항목입니다. 구분이 안될시에는 0을 입력하세요]");
	  			  	    aLst.add(dataMap);
	  				      
	  				    iCnt++;
	  				      
	  				    continue;
	  		  	    }
	  				    // 봉사료 확인
	  		  	    if(strReceiptServiceAmt.trim().length() == 0) {
	  		  	    	dataMap.put("line", iCnt);
	  			  	    dataMap.put("desc", "[봉사료는 필수 입력 항목입니다. 구분이 안될시에는 0을 입력하세요]");
	  			  	    aLst.add(dataMap);
	  				      
	  				    iCnt++;
	  				      
	  				    continue;
	  		  	    }
	  		  	    
				    int iGoodsAmt 	= Integer.parseInt(strReceiptAmt);
				    int iSupplyAmt 	= Integer.parseInt(strReceiptSupplyAmt);
				    int iGoodsVat 	= Integer.parseInt(strReceiptVAT);
				    int iSvsAmt 	= Integer.parseInt(strReceiptServiceAmt);
				    int iTotAmt 	= iSupplyAmt + iGoodsVat + iSvsAmt;

				    if(iGoodsAmt != iTotAmt) {
				      dataMap.put("line", iCnt);
				      dataMap.put("desc", "[결제금액("+iGoodsAmt+")은 공급가액, VAT, 봉사료의 합("+iTotAmt+")과 같아야합니다.]");
				      aLst.add(dataMap);
				      
				      iCnt++;
				      
				      continue;
				    }
				    */
  	  			    // 발행번호 입력 여부 확인
	  		  	    if(strPublishType.trim().length() == 0) {
	  		  	    	dataMap.put("line", iCnt);
	  			  	    dataMap.put("desc", "[발행구분은 필수 입력 항목입니다.]");
	  			  	    aLst.add(dataMap);
	  			  	    log.info( "발행구분 확인 ERROR dataMap : "+ dataMap );
	  				    iCnt++;
	  				      
	  				    continue;
	  		  	    }
	  		  	    
	  				    // 영수증 id 입력 여부 확인
	  		  	    if(strRcptId.trim().length() == 0) {
	  		  	    	dataMap.put("line", iCnt);
	  			  	    dataMap.put("desc", "[발행번호는 필수 입력 항목입니다.]");
	  			  	    log.info( "발행 번호 ERROR dataMap : "+ dataMap );
	  			  	    aLst.add(dataMap);
	  				      
	  				    iCnt++;
	  				      
	  				      continue;
	  		  	    }else{
	  		  	    	int identityLen = strRcptId.length();
	  		  	    	
	  		  	    	if(strPublishType.equals( "4" )){
	  		  	    		if(!(identityLen==10 || identityLen==11)){
	  		  	  	  	      dataMap.put("line", iCnt);
	  		  	  	  	      dataMap.put("desc", "[휴대폰번호는 10~11자리 입니다.]");
	  		  	  	  	      aLst.add(dataMap);
	  		  	  	  	      log.info( "휴대폰 번호 ERROR dataMap : "+ dataMap );
	  		  	  	  	      iCnt++;
	  						      
  						      continue;	 
	  		  	    		}
	  		  	    	}else if(strPublishType.equals( "2" )){
	  		  	    		if(identityLen!=13){
	  		  	    			dataMap.put("line", iCnt);
	  						  	dataMap.put("desc", "[주민등록번호는 13자리 입니다.]");
	  						  	aLst.add(dataMap);
	  						  	log.info( "주민등록 번호 ERROR dataMap : "+ dataMap );
	  							iCnt++;
	  							      
	  							continue;	 
	  		  	    		}else{
	  		  	    			if(!commonUtils.Regist_Check(strRcptId)){
	  		  	  	  	  	      dataMap.put("line", iCnt);
	  						  	    dataMap.put("desc", "[주민등록번호가 유효하지 않습니다.]");
	  						  	    aLst.add(dataMap);
	  						  	    log.info( "주민등록번호 유효성 ERROR dataMap : "+ dataMap );
	  							      iCnt++;
	  							      
	  							      continue;	 
	  		  	    			}
	  		  	    		}
	  		  	    	}else if(strPublishType.equals( "3" )){
	  		  	    		if("1".equals(strReceiptType)){
	  		  	    			dataMap.put("line", iCnt);
	  		  	    			dataMap.put("desc", "[사업자번호는 지출증빙용에만 사용하실 수 있습니다.]");
	  		  	    			aLst.add(dataMap);
	  		  	    			log.info( "사업자 번호 ERROR dataMap : "+ dataMap );
	  		  	    			iCnt++;
	  		  				      
	  		  	    			continue;	  	 
	  		  	    		}
	  		  	    	}else{
	  		  	  	      	dataMap.put("line", iCnt);
	  				  	    dataMap.put("desc", "[유효하지 않은 발행구분 값이 입력되었습니다. 확인바랍니다.]");
	  				  	    aLst.add(dataMap);
	  				  	    log.info( "발행구분 ERROR dataMap : "+ dataMap );
	  				  	    iCnt++;
	  					      
	  				  	    continue;	  	    		
	  		  	    	}
	  		  	    }   
	  	  
	  		  	    //지출증빙은 사업자번호로 요청했을때만
	  				if(strReceiptType.equals( "1" )&& strRcptId.length() == 10 && !commonUtils.HhpNum_Check(strRcptId)) {
	  					dataMap.put("line", iCnt);
	  			  	    dataMap.put("desc", "[사업자번호가 유효하지 않거나 지출증빙용을 선택하지 않았습니다.]");
	  			  	    aLst.add(dataMap);
	  			  	    log.info( "지출 증빙 ERROR dataMap : "+ dataMap );
	  				    iCnt++;
	  	            
	  				    continue;
	  				} 
	  		        	  		        
	  		        map.put("orgTid", strOrgTID);
	  		        map.put("pubType", strPublishType);
	  		        map.put("reqType", strReceiptType);	  		        
	  		        map.put("rcptId", strRcptId);
	  		        String strRcptIdEnc = SHA256Util.encrypt( strRcptId );  
	  		        map.put("rcptIdEnc", strRcptIdEnc);
	  		        
	  		        iRtn = (int)operMgmtDAO.insertFailCashReReq(map);
	  		        
	  		        if(iRtn == 0) {
	  		        	dataMap.put("line", iCnt);
				    	dataMap.put("desc", "[생성 실패. 원거래 및 MID존재여부를 확인하세요.]");
				    	aLst.add(dataMap);
				    	log.info( "생성 실패 ERROR dataMap : "+ dataMap );
					    iCnt++;
					    
					    continue;
	  		        }
	  		        
			    }else{			    	
			    	dataMap.put("line", iCnt);
			    	dataMap.put("desc", "[입력값이 4개가 아닙니다. 제공포맷에 맞게 고쳐서 다시 입력하여 주십시요.]");
			    	log.info( "dataMap : "+ dataMap );
			    	aLst.add(dataMap);
			    	log.info( "입력값 ERROR dataMap : "+ dataMap );
				    iCnt++;
				    
				    continue;
	  		  }
	      
				iCnt++;
	      }
	    }catch(Exception e){
	    	log.error( "Exception : " , e);
    	}
	    return aLst; 
    }
}
