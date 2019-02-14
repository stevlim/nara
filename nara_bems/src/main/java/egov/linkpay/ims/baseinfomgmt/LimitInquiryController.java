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
@RequestMapping(value="/baseInfoMgmt/LimitInfoInquiry")
public class LimitInquiryController {
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
    @RequestMapping(value = "/LimitInfoInquiry.do")
    public String baseInfoMgmt(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "13"); //기본정보 조회 
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0047"));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        model.addAttribute("MER_SEARCH",          CommonDDLB.merchantType3_1());
        model.addAttribute("MER_TYPE",          CommonDDLB.merchantType4(DDLBType.SEARCH));

        model.addAttribute("COMPANY_TYPE",          CommonDDLB.companyType(DDLBType.SEARCH));
        model.addAttribute("OM_PAY_SETTLE",          CommonDDLB.OM_SETTL_TYPE(DDLBType.SEARCH));
        model.addAttribute("SHOP_TYPE",          CommonDDLB.shopType(DDLBType.SEARCH));
        model.addAttribute("USE_STATUS",          CommonDDLB.useStatus2(DDLBType.SEARCH));

        return "/baseInfoMgmt/baseInfoMgmt/baseInfoMgmt";
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
