package egov.linkpay.ims.operMgmt;

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
import java.util.StringTokenizer;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoMgmtService;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonUtils.DateFormat;
import egov.linkpay.ims.common.common.MultipartRequest;
import egov.linkpay.ims.home.service.HomeService;
import egov.linkpay.ims.operMgmt.service.OperMgmtService;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.home
 * File Name      : HomeController.java
 * Description    : Home Controller(Dashboard)
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/operMgmt/operMgmt")
public class OperMgmtController {
    Logger log = Logger.getLogger(this.getClass());
	
    @Resource(name="operMgmtService")
    private OperMgmtService operMgmtService;
    
    @Resource(name="baseInfoMgmtService")
    private BaseInfoMgmtService baseInfoMgmtService;
    
   @RequestMapping(value="/cashRecepProc.do")
   public String cashRecepProc(Model model, CommonMap commonMap) throws Exception {
	   Map<String, Object> dataMap = new HashMap<String, Object>();
	   model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
       model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
       model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
       model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
       
       log.info( "기본정보조회-10- 관리자 권한 조회" );
	   	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
	   	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
	   	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
	   	model.addAttribute("authList", list);
	   	model.addAttribute( "PAY_AUTH_FLG1" , list.get( 0 ).get( "PAY_AUTH_FLG1" ));
       
       return "/operMgmt/operMgmt/cashRecepProc";
   }
   
   //현금영수증 실패 처리  (메모장으로 가져와야하는 듯 )
   @RequestMapping(value="/procFailCashRec.do", method=RequestMethod.POST)
   public ModelAndView procFailCashRec(HttpServletRequest request, HttpServletResponse response) throws Exception {
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
    	   String filedir = "/test/"+today;  
			
    	   File isDir = new File(filedir);
			  
    	   // 디렉토리 미존재시 디렉토리 생성
    	   if ( !isDir.isDirectory() ) {
    		   isDir.mkdir();
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
    	   
    	   //String imgUrl = "http://127.0.0.1:8011";
    	   String url = "D:/test";
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
        	   objList = operMgmtService.uploadCashFailReReq(objMap);
        	   log.info( "objList : " +  objList  );
        	   objMv.addObject( "failList" , objList);
    	   } 
    	   catch (UnsupportedEncodingException e)
    	   {
    		   // TODO Auto-generated catch block 
    		   intResultCode    = 9999;
    		   strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
    		   log.error("procFailCashRec.do exception : " + e.getMessage());
    	   }
    	   catch (IllegalStateException e)
    	   { 
    		   // TODO Auto-generated catch block
    		   intResultCode    = 9999;
    		   strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
    		   log.error("procFailCashRec.do exception : " + e.getMessage());
    	   }
    	   catch (IOException e) 
    	   { 
    		   // TODO Auto-generated catch block 
    		   intResultCode    = 9999;
    		   strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
    		   log.error("procFailCashRec.do exception : " + e.getMessage());
    	   }			
			
       } catch(Exception ex) {
           intResultCode    = 9999;
           strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
           log.error("procFailCashRec.do exception : " + ex.getMessage());
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