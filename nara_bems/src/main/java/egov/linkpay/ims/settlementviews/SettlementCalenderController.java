package egov.linkpay.ims.settlementviews;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonUtils.DateFormat;
import egov.linkpay.ims.paymentMgmt.PayFailListExcelGenerator;
import egov.linkpay.ims.settlementviews.service.SettlementCalenderService;

/**------------------------------------------------------------
 * Package Name   : net.nicepay.dashboard.settlementviews
 * File Name      : SettlementCalenderContrller.java
 * Description    : 정산 조회 - 정산 달력
 * Author         : yangjeongmo, 2015. 11. 10.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/settlementViews/settlementCalender")
public class SettlementCalenderController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="settlementCalenderService")
    private SettlementCalenderService settlementCalenderService;
    
    /**--------------------------------------------------
     * Method Name    : settlementCalender
     * Description    : 메뉴 진입
     * Author         : yangjeongmo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/settlementCalender.do")
    public String settlementCalender(Model model, CommonMap commonMap) throws Exception {
        List<Map<String,Object>> objList = settlementCalenderService.selectMerchantIDList(commonMap.get("USR_ID").toString());
        
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        
        model.addAttribute("MERCHANT_ID_FOR_SEARCH", CommonDDLB.merchantID(DDLBType.SEARCH, objList));
        
        //년
        model.addAttribute("YYYY_LIST",  	CommonDDLB.yyyyList());
        
        //월
        model.addAttribute("MM_LIST",  	CommonDDLB.mmList());
        
        Date today = new Date();
        System.out.println(today);
            
        SimpleDateFormat todayYyyyDate = new SimpleDateFormat("yyyy");
        SimpleDateFormat todayMmDate = new SimpleDateFormat("MM");
        
        model.addAttribute("TODAY_YYYY", todayYyyyDate.format(today));
        model.addAttribute("TODAY_MM", todayMmDate.format(today));
        
        return "/settlementViews/settlementCalender/settlementCalender";
    }
    
    /**--------------------------------------------------
     * Method Name    : taxInvoiceInquiry
     * Description    : 메뉴 진입
     * Author         : yangjeongmo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/taxInvoiceInquiry.do")
    public String taxInvoiceInquiry(Model model, CommonMap commonMap) throws Exception {
    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            CommonMessageDic.getMessage("IMS_SM_TV_0007"));	//세금계산서
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));
        
        model.addAttribute("sendCategorySearch",          CommonDDLB.handWriteSendCategoryAllType());
        
        return "/settlementViews/settlementCalender/taxInvoiceInquiry";
    }
    
    /**--------------------------------------------------
     * Method Name    : selectSettlementCalenderList
     * Description    : 정산 달력 내역 조회(입금내용) - 정산 금액 포함
     * Author         : yangjeongmo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectSettlementCalenderList.do", method=RequestMethod.POST)
    public ModelAndView selectSettlementCalenderList(HttpServletRequest request, @RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                objMap.put("I_MID",     objMap.get("I_MID").toString().equals("") ? commonMap.get("I_MIDS") : objMap.get("I_MID"));
                objMap.put("SET_MONTH", CommonUtils.ConvertDate(DateFormat.YYYYMM, "", objMap.get("SET_MONTH")));
                
                HttpSession session = request.getSession(false);
            	String merId = "";
            	String merType = "";
            	
            	merId = session.getAttribute("MER_ID").toString();
     	   		merType = session.getAttribute("MER_ID_TYPE").toString();
     	   	
     	   		objMap.put("MER_ID", merId);
     	   		objMap.put("MER_TYPE", merType);
	    	
     	   		//objMap.put("merId", merId);
                
                objList = settlementCalenderService.selectSettlementCalenderList(objMap);
                
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.info("selectSettlementCalenderList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectSettlementSettCalenderList
     * Description    : 정산 달력 내역 조회(정산내용) - 정산 금액 포함
     * Author         : yangjeongmo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectSettlementSettCalenderList.do", method=RequestMethod.POST)
    public ModelAndView selectSettlementSettCalenderList(HttpServletRequest request, @RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                objMap.put("I_MID",     objMap.get("I_MID").toString().equals("") ? commonMap.get("I_MIDS") : objMap.get("I_MID"));
                objMap.put("SET_MONTH", CommonUtils.ConvertDate(DateFormat.YYYYMM, "", objMap.get("SET_MONTH")));
                
                HttpSession session = request.getSession(false);
            	String merId = "";
     	   		merId = session.getAttribute("MER_ID").toString();
     	   		
     	   		objMap.put("merId", merId);
                
                objList = settlementCalenderService.selectSettlementSettCalenderList(objMap);
                
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.info("selectSettlementSettCalenderList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectSettlementDetailList
     * Description    : 정산 달력 상세 내역 조회
     * Author         : yangjeongmo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectSettlementDetailList.do", method=RequestMethod.POST)
    public ModelAndView selectSettlementDetailList(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                
                if (!objMap.get("I_MID").toString().equals("") && !CommonUtils.availMIDInquiry(commonMap.get("I_MIDS"), objMap.get("I_MID"))) {
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_PERMISSION;
                } else {
                    CommonUtils.initSearchRange(objMap);
                    
                    objMap.put("I_MID",     objMap.get("I_MID").toString().equals("") ? commonMap.get("I_MIDS") : objMap.get("I_MID"));
                    objMap.put("SETTLMNT_DT", CommonUtils.ConvertDate(DateFormat.YYYYMM, "", objMap.get("SETTLMNT_DT")));
                    
                    objList = settlementCalenderService.selectSettlementDetailList(objMap);
                }
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.info("selectSettlementDetailList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectPerMerchantReportExcelList
     * Description    : 가맹점 별 내역 엑셀 다운로드
     * Author         : yangjeongmo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    /*@RequestMapping(value="/selectPerMerchantReportExcelList.do", method=RequestMethod.POST)
    public View selectPerMerchantReportExcelList(@RequestBody String strJsonParameter, Map<String, Object> modelMap, CommonMap commonMap) throws Exception {
        Map<String,Object>       objMap       = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try
        { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            
            if (!objMap.get("I_MID").toString().equals("") && !CommonUtils.availMIDInquiry(commonMap.get("I_MIDS"), objMap.get("I_MID"))) {
                return null;
            } else {
                objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
                objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
                objMap.put("SETTLMNT_DT",  CommonUtils.ConvertDate(DateFormat.YYYYMMDD, "", objMap.get("SETTLMNT_DT")));
                objMap.put("I_MID",        objMap.get("I_MID").toString().equals("") ? commonMap.get("I_MIDS") : objMap.get("I_MID"));
                
                objExcelData = settlementCalenderService.selectPerMerchantReportExcelList(objMap);
            }
        }
        catch(Exception ex)
        {
            objExcelData = null;
            logger.info("selectPerMerchantReportExcelList.do exception : " + ex.getMessage());
        }
        finally
        {
            modelMap.put("excelName", "PerMerchantSettlementReport");
            modelMap.put("excelData", CommonUtils.removeCrlfFromMap(objExcelData));
        }
        
        return new SettlementPerMerchantReportExcelGenerator();
    }*/
    
    /**--------------------------------------------------
     * Method Name    : selectPerMerchantReportExcelCnt
     * Description    : 가맹점 별 내역 리스트 개수 조회
     * Author         : yangjeongmo, 2015. 11. 10.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    /*@RequestMapping(value="/selectPerMerchantReportExcelCnt.do", method=RequestMethod.POST)
    public ModelAndView selectPerMerchantReportExcelCnt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv   = new ModelAndView();
        Map<String, Object> objMap  = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        int    intResultCnt     = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.queryStringToMap(strJsonParameter);
                
                if (!objMap.get("I_MID").toString().equals("") && !CommonUtils.availMIDInquiry(commonMap.get("I_MIDS"), objMap.get("I_MID"))) {
                    intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_PERMISSION;
                } else {
                    objMap.put("SETTLMNT_DT", CommonUtils.ConvertDate(DateFormat.YYYYMMDD, "", objMap.get("SETTLMNT_DT")));
                    objMap.put("I_MID",       objMap.get("I_MID").toString().equals("") ? commonMap.get("I_MIDS") : objMap.get("I_MID"));
                    
                    intResultCnt = Integer.parseInt(settlementCalenderService.selectPerMerchantReportExcelCnt(objMap).toString());
                    objMv.addObject("ResultCnt", intResultCnt);
                }
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.info("selectPerMerchantReportExcelCnt.do exception : " + ex.getMessage());
        }  finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }*/
    
  //리스트 조회
  	@RequestMapping(value = "/selectTaxInvoiceList.do", method=RequestMethod.POST)
      public ModelAndView selectTaxInvoiceList(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception 
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
	      	logger.info( "세금계산서 조회- Start -" );
	      	try 
	      	{
	      		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	      		{
	      			logger.info( "strJsonParameter  : " + strJsonParameter );
	      			objMap = CommonUtils.jsonToMap(strJsonParameter);
	  	        	
	      			
	  	            CommonUtils.initSearchRange(objMap);
	  	            logger.info( "세금계산서 리스트 조회- parameter : " + objMap );
	  	            
	  	            HttpSession session = request.getSession(false);
	     	   		
		     	   	String merId = "";
			    	String merType = "";
			    	
				   	merId = session.getAttribute("MER_ID").toString();
				   	merType = session.getAttribute("MER_ID_TYPE").toString();
				   	
				   	objMap.put("MER_ID", merId);
			    	objMap.put("MER_TYPE", merType);
		    	
	     	   		//objMap.put("midSearch", merId);
	     	   		
	  	          
	      			objMap.put("txtFromDate",objMap.get("txtFromDate").toString().replaceAll("-", ""));
	      			
	      			objList = 	settlementCalenderService.selectTaxInvoiceList(objMap);
	      			//intPageTotalCnt = objList.size();
	      			intPageTotalCnt = ( Integer ) settlementCalenderService.selectTaxInvoiceListTotal(objMap);
	      			
	      		}
	      		else
	      		{
	      			logger.info( "세금계산서1-파라미터 null " );
	      		}
	      		
	      	}
	      	catch(Exception e)
	      	{
	      		logger.error( "세금계산서-Exception : ", e );
	      	}
	      	finally
	      	{
	      		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	      	}
	      	
	      	objMv.setViewName("jsonView");
	      	logger.info( "세금계산서 조회- End -" );
      	return objMv; 
      }
  	
  	@RequestMapping(value = "/selectTaxInvoiceListExcel.do", method=RequestMethod.POST)
    public View selectTaxInvoiceListExcel(HttpServletRequest request, @RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception 
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
	      	
	      	List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	      	
	      	JsonParser jsonParser = new JsonParser();
	      	logger.info( "세금계산서 조회- Start -" );
	      	try 
	      	{
	      		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	      		{
	      			logger.info( "strJsonParameter  : " + strJsonParameter );
	      			objMap = CommonUtils.queryStringToMap(strJsonParameter);
	  	        	
	      			
	  	            CommonUtils.initSearchRange(objMap);
	  	            logger.info( "세금계산서 리스트 조회- parameter : " + objMap );
	  	            
	  	            HttpSession session = request.getSession(false);
	     	   		
		     	   	String merId = "";
			    	String merType = "";
			    	
				   	merId = session.getAttribute("MER_ID").toString();
				   	merType = session.getAttribute("MER_ID_TYPE").toString();
				   	
				   	objMap.put("MER_ID", merId);
			    	objMap.put("MER_TYPE", merType);
		    	
	     	   		//objMap.put("midSearch", merId);
	     	   		
	  	          
	      			objMap.put("txtFromDate",objMap.get("txtFromDate").toString().replaceAll("-", ""));
	      			
	      			objExcelData = 	settlementCalenderService.selectTaxInvoiceList(objMap);
	      			
	      		}
	      		else
	      		{
	      			logger.info( "세금계산서1-파라미터 null " );
	      		}
	      		
	      	}
	      	catch(Exception e)
	      	{
	      		objExcelMap  = null;
	             objExcelData = null;
	             logger.error("selectCardTransInfoList.do exception : " , e);
	      	}
	      	finally
	      	{
	      		objExcelMap.put("excelName", "tax_invoice_inquiry");
	             objExcelMap.put("excelData", objExcelData);
	             objExcelMap.put("reqData",   objMap);
	      	}
	      	
	      	return new TaxInvoiceListExcelGenerator(); 
    }
}
