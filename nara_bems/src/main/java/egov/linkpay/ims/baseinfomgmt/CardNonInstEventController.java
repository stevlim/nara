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
import egov.linkpay.ims.baseinfomgmt.service.CardNonInstEventService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

@Controller
@RequestMapping(value="/baseInfoMgmt/cardNonInstMnt")
public class CardNonInstEventController
{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
	
	@Resource(name="cardNonInstEventService")
    private CardNonInstEventService  cardNonInstEventService;
	 
	//화면
	 @RequestMapping(value = "/cardNonInstMnt.do")
	    public String cardNonInstMnt(Model model, CommonMap commonMap) throws Exception {
	    	List< Map< String, String > > listMap = new ArrayList<>();

	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
	        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
	        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
	        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

	        model.addAttribute("STATUS",          CommonDDLB.nonInstEventStatus(DDLBType.SEARCH));
	        
	        log.info( "카드무이자이벤트-1- 카드 조회" );
	        Map<String, Object> dataMap = new HashMap< String, Object >();
	    	dataMap.put( "code2", "pur" );
        	listMap = baseInfoRegistrationService.selectCardList( dataMap);   
	    	model.addAttribute("CARD_LIST", CommonDDLB.ListOptionSetCity( DDLBType.SEARCH, listMap ));
	    	model.addAttribute("CARD_LIST1", CommonDDLB.ListOptionCity( listMap ));
	    	
	        return "/baseInfoMgmt/cardNonInstMnt/cardNonInstMnt";
	    }
	 
	 	//무이자 이벤트 조회
	    @RequestMapping(value = "/selectNoInstCardEventList.do", method=RequestMethod.POST)
	    public ModelAndView selectNoInstCardEventList(@RequestBody String strJsonParameter) throws Exception 
	    {
	    	ModelAndView objMv  = new ModelAndView();
	    	Map< String, Object > objMap = new HashMap<String, Object>();
	    	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	    	int intResultCode    = 0;
	    	int intPageTotalCnt = 0;
	    	String strResultMessage = "";
	    	String date = "";  
	    	log.info( "무이자 이벤트 조회- Start -" );
	    	try 
	    	{
	    		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	    		{
	    			objMap = CommonUtils.jsonToMap(strJsonParameter);
	    			CommonUtils.initSearchRange(objMap);
	    			log.info( "무이자 이벤트 조회- parameter : " + objMap );
	    			objList = 	cardNonInstEventService.selectNoInstCardEventList(objMap);
	    			intPageTotalCnt = (Integer)cardNonInstEventService.selectNoInstCardEventListTotal(objMap);
	    		}
	    		else
	    		{
	    			log.info( "무이자 이벤트 조회-1-파라미터 null " );
	    		}
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		log.error( "무이자 이벤트 조회-Exception : ", e );
	    	}
	    	finally
	    	{
	    		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	    	}
	    	
	    	objMv.setViewName("jsonView");
	    	log.info( "무이자 이벤트 조회- End -" );
	    	return objMv; 
	    }
	    //무이자 이벤트 신규등록
	    @RequestMapping(value = "/insertNoInstCardEvent.do" , method=RequestMethod.POST)
	    public ModelAndView insertNoInstCardEvent(@RequestBody String strJsonParameter) throws Exception 
	    {
	    	ModelAndView objMv  = new ModelAndView();
	    	Map< String, Object > objMap = new HashMap<String, Object>();
	    	log.info( "무이자 이벤트-insert- Start -" );
	        int    intResultCode    = 0;
	        String strResultMessage = "";
	        int cnt =0;
	    	try 
	    	{
	            if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	            {
	            	log.info( "무이자 이벤트-insert-1-파라미터 null 체크 " );
	            	objMap = CommonUtils.jsonToMap(strJsonParameter);
	            	CommonUtils.initSearchRange(objMap);
	            	String frDate = (String)objMap.get( "frDt" );
	            	String frDt ="";
	            	frDt = frDate.replaceAll("(\\d+)/(\\d+)/(\\d+)", "$1$2$3" );
				    objMap.put( "frDt", frDt);
				    String toDate = (String)objMap.get( "toDt" );
	            	String toDt ="";
	            	toDt = toDate.replaceAll("(\\d+)/(\\d+)/(\\d+)", "$1$2$3" );
				    objMap.put( "toDt", toDt);
				    objMap.put( "cardCd",  objMap.get( "cpCd"));
				    log.info( "무이자 이벤트-insert-1-파라미터 : " + objMap );
				    
				    cnt = cardNonInstEventService.insertNoInstCardEvent(objMap);
				    if(cnt == 0 )
				    {
				    	intResultCode = 9999;
				    	strResultMessage = "INSERT FAIL";
				    }
	            }
	            else
	            {
	            	log.info( "무이자 이벤트-insert-1-파라미터 null " );
	            	intResultCode = 9999;
	            }
	            
	    	}
	    	catch(Exception e)
	    	{
	    		log.error( "무이자 이벤트-Exception : ", e );
	    		intResultCode = 9999;
	    		strResultMessage = "Exception Fail";
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
	        
	    	log.info( "무이자 이벤트-insert- End -" );
	        return objMv; 
	    }
	    //무이자 이벤트 update
	    @RequestMapping(value = "/updateNoInstCardEvent.do" , method=RequestMethod.POST)
	    public ModelAndView updateNoInstCardEvent(@RequestBody String strJsonParameter) throws Exception 
	    {
	    	ModelAndView objMv  = new ModelAndView();
	    	Map< String, Object > objMap = new HashMap<String, Object>();
	    	log.info( "무이자 이벤트-update- Start -" );
	        int    intResultCode    = 0;
	        String strResultMessage = "";
	        int cnt =0;
	    	try 
	    	{
	            if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
	            {
	            	log.info( "무이자 이벤트-update-1-파라미터 null 체크 " );
	            	objMap = CommonUtils.jsonToMap(strJsonParameter);
	            	CommonUtils.initSearchRange(objMap);
	            	String frDate = (String)objMap.get( "frDt" );
	            	String frDt ="";
	            	frDt = frDate.replaceAll("(\\d+)/(\\d+)/(\\d+)", "$1$2$3" );
				    objMap.put( "frDt", frDt);
				    String toDate = (String)objMap.get( "toDt" );
	            	String toDt ="";
	            	toDt = toDate.replaceAll("(\\d+)/(\\d+)/(\\d+)", "$1$2$3" );
				    objMap.put( "toDt", toDt);
				    log.info( "무이자 이벤트-update-1-파라미터 : " + objMap );
				    
				    cnt = cardNonInstEventService.updateNoInstCardEvent(objMap);
				    log.info( "무이자 이벤트-update - result : " + cnt );
				    if(cnt == 0 )
				    {
				    	intResultCode = 9999;
				    	strResultMessage = "UPDATE FAIL";
				    }
	            }
	            else
	            {
	            	log.info( "무이자 이벤트-update-1-파라미터 null " );
	            	intResultCode = 9999;
	            }
	            
	    	}
	    	catch(Exception e)
	    	{
	    		log.error( "무이자 이벤트-Exception : ", e );
	    		intResultCode = 9999;
	    		strResultMessage = "EXCEPTION FAIL ";
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
	        
	    	log.info( "무이자 이벤트-update- End -" );
	        return objMv; 
	    }
}
