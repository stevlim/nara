package egov.linkpay.ims.calcuMgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.calcuMgmt.service.CalcuMgmtService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;

/**
 * ------------------------------------------------------------ Package Name :
 * egov.linkpay.ims.home File Name : HomeController.java Description : Home
 * Controller(Dashboard) Author : ymjo, 2015. 10. 5. Modify History : Just
 * Created. ------------------------------------------------------------
 */
@Controller
@RequestMapping(value = "/calcuMgmt/calcuCard")
public class CalcuMgmtController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "calcuMgmtService")
	private CalcuMgmtService calcuMgmtService;

	@RequestMapping(value = "/depReport.do")
	public String depReport(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "62");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0060"));
		model.addAttribute("MER_TYPE", CommonDDLB.merchantType4(DDLBType.SEARCH));
		model.addAttribute("inOutChk", CommonDDLB.foreignCardTypeSet(DDLBType.SEARCH));
		model.addAttribute("CardCompanyList", CommonDDLB.cardCompanyList(DDLBType.SEARCH));
		return "/calcuMgmt/calcuCard/depReport";
	}

	@RequestMapping(value = "/selectDepReport.do", method = RequestMethod.POST)
	public ModelAndView selectDepReport(@RequestBody String strJsonParameter) throws Exception {
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

				boolean isPhaDt = (objMap.get("phaDt") != null ? (objMap.get("phaDt").equals("on") ? true : false)
						: false);
				boolean isDepDt = (objMap.get("depDt") != null ? (objMap.get("depDt").equals("on") ? true : false)
						: false);

				String frDt = "";
				String toDt = "";
				String searchType = "";
				if (isPhaDt) {
					frDt = (String) ((List) objMap.get("fromdate")).get(0);
					toDt = (String) ((List) objMap.get("todate")).get(0);
					searchType = "0";
				}
				if (isDepDt) {
					frDt = (String) ((List) objMap.get("fromdate")).get(1);
					toDt = (String) ((List) objMap.get("todate")).get(1);
					searchType = "1";
				}

				frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				objMap.put("frDt", frDt);
				objMap.put("toDt", toDt);
				objMap.put("searchType", searchType);

				rstMap = calcuMgmtService.getCardSettlmntLstCnt(objMap);
				objList = calcuMgmtService.getCardSettlmntLst(objMap);

				// test
//				Map<String, Object> testMap = new HashMap<String, Object>();
//				testMap.put("RNUM", 1);
//				testMap.put("MBS_NO", "123456");
//				testMap.put("ACQ_DT", "20170602");
//				testMap.put("OVER_FLG", 1);
//				testMap.put("CARD_CD", "1");
//				testMap.put("FN_NM", "삼성카드");
//				testMap.put("TR_AMT", 0);
//				testMap.put("ORG_AMT", 0);
//				testMap.put("ACQ_AMT", 0);
//				testMap.put("RE_AMT", 0);
//				testMap.put("RTN_AMT", 0);
//				testMap.put("RESR_AMT", 0);
//				testMap.put("ETC_AMT", 0);
//				testMap.put("DPST_AMT", 0);
//				testMap.put("EXP_AMT", 0);
//				testMap.put("GAP_AMT", 0);
//				testMap.put("DPST_DT", "20170602");
//				testMap.put("MBS_TYPE_CD", "1234");
//				testMap.put("CONFIRM_FLG", "1");
//				objList.add(testMap);
				
				if (objList.size() == 0) {
					intPageTotalCnt = 0;
//					intResultCode = 9999;
//					strResultMessage = "DATA NOT EXIST";
//					log.info("History조회- 기준정보 변경이력 조회-1-select fail");
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

	@RequestMapping(value = "/differMgmt.do")
	public String differMgmt(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "63");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0061"));
		model.addAttribute("CardCompanyList", CommonDDLB.cardCompanyList(DDLBType.SEARCH));
		return "/calcuMgmt/calcuCard/differMgmt";
	}

	@RequestMapping(value = "/depoRegChk.do")
	public String depoRegChk(Model model, CommonMap commonMap) throws Exception {
		model.addAttribute("MENU", commonMap.get("MENU_GRP_NO"));
		model.addAttribute("SUBMENU", "64");
		model.addAttribute("MENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
		model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage("IMS_MENU_SUB_0062"));
		model.addAttribute("inOutChk", CommonDDLB.foreignCardTypeSet(DDLBType.SEARCH));
		model.addAttribute("CardCompanyList", CommonDDLB.cardCompanyList(DDLBType.SEARCH));
		model.addAttribute("typeFlg", CommonDDLB.typeFlg(DDLBType.SEARCH));
		model.addAttribute("dateChk", CommonDDLB.dateChk());
		model.addAttribute("inOutChkReg", CommonDDLB.foreignCardTypeSet(DDLBType.EDIT));
		return "/calcuMgmt/calcuCard/depoRegChk";
	}
	
	@RequestMapping(value = "/receiveDeferSearch.do", method = RequestMethod.POST)
	public ModelAndView receiveDeferSearch(@RequestBody String strJsonParameter) throws Exception {
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

//				boolean isPhaDt = (objMap.get("phaDt") != null ? (objMap.get("phaDt").equals("on") ? true : false)
//						: false);
//				boolean isDepDt = (objMap.get("depDt") != null ? (objMap.get("depDt").equals("on") ? true : false)
//						: false);

				String frDt = "";
				String toDt = "";
				String searchType = "";
//				if (isPhaDt) {
//					frDt = (String) ((List) objMap.get("fromdate")).get(0);
//					toDt = (String) ((List) objMap.get("todate")).get(0);
//					searchType = "0";
//				}
//				if (isDepDt) {
//					frDt = (String) ((List) objMap.get("fromdate")).get(1);
//					toDt = (String) ((List) objMap.get("todate")).get(1);
//					searchType = "1";
//				}
				frDt = (String)objMap.get("fromdate");
				toDt = (String)objMap.get("todate");
				
				frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				objMap.put("frDt", frDt);
				objMap.put("toDt", toDt);
				objMap.put("searchType", searchType);

				rstMap = calcuMgmtService.getReceiveDeferLstCnt(objMap);
				objList = calcuMgmtService.getReceiveDeferLst(objMap);

				// test
//				Map<String, Object> testMap = new HashMap<String, Object>();
//				testMap.put("RNUM", 1);
//				testMap.put("CARD_NM", "삼성카드");
//				testMap.put("MBS_NO", "123456");
//				testMap.put("DPST_DT", "20170602");
//				testMap.put("ACQ_DT", "20170602");
//				testMap.put("AMT", 0);
//				testMap.put("TID", 0);
//				testMap.put("REASON_NM", "NO REASON");
//				testMap.put("ST_TYPE", "1234");
//				testMap.put("REG_DT", "20170602");
//				testMap.put("SEQ", 1);
//				testMap.put("OVER_FLG_NM", "국내");
//				testMap.put("OVER_FLG", "0");
//				testMap.put("MEMO", "MEADF");
//				objList.add(testMap);
				
				if (objList.size() == 0) {
					intPageTotalCnt = 0;
//					intResultCode = 9999;
//					strResultMessage = "DATA NOT EXIST";
//					log.info("History조회- 기준정보 변경이력 조회-1-select fail");
				}

				intPageTotalCnt = objList.size();
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("receiveDeferSearch.do exception : ", e);
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
	
	@RequestMapping(value = "/differenceAmtSearch.do", method = RequestMethod.POST)
	public ModelAndView differenceAmtSearch(@RequestBody String strJsonParameter) throws Exception {
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

				boolean isPhaDt = (objMap.get("phaDt") != null ? (objMap.get("phaDt").equals("on") ? true : false)
						: false);
				boolean isDepDt = (objMap.get("depDt") != null ? (objMap.get("depDt").equals("on") ? true : false)
						: false);

				String frDt = "";
				String toDt = "";
				String searchType = "";
				if (isPhaDt) {
					frDt = (String) ((List) objMap.get("fromdate")).get(0);
					toDt = (String) ((List) objMap.get("todate")).get(0);
					searchType = "0";
				}else{
					searchType = "1";
				}
				if (isDepDt) {
					frDt = (String) ((List) objMap.get("fromdate")).get(1);
					toDt = (String) ((List) objMap.get("todate")).get(1);
					searchType = "1";
				}

				frDt = frDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				toDt = toDt.replaceAll("(\\d+)-(\\d+)-(\\d+)", "$1$2$3");
				objMap.put("frDt", frDt);
				objMap.put("toDt", toDt);
				objMap.put("searchType", searchType);

				rstMap = calcuMgmtService.getCardSettlmntExpLstCnt(objMap);
				objList = calcuMgmtService.getCardSettlmntExpLst(objMap);

				// test
//				Map<String, Object> testMap = new HashMap<String, Object>();
//				testMap.put("RNUM", 1);
//				testMap.put("SEQ", 1);
//				testMap.put("CARD_NM", "삼성카드");
//				testMap.put("MBS_NO", "123456");
//				testMap.put("DPST_DT", "20170602");
//				testMap.put("ACQ_DT", "20170602");
//				testMap.put("AMT", 0);				
//				testMap.put("MEMO", "MEADF");
//				objList.add(testMap);
				
				if (objList.size() == 0) {
					intPageTotalCnt = 0;
//					intResultCode = 9999;
//					strResultMessage = "DATA NOT EXIST";
//					log.info("History조회- 기준정보 변경이력 조회-1-select fail");
				}

				intPageTotalCnt = objList.size();
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("differenceAmtSearch.do exception : ", e);
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
	
	@RequestMapping(value = "/differenceAmtDel.do", method = RequestMethod.POST)
	public ModelAndView differenceAmtDel(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		int intResultCode = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);

				int rst = calcuMgmtService.delAcqSettExp(objMap);
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("receiveDeferSearch.do exception : ", e);
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
	
	@RequestMapping(value = "/receiveDeferRegist.do", method = RequestMethod.POST)
	@Transactional
	public ModelAndView receiveDeferRegist(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		int intResultCode = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);
				
				for(int i=0; i < 8; i++){
					Map<String, Object> insMap = new HashMap<String, Object>();
					
					if(objMap.get("mbsNo_" + i) != null && objMap.get("mbsNo_" + i).equals("") == false){
						insMap.put("overFlgNm", objMap.get("overFlgNm_" + i));
						insMap.put("mbsNo", objMap.get("mbsNo_" + i));
						insMap.put("acqDt", objMap.get("acqDt_" + i));
						insMap.put("dpstDt", objMap.get("dpstDt_" + i));
						insMap.put("tid", objMap.get("tid_" + i));
						insMap.put("memo", objMap.get("memo_" + i));
						insMap.put("amt", objMap.get("amt_" + i));
						insMap.put("worker", objMap.get("worker"));
						int rst = calcuMgmtService.insCardSettlmntRD(insMap);
					}
					else continue;
				}
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("receiveDeferSearch.do exception : ", e);
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
	
	@RequestMapping(value = "/deferrenceRegist.do", method = RequestMethod.POST)
	@Transactional
	public ModelAndView deferrenceRegist(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		int intResultCode = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);
				
				for(int i=0; i < 8; i++){
					Map<String, Object> insMap = new HashMap<String, Object>();
					
					if(objMap.get("mbsNo_" + i) != null && objMap.get("mbsNo_" + i).equals("") == false){
						insMap.put("overFlgNm", objMap.get("overFlgNm_" + i));
						insMap.put("mbsNo", objMap.get("mbsNo_" + i));
						insMap.put("acqDt", objMap.get("acqDt_" + i));
						insMap.put("dpstDt", objMap.get("dpstDt_" + i));
						insMap.put("tid", objMap.get("tid_" + i));
						insMap.put("memo", objMap.get("memo_" + i));
						insMap.put("amt", objMap.get("amt_" + i));
						insMap.put("worker", objMap.get("worker"));
						int rst = calcuMgmtService.insCardSettlmntExp(insMap);
					}
					else continue;
				}
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("receiveDeferSearch.do exception : ", e);
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
	
	@RequestMapping(value = "/getReceiveDeferGetTIDData.do", method = RequestMethod.POST)
	public ModelAndView getReceiveDeferGetTIDData(@RequestBody String strJsonParameter) throws Exception {
		ModelAndView objMv = new ModelAndView();
		Map<String, Object> objMap = new HashMap<String, Object>();
		Map<String, Object> rstMap = new HashMap<String, Object>();
		int intResultCode = 0;
		String strResultMessage = "";

		try {
			if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
				objMap = CommonUtils.jsonToMap(strJsonParameter);
				String tid = (String)objMap.get("tid");
				rstMap = calcuMgmtService.getReceiveDeferGetTIDData(tid);
				
				rstMap = new HashMap<String, Object>();
				rstMap.put("index", (String)objMap.get("index"));
				
				//test
//				rstMap.put("MBS_NO", "123456");
//				rstMap.put("OVER_FLG", "1");
//				rstMap.put("OVER_FLG_NM", "국내");
//				rstMap.put("GOODS_AMT", 1000);
				
				objMv.addObject("data", rstMap);
			}
		} catch (Exception e) {
			intResultCode = 9999;
			log.error("receiveDeferSearch.do exception : ", e);
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