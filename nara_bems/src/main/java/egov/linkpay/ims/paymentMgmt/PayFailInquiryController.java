package egov.linkpay.ims.paymentMgmt;

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

@Controller
@RequestMapping(value="/paymentMgmt/payFailInquiry")
public class PayFailInquiryController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="cardPaymentMgmtService")
	CardPaymentMgmtService cardPaymentMgmtService;
	
	@Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
	
	@Resource(name="baseInfoMgmtService")
	BaseInfoMgmtService baseInfoMgmtService;
	
	 // 결제실패내역조회 
	@RequestMapping(value="/payFailInquiry.do")
	public String acctPayInquiry(Model model, CommonMap commonMap) throws Exception {
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU",            "46");
		model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0072"));
		
		model.addAttribute("MER_SEARCH",          CommonDDLB.paySearchType1());
		model.addAttribute("PAY_SEARCH",          CommonDDLB.paySearchType2());
		model.addAttribute("Option_Chk",          CommonDDLB.OptionChk(DDLBType.CHECK));
		model.addAttribute("BankOption",          CommonDDLB.BankOption(DDLBType.SEARCH));
		model.addAttribute("SettleCycle",          CommonDDLB.SettleCycle(DDLBType.SEARCH));
		model.addAttribute("Status",          CommonDDLB.Status(DDLBType.SEARCH));
		model.addAttribute("Escrow",          CommonDDLB.Escrow(DDLBType.SEARCH));
		model.addAttribute("ConnFlg",          CommonDDLB.ConnFlg(DDLBType.SEARCH));
		model.addAttribute("DealFlg",          CommonDDLB.DealFlg(DDLBType.SEARCH));
		model.addAttribute("DateChk",          CommonDDLB.payFailDateChk());
		
		return "/paymentMgmt/payFailInquiry/payFailInquiry";
	}
	
	//결제관리 카드 total 정보 리스트 조회
    @RequestMapping(value = "/selectTransFailInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectTransFailInfoList(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception 
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
    			
    			objList = 	cardPaymentMgmtService.selectTransFailInfoList(objMap);
    			//intPageTotalCnt = objList.size();
    			intPageTotalCnt = ( Integer ) cardPaymentMgmtService.selectTransFailInfoListTotal(objMap);
    			
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
    @RequestMapping(value="/selectTransFailInfoListExcel.do", method=RequestMethod.POST)
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
             
             objExcelData = cardPaymentMgmtService.selectTransFailInfoList(objMap);
             //objExcelData = cardPaymentMgmtService.selectTransInfoList(objMap);
             
         } catch(Exception ex) {
             objExcelMap  = null;
             objExcelData = null;
             log.error("selectCardTransInfoList.do exception : " , ex);
         } finally {
             objExcelMap.put("excelName", "pay_fail_inquiry");
             objExcelMap.put("excelData", objExcelData);
             objExcelMap.put("reqData",   objMap);
         }
         
         return new PayFailListExcelGenerator();
     }
    
  //카드 세부정보  조회
    @RequestMapping(value = "/selectSerTidFailInfo.do", method=RequestMethod.POST)
    public ModelAndView selectSerTidFailInfo(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception 
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
 	        	   //dataMap = 	cardPaymentMgmtService.selectSerTidInfo(objMap);
 	        	  dataMap = 	cardPaymentMgmtService.selectSerTidFailInfo(objMap);
 	        	  
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
}
