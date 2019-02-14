package egov.linkpay.ims.baseinfomgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.baseinfomgmt.service.CreditCardBINMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.baseinfomgmt
 * File Name      : CreditCardBINMgmtController.java
 * Description    : 기본정보 - 신용카드 지원 - BIN 관리
 * Author         : ChoiIY, 2017. 04. 26.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/baseInfoMgmt/creditCardBINMgmt")
public class CreditCardBINMgmtController {
    Logger log = Logger.getLogger(this.getClass());

    @Resource(name="creditCardBINMgmtService")
    private CreditCardBINMgmtService creditCardBINMgmtService;
    
    @Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
    /**--------------------------------------------------
     * Method Name    : creditCardBINMgmt
     * Description    : 메뉴 진입
     * Author         : ChoiIY, 2017. 04. 26.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/creditCardBINMgmt.do")
    public String creditCardBINMgmt(Model model, CommonMap commonMap) throws Exception {
    	List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl = "";
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        model.addAttribute("ForeignCardType",          CommonDDLB.foreignCardTypeSet(DDLBType.SEARCH));
        
        //카드정보 조회 
    	log.info( "카드사 리스트 조회" );
    	codeCl ="0002";
    	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        model.addAttribute("CardCompanyList",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        //카드구분 조회 
    	log.info( "카드구분 리스트 조회" );
    	codeCl ="0020";
    	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        model.addAttribute("CardType",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        
        
        return "/baseInfoMgmt/creditCardBINMgmt/creditCardBINMgmt";
    }
    //bin 조회
    @RequestMapping(value = "/selectBinInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectBinInfoList(@RequestBody String strJsonParameter) throws Exception 
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
    	int intResultCode    = 0;
    	int intPageTotalCnt = 0;
    	String strResultMessage = "";
    	String date = "";  
    	log.info( "BIN 조회- Start -" );
    	try 
    	{
    		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
    		{
    			objMap = CommonUtils.jsonToMap(strJsonParameter);
    			CommonUtils.initSearchRange(objMap);
    			log.info( "BIN 조회- parameter : " + objMap );
    			objList = 	creditCardBINMgmtService.selectCreditCardBINSearch(objMap);
    			intPageTotalCnt = (Integer)creditCardBINMgmtService.selectCreditCardBINSearchTotal(objMap);
    		}
    		else
    		{
    			log.info( "BIN 조회-1-파라미터 null " );
    		}
    		
    	}
    	catch(Exception e)
    	{
    		log.error( "BIN 조회-Exception : ", e );
    	}
    	finally
    	{
    		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
    	}
    	
    	objMv.setViewName("jsonView");
    	log.info( "BIN 조회- End -" );
    	return objMv; 
    }
    //카드사 승인한도 관리
    @RequestMapping(value = "/cardApprLimitMgmt.do")
    public String cardApprLimitMgmt(Model model, CommonMap commonMap) throws Exception {
    	List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl = "";
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "77");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0097"));
        
        //카드정보 조회 
    	log.info( "카드사 리스트 조회" );
    	codeCl ="0002";
    	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        model.addAttribute("CardCompanyList",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        
        //조회 옵션 
        model.addAttribute("INQUIRY_OPTION",          CommonDDLB.inquiryOption(DDLBType.SEARCH));
        
        
        return "/baseInfoMgmt/creditCardBINMgmt/cardApprLimitMgmt";
    }
    //카드 승인한도 리스트 
    @RequestMapping(value = "/selectAppLmtList.do", method=RequestMethod.POST)
    public ModelAndView selectVanTerInfo(@RequestBody String strJsonParameter) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        int intResultCode    = 0;
        int intPageTotalCnt = 0;
        String strResultMessage = "";
        String frDt = ""; 
 	   	log.info( "카드 승인한도 리스트 -  SELECT - Start -" );
 	   	try 
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
 	           {
 	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
 	        	   frDt = (String)objMap.get( "frDt" );
 	        	   frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   objMap.put( "frDt" , frDt);
 	        	   log.info( "카드 승인한도 리스트 -  SELECT - parameter : " + objMap );
 	        	   CommonUtils.initSearchRange(objMap);
 	               objList = 	creditCardBINMgmtService.selectAppLmtList(objMap);
 	               intPageTotalCnt = (Integer)creditCardBINMgmtService.selectAppLmtListTotal(objMap);
 	           }
 	           else
 	           {
 	        	   log.info( "VAN 터미널 관리-VAN SELECT-1-파라미터 null " );
 	           }
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "VAN 터미널 관리-Exception : ", e );
 	   	}
 	   	finally
 	   	{
 	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
 	   	}
 	       
 	   	objMv.setViewName("jsonView");
 	   	log.info( "VAN 터미널 관리-VAN SELECT - End -" );
 	    return objMv; 
    }
    //카드 승인한도 리스트 excel
    @RequestMapping(value="/selectAppLmtListExcel.do", method=RequestMethod.POST)
    public View selectCreditCardListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            
            objExcelData = creditCardBINMgmtService.selectAppLmtList(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectReportExcelList.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Card_Approve_Limit_Infomation_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new CreditCardAppLmtListExcelGenerator();
    }
}
