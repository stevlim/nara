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
import egov.linkpay.ims.baseinfomgmt.service.CreditCardVANMgmtService;
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
@RequestMapping(value="/baseInfoMgmt/creditCardVANMgmt")
public class CreditCardVANMgmtController {
    Logger log = Logger.getLogger(this.getClass());

    @Resource(name="creditCardVANMgmtService")
    private CreditCardVANMgmtService creditCardVANMgmtService;
    @Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
    /**--------------------------------------------------
     * Method Name    : creditCardVANMgmt
     * Description    : 메뉴 진입
     * Author         : ChoiIY, 2017. 04. 26.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/creditCardVANMgmt.do")
    public String creditCardVANMgmt(Model model, CommonMap commonMap) throws Exception {
    	List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl = "";
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        model.addAttribute("CardCompanyList",          CommonDDLB.cardCompanyList(DDLBType.SEARCH));
        model.addAttribute("CardType",          CommonDDLB.cardType(DDLBType.SEARCH));
        model.addAttribute("ForeignCardType",          CommonDDLB.foreignCardTypeSet(DDLBType.SEARCH));
        
        //van_cd 
        try
        {
        	codeCl ="0003";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("VAN_CD",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        }
        catch(Exception e)
        {
        	log.error( "Exception : " ,e );
        }
        
        
        return "/baseInfoMgmt/creditCardVANMgmt/creditCardVANMgmt";
    }
    //van 조회 (이용실적)
    @RequestMapping(value = "/selectVanList.do", method=RequestMethod.POST)
  	public ModelAndView selectVanList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  	    int intResultCode    = 0;
  	    int intPageTotalCnt = 0;
  	    String strResultMessage = "";
  	    String date = "";  
  	   	log.info( "VAN(이용실적) 조회- Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   date = (String)objMap.get( "useMon" );
  	        	   date = date.replaceAll("(\\d+)/(\\d+)", "$1$2" );
  	        	   objMap.put( "useMon", date);
  	        	   log.info( "VAN(이용실적) 조회- parameter : " + objMap );
  	               objList = 	creditCardVANMgmtService.selectVanList(objMap);
  	               intPageTotalCnt = objList.size();
  	           }
  	           else
  	           {
  	        	   log.info( "VAN(이용실적) 조회-1-파라미터 null " );
  	           }
  	           
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "VAN(이용실적) 조회-Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "VAN(이용실적) 조회- End -" );
  	    return objMv; 
  	}
    //van 조회 (van사 정보)
    @RequestMapping(value = "/selectVanInfoList.do", method=RequestMethod.POST)
  	public ModelAndView selectVanInfoList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  	     int intResultCode    = 0;
  	     int intPageTotalCnt = 0;
  	     String strResultMessage = "";
  	   	log.info( "VAN(이용실적) 조회- Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "VAN(이용실적) 조회- parameter : " + objMap );
  	               objList = 	creditCardVANMgmtService.selectVanInfoList(objMap);
  	               intPageTotalCnt = (Integer)creditCardVANMgmtService.selectVanInfoListTotal(objMap);
  	           }
  	           else
  	           {
  	        	   log.info( "VAN(이용실적) 조회-1-파라미터 null " );
  	           }
  	           
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "VAN(이용실적) 조회-Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "VAN(이용실적) 조회- End -" );
  	    return objMv; 
  	}
}
