package egov.linkpay.ims.rmApproval;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.google.gson.JsonParser;

import egov.linkpay.ims.calcuMgmt.service.CalcuMgmtService;
import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.rmApproval.service.RmApprovalService;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.paymentMgmt.CardInfoListExcelGenerator;

@Controller
@RequestMapping(value = "/rmApproval/newContComp")
public class NewContCompController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "rmApprovalService")
	private RmApprovalService rmApprovalService;
	
	@RequestMapping(value = "/newContComp.do")
	public String newContComp(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", commonMap.get("MENU_NO"));   //신규계약 가맹점 현환 "52"
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString())); //CommonMessageDic.getMessage("IMS_MENU_SUB_0081")

		model.addAttribute("SEARCH_FLG", CommonDDLB.RMOption(DDLBType.CHOICE));
		model.addAttribute("DATE_CHK", CommonDDLB.RMDateOption());
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codeType", "1");
		params.put("codeCl", "BS_KIND_CD");
		List<Map<String, String>> listMap1 = rmApprovalService.getCateCodeList(params);
		model.addAttribute("CATE1", CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap1));

		return "/rmApproval/approvalLimit/newContComp";
	}
	//신규계약 가맹점 현황 리스트 조회 
	@RequestMapping(value = "/selectContCompList.do", method=RequestMethod.POST)
    public ModelAndView selectContCompList(HttpServletRequest request, @RequestBody String strJsonParameter) throws Exception 
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	Map< String, Object > dataMap = new HashMap<String, Object>();
    	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
    	int intResultCode    = 0;
    	int intPageTotalCnt = 0;
    	String strResultMessage = "";
    	String frDt = "";
    	String toDt = "";
    	
    	JsonParser jsonParser = new JsonParser();
    	log.info( "신규계약 가맹점 현황 리스트- Start -" );
    	try 
    	{
    		if (!CommonUtils.isNullorEmpty(strJsonParameter)) 
    		{
    			log.info( "strJsonParameter  : " + strJsonParameter );
    			objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	frDt= (String)objMap.get( "fromdate" );
	            frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "frDt", frDt );
	            toDt= (String)objMap.get( "todate" );
	            toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
	            objMap.put( "toDt", toDt );
    			
	            CommonUtils.initSearchRange(objMap);
    			log.info( "신규계약 가맹점 현황 리스트- parameter : " + objMap );
    			
    			objList = 	rmApprovalService.selectContCompList(objMap);
    			intPageTotalCnt = Integer.parseInt(rmApprovalService.selectContCompListCnt(objMap).toString());
    		}
    		else
    		{
    			log.info( "신규계약 가맹점 현황 리스트-1-파라미터 null " );
    		}
    		
    	}
    	catch(Exception e)
    	{
    		log.error( "신규계약 가맹점 현황 리스트-Exception : ", e );
    	}
    	finally
    	{
    		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
    	}
    	
    	objMv.setViewName("jsonView");
    	log.info( "신규계약 가맹점 현황 리스트- End -" );
    	return objMv; 
    }
}
