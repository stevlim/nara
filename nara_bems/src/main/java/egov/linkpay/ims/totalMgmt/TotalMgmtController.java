package egov.linkpay.ims.totalMgmt;

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

import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonUtils.DateFormat;
import egov.linkpay.ims.home.service.HomeService;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.home
 * File Name      : HomeController.java
 * Description    : Home Controller(Dashboard)
 * Author         : ymjo, 2015. 10. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/totalMgmt/plInquiryMgmt")
public class TotalMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
	
   @RequestMapping(value="/plInquiryMgmt.do")
   public String plInquiryMgmt(Model model, CommonMap commonMap) throws Exception {
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
       model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
       model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
       model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
       return "/totalMgmt/plInquiryMgmt/plInquiryMgmt";
   }
   @RequestMapping(value="/plInquiryByCompMgmt.do")
   public String plInquiryByCompMgmt(Model model, CommonMap commonMap) throws Exception {
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
       model.addAttribute("SUBMENU",            "67");
       model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
       model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0064"));  //업체별 손익조회
      
       model.addAttribute("SEARCH_FLG",    CommonDDLB.TotalOption());
       model.addAttribute("DATE_CHK",    CommonDDLB.TotalDateChk());
       
       return "/totalMgmt/plInquiryMgmt/plInquiryByCompMgmt";
   }
}