package egov.linkpay.ims.rmApproval;

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
import org.springframework.web.servlet.View;

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
@RequestMapping(value = "/rmApproval/approvalLimit")
public class ApprovalLimitController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "rmApprovalService")
	private RmApprovalService rmApprovalService;
	
	@RequestMapping(value = "/selectSubCategory.do", method = RequestMethod.POST)
	public ModelAndView selectSubCategory(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		Map<String, Object> rstMap = new HashMap<String, Object>();
		List<Map<String, String>> rstMapList = null;
		int intResultCode = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("codeType", "1");
				params.put("codeCl", "BS_KIND_CD");
				params.put("code1", objMap.get("code1"));
				rstMapList = rmApprovalService.getSubCateCodeList(params);

				objMv.addObject("data", rstMapList);
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("selectCateList.do exception : ", e);
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

	@RequestMapping(value = "/approLimitRegist.do")
	public String approLimitRegist(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "53");   //승인한도 등록 및 수정 
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0082"));

		model.addAttribute("SEARCH_FLG", CommonDDLB.RMRegOption(DDLBType.SEARCH));
		model.addAttribute("Cut_Chk", CommonDDLB.RMCutChk(DDLBType.CHOICE));
		model.addAttribute("PAY_TYPE", CommonDDLB.RMPayType(DDLBType.CHOICE));
		model.addAttribute("DATE_CHK", CommonDDLB.RMDateChk());
		model.addAttribute("EXHAUST_RATE", CommonDDLB.RMExhRate(DDLBType.CHOICE));
		model.addAttribute("Cut_Chk1", CommonDDLB.RMCutChk(DDLBType.EDIT));
		model.addAttribute("PAY_TYPE1", CommonDDLB.RMPayType(DDLBType.EDIT));
		model.addAttribute("INST_MON", CommonDDLB.InstMon());
		model.addAttribute("LIMIT_CASH", CommonDDLB.RMLimitCash());
		model.addAttribute("LIMIT_COUNT", CommonDDLB.RMLimitCount());
		model.addAttribute("SEND_CHK", CommonDDLB.RMSendChk());
		model.addAttribute("TARGET", CommonDDLB.RMTarget());
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codeType", "1");
		params.put("codeCl", "BS_KIND_CD");
		List<Map<String, String>> listMap1 = rmApprovalService.getCateCodeList(params);
		model.addAttribute("CATE1", CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap1));
		params.put("codeCl", "CARD_CD");
		List<Map<String, String>> listMap2 = rmApprovalService.getCateCodeList(params);
		model.addAttribute("CARDCD", CommonDDLB.ListOptionSet(DDLBType.EDIT, listMap2));

		return "/rmApproval/approvalLimit/approLimitRegist";
	}

	@RequestMapping(value = "/approLimitInquiry.do")
	public String approLimitInquiry(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "54");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0083"));

		model.addAttribute("SEARCH_FLG", CommonDDLB.RMRegOption(DDLBType.SEARCH));
		model.addAttribute("Cut_Chk", CommonDDLB.RMCutChk(DDLBType.CHOICE));
		model.addAttribute("PAY_TYPE", CommonDDLB.RMPayType(DDLBType.CHOICE));
		model.addAttribute("DATE_CHK", CommonDDLB.RMDateChk());
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codeType", "1");
		params.put("codeCl", "BS_KIND_CD");
		List<Map<String, String>> listMap1 = rmApprovalService.getCateCodeList(params);
		List<Map<String, String>> listMap2 = rmApprovalService.getSubCateCodeList(params);
		model.addAttribute("CATE1", CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap1));
		model.addAttribute("CATE2", CommonDDLB.sListOption(listMap2));

		return "/rmApproval/approvalLimit/approLimitInquiry";
	}

	@RequestMapping(value = "/limitReqInquiry.do")
	public String limitReqInquiry(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "55");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0084"));

		model.addAttribute("Cut_Chk", CommonDDLB.RMCutChk(DDLBType.CHOICE));
		model.addAttribute("PAY_TYPE", CommonDDLB.RMPayType(DDLBType.CHOICE));
		model.addAttribute("SEARCH_FLG", CommonDDLB.RMLimitOption());
		model.addAttribute("RM_STATUS", CommonDDLB.RMStatus(DDLBType.CHOICE));
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("codeType", "1");
		params.put("codeCl", "BS_KIND_CD");
		List<Map<String, String>> listMap1 = rmApprovalService.getCateCodeList(params);
		model.addAttribute("CATE1", CommonDDLB.ListOptionSet(DDLBType.SEARCH, listMap1));

		return "/rmApproval/approvalLimit/limitReqInquiry";
	}
	
	@RequestMapping(value = "/selectApproLimitList.do", method = RequestMethod.POST)
	public ModelAndView selectApproLimitList(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		Map<String, Object> rstMap = new HashMap<String, Object>();
		List<Map<String, Object>> objList = new ArrayList<Map<String, Object>>();
		int intResultCode = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);
				CommonUtils.initSearchRange(objMap);

				String frDt = "";
				String toDt = "";
				
				if(objMap.get("dateChk").equals("1")){
					frDt = (String) objMap.get("fromdate");
				}
				else if(objMap.get("dateChk").equals("2")){
					frDt = (String) objMap.get("fromdate");
					toDt = (String) objMap.get("todate");
				}

				frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				objMap.put("frDt", frDt);
				objMap.put("toDt", toDt);

				objList = rmApprovalService.getContLimitList(objMap);

				// test
				/*Map<String, Object> testMap = new HashMap<String, Object>();
				testMap.put("ROWNUM", "1");
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
				testMap.put("MODIFY_YN", "Y");
				objList.add(testMap);*/
				
				if (objList.size() == 0) {
					//intResultCode = 9999;
					//strResultMessage = "DATA NOT EXIST";
					//log.info("History조회- 기준정보 변경이력 조회-1-select fail");
					intPageTotalCnt = 0;
				}

				intPageTotalCnt = objList.size();
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("selectCateList.do exception : ", e);
		} finally {
			if (intResultCode == 0) {
				objMv = CommonUtils.resultSuccess(objMv);
			} else {
				objMv = CommonUtils.resultFail(objMv, strResultMessage);
			}
		}

		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);

		objMv.setViewName("jsonView");

		return objMv;
	}
	
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

				rstMap = rmApprovalService.getContLimitDetail(objMap);

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
			log.error("selectCateList.do exception : ", e);
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
	
	@RequestMapping(value="/selectApproLimitListExcel.do", method=RequestMethod.POST)
    public View selectApproLimitListExcel(@RequestBody String strJsonParameter, Map<String, Object> objExcelMap) throws Exception {
        Map<String,Object>       objMap           = new HashMap<String, Object>();        
        List<Map<String,Object>> objExcelData = new ArrayList<Map<String, Object>>();
        
        try { 
            objMap = CommonUtils.queryStringToMap(strJsonParameter);
            objMap.put("intPageStart", CommonConstants.EXCEL_PAGE_START_SIZE);
            objMap.put("intPageEnd",   CommonConstants.EXCEL_PAGE_END_SIZE);
            String frDt = "";
        	 String toDt = ""; 
            frDt= (String)objMap.get( "fromdate" );
            frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
            objMap.put( "frDt", frDt );
            toDt= (String)objMap.get( "todate" );
            toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3" );
            objMap.put( "toDt", toDt );
            
            objExcelData = rmApprovalService.getContLimitList(objMap);
            
        } catch(Exception ex) {
            objExcelMap  = null;
            objExcelData = null;
            log.error("selectApproLimitListExcel.do exception : " , ex);
        } finally {
            objExcelMap.put("excelName", "Card_approve_limit_List");
            objExcelMap.put("excelData", objExcelData);
            objExcelMap.put("reqData",   objMap);
        }
        
        return new ApproLimitListExcelGenerator();
    }
	
	@RequestMapping(value = "/saveApproLimit.do", method = RequestMethod.POST)
	public ModelAndView saveApproLimit(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		Map<String, Object> rstMap = new HashMap<String, Object>();
		int intResultCode = 0;
		int intPageTotalCnt = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				
				paramMap.put("idCd", objMap.get("idCd"));
				paramMap.put("lmtId", objMap.get("lmtId"));
				paramMap.put("pmCd", objMap.get("payType"));
				paramMap.put("spmCd", objMap.get("payType"));
				paramMap.put("frDt", objMap.get("date"));
				paramMap.put("lmtTypeCd", objMap.get("detail"));
				paramMap.put("lmtCd", objMap.get("limitType"));
				paramMap.put("trxStCd", objMap.get("stateCd"));
				paramMap.put("blockFlg", objMap.get("tranCutFlg"));
				paramMap.put("amtType", objMap.get("cashLimit"));
				paramMap.put("cntType", objMap.get("countLimit"));
				paramMap.put("notiFlg", objMap.get("sendChk"));
				paramMap.put("notiTrgType", objMap.get("target"));
				paramMap.put("instmnDt", objMap.get("instMon"));
				paramMap.put("amtLmt", objMap.get("limit"));
				paramMap.put("cntLmt", objMap.get("count"));
				paramMap.put("notiPct", objMap.get("pac"));
				paramMap.put("maxSndCnt", objMap.get("maxCount"));
				paramMap.put("memo", objMap.get("regiReason"));
				paramMap.put("worker", objMap.get("worker"));
				paramMap.put("emailList", objMap.get("sendEmail"));
				paramMap.put("smsList", objMap.get("sendSms"));
				paramMap.put("seqNo", objMap.get("seqNo"));

				String registType = (String)objMap.get("registType");
				
				int dupCnt = rmApprovalService.getContLimitDulicateCnt(paramMap);
				
				if(dupCnt > 0){
					intResultCode = 9999;
					strResultMessage = "중복된 건이 존재합니다. 수정으로 처리해주시기 바랍니다.";
					objMv = CommonUtils.resultFail(objMv, strResultMessage);
					objMv.setViewName("jsonView");

					return objMv;
				}
				
				int insCnt = 0;
				
				if(registType.equals("1") == false)
					insCnt = rmApprovalService.insContLimit(paramMap);
				else
					insCnt = rmApprovalService.updateContLimit(paramMap);
				
				if(insCnt <= 0){
					intResultCode = 9999;
					strResultMessage = "등록에 실패하였습니다.";
					objMv = CommonUtils.resultFail(objMv, strResultMessage);
					objMv.setViewName("jsonView");

					return objMv;
				}
				
				if(registType.equals("1") == false)
					insCnt = rmApprovalService.insLimitNotiConfig(paramMap);
				else
					insCnt = rmApprovalService.upLimitNotiConfig(paramMap);
				
				if(insCnt <= 0){
					intResultCode = 9999;
					strResultMessage = "등록에 실패하였습니다.";
					objMv = CommonUtils.resultFail(objMv, strResultMessage);
					objMv.setViewName("jsonView");

					return objMv;
				}
				
				intResultCode = 0;
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("selectCateList.do exception : ", e);
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
