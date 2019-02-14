package egov.linkpay.ims.baseinfomgmt;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.apache.tiles.request.Request;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
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
@RequestMapping(value="/baseInfoMgmt/normalInfoMgmt")
public class NormalInfoMgmtController {
    Logger log = Logger.getLogger(this.getClass());

    @Resource(name="baseInfoMgmtService")
    private BaseInfoMgmtService baseInfoMgmtService;

    @Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;
    /**--------------------------------------------------
     * Method Name    : baseInfo
     * Description    : 메뉴 진입
     * Author         : ChoiIY, 2017. 04. 17.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/normalInfoMgmt.do")
    public String baseInfoMgmt(HttpServletRequest request, Model model, CommonMap commonMap) throws Exception {
    	List< Map< String, String > > listMap = new ArrayList<>();
    	String codeCl = "";
    	String url = "";
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "13"); //기본정보 조회 
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0104") + " " + CommonMessageDic.getMessage("IMS_BIM_CCS_0005"));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        model.addAttribute("MER_SEARCH",          CommonDDLB.merchantType3_1());
        model.addAttribute("MER_TYPE",          CommonDDLB.merchantType4(DDLBType.SEARCH));

        model.addAttribute("COMPANY_TYPE",          CommonDDLB.companyType(DDLBType.SEARCH));
        model.addAttribute("OM_PAY_SETTLE",          CommonDDLB.OM_SETTL_TYPE(DDLBType.SEARCH));
        model.addAttribute("SHOP_TYPE",          CommonDDLB.shopType(DDLBType.SEARCH));
        model.addAttribute("USE_STATUS",          CommonDDLB.useStatus2(DDLBType.SEARCH));
        
        model.addAttribute("ENCODING_TYPE",          CommonDDLB.settleEncodingType());

        try
	   	{

        	log.info("은행코드 조회");
        	codeCl = "0001";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("BANK_CD", CommonDDLB.ListOption(listMap));
        	
        	
	        HttpSession session = request.getSession(false);
	    	String merId = "";
	    	String merType = "";
	    	
	    	
		   	merId = session.getAttribute("MER_ID").toString();
		   	merType = session.getAttribute("MER_ID_TYPE").toString();
		   	
		   	if(merType.equals("m")) {
		   		url = "/baseInfoMgmt/baseInfoMgmt/normalInfoMgmt";
		   	}else if(merType.equals("g")) {
		   		url = "/baseInfoMgmt/baseInfoMgmt/normalGidInfoMgmt";
		   	}else if(merType.equals("v")) {
		   		url = "/baseInfoMgmt/baseInfoMgmt/normalVidInfoMgmt";
		   	}else {
		   		url = "/error/error404";
		   	}
		   	
		   	model.addAttribute("MID", merId);
        
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "keyInfoMgmt-Exception : ", e );
	   	}
        
        ///return "/baseInfoMgmt/baseInfoMgmt/normalInfoMgmt";
        return url;
    }
    
    @RequestMapping(value = "/updateNormalInfo.do", method=RequestMethod.POST)
    public ModelAndView updateNormalInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	int intResultCode = 0 ;
 	   	String strResultMessage = "";
 	   
 	   	log.info( "updateNormalInfo update- Start -" );
 	   	try
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
 	           {
 	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();

	 	 		   log.info( "updateNormalInfo update-1-파라미터 null 체크 " );
 		           objMap = CommonUtils.jsonToMap(strJsonParameter);
 		           
 		           objMap.put("MER_ID", merId);
 		           
 		           log.info( "updateNormalInfo update-1-파라미터 : " + objMap );
 		           baseInfoMgmtService.updateNormalInfo(objMap);
	        	    		        	   
 	           }
 	           else
 	           {
 	        	   log.info( "updateNormalInfo update-1-파라미터 null " );
 	        	   intResultCode = 9999;
 	   	   		   strResultMessage = "Fail";
 	           }

 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "updateNormalInfo-Exception : ", e );
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
 	   	log.info( "updateNormalInfo update- End -" );
 	   	objMv.setViewName("jsonView");
 	    return objMv;
    }
    
    @RequestMapping(value = "/updateNormalGidInfo.do", method=RequestMethod.POST)
    public ModelAndView updateNormalGidInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	int intResultCode = 0 ;
 	   	String strResultMessage = "";
 	   
 	   	log.info( "updateNormalGidInfo update- Start -" );
 	   	try
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
 	           {
 	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();

	 	 		   log.info( "updateNormalGidInfo update-1-파라미터 null 체크 " );
 		           objMap = CommonUtils.jsonToMap(strJsonParameter);
 		           
 		           objMap.put("MER_ID", merId);
 		           
 		           log.info( "updateNormalGidInfo update-1-파라미터 : " + objMap );
 		           baseInfoMgmtService.updateNormalGidInfo(objMap);
	        	    		        	   
 	           }
 	           else
 	           {
 	        	   log.info( "updateNormalGidInfo update-1-파라미터 null " );
 	        	   intResultCode = 9999;
 	   	   		   strResultMessage = "Fail";
 	           }

 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "updateNormalGidInfo-Exception : ", e );
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
 	   	log.info( "updateNormalGidInfo update- End -" );
 	   	objMv.setViewName("jsonView");
 	    return objMv;
    }
    
    @RequestMapping(value = "/updateNormalVidInfo.do", method=RequestMethod.POST)
    public ModelAndView updateNormalVidInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	int intResultCode = 0 ;
 	   	String strResultMessage = "";
 	   
 	   	log.info( "updateNormalVidInfo update- Start -" );
 	   	try
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
 	           {
 	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();

	 	 		   log.info( "updateNormalVidInfo update-1-파라미터 null 체크 " );
 		           objMap = CommonUtils.jsonToMap(strJsonParameter);
 		           
 		           objMap.put("MER_ID", merId);
 		           
 		           log.info( "updateNormalVidInfo update-1-파라미터 : " + objMap );
 		           baseInfoMgmtService.updateNormalVidInfo(objMap);
	        	    		        	   
 	           }
 	           else
 	           {
 	        	   log.info( "updateNormalVidInfo update-1-파라미터 null " );
 	        	   intResultCode = 9999;
 	   	   		   strResultMessage = "Fail";
 	           }

 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "updateNormalVidInfo-Exception : ", e );
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
 	   	log.info( "updateNormalVidInfo update- End -" );
 	   	objMv.setViewName("jsonView");
 	    return objMv;
    }
    
    @RequestMapping(value = "/updateCancelTransPw.do", method=RequestMethod.POST)
    public ModelAndView updateCancelTransPw(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	int intResultCode = 0 ;
 	   	String strResultMessage = "";
 	   
 	   	log.info( "updateCancelTransPw update- Start -" );
 	   	try
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
 	           {
 	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();

	 	 		   log.info( "updateCancelTransPw update-1-파라미터 null 체크 " );
 		           objMap = CommonUtils.jsonToMap(strJsonParameter);
 		           
 		           objMap.put("MER_ID", merId);
 		           
 		           log.info( "updateCancelTransPw update-1-파라미터 : " + objMap );
 		           baseInfoMgmtService.updateCancelTransPw(objMap);
	        	    		        	   
 	           }
 	           else
 	           {
 	        	   log.info( "updateCancelTransPw update-1-파라미터 null " );
 	        	   intResultCode = 9999;
 	   	   		   strResultMessage = "Fail";
 	           }

 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "updateCancelTransPw-Exception : ", e );
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
 	   	log.info( "updateCancelTransPw update- End -" );
 	   	objMv.setViewName("jsonView");
 	    return objMv;
    }
    
    @RequestMapping(value = "/updateNormalTelInfo.do", method=RequestMethod.POST)
    public ModelAndView updateNormalTelInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	int intResultCode = 0 ;
 	   	String strResultMessage = "";
 	   
 	   	log.info( "updateNormalTelInfo update- Start -" );
 	   	try
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
 	           {
 	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();

	 	 		   log.info( "updateNormalTelInfo update-1-파라미터 null 체크 " );
 		           objMap = CommonUtils.jsonToMap(strJsonParameter);
 		           
 		           objMap.put("MER_ID", merId);
 		           
 		           log.info( "updateNormalTelInfo update-1-파라미터 : " + objMap );
 		           baseInfoMgmtService.updateNormalTelInfo(objMap);
	        	    		        	   
 	           }
 	           else
 	           {
 	        	   log.info( "updateNormalTelInfo update-1-파라미터 null " );
 	        	   intResultCode = 9999;
 	   	   		   strResultMessage = "Fail";
 	           }

 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "updateNormalTelInfo-Exception : ", e );
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
 	   	log.info( "updateNormalInfo update- End -" );
 	   	objMv.setViewName("jsonView");
 	    return objMv;
    }
    
    @RequestMapping(value = "/updateNotiTransInfo.do", method=RequestMethod.POST)
    public ModelAndView updateNotiTransInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	int intResultCode = 0 ;
 	   	String strResultMessage = "";
 	   
 	   	log.info( "updateNotiTransInfo update- Start -" );
 	   	try
 	   	{
 	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
 	           {
 	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();

	 	 		   log.info( "updateNotiTransInfo update-1-파라미터 null 체크 " );
 		           objMap = CommonUtils.jsonToMap(strJsonParameter);
 		           
 		           objMap.put("MER_ID", merId);
 		           
 		           log.info( "updateNotiTransInfo update-1-파라미터 : " + objMap );
 		           
 		           int infoCnt = 0;
	        	   infoCnt = baseInfoMgmtService.selectNotiTransInfo(objMap);
	        	   
	        	   if(infoCnt > 0) {
	        		   baseInfoMgmtService.updateNotiTransInfo(objMap);
	        	   }else  {
	        		   baseInfoMgmtService.insertNotiTransInfo(objMap);
	        	   }
	        	   
 		           
	        	    		        	   
 	           }
 	           else
 	           {
 	        	   log.info( "updateNotiTransInfo update-1-파라미터 null " );
 	        	   intResultCode = 9999;
 	   	   		   strResultMessage = "Fail";
 	           }

 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "updateNotiTransInfo-Exception : ", e );
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
 	   	log.info( "updateNotiTransInfo update- End -" );
 	   	objMv.setViewName("jsonView");
 	    return objMv;
    }
    
    //일반정보조회 MID
    @RequestMapping(value = "/selectNormalInfo.do", method=RequestMethod.POST)
    public ModelAndView selectNormalInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	    Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
 	    int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        String fr_dt="";
	   	log.info( "selectNormalInfo- SELECT - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();
	 	 		   
	        	   log.info( "selectNormalInfo-SELECT-1-파라미터 null 체크 " );
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   
	        	   objMap.put("MER_ID", merId);
	        	   
	        	   log.info("기본정보조회-SELECT-1-파라미터 : "+objMap);
	        	   
		           dataMap = 	baseInfoMgmtService.selectNormalInfo(objMap);

        		   if(dataMap.get( "midInfo" ) != null)
        		   {
        			   objMv.addObject( "midInfo", dataMap.get( "midInfo" ) );
        		   }
	           }
	           else
	           {
	        	   log.info( "selectNormalInfo-SELECT-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "selectNormalInfo-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "selectNormalInfo-SELECT - End -" );
	    return objMv;
   	}
    
    //일반정보조회 GID
    @RequestMapping(value = "/selectNormalGidInfo.do", method=RequestMethod.POST)
    public ModelAndView selectNormalGidInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	    Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
 	    int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        String fr_dt="";
	   	log.info( "selectNormalInfo- SELECT - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();
	 	 		   
	        	   log.info( "selectNormalInfo-SELECT-1-파라미터 null 체크 " );
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   
	        	   objMap.put("MER_ID", merId);
	        	   
	        	   log.info("기본정보조회-SELECT-1-파라미터 : "+objMap);
	        	   
		           dataMap = 	baseInfoMgmtService.selectNormalGidInfo(objMap);

        		   if(dataMap.get( "midInfo" ) != null)
        		   {
        			   objMv.addObject( "midInfo", dataMap.get( "midInfo" ) );
        		   }
	           }
	           else
	           {
	        	   log.info( "selectNormalInfo-SELECT-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "selectNormalInfo-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "selectNormalInfo-SELECT - End -" );
	    return objMv;
   	}
    
    //일반정보조회 VID
    @RequestMapping(value = "/selectNormalVidInfo.do", method=RequestMethod.POST)
    public ModelAndView selectNormalVidInfo(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	    Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
 	    int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        String fr_dt="";
	   	log.info( "selectNormalInfo- SELECT - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   HttpSession session = request.getSession(false);
 	        	   String merId = "";
	 	 		   merId = session.getAttribute("MER_ID").toString();
	 	 		   
	        	   log.info( "selectNormalInfo-SELECT-1-파라미터 null 체크 " );
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   
	        	   objMap.put("MER_ID", merId);
	        	   
	        	   log.info("기본정보조회-SELECT-1-파라미터 : "+objMap);
	        	   
		           dataMap = 	baseInfoMgmtService.selectNormalVidInfo(objMap);

        		   if(dataMap.get( "midInfo" ) != null)
        		   {
        			   objMv.addObject( "midInfo", dataMap.get( "midInfo" ) );
        		   }
	           }
	           else
	           {
	        	   log.info( "selectNormalInfo-SELECT-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "selectNormalInfo-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "selectNormalInfo-SELECT - End -" );
	    return objMv;
   	}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //기본정보조회
    @RequestMapping(value = "/selectBaseInfo.do", method=RequestMethod.POST)
    public ModelAndView selectBaseInfoAll(@RequestBody String strJsonParameter) throws Exception
    {
 	   	ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	    Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
 	    int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        String fr_dt="";
	   	log.info( "기본정보조회- SELECT - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   log.info( "기본정보조회-SELECT-1-파라미터 null 체크 " );
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   if(objMap.get( "frDt") != null)
	        	   {
	        		   fr_dt = (String)objMap.get( "frDt" );
	        		   fr_dt = fr_dt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        		   objMap.put( "frDt" , fr_dt);
	        	   }
	        	   log.info("기본정보조회-SELECT-1-파라미터 : "+objMap);
	        	   CommonUtils.initSearchRange(objMap);
		           //기존 SELECT
		           //objList = 	baseInfoRegistrationService.selectBaseInfo(objMap);

		           //TB_CO & TB_MBS SELECT
		           dataMap = 	baseInfoMgmtService.baseInfo(objMap);

	        	   if(objMap.get( "MER_VAL" ).equals("2")) //mid
	        	   {
	        		   if(dataMap.get( "midInfo" ) != null)
	        		   {
	        			   objMv.addObject( "midInfo", dataMap.get( "midInfo" ) );
	        		   }
	        		   if(dataMap.get( "settleFeeInfo" ) != null)
	        		   {
	        			   objMv.addObject( "settleFeeInfo", dataMap.get( "settleFeeInfo" ) );
	        		   }
	        		   if(dataMap.get( "settleServiceInfo" ) != null)
	        		   {
	        			   objMv.addObject( "settleServiceInfo", dataMap.get( "settleServiceInfo" ) );
	        		   }
	        		   if(dataMap.get( "cardInfo" ) != null)
	        		   {
	        			   objMv.addObject( "cardInfo", dataMap.get( "cardInfo" ) );
	        		   }
	        		   if(dataMap.get( "cardBillInfo" ) != null)
	        		   {
	        			   objMv.addObject( "cardBillInfo", dataMap.get( "cardBillInfo" ) );
	        		   }
	        		   if(dataMap.get( "settleCycle" ) != null)
	        		   {
	        			   objMv.addObject( "settleCycle", dataMap.get( "settleCycle" ) );
	        		   }
	        		   if(dataMap.get( "payType" ) != null)
	        		   {
	        			   objMv.addObject( "payType", dataMap.get( "payType" ) );
	        		   }
	        		   if(dataMap.get( "useCard" ) != null)
	        		   {
	        			   objMv.addObject( "useCard", dataMap.get( "useCard" ) );
	        			   objMv.addObject( "overCardCd", dataMap.get( "overCardCd" ) );
	        			   objMv.addObject( "majorCardCd", dataMap.get( "majorCardCd" ) );
	        		   }
	        	   }
	        	   else if(objMap.get( "MER_VAL" ).equals("3"))//GID
	        	   {
	        		  log.info( "기본정보조회-SELECT-1-gid" );
	        		  log.info( "기본정보조회-SELECT-1-gid setting gidInfo" );
	        		  objMv.addObject( "gidInfo", dataMap.get( "gidInfo" ) );
	        		  log.info( "기본정보조회-SELECT-1-gid,mid info" );
	        		  objMv.addObject( "gidMidInfo", dataMap.get( "gidMidInfo" ));
	        		  log.info( "기본정보조회-SELECT-1-gid banklist info" );
	        		  objMv.addObject( "gidBankList", dataMap.get( "gidBankList" ));
	        	   }
	        	   else if(objMap.get( "MER_VAL" ).equals("4"))//VID
	        	   {
	        		   log.info( "기본정보조회-SELECT-1-vid" );
	        		   log.info( "기본정보조회-SELECT-1-vid vid info " );
	        		   objMv.addObject( "vidInfo", dataMap.get( "vidInfo" ) );
	        		   log.info( "기본정보조회-SELECT-1-vid vid fee info" );
	        		   objMv.addObject( "vidFeeInfo", dataMap.get( "vidFeeInfo" ));
	        		   log.info( "기본정보조회-SELECT-1-vid, mid info " );
	        		   objMv.addObject( "vidMidInfo", dataMap.get( "vidMidInfo" ));
	        		   log.info( "기본정보조회-SELECT-1-vid bankList info " );
	        		   objMv.addObject( "vidBankList", dataMap.get( "vidBankList" ));
	        	   }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-SELECT-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-SELECT - End -" );
	    return objMv;
   	}

    //기본정보 리스트 조회
    @RequestMapping(value = "/selectBaseInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectBaseInfoList(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	Map< String, Object > dataMap = new HashMap<String, Object>();
    	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
    	int intResultCode    = 0;
    	int intPageTotalCnt = 0;
    	String strResultMessage = "";
    	String frDt = "";
    	String toDt = "";

    	log.info( "기본정보 리스트 조회- Start -" );
    	try
    	{
    		if (!CommonUtils.isNullorEmpty(strJsonParameter))
    		{
    			objMap = CommonUtils.jsonToMap(strJsonParameter);
    			CommonUtils.initSearchRange(objMap);
    			frDt = (String)objMap.get( "frDt" );
    			frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "frDt" , frDt);
	        	toDt = (String)objMap.get( "toDt" );
	        	toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "toDt" , toDt);
	        	if(objMap.get( "MER_SEARCH" ).equals( "1" )){
	        		//사업자 번호
	        	}
    			log.info( "기본정보 리스트 조회- parameter : " + objMap );

    			log.info( "기본정보 리스트 조회- 관리자 권한 조회 "  );
    			objList  = baseInfoMgmtService.selectEmpAuthSearch(objMap);

    			if(objList.size() == 0 )
    			{
    				log.info( "기본정보 리스트 조회-1-관리자 권한 데이터 x " );
    			}
    			else
    			{
    				dataMap.put( "auth", objList.get( 0 ) );
    				objMv.addObject( "auth", dataMap.get( "auth" ) );
    			}

    			log.info( "기본정보 리스트 조회- ");
    			objList = 	baseInfoMgmtService.selectBaseInfoList(objMap);
    			intPageTotalCnt = baseInfoMgmtService.selectBaseInfoListTotal(objMap);
    		}
    		else
    		{
    			log.info( "기본정보 리스트 조회-1-파라미터 null " );
    		}

    	}
    	catch(Exception e)
    	{
    		log.error( "기본정보 리스트 조회-Exception : ", e );
    	}
    	finally
    	{
    		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
    	}

    	objMv.setViewName("jsonView");
    	log.info( "기본정보 리스트 조회- End -" );
    	return objMv;
    }
    //기본정보 리스트 excel
    @RequestMapping(value="/selectBaseInfoListExcel.do", method=RequestMethod.POST)
    public View selectBaseInfoListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();

        try {
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String frDt = "";
            String toDt = "";
            frDt = (String)objMap.get( "frDt" );
			frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
        	objMap.put( "frDt" , frDt);
        	toDt = (String)objMap.get( "toDt" );
        	toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
        	objMap.put( "toDt" , toDt);

            objExcelData = baseInfoMgmtService.selectBaseInfoList(objMap);

        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectReportExcelList.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Base_Infomation_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }

        return new BaseInfoListExcelGenerator();
    }

    //다량등록
    @RequestMapping(value = "/multiRegist.do")
    public String multiRegist(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "75");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0049"));

        return "/baseInfoMgmt/baseInfoMgmt/multiRegist";
    }
    @RequestMapping(value="/insertMultiRegist.do", method=RequestMethod.POST)
    public ModelAndView insertMultiRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        List<Map<String, Object>> objList = new ArrayList<Map<String, Object>>();
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
        int    intResultCode    = 0;
        String strResultMessage = "";
        int cnt =0;
        try{

        		//최대 Size : 10 Mega (Upload File을 제한)
        		String file_name = null;
        		Calendar calendar = Calendar.getInstance();
        		java.util.Date date = calendar.getTime();
        		String today = (new SimpleDateFormat("yyyyMMdd").format(date));
        		String filedir = "C:/test/"+today;

        		File isDir = new File(filedir);

        		// 디렉토리 미존재시 디렉토리 생성
        		if ( !isDir.isDirectory() ) {
        			isDir.mkdirs();
        		}
        		log.info( "file  : " + isDir );
        		/*MultipartRequest  multi= new MultipartRequest(request,filedir,10*1024*1024);

 				file_name = multi.getFilesystemName("textfield");*/
        		// 값이 나올때까지
        		Iterator iter = multipartRequest.getFileNames();
        		String fieldName = ""  ;
        		MultipartFile mfile = null;
        		Map<String, Object> map = new HashMap<String, Object>();

        		MultipartFile objFile = multipartRequest.getFile("DATA_FILE");

        		String url = "C:" + File.separator + "test";
        		objMap.put("DATA_FILE_NAME", objFile.getOriginalFilename());

        		objMap.put("DATA_FILE",      objFile.getBytes());

        		String strFileNm = (String)objMap.get( "DATA_FILE_NAME" );

        		boolean bSuccess = false;
        		String strMsg = "파일 등록이 실패하였습니다.";
        		try
        		{
        			while (iter.hasNext()) {
        				fieldName = ( String ) iter.next();
        				// 내용을 가져와서
        				mfile = multipartRequest.getFile(fieldName);
        				String origName;
        				origName = new String(mfile.getOriginalFilename().getBytes("8859_1"), "UTF-8"); //한글꺠짐 방지
        				// 파일명이 없다면
        				if ("".equals(origName)) { continue; }
        				// 파일 명 변경(uuid로 암호화)
        				String ext = origName.substring(origName.lastIndexOf('.'));
        				// 확장자
        				String saveFileName =  origName;
        				// 설정한 path에 파일저장
        				File serverFile = new File(url+File.separator + today+File.separator +strFileNm);
        				mfile.transferTo(serverFile);
        			}
        			String file_path = url+File.separator + today+File.separator +strFileNm;

        			objMap.put( "fileNm" , strFileNm );
        			objMap.put( "filePath" , file_path);
        			log.info( "fileNm : " + objMap.get( "fileNm" ) );
        			log.info( "filePath : " + objMap.get( "filePath" ) );
        			objList = baseInfoMgmtService.insertMultiRegist(objMap);
        			log.info( "objList : " +  objList  );
        			objMv.addObject( "failList" , objList);
        			if(!objList.get( 0 ).get( "resultMsg" ).equals( "성공" )){
        				intResultCode    = 9999;
        			}
        		}
        		catch (UnsupportedEncodingException e)
        		{
        			// TODO Auto-generated catch block
        			intResultCode    = 9999;
        			strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
        			log.error("insertMultiRegist.do exception : " + e.getMessage());
        		}
        		catch (IllegalStateException e)
        		{
        			// TODO Auto-generated catch block
        			intResultCode    = 9999;
        			strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
        			log.error("insertMultiRegist.do exception : " + e.getMessage());
        		}
        		catch (IOException e)
        		{
        			// TODO Auto-generated catch block
        			intResultCode    = 9999;
        			strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
        			log.error("insertMultiRegist.do exception : " + e.getMessage());
        		}
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("insertMultiRegist.do exception : " + ex.getMessage());
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
}
