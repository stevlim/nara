package egov.linkpay.ims.businessmgmt;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
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
import egov.linkpay.ims.businessmgmt.service.NewContractMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.MultipartRequest;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt
 * File Name      : NewContractMgmtController.java
 * Description    : 영업관리 - 신규계약관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/businessMgmt/newContractMgmt")
public class NewContractMgmtController {
    Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="newContractMgmtService")
    private NewContractMgmtService newContractMgmtService;
    
    @Resource(name="baseInfoMgmtService")
    private BaseInfoMgmtService baseInfoMgmtService;
    
    @Autowired
    private Properties config;
    
    /**--------------------------------------------------
     * Method Name    : newContractMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/newContractMgmtIng.do")
    public String newContractMgmt(Model model, CommonMap commonMap) throws Exception {
    	log.info( "신규계약진행현황 - start - " );
    	String codeCl = "";
    	List< Map< String, String > > listMap = new ArrayList<>();
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "5");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0018"));        

        model.addAttribute("flagChk",          CommonDDLB.flagChk());
        model.addAttribute("useCash",          CommonDDLB.useCash());
        model.addAttribute("contFlg",          CommonDDLB.contFlg());
        model.addAttribute("inOutChk",          CommonDDLB.foreignCardType());
        model.addAttribute("DIVISION_SEARCH",                   CommonDDLB.merchantSearchType3(DDLBType.CHECK));
        
        log.info( "신규계약진행현황-1- 접수경로 조회" );
    	codeCl ="0007";
    	listMap = newContractMgmtService.selectCodeCl(codeCl);
    	model.addAttribute("RECV_CHANNEL_EDIT", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
    	
    	model.addAttribute("contRoute", CommonDDLB.ListOption(listMap ));
    	
    	log.info( "신규계약진행현황-2- 현재 상태 조회" );
    	codeCl ="0004";
    	listMap = newContractMgmtService.selectCodeCl(codeCl);
    	model.addAttribute("STATUSL_EDIT", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
    	model.addAttribute("STATUS",          CommonDDLB.ListOption(listMap));
    	
    	log.info("신규계약진행현황-3- 담당자 조회");
    	Map<String,Object> dataMap = new HashMap<String, Object>();
    	dataMap.put( "dept", "ALL" );
    	dataMap.put( "part", "ALL" );
    	dataMap.put( "duty", "ALL" );
    	dataMap.put( "appAuth", "ALL" );
    	dataMap.put( "status", "0" );
    	
    	listMap = newContractMgmtService.selectEmplList(dataMap);
    	model.addAttribute("EMP_MANAGER", CommonDDLB.MngOption(listMap));
    	
    	log.info( "기본정보조회-10- 관리자 권한 조회" );
    	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
    	dataMap.put( "empNo", commonMap.get( "USR_ID" ) );
    	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
    	model.addAttribute("authList", list);
    	model.addAttribute( "SALES_AUTH_FLQ5" , list.get( 0 ).get( "SALES_AUTH_FLQ5" ));
    	
        return "/businessMgmt/newContractMgmt/newContractMgmtIng";
    } 
    /**--------------------------------------------------
     * Method Name    : selectCoNo
     * Description    : Corporate No 중복 체크 조회
     * Author         : kwjang, 2015. 10. 21.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectCoNo.do", method=RequestMethod.POST)
    public ModelAndView selectCoNo(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        List<Map<String, Object>> objList = new ArrayList<Map<String, Object>>();
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try { 
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) { 
                objMap           = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "objMap : " + objMap );
                objList = newContractMgmtService.selectCoNo(objMap);
                objMv.addObject( "data", objList );
                if(objList.size() > 0 ){
                	intResultCode    = 9999;
                    strResultMessage = "중복되는 사업자 번호가 존재합니다.";
                }
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectCoNo.do exception : " + ex.getMessage());
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
    //가맹점 번호 별 조회  
    @RequestMapping(value="/selectCoIngView.do", method=RequestMethod.POST)
    public ModelAndView selectCoIngView(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        int    cnt    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                dataMap = (Map<String, Object>)newContractMgmtService.selectCoIngView(objMap);
                log.info( "coView  : " + dataMap.get( "coView" )  );
                objMv.addObject( "coView" , dataMap.get( "coView" ) );
                objMv.addObject( "feeMap" , dataMap.get( "feeMap" ) );
                log.info( "select success");
                
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectCoIngView.do exception : " + ex.getMessage());
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
    //카드 수수료 조회 
    @RequestMapping(value="/selectCardFeeInfo.do", method=RequestMethod.POST)
    public ModelAndView selectCardFeeInfo(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                String title = null;
                
                if(objMap.get( "spmCd" ).equals( "01" )){
            		title = "온라인";
            	}else if(objMap.get( "spmCd" ).equals( "02" )){
            		title = "모바일"; 
            	}else {
            		title = "스마트폰";
            	}
                objMv.addObject( "title", title );
                objMv.addObject( "data", objMap);
                
                dataMap = newContractMgmtService.selectCardFeeInfo(objMap);
                
                objMv.addObject("overCardCd", dataMap.get( "overCardCd" ));
                objMv.addObject("majorCardCd", dataMap.get( "majorCardCd" ));
                objMv.addObject("coFeeList", dataMap.get( "coFeeList" ));
                objMv.addObject("merIdList", dataMap.get( "merIdList" ));
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
    //카드 수수료 조회 
    @RequestMapping(value="/matchFeeInfo.do", method=RequestMethod.POST)
    public ModelAndView matchFeeInfo(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                dataMap = newContractMgmtService.selectCardFeeInfo(objMap);
                
                objMv.addObject("merIdList", dataMap.get( "merIdList" ));
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
    //카드 수수료 insert
    @RequestMapping(value="/insertCardFeeReg.do", method=RequestMethod.POST)
    public ModelAndView insertCardFeeReg(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        int    cnt    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                dataMap = newContractMgmtService.insertCardFeeReg(objMap);
                objMv.addObject( "data", dataMap );
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
    //가맹점 insert 
    @RequestMapping(value="/insertCoInfo.do", method=RequestMethod.POST)
    public ModelAndView insertCoInfo(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        int    cnt    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                dataMap = newContractMgmtService.insertCoInfo(objMap);
                int result = ( int ) dataMap.get( "resultCd" ) ;
                if(result ==  -1){
                	intResultCode = 9999;
                }
                log.info( "insert success");
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmt.do exception : " + ex.getMessage());
        } finally {
        	log.info( "intResultCode : " + intResultCode );
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    //가맹점 수정  
    @RequestMapping(value="/updateCoInfo.do", method=RequestMethod.POST)
    public ModelAndView updateCoInfo(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> dataMap = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        int    cnt    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "request parameter :  " + objMap );
                newContractMgmtService.insertCoInfo(objMap);
                log.info( "insert success");
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
    //	계약서 이미지 업로드 
    @RequestMapping(value="/uploadContImg.do", method=RequestMethod.POST)
    public ModelAndView uploadContImg(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();

        int    intResultCode    = 0;
        String strResultMessage = "";
        int cnt =0;
        try {
        	String path = config.getProperty("IMG_URL"); 
        	Map returnObject = new HashMap();
        	
        	Map file = new HashMap();
        	
        	MultipartHttpServletRequest mhsr = (MultipartHttpServletRequest) request;
        	Iterator iter = mhsr.getFileNames(); MultipartFile mfile = null;
        	String fieldName = ""; 
        	List resultList = new ArrayList(); 

        	// 디레토리가 없다면 생성 
        	File dir = new File(path); 
        	if (!dir.isDirectory()) { 
        		dir.mkdirs(); 
    		} 
        	// 값이 나올때까지 
        	while (iter.hasNext()) { 
        		fieldName = (String) iter.next(); 
        		// 내용을 가져와서 
        		mfile = mhsr.getFile(fieldName);
        		String origName; 
        		origName = new String(mfile.getOriginalFilename().getBytes("8859_1"), "UTF-8"); //한글꺠짐 방지 
        		// 파일명이 없다면 
        		if ("".equals(origName)) { continue; } 
        		// 파일 명 변경(uuid로 암호화)
        		String ext = origName.substring(origName.lastIndexOf('.')); 
        		// 확장자 
        		String saveFileName = getUuid() + ext; 
        		// 설정한 path에 파일저장
        		File serverFile = new File(path + File.separator + saveFileName);
        		String fileUrl = path + File.separator + saveFileName;
        		mfile.transferTo(serverFile); 
        		
        		file.put("coNo", request.getParameter("coNo" ));
        		file.put("imgNm", origName);
        		file.put("imgUrl", fileUrl);
    		}
            // 파일 경로 반영
            cnt = newContractMgmtService.uploadContImg(file);
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.debug("insertArchivesMgmt.do exception : " + ex.getMessage());
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
    //uuid생성 
    public static String getUuid() { 
    	return UUID.randomUUID().toString().replaceAll("-", ""); 
	}
    //	이미지 경로 리스트  
    @RequestMapping(value="/selectContImgList.do", method=RequestMethod.POST)
    public ModelAndView selectContImgList(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int intPageTotalCnt = 0;
        int intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) { 
                objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	
                log.info( "request parameter :  " + objMap );
                CommonUtils.initSearchRange(objMap);
                objList         = newContractMgmtService.selectContImgList(objMap);
                if(objList != null){
                	intPageTotalCnt = objList.size();//(Integer)newContractMgmtService.selectContImgListTotal(objMap);
                }
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    //가맹점 리스트 조회 
    @RequestMapping(value="/selectCoInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectCoInfoList(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int intPageTotalCnt = 0;
        int intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) { 
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                String frDt = "";
                String toDt = "";
                frDt = (String)objMap.get( "fromdate" );
    			frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "frDt" , frDt);
	        	toDt = (String)objMap.get( "todate" );
	        	toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "toDt" , toDt);
	        	
                log.info( "request parameter :  " + objMap );
                CommonUtils.initSearchRange(objMap);
                objList         = newContractMgmtService.selectCoInfoList(objMap);
                intPageTotalCnt = (Integer)newContractMgmtService.selectCoInfoListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    
    //영업관리 신규계약 승인
    @RequestMapping(value = "/newContractMgmtApprove.do")
    public String newContractMgmtApprove(Model model, CommonMap commonMap) throws Exception {
    	String codeCl = "";
    	List< Map< String, String > > listMap = new ArrayList<>();
    	
    	log.info( "신규계약승인-start-" );
    	
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            "102");
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0069"));        

        model.addAttribute("flagChk",          CommonDDLB.flagChk());
        model.addAttribute("useCash",          CommonDDLB.useCash());
        model.addAttribute("contFlg",          CommonDDLB.contFlg());
        model.addAttribute("inOutChk",          CommonDDLB.foreignCardType());
        model.addAttribute("DIVISION_SEARCH",                   CommonDDLB.merchantSearchType3(DDLBType.CHECK));
        
        log.info( "신규계약승인-1- 접수경로 조회" );
    	codeCl ="0007";
    	listMap = newContractMgmtService.selectCodeCl(codeCl);
    	model.addAttribute("RECV_CHANNEL_EDIT", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
    	
    	model.addAttribute("contRoute", CommonDDLB.ListOption(listMap ));
    	
    	log.info( "신규계약승인-2- 현재 상태 조회" );
    	codeCl ="0004";
    	listMap = newContractMgmtService.selectCodeCl(codeCl);
    	model.addAttribute("STATUSL_EDIT", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
    	model.addAttribute("STATUS",          CommonDDLB.ListOption(listMap));
    	
    	log.info("신규계약승인-3- 담당자 조회");
    	Map<String,Object> dataMap = new HashMap<String, Object>();
    	dataMap.put( "dept", "01" );
    	dataMap.put( "part", "ALL" );
    	dataMap.put( "duty", "ALL" );
    	dataMap.put( "appAuth", "ALL" );
    	dataMap.put( "status", "0" );
    	
    	listMap = newContractMgmtService.selectEmplList(dataMap);
    	model.addAttribute("EMP_MANAGER", CommonDDLB.MngOption(listMap));
    	
        return "/businessMgmt/newContractMgmt/newContractMgmtApprove";
    }
    //신규계약승인
    @RequestMapping(value="/selectCoApprInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectCoApprInfoList(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
    	ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        List<Map<String,Object>> mngList = new ArrayList<Map<String, Object>>();
        int intPageTotalCnt = 0;
        int intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) { 
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                String frDt = "";
                String toDt = "";
                frDt = (String)objMap.get( "fromdate" );
    			frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "frDt" , frDt);
	        	toDt = (String)objMap.get( "todate" );
	        	toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "toDt" , toDt);
	        	
                log.info( "request parameter :  " + objMap );
                CommonUtils.initSearchRange(objMap);
                
                objList         = newContractMgmtService.selectCoApprInfoList(objMap);
                intPageTotalCnt = (Integer)newContractMgmtService.selectCoApprInfoListTotal(objMap);
                log.info("commonMap : " + ToStringBuilder.reflectionToString( commonMap ));
                objMap.put( "empNo", commonMap.get( "USR_ID" ) );
                mngList = baseInfoMgmtService.selectEmpAuthSearch(objMap);
                objMv.addObject( "mngList" , mngList);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
  //신규계약승인 구분 mid
    @RequestMapping(value="/selectCoApprMInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectCoApprMInfoList(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int intPageTotalCnt = 0;
        int intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) { 
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                String frDt = "";
                String toDt = "";
                frDt = (String)objMap.get( "fromdate" );
    			frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "frDt" , frDt);
	        	toDt = (String)objMap.get( "todate" );
	        	toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "toDt" , toDt);
	        	
                log.info( "request parameter :  " + objMap );
                CommonUtils.initSearchRange(objMap);
                
                objList         = newContractMgmtService.selectCoApprMInfoList(objMap);
                intPageTotalCnt = (Integer)newContractMgmtService.selectCoApprMInfoListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    //가맹점 정보 리스트 excel 구분자 mid 
    @RequestMapping(value="/selectCoApprMInfoListExcel.do", method=RequestMethod.POST)
    public View selectCoApprMInfoListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            
            objExcelData = newContractMgmtService.selectCoApprMInfoList(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectCoApprInfoListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Co_Approve_Info(MID)_Infomation_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new CoApprInfoMListExcelGenerator();
    }
    
  //신규계약승인 구분 vid
    @RequestMapping(value="/selectCoApprVInfoList.do", method=RequestMethod.POST)
    public ModelAndView selectCoApprVInfoList(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int intPageTotalCnt = 0;
        int intResultCode   = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) { 
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                String frDt = "";
                String toDt = "";
                frDt = (String)objMap.get( "fromdate" );
    			frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "frDt" , frDt);
	        	toDt = (String)objMap.get( "todate" );
	        	toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "toDt" , toDt);
	        	
                log.info( "request parameter :  " + objMap );
                CommonUtils.initSearchRange(objMap);
                
                objList         = newContractMgmtService.selectCoApprVInfoList(objMap);
                intPageTotalCnt = (Integer)newContractMgmtService.selectCoApprVInfoListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            log.error("selectNewContractMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
    //가맹점 정보 리스트 excel
   @RequestMapping(value="/selectCoApprVInfoListExcel.do", method=RequestMethod.POST)
    public View selectCoApprVInfoListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            
            objExcelData = newContractMgmtService.selectCoApprVInfoList(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectCoApprInfoListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Co_Approve_Info(VID)_Infomation_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new CoApprInfoVListExcelGenerator();
    }
   
   //가맹점 승인반려 
   @RequestMapping(value="/updateCoApp.do", method=RequestMethod.POST)
   public ModelAndView updateCoApp(@RequestBody String strJsonParameter) throws Exception {
   	ModelAndView        objMv  = new ModelAndView();
       Map<String, Object> objMap = new HashMap<String, Object>();
       Map<String, Object> dataMap = new HashMap<String, Object>();
      
       int    intResultCode    = 0;
       int    cnt    = 0;
       String strResultMessage = "";
       
       try {
           if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
               objMap = CommonUtils.jsonToMap(strJsonParameter);
               log.info( "request parameter :  " + objMap );
               newContractMgmtService.updateCoApp(objMap);
               log.info( "insert success");
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
   
	//가맹점 번호 별 조회  
   @RequestMapping(value="/selectCoView.do", method=RequestMethod.POST)
   public ModelAndView selectCoView(@RequestBody String strJsonParameter) throws Exception {
   	ModelAndView        objMv  = new ModelAndView();
       Map<String, Object> objMap = new HashMap<String, Object>();
       Map<String, Object> dataMap = new HashMap<String, Object>();
      
       int    intResultCode    = 0;
       int    cnt    = 0;
       String strResultMessage = "";
       
       try {
           if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
               objMap = CommonUtils.jsonToMap(strJsonParameter);
               log.info( "request parameter :  " + objMap );
               dataMap = (Map<String, Object>)newContractMgmtService.selectCoView(objMap);
               log.info( "coView  : " + dataMap.get( "coView" )  );
               objMv.addObject( "coView" , dataMap.get( "coView" ) );
               objMv.addObject( "memoList" , dataMap.get( "memoList" ) );
               objMv.addObject( "contFeeAllInfo" , dataMap.get( "contFeeAllInfo" ) );
               log.info( "insert success");
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
 //가맹점 승인반려 
   @RequestMapping(value="/selectSerFeeView.do", method=RequestMethod.POST)
   public ModelAndView selectSerFeeView(@RequestBody String strJsonParameter) throws Exception {
   	ModelAndView        objMv  = new ModelAndView();
       Map<String, Object> objMap = new HashMap<String, Object>();
       Map<String, Object> dataMap = new HashMap<String, Object>();
      
       int    intResultCode    = 0;
       int    cnt    = 0;
       String strResultMessage = "";
       
       try {
           if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
               objMap = CommonUtils.jsonToMap(strJsonParameter);
               log.info( "request parameter :  " + objMap );
               dataMap = (Map<String, Object>)newContractMgmtService.selectFeeViewCardLst(objMap);
               objMv.addObject( "cardList", dataMap.get( "cardList" ) );
               objMv.addObject( "overCardList", dataMap.get( "overCardList" ) );
               objMv.addObject( "feeList", dataMap.get( "feeList" ) );
               objMv.addObject( "feeAddList", dataMap.get( "feeAddList" ) );
               log.info( "select success");
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
}
