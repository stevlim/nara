package egov.linkpay.ims.businessmgmt;

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
import org.springframework.web.servlet.View;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.businessmgmt.service.NewContractMgmtService;
import egov.linkpay.ims.businessmgmt.service.PwdDelService;
import egov.linkpay.ims.businessmgmt.service.SubMallService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

@Controller
@RequestMapping(value="/businessMgmt/subMall")
public class SubMallController
{
	    Logger log = Logger.getLogger(this.getClass());
	    
	    @Resource(name="subMallService")
	    private SubMallService subMallService;
	    
	    @Resource(name="baseInfoRegistrationService")
	    private BaseInfoRegistrationService baseInfoRegistrationService;
	    
	    /**--------------------------------------------------
	     * Method Name    : inquiryMgmt
	     * Description    : 메뉴 진입
	     * Author         : ymjo, 2015. 10. 8.
	     * Modify History : Just Created.
	     ----------------------------------------------------*/
	    @RequestMapping(value="/cardRegist.do")
	    public String cardRegist(Model model, CommonMap commonMap) throws Exception {
	    	List< Map< String, String > > listMap = new ArrayList<Map< String, String >>();
	    	String codeCl = "";
	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "16");
	    	model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0051"));
	        
	        model.addAttribute("askStatus",          CommonDDLB.askStatus(DDLBType.SEARCH));
	        log.info("제휴사서브몰현황 -1- 담당자 조회");
	    	Map<String,Object> dataMap = new HashMap<String, Object>();
	    	dataMap.put( "dept", "01" );
	    	dataMap.put( "part", "ALL" );
	    	dataMap.put( "duty", "ALL" );
	    	dataMap.put( "appAuth", "ALL" );
	    	dataMap.put( "status", "0" );
	    	listMap = baseInfoRegistrationService.selectEmplList(dataMap);
	    	model.addAttribute("EMP_MANAGER", CommonDDLB.MngOptionSet(DDLBType.SEARCH, listMap));
	    	
	    	log.info( "제휴사서브몰현황-2- 카드 조회" );
	    	dataMap.put( "code2", "pur" );
        	listMap = baseInfoRegistrationService.selectCardList( dataMap);   
	    	model.addAttribute("CARD_LIST", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
	    	
	    	log.info( "제휴사서브몰현황-2- 등록 상태 조회" );
	    	codeCl ="0054";
	    	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
	    	model.addAttribute("STATUSL_EDIT", CommonDDLB.ListOptionSet( DDLBType.SEARCH, listMap ));
	        
	        return "/businessMgmt/subMall/cardRegist";
	    }
	    
	    //가맹점 리스트 조회 
	    @RequestMapping(value="/selectSubCardList.do", method=RequestMethod.POST)
	    public ModelAndView selectSubCardList(@RequestBody String strJsonParameter) throws Exception {
	    	ModelAndView             objMv   = new ModelAndView();
	        Map<String, Object>      objMap  = new HashMap<String, Object>();
	        Map<String, Object>      dataMap  = new HashMap<String, Object>();
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
	                dataMap         = subMallService.selectCardStatusList(objMap);
	                objList = ( List< Map< String, Object > > ) dataMap.get("data");
	                log.info( "datMap : " + dataMap );
	                log.info( "datMap : " + dataMap.get( "data" ) );
	                //objList.add( ( Map< String, Object > ) dataMap.get( "cardLst" ) );
	                objMv.addObject( "data", dataMap.get( "data" ) );
	                objMv.addObject( "cardLst", dataMap.get( "cardLst" ) );
	                
	                
	                //log.info( "cardInfo  : " + dataMap.get( "cardInfo" ));
	                intPageTotalCnt = (Integer)subMallService.selectCardStatusListTotal(objMap);
	            } else {
	                intResultCode    = 9999;
	                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
	            }
	        } catch(Exception ex) {
	            intResultCode    = 9999;
	            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
	            log.error("selectNewContractMgmtList.do exception : " + ex.getMessage());
	        } finally {
	        		if (intResultCode == 0) {
		                objMv = CommonUtils.resultSuccess(objMv);
		            } else {
		                objMv = CommonUtils.resultFail(objMv, strResultMessage);
		            }
	        }
	        objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	        objMv.setViewName("jsonView");
	        
	        return objMv;
	    }
	    
	    //카드 리스트 엑셀 
	    @RequestMapping(value="/selectSubCardListExcel.do", method=RequestMethod.POST)
	    public View selectSubCardListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
	        Map<String,Object>       objMap           = new HashMap<String, Object>();        
	        Map<String,Object>       dataMap           = new HashMap<String, Object>();
	        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
	        
	        try { 
	            objMap = CommonUtils.queryStringToMap(strJsonParameter);
	            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
	            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
	            String frDt = "";
                String toDt = "";
                frDt = (String)objMap.get( "fromdate" );
    			frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "frDt" , frDt);
	        	toDt = (String)objMap.get( "todate" );
	        	toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	        	objMap.put( "toDt" , toDt);
	        	dataMap = subMallService.selectCardStatusList(objMap);
	            objExcelData = ( List< Map< String, Object > > ) dataMap.get( "data" );
	            
	            
	        } catch(Exception ex) {
	            objExcelMap  = null;
	            objExcelData = null;
	            log.error("selectCoApprInfoListExcel.do exception : " , ex);
	        } finally {
	            objExcelMap.put("excelName", "Submall_Card_Infomation_List");
	            objExcelMap.put("excelData", objExcelData);
	            objExcelMap.put("cardLst", dataMap.get( "cardLst" ));
	            objExcelMap.put("reqData",   objMap);
	        }
	        
	        return new SubmallCardListExcelGenerator();
	    }
	    
	    //제휴사 카드 정보   
	    @RequestMapping(value="/selectCardSubMallInfo.do", method=RequestMethod.POST)
	    public ModelAndView selectCardSubMallInfo(@RequestBody String strJsonParameter) throws Exception {
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
	                dataMap = (Map<String, Object>)subMallService.selectCardSubMallInfo(objMap);
	                objMv.addObject( "data" , dataMap );
	                log.info( "coView  : " + dataMap );
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
	    
	  //제휴사 카드 정보   
	    @RequestMapping(value="/insertSubCardReg.do", method=RequestMethod.POST)
	    public ModelAndView insertSubCardReg(@RequestBody String strJsonParameter) throws Exception {
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
	                cnt = subMallService.insertSubCardReg(objMap);
	                if(cnt>0){
	                	if(cnt == 99 ){
	                		strResultMessage = "변경사항이없습니다.";
	                	}else{
	                		strResultMessage = "적용되었습니다.";
	                	}
	                }else{
	                	intResultCode    = 9999;
	                	strResultMessage = "실패하였습니다..";
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
	            if (intResultCode == 0) {
	                objMv = CommonUtils.resultSuccess(objMv);
	            } else {
	                objMv = CommonUtils.resultFail(objMv, strResultMessage);
	            }
	        }
	        
	        objMv.setViewName("jsonView");
	        
	        return objMv;
	    }
	    
	    @RequestMapping(value="/vacctRegist.do")
	    public String vacctRegist(Model model, CommonMap commonMap) throws Exception {
	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "22");
	    	model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0053"));
	        return "/businessMgmt/subMall/vacctRegist";
	    }
	    @RequestMapping(value="/phoneRegist.do")
	    public String phoneRegist(Model model, CommonMap commonMap) throws Exception {
	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "23");
	    	model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0054"));
	        return "/businessMgmt/subMall/phoneRegist";
	    }
	    @RequestMapping(value="/cashRecetRegist.do")
	    public String CashRecetRegist(Model model, CommonMap commonMap) throws Exception {
	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "24");
	    	model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0055"));
	        return "/businessMgmt/subMall/cashRecetRegist";
	    }
}
