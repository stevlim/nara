package egov.linkpay.ims.calcuMgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.calcuMgmt.service.CalcuMgmtService;
import egov.linkpay.ims.calcuMgmt.service.PurchaseMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;

/**
 * ------------------------------------------------------------ Package Name :
 * egov.linkpay.ims.home File Name : HomeController.java Description : Home
 * Controller(Dashboard) Author : ymjo, 2015. 10. 5. Modify History : Just
 * Created. ------------------------------------------------------------
 */
@Controller
@RequestMapping(value = "/calcuMgmt/purchaseMgmt")
public class PurchaseMgmtController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "baseInfoRegistrationService")
	private BaseInfoRegistrationService baseInfoRegistrationService;
	
	@Resource(name = "baseInfoMgmtService")
	private BaseInfoMgmtService baseInfoMgmtService;
	
	@Resource(name = "purchaseMgmtService")
	private PurchaseMgmtService purchaseMgmtService;
	
	//매입검증
	@RequestMapping(value = "/purchaseVeri.do")
	public String purchaseVeri(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "150");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0116"));
		
		return "/calcuMgmt/purchaseMgmt/purchaseVeri";
	}
	//매입검증 정보 조회
	@RequestMapping(value = "/selectPurchaseVeriList.do", method=RequestMethod.POST)
	public ModelAndView selectResrSetList(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "매입검증- 매입검증 리스트 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "매입검증- 매입검증 리스트 조회 - parameter : " + objMap );
	        	   String acqDate = (String)objMap.get( "acqDt" );
	        	   String acqDt = "";
	        	   acqDt = acqDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "acqDt", acqDt);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "매입검증- 매입검증 리스트 조회 - parameter : " + objMap );
	        	   dataMap = 	purchaseMgmtService.selectPurchaseVeriList(objMap);
	        	   if(dataMap.get( "resultCd" ) != "0000"){
	        		   intResultCode = 9999;
	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
	        	   }else{
	        		   objMv.addObject( "transMap", dataMap.get( "transMap" ));
	        		   objMv.addObject( "etcMap", dataMap.get( "etcMap" ));
	        		   objMv.addObject( "reMap", dataMap.get( "reMap" ));
	        		   objMv.addObject( "canMap", dataMap.get( "canMap" ));
	        		   objMv.addObject( "listMap", dataMap.get( "listMap" ));
	        		   objMv.addObject( "vanMap", dataMap.get( "vanMap" ));
	        	   }
	           }
	           else
	           {
	        	   log.info( "매입검증- 매입검증 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
	           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "매입검증-Exception : ", e );
	   	}
	   	finally
	   	{
		   	 if (intResultCode == 0) {
		         objMv = CommonUtils.resultSuccess(objMv);
		     } else {
		         objMv = CommonUtils.resultFail(objMv, strResultMessage);
		     }
	   	}
	   	objMv.setViewName("jsonView");
	   	log.info( "매입검증- 매입검증 리스트 조회 - End -" );
	    return objMv; 
	}
	//매입검증 리스트 조회
	@RequestMapping(value = "/selectAcqGap.do", method=RequestMethod.POST)
	public ModelAndView selectAcqGap(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "매입검증- 매입검증 리스트 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "매입검증- 매입검증 리스트 조회 - parameter : " + objMap );
	        	   String acqDate = (String)objMap.get( "acqDt" );
	        	   String acqDt = "";
	        	   acqDt = acqDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "acqDt", acqDt);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "매입검증- 매입검증 리스트 조회 - parameter : " + objMap );
	        	   objList = 	purchaseMgmtService.selectAcqGap(objMap);
	        	   intPageTotalCnt = 	purchaseMgmtService.selectAcqGapTotal(objMap);
	    	   
	           }
	           else
	           {
	        	   log.info( "매입검증- 매입검증 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "매입검증-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "매입검증- 매입검증 리스트 조회 - End -" );
	    return objMv; 
	}
	//매입결과
	@RequestMapping(value = "/purchaseResult.do")
	public String purchaseResult(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "151");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0117"));

		model.addAttribute("OVER_CL", CommonDDLB.foreignCardTypeSet(DDLBType.SEARCH));
		model.addAttribute("STATUS", CommonDDLB.StatusOption1(DDLBType.SEARCH));
		
		log.info( "매입결과-1- 카드 조회" );
        Map<String, Object> dataMap = new HashMap< String, Object >();
        List< Map< String, String > > listMap = new ArrayList<>();
    	dataMap.put( "code2", "pur" );
    	listMap = baseInfoRegistrationService.selectCardList( dataMap);   
    	model.addAttribute("CARD_LIST", CommonDDLB.ListOptionSetCity( DDLBType.SEARCH, listMap ));
		
		return "/calcuMgmt/purchaseMgmt/purchaseResult";
	}
	//매입결과 건수,금액 정보 조회
	@RequestMapping(value = "/selectAcqTidRsltInfo.do", method=RequestMethod.POST)
	public ModelAndView selectAcqTidRsltInfo(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "매입결과 - 건수,금액 정보 조회 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "매입결과 - 건수,금액 정보 조회 조회 - parameter : " + objMap );
	        	   String fromDate = (String)objMap.get( "txtFromDate" );
	        	   String frDt = "";
	        	   frDt  = fromDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "frDt", frDt );
				   String toDate = (String)objMap.get( "txtToDate" );
	        	   String toDt = "";
	        	   toDt  = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "toDt", toDt );
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "매입결과 - 건수,금액 정보 조회 조회 - parameter : " + objMap );
	        	   dataMap = 	purchaseMgmtService.selectAcqTidRsltInfo(objMap);
	        	   
	        	   objMv.addObject( "data", dataMap );
	           }
	           else
	           {
	        	   log.info( "매입결과 - 건수,금액 정보 조회 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "매입결과-Exception : ", e );
	   	}
	   	finally
	   	{
	   		if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "매입결과 - 건수,금액 정보 조회 조회 - End -" );
	    return objMv; 
	}
	//매입결과 리스트 조회
	@RequestMapping(value = "/selectAcqTidRsltList.do", method=RequestMethod.POST)
	public ModelAndView selectAcqTidRsltList(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "매입결과 - tid별 매입결과 조회 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "매입결과 - tid별 매입결과 조회 조회 - parameter : " + objMap );
	        	   String fromDate = (String)objMap.get( "txtFromDate" );
	        	   String frDt = "";
	        	   frDt  = fromDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "frDt", frDt );
				   String toDate = (String)objMap.get( "txtToDate" );
	        	   String toDt = "";
	        	   toDt  = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "toDt", toDt );
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "매입결과 - tid별 매입결과 조회 조회 - parameter : " + objMap );
	        	   objList = 	purchaseMgmtService.selectAcqTidRsltList(objMap);
	        	   intPageTotalCnt = 	purchaseMgmtService.selectAcqTidRsltListTotal(objMap);
	    	   
	           }
	           else
	           {
	        	   log.info( "매입결과 - tid별 매입결과 조회 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "매입결과-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "매입결과 - tid별 매입결과 조회 조회 - End -" );
	    return objMv; 
	}
	//매입결과 내역 엑셀   
    @RequestMapping(value="/selectAcqTidRsltListExcel.do", method=RequestMethod.POST)
    public View selectAcqTidRsltListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        Map<String,Object>       dataMap           = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String frDate = (String)objMap.get( "txtFromDate" );
     	   	String frDt = "";
            frDt = frDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "frDt", frDt);
			String toDate = (String)objMap.get( "txtToDate" );
			String toDt = "";
            toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "toDt", toDt);
			objExcelData = purchaseMgmtService.selectAcqTidRsltList(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectAcqTidRsltListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Acq_Tid_Rslt_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new AcqTidRsltListExcelGenerator();
    }
    //매입결과 리스트 조회
  	@RequestMapping(value = "/selectAcqRsltList.do", method=RequestMethod.POST)
  	public ModelAndView selectAcqRsltList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "매입결과 - 매입결과 조회 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   log.info( "매입결과 - 매입결과 조회 - parameter : " + objMap );
  	        	   String fromDate = (String)objMap.get( "txtFromDate" );
  	        	   String frDt = "";
  	        	   frDt  = fromDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
  				   objMap.put( "frDt", frDt );
  				   String toDate = (String)objMap.get( "txtToDate" );
  	        	   String toDt = "";
  	        	   toDt  = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
  				   objMap.put( "toDt", toDt );
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "매입결과 - 매입결과 조회 - parameter : " + objMap );
  	        	   objList = 	purchaseMgmtService.selectAcqRsltList(objMap);
  	        	   intPageTotalCnt = 	purchaseMgmtService.selectAcqRsltListTotal(objMap);
  	    	   
  	           }
  	           else
  	           {
  	        	   log.info( "매입결과 - 매입결과 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "매입결과-Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "매입결과 - 매입결과 조회 - End -" );
  	    return objMv; 
  	}
  	//매입결과 내역 엑셀   
	@RequestMapping(value="/selectAcqRsltListExcel.do", method=RequestMethod.POST)
	public View selectAcqRsltListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	    Map<String,Object>       objMap           = new HashMap<String, Object>();        
	    Map<String,Object>       dataMap           = new HashMap<String, Object>();
	    List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	      
	    try { 
	        objMap = CommonUtils.queryStringToMap(strJsonParameter);
	        objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
	        objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
	        String frDate = (String)objMap.get( "txtFromDate" );
	   	   	String frDt = "";
	        frDt = frDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "frDt", frDt);
			String toDate = (String)objMap.get( "txtToDate" );
			String toDt = "";
	        toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "toDt", toDt);
			objExcelData = purchaseMgmtService.selectAcqRsltList(objMap);
	          
	    } catch(Exception ex) {
	        objExcelMap  = null;
	        objExcelData = null;
	        log.error("selectAcqRsltListExcel.do exception : " , ex);
	    } finally {
	        objExcelMap.put("excelName", "Acq_Rslt_List");
	        objExcelMap.put("excelData", objExcelData);
	        objExcelMap.put("reqData",   objMap);
	    }
	      
	    return new AcqRsltListExcelGenerator();
    }
	//반송조회/처리
	@RequestMapping(value = "/retInqProc.do")
	public String retInqProc(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "152");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0118"));

		model.addAttribute("MER_TYPE", CommonDDLB.merchantType4(DDLBType.SEARCH));
		model.addAttribute("STATE_CD", CommonDDLB.StateTypeOption(DDLBType.SEARCH));
		
		log.info( "반송조회/처리-1- 카드 조회" );
        Map<String, Object> dataMap = new HashMap< String, Object >();
        List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl="";
        dataMap.put( "code2", "pur" );
    	listMap = baseInfoRegistrationService.selectCardList( dataMap);   
    	model.addAttribute("CARD_LIST", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
    	log.info( "반송조회/처리-1- 처리상태 조회" );
    	codeCl = "0050";
    	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);   
    	model.addAttribute("PROC_CD", CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap));
    	model.addAttribute("PROC_CD1", CommonDDLB.ListOption(listMap));
    	log.info( "반송조회/처리 -입금보고서 체크  " );
    	model.addAttribute("APP_DEP_REP", CommonDDLB.AppDepRepOption());
    	log.info( "반송조회/처리-- 관리자 권한 조회" );
    	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute("authList", list);
    	model.addAttribute( "SETT_AUTH_FLG3" , list.get( 0 ).get( "SETT_AUTH_FLG3" ));
    	
		return "/calcuMgmt/purchaseMgmt/retInqProc";
	}
	//반송조회/처리 리스트 조회
  	@RequestMapping(value = "/selectAcqRetList.do", method=RequestMethod.POST)
  	public ModelAndView selectAcqRetList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "반송조회/처리 - 반송조회/처리 조회 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   log.info( "반송조회/처리 - 반송조회/처리 조회 - parameter : " + objMap );
  	        	   String acqFrDt = (String)objMap.get( "acqFrDt" );
  	        	   acqFrDt = acqFrDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
  	        	   objMap.put( "acqFrDt", acqFrDt);
  	        	   String acqToDt = (String)objMap.get( "acqToDt" );
  	        	   acqToDt = acqToDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
  	        	   objMap.put( "acqToDt", acqToDt);
  	        	   String retFrDt = (String)objMap.get( "retFrDt" );
  	        	   retFrDt = retFrDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
  	        	   objMap.put( "retFrDt", retFrDt);
  	        	   String retToDt = (String)objMap.get( "retToDt" );
  	        	   retToDt = retToDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
  	        	   objMap.put( "retToDt", retToDt);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "반송조회/처리 - 반송조회/처리 조회 - parameter : " + objMap );
  	        	   objList = 	purchaseMgmtService.selectAcqRetList(objMap);
  	        	   intPageTotalCnt = 	purchaseMgmtService.selectAcqRetListTotal(objMap);
  	    	   
  	           }
  	           else
  	           {
  	        	   log.info( "반송조회/처리 - 반송조회/처리 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "반송조회/처리-Exception : ", e );
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "반송조회/처리 - 반송조회/처리 조회 - End -" );
  	    return objMv; 
  	}
  	//반송조회/처리 내역 엑셀   
	@RequestMapping(value="/selectAcqRetListExcel.do", method=RequestMethod.POST)
	public View selectAcqRetListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	    Map<String,Object>       objMap           = new HashMap<String, Object>();        
	    Map<String,Object>       dataMap           = new HashMap<String, Object>();
	    List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	      
	    try { 
	        objMap = CommonUtils.queryStringToMap(strJsonParameter);
	        objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
	        objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
	        String acqFrDt = (String)objMap.get( "acqFrDt" );
	   	 	acqFrDt = acqFrDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "acqFrDt", acqFrDt);
			String acqToDt = (String)objMap.get( "acqToDt" );
			acqToDt = acqToDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "acqToDt", acqToDt);
			String retFrDt = (String)objMap.get( "retFrDt" );
			retFrDt = retFrDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "retFrDt", retFrDt);
			String retToDt = (String)objMap.get( "retToDt" );
			retToDt = retToDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "retToDt", retToDt);
			objExcelData = purchaseMgmtService.selectAcqRetList(objMap);
	          
	    } catch(Exception ex) {
	        objExcelMap  = null;
	        objExcelData = null;
	        log.error("selectAcqRetListExcel.do exception : " , ex);
	    } finally {
	        objExcelMap.put("excelName", "Acq_Return_List");
	        objExcelMap.put("excelData", objExcelData);
	        objExcelMap.put("reqData",   objMap);
	    }
	      
	    return new AcqRetListExcelGenerator();
    }
	//반송조회/처리 업데이트 
	@RequestMapping(value = "/updateRetProc.do", method=RequestMethod.POST)
	public ModelAndView updateRetProc(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "반송조회/처리 업데이트  - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "반송조회/처리 업데이트  - parameter : " + objMap );
	        	   dataMap = 	purchaseMgmtService.updateRetProc(objMap);
	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
	        		   intResultCode = 9999;
	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
	        	   }
	           }
	           else
	           {
	        	   log.info( "반송조회/처리 업데이트 -1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "반송조회/처리-Exception : ", e );
	   	}
	   	finally
	   	{
	   		if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "반송조회/처리 업데이트  - End -" );
	    return objMv; 
	}
}