package egov.linkpay.ims.paymentMgmt;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;

@Controller
@RequestMapping(value="/paymentMgmt/trans")
public class TransController
{
	Logger logger = Logger.getLogger(this.getClass());
	
	 // 가상계좌 결제내역조회 
	 @RequestMapping(value="/transInquiry.do")
	    public String acctPayInquiry(Model model, CommonMap commonMap) throws Exception {
		 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "46");
	        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0078"));
	        
	        model.addAttribute("MER_SEARCH",          CommonDDLB.merchantType5());
	        model.addAttribute("Option_Chk",          CommonDDLB.OptionChk(DDLBType.CHECK));
	        model.addAttribute("BankOption",          CommonDDLB.BankOption(DDLBType.SEARCH));
	        model.addAttribute("SettleCycle",          CommonDDLB.SettleCycle(DDLBType.SEARCH));
	        model.addAttribute("Status",          CommonDDLB.Status(DDLBType.SEARCH));
	        model.addAttribute("Escrow",          CommonDDLB.Escrow(DDLBType.SEARCH));
	        model.addAttribute("ConnFlg",          CommonDDLB.ConnFlg(DDLBType.SEARCH));
	        model.addAttribute("DealFlg",          CommonDDLB.DealFlg(DDLBType.SEARCH));
	        model.addAttribute("DateChk",          CommonDDLB.DateChk());
	        
	        return "/paymentMgmt/acct/acctPayInquiry";
	    }
	 //가상ㄱ계좌 환불내역 조회 
	 @RequestMapping(value="/acctRefundInquiry.do")
	    public String acctRefundInquiry(Model model, CommonMap commonMap) throws Exception {
		 	model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
	        model.addAttribute("SUBMENU",            "47");
	        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
	        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0079"));
	        
	        model.addAttribute("Escrow",          CommonDDLB.Escrow(DDLBType.SEARCH));
	        model.addAttribute("DateChk",          CommonDDLB.RefDateChk());
	        model.addAttribute("MER_SEARCH",          CommonDDLB.RefSearchFlg(DDLBType.SEARCH));
	        model.addAttribute("Option_Chk",          CommonDDLB.RefOption(DDLBType.CHECK));
	        
	        return "/paymentMgmt/acct/acctRefundInquiry";
	    }
}
