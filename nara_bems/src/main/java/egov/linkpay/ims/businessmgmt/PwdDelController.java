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

import egov.linkpay.ims.businessmgmt.service.PwdDelService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

@Controller
@RequestMapping(value="/businessMgmt/pwdDel")
public class PwdDelController
{
	    Logger log = Logger.getLogger(this.getClass());
	    
	    @Resource(name="pwdDelService")
	    private PwdDelService pwdDelService;
	    
	    /**--------------------------------------------------
	     * Method Name    : inquiryMgmt
	     * Description    : 메뉴 진입
	     * Author         : ymjo, 2015. 10. 8.
	     * Modify History : Just Created.
	     ----------------------------------------------------*/
	    @RequestMapping(value="/pwdDel.do")
	    public String pwdDel(Model model, CommonMap commonMap) throws Exception {
	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
	        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_SGMNT", CommonConstants.BUSINESSMGMT_MERCHANTMGMT_INQUIRY_SEGMNT);
	        
	        model.addAttribute("searchFlg",   CommonDDLB.searchFlg());
	        
	        return "/businessMgmt/pwdDel/pwdDel";
	    }
	    
	    //비밀번호 초기화 리스트 
	    @RequestMapping(value="/selectPWDList.do", method=RequestMethod.POST)
	    public ModelAndView selectPWDList(@RequestBody String strJsonParameter) throws Exception {
	    	ModelAndView             objMv   = new ModelAndView();
	        Map<String, Object>      objMap  = new HashMap<String, Object>();
	        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	        
	        int intPageTotalCnt = 0;
	        int intResultCode   = 0;
	        String strResultMessage = "";
	        
	        try {
	            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
	            	log.info( "request parameter :  " + strJsonParameter );
	                objMap = CommonUtils.jsonToMap(strJsonParameter);
	                log.info( "request parameter :  " + objMap );
	                CommonUtils.initSearchRange(objMap);
	                
	                objList         = pwdDelService.selectPWDList(objMap);
	                intPageTotalCnt = (Integer)pwdDelService.selectPWDListTotal(objMap);
	            } else {
	                intResultCode    = 9999;
	                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
	            }
	        } catch(Exception ex) {
	            intResultCode    = 9999;
	            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
	            log.error("selectPWDList.do exception : " + ex.getMessage());
	        } finally {
	            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	        }
	        
	        objMv.setViewName("jsonView");
	        
	        return objMv;
	    }
	    //비번 초기화 업데이트
	    @RequestMapping(value="/updatePwdInit.do", method=RequestMethod.POST)
	    public ModelAndView updatePwdInit(@RequestBody String strJsonParameter) throws Exception {
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
	                pwdDelService.updatePwdInit(objMap);
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
	    //거래 취소 비번 초기화 업데이트
	    @RequestMapping(value="/updateChangeCcPw.do", method=RequestMethod.POST)
	    public ModelAndView updateChangeCcPw(@RequestBody String strJsonParameter) throws Exception {
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
	                pwdDelService.updateChangeCcPw(objMap);
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
