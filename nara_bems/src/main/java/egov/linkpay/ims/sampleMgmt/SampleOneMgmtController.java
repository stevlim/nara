package egov.linkpay.ims.sampleMgmt;

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

import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.sampleMgmt.service.SampleMgmtService;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.sampleMgmt
 * File Name      : SampleOneMgmtController.java
 * Description    : SampleOneMgmtController
 * Author         : st.lim, 2019. 02. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/sampleMgmt/sampleOneMgmt")
public class SampleOneMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="sampleMgmtService")
    private SampleMgmtService sampleMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : sampleOneMgmt
     * Description    : sample 01 view
     * Author         : st.lim, 2019. 02. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/sampleOneMgmt.do")
    public String sampleOneMgmt(Model model, CommonMap commonMap) throws Exception {
    	/*model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("MENU_SUBMENU_SGMNT", CommonConstants.BUSINESSMGMT_MERCHANTMGMT_FAQ_SEGMNT);
        
        model.addAttribute("division",   CommonDDLB.faqDivision(DDLBType.EDIT));
        model.addAttribute("faqFlag",   CommonDDLB.faqFlag(DDLBType.EDIT));
        model.addAttribute("BOARD_TYPE",   CommonDDLB.faqDivision(DDLBType.SEARCH));*/
    	
        return "/sampleMgmt/sampleOneMgmt/sampleOneMgmt";
    }
    
    
    /*@RequestMapping(value="/selectFaqMgmtList.do", method=RequestMethod.POST)
    public ModelAndView selectFaqMgmtList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        
        int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
               
                CommonUtils.initSearchRange(objMap);
    
                objList         = sampleMgmtService.selectFaqMgmtList(objMap);
                for( Map<String, Object> row : objList) {
                	if(row.get("BODY") instanceof java.sql.Clob) {
                		String body = CommonUtils.clobToString((java.sql.Clob)row.get("BODY"));
                		row.put("BODY", body);
                	}
                }
                intPageTotalCnt = (Integer)sampleMgmtService.selectFaqMgmtListTotal(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectFaqMgmtList.do exception : " + ex.getMessage());
        } finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }
    
   
    @RequestMapping(value="/selectFaqMgmt.do", method=RequestMethod.POST)
    public ModelAndView selectFaqMgmt(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        Map<String, Object> objRow = new HashMap<String, Object>();
       
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objRow = sampleMgmtService.selectFaqMgmt(objMap);
                if(objRow.get("BODY") instanceof java.sql.Clob) {
            		String body = CommonUtils.clobToString((java.sql.Clob)objRow.get("BODY"));
            		objRow.put("BODY", body);
            	}
                objMv.addObject("rowData", objRow);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectFaqMgmt.do exception : " + ex.getMessage());
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
    
   
    @RequestMapping(value="/insertFaqMgmt.do", method=RequestMethod.POST)
    public ModelAndView insertFaqMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {            
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                
                sampleMgmtService.insertFaqMgmt(objMap);                
            } else {                
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("insertFaqMgmt.do exception : " + ex.getMessage());
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
    

    @RequestMapping(value="/updateFaqMgmt.do", method=RequestMethod.POST)
    public ModelAndView updateFaqMgmt(@RequestBody String strJsonParameter, CommonMap commonMap) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        
        int    intResultCode    = 0;
        String strResultMessage = "";
        
        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                objMap.put("WORKER",    commonMap.get("USR_ID"));
                
                sampleMgmtService.updateFaqMgmt(objMap);
                
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("updateFaqMgmt.do exception : " + ex.getMessage());
        } finally {
            if (intResultCode == 0) {
                objMv = CommonUtils.resultSuccess(objMv);
            } else {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }
        
        objMv.setViewName("jsonView");
        
        return objMv;
    }*/
}
