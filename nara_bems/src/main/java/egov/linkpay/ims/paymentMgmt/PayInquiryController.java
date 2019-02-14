package egov.linkpay.ims.paymentMgmt;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonParser;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.paymentMgmt.service.CardPaymentMgmtService;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.Encrypt;

@Controller
@RequestMapping(value="/paymentMgmt/payInquiry")
public class PayInquiryController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="cardPaymentMgmtService")
	CardPaymentMgmtService cardPaymentMgmtService;
	
	@Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
	
	@Resource(name="baseInfoMgmtService")
	BaseInfoMgmtService baseInfoMgmtService;
	
	 // 결제내역조회 
	@RequestMapping(value="/payInquiry.do")
	public String acctPayInquiry(Model model, CommonMap commonMap) throws Exception {
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU",            "46");
		model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0018"));
		
		model.addAttribute("MER_SEARCH",          CommonDDLB.paySearchType1());
		model.addAttribute("PAY_SEARCH",          CommonDDLB.paySearchType2());
		model.addAttribute("Option_Chk",          CommonDDLB.OptionChk(DDLBType.CHECK));
		model.addAttribute("BankOption",          CommonDDLB.BankOption(DDLBType.SEARCH));
		model.addAttribute("SettleCycle",          CommonDDLB.SettleCycle(DDLBType.SEARCH));
		model.addAttribute("Status",          CommonDDLB.Status(DDLBType.SEARCH));
		model.addAttribute("Escrow",          CommonDDLB.Escrow(DDLBType.SEARCH));
		model.addAttribute("ConnFlg",          CommonDDLB.ConnFlg(DDLBType.SEARCH));
		model.addAttribute("DealFlg",          CommonDDLB.DealFlg(DDLBType.SEARCH));
		model.addAttribute("DateChk",          CommonDDLB.DateChk());
		
		return "/paymentMgmt/payInquiry/payInquiry";
	}
	
	//거래영수증 팝업
	@RequestMapping(value="/payReceiptPopup.do")
	public String payReceiptPopup(HttpServletRequest request, Model model, CommonMap commonMap) throws Exception {
		Map< String, Object > objMap = new HashMap<String, Object>();
		
		String tid =request.getParameter("tid");
		
		try{
			Map<String,Object> obj = cardPaymentMgmtService.selectRecpt(tid);
			model.addAttribute("data", obj);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		model.addAttribute("tid", tid);
		
		/*model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU",            "46");
		model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0018"));
		
		model.addAttribute("MER_SEARCH",          CommonDDLB.paySearchType1());
		model.addAttribute("PAY_SEARCH",          CommonDDLB.paySearchType2());
		model.addAttribute("Option_Chk",          CommonDDLB.OptionChk(DDLBType.CHECK));
		model.addAttribute("BankOption",          CommonDDLB.BankOption(DDLBType.SEARCH));
		model.addAttribute("SettleCycle",          CommonDDLB.SettleCycle(DDLBType.SEARCH));
		model.addAttribute("Status",          CommonDDLB.Status(DDLBType.SEARCH));
		model.addAttribute("Escrow",          CommonDDLB.Escrow(DDLBType.SEARCH));
		model.addAttribute("ConnFlg",          CommonDDLB.ConnFlg(DDLBType.SEARCH));
		model.addAttribute("DealFlg",          CommonDDLB.DealFlg(DDLBType.SEARCH));
		model.addAttribute("DateChk",          CommonDDLB.DateChk());*/
		
		return "/paymentMgmt/payInquiry/payReceiptPopup";
	}
	
	//결제관리 카드 total 정보 리스트 조회
    @RequestMapping(value = "/selectTransInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectTransInfoList(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception 
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	Map< String, Object > dataMap = new HashMap<String, Object>();
    	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
    	int intResultCode    = 0;
    	int intPageTotalCnt = 0;
    	String strResultMessage = "";
    	String frDt = "";
    	String toDt = "";
    	String merId = "";
        String merIdType = "";
        String searchFlg = "";
    	
    	JsonParser jsonParser = new JsonParser();
    	log.info( "카드 total 정보 리스트 조회- Start -" );
    	try 
    	{
    		HttpSession session = request.getSession(false);
 	   		
 	   		merId = session.getAttribute("MER_ID").toString();
 	   		merIdType = session.getAttribute("MER_ID_TYPE").toString();
 	   		
 	   		if(merIdType.equals("m")) {
 	   			searchFlg = "1";
 	   		}else if(merIdType.equals("g")) {
 	   			searchFlg = "2";
 	   		}else if(merIdType.equals("v")) {
 	   			searchFlg = "3";
 	   		}
 	   		
    		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
    		{
    			log.info( "strJsonParameter  : " + strJsonParameter );
    			objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	frDt= (String)objMap.get( "fromdate" );
	            frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "frDt", frDt );
	            toDt= (String)objMap.get( "todate" );
	            toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "toDt", toDt );
    			
	            objMap.put("searchFlg", searchFlg);
	 	   		objMap.put("txtSearch", merId);
	 	   		
	            CommonUtils.initSearchRange(objMap);
    			log.info( "카드 total 정보 리스트 조회- parameter : " + objMap );
    			
    			objList = 	cardPaymentMgmtService.selectTransInfoList(objMap);
    			//intPageTotalCnt = objList.size();
    			intPageTotalCnt = ( Integer ) cardPaymentMgmtService.selectTransInfoListTotal(objMap);
    			
    		}
    		else
    		{
    			log.info( "카드 total 정보 리스트 조회-1-파라미터 null " );
    		}
    		
    	}
    	catch(Exception e)
    	{
    		log.error( "카드 total 정보 리스트 조회-Exception : ", e );
    	}
    	finally
    	{
    		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
    	}
    	
    	objMv.setViewName("jsonView");
    	log.info( "카드 total 정보 리스트 조회- End -" );
    	return objMv; 
    }
    
    @RequestMapping(value="/selectPayInfoListExcel.do", method=RequestMethod.POST)
    public View selectPayInfoListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap, HttpServletRequest request) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        String merId = "";
        String merIdType = "";
        String searchFlg = "";
        
        try { 
       	 HttpSession session = request.getSession(false);
 	   		
 	   		 merId = session.getAttribute("MER_ID").toString();
 	   		 merIdType = session.getAttribute("MER_ID_TYPE").toString();
 	   		 
 	   		 if(merIdType.equals("m")) {
 	   		 	searchFlg = "1";
 	   		 }else if(merIdType.equals("g")) {
 	   		 	searchFlg = "2";
 	   		 }else if(merIdType.equals("v")) {
 	   		 	searchFlg = "3";
 	   		 }
 	   		
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String frDt = "";
        	 String toDt = ""; 
            frDt= (String)objMap.get( "fromdate" );
            frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
            objMap.put( "frDt", frDt );
            toDt= (String)objMap.get( "todate" );
            toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
            objMap.put( "toDt", toDt );
            
            objMap.put("searchFlg", searchFlg);
	 	   	 objMap.put("txtSearch", merId);
            
            objExcelData = cardPaymentMgmtService.selectTransInfoList(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectCardTransInfoList.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "pay_inquiry");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new PayListExcelGenerator();
    }
    
    //결제관리 카드 total 정보 리스트 excel
    @RequestMapping(value="/selectTransInfoListExcel.do", method=RequestMethod.POST)
     public View selectCardTransInfoListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap, HttpServletRequest request) throws Exception {
         Map<String,Object>       objMap           = new HashMap<String, Object>();        
         List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
         
         String merId = "";
         String merIdType = "";
         String searchFlg = "";
         
         try { 
        	 HttpSession session = request.getSession(false);
  	   		
  	   		 merId = session.getAttribute("MER_ID").toString();
  	   		 merIdType = session.getAttribute("MER_ID_TYPE").toString();
  	   		 
  	   		 if(merIdType.equals("m")) {
  	   		 	searchFlg = "1";
  	   		 }else if(merIdType.equals("g")) {
  	   		 	searchFlg = "2";
  	   		 }else if(merIdType.equals("v")) {
  	   		 	searchFlg = "3";
  	   		 }
  	   		
             objMap = CommonUtils.queryStringToMap(strJsonParameter);
             objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
             objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
             String frDt = "";
         	 String toDt = ""; 
             frDt= (String)objMap.get( "fromdate" );
             frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
             objMap.put( "frDt", frDt );
             toDt= (String)objMap.get( "todate" );
             toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
             objMap.put( "toDt", toDt );
             
             objMap.put("searchFlg", searchFlg);
	 	   	 objMap.put("txtSearch", merId);
             
             objExcelData = cardPaymentMgmtService.selectTransInfoList(objMap);
             
         } catch(Exception ex) {
             objExcelMap  = null;
             objExcelData = null;
             log.error("selectCardTransInfoList.do exception : " , ex);
         } finally {
             objExcelMap.put("excelName", "CARD_PAY_Infomation_List");
             objExcelMap.put("excelData", objExcelData);
             objExcelMap.put("reqData",   objMap);
         }
         
         return new PayListExcelGenerator();
     }
    
  //카드 세부정보  조회
    @RequestMapping(value = "/selectSerTidInfo.do", method=RequestMethod.POST)
    public ModelAndView selectSerTidInfo(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
         int intResultCode    = 0;
         int intPageTotalCnt = 0;
         String strResultMessage = "";
 	   	log.info( "카드 세부정보   조회 - Start -" );
 	   	try 
 	   	{
 	   	
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
 	           {
 	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
 	        	   log.info( "카드 세부정보   조회 - parameter : " + objMap );
 	        	   CommonUtils.initSearchRange(objMap);
 	        	   dataMap = 	cardPaymentMgmtService.selectSerTidInfo(objMap);
 	        	   objMv.addObject( "tidInfo", dataMap.get( "tidInfo" ) );
 	        	   objMv.addObject( "tidDetailLst", dataMap.get( "tidDetailLst" ) );
 	        	   //objMap.put( "empNo", commonMap.get( "USR_ID" ) );
 	        	   
 	        	   String empNo = objMap.get("USR_ID").toString(); 
 	        	   
 	        	  objMap.put( "empNo", empNo );
 	        	   objList = baseInfoMgmtService.selectEmpAuthSearch(objMap);
 	               objMv.addObject( "mngList" , objList);
 	           }
 	           else
 	           {
 	        	   log.info( "카드 세부정보   조회-1-파라미터 null " );
 	        	   intResultCode = 9999;
 	  	   		   strResultMessage = "data not exist";
 	           }
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "카드 세부정보   조회-Exception : ", e );
 	   		intResultCode = 9999;
 	   		strResultMessage = "fail";
 	   	}
 	   	finally
 	   	{
 	   		//objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	 	   	if (intResultCode == 0) 
	 	   	{
	            objMv = CommonUtils.resultSuccess(objMv);
	        }
	 	   	else 
	  	  	{
	            objMv = CommonUtils.resultFail(objMv, strResultMessage);
	        }
 	   	}
 	       
 	   	objMv.setViewName("jsonView");
 	   	log.info( "카드 세부정보   조회 - End -" );
 	    return objMv; 
    }
    
  //카드 세부정보   조회
    @RequestMapping(value = "/selectCardInfoAmt.do", method=RequestMethod.POST)
    public ModelAndView selectCardInfoAmt(@RequestBody String strJsonParameter, HttpServletRequest request) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView(); 
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
 	   	
 	   String frDt = "";
 	   String toDt = "";
       int intResultCode    = 0;
       int intPageTotalCnt = 0;
       String strResultMessage = "";
       String merId = "";
       String merIdType = "";
       String searchFlg = "";
       
 	   	log.info( "selectCardInfoAmt   조회 - Start -" );
 	   	try 
 	   	{
 	   		HttpSession session = request.getSession(false);
 	   		
 	   		merId = session.getAttribute("MER_ID").toString();
 	   		merIdType = session.getAttribute("MER_ID_TYPE").toString();
 	   		
 	   		if(merIdType.equals("m")) {
 	   			searchFlg = "1";
 	   		}else if(merIdType.equals("g")) {
 	   			searchFlg = "2";
 	   		}else if(merIdType.equals("v")) {
 	   			searchFlg = "3";
 	   		}
       	
	 	   	if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
			{
				log.info( "strJsonParameter  : " + strJsonParameter );
				objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	frDt= (String)objMap.get( "fromdate" );
	            frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "frDt", frDt );
	            toDt= (String)objMap.get( "todate" );
	            toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "toDt", toDt );
	            
	            objMap.put("searchFlg", searchFlg);
	 	   		objMap.put("txtSearch", merId);
				
	            CommonUtils.initSearchRange(objMap);
				log.info( "카드 total 정보 리스트 조회- parameter : " + objMap );
				
				objList = 	cardPaymentMgmtService.selectCardInfoAmt(objMap);
				
				
			}
			else
			{
				log.info( "selectCardInfoAmt 조회-1-파라미터 null " );
			}
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "selectCardInfoAmt   조회-Exception : ", e );
 	   		intResultCode = 9999;
 	   		strResultMessage = "fail";
 	   	}
 	   	finally
 	   	{
 	   	objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
 	   	}
 	       
 	   	objMv.setViewName("jsonView");
 	   	log.info( "카드 세부정보   조회 - End -" );
 	    return objMv; 
    }
    
  //카드 세부정보   조회
    @RequestMapping(value = "/selectCardTotalAmt.do", method=RequestMethod.POST)
    public ModelAndView selectCardTotalAmt(@RequestBody String strJsonParameter, HttpServletRequest request) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	List< Map<String, Object>> dataMap = new ArrayList<Map<String, Object>>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
         int intResultCode    = 0;
         int intPageTotalCnt = 0;
         String strResultMessage = "";
         
         String merId = "";
         String merIdType = "";
         String searchFlg = "";
         
 	   	log.info( "카드 세부정보   조회 - Start -" );
 	   	try 
 	   	{
 	   		HttpSession session = request.getSession(false);
	   		
	   		merId = session.getAttribute("MER_ID").toString();
	   		merIdType = session.getAttribute("MER_ID_TYPE").toString();
	   		
	   		if(merIdType.equals("m")) {
	   			searchFlg = "1";
	   		}else if(merIdType.equals("g")) {
	   			searchFlg = "2";
	   		}else if(merIdType.equals("v")) {
	   			searchFlg = "3";
	   		}
	   		
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
            {
        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
        	   log.info( "카드 세부정보   조회 - parameter : " + objMap );
        	   String frDt = "";
        	   String toDt = "";
        	   frDt= (String)objMap.get( "fromdate" );
               frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
               objMap.put( "frDt", frDt );
               
               toDt= (String)objMap.get( "todate" );
               toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
               objMap.put( "toDt", toDt );
               
               objMap.put("searchFlg", searchFlg);
	 	   	   objMap.put("txtSearch", merId);
	 	   		
        	   log.info( "카드 세부정보   조회 - parameter : " + objMap );
        	   CommonUtils.initSearchRange(objMap);
        	   dataMap = 	cardPaymentMgmtService.selectCardInfoTotAmt(objMap);
        	   objMv.addObject( "data", dataMap );
            }
            else
            {
        	   log.info( "카드 세부정보   조회-1-파라미터 null " );
            }
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "카드 세부정보   조회-Exception : ", e );
 	   		intResultCode = 9999;
 	   		strResultMessage = "fail";
 	   	}
 	   	finally
 	   	{
	 	   	if (intResultCode == 0) 
	  	  {
	            objMv = CommonUtils.resultSuccess(objMv);
	        }
	  	  else 
	  	  {
	            objMv = CommonUtils.resultFail(objMv, strResultMessage);
	        }
 	   	}
 	       
 	   	objMv.setViewName("jsonView");
 	   	log.info( "카드 세부정보   조회 - End -" );
 	    return objMv; 
    }
    
    //카드 세부정보   조회
    @RequestMapping(value = "/sendCancelHandShake.do", method=RequestMethod.POST)
    public ModelAndView sendCancelHandShake(@RequestBody String strJsonParameter, HttpServletRequest request) throws Exception 
    {
 	   	 ModelAndView objMv  = new ModelAndView();
 	   	 Map< String, Object > objMap = new HashMap<String, Object>();
 	   	 Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	 Map< String, Object > ret = new HashMap<String, Object>();
 	    	   	
 	     Encrypt enc = new Encrypt(); 
 	     int intResultCode    = 0;
	     
	     String inParam = "";	     

	    // IFPCP212 거래취소
	     String ifId = "IFPCP212";
	     String mId = "";//(String)inParam.get("mid");
	     
	    // 가맹점 key	
	     String mbsKey = "";//"APG/phkhRDXEYznhW8HSyqVQgoRAElgQ21DQMBNYfuKm0univreJzanQbJZ/V+Fcr9FOAconvKJ1PW27rqUzPw==";	
	     String url = "http://1.227.122.150:8085/mbs/mncaction.erom";
	     //url = "http://localhost:8085/mbs/mncaction.erom";         
	    
	     
 	   	log.info( "취소전문 HandShake 발송  - Start -" ); 	   	
 	   	try 
 	   	{ 	
 	   		objMap = CommonUtils.jsonToMap(strJsonParameter);
 	   		mbsKey = (String) objMap.get("MBS_KEY");
 	   		mId = (String) objMap.get("MID");
 	   		inParam = "{" 
	   				   +"'tid':'" + objMap.get("TID") +"'," 			//거래 ID
	   				   +"'app_no':'" + objMap.get("APP_NO")+"'," 		//승인번호 
	   				   +"'app_dt':'" + objMap.get("APP_DT")+"',"		//거래일자	
	   				   +"'reg_id':'" + objMap.get("REG_ID")+"',"		//요청자 ID
	   				   +"'pin':'" + objMap.get("CC_PASSWORD")+"',"		//결제취소 비밀번호
	   				   +"'goods_amt':'" + objMap.get("GOODS_AMT")+"',"	//거래금액
	   				   +"'reason_desc':'" + objMap.get("REASON_DESC")+"'"	//취소사유
	   				   +"}";
 	   				   
            HttpURLConnection conn = (HttpURLConnection)(new URL(url)).openConnection();

            conn.setDoOutput(true);

            conn.setRequestMethod("POST");

            conn.setRequestProperty("Content-Type", "text/plain");

            conn.setRequestProperty("if_id", ifId);

            conn.setRequestProperty("i_mid", mId);

           

            PrintWriter out = new PrintWriter(new OutputStreamWriter(conn.getOutputStream()));

           

           // JSON String에서 암호화된 전문으로 parse

            //String param = new ObjectMapper().writeValueAsString(inParam);

            String encParam = enc.getAes256Message(inParam, mbsKey, "enc");

            out.write(encParam);

            out.flush();

           
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

            StringBuffer buf = new StringBuffer();

            String line = null;

            while((line = in.readLine()) != null) {

                      buf.append(line);

            }

            System.out.println(buf.toString());

            // 복호화된 전문 -> getAes256Message(buf.toString(), mbsKey, "dec")
            ret = new ObjectMapper().readValue(enc.getAes256Message(buf.toString(), mbsKey, "dec"), Map.class);
            intResultCode = Integer.parseInt(ret.get("result_code").toString());
            out.close();

            in.close();
 	           
 	   	}
		catch(MalformedURLException e) {
		
		        e.printStackTrace();
		
		}catch(IOException e) {
		
		        e.printStackTrace();
		
		}catch(Exception e) {
		
		        e.printStackTrace();
		
		}
 	   	finally
 	   	{
	 	   	if (intResultCode == 0000) 
	 	   	{
	            objMv = CommonUtils.resultSuccess(objMv);
	        }
	 	   	else 
	  	  	{
	            objMv = CommonUtils.resultFail(objMv, ret.get("result_message").toString());
	        }
 	   	}
 	       
 	   	objMv.setViewName("jsonView");
 	   	objMv.addObject("ret", ret);
 	   	log.info( "취소전문 HandShake 발송 - End -" );
 	    return objMv; 
    }
    
    @RequestMapping(value = "/sendCancel.do", method=RequestMethod.POST)
    public ModelAndView sendCancel(@RequestBody String strJsonParameter, HttpServletRequest request) throws Exception 
    {
 	   	 ModelAndView objMv  = new ModelAndView();
 	   	 Map< String, Object > objMap = new HashMap<String, Object>();
 	   	 Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	 Map< String, Object > ret = new HashMap<String, Object>();
 	    	   	
 	     Encrypt enc = new Encrypt(); 
 	     int intResultCode    = 0;
	     
	     String inParam = "";	     

	    // IFPCP212 거래취소
	     String ifId = "IFPCP258";
	     String mId = "";//(String)inParam.get("mid");
	     
	    // 가맹점 key	
	     String mbsKey = "";	
	     String url = "http://1.227.122.150:8085/mbs/mncaction.erom";
	     //url = "http://localhost:8085/mbs/mncaction.erom";         
	    
	     
 	   	log.info( "취소전문 발송  - Start -" ); 	   	
 	   	try 
 	   	{ 	
 	   		objMap = CommonUtils.jsonToMap(strJsonParameter);
 	   		mbsKey = (String) objMap.get("MBS_KEY");
 	   		mId = (String) objMap.get("MID");
 	   		inParam = "{" 
 	   				   +"'tid':'" + objMap.get("TID") +"'," 			//거래 ID
 	   				   +"'app_no':'" + objMap.get("APP_NO")+"'," 		//승인번호 
 	   				   +"'app_dt':'" + objMap.get("APP_DT")+"',"		//거래일자	
 	   				   +"'goods_amt':'" + objMap.get("GOODS_AMT")+"',"	//거래금액
 	   				   +"'reg_id':'" + objMap.get("REG_ID")+"',"		//요청자 ID
 	   				   +"'cc_seq':'" + objMap.get("CC_SEQ")+"'"			//취소거래순번
 	   				   +"}";
 	   				   
            HttpURLConnection conn = (HttpURLConnection)(new URL(url)).openConnection();

            conn.setDoOutput(true);

            conn.setRequestMethod("POST");

            conn.setRequestProperty("Content-Type", "text/plain");

            conn.setRequestProperty("if_id", ifId);

            conn.setRequestProperty("i_mid", mId);

           

            PrintWriter out = new PrintWriter(new OutputStreamWriter(conn.getOutputStream()));

           

           // JSON String에서 암호화된 전문으로 parse

            //String param = new ObjectMapper().writeValueAsString(inParam);

            String encParam = enc.getAes256Message(inParam, mbsKey, "enc");

            out.write(encParam);

            out.flush();

           
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

            StringBuffer buf = new StringBuffer();

            String line = null;

            while((line = in.readLine()) != null) {
                      buf.append(line);
            }

            System.out.println(buf.toString());

            // 복호화된 전문 -> getAes256Message(buf.toString(), mbsKey, "dec")
            ret = new ObjectMapper().readValue(enc.getAes256Message(buf.toString(), mbsKey, "dec"), Map.class);
            intResultCode = Integer.parseInt(ret.get("result_code").toString());
            out.close();

            in.close();
            conn.disconnect();
 	           
 	   	}
		catch(MalformedURLException e) {
		
		        e.printStackTrace();
		
		}catch(IOException e) {
		
		        e.printStackTrace();
		
		}catch(Exception e) {
		
		        e.printStackTrace();
		
		}
 	   	finally
 	   	{
	 	   	if (intResultCode == 0000) 
	 	   	{
	            objMv = CommonUtils.resultSuccess(objMv);
	        }
	 	   	else 
	  	  	{
	            objMv = CommonUtils.resultFail(objMv, ret.get("result_message").toString());
	        }
 	   	}
 	       
 	   	objMv.setViewName("jsonView");
 	   	objMv.addObject("ret", ret);
 	   	log.info( "취소전문 발송 - End -" );
 	    return objMv; 
    }     
}
