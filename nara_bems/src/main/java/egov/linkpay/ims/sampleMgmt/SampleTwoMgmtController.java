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

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.sampleMgmt.service.SampleMgmtService;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.sampleMgmt
 * File Name      : SampleTwoMgmtController.java
 * Description    : SampleTwoMgmtController
 * Author         : st.lim, 2019. 02. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/sampleMgmt/sampleTwoMgmt")
public class SampleTwoMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="sampleMgmtService")
    private SampleMgmtService sampleMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : sampleTwoMgmt
     * Description    : sample 02 view
     * Author         : st.lim, 2019. 02. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/sampleTwoMgmt.do")
    public String sampleTwoMgmt(Model model, CommonMap commonMap) throws Exception {
    
        return "/sampleMgmt/sampleTwoMgmt/sampleTwoMgmt";
    }
    
    /**--------------------------------------------------
     * Method Name    : faqMgmt
     * Description    : 메뉴 진입
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/selectApproLimitDetail.do", method = RequestMethod.POST)
	public ModelAndView selectApproLimitDetail(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		Map<String, Object> rstMap = new HashMap<String, Object>();
		int intResultCode = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);

				//rstMap = rmApprovalService.getContLimitDetail(objMap);

				// test
				/*Map<String, Object> testMap = new HashMap<String, Object>();
				testMap.put("SEQ", "1");
				testMap.put("FR_DT", "20170629");
				testMap.put("TO_DT", "20170629");
				testMap.put("REG_DATE", "1");
				testMap.put("WORKER", "1");
				testMap.put("INSTMN_DT", "1");
				testMap.put("LMT_CD_NM", "1");
				testMap.put("LMT_CD", "1");
				testMap.put("LMT_ID", "1");
				testMap.put("LMT_TYPE_CD_NM", "1"); 
				testMap.put("LMT_TYPE_CD", "1");
				testMap.put("CATE1", "1");
				testMap.put("CATE2", "1");
				testMap.put("BLOCK_NM", "1");
				testMap.put("BLOCK_FLG", "1");
				testMap.put("LMT_CD_DESC", "1");
				testMap.put("PM_NM", "1");
				testMap.put("PM_CD", "1");
				testMap.put("SPM_NM", "1");
				testMap.put("SPM_CD", "1");
				testMap.put("TRX_ST_NM", "1");
				testMap.put("TRX_ST_CD", "1");
				testMap.put("AMT_TYPE_NM", "1");
				testMap.put("AMT_TYPE", "1");
				testMap.put("AMT_LMT", "1");
				testMap.put("CNT_TYPE_NM", "1");
				testMap.put("CNT_TYPE", "1");
				testMap.put("CNT_LMT", "1");
				testMap.put("NOTI_NM", "1");
				testMap.put("NOTI_FLG", "1");
				testMap.put("NOTI_PCT", "1");
				testMap.put("NOTI_TRG_TYPE_NM", "1"); 
				testMap.put("NOTI_TRG_TYPE", "1");
				testMap.put("MEMO", "1");
				testMap.put("EMAIL_LIST", "1");
				testMap.put("SMS_LIST", "1");
				testMap.put("MODIFY_YN", "Y");*/
				
				objMv.addObject("data", rstMap);
				//objMv.addObject("data", testMap);
			}
		} catch (Exception e) {
			intResultCode = 9999;
			//log.error("selectCateList.do exception : ", e);
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
