package egov.linkpay.ims.home;

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

import egov.linkpay.ims.common.common.CommonMessage;
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
@RequestMapping(value="/home/dashboard")
public class HomeController {
    Logger logger = Logger.getLogger(this.getClass());

    @Resource(name="homeService")
    private HomeService homeService;

    /**--------------------------------------------------
     * Method Name    : dashboard
     * Description    : View Dashboard
     * Author         : ymjo, 2015. 10. 2.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value = "/dashboard.do")
    public String dashboard(Model model) {
        return "/home/dashboard/dashboard";
    }

    /**--------------------------------------------------
     * Method Name    : selectDashBoardChart
     * Description    : 대시보드 차트 정보 조회
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardChart.do")
    public ModelAndView selectDashBoardChart(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                CommonUtils.initSearchRange(objMap);

                String trxType = objMap.get("TRX_TYPE").toString();

                /*objList = homeService.selectDashBoardChart(objMap);
                if(trxType.equals("1")){
                	objList = homeService.selectDashBoardChart(objMap);
                } else {
                	objList = homeService.selectTrxDashBoardChart(objMap);
                }*/
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardChart.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }

    /**--------------------------------------------------
     * Method Name    : selectDashBoardTopMerchantList
     * Description    : 거래 상위 가맹점 조회
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardTopMerchantList.do", method=RequestMethod.POST)
    public ModelAndView selectDashBoardTopMerchantList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                CommonUtils.initSearchRange(objMap);

                //objList = homeService.selectDashBoardTopMerchantList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardTopMerchantList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }

    /**--------------------------------------------------
     * Method Name    : selectDashBoardTopMerchantChart
     * Description    : 거래 상위 가맹점 차트
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardTopMerchantChart.do", method=RequestMethod.POST)
    public ModelAndView selectDashBoardTopMerchantChart(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                CommonUtils.initSearchRange(objMap);

                objList = homeService.selectDashBoardTopMerchantChart(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardTopMerchantChart.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }

    /**--------------------------------------------------
     * Method Name    : selectDashBoardPieChart
     * Description    : 대시보드 차트 정보 조회
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardPieChart.do")
    public ModelAndView selectDashBoardPieChart(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                objMap.put("TRANS_DT", CommonUtils.ConvertDate(DateFormat.YYYYMMDD, "", objMap.get("TRANS_DT")));

                CommonUtils.initSearchRange(objMap);

                objList = homeService.selectDashBoardPieChart(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardPieChart.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }

    /**--------------------------------------------------
     * Method Name    : selectDashBoardSummaryList
     * Description    : 대시보드 요약 리스트 조회(신용카드,가상계좌,...등)
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardSummaryList.do")
    public ModelAndView selectDashBoardSummaryList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                //CommonUtils.initSearchRange(objMap);

                objList = homeService.selectDashBoardSummaryList(objMap);

                objMv.addObject("LIST_TYPE", objMap.get("LIST_TYPE"));
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardSummaryList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
    
    
    /**--------------------------------------------------
     * Method Name    : selectTodayInput
     * Description    : 오늘의 입금액
     * Author         : yangjeongmo, 2018. 10. 04.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectTodayInput.do")
    public ModelAndView selectTodayInput(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                CommonUtils.initSearchRange(objMap);
 
                objList = homeService.selectTodayInput(objMap);
                objMv.addObject("DPST_AMT", objMap.get("DPST_AMT"));
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardSummaryList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
    
    
    /**--------------------------------------------------
     * Method Name    : selectDashBoardInDecreaseList
     * Description    : 대시보드 거래 급증/급감 현황
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardInDecreaseList.do")
    public ModelAndView selectDashBoardInDecreaseList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                CommonUtils.initSearchRange(objMap);

                //objList = homeService.selectDashBoardInDecreaseList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardInDecreaseList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectDashBoardInformList
     * Description    : 공지사항
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardInformList.do")
    public ModelAndView selectDashBoardInformList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                CommonUtils.initSearchRange(objMap);

                objList = homeService.selectDashBoardInformList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardInDecreaseList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
    
    /**--------------------------------------------------
     * Method Name    : selectDashBoardQnaList
     * Description    : 공지사항
     * Author         : yangjeongmo, 2015. 10. 29.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @RequestMapping(value="/selectDashBoardQnaList.do")
    public ModelAndView selectDashBoardQnaList(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView             objMv   = new ModelAndView();
        Map<String, Object>      objMap  = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();

        int    intResultCode    = 0;
        String strResultMessage = "";

        try {
            if (!CommonUtils.isNullorEmpty(strJsonParameter)) {
                objMap = CommonUtils.jsonToMap(strJsonParameter);

                CommonUtils.initSearchRange(objMap);

                objList = homeService.selectDashBoardQnaList(objMap);
            } else {
                intResultCode    = 9999;
                strResultMessage = CommonMessage.MSG_ERR_JSON_PARAMETER_EMPTY;
            }
        } catch(Exception ex) {
            intResultCode    = 9999;
            strResultMessage = CommonMessage.MSG_ERR_EXCEPTION;
            logger.debug("selectDashBoardInDecreaseList.do exception : " + ex.getMessage());
        }  finally {
            objMv = CommonUtils.resultList(objMv, objMap, objList, 0, intResultCode, strResultMessage);
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
}