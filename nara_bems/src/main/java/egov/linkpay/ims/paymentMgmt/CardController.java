package egov.linkpay.ims.paymentMgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.businessmgmt.CoApprInfoVListExcelGenerator;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.paymentMgmt.service.CardPaymentMgmtService;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

@Controller
@RequestMapping(value="/paymentMgmt/card")
public class CardController
{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="cardPaymentMgmtService")
	CardPaymentMgmtService cardPaymentMgmtService;
	
	@Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
	
	@Resource(name="baseInfoMgmtService")
	BaseInfoMgmtService baseInfoMgmtService;
	
	@RequestMapping(value="/cardPayInquiry.do")
    public String cardPayInquiry(Model model, CommonMap commonMap) throws Exception {
	 	log.info( "결제관리 신용카드 -Start -" );
    	List< Map< String, String > > listMap = new ArrayList<>();
    	Map< String, String > dataMap = new HashMap< String, String >();
    	
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "42");   //신용카드 결제 내역 조회 
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0074"));
        
        model.addAttribute("MER_SEARCH",          CommonDDLB.RefSearchFlg(DDLBType.SEARCH));
        model.addAttribute("Status",          CommonDDLB.Status(DDLBType.SEARCH));
        model.addAttribute("Escrow",          CommonDDLB.Escrow(DDLBType.SEARCH));
        model.addAttribute("DealFlg",          CommonDDLB.DealFlg(DDLBType.SEARCH));
        model.addAttribute("DateChk",          CommonDDLB.DateChk());
        model.addAttribute("Flg_Chk",          CommonDDLB.FlgChk(DDLBType.CHECK));
        
        
    	/*log.info( "결제관리 신용카드 -1- 정산주기" );
    	dataMap.put( "CODE_CL", "0038" );
    	listMap = baseInfoRegistrationService.selectCodeCl((String)dataMap.get( "CODE_CL" ));
    	model.addAttribute("SettleCycle", CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
    	
    	log.info( "결제관리 신용카드 -1- 카드 리스트 " );
    	dataMap.put( "CODE_CL", "0002" );
    	listMap = baseInfoRegistrationService.selectCodeCl((String)dataMap.get( "CODE_CL" ));
    	model.addAttribute("CARD_SEARCH",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
    	
    	log.info( "결제관리 신용카드 -1- 대행/직가맹 구분" );
    	dataMap.put( "CODE_CL", "0012" );
    	listMap = baseInfoRegistrationService.selectCodeCl((String)dataMap.get( "CODE_CL" ));
    	model.addAttribute("TYPE_CHK",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
    	
    	
    	log.info( "결제관리 신용카드 -1- 접속구분" );
    	dataMap.put( "CODE_CL", "0075" );
    	listMap = baseInfoRegistrationService.selectCodeCl((String)dataMap.get( "CODE_CL" ));
    	model.addAttribute("ConnFlg",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        
    	log.info( "결제관리 신용카드 -1- 인증타입" );
    	dataMap.put( "CODE_CL", "0057" );
    	listMap = baseInfoRegistrationService.selectCodeCl((String)dataMap.get( "CODE_CL" ));
    	model.addAttribute("cardCertList",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));*/
    	
        return "/paymentMgmt/card/cardPayInquiry";
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
    	
    	JsonParser jsonParser = new JsonParser();
    	log.info( "카드 total 정보 리스트 조회- Start -" );
    	try 
    	{
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
    			
	            CommonUtils.initSearchRange(objMap);
    			log.info( "카드 total 정보 리스트 조회- parameter : " + objMap );
    			
    			objList = 	cardPaymentMgmtService.selectTransInfoList(objMap);
    			intPageTotalCnt = objList.size();
//    			intPageTotaCnt = ( Integer ) cardPaymentMgmtService.selectTransInfoListTotal(objMap);
    			
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
    //결제관리 카드 total 정보 리스트 excel
    @RequestMapping(value="/selectCardTransInfoListExcel.do", method=RequestMethod.POST)
     public View selectCardTransInfoListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
         Map<String,Object>       objMap           = new HashMap<String, Object>();        
         List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
         
         try { 
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
         
         return new CardInfoListExcelGenerator();
     }
    //카드 세부정보   조회
    @RequestMapping(value = "/selectCardInfoAmt.do", method=RequestMethod.POST)
    public ModelAndView selectCardInfoAmt(@RequestBody String strJsonParameter) throws Exception 
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
 	   	objList = 	cardPaymentMgmtService.selectCardInfoAmt(objMap);
        	  //objMv.addObject( "data", dataMap );
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "카드 세부정보   조회-Exception : ", e );
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
 	        	   objMap.put( "empNo", commonMap.get( "USR_ID" ) );
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
    
  //결제관리 카드 total 정보 리스트 조회
    @RequestMapping(value = "/selectTransInfoTotalList.do", method=RequestMethod.POST)
    public ModelAndView selectTransInfoTotalList(@RequestBody String strJsonParameter) throws Exception 
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
    	
    	log.info( "카드 total 정보 리스트 조회- Start -" );
    	try 
    	{
    		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
    		{
    			objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	frDt= (String)objMap.get( "fromdate" );
	            frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "frDt", frDt );
	            toDt= (String)objMap.get( "todate" );
	            toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "toDt", toDt );
    			
	            CommonUtils.initSearchRange(objMap);
    			log.info( "카드 total 정보 리스트 조회- parameter : " + objMap );
    			
    			objList = 	cardPaymentMgmtService.selectTransInfoTotalList(objMap);
    			
    			intPageTotalCnt = ( Integer ) cardPaymentMgmtService.selectTransInfoTotalListTotal(objMap);
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
  //카드 세부정보   조회
    @RequestMapping(value = "/selectCardTotalAmt.do", method=RequestMethod.POST)
    public ModelAndView selectCardTotalAmt(@RequestBody String strJsonParameter) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   List<Map<String,Object>> dataMap = new ArrayList<Map<String, Object>>();
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
	        	   String frDt = "";
	        	   String toDt = "";
 	        	   frDt= (String)objMap.get( "fromdate" );
	               frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	               objMap.put( "frDt", frDt );
	               
	               toDt= (String)objMap.get( "todate" );
	               toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	               objMap.put( "toDt", toDt );
	               
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
    //카드 비밀번호 체크 
    @RequestMapping(value = "/selectPwChk.do", method=RequestMethod.POST)
    public ModelAndView selectPwChk(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception 
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
 	        	   dataMap = 	cardPaymentMgmtService.selectPwChk(objMap);
 	        	   objMv.addObject( "data", dataMap );
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

    //소보법메일 발송  
    @RequestMapping(value = "/selectMailSendSearch.do", method=RequestMethod.POST)
    public ModelAndView selectMailSendSearch(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
         int intResultCode    = 0;
         int intPageTotalCnt = 0;
         String strResultMessage = "";
 	   	log.info( "소보법메일 발송   - Start -" );
 	   	try 
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
 	           {
 	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
 	        	   String frDt = "";
	        	   String toDt = "";
	        	   frDt= (String)objMap.get( "fromdate" );
	               frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	               objMap.put( "frDt", frDt );
	               
	               toDt= (String)objMap.get( "todate" );
	               toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	               objMap.put( "toDt", toDt );
	               CommonUtils.initSearchRange(objMap);
 	        	   log.info( "소보법메일 발송   - parameter : " + objMap );
 	        	   dataMap = 	cardPaymentMgmtService.selectMailSendSearch(objMap);
 	        	   objMv.addObject( "data", dataMap.get( "dataMap" ) );
 	        	   objMv.addObject( "dataList", dataMap.get( "dataList" ) );
 	           }
 	           else
 	           {
 	        	   log.info( "소보법메일 발송  -1-파라미터 null " );
 	        	   intResultCode = 9999;
 	  	   		   strResultMessage = "data not exist";
 	           }
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "소보법메일 발송  -Exception : ", e );
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
 	    //objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);     
 	   	objMv.setViewName("jsonView");
 	   	log.info( "소보법메일 발송   - End -" );
 	    return objMv; 
    }
    //신용카드 실시간 승인 현황
	 @RequestMapping(value="/cardRealTimeChk.do")
    public String cardRealTimeChk(Model model, CommonMap commonMap) throws Exception {
		List< Map< String, String > > listMap = new ArrayList<>();
		Map< String, String > dataMap = new HashMap< String, String >();
		 
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "44");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0076"));
    
        
        log.info( "결제관리 신용카드 -1- 카드 리스트 " );
    	dataMap.put( "CODE_CL", "0002" );
    	listMap = baseInfoRegistrationService.selectCodeCl((String)dataMap.get( "CODE_CL" ));
    	model.addAttribute("CARD_SEARCH",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        
        
        return "/paymentMgmt/card/cardRealTimeChk";
    }
	 
	//결제관리 카드 total 정보 리스트 조회
	    @RequestMapping(value = "/selectCheckCardEventList.do", method=RequestMethod.POST)
	    public ModelAndView selectCheckCardEventList(@RequestBody String strJsonParameter) throws Exception 
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
	    	
	    	log.info( "카드 event 정보 리스트 조회- Start -" );
	    	try 
	    	{
	    		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	    		{
	    			objMap = CommonUtils.jsonToMap(strJsonParameter);
		        	frDt= (String)objMap.get( "fromdate" );
		            frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
		            objMap.put( "frDt", frDt );
		            toDt= (String)objMap.get( "todate" );
		            toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
		            objMap.put( "toDt", toDt );
	    			
		            CommonUtils.initSearchRange(objMap);
	    			log.info( "카드 event  정보 리스트 조회- parameter : " + objMap );
	    			
	    			objList = 	cardPaymentMgmtService.selectCheckCardEventList(objMap);
	    			
	    			intPageTotalCnt = ( Integer ) cardPaymentMgmtService.selectCheckCardEventListTotal(objMap);
	    		}
	    		else
	    		{
	    			log.info( "카드 event  정보 리스트 조회-1-파라미터 null " );
	    		}
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		log.error( "카드 event  정보 리스트 조회-Exception : ", e );
	    	}
	    	finally
	    	{
	    		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	    	}
	    	
	    	objMv.setViewName("jsonView");
	    	log.info( "카드 event  정보 리스트 조회- End -" );
	    	return objMv; 
	    }
	    //결제관리 카드 total 정보 리스트 excel
	    @RequestMapping(value="/selectCheckCardEventListExcel.do", method=RequestMethod.POST)
	     public View selectCheckCardEventListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	         Map<String,Object>       objMap           = new HashMap<String, Object>();        
	         List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	         
	         try { 
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
	             
	             objExcelData = cardPaymentMgmtService.selectCheckCardEventList(objMap);
	             
	         } catch(Exception ex) {
	             objExcelMap  = null;
	             objExcelData = null;
	             log.error("selectCardTransInfoList.do exception : " , ex);
	         } finally {
	             objExcelMap.put("excelName", "card_event_Infomation_List");
	             objExcelMap.put("excelData", objExcelData);
	             objExcelMap.put("reqData",   objMap);
	         }
	         
	         return new CardInfoListExcelGenerator();
	     }
	 
}
