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

import egov.linkpay.ims.baseinfomgmt.service.AffMgmtService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonConstants;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.baseinfomgmt
 * File Name      : BaseInfoMgmtController.java
 * Description    : 기본정보 - 기본정보 조회
 * Author         : ChoiIY, 2017. 04. 17.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/baseInfoMgmt/subMallMgmt")
public class AffMgmtController {
    Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="affMgmtService")
    private AffMgmtService affMgmtService;
    //신용카드 관리
    @RequestMapping(value = "/creditCardMgmt.do")
    public String creditCardMgmt(Model model, CommonMap commonMap) throws Exception {
    	List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl = "";
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "80");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0100"));
        //카드정보 조회 
    	log.info( "신용카드관리-1- 카드리스트" );
    	codeCl ="0002";
    	listMap = affMgmtService.selectCodeCl(codeCl);
        model.addAttribute("CardCompanyList",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        model.addAttribute("CardCompanyList1",          CommonDDLB.ListOption(listMap));
        //인증형태 조회 
    	log.info( "신용카드관리-1- 인증형태" );
        codeCl ="0057";
    	listMap = affMgmtService.selectCodeCl(codeCl);
        model.addAttribute("CardCertList",          CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        model.addAttribute("CardCertList1",          CommonDDLB.ListOption(listMap));
        //가맹점 구분 
        log.info( "신용카드관리-1- 가맹점구분" );
        codeCl ="0056";
    	listMap = affMgmtService.selectCodeCl(codeCl);
        model.addAttribute("MerType",         CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
        model.addAttribute("MerType1",         CommonDDLB.ListOption(listMap));
       
        
        model.addAttribute("PointType",          CommonDDLB.pointType(DDLBType.SEARCH));
        model.addAttribute("PointType1",          CommonDDLB.pointType(DDLBType.EDIT));
        model.addAttribute("DepositCycle",          CommonDDLB.depositCycle(DDLBType.SEARCH));
        model.addAttribute("DepositCycle1",          CommonDDLB.depositCycle(DDLBType.EDIT));
        model.addAttribute("LimitChk",          CommonDDLB.limitChk(DDLBType.SEARCH));
        model.addAttribute("LimitChk1",          CommonDDLB.limitChk(DDLBType.EDIT));
        model.addAttribute("KeyInList",          CommonDDLB.keyInList(DDLBType.EDIT));
        //model.addAttribute("MER_TYPE",          CommonDDLB.merchantType4(DDLBType.EDIT));
        model.addAttribute("MER_TYPE",          CommonDDLB.merchantType4_1());
        
        return "/baseInfoMgmt/subMallMgmt/creditCardMgmt";
    }
    //제휴사 신용카드 등록
    @RequestMapping(value = "/insertCreditCardInfo.do" , method=RequestMethod.POST)
    public ModelAndView insertBaseInfo(@RequestBody String strJsonParameter) throws Exception 
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	log.info( "제휴사 신용카드 등록-insert- Start -" );
        int    intResultCode    = 0;
        String strResultMessage = "";
    	try 
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
            {
            	log.info( "제휴사 신용카드 등록-insert-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	log.info( "제휴사 신용카드 등록-insert-1-파라미터 : " + objMap );
            	CommonUtils.initSearchRange(objMap);
            	
            	affMgmtService.insertCreditCardInfo(objMap);
            }
            else
            {
            	log.info( "제휴사 신용카드 등록-insert-1-파라미터 null " );
            	intResultCode=9999;
            }
            
    	}
    	catch(Exception e)
    	{
    		log.error( "제휴사 신용카드 등록-Exception : ", e );
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
        
    	log.info( "제휴사 신용카드 등록-insert- End -" );
        return objMv; 
    }
    @RequestMapping(value = "/cardDelete.do", method=RequestMethod.POST)
    public ModelAndView cardDelete(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > resultMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  	     int intResultCode    = 0;
  	     String strResultMessage = "";
  	   	log.info( "제휴사 신용카드 조회-카드정보삭제- Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "제휴사 신용카드 조회- 카드정보삭제-parameter : " + objMap );
  	        	   
  	        	   resultMap =  affMgmtService.deleteCardInfo(objMap);
  	               
  	        	   if(!resultMap.get( "resultCd" ).equals( "0000" ))
  	        	   {
  	        		   if(resultMap.get( "resultCd" ).equals( "-999" ))
  	        		   {
  	        			 intResultCode = -999;
  	        			 objMv.addObject("mbsNo", resultMap.get( "mbsNo" ) );
  	        			 objMv.addObject("cardCd", resultMap.get( "cardCd" ) );
  	        			
  	        			 log.info( "제휴사 신용카드 조회-카드정보삭제-삭제불가" + resultMap.get( "resultCd" ) );
  	        		   }
  	        		   else
  	        		   {
  	        			   intResultCode = 9999;
  	        			   strResultMessage="DATA NOT EXIST";
  	        			   log.info( "제휴사 신용카드 조회-카드정보삭제-1-delete fail" );
  	        		   }
  	               }
  	           }
  	           else
  	           {
  	        	   log.info( "제휴사 신용카드 조회-카드정보삭제-1-파라미터 null " );
  	           }
  	           
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "제휴사 신용카드 조회-카드정보삭제-Exception : ", e );
  	   	}
  	  finally 
      {
      	  if (intResultCode == 0) 
      	  {
                objMv = CommonUtils.resultSuccess(objMv);
            }
      	  else 
      	  {
                objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
            }
		}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "제휴사 신용카드 조회-카드정보삭제- End -" );
    	return objMv;
    }
  //제휴사 신용카드 조회
  	@RequestMapping(value = "/selectCardSetData.do", method=RequestMethod.POST)
  	public ModelAndView selectCardSetData(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  	     int intResultCode    = 0;
  	     int intPageTotalCnt = 0;
  	     String strResultMessage = "";
  	   	log.info( "제휴사 신용카드 조회- 가맹점 설정 정보 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "제휴사 신용카드 조회-가맹점 설정 정보 - parameter : " + objMap );
  	               objList = 	affMgmtService.selectCardSetData(objMap);
  	               intPageTotalCnt = 	(Integer)affMgmtService.selectCardSetDataTotal(objMap);
  	           }
  	           else
  	           {
  	        	   log.info( "제휴사 신용카드 조회-가맹점 설정 정보 -1-파라미터 null " );
  	           }
  	           
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "제휴사 신용카드 조회-가맹점 설정 정보 -Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "제휴사 신용카드 조회-가맹점 설정 정보 - End -" );
  	    return objMv; 
  	}
    //제휴사 신용카드 조회
  	@RequestMapping(value = "/selectCreditCardList.do", method=RequestMethod.POST)
  	public ModelAndView selectCreditCardList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  	     int intResultCode    = 0;
  	     int intPageTotalCnt = 0;
  	     String strResultMessage = "";
  	   	log.info( "제휴사 신용카드 조회- Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "제휴사 신용카드 조회- parameter : " + objMap );
  	               objList = 	affMgmtService.selectCreditCardList(objMap);
  	               intPageTotalCnt =  (Integer)affMgmtService.selectCreditCardListTotal(objMap);
  	           }
  	           else
  	           {
  	        	   log.info( "제휴사 신용카드 조회-1-파라미터 null " );
  	           }
  	           
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "제휴사 신용카드 조회-Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "제휴사 신용카드 조회- End -" );
  	    return objMv; 
  	}
    //카드 리스트 excel
    @RequestMapping(value="/selectCreditCardListExcel.do", method=RequestMethod.POST)
    public View selectCreditCardListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            
            objExcelData = affMgmtService.selectCreditCardList(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectReportExcelList.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Card_Infomation_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new AffCreditCardExcelGenerator();
    }
    
    //카드가맹점HISTORY
    @RequestMapping(value = "/cardMerHistory.do")
    public String cardMerHistory(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "81");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0101"));

        return "/baseInfoMgmt/subMallMgmt/cardMerHistory";
    }
  //제휴사 신용카드 HISTORY TOP 조회
  	@RequestMapping(value = "/selectCardInfo.do", method=RequestMethod.POST)
  	public ModelAndView selectCardInfo(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  	     int intResultCode    = 0;
  	     int intPageTotalCnt = 0;
  	     String strResultMessage = "";
  	   	log.info( "제휴사 신용카드HISTORY 조회- Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "제휴사 신용카드 HISTORY 조회- parameter : " + objMap );
  	               objList = 	affMgmtService.selectCardInfo(objMap);
  	               intPageTotalCnt = (Integer)affMgmtService.selectCardInfoTotal(objMap);
  	           }
  	           else
  	           {
  	        	   log.info( "제휴사 신용카드 HISTORY 조회-1-파라미터 null " );
  	           }
  	           
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "제휴사 신용카드 HISTORY 조회-Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "제휴사 신용카드 HISTORY 조회- End -" );
  	    return objMv; 
  	}
    //카드가맹점 history조회
  	@RequestMapping(value = "/selectCardHistory.do", method=RequestMethod.POST)
  	public ModelAndView selectCardHistory(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  	     int intResultCode    = 0;
  	     int intPageTotalCnt = 0;
  	     String strResultMessage = "";
  	   	log.info( "제휴사 신용카드 history 조회- Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "제휴사 신용카드 history  조회- parameter : " + objMap );
  	        	   //history 조회
  	               objList = 	affMgmtService.selectCardHistory(objMap);
  	               intPageTotalCnt = (Integer)affMgmtService.selectCardHistoryTotal(objMap);
  	           }
  	           else
  	           {
  	        	   log.info( "제휴사 신용카드 history  조회-1-파라미터 null " );
  	           }
  	           
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "제휴사 신용카드  history 조회-Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "제휴사 신용카드  history 조회- End -" );
  	    return objMv; 
  	}
    //VAN 터미널 관리
    @RequestMapping(value = "/vanTerMgmt.do")
    public String vanTerMgmt(Model model, CommonMap commonMap) throws Exception {
    	List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl = "";
    	log.info( "VAN 터미널 관리 START" );
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "82");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0102"));
        model.addAttribute("MER_TYPE",          CommonDDLB.merchantType4(DDLBType.EDIT));
         
        log.info( "VAN 터미널 관리-1- VAN 조회 " );
    	codeCl ="0003";
    	listMap = affMgmtService.selectCodeCl(codeCl);
    	model.addAttribute("VanType",	CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap ));
    	model.addAttribute("VanType1", CommonDDLB.ListOption(listMap));
    	//카드정보 조회 
    	log.info( "VAN 터미널 관리-2- 카드리스트" );
    	codeCl ="0002";
    	listMap = affMgmtService.selectCodeCl(codeCl);
        model.addAttribute("CardCompanyList",          CommonDDLB.ListOptionSet(DDLBType.ALL, listMap));
        model.addAttribute("CardCompanyList1",          CommonDDLB.ListOption(listMap));
        
        model.addAttribute("MER_TYPE",          CommonDDLB.merchantType4_1());
        
        return "/baseInfoMgmt/subMallMgmt/vanTerMgmt";
    }
    //VAN 신규등록
    @RequestMapping(value = "/insertVanTer.do" , method=RequestMethod.POST)
    public ModelAndView insertVanTer(@RequestBody String strJsonParameter) throws Exception 
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	log.info( "VAN 터미널 관리-insert- Start -" );
        int    intResultCode    = 0;
        String strResultMessage = "";
        String frDt = "";
    	try 
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
            {
            	log.info( "VAN 터미널 관리-insert-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	
            	frDt = (String)objMap.get( "frDt" );
    			frDt = frDt.replaceAll("(\\d+)/(\\d+)/(\\d+)", "$1$2$3" );
	        	objMap.put( "frDt" , frDt);
            	
            	log.info( "VAN 터미널 관리-insert-1-파라미터 : " + objMap );
            	CommonUtils.initSearchRange(objMap);
            	
            	affMgmtService.insertVanTer(objMap);
            }
            else
            {
            	log.info( "VAN 터미널 관리-insert-1-파라미터 null " );
            	intResultCode = 9999;
            }
            
    	}
    	catch(Exception e)
    	{
    		log.error( "VAN 터미널 관리-Exception : ", e );
    		intResultCode = 9999;
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
        
    	log.info( "VAN 터미널 관리-insert- End -" );
        return objMv; 
    }
    //van select
    @RequestMapping(value = "/selectVanTerInfo.do", method=RequestMethod.POST)
    public ModelAndView selectVanTerInfo(@RequestBody String strJsonParameter) throws Exception 
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
         int intResultCode    = 0;
         int intPageTotalCnt = 0;
         String strResultMessage = "";
 	   	log.info( "VAN 터미널 관리- VAN SELECT - Start -" );
 	   	try 
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
 	           {
 	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
 	        	   log.info( "VAN 터미널 관리- VAN SELECT - parameter : " + objMap );
 	        	   CommonUtils.initSearchRange(objMap);
 	               objList = 	affMgmtService.selectVanTerInfo(objMap);
 	               intPageTotalCnt = (Integer)affMgmtService.selectVanTerInfoTotal(objMap);
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
    //van 리스트 excel
    @RequestMapping(value="/selectVanListExcel.do", method=RequestMethod.POST)
    public View selectVanListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            
            objExcelData = affMgmtService.selectVanTerInfo(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectReportExcelList.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Van_Infomation_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new AffVanExcelGenerator();
    }
}
