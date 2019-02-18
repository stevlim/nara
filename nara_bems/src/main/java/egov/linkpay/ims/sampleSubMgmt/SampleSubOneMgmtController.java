package egov.linkpay.ims.sampleSubMgmt;

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
import egov.linkpay.ims.sampleSubMgmt.service.SampleSubMgmtService;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.sampleSubMgmt
 * File Name      : SampleSubOneMgmtController.java
 * Description    : SampleSubOneMgmtController
 * Author         : st.lim, 2019. 02. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/sampleSubMgmt/sampleSubOneMgmt")
public class SampleSubOneMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="sampleSubMgmtService")
    private SampleSubMgmtService sampleSubMgmtService;
    
    /**--------------------------------------------------
     * Method Name    : sampleSubOneMgmt
     * Description    : sample sub 01 view
     * Author         : st.lim, 2019. 02. 18.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/sampleSubOneMgmt.do")
    public String sampleSubOneMgmt(Model model, CommonMap commonMap) throws Exception {
        
        return "/sampleSubMgmt/sampleSubOneMgmt/sampleSubOneMgmt";
    }
    
    
}
