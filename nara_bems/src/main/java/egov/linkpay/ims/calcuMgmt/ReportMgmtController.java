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
import egov.linkpay.ims.businessmgmt.SubmallCardListExcelGenerator;
import egov.linkpay.ims.calcuMgmt.service.CalcuMgmtService;
import egov.linkpay.ims.calcuMgmt.service.ReportMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;

/**
 * ------------------------------------------------------------ Package Name :
 * egov.linkpay.ims.home File Name : HomeController.java Description : Home
 * Controller(Dashboard) Author : ymjo, 2015. 10. 5. Modify History : Just
 * Created. ------------------------------------------------------------
 */
@Controller
@RequestMapping(value = "/calcuMgmt/reportMgmt")
public class ReportMgmtController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "baseInfoRegistrationService")
	private BaseInfoRegistrationService baseInfoRegistrationService;

	@Resource(name = "reportMgmtService")
	private ReportMgmtService reportMgmtService;

	@Resource(name = "baseInfoMgmtService")
	private BaseInfoMgmtService baseInfoMgmtService;

	//보고서 작성 daily
	@RequestMapping(value = "/reportDaily.do")
	public String reportDaily(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "143");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0126"));

		model.addAttribute("division", CommonDDLB.ReportSearchOption(DDLBType.ALL));

		return "/calcuMgmt/reportMgmt/reportDaily";
	}
	//정산 id 여부 체크
    @RequestMapping(value = "/selectStmtList.do" , method=RequestMethod.POST)
    public ModelAndView selectStmtIdChk(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	Map< String, Object > dataMap = new HashMap<String, Object>();
    	List<Map< String, Object >> objList = new ArrayList<Map<String, Object>>();
    	log.info( "보고서 작성-정산 id 여부- Start -" );
        int    intResultCode    = 0;
        int intPageTotalCnt = 0;
        String strResultMessage = "";
        int cnt =0;
    	try
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
            	log.info( "보고서 작성-정산 id 여부-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	CommonUtils.initSearchRange(objMap);
			    log.info( "보고서 작성-정산 id 여부-1-파라미터 : " + objMap );
			    dataMap = reportMgmtService.selectStmtList(objMap);
			    if( !dataMap.get( "resultCd" ).equals( "0000" )){
			    	intResultCode = 9999;
		    		strResultMessage = (String)dataMap.get( "resultMsg" );
			    }else{
			    	objList = ( List< Map< String, Object > > ) dataMap.get( "listMap" );
			    	intPageTotalCnt =  ( int ) dataMap.get( "listCnt" );
			    }
            }
            else
            {
            	log.info( "보고서 작성-정산 id 여부-1-파라미터 null " );
            	intResultCode = 9999;
            }
    	}
    	catch(Exception e)
    	{
    		log.error( "보고서 작성-Exception : ", e );
    		intResultCode = 9999;
    		strResultMessage = "EXCEPTION FAIL ";
    	}
        finally
        {
        	objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
		}
    	objMv.setViewName("jsonView");

    	log.info( "보고서 작성-정산 id 여부- End -" );
        return objMv;
    }
	//임의지급보류
	@RequestMapping(value = "/randomHold.do")
	public String randomHold(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "144");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0106"));
		model.addAttribute("MER_TYPE", CommonDDLB.merchantType7(DDLBType.ALL));

		log.info( "정산_보류/해제/별도가감-- 관리자 권한 조회" );
    	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	Map<String, Object> dataMap = new HashMap<String, Object>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute("authList", list);
    	model.addAttribute( "SETT_AUTH_FLG2" , list.get( 0 ).get( "SETT_AUTH_FLG2" ));

		return "/calcuMgmt/reportMgmt/randomHold";
	}
	//임의지급보류 등록
    @RequestMapping(value="/insertResrSet.do", method=RequestMethod.POST)
    public ModelAndView insertResrSet(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();

        int intResultCode    = 0;
        int cnt = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
            	log.info( "보고서 작성- 보류/해제/별도가감 등록 - Start -" );
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                String payDate = (String)objMap.get( "startDt" );
        	    payDate = payDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			    objMap.put( "startDt", payDate);
			    String amt = CommonUtils.ConvertAmt( objMap.get( "setAmt" ) );
			    objMap.put( "setAmt", amt);
                log.info( "request parameter :  " + objMap );
                dataMap = reportMgmtService.insertResrSet(objMap);
                if(!dataMap.get( "resultCd" ).equals( "0000" ))
                {
                	intResultCode    = 9999;
                    strResultMessage = ( String ) dataMap.get( "resultMsg" );
                }
                objMv.addObject( "data" , dataMap );

            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmt.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
	//임의지급보류 리스트 조회
	@RequestMapping(value = "/selectResrSetList.do", method=RequestMethod.POST)
	public ModelAndView selectResrSetList(@RequestBody String strJsonParameter) throws Exception
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "보고서 작성- 임의지급보류 리스트 조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String frDate = (String)objMap.get( "txtFromDate" );
	        	   String frDt = "";
	               frDt = frDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "frDt", frDt);
				   String toDate = (String)objMap.get( "txtToDate" );
				   String toDt = "";
	               toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "toDt", toDt);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "보고서 작성- 임의지급보류 리스트 조회 - parameter : " + objMap );
	               objList = 	reportMgmtService.selectResrSetList(objMap);
	               intPageTotalCnt = 	(Integer)reportMgmtService.selectResrSetListTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "보고서 작성- 임의지급보류 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "보고서 작성-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "보고서 작성- 임의지급보류 리스트 조회 - End -" );
	    return objMv;
	}

	//지급데이터검증
	@RequestMapping(value = "/payDataChk.do")
	public String payDataChk(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "145");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0107"));

		return "/calcuMgmt/reportMgmt/payDataChk";
	}
	//지급데이터검증 리스트
	@RequestMapping(value = "/selectStmtInsList.do", method=RequestMethod.POST)
	public ModelAndView selectStmtInsList(@RequestBody String strJsonParameter) throws Exception
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "보고서 작성- 지급데이터검증 리스트 조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String stmtDate = (String)objMap.get( "stmtDt" );
	        	   String stmtDt = "";
	        	   stmtDt = stmtDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "stmtDt", stmtDt);
				   if(objMap.get( "selType" ).equals( "settlmnt" ))
				   {
					   String toDate = (String)objMap.get( "toDt" );
					   String toDt = "";
					   toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
					   objMap.put( "to", toDt);
				   }
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "보고서 작성- 지급데이터검증 리스트 조회 - parameter : " + objMap );
	               objList = 	reportMgmtService.selectStmtInsList(objMap);
	               //intPageTotalCnt = 	(Integer)reportMgmtService.selectResrSetListTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "보고서 작성- 지급데이터검증 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "보고서 작성-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "보고서 작성- 지급데이터검증 리스트 조회 - End -" );
	    return objMv;
	}
	@RequestMapping(value = "/selectStmtFeeInsList.do", method=RequestMethod.POST)
	public ModelAndView selectStmtFeeInsList(@RequestBody String strJsonParameter) throws Exception
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "보고서 작성- 지급데이터검증 리스트 조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String stmtDate = (String)objMap.get( "stmtDt" );
	        	   String stmtDt = "";
	        	   stmtDt = stmtDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "stmtDt", stmtDt);
				   if(objMap.get( "selType" ).equals( "settlmnt" ))
				   {
					   String toDate = (String)objMap.get( "toDt" );
					   String toDt = "";
					   toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
					   objMap.put( "to", toDt);
				   }
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "보고서 작성- 지급데이터검증 리스트 조회 - parameter : " + objMap );
	               objList = 	reportMgmtService.selectStmtFeeInsList(objMap);
	           }
	           else
	           {
	        	   log.info( "보고서 작성- 지급데이터검증 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "보고서 작성-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "보고서 작성- 지급데이터검증 리스트 조회 - End -" );
	    return objMv;
	}
	//지급데이터검증 리스트 조회
	@RequestMapping(value = "/selectStmtOffInsList.do", method=RequestMethod.POST)
	public ModelAndView selectStmtOffInsList(@RequestBody String strJsonParameter) throws Exception
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "보고서 작성- 지급데이터검증 리스트 조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String stmtDate = (String)objMap.get( "stmtDt" );
	        	   String stmtDt = "";
	        	   stmtDt = stmtDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "stmtDt", stmtDt);
				   String selType = (String)objMap.get( "selType" );
				   if(selType ==  "app" )
				   {
					   String toDate = (String)objMap.get( "toDt" );
					   String toDt = "";
					   toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
					   objMap.put( "to", toDt);
				   }
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "보고서 작성- 지급데이터검증 리스트 조회 - parameter : " + objMap );
	               objList = 	reportMgmtService.selectStmtOffInsList(objMap);
	               //intPageTotalCnt = 	(Integer)reportMgmtService.selectResrSetListTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "보고서 작성- 지급데이터검증 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "보고서 작성-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "보고서 작성- 지급데이터검증 리스트 조회 - End -" );
	    return objMv;
	}
	//지급보고서작성
	@RequestMapping(value = "/writePayReport.do")
	public String writePayReport(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "146");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0108"));

		model.addAttribute("selType", CommonDDLB.TypeOption(DDLBType.SEARCH));
		model.addAttribute("selDecide", CommonDDLB.DecideOption(DDLBType.SEARCH));
		model.addAttribute("selPayType", CommonDDLB.PayTypeOption());

		log.info( "정산_보류/해제/별도가감-- 관리자 권한 조회" );
    	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	Map<String,Object> dataMap= new HashMap<String,Object>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute( "SETT_AUTH_FLG5" , list.get( 0 ).get( "SETT_AUTH_FLG5" ));
    	model.addAttribute( "SETT_AUTH_FLG6" , list.get( 0 ).get( "SETT_AUTH_FLG6" ));

		return "/calcuMgmt/reportMgmt/writePayReport";
	}
	//지급보고서작성 리스트 조회
	@RequestMapping(value = "/selectStmtPayRepList.do", method=RequestMethod.POST)
	public ModelAndView selectStmtPayRepList(@RequestBody String strJsonParameter) throws Exception
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "보고서 작성- 지급보고서작성 리스트 조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String fromDate = (String)objMap.get( "txtFromDate" );
	        	   String frDt = "";
	        	   frDt = fromDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "frDt", frDt);
				   String toDate = (String)objMap.get( "txtToDate" );
				   String toDt = "";
				   toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "toDt", toDt);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "보고서 작성- 지급보고서작성 리스트 조회 - parameter : " + objMap );
	               objList = 	reportMgmtService.selectStmtPayRepList(objMap);
	               intPageTotalCnt = 	(Integer)reportMgmtService.selectStmtPayRepListTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "보고서 작성- 지급보고서작성 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "보고서 작성-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "보고서 작성- 지급보고서작성 리스트 조회 - End -" );
	    return objMv;
	}
	//지급보고서 작성 엑셀
    @RequestMapping(value="/selectStmtPayRepListExcel.do", method=RequestMethod.POST)
    public View selectStmtPayRepListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
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
			objExcelData = reportMgmtService.selectStmtPayRepList(objMap);

        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectStmtPayRepListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Settlement_Pay_Report_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }

        return new SendReportListExcelGenerator();
    }
	//송금보고서확정
	@RequestMapping(value = "/remitReportConfirm.do")
	public String remitReportConfirm(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "147");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0109"));
		return "/calcuMgmt/reportMgmt/remitReportConfirm";
	}
	//송금보고서확정
	@RequestMapping(value="/selectReportSearch.do", method=RequestMethod.POST)
    public ModelAndView selectReportSearch(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();

        int intResultCode    = 0;
        int cnt = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
            	log.info( "보고서 작성- 송금보고서확정 - Start -" );
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                String payDate = (String)objMap.get( "stmtDt" );
        	    payDate = payDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			    objMap.put( "stmtDt", payDate);
                log.info( "request parameter :  " + objMap );
                dataMap = reportMgmtService.selectReportSearch(objMap);
                if(!dataMap.get( "resultCd" ).equals( "0000" ))
                {
                	intResultCode    = 9999;
                    strResultMessage = ( String ) dataMap.get( "resultMsg" );
                }
                objMv.addObject( "pmReport" , dataMap.get( "pmReport" ) );
                objMv.addObject( "confData" , dataMap.get( "confData" ) );
                objMv.addObject( "refundCnt" , dataMap.get( "refundCnt" ) );

            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectReportSearch.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
	//송금보고서확정 송금보고서 엑셀
    @RequestMapping(value="/selectSendListExcel.do", method=RequestMethod.POST)
    public View selectSendListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();
        Map<String,Object>       dataMap           = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();

        try {
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String stmtDate = (String)objMap.get( "stmtDt" );
     	   	String stmtDt = "";
     	   	stmtDt = stmtDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "stmtDt", stmtDt);
			objExcelData = reportMgmtService.selectSendList(objMap);

        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectSendListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "SendListDown");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }

        return new SendListExcelGenerator();
    }
    //송금보고서확정 송금보고서 엑셀
    @RequestMapping(value="/selectSendReportExcel.do", method=RequestMethod.POST)
    public View selectSendReportExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();
        Map<String,Object>       dataMap           = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();

        try {
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String stmtDate = (String)objMap.get( "stmtDt" );
     	   	String stmtDt = "";
     	   	stmtDt = stmtDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "stmtDt", stmtDt);
			objExcelData = reportMgmtService.selectSendReport(objMap);

        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectStmtPayRepListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "SendReportDown");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }

        return new SendReportListExcelGenerator();
    }
    //송금보고서확정 송금보고서 엑셀
    @RequestMapping(value="/selectPgStmtExcel.do", method=RequestMethod.POST)
    public View selectPgStmtExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();
        Map<String,Object>       dataMap           = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();

        try {
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String stmtDate = (String)objMap.get( "stmtDt" );
     	   	String stmtDt = "";
     	   	stmtDt = stmtDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "stmtDt", stmtDt);
			objExcelData = reportMgmtService.selectPgStmtDetail(objMap);

        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectStmtPayRepListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "SendReportDown");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("cardLst", dataMap.get( "cardLst" ));
            objExcelMap.put("reqData",   objMap);
        }

        return new PgStmtListExcelGenerator();
    }
    //송금보고서확정 개인고객 직접 환불 내역 다운 엑셀
    @RequestMapping(value="/selectSendRefundExcel.do", method=RequestMethod.POST)
    public View selectSendRefundExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();
        Map<String,Object>       dataMap           = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();

        try {
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String stmtDate = (String)objMap.get( "stmtDt" );
     	   	String stmtDt = "";
     	   	stmtDt = stmtDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			objMap.put( "stmtDt", stmtDt);
			log.info( "request parameter :  " + objMap );
			objExcelData = reportMgmtService.selectSendRefund(objMap);

        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectStmtPayRepListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "SendReFundDown");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("cardLst", dataMap.get( "cardLst" ));
            objExcelMap.put("reqData",   objMap);
        }

        return new PgStmtListExcelGenerator();
    }
	//미지급금 등록
	@RequestMapping(value = "/regNonPayment.do")
	public String regPayment(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "148");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0110"));

		model.addAttribute("status", CommonDDLB.StatusOption(DDLBType.SEARCH));

		log.info( "미지급금 등록-- 관리자 권한 조회" );
    	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	Map<String,Object> dataMap = new HashMap<String,Object>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute("authList", list);
    	model.addAttribute( "SETT_AUTH_FLG2" , list.get( 0 ).get( "SETT_AUTH_FLG2" ));

		return "/calcuMgmt/reportMgmt/regNonPayment";
	}
	//미지급금금액 수정
	@RequestMapping(value="/updateUnStmtReg.do", method=RequestMethod.POST)
    public ModelAndView updateUnStmtReg(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();

        int intResultCode    = 0;
        int cnt = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
            	log.info( "보고서 작성- 미지급금금액 수정 - Start -" );
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                cnt = reportMgmtService.updateUnStmtReg(objMap);
                if(cnt == 9999){
                	intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
                }
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("insertUnStmtReg.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
	//미지급금금액 등록
	@RequestMapping(value="/insertUnStmtReg.do", method=RequestMethod.POST)
    public ModelAndView insertUnStmtReg(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();

        int intResultCode    = 0;
        int cnt = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
            	log.info( "보고서 작성- 미지급금금액 등록 - Start -" );
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                cnt = reportMgmtService.insertUnStmtReg(objMap);
                if(cnt == 9999){
                	intResultCode    = 9999;
                    strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
                }
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("insertUnStmtReg.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
	//미지급금등록 정산 리스트 조회
	@RequestMapping(value = "/selectUnStmtRegList.do", method=RequestMethod.POST)
	public ModelAndView selectUnStmtRegList(@RequestBody String strJsonParameter) throws Exception
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "보고서 작성- 미지급금등록 정산 리스트 조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String fromDate = (String)objMap.get( "txtFromDate" );
	        	   String frDt = "";
	        	   frDt = fromDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "frDt", frDt);
				   String toDate = (String)objMap.get( "txtToDate" );
				   String toDt = "";
				   toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "toDt", toDt);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "보고서 작성- 미지급금등록 정산 리스트 조회 - parameter : " + objMap );
	               objList = 	reportMgmtService.selectUnStmtRegList(objMap);
	               intPageTotalCnt = 	(Integer)reportMgmtService.selectUnStmtRegListTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "보고서 작성- 미지급금등록 정산 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "보고서 작성-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "보고서 작성- 지급보고서작성 리스트 조회 - End -" );
	    return objMv;
	}
	//보류/해제/별도가감
	@RequestMapping(value = "/holdReleaseEtc.do")
	public String holdReleaseEtc(Model model, CommonMap commonMap) throws Exception {
		String codeCl = "";
		List<Map<String,String>> listMap = new ArrayList<Map<String,String>>();
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "159");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", "IMS_MENU_SUB_0105");

		model.addAttribute("division", CommonDDLB.merchantType8(DDLBType.ALL));

		log.info( "정산_보류/해제/별도가감 --카드조회 " );
        codeCl = "0048";
    	listMap = baseInfoRegistrationService.selectCodeCl( codeCl);
    	model.addAttribute("LstCardCode", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
    	model.addAttribute("LstCardCode1", CommonDDLB.ListOption(listMap ));

    	log.info( "정산_보류/해제/별도가감 --카드조회 " );
    	Map<String,Object> dataMap = new HashMap<>();
    	dataMap.put( "codeCl", "0048");
    	dataMap.put( "code2", "01" );
        listMap = reportMgmtService.selectCode2List( dataMap);
        model.addAttribute("typeList1", CommonDDLB.ListOptionCode2(listMap));

    	log.info( "정산_보류/해제/별도가감-- 관리자 권한 조회" );
    	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute("authList", list);
    	model.addAttribute( "SETT_AUTH_FLG2" , list.get( 0 ).get( "SETT_AUTH_FLG2" ));

		return "/calcuMgmt/reportMgmt/holdReleaseEtc";
	}
	//보류/해제/별도가감 등록
    @RequestMapping(value="/insertResr.do", method=RequestMethod.POST)
    public ModelAndView insertResr(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();

        int intResultCode    =  0;
        int cnt = 0;
        String strResultMessage = "";
        // 123
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
            	log.info( "보고서 작성- 보류/해제/별도가감 등록 - Start -" );
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                String payDate = (String)objMap.get( "payDt" );
        	    payDate = payDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
			    objMap.put( "payDt", payDate);
			    String amt = CommonUtils.ConvertAmt( objMap.get( "amt" ) );
			    objMap.put( "amt", amt);
                log.info( "request parameter :  " + objMap );
                dataMap = reportMgmtService.insertResrExtra(objMap);
                if(!dataMap.get( "resultCd" ).equals( "0000" ))
                {
                	intResultCode    = 9999;
                    strResultMessage = ( String ) dataMap.get( "resultMsg" );
                }
                objMv.addObject( "data" , dataMap );

            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmt.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
	//보류잔액 조회
    @RequestMapping(value="/selectAmtChk.do", method=RequestMethod.POST)
    public ModelAndView selectAmtChk(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();

        int intResultCode    = 0;
        int cnt = 0;
        int amt = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
            	log.info( "보고서 작성- 보류잔액 조회 - Start -" );
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                amt = reportMgmtService.selectAmtChk(objMap);
                log.info( "보고서 작성- 보류잔액 조회 - amt : " + amt );
                objMv.addObject( "amt" , amt );

            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectAmtChk.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
	//보류/해제/별도가감 리스트 조회
	@RequestMapping(value = "/selectResrList.do", method=RequestMethod.POST)
	public ModelAndView selectResrList(@RequestBody String strJsonParameter) throws Exception
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode    = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";
		int i=0;
	   	log.info( "보고서 작성- 보류/해제/별도가감 리스트 조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   String frDate = (String)objMap.get( "txtFromDate" );
	        	   String frDt = "";
	               frDt = frDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "frDt", frDt);
				   String toDate = (String)objMap.get( "txtToDate" );
				   String toDt = "";
	               toDt = toDate.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
				   objMap.put( "toDt", toDt);
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "보고서 작성- 보류/해제/별도가감 리스트 조회 - parameter : " + objMap );
	               objList = 	reportMgmtService.selectResrList(objMap);
	               intPageTotalCnt = 	(Integer)reportMgmtService.selectResrListTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "보고서 작성- 보류/해제/별도가감 리스트 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "보고서 작성-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "보고서 작성- 보류/해제/별도가감 리스트 조회 - End -" );
	    return objMv;
	}
	//카드 리스트 엑셀
    @RequestMapping(value="/selectResrListExcel.do", method=RequestMethod.POST)
    public View selectSubCardListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
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
			objExcelData = reportMgmtService.selectResrList(objMap);

        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectResrListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Settlement_Resr_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("cardLst", dataMap.get( "cardLst" ));
            objExcelMap.put("reqData",   objMap);
        }

        return new ResrListExcelGenerator();
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
                objMv.addObject("typeList", CommonDDLB.ListOptionCode2Set(DDLBType.SEARCH,listMap));
                objMv.addObject("typeList1", CommonDDLB.ListOptionCode2(listMap));
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


}