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
@RequestMapping(value="/totalMgmt/etcTotalMgmt")
public class EtcTotalMgmtController {
    Logger logger = Logger.getLogger(this.getClass());
	
   @RequestMapping(value="/saleManagerInquiry.do")
   public String saleManagerInquiry(Model model, CommonMap commonMap) throws Exception {
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
       model.addAttribute("SUBMENU",            "69");  //영업 담당자별 매출조회
       model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
       model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0066"));
       return "/totalMgmt/etcTotalMgmt/saleManagerInquiry";
   }
   @RequestMapping(value="/dataExtract.do")
   public String dataExtract(Model model, CommonMap commonMap) throws Exception {
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
       model.addAttribute("SUBMENU",            "70");
       model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
       model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0067"));
       return "/totalMgmt/etcTotalMgmt/dataExtract";
   }
   @RequestMapping(value="/periodTotal.do")
   public String periodTotal(Model model, CommonMap commonMap) throws Exception {
	 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
       model.addAttribute("SUBMENU",            "71"); //기간별 통계 
       model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
       model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0068"));
       
       model.addAttribute("SEARCH_FLG",    CommonDDLB.EtcTotalOption());
       
       return "/totalMgmt/etcTotalMgmt/periodTotal";
   }
}