package egov.linkpay.ims.baseinfomgmt;

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
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.baseinfomgmt.service.MerChantFeeInquiryService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.baseinfomgmt
 * File Name      : BaseInfoMgmtController.java
 * Description    : 기본정보 - 기본정보 조회
 * Author         : ChoiIY, 2017. 04. 17.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/baseInfoMgmt/merchantFeeInquiry")
public class MerchantFeeInquiryController {
    Logger log = Logger.getLogger(this.getClass());

    @Resource(name="merchantFeeInquiryService")
    private MerChantFeeInquiryService merchantFeeInquiryService;
    /**--------------------------------------------------
     * Method Name    : baseInfo
     * Description    : 메뉴 진입
     * Author         : ChoiIY, 2017. 04. 17.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/merchantFeeInquiry.do")
    public String merchantFeeInquiry(Model model, CommonMap commonMap) throws Exception {
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        model.addAttribute("PaymentMethod_SEARCH",          CommonDDLB.paymentMethodSearchType(DDLBType.SEARCH));
        
        return "/baseInfoMgmt/merchantFeeInquiry/merchantFeeInquiry";
    }
    
    //mid 별 수수료 조회
    @RequestMapping(value = "/selectMerFeeList.do" )
    public ModelAndView selectMerFeeList(@RequestBody String strJsonParameter) throws Exception
    {	
 	    ModelAndView objMv  = new ModelAndView();
 	   	Map< String, Object > objMap = new HashMap<String, Object>();
 	   	List<Map< String, Object >> objList = new ArrayList<Map<String, Object>>();
 	   	Map< String, Object > dataMap = new HashMap<String, Object>();
 	   	int intResultCode = 0;
 	   	int intPageTotalCnt = 0;
 	   	String strResultMessage = "";
 	   	log.info( "가맹점 수수료 내역 조회 - Start -" );
 	   	try 
 	   	{
 	   			if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
 	           {
 		           	log.info( "가맹점 수수료 내역 조회-1-파라미터 null 체크 " );
 		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
 		           	
 		           	CommonUtils.initSearchRange(objMap);
 		           log.info( "가맹점 수수료 내역 조회-1-파라미터 : "  + objMap );
 		           	objList = merchantFeeInquiryService.selectMerFeeList(objMap);
 		           	intPageTotalCnt = (Integer)merchantFeeInquiryService.selectMerFeeListTotal(objMap);
 	           }
 	           else
 	           {
 	        	   log.info( "가맹점 수수료 내역 조회-1-파라미터 null " );
 	           }
 	           
 	   	}
 	   	catch(Exception e)
 	   	{
 	   		log.error( "가맹점 수수료 내역 조회-Exception : ", e );
 	   	}
 	   	finally
 	   	{
 	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
 	   	} 
 	   	objMv.setViewName("jsonView");
 	   	log.info( "가맹점 수수료 내역 조회- End -" );
 	    return objMv; 
    }
}
