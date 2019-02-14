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
import egov.linkpay.ims.calcuMgmt.service.AgentMgmtService;
import egov.linkpay.ims.calcuMgmt.service.CalcuMgmtService;
import egov.linkpay.ims.calcuMgmt.service.ReportMgmtService;
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
@RequestMapping(value = "/calcuMgmt/agencyStmtMgmt")
public class AgencyMgmtController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "baseInfoRegistrationService")
	private BaseInfoRegistrationService baseInfoRegistrationService;

	@Resource(name = "baseInfoMgmtService")
	private BaseInfoMgmtService baseInfoMgmtService;
	
	@Resource(name = "reportMgmtService")
	private ReportMgmtService reportMgmtService;
	
	@Resource(name = "agentMgmtService")
	private AgentMgmtService agentMgmtService;
	
	@RequestMapping(value = "/repStmt.do")
	public String repStmt(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "154");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0121"));
		
		model.addAttribute("division", CommonDDLB.SelectOption(DDLBType.ALL));
		
		return "/calcuMgmt/agencyStmtMgmt/repStmt";
	}
	//정산재생성 리스트
	@RequestMapping(value = "/selectAgentStmtList.do", method=RequestMethod.POST)
	public ModelAndView selectAgentStmtList(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "정산재생성 리스트  - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "정산재생성 리스트  - parameter : " + objMap );
	        	   dataMap = 	agentMgmtService.selectAgentStmtList(objMap);
	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
	        		   if(dataMap.get( "resultCd" ).equals( "9998" )){
	        			   objMv.addObject( "resultCd", dataMap.get( "resultCd" ) );
	        			   strResultMessage = (String)dataMap.get( "resultMsg" );
	        		   }else{
	        			   intResultCode = 9999;
	        			   strResultMessage = (String)dataMap.get( "resultMsg" );
	        		   }
	        	   }else{
	        		   objMv.addObject( "data", dataMap.get( "list" ) );
	        	   }
	           }
	           else
	        	   
	           {
	        	   log.info( "정산재생성 리스트 -1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "정산재생성 -Exception : ", e );
	   		intResultCode    = 9999;
            strResultMessage = "Exception Fail";
	   	}
	   	finally
	   	{
	   		if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
	   	}
	   	objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);   
	   	objMv.setViewName("jsonView");
	   	log.info( "정산재생성 리스트  - End -" );
	    return objMv; 
	}
	@RequestMapping(value = "/stmtMultiChk.do")
	public String stmtMultiChk(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "155");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0122"));
		
		model.addAttribute("YEAR", CommonDDLB.YearOption());
		model.addAttribute("MONTH", CommonDDLB.MonthOption());
		
		log.info( "정산_보류/해제/별도가감 -- " );
		String codeCl="";
		List<Map<String,String>> listMap = new ArrayList<>();
        codeCl = "0048";
    	listMap = baseInfoRegistrationService.selectCodeCl( codeCl);   
    	model.addAttribute("LstCardCode", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
    	model.addAttribute("LstCardCode1", CommonDDLB.ListOption( listMap ));
		
    	log.info( "정산보류/해제/별도가감 - 구분2 DEFAULT_CD2" );
    	Map<String,Object> dataMap = new HashMap<String,Object>();
    	dataMap.put( "codeCl", "0048");
        dataMap.put( "code2", "01");
        listMap = reportMgmtService.selectCode2List( dataMap);   
    	model.addAttribute("DEFAULT_CD2", CommonDDLB.ListOptionCode2( listMap ));

    	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute( "SETT_AUTH_FLG2" , list.get( 0 ).get( "SETT_AUTH_FLG2" ));
    	
		return "/calcuMgmt/agencyStmtMgmt/stmtMultiChk";
	}
	//카테고리 소분류 조회
    @RequestMapping(value="/selectCode2List.do", method=RequestMethod.POST)
    public ModelAndView selectCode2List(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	List<Map<String,String>> objList = new ArrayList<Map<String, String>>();
    	Map<String, Object> dataMap = new HashMap< String, Object >();
		List<Map<String,String>> listMap = new ArrayList<Map<String,String>>();
		
        int    intResultCode    = 0;
        String strResultMessage = "";
        try 
        {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
            {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                CommonUtils.initSearchRange(objMap);
                
                dataMap.put( "codeCl", "0048");
                dataMap.put( "code2", objMap.get( "code1" ));
                listMap = reportMgmtService.selectCode2List( dataMap);   
                //objMv.addObject("typeList", CommonDDLB.ListOptionCode2(listMap));
                objMv.addObject("typeList", CommonDDLB.ListOptionCode2Set(DDLBType.SEARCH, listMap));
            }
            else 
            {
                intResultCode    = 9999;
                strResultMessage = "Fail";
            }
        } 
        catch(Exception e) 
        {
            intResultCode    = 9999;
            strResultMessage = "Exception Fail";
            log.error("selectCode2List.do exception : " , e);
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
        
        return objMv;
    }
    //보류/해제/별도가감/이월 금액
  	@RequestMapping(value = "/selectAgentResrRemainAmt.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentResrRemainAmt(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		long amt = 0;
  		int i=0;
  	   	log.info( "보류/해제/별도가감/이월 금액  - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   log.info( "보류/해제/별도가감/이월 금액  - parameter : " + objMap );
  	        	   amt = 	agentMgmtService.selectAgentResrRemainAmt(objMap);
  	        	   objMv.addObject( "REMAIN_AMT", amt );
  	           }
  	           else
  	           {
  	        	   log.info( "보류/해제/별도가감/이월 금액 -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "보류/해제/별도가감/이월 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "보류/해제/별도가감/이월 금액  - End -" );
  	    return objMv; 
  	}
    //보류/해제/별도가감/이월 리스트 조회
  	@RequestMapping(value = "/selectAgentResrEtcList.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentResrEtcList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "보류/해제/별도가감/이월 - 보류/해제/별도가감/이월 조회 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "보류/해제/별도가감/이월 - 보류/해제/별도가감/이월 조회 - parameter : " + objMap );
  	        	   objList = 	agentMgmtService.selectAgentResrEtcList(objMap);
  	        	   intPageTotalCnt = 	agentMgmtService.selectAgentResrEtcListTotal(objMap);
  	    	   
  	           }
  	           else
  	           {
  	        	   log.info( "보류/해제/별도가감/이월 - 보류/해제/별도가감/이월 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "보류/해제/별도가감/이월-Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "보류/해제/별도가감/이월 - 보류/해제/별도가감/이월 조회 - End -" );
  	    return objMv; 
  	}
  	//보류/해제/별도가감/이월 내역 엑셀   
	@RequestMapping(value="/selectAgentResrEtcListExcel.do", method=RequestMethod.POST)
	public View selectAgentResrEtcListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	    Map<String,Object>       objMap           = new HashMap<String, Object>();        
	    Map<String,Object>       dataMap           = new HashMap<String, Object>();
	    List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	      
	    try { 
	        objMap = CommonUtils.queryStringToMap(strJsonParameter);
	        objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
	        objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
			objExcelData = agentMgmtService.selectAgentResrEtcList(objMap);
	          
	    } catch(Exception ex) {
	        objExcelMap  = null;
	        objExcelData = null;
	        log.error("selectAcqRetListExcel.do exception : " , ex);
	    } finally {
	        objExcelMap.put("excelName", "Agent_Stmt_Conf_List");
	        objExcelMap.put("excelData", objExcelData);
	        objExcelMap.put("reqData",   objMap);
	    }
	      
	    return new AgentResrEtcListExcelGenerator(); 
    }
	//보류/해제/별도가감/이월 등록
  	@RequestMapping(value = "/insertAgentResrEtc.do", method=RequestMethod.POST)
  	public ModelAndView insertAgentResrEtc(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "보류/해제/별도가감/이월 등록 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   String payDt = (String)objMap.get( "payDt" );
  	        	   payDt = payDt.replaceAll("(\\d+)/(\\d+)", "$1$2" );
	        	   objMap.put( "payDt", payDt);
  	        	   log.info( "보류/해제/별도가감/이월 등록  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.insertAgentResrEtc(objMap);
  	        	   if(!dataMap.get("resultCd").equals( "0000" ))
  	        	   {
  	        		 intResultCode = 9999;
  	        		 strResultMessage = ( String ) dataMap.get( "resultMsg" );
  	        	   }
  	        	   objMv.addObject( "dataMap", dataMap );
  	           }
  	           else
  	           {
  	        	   log.info( "보류/해제/별도가감/이월 등록 -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	        	   
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "보류/해제/별도가감/이월 등록 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "보류/해제/별도가감/이월 등록  - End -" );
  	    return objMv; 
  	}
  	//보류/해제/별도가감/이월 삭제
  	@RequestMapping(value = "/deleteAgentResrExtra.do", method=RequestMethod.POST)
  	public ModelAndView deleteAgentResrExtra(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "보류/해제/별도가감/이월 삭제 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
//  	        	   String payDt = (String)objMap.get( "payDt" );
//  	        	   payDt = payDt.replaceAll("(\\d+)/(\\d+)", "$1$2" );
//	        	   objMap.put( "payDt", payDt);
  	        	   log.info( "보류/해제/별도가감/이월 삭제  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.deleteAgentResrExtra(objMap);
  	        	   if(!dataMap.get("resultCd").equals( "0000" ))
  	        	   {
  	        		 intResultCode = 9999;
  	        		 strResultMessage = ( String ) dataMap.get( "resultMsg" );
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "보류/해제/별도가감/이월 삭제 -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "보류/해제/별도가감/이월 삭제 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "보류/해제/별도가감/이월 삭제  - End -" );
  	    return objMv; 
  	}
  	//보류/해제/별도가감/이월 수정
  	@RequestMapping(value = "/updateAgentResrEtc.do", method=RequestMethod.POST)
  	public ModelAndView updateAgentResrEtc(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "보류/해제/별도가감/이월 수정 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   String payDt = (String)objMap.get( "payDt" );
  	        	   payDt = payDt.replaceAll("(\\d+)/(\\d+)", "$1$2" );
	        	   objMap.put( "payDt", payDt);
  	        	   log.info( "보류/해제/별도가감/이월 수정  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.updateAgentResrEtc(objMap);
  	        	   if(!dataMap.get("resultCd").equals( "0000" ))
  	        	   {
  	        		 intResultCode = 9999;
  	        		 strResultMessage = ( String ) dataMap.get( "resultMsg" );
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "보류/해제/별도가감/이월 수정 -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "보류/해제/별도가감/이월 수정 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "보류/해제/별도가감/이월 수정  - End -" );
  	    return objMv; 
  	}
	@RequestMapping(value = "/stmtReportSend.do")
	public String stmtReportSend(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "156");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0123"));
		
		model.addAttribute("YEAR", CommonDDLB.YearOption());
		model.addAttribute("MONTH", CommonDDLB.MonthOption());
		
		return "/calcuMgmt/agencyStmtMgmt/stmtReportSend";
	}
	//정산보고서 리스트 조회
  	@RequestMapping(value = "/selectAgentStmtReportList.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentStmtReportList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서작성 - 정산보고서작성 조회 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   log.info( "정산보고서작성 - 정산보고서작성 조회 - parameter : " + objMap );
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   String dt = objMap.get( "year" ).toString() + objMap.get( "mon" );
  	        	   objMap.put( "mon", dt );
  	        	   log.info( "정산보고서작성 - 정산보고서작성 조회 - parameter : " + objMap );
  	        	   objList = 	agentMgmtService.selectAgentStmtReportList(objMap);
  	        	   intPageTotalCnt = 	agentMgmtService.selectAgentStmtReportListTotal(objMap);
  	    	   
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서작성 - 정산보고서작성 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서발송-Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "정산보고서작성 - 정산보고서작성 조회 - End -" );
  	    return objMv; 
  	}
  	@RequestMapping(value="/selectAgentStmtConfirmListExcel.do", method=RequestMethod.POST)
	public View selectAgentStmtConfirmListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	    Map<String,Object>       objMap           = new HashMap<String, Object>();        
	    Map<String,Object>       dataMap           = new HashMap<String, Object>();
	    List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	      
	    try { 
	        objMap = CommonUtils.queryStringToMap(strJsonParameter);
	        objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
	        objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
	        String date = objMap.get( "year" ).toString() + objMap.get( "mon" ).toString();
       	    objMap.put( "date", date );
			objExcelData = agentMgmtService.selectAgentStmtConfirmList(objMap);
	          
	    } catch(Exception ex) {
	        objExcelMap  = null;
	        objExcelData = null;
	        log.error("selectAcqRetListExcel.do exception : " , ex);
	    } finally {
	        objExcelMap.put("excelName", "Agent_Stmt_Conf_List");
	        objExcelMap.put("excelData", objExcelData);
	        objExcelMap.put("reqData",   objMap);
	    }
	      
	    return new AgentStmtConfirmListExcelGenerator(); 
    }
  	//정산보고서발송 내역 엑셀   
	@RequestMapping(value="/selectAgentStmtReportListExcel.do", method=RequestMethod.POST)
	public View selectAgentStmtReportListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	    Map<String,Object>       objMap           = new HashMap<String, Object>();        
	    Map<String,Object>       dataMap           = new HashMap<String, Object>();
	    List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	      
	    try { 
	        objMap = CommonUtils.queryStringToMap(strJsonParameter);
	        objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
	        objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
	        String date = objMap.get( "year" ).toString() + objMap.get( "mon" ).toString();
       	    objMap.put( "date", date );
			objExcelData = agentMgmtService.selectAgentStmtReportList(objMap);
	          
	    } catch(Exception ex) {
	        objExcelMap  = null;
	        objExcelData = null;
	        log.error("selectAgentStmtReportListExcel.do exception : " , ex);
	    } finally {
	        objExcelMap.put("excelName", "Agent_Stmt_Report_List");
	        objExcelMap.put("excelData", objExcelData);
	        objExcelMap.put("reqData",   objMap);
	    }
	      
	    return new AgentStmtReportListExcelGenerator(); 
    }
	//정산보고서발송 상세내역 조회
  	@RequestMapping(value = "/selectAgentCompPayAmtListDetail.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentCompPayAmtListDetail(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서작성 - 정산보고서발송 조회 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   log.info( "정산보고서발송 - 정산보고서발송 조회 - parameter : " + objMap );
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "정산보고서발송 - 정산보고서발송 조회 - parameter : " + objMap );
  	        	   objList = 	agentMgmtService.selectAgentCompPayAmtListDetail(objMap);
  	        	   intPageTotalCnt = 	agentMgmtService.selectAgentCompPayAmtListDetailTotal(objMap);
  	    	   
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서발송 - 정산보고서발송 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서발송-Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "정산보고서발송 - 정산보고서발송 조회 - End -" );
  	    return objMv; 
  	}
  	//정산보고서발송  메일
  	@RequestMapping(value = "/selectAgentStmtTaxAccount.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentStmtTaxAccount(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서확정 리스트  - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "정산보고서확정 리스트  - parameter : " + objMap );
  	        	   objMap.put( "MER_ID", objMap.get( "vid" ) );
  	        	   objList = 	agentMgmtService.selectVidInfo(objMap.get( "MER_ID" ).toString());
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서확정 리스트 -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	        	   strResultMessage = "Data Not Exist";
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서확정 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "정산보고서확정 리스트  - End -" );
  	    return objMv; 
  	}
	@RequestMapping(value = "/stmtReportWrite.do")
	public String stmtReportWrite(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "157");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0124"));
		
		model.addAttribute("YEAR", CommonDDLB.YearOption());
		model.addAttribute("MONTH", CommonDDLB.MonthOption());
		model.addAttribute("TYPE", CommonDDLB.TypeOption1(DDLBType.ALL));
		
		return "/calcuMgmt/agencyStmtMgmt/stmtReportWrite";
	}
	//정산보고서발송 수정
  	@RequestMapping(value = "/sendAgentStmtTaxAccount.do", method=RequestMethod.POST)
  	public ModelAndView sendAgentStmtTaxAccount(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서발송 수정 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   log.info( "정산보고서발송 수정  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.sendAgentStmtTaxAccount(objMap);
  	        	   if(!dataMap.get("resultCd").equals( "0000" ))
  	        	   {
  	        		 intResultCode = 9999;
  	        		 strResultMessage = ( String ) dataMap.get( "resultMsg" );
  	        	   }else{
  	        		 strResultMessage = "SUCESS";
  	        	   }
  	        	   
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서발송 수정 -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서발송 수정 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "정산보고서발송 수정  - End -" );
  	    return objMv; 
  	}
	//정산보고서작성 리스트 조회
  	@RequestMapping(value = "/selectAgentStmtConfirmList.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentStmtConfirmList(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서작성 - 정산보고서작성 조회 - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   String date = objMap.get( "year" ).toString() + objMap.get( "mon" ).toString();
  	        	   objMap.put( "date", date );
  	        	   log.info( "정산보고서작성 - 정산보고서작성 조회 - parameter : " + objMap );
  	        	   
  	        	   objList = 	agentMgmtService.selectAgentStmtConfirmList(objMap);
  	        	   intPageTotalCnt = 	agentMgmtService.selectAgentStmtConfirmListTotal(objMap);
  	    	   
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서작성 - 정산보고서작성 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서작성-Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}
  	       
  	   	objMv.setViewName("jsonView");
  	   	log.info( "정산보고서작성 - 정산보고서작성 조회 - End -" );
  	    return objMv; 
  	}
  	//정산보고서작성 내역 엑셀   
	@RequestMapping(value="/selectAgentStmtConfExcel.do", method=RequestMethod.POST)
	public View selectAgentStmtConfListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	    Map<String,Object>       objMap           = new HashMap<String, Object>();        
	    Map<String,Object>       dataMap           = new HashMap<String, Object>();
	    List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	      
	    try { 
	        objMap = CommonUtils.queryStringToMap(strJsonParameter);
	        objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
	        objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
			objExcelData = agentMgmtService.selectAgentStmtConfirmList(objMap);
	          
	    } catch(Exception ex) {
	        objExcelMap  = null;
	        objExcelData = null;
	        log.error("selectAcqRetListExcel.do exception : " , ex);
	    } finally {
	        objExcelMap.put("excelName", "Agent_Stmt_Conf_List");
	        objExcelMap.put("excelData", objExcelData);
	        objExcelMap.put("reqData",   objMap);
	    }
	      
	    return new AgentStmtConfirmListExcelGenerator(); //AgentStmtConfirmListExcelGenerator
    }
	//정산보고서 확정 
	@RequestMapping(value = "/stmtReportConfirm.do")
	public String stmtReportConfirm(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "158");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0125"));
		
		model.addAttribute("YEAR", CommonDDLB.YearOption());
		model.addAttribute("MONTH", CommonDDLB.MonthOption());
		
		List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	Map<String,Object> dataMap= new HashMap<String,Object>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute( "SETT_AUTH_FLG6" , list.get( 0 ).get( "SETT_AUTH_FLG6" ));
		
		return "/calcuMgmt/agencyStmtMgmt/stmtReportConfirm";
	}
	//정산보고서확정 리스트
	@RequestMapping(value = "/selectAgentStmtConfList.do", method=RequestMethod.POST)
	public ModelAndView selectAgentStmtConfList(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "정산보고서확정 리스트  - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "정산보고서확정 리스트  - parameter : " + objMap );
	        	   dataMap = 	agentMgmtService.selectAgentStmtConfList(objMap);
	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
	        		   intResultCode = 9999;
	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
	        	   }else{
	        		   objMv.addObject( "list", dataMap.get( "list" ) );
	        		   objMv.addObject( "data", dataMap.get( "data" ) );
	        		   objMv.addObject( "tot", dataMap.get( "tot" ) );
	        	   }
	           }
	           else
	           {
	        	   log.info( "정산보고서확정 리스트 -1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "정산보고서확정 -Exception : ", e );
	   		intResultCode    = 9999;
            strResultMessage = "Exception Fail";
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
	   	log.info( "정산보고서확정 리스트  - End -" );
	    return objMv; 
	}
	//정산보고서확정 저장
  	@RequestMapping(value = "/updateAgentStmtAdSave.do", method=RequestMethod.POST)
  	public ModelAndView updateAgentStmtAdSave(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서확정 저장  - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "정산보고서확정 저장  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.updateAgentStmtAdSave(objMap);
  	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
  	        		   intResultCode = 9999;
  	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
  	        	   }else{
  	        		   
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서확정 저장  -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서확정 저장 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "정산보고서확정 저장 - End -" );
  	    return objMv; 
  	}
  //정산보고서확정 확정취소
  	@RequestMapping(value = "/updateAgentStmtAdCancel.do", method=RequestMethod.POST)
  	public ModelAndView updateAgentStmtAdCancel(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서확정 확정취소  - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "정산보고서확정 확정취소  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.updateAgentStmtAdCancel(objMap);
  	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
  	        		   intResultCode = 9999;
  	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
  	        	   }else{
  	        		   
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서확정 확정취소  -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서확정 확정취소 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "정산보고서확정 확정취소  - End -" );
  	    return objMv; 
  	}
  	//정산보고서 확정 송금 엑셀   
  	@RequestMapping(value="/selectAgentStmtConfirmedListExcel.do", method=RequestMethod.POST)
  	public View selectAgentStmtConfirmedListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
  	    Map<String,Object>       objMap           = new HashMap<String, Object>();        
  	    Map<String,Object>       dataMap           = new HashMap<String, Object>();
  	    Map<String,Object>       totMap           = new HashMap<String, Object>();
  	    List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
  	      
  	    try { 
  	        objMap = CommonUtils.queryStringToMap(strJsonParameter);
  	        objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
  	        objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
  	        dataMap = agentMgmtService.selectAgentStmtConfList(objMap);
  			objExcelData = ( List< Map< String, Object > > ) dataMap.get( "list" ) ;
  			totMap = ( Map< String, Object > ) dataMap.get( "tot" ) ;
  	          
  	    } catch(Exception ex) {
  	        objExcelMap  = null;
  	        objExcelData = null;
  	        log.error("selectAcqRetListExcel.do exception : " , ex);
  	    } finally {
  	        objExcelMap.put("excelName", "Agent_Stmt_Confirmed_List");
  	        objExcelMap.put("excelData", objExcelData);
  	        objExcelMap.put("reqData",   objMap);
  	        objExcelMap.put("totData",   totMap);
  	    }
  	      
  	    return new AgentStmtConfirmedListExcelGenerator(); 
      }
  	//송금보고서확정 송금보고서 엑셀  
    @RequestMapping(value="/selectAgentSendReportExcel.do", method=RequestMethod.POST)
    public View selectSendReportExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        Map<String,Object>       dataMap           = new HashMap<String, Object>();
        Map<String,Object>       dMap           = new HashMap<String, Object>();
        Map<String,Object>       totMap           = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
			dataMap = agentMgmtService.selectAgentStmtConfList(objMap); 
			objExcelData = ( List< Map< String, Object > > ) dataMap.get( "list" ) ;
			dMap = ( Map< String, Object > ) dataMap.get( "data" ) ;
  			totMap = ( Map< String, Object > ) dataMap.get( "tot" ) ;
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectStmtPayRepListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "AgentSendReportDown");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
            objExcelMap.put("dMap",   dMap);
            objExcelMap.put("totMap",   totMap);
        }
        
        return new SendAgentReportListExcelGenerator();
    }
    //정산보고서확정 등록비 배분 상세조회
  	@RequestMapping(value = "/selectAgentCoPayAmtDetail.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentCoPayAmtDetail(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서확정 등록비 배분 상세조회  - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "정산보고서확정 등록비 배분 상세조회  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.selectAgentCoPayAmtDetail(objMap);
  	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
  	        		   intResultCode = 9999;
  	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
  	        	   }else{
  	        		   objMv.addObject( "data", dataMap.get( "list" ));
  	        		   objMv.addObject( "totMap", dataMap.get( "totMap" ));
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서확정 등록비 배분 상세조회  -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서확정 등록비 배분 상세조회 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "정산보고서확정 등록비 배분 상세조회  - End -" );
  	    return objMv; 
  	}
  //정산보고서확정 이월내역 상세조회
  	@RequestMapping(value = "/selectAgentStmtCarryDetail.do", method=RequestMethod.POST)
  	public ModelAndView selectAgentStmtCarryDetail(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서확정  이월내역 상세조회  - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "정산보고서확정  이월내역 상세조회  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.selectAgentStmtCarryDetail(objMap);
  	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
  	        		   intResultCode = 9999;
  	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
  	        	   }else{
  	        		   objMv.addObject( "data", dataMap.get( "list" ));
	        		   objMv.addObject( "totMap", dataMap.get( "totMap" ));
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서확정  이월내역 상세조회  -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서확정  이월내역 상세조회 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "정산보고서확정  이월내역 상세조회  - End -" );
  	    return objMv; 
  	}
  	//정산보고서확정 확정 취소 ?
  	@RequestMapping(value = "/updateConfStmtSave.do", method=RequestMethod.POST)
  	public ModelAndView updateConfStmtSave(@RequestBody String strJsonParameter) throws Exception 
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "정산보고서확정 확정 취소  - Start -" );
  	   	try 
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "정산보고서확정 확정 취소  - parameter : " + objMap );
  	        	   dataMap = 	agentMgmtService.updateConfStmtSave(objMap);
  	        	   if(!dataMap.get( "resultCd" ).equals( "0000" )){
  	        		   intResultCode = 9999;
  	        		   strResultMessage = (String)dataMap.get( "resultMsg" );
  	        	   }else{
  	        		   objMv.addObject( "data", dataMap.get( "list" ));
  	        		   objMv.addObject( "totMap", dataMap.get( "totMap" ));
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "정산보고서확정 확정 취소  -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }
             
  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "정산보고서확정 확정 취소 -Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
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
  	   	log.info( "정산보고서확정 확정 취소  - End -" );
  	    return objMv; 
  	}
}
