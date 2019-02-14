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

import egov.linkpay.ims.baseinfomgmt.service.HistorySearchService;
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
@RequestMapping(value="/baseInfoMgmt/historySearch")
public class HistorySearchController {
    Logger log = Logger.getLogger(this.getClass());

    @Resource(name="historySearchService")
    private HistorySearchService historySearchService;
    /**--------------------------------------------------
     * Method Name    : baseInfo
     * Description    : 메뉴 진입
     * Author         : ChoiIY, 2017. 04. 17.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/historySearch.do")
    public String historySearch(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        model.addAttribute("MER_SEARCH",          CommonDDLB.merchantType5());
        model.addAttribute("HISTORY_TYPE",          CommonDDLB.historyType());
        
        return "/baseInfoMgmt/historySearch/historySearch";
    }
    
    //id별 기준정보 변경이력 조회
	@RequestMapping(value = "/selectBaseInfoList.do", method=RequestMethod.POST)
	public ModelAndView selectBaseInfoList(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	     int intResultCode    = 0;
	     int intPageTotalCnt = 0;
	     String strResultMessage = "";
	     String frDt = "";
	     String toDt = "";
	     int i=0;
	   	log.info( "History조회- 기준정보 변경이력 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   frDt= (String)objMap.get( "txtFromDate" );
	        	   frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   toDt= (String)objMap.get( "txtToDate" );
	        	   toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   objMap.put( "frDt", frDt );
	        	   objMap.put( "toDt", toDt );
	        	   CommonUtils.initSearchRange(objMap);
	        	   log.info( "History조회- 기준정보 변경이력 조회 - parameter : " + objMap );
	               objList = 	historySearchService.selectChangeHistoryDetail(objMap);
	               intPageTotalCnt = 	(Integer)historySearchService.selectChangeHistoryDetailTotal(objMap);
	               //intPageTotalCnt = objList.size();
	           }
	           else
	           {
	        	   log.info( "History조회- 기준정보 변경이력 조회-1-파라미터 null " );
	        	   intResultCode = 9999;
	           }
	           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "History조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "History조회- 기준정보 변경이력 조회 - End -" );
	    return objMv; 
	}
	//id별 수수료 정보 조회
	@RequestMapping(value = "/selectFeeInfo.do", method=RequestMethod.POST)
	public ModelAndView selectFeeInfo(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	     int intResultCode    = 0;
	     int intPageTotalCnt = 0;
	     String strResultMessage = "";
	     String frDt = "";
	     String toDt = "";
	     int i=0;
	   	log.info( "History조회- 수수료정보이력 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   CommonUtils.initSearchRange(objMap);
	        	   frDt= (String)objMap.get( "txtFromDate" );
	        	   frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   toDt= (String)objMap.get( "txtToDate" );
	        	   toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   objMap.put( "frDt", frDt );
	        	   objMap.put( "toDt", toDt );
	        	   String id_cl = (String)objMap.get( "MER_SEARCH" );
        		   if(id_cl.equals( "1" ))
        		   {
        			   id_cl = "0";
        		   }
        		   else if(id_cl.equals( "2" ))
    			   {
        			   id_cl = "1";
    			   }
        		   objMap.put( "MER_SEARCH", id_cl );
	        	   log.info( "History조회- 수수료정보이력 조회 - parameter : " + objMap );
	               objList = 	historySearchService.selectFeeInfo(objMap);
	               intPageTotalCnt = (Integer)historySearchService.selectFeeInfoTotal(objMap);
		       }
	           else
	           {
	        	   log.info( "History조회- 수수료정보이력 조회-1-파라미터 null " );
	           }
	           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "History조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "History조회- 수수료정보이력 조회 - End -" );
	    return objMv; 
	}
	//정산주기 조회
	@RequestMapping(value = "/selectSettleCycleInfo.do", method=RequestMethod.POST)
	public ModelAndView selectSettleCycleInfo(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	     int intResultCode    = 0;
	     int intPageTotalCnt = 0;
	     String strResultMessage = "";
	     String frDt = "";
	     String toDt = "";
	     int i=0;
	   	log.info( "History조회- 정산주기 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   CommonUtils.initSearchRange(objMap);
	        	   frDt= (String)objMap.get( "txtFromDate" );
	        	   frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   toDt= (String)objMap.get( "txtToDate" );
	        	   toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   objMap.put( "frDt", frDt );
	        	   objMap.put( "toDt", toDt );
	        	   log.info( "History조회- 정산주기 조회 - parameter : " + objMap );
	               objList = 	historySearchService.selectSettleCycleInfo(objMap);
	               intPageTotalCnt = (Integer)historySearchService.selectSettleCycleInfoTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "History조회- 정산주기 조회-1-파라미터 null " );
	           }
	           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "History조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "History조회- 정산주기 조회 - End -" );
	    return objMv; 
	}
	//사업자입금정보 조회
	@RequestMapping(value = "/selectCoInfo.do", method=RequestMethod.POST)
	public ModelAndView selectCoInfo(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	     int intResultCode    = 0;
	     int intPageTotalCnt = 0;
	     String strResultMessage = "";
	     String frDt = "";
	     String toDt = "";
	     int i=0;
	   	log.info( "History조회- 사업자입금정보 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   CommonUtils.initSearchRange(objMap);
	        	   frDt= (String)objMap.get( "txtFromDate" );
	        	   frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   toDt= (String)objMap.get( "txtToDate" );
	        	   toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   objMap.put( "frDt", frDt );
	        	   objMap.put( "toDt", toDt );
	        	   log.info( "History조회- 사업자입금정보 조회 - parameter : " + objMap );
	               objList = 	historySearchService.selectCoInfo(objMap);
	               intPageTotalCnt = (Integer)historySearchService.selectCoInfoTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "History조회- 사업자입금정보 조회-1-파라미터 null " );
	           }
	           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "History조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "History조회- 사업자입금정보 조회 - End -" );
	    return objMv; 
	}
	//제휴사연동정보 조회
	@RequestMapping(value = "/selectAffInfo.do", method=RequestMethod.POST)
	public ModelAndView selectAffInfo(@RequestBody String strJsonParameter) throws Exception 
	{
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	     int intResultCode    = 0;
	     int intPageTotalCnt = 0;
	     String strResultMessage = "";
	     String frDt = "";
	     String toDt = "";
	     int i=0;
	   	log.info( "History조회- 제휴사연동정보 조회 - Start -" );
	   	try 
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   CommonUtils.initSearchRange(objMap);
	        	   frDt= (String)objMap.get( "txtFromDate" );
	        	   frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   toDt= (String)objMap.get( "txtToDate" );
	        	   toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	   objMap.put( "frDt", frDt );
	        	   objMap.put( "toDt", toDt );
	        	   log.info( "History조회- 제휴사연동정보 조회 - parameter : " + objMap );
	               objList = 	historySearchService.selectAffInfo(objMap);
		           intPageTotalCnt = (Integer)historySearchService.selectAffInfoTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "History조회- 제휴사연동정보 조회-1-파라미터 null " );
	           }
	           
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "History조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	       
	   	objMv.setViewName("jsonView");
	   	log.info( "History조회- 제휴사연동정보 조회 - End -" );
	    return objMv; 
	}
}
