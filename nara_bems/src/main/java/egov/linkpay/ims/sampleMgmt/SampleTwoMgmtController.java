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
     * Method Name    : selectApproLimitDetail
     * Description    : sample 02 view real time inquiry
     * Author         : st.lim, 2019. 02. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/selectApproLimitDetail.do", method = RequestMethod.POST)
	public ModelAndView selectApproLimitDetail(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		//Map<String, Object> rstMap = new HashMap<String, Object>();
		int intResultCode = 0;
		//int intPageTotalCnt = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);

				//rstMap = rmApprovalService.getContLimitDetail(objMap);

				// test
				Map<String, Object> testMap = new HashMap<String, Object>();
				testMap.put("DATA01", (int)(Math.random()*100));
				testMap.put("DATA02", (int)(Math.random()*100));
				testMap.put("DATA03", (int)(Math.random()*100));
				testMap.put("DATA04", (int)(Math.random()*100));
				testMap.put("DATA05", (int)(Math.random()*100));
				testMap.put("DATA06", (int)(Math.random()*100));
				testMap.put("DATA07", (int)(Math.random()*100));
				testMap.put("DATA08", (int)(Math.random()*100));
				testMap.put("DATA09", (int)(Math.random()*100));
				testMap.put("DATA10", (int)(Math.random()*100));
				testMap.put("DATA11", (int)(Math.random()*100));
				testMap.put("DATA12", (int)(Math.random()*100));

				
				//objMv.addObject("data", rstMap);
				objMv.addObject("data", testMap);
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
