package egov.linkpay.ims.operMgmt;

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

import egov.linkpay.ims.common.batch.TcpClient;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.operMgmt.service.BatchMgmtService;

/**
 * ------------------------------------------------------------ Package Name :
 * egov.linkpay.ims.home File Name : HomeController.java Description : Home
 * Controller(Dashboard) Author : ymjo, 2015. 10. 5. Modify History : Just
 * Created. ------------------------------------------------------------
 */
@Controller
@RequestMapping(value = "/operMgmt/batchMgmt")
public class BatchMgmtController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "batchMgmtService")
	private BatchMgmtService batchMgmtService;

	//배치 job 관리
	@RequestMapping(value = "/batchJobMgmt.do")
	public String batchJobMgmt(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "162");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0128"));

		model.addAttribute("JOB_USE", CommonDDLB.JobUseOption());
		model.addAttribute("JOB_STATE", CommonDDLB.JobStateOption());

		return "/operMgmt/batchMgmt/batchJobMgmt";
	}
	//배치 job 리스트 조회
  	@RequestMapping(value = "/selectBatchJobList.do", method=RequestMethod.POST)
  	public ModelAndView selectBatchJobList(@RequestBody String strJsonParameter) throws Exception
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "배치 job - 배치 job 조회 - Start -" );
  	   	try
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "배치 job - 배치 job 조회 - parameter : " + objMap );

  	        	   objList = 	batchMgmtService.selectBatchJobList(objMap);
  	        	   intPageTotalCnt = 	batchMgmtService.selectBatchJobListTotal(objMap);
  	           }
  	           else
  	           {
  	        	   log.info( "배치 job - 배치 job 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }

  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "배치 job-Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}

  	   	objMv.setViewName("jsonView");
  	   	log.info( "배치 job - 배치 job 조회 - End -" );
  	    return objMv;
  	}
  	//batch job insert
  	@RequestMapping(value = "/insertBatchJob.do", method=RequestMethod.POST)
  	public ModelAndView insertBatchJob(@RequestBody String strJsonParameter) throws Exception
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int cnt=0;
  	   	log.info( "배치 job insert  - Start -" );
  	   	try
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "배치 job insert  - parameter : " + objMap );
  	        	   cnt = 	batchMgmtService.insertBatchJob(objMap);
  	        	   if(cnt == 0)
  	        	   {
  	        		   intResultCode = 9999;
    	        	   strResultMessage = "Insert Fail";
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "배치 job insert -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	        	   strResultMessage = "Data not exist";
  	           }

  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "배치 job insert -Exception : ", e );
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
  	   	log.info( "배치 job insert  - End -" );
  	    return objMv;
  	}
  //batch job update
  	@RequestMapping(value = "/updateBatchJob.do", method=RequestMethod.POST)
  	public ModelAndView updateBatchJob(@RequestBody String strJsonParameter) throws Exception
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int cnt=0;
  	   	log.info( "배치 job update  - Start -" );
  	   	try
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "배치 job update  - parameter : " + objMap );
  	        	   cnt = 	batchMgmtService.updateBatchJob(objMap);
  	        	   if(cnt == 0)
  	        	   {
  	        		   intResultCode = 9999;
    	        	   strResultMessage = "update Fail";
  	        	   }
  	           }
  	           else
  	           {
  	        	   log.info( "배치 job update -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	        	   strResultMessage = "Data not exist";
  	           }

  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "배치 job update -Exception : ", e );
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
  	   	log.info( "배치 job update  - End -" );
  	    return objMv;
  	}
  	//batch job useFlg update
  	@RequestMapping(value = "/updateUseType.do", method=RequestMethod.POST)
  	public ModelAndView updateUseType(@RequestBody String strJsonParameter) throws Exception
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int cnt=0;
  	   	log.info( "배치 job 사용유무 업데이트  - Start -" );
  	   	try
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "배치 job 사용유무 업데이트  - parameter : " + objMap );
  	        	   cnt = 	batchMgmtService.updateUseType(objMap);
  	        	   dataMap = 	batchMgmtService.selectBatchJobInfo(objMap);
  	        	   objMv.addObject( "data", dataMap );
  	           }
  	           else
  	           {
  	        	   log.info( "배치 job 사용유무 업데이트 -1-파라미터 null " );
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
  	   	log.info( "배치 job 사용유무 업데이트  - End -" );
  	    return objMv;
  	}
	//배치 history 관리
	@RequestMapping(value = "/batchHistoryMgmt.do")
	public String batchHistoryMgmt(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "163");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0129"));

		model.addAttribute("SUCCESS_FLG", CommonDDLB.JobSuccessOption(DDLBType.ALL));

		return "/operMgmt/batchMgmt/batchHistoryMgmt";
	}
	//배치 job history 리스트 조회
  	@RequestMapping(value = "/selectBatchJobHistList.do", method=RequestMethod.POST)
  	public ModelAndView selectBatchJobHistList(@RequestBody String strJsonParameter) throws Exception
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
  		int intResultCode    = 0;
  		int intPageTotalCnt = 0;
  		String strResultMessage = "";
  		int i=0;
  	   	log.info( "배치 job history - 배치 job history 조회 - Start -" );
  	   	try
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   String frDt = objMap.get( "txtFromDate" ).toString();
  	        	   frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$3-$2-$1" );
  	        	   String toDt = objMap.get( "txtToDate" ).toString();
  	        	   toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$3-$2-$1" );
  	        	   objMap.put( "frDt", frDt );
  	        	   objMap.put( "toDt", toDt );
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   log.info( "배치 job history - 배치 job history 조회 - parameter : " + objMap );

  	        	   objList = 	batchMgmtService.selectBatchJobHistList(objMap);
  	        	   intPageTotalCnt = 	batchMgmtService.selectBatchJobHistListTotal(objMap);

  	           }
  	           else
  	           {
  	        	   log.info( "배치 job history - 배치 job history 조회-1-파라미터 null " );
  	        	   intResultCode = 9999;
  	           }

  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "배치 job history-Exception : ", e );
	  	   	intResultCode    = 9999;
	        strResultMessage = "Exception Fail";
  	   	}
  	   	finally
  	   	{
  	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
  	   	}

  	   	objMv.setViewName("jsonView");
  	   	log.info( "배치 job history - 배치 job 조회 history - End -" );
  	    return objMv;
  	}
  	//batch processing
  	@RequestMapping(value = "/processing.do", method=RequestMethod.POST)
  	public ModelAndView processing(@RequestBody String strJsonParameter) throws Exception
  	{
  	   	ModelAndView objMv  = new ModelAndView();
  	   	Map< String, Object > objMap = new HashMap<String, Object>();
  	   	Map< String, Object > dataMap = new HashMap<String, Object>();
  		int intResultCode    = 0;
  		String strResultMessage = "";
  		int cnt = 0;
  	   	log.info( "배치 실행 - Start -" );
  	   	String ip = "192.168.0.5";
  	   	int port = 2211;

  	   	try
  	   	{
  	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
  	           {
  	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
  	        	   CommonUtils.initSearchRange(objMap);
  	        	   String workFlg =  objMap.get( "jobId" )+","+objMap.get( "stFlg" ).toString();

  	        	   objMap.put( "workFlg", workFlg );
  	        	   log.info( "배치 실행  - parameter : " + objMap );

  	        	   if(objMap.get( "retryFlg" ) == null){

  	        	   }else{
  	        		   if(objMap.get( "retryFlg" ).equals( "HIST" )){
  	        			   //HISTORY 재실행 횟수 UPDATE
  	        			   cnt = 	batchMgmtService.updateRetryCnt(objMap);
  	        		   }
  	        	   }

  	        	   TcpClient tcpClient = new TcpClient(workFlg, ip, port);

 	        	   if(tcpClient.getResult().equals( "000" )){
  	        		 strResultMessage = "PROC SUCCESS!";
  	        	   }else{
  	        		 intResultCode    = 9999;
  	        		 strResultMessage = "Result : "+ tcpClient.getResult();
  	        	   }
 	        	   log.info( "배치 실행  - result : " + tcpClient.getResult() );
  	           }
  	           else
  	           {
  	        	   log.info( "배치 실행 -1-파라미터 null " );
  	        	   intResultCode = 9999;
  	        	   strResultMessage = "data check";
  	           }

  	   	}
  	   	catch(Exception e)
  	   	{
  	   		log.error( "배치 실행 -Exception : ", e );
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
  	   	log.info( "배치 실행  - End -" );
  	    return objMv;
  	}


  	public static void main(String[] args){
  		String str = "/linkpay_ims/src/main/java/egov/linkpay/ims/operMgmt/BatchMgmtController.java";
  		String finalStr = "";
  		String[] arrStr = str.split( "/" );


  		System.out.println( arrStr );

  		//var fullStr = "문자열";
  		//var lastChar = fullStr.charAt(fullStr.length-1); //열

  	}
}
