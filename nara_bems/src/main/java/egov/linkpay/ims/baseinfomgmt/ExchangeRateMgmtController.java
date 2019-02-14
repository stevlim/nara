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

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.baseinfomgmt.service.ExchangeRateService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.baseinfomgmt
 * File Name      : BaseInfoMgmtController.java
 * Description    : 기본정보 - 기본정보 조회
 * Author         : ChoiIY, 2017. 04. 17.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/baseInfoMgmt/exchangeRateMgmt")
public class ExchangeRateMgmtController {
    Logger log = Logger.getLogger(this.getClass());

    @Resource(name="exchangeRateService")
    private ExchangeRateService exchangeRateService;
    
    @Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
    /**--------------------------------------------------
     * Method Name    : exchangeRateMgmt
     * Description    : 메뉴 진입
     * Author         : ChoiIY, 2017. 04. 25.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/exchangeRateMgmt.do")
    public String exchangeRateMgmt(Model model, CommonMap commonMap) throws Exception {
    	List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl = "";
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        //model.addAttribute("CURRENCY_SEARCH",          CommonDDLB.currencyType(DDLBType.SEARCH));
    	log.info( "통화코드 조회" );
    	codeCl ="0086";
    	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        model.addAttribute("CURRENCY_SEARCH",          CommonDDLB.CurrencyOptionSet(DDLBType.SEARCH, listMap));
        model.addAttribute("CURRENCY_SEARCH1",          CommonDDLB.CurrencyOption(listMap));
        return "/baseInfoMgmt/exchangeRateMgmt/exchangeRateMgmt";
    }
    //환율 신규등록
    @RequestMapping(value = "/insertExRateInfo.do" , method=RequestMethod.POST)
    public ModelAndView insertExRateInfo(@RequestBody String strJsonParameter) throws Exception 
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	log.info( "환율관리-insert- Start -" );
        int    intResultCode    = 0;
        String strResultMessage = "";
    	try 
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
            {
            	log.info( "환율관리-insert-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	log.info( "환율관리-insert-1-파라미터 : " + objMap );
            	CommonUtils.initSearchRange(objMap);
            	String baseDate = (String)objMap.get( "baseDt" );
            	String baseDt ="";
			    baseDt = baseDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			    objMap.put( "baseDt", baseDt);
			    
            	exchangeRateService.insertExRate(objMap);
            }
            else
            {
            	log.info( "환율관리-insert-1-파라미터 null " );
            	intResultCode = 9999;
            }
            
    	}
    	catch(Exception e)
    	{
    		log.error( "환율관리-Exception : ", e );
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
        
    	log.info( "환율관리-insert- End -" );
        return objMv; 
    }
    //환율  select
    @RequestMapping(value = "/selectExRateInfo.do", method=RequestMethod.POST)
    public ModelAndView selectExRateInfo(@RequestBody String strJsonParameter) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
         int intResultCode    = 0;
         int intPageTotalCnt = 0;
         String strResultMessage = "";
 	   	log.info( "환율관리- VAN SELECT - Start -" );
 	   	try 
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
 	           {
 	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String frDt = "";
	        	   String toDt = "";
 	        	   frDt= (String)objMap.get( "txtFromDate" );
	               frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	               objMap.put( "frDt", frDt );
	               
	               toDt= (String)objMap.get( "txtToDate" );
	               toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	               objMap.put( "toDt", toDt );
	               
 	        	   log.info( "환율관리- VAN SELECT - parameter : " + objMap );
 	        	   CommonUtils.initSearchRange(objMap);
 	               objList = 	exchangeRateService.selectExRate(objMap);
 	               intPageTotalCnt = (Integer)exchangeRateService.selectExRateTotal(objMap);
 	           }
 	           else
 	           {
 	        	   log.info( "환율관리-VAN SELECT-1-파라미터 null " );
 	           }
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "환율관리-Exception : ", e );
 	   	}
 	   	finally
 	   	{
 	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
 	   	}
 	       
 	   	objMv.setViewName("jsonView");
 	   	log.info( "환율관리-VAN SELECT - End -" );
 	    return objMv; 
    }
}
