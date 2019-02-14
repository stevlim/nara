package egov.linkpay.ims.businessmgmt;

import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egov.linkpay.ims.businessmgmt.service.PwdDelService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDAO;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

@Controller
@RequestMapping(value="/businessMgmt/oriComp")
public class OriCompMgmtController
{
	    Logger logger = Logger.getLogger(this.getClass());
	    
	    @Resource(name="commonDAO")
	    private CommonDAO commonDAO;
	    
	    /**--------------------------------------------------
	     * Method Name    : inquiryMgmt
	     * Description    : 메뉴 진입
	     * Author         : ymjo, 2015. 10. 8.
	     * Modify History : Just Created.
	     ----------------------------------------------------*/
	    @RequestMapping(value="/managerChk.do")
	    public String managerChk(Model model, CommonMap commonMap) throws Exception {
	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "26");
	        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0070"));
	        model.addAttribute("MENU_SUBMENU_SGMNT", CommonConstants.BUSINESSMGMT_MERCHANTMGMT_INQUIRY_SEGMNT);
	        return "/businessMgmt/oriComp/managerChk";
	    }
	    @RequestMapping(value="/acceptInquiry.do")
	    public String acceptInquiry(Model model, CommonMap commonMap) throws Exception {
	    	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "27");
	        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0071"));
	        model.addAttribute("MENU_SUBMENU_SGMNT", CommonConstants.BUSINESSMGMT_MERCHANTMGMT_INQUIRY_SEGMNT);
	        return "/businessMgmt/oriComp/acceptInquiry";
	    }
}
