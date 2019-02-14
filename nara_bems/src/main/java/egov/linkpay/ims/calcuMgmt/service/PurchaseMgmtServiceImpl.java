package egov.linkpay.ims.calcuMgmt.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.BaseInfoRegistrationDAO;
import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;
import egov.linkpay.ims.calcuMgmt.dao.CalcuMgmtDAO;
import egov.linkpay.ims.calcuMgmt.dao.PurchaseMgmtDAO;
import egov.linkpay.ims.calcuMgmt.dao.ReportMgmtDAO;

@Service("purchaseMgmtService")
public class PurchaseMgmtServiceImpl implements PurchaseMgmtService
{
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name="purchaseMgmtDAO")
    private PurchaseMgmtDAO purchaseMgmtDAO;

	//매입검증 리스트 조회
	@Override
    public Map<String, Object> selectPurchaseVeriList(Map<String,Object> paramMap) throws Exception {
		List< Map<String,Object> > dataList = new ArrayList<Map<String,Object>>();
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try
		{
			//매입일 여부
			String acqDt = (String)purchaseMgmtDAO.selectAcqProcFlg(paramMap);

			if(acqDt.equals( "N" ))
			{
				resultMap.put( "resultCd", "9999" );
				resultMap.put( "resultMsg", "매입 처리일이 아닙니다" );
				return resultMap;
			}
			else
			{
				// 매입 대상일 가져오기
				dataList = purchaseMgmtDAO.selectAcqTransDay(paramMap);
				Map<String, Object> dayMap = dataList.get( 0 );
				paramMap.put( "frDt", dayMap.get( "FR_DT" )==null?"":dayMap.get( "FR_DT" ));
				paramMap.put( "toDt", dayMap.get( "TO_DT" )==null?"":dayMap.get( "TO_DT" ));

				// 거래내역 - 자동매입
				dataList = purchaseMgmtDAO.selectAcqVerifyTrans(paramMap);
				Map<String, Object> transMap = dataList.get( 0 );

				int iCntAutoKeyIn = ((BigDecimal) transMap.get("CNT_AUTO_KEYIN")).intValue();
				long iAmtAutoKeyIn = ((BigDecimal)transMap.get("AMT_AUTO_KEYIN")).longValue();
				int iCntAutoIsp = ((BigDecimal)transMap.get("CNT_AUTO_ISP")).intValue();
				long iAmtAutoIsp = ((BigDecimal)transMap.get("AMT_AUTO_ISP")).longValue();
				int iCntAutoVisa3D = ((BigDecimal)transMap.get("CNT_AUTO_VISA3D")).intValue();
				long iAmtAutoVisa3D = ((BigDecimal)transMap.get("AMT_AUTO_VISA3D")).longValue();
				int iCntAutoBillkeyin = ((BigDecimal)transMap.get("CNT_AUTO_BILL_KEYIN")).intValue();
				long iAmtAutoBillkeyin = ((BigDecimal)transMap.get("AMT_AUTO_BILL_KEYIN")).longValue();
				int iCntAutoUpop = ((BigDecimal)transMap.get("CNT_AUTO_UPOP")).intValue();
				long iAmtAutoUpop = ((BigDecimal)transMap.get("AMT_AUTO_UPOP")).longValue();

				int iCntReqKeyIn = ((BigDecimal)transMap.get("CNT_REQ_KEYIN")).intValue();
				long iAmtReqKeyIn = ((BigDecimal)transMap.get("AMT_REQ_KEYIN")).longValue();
				int iCntReqIsp = ((BigDecimal)transMap.get("CNT_REQ_ISP")).intValue();
				long iAmtReqIsp = ((BigDecimal)transMap.get("AMT_REQ_ISP")).longValue();
				int iCntReqVisa3D = ((BigDecimal)transMap.get("CNT_REQ_VISA3D")).intValue();
				long iAmtReqVisa3D = ((BigDecimal)transMap.get("AMT_REQ_BILL_KEYIN")).longValue();
				int iCntReqBillkeyin = ((BigDecimal)transMap.get("CNT_REQ_BILL_KEYIN")).intValue();
				long iAmtReqBillkeyin = ((BigDecimal)transMap.get("AMT_REQ_UPOP")).longValue();
				int iCntReqUpop = ((BigDecimal)transMap.get("CNT_REQ_UPOP")).intValue();
				long iAmtReqUpop = ((BigDecimal)transMap.get("AMT_REQ_UPOP")).longValue();

				int iCntCanKeyIn = ((BigDecimal)transMap.get("CNT_CAN_KEYIN")).intValue();
				long iAmtCanKeyIn = ((BigDecimal)transMap.get("AMT_CAN_KEYIN")).longValue();
				int iCntCanIsp = ((BigDecimal)transMap.get("CNT_CAN_ISP")).intValue();
				long iAmtCanIsp = ((BigDecimal)transMap.get("AMT_CAN_ISP")).longValue();
				int iCntCanVisa3D = ((BigDecimal)transMap.get("CNT_CAN_VISA3D")).intValue();
				long iAmtCanVisa3D = ((BigDecimal)transMap.get("AMT_CAN_VISA3D")).longValue();
				int iCntCanBillkeyin = ((BigDecimal)transMap.get("CNT_CAN_BILL_KEYIN")).intValue();
				long iAmtCanBillkeyin = ((BigDecimal)transMap.get("AMT_CAN_BILL_KEYIN")).longValue();
				int iCntCanUpop =((BigDecimal) transMap.get("CNT_CAN_UPOP")).intValue();
				long iAmtCanUpop = ((BigDecimal)transMap.get("AMT_CAN_UPOP")).longValue();

				int iTransCntAppKeyIn = iCntAutoKeyIn + iCntReqKeyIn;
				transMap.put( "TRANS_CNT_APP_KEYIN", iTransCntAppKeyIn );
				long iTransAmtAppKeyIn = iAmtAutoKeyIn + iAmtReqKeyIn;
				transMap.put( "TRANS_AMT_APP_KEYIN", iTransCntAppKeyIn );
				int iTransCntCcKeyIn = iCntCanKeyIn;
				long iTransAmtCcKeyIn = iAmtCanKeyIn;

				int iTransCntAppIsp = iCntAutoIsp + iCntReqIsp;
				transMap.put( "TRANS_CNT_APP_ISP", iTransCntAppKeyIn );
				long iTransAmtAppIsp = iAmtAutoIsp + iAmtReqIsp;
				transMap.put( "TRANS_AMT_APP_ISP", iTransCntAppKeyIn );
				int iTransCntCcIsp = iCntCanIsp;
				long iTransAmtCcIsp = iAmtCanIsp;

				int iTransCntAppVisa3D = iCntAutoVisa3D + iCntReqVisa3D;
				transMap.put( "TRANS_CNT_APP_VISA3D", iTransCntAppVisa3D );
				long iTransAmtAppVisa3D = iAmtAutoVisa3D + iAmtReqVisa3D;
				transMap.put( "TRANS_AMT_APP_VISA3D", iTransAmtAppVisa3D );
				int iTransCntCcVisa3D = iCntCanVisa3D;
				long iTransAmtCcVisa3D = iAmtCanVisa3D;

				int iTransCntAppBillkeyin = iCntAutoBillkeyin + iCntReqBillkeyin;
				transMap.put( "TRANS_CNT_APP_BILL_KEYIN", iTransCntAppBillkeyin );
				long iTransAmtAppBillkeyin = iAmtAutoBillkeyin + iAmtReqBillkeyin;
				transMap.put( "TRANS_AMT_APP_BILL_KEYIN", iTransAmtAppBillkeyin );
				int iTransCntCcBillkeyin = iCntCanBillkeyin;
				long iTransAmtCcBillkeyin = iAmtCanBillkeyin;

				int iTransCntAppUpop = iCntAutoUpop + iCntReqUpop;
				transMap.put( "TRANS_CNT_APP_UPOP", iTransCntAppUpop );
				long iTransAmtAppUpop = iAmtAutoUpop + iAmtReqUpop;
				transMap.put( "TRANS_AMT_APP_UPOP", iTransCntAppUpop );

				int iTransCntCcUpop = iCntCanUpop;
				long iTransAmtCcUpop = iAmtCanUpop;

				//합계
				int cntAutoTotal = iCntAutoKeyIn + iCntAutoIsp + iCntAutoVisa3D + iCntAutoBillkeyin + iCntAutoUpop;
				transMap.put( "CntAutoTotal", cntAutoTotal );
				long amtAutoTotal = iAmtAutoKeyIn + iAmtAutoIsp + iAmtAutoVisa3D + iAmtAutoBillkeyin + iAmtAutoUpop;
				transMap.put( "AmtAutoTotal", amtAutoTotal );
				int cntReqTotal = iCntReqKeyIn + iCntReqIsp + iCntReqVisa3D + iCntReqBillkeyin + iCntReqUpop;
				transMap.put( "CntReqTotal", cntReqTotal );
				long amtReqTotal = iAmtReqKeyIn + iAmtReqIsp + iAmtReqVisa3D + iAmtReqBillkeyin + iAmtReqUpop;
				transMap.put( "AmtReqTotal", amtReqTotal );
				int cntCanTotal = iCntCanKeyIn + iCntCanIsp + iCntCanVisa3D + iCntCanBillkeyin + iCntCanUpop;
				transMap.put( "CntCanTotal", cntCanTotal );
				long amtCanTotal = iAmtCanKeyIn + iAmtCanIsp + iAmtCanVisa3D + iAmtCanBillkeyin + iAmtCanUpop;
				transMap.put( "AmtCanTotal", amtCanTotal );
				int cntTransTotal = iTransCntAppKeyIn + iTransCntAppIsp + iTransCntAppVisa3D + iTransCntAppBillkeyin + iTransCntAppUpop;
				transMap.put( "CntTransTotal", cntTransTotal );
				long amtTransTotal =  iTransAmtAppKeyIn + iTransAmtAppIsp + iTransAmtAppVisa3D + iTransAmtAppBillkeyin + iTransAmtAppUpop;
				transMap.put( "AmtTransTotal", amtTransTotal );
				int cntTransCcTotal = iTransCntCcKeyIn + iTransCntCcIsp + iTransCntCcVisa3D + iTransCntCcBillkeyin + iTransCntCcUpop;
				transMap.put( "CntTransCcTotal", cntTransCcTotal );
				long amtTransCcTotal =  iTransAmtCcKeyIn + iTransAmtCcIsp + iTransAmtCcVisa3D + iTransAmtCcBillkeyin + iTransAmtCcUpop;
				transMap.put( "AmtTransCcTotal", amtTransCcTotal );

				resultMap.put( "transMap", transMap );
				// 기타내역 - 예외
				dataList = purchaseMgmtDAO.selectAcqException(paramMap);
				Map<String, Object> etcMap = dataList.get( 0 );

				int iCntAppInKeyIn = ((BigDecimal) etcMap.get("CNT_APP_IN_KEYIN")).intValue();
				long iAmtAppInKeyIn = ((BigDecimal)etcMap.get("AMT_APP_IN_KEYIN")).longValue();
				int iCntCcInKeyIn = ((BigDecimal) etcMap.get("CNT_CC_IN_KEYIN")).intValue();
				long iAmtCcInKeyIn = ((BigDecimal)etcMap.get("AMT_CC_IN_KEYIN")).longValue();

				int iCntAppOutKeyIn = ((BigDecimal) etcMap.get("CNT_APP_OUT_KEYIN")).intValue();
				long iAmtAppOutKeyIn = ((BigDecimal)etcMap.get("AMT_APP_OUT_KEYIN")).longValue();
				int iCntCcOutKeyIn = ((BigDecimal) etcMap.get("CNT_CC_OUT_KEYIN")).intValue();
				long iAmtCcOutKeyIn = ((BigDecimal)etcMap.get("AMT_CC_OUT_KEYIN")).longValue();

				int iCntAppInIsp = ((BigDecimal) etcMap.get("CNT_APP_IN_ISP")).intValue();
				long iAmtAppInIsp = ((BigDecimal)etcMap.get("AMT_APP_IN_ISP")).longValue();
				int iCntCcInIsp = ((BigDecimal) etcMap.get("CNT_CC_IN_ISP")).intValue();
				long iAmtCcInIsp = ((BigDecimal)etcMap.get("AMT_CC_IN_ISP")).longValue();

				int iCntAppOutIsp = ((BigDecimal) etcMap.get("CNT_APP_OUT_ISP")).intValue();
				long iAmtAppOutIsp = ((BigDecimal)etcMap.get("AMT_APP_OUT_ISP")).longValue();
				int iCntCcOutIsp = ((BigDecimal) etcMap.get("CNT_CC_OUT_ISP")).intValue();
				long iAmtCcOutIsp = ((BigDecimal)etcMap.get("AMT_CC_OUT_ISP")).longValue();

				int iCntAppInVisa3D = ((BigDecimal) etcMap.get("CNT_APP_IN_VISA3D")).intValue();
				long iAmtAppInVisa3D = ((BigDecimal)etcMap.get("AMT_APP_IN_VISA3D")).longValue();
			  	int iCntCcInVisa3D = ((BigDecimal) etcMap.get("CNT_CC_IN_VISA3D")).intValue();
			  	long iAmtCcInVisa3D = ((BigDecimal)etcMap.get("AMT_CC_IN_VISA3D")).longValue();

			  	int iCntAppOutVisa3D = ((BigDecimal) etcMap.get("CNT_APP_OUT_VISA3D")).intValue();
			  	long iAmtAppOutVisa3D = ((BigDecimal)etcMap.get("AMT_APP_OUT_VISA3D")).longValue();
			  	int iCntCcOutVisa3D = ((BigDecimal) etcMap.get("CNT_CC_OUT_VISA3D")).intValue();
			  	long iAmtCcOutVisa3D = ((BigDecimal)etcMap.get("AMT_CC_OUT_VISA3D")).longValue();

			  	int iCntAppInBillkeyin = ((BigDecimal) etcMap.get("CNT_APP_IN_BILL_KEYIN")).intValue();
			  	long iAmtAppInBillkeyin = ((BigDecimal)etcMap.get("AMT_APP_IN_BILL_KEYIN")).longValue();
			  	int iCntCcInBillkeyin = ((BigDecimal) etcMap.get("CNT_CC_IN_BILL_KEYIN")).intValue();
			  	long iAmtCcInBillkeyin = ((BigDecimal)etcMap.get("AMT_CC_IN_BILL_KEYIN")).longValue();

			  	int iCntAppOutBillkeyin = ((BigDecimal) etcMap.get("CNT_APP_OUT_BILL_KEYIN")).intValue();
			  	long iAmtAppOutBillkeyin = ((BigDecimal)etcMap.get("AMT_APP_OUT_BILL_KEYIN")).longValue();
			  	int iCntCcOutBillkeyin = ((BigDecimal) etcMap.get("CNT_CC_OUT_BILL_KEYIN")).intValue();
			  	long iAmtCcOutBillkeyin = ((BigDecimal)etcMap.get("AMT_CC_OUT_BILL_KEYIN")).longValue();

			  	int iCntAppInUpop = ((BigDecimal) etcMap.get("CNT_APP_IN_UPOP")).intValue();
			  	long iAmtAppInUpop = ((BigDecimal)etcMap.get("AMT_APP_IN_UPOP")).longValue();
			  	int iCntCcInUpop = ((BigDecimal) etcMap.get("CNT_CC_IN_UPOP")).intValue();
			  	long iAmtCcInUpop = ((BigDecimal)etcMap.get("AMT_CC_IN_UPOP")).longValue();

			  	int iCntAppOutUpop = ((BigDecimal) etcMap.get("CNT_APP_OUT_UPOP")).intValue();
			  	long iAmtAppOutUpop = ((BigDecimal)etcMap.get("AMT_APP_OUT_UPOP")).longValue();
			  	int iCntCcOutUpop = ((BigDecimal) etcMap.get("CNT_CC_OUT_UPOP")).intValue();
			  	long iAmtCcOutUpop = ((BigDecimal)etcMap.get("AMT_CC_OUT_UPOP")).longValue();

				// 기타내역 - 취소매입보류
				dataList = purchaseMgmtDAO.selectAcqCanResr(paramMap);
				Map<String, Object> canMap = dataList.get( 0 );

				int iCntHoldKeyIn = ((BigDecimal) canMap.get("CNT_HOLD_KEYIN")).intValue();
				long iAmtHoldKeyIn = ((BigDecimal)canMap.get("AMT_HOLD_KEYIN")).longValue();

				int iCntHoldIsp = ((BigDecimal) canMap.get("CNT_HOLD_ISP")).intValue();
				long iAmtHoldIsp = ((BigDecimal)canMap.get("AMT_HOLD_ISP")).longValue();

				int iCntHoldVisa3D = ((BigDecimal) canMap.get("CNT_HOLD_VISA3D")).intValue();
				long iAmtHoldVisa3D =((BigDecimal) canMap.get("AMT_HOLD_VISA3D")).longValue();

				int iCntHoldBillkeyin =((BigDecimal)  canMap.get("CNT_HOLD_BILL_KEYIN")).intValue();
				long iAmtHoldBillkeyin = ((BigDecimal)canMap.get("AMT_HOLD_BILL_KEYIN")).longValue();

				int iCntHoldUpop = ((BigDecimal) canMap.get("CNT_HOLD_UPOP")).intValue();
				long iAmtHoldUpop = ((BigDecimal)canMap.get("AMT_HOLD_UPOP")).longValue();

				// 재매입 내역
				dataList = purchaseMgmtDAO.selectAcqRetry(paramMap);
				Map<String, Object> reMap = dataList.get( 0 );
				int iCntReAppKeyIn = ((BigDecimal) reMap.get("CNT_RE_APP_KEYIN")).intValue();
				long iAmtReAppKeyIn = ((BigDecimal)reMap.get("AMT_RE_APP_KEYIN")).longValue();
				int iCntReCcKeyIn = ((BigDecimal) reMap.get("CNT_RE_CC_KEYIN")).intValue();
				long iAmtReCcKeyIn = ((BigDecimal)reMap.get("AMT_RE_CC_KEYIN")).longValue();

				int iCntReAppIsp = ((BigDecimal) reMap.get("CNT_RE_APP_ISP")).intValue();
				long iAmtReAppIsp = ((BigDecimal)reMap.get("AMT_RE_APP_ISP")).longValue();
				int iCntReCcIsp = ((BigDecimal) reMap.get("CNT_RE_CC_ISP")).intValue();
				long iAmtReCcIsp = ((BigDecimal)reMap.get("AMT_RE_CC_ISP")).longValue();

				int iCntReAppVisa3D =((BigDecimal)  reMap.get("CNT_RE_APP_VISA3D")).intValue();
				long iAmtReAppVisa3D = ((BigDecimal)reMap.get("AMT_RE_APP_VISA3D")).longValue();
				int iCntReCcVisa3D = ((BigDecimal) reMap.get("CNT_RE_CC_VISA3D")).intValue();
				long iAmtReCcVisa3D = ((BigDecimal)reMap.get("AMT_RE_CC_VISA3D")).longValue();

				int iCntReAppBillkeyin =((BigDecimal)  reMap.get("CNT_RE_APP_BILL_KEYIN")).intValue();
				long iAmtReAppBillkeyin = ((BigDecimal)reMap.get("AMT_RE_APP_BILL_KEYIN")).longValue();
				int iCntReCcBillkeyin = ((BigDecimal) reMap.get("CNT_RE_CC_BILL_KEYIN")).intValue();
				long iAmtReCcBillkeyin = ((BigDecimal)reMap.get("AMT_RE_CC_BILL_KEYIN")).longValue();

				int iCntReAppUpop = ((BigDecimal) reMap.get("CNT_RE_APP_UPOP")).intValue();
				long iAmtReAppUpop = ((BigDecimal)reMap.get("AMT_RE_APP_UPOP")).longValue();
				int iCntReCcUpop =((BigDecimal)  reMap.get("CNT_RE_CC_UPOP")).intValue();
				long iAmtReCcUpop = ((BigDecimal)reMap.get("AMT_RE_CC_UPOP")).longValue();

				//파라미터 셋팅

				// 기타 합계
				int iEtcCntAppKeyIn = iCntAppInKeyIn + iCntAppOutKeyIn + iCntReAppKeyIn;
				etcMap.put( "EtcCntAppKeyIn", iEtcCntAppKeyIn );
				long iEtcAmtAppKeyIn = iAmtAppInKeyIn + iAmtAppOutKeyIn + iAmtReAppKeyIn;
				etcMap.put( "EtcAmtAppKeyIn", iEtcAmtAppKeyIn );
				int iEtcCntCcKeyIn = iCntCcInKeyIn + iCntCcOutKeyIn + iCntHoldKeyIn + iCntReCcKeyIn;
				etcMap.put( "EtcCntCcKeyIn", iEtcCntCcKeyIn );
				long iEtcAmtCcKeyIn = iAmtCcInKeyIn + iAmtCcOutKeyIn + iAmtHoldKeyIn + iAmtReCcKeyIn;
				etcMap.put( "EtcAmtCcKeyIn", iEtcAmtCcKeyIn );

				int iEtcCntAppIsp = iCntAppInIsp + iCntAppOutIsp + iCntReAppIsp;
				etcMap.put( "EtcCntAppIsp", iEtcCntAppIsp );
				long iEtcAmtAppIsp = iAmtAppInIsp + iAmtAppOutIsp + iAmtReAppIsp;
				etcMap.put( "EtcAmtAppIsp", iEtcAmtAppIsp );
				int iEtcCntCcIsp = iCntCcInIsp + iCntCcOutIsp + iCntHoldIsp + iCntReCcIsp;
				etcMap.put( "EtcCntCcIsp", iEtcCntCcIsp );
				long iEtcAmtCcIsp = iAmtCcInIsp + iAmtCcOutIsp + iAmtHoldIsp + iAmtReCcIsp;
				etcMap.put( "EtcAmtCcIsp", iEtcAmtCcIsp );

				int iEtcCntAppVisa3D = iCntAppInVisa3D + iCntAppOutVisa3D + iCntReAppVisa3D;
				etcMap.put( "EtcCntAppVisa3D", iEtcCntAppVisa3D );
				long iEtcAmtAppVisa3D = iAmtAppInVisa3D + iAmtAppOutVisa3D + iAmtReAppVisa3D;
				etcMap.put( "EtcAmtAppVisa3D", iEtcAmtAppVisa3D );
				int iEtcCntCcVisa3D = iCntCcInVisa3D + iCntCcOutVisa3D + iCntHoldVisa3D + iCntReCcVisa3D;
				etcMap.put( "EtcCntCcVisa3D", iEtcCntCcVisa3D );
				long iEtcAmtCcVisa3D = iAmtCcInVisa3D + iAmtCcOutVisa3D + iAmtHoldVisa3D + iAmtReCcVisa3D;
				etcMap.put( "EtcAmtCcVisa3D", iEtcAmtCcVisa3D );

				int iEtcCntAppBillkeyin = iCntAppInBillkeyin + iCntAppOutBillkeyin + iCntReAppBillkeyin;
				etcMap.put( "EtcCntAppBillkeyin", iEtcCntAppBillkeyin );
				long iEtcAmtAppBillkeyin = iAmtAppInBillkeyin + iAmtAppOutBillkeyin + iAmtReAppBillkeyin;
				etcMap.put( "EtcAmtAppBillkeyin", iEtcAmtAppBillkeyin );
				int iEtcCntCcBillkeyin = iCntCcInBillkeyin + iCntCcOutBillkeyin + iCntHoldBillkeyin + iCntReCcBillkeyin;
				etcMap.put( "EtcCntCcBillkeyin", iEtcCntCcBillkeyin );
				long iEtcAmtCcBillkeyin = iAmtCcInBillkeyin + iAmtCcOutBillkeyin + iAmtHoldBillkeyin + iAmtReCcBillkeyin;
				etcMap.put( "EtcAmtCcBillkeyin", iEtcAmtCcBillkeyin );

				int iEtcCntAppUpop = iCntAppInUpop + iCntAppOutUpop + iCntReAppUpop;
				etcMap.put( "EtcCntAppUpop", iEtcCntAppUpop );
				long iEtcAmtAppUpop = iAmtAppInUpop + iAmtAppOutUpop + iAmtReAppUpop;
				etcMap.put( "EtcAmtAppUpop", iEtcAmtAppUpop );
				int iEtcCntCcUpop = iCntCcInUpop + iCntCcOutUpop + iCntHoldUpop + iCntReCcUpop;
				etcMap.put( "EtcCntCcUpop", iEtcCntCcUpop );
				long iEtcAmtCcUpop = iAmtCcInUpop + iAmtCcOutUpop + iAmtHoldUpop + iAmtReCcUpop;
				etcMap.put( "EtcAmtCcUpop", iEtcAmtCcUpop );

				//기타내역 합계
				int cntAppInTotal = iCntAppInKeyIn + iCntAppInIsp + iCntAppInVisa3D + iCntAppInBillkeyin + iCntAppInUpop;
				long amtAppInTotal = iAmtAppInKeyIn + iAmtAppInIsp + iAmtAppInVisa3D + iAmtAppInBillkeyin + iAmtAppInUpop;
				int cntCcInTotal = iCntCcInKeyIn + iCntCcInIsp + iCntCcInVisa3D + iCntCcInBillkeyin + iCntCcInUpop;
				long amtCcInTotal = iAmtCcInKeyIn + iAmtCcInIsp + iAmtCcInVisa3D + iAmtCcInBillkeyin + iAmtCcInUpop;
				int cntAppOutTotal = iCntAppOutKeyIn + iCntAppOutIsp + iCntAppOutVisa3D + iCntAppOutBillkeyin + iCntAppOutUpop;
				long amtAppOutTotal = iAmtAppOutKeyIn + iAmtAppOutIsp + iAmtAppOutVisa3D + iAmtAppOutBillkeyin + iAmtAppOutUpop;
				int cntCcOutTotal = iCntCcOutKeyIn + iCntCcOutIsp + iCntCcOutVisa3D + iCntCcOutBillkeyin + iCntCcOutUpop;
				long amtCcOutTotal = iAmtCcOutKeyIn + iAmtCcOutIsp + iAmtCcOutVisa3D + iAmtCcOutBillkeyin + iAmtCcOutUpop;

				int cntReAppTotal = iCntReAppKeyIn + iCntReAppIsp + iCntReAppVisa3D + iCntReAppBillkeyin + iCntReAppUpop;
				long amtReAppTotal = iAmtReAppKeyIn + iAmtReAppIsp + iAmtReAppVisa3D + iAmtReAppBillkeyin + iAmtReAppUpop;
				int cntReCcTotal = iCntReCcKeyIn + iCntReCcIsp + iCntReCcVisa3D + iCntReCcBillkeyin + iCntReCcUpop;
				long amtReCcTotal = iAmtReCcKeyIn + iAmtReCcIsp + iAmtReCcVisa3D + iAmtReCcBillkeyin + iAmtReCcUpop;
				int cntHoldTotal = iCntHoldKeyIn + iCntHoldIsp + iCntHoldVisa3D + iCntHoldBillkeyin + iCntHoldUpop;
				long amtHoldTotal = iAmtHoldKeyIn + iAmtHoldIsp + iAmtHoldVisa3D + iAmtHoldBillkeyin + iAmtHoldUpop;
				int cntEtcAppTotal = iEtcCntAppKeyIn + iEtcCntAppIsp + iEtcCntAppVisa3D + iEtcCntAppBillkeyin + iEtcCntAppUpop;
				long amtEtcAppTotal = iEtcAmtAppKeyIn + iEtcAmtAppIsp + iEtcAmtAppVisa3D + iEtcAmtAppBillkeyin + iEtcAmtAppUpop;
				int cntEtcCcTotal = iEtcCntCcKeyIn + iEtcCntCcIsp + iEtcCntCcVisa3D + iEtcCntCcBillkeyin + iEtcCntCcUpop;
				long amtEtcCcTotal = iEtcAmtCcKeyIn + iEtcAmtCcIsp + iEtcAmtCcVisa3D + iEtcAmtCcBillkeyin + iEtcAmtCcUpop;

				// 매입대상 내역
				int iSrcCntAppKeyIn = iTransCntAppKeyIn + iEtcCntAppKeyIn;
				etcMap.put( "SrcCntAppKeyIn", iSrcCntAppKeyIn );
				long iSrcAmtAppKeyIn = iTransAmtAppKeyIn + iEtcAmtAppKeyIn;
				etcMap.put( "SrcAmtAppKeyIn", iSrcAmtAppKeyIn );
				int iSrcCntCcKeyIn = iTransCntCcKeyIn + iEtcCntCcKeyIn;
				etcMap.put( "SrcCntCcKeyIn", iSrcCntCcKeyIn );
				long iSrcAmtCcKeyIn = iTransAmtCcKeyIn + iEtcAmtCcKeyIn;
				etcMap.put( "SrcAmtCcKeyIn", iSrcAmtCcKeyIn );

				int iSrcCntAppIsp = iTransCntAppIsp + iEtcCntAppIsp;
				etcMap.put( "SrcCntAppIsp", iSrcCntAppIsp );
				long iSrcAmtAppIsp = iTransAmtAppIsp + iEtcAmtAppIsp;
				etcMap.put( "SrcAmtAppIsp", iSrcAmtAppIsp );
				int iSrcCntCcIsp = iTransCntCcIsp + iEtcCntCcIsp;
				etcMap.put( "SrcCntCcIsp", iSrcCntCcIsp );
				long iSrcAmtCcIsp = iTransAmtCcIsp + iEtcAmtCcIsp;
				etcMap.put( "SrcAmtCcIsp", iSrcAmtCcIsp );

				int iSrcCntAppVisa3D = iTransCntAppVisa3D + iEtcCntAppVisa3D;
				etcMap.put( "SrcCntAppVisa3d", iSrcCntAppVisa3D );
				long iSrcAmtAppVisa3D = iTransAmtAppVisa3D + iEtcAmtAppVisa3D;
				etcMap.put( "SrcAmtAppVisa3d", iSrcAmtAppVisa3D );
				int iSrcCntCcVisa3D = iTransCntCcVisa3D + iEtcCntCcVisa3D;
				etcMap.put( "SrcCntCcVisa3d", iSrcCntCcVisa3D );
				long iSrcAmtCcVisa3D = iTransAmtCcVisa3D + iEtcAmtCcVisa3D;
				etcMap.put( "SrcAmtCcVisa3d", iSrcAmtCcVisa3D );

				int iSrcCntAppBillkeyin = iTransCntAppBillkeyin + iEtcCntAppBillkeyin;
				etcMap.put( "SrcCntAppBillKeyin", iSrcCntAppBillkeyin );
				long iSrcAmtAppBillkeyin = iTransAmtAppBillkeyin + iEtcAmtAppBillkeyin;
				etcMap.put( "SrcAmtAppBillKeyin", iSrcAmtAppBillkeyin );
				int iSrcCntCcBillkeyin = iTransCntCcBillkeyin + iEtcCntCcBillkeyin;
				etcMap.put( "SrcCntCcBillKeyin", iSrcCntCcBillkeyin );
				long iSrcAmtCcBillkeyin = iTransAmtCcBillkeyin + iEtcAmtCcBillkeyin;
				etcMap.put( "SrcAmtCcBillKeyin", iSrcAmtCcBillkeyin );

				int iSrcCntAppUpop = iTransCntAppUpop + iEtcCntAppUpop;
				etcMap.put( "SrcCntAppUpop", iSrcCntAppUpop );
				long iSrcAmtAppUpop = iTransAmtAppUpop + iEtcAmtAppUpop;
				etcMap.put( "SrcAmtAppUpop", iSrcAmtAppUpop );
				int iSrcCntCcUpop = iTransCntCcUpop + iEtcCntCcUpop;
				etcMap.put( "SrcCntCcUpop", iSrcCntCcUpop );
				long iSrcAmtCcUpop = iTransAmtCcUpop + iEtcAmtCcUpop;
				etcMap.put( "SrcAmtCcUpop", iSrcAmtCcUpop );

				// 매입생성 내역
				dataList = purchaseMgmtDAO.selectAcqList(paramMap);
				Map<String, Object> listMap = dataList.get( 0 );

				int iAcquCntAppKeyIn = ((BigDecimal) listMap.get("CNT_APP_ACQ_KEYIN")).intValue();
				long iAcquAmtAppKeyIn = ((BigDecimal)listMap.get("AMT_APP_ACQ_KEYIN")).longValue();
				int iAcquCntCcKeyIn = ((BigDecimal) listMap.get("CNT_CC_ACQ_KEYIN")).intValue();
				long iAcquAmtCcKeyIn = ((BigDecimal)listMap.get("AMT_CC_ACQ_KEYIN")).longValue();

				int cntAcqCcKeyIn = iAcquCntAppKeyIn-iSrcCntCcKeyIn;
				if(cntAcqCcKeyIn != 0)
					listMap.put( "CntAcqCcKeyIn", cntAcqCcKeyIn );
				else
					listMap.put( "CntAcqCcKeyIn", 0 );

				long amtAcqCcKeyIn = iAcquAmtAppKeyIn-iSrcAmtCcKeyIn;
				if(amtAcqCcKeyIn != 0)
					listMap.put( "AmtAcqCcKeyIn", amtAcqCcKeyIn );
				else
					listMap.put( "AmtAcqCcKeyIn", 0 );

				int cntAppKeyIn = iAcquCntAppKeyIn - iSrcCntAppKeyIn;
				if(cntAppKeyIn != 0)
					listMap.put( "CntAppKeyIn", cntAppKeyIn );
				else
					listMap.put( "CntAppKeyIn", 0 );

				long amtAppKeyIn = iAcquAmtAppKeyIn - iSrcAmtAppKeyIn;
				if(amtAppKeyIn  != 0)
					listMap.put( "AmtAppKeyIn", amtAppKeyIn );
				else
					listMap.put( "AmtAppKeyIn", 0 );

				int iAcquCntAppIsp = ((BigDecimal) listMap.get("CNT_APP_ACQ_ISP")).intValue();
				long iAcquAmtAppIsp =((BigDecimal) listMap.get("AMT_APP_ACQ_ISP")).longValue();
				int iAcquCntCcIsp = ((BigDecimal) listMap.get("CNT_CC_ACQ_ISP")).intValue();
				long iAcquAmtCcIsp = ((BigDecimal)listMap.get("AMT_CC_ACQ_ISP")).longValue();

				int acqCntAppIsp = iAcquCntAppIsp - iSrcCntAppIsp;
				if(acqCntAppIsp  != 0)
					listMap.put( "AcqCntAppIsp", acqCntAppIsp );
				else
					listMap.put( "AcqCntAppIsp", 0 );

				long acqAmtAppIsp = iAcquAmtAppIsp - iSrcAmtAppIsp;
				if(acqAmtAppIsp  != 0)
					listMap.put( "AcqAmtAppIsp", acqAmtAppIsp );
				else
					listMap.put( "AcqAmtAppIsp", 0 );

				int acqCntCcIsp = iAcquCntCcIsp - iSrcCntCcIsp;
				if(acqCntCcIsp  != 0)
					listMap.put( "AcqCntCcIsp", acqCntCcIsp );
				else
					listMap.put( "AcqCntCcIsp", 0 );

				long acqAmtCcIsp = iAcquAmtCcIsp - iSrcAmtCcIsp;
				if(acqAmtCcIsp  != 0)
					listMap.put( "AcqAmtCcIsp", acqAmtCcIsp );
				else
					listMap.put( "AcqAmtCcIsp", 0 );


				int iAcquCntAppVisa3D =((BigDecimal)  listMap.get("CNT_APP_ACQ_VISA3D")).intValue();
				long iAcquAmtAppVisa3D = ((BigDecimal)listMap.get("AMT_APP_ACQ_VISA3D")).longValue();
				int iAcquCntCcVisa3D = ((BigDecimal) listMap.get("CNT_CC_ACQ_VISA3D")).intValue();
				long iAcquAmtCcVisa3D = ((BigDecimal)listMap.get("AMT_CC_ACQ_VISA3D")).longValue();

				int acqCntAppVisa3d = iAcquCntAppVisa3D - iSrcCntAppVisa3D;
				if(acqCntAppVisa3d  != 0)
					listMap.put( "AcqCntAppVisa3d", acqCntAppVisa3d );
				else
					listMap.put( "AcqCntAppVisa3d", 0 );

				long acqAmtAppVisa3d = iAcquAmtAppVisa3D - iSrcAmtAppVisa3D;
				if(acqAmtAppVisa3d  != 0)
					listMap.put( "AcqAmtAppVisa3d", acqAmtAppVisa3d );
				else
					listMap.put( "AcqAmtAppVisa3d", 0 );

				int acqCntCcVisa3d = iAcquCntCcVisa3D - iSrcCntCcVisa3D;
				if(acqCntCcVisa3d  != 0)
					listMap.put( "AcqCntCcVisa3d", acqCntCcVisa3d );
				else
					listMap.put( "AcqCntCcVisa3d", 0 );

				long acqAmtCcVisa3d = iAcquAmtCcVisa3D - iSrcAmtCcVisa3D;
				if(acqAmtCcVisa3d  != 0)
					listMap.put( "AcqAmtCcVisa3d", acqAmtCcVisa3d );
				else
					listMap.put( "AcqAmtCcVisa3d", 0 );

				int iAcquCntAppBillkeyin = ((BigDecimal) listMap.get("CNT_APP_ACQ_BILL_KEYIN")).intValue();
				long iAcquAmtAppBillkeyin = ((BigDecimal)listMap.get("AMT_APP_ACQ_BILL_KEYIN")).longValue();
				int iAcquCntCcBillkeyin = ((BigDecimal) listMap.get("CNT_CC_ACQ_BILL_KEYIN")).intValue();
				long iAcquAmtCcBillkeyin = ((BigDecimal)listMap.get("AMT_CC_ACQ_BILL_KEYIN")).longValue();

				int acqCntAppBillKeyIn = iAcquCntAppBillkeyin - iSrcCntAppBillkeyin;
				if(acqCntAppBillKeyIn  != 0)
					listMap.put( "AcqCntAppBillKeyIn", acqCntAppBillKeyIn );
				else
					listMap.put( "AcqCntAppBillKeyIn", 0 );

				long acqAmtAppBillKeyIn = iAcquAmtAppBillkeyin - iSrcAmtAppBillkeyin;
				if(acqAmtAppBillKeyIn  != 0)
					listMap.put( "AcqAmtAppBillKeyIn", acqAmtAppBillKeyIn );
				else
					listMap.put( "AcqAmtAppBillKeyIn", 0 );

				int acqCntCcBillKeyIn = iAcquCntCcBillkeyin - iSrcCntCcBillkeyin;
				if(acqCntCcBillKeyIn  != 0)
					listMap.put( "AcqCntCcBillKeyIn", acqCntCcBillKeyIn );
				else
					listMap.put( "AcqCntCcBillKeyIn", 0 );

				long acqAmtCcBillKeyIn = iAcquAmtCcBillkeyin - iSrcAmtCcBillkeyin;
				if(acqAmtCcBillKeyIn  != 0)
					listMap.put( "AcqAmtCcBillKeyIn", acqAmtCcBillKeyIn );
				else
					listMap.put( "AcqAmtCcBillKeyIn", 0 );

				int iAcquCntAppUpop = ((BigDecimal) listMap.get("CNT_APP_ACQ_UPOP")).intValue();
				long iAcquAmtAppUpop =((BigDecimal) listMap.get("AMT_APP_ACQ_UPOP")).longValue();
				int iAcquCntCcUpop = ((BigDecimal) listMap.get("CNT_CC_ACQ_UPOP")).intValue();
				long iAcquAmtCcUpop =((BigDecimal) listMap.get("AMT_CC_ACQ_UPOP")).longValue();

				int acqCntAppUpop= iAcquCntAppUpop - iSrcCntAppUpop;
				if(acqCntAppUpop  != 0)
					listMap.put( "AcqCntAppUpop", acqCntAppUpop );
				else
					listMap.put( "AcqCntAppUpop", 0 );

				long acqAmtAppUpop = iAcquAmtAppUpop - iSrcAmtAppUpop;
				if(acqAmtAppUpop  != 0)
					listMap.put( "AcqAmtAppUpop", acqAmtAppUpop );
				else
					listMap.put( "AcqAmtAppUpop", 0 );

				int acqCntCcUpop = iAcquCntCcUpop - iSrcCntCcUpop;
				if(acqCntCcUpop  != 0)
					listMap.put( "AcqCntCcUpop", acqCntCcUpop );
				else
					listMap.put( "AcqCntCcUpop", 0 );

				long acqAmtCcUpop = iAcquAmtCcUpop - iSrcAmtCcUpop;
				if(acqAmtCcUpop  != 0)
					listMap.put( "AcqAmtCcUpop", acqAmtCcUpop );
				else
					listMap.put( "AcqAmtCcUpop", 0 );

				int srcCntApp = iSrcCntAppKeyIn + iSrcCntAppIsp + iSrcCntAppVisa3D + iSrcCntAppBillkeyin + iSrcCntAppUpop;
				listMap.put( "SrcCntApp", srcCntApp );
				long srcAmtApp = iSrcAmtAppKeyIn + iSrcAmtAppIsp + iSrcAmtAppVisa3D + iSrcAmtAppBillkeyin + iSrcAmtAppUpop;
				listMap.put( "SrcAmtApp", srcAmtApp );
				int srcCntCc = iSrcCntCcKeyIn + iSrcCntCcIsp + iSrcCntCcVisa3D + iSrcCntCcBillkeyin + iSrcCntCcUpop;
				listMap.put( "SrcCntCc", srcCntCc );
				long srcAmtCc = iSrcAmtCcKeyIn + iSrcAmtCcIsp + iSrcAmtCcVisa3D + iSrcAmtCcBillkeyin + iSrcAmtCcUpop;
				listMap.put( "SrcAmtCc", srcAmtCc );
				int acqCntApp = iAcquCntAppKeyIn + iAcquCntAppIsp + iAcquCntAppVisa3D + iAcquCntAppBillkeyin + iAcquCntAppUpop;
				listMap.put( "AcqCntApp", acqCntApp );
				long acqAmtApp = iAcquAmtAppKeyIn + iAcquAmtAppIsp + iAcquAmtAppVisa3D + iAcquAmtAppBillkeyin + iAcquAmtAppUpop;
				listMap.put( "AcqAmtApp", acqAmtApp );
				int acqCntCcApp = iAcquCntCcKeyIn + iAcquCntCcIsp + iAcquCntCcVisa3D + iAcquCntCcBillkeyin + iAcquCntCcUpop;
				listMap.put( "AcqCntCcApp", acqCntCcApp );
				long acqAmtCcApp = iAcquAmtCcKeyIn + iAcquAmtCcIsp + iAcquAmtCcVisa3D + iAcquAmtCcBillkeyin + iAcquAmtCcUpop;
				listMap.put( "AcqAmtCcApp", acqAmtCcApp );
				//매입생성 내역 및 차이-승인갯수합계
				int cntAppTotal = iAcquCntAppKeyIn + iAcquCntAppIsp + iAcquCntAppVisa3D + iAcquCntAppBillkeyin + iAcquCntAppUpop - iSrcCntAppKeyIn - iSrcCntAppIsp - iSrcCntAppVisa3D - iSrcCntAppBillkeyin - iSrcCntAppUpop;
				if(cntAppTotal!= 0)
					listMap.put( "CntAppTotal", cntAppTotal );
				else
					listMap.put( "CntAppTotal", 0);
				//매입생성 내역 및 차이-승인금액합계
				long amtAppTotal = iAcquAmtAppKeyIn + iAcquAmtAppIsp + iAcquAmtAppVisa3D + iAcquAmtAppBillkeyin + iAcquAmtAppUpop - iSrcAmtAppKeyIn - iSrcAmtAppIsp - iSrcAmtAppVisa3D - iSrcAmtAppBillkeyin - iSrcAmtAppUpop;
				if(amtAppTotal!= 0)
					listMap.put( "AmtAppTotal", amtAppTotal );
				else
					listMap.put( "AmtAppTotal", 0);
				//매입생성 내역 및 차이-취소갯수합계
				int cntCcTotal = iAcquCntCcKeyIn + iAcquCntCcIsp + iAcquCntCcVisa3D + iAcquCntCcBillkeyin + iAcquCntCcUpop - iSrcCntCcKeyIn - iSrcCntCcIsp - iSrcCntCcVisa3D - iSrcCntCcBillkeyin - iSrcCntCcUpop;
				if(cntCcTotal!= 0)
					listMap.put( "CntCcTotal", cntCcTotal );
				else
					listMap.put( "CntCcTotal", 0);
				//매입생성 내역 및 차이-취소금액합계
				long amtCcTotal = iAcquAmtCcKeyIn + iAcquAmtCcIsp + iAcquAmtCcVisa3D + iAcquAmtCcBillkeyin + iAcquAmtCcUpop - iSrcAmtCcKeyIn - iSrcAmtCcIsp - iSrcAmtCcVisa3D - iSrcAmtCcBillkeyin - iSrcAmtCcUpop;
				if(amtCcTotal!= 0)
					listMap.put( "AmtCcTotal", amtCcTotal );
				else
					listMap.put( "AmtCcTotal", 0);

				// 밴사별 생성내역
				dataList = purchaseMgmtDAO.selectAcqCntOfVan(paramMap);
				Map<String, Object> vanMap = dataList.get( 0 );

				int iJTNETCnt = ((BigDecimal) vanMap.get("JTNET_CNT")).intValue();
				long iJTNETAmt = ((BigDecimal)vanMap.get("JTNET_AMT")).longValue();
				int iJTNETSendCnt =  Integer.parseInt( vanMap.get("JTNET_SEND_CNT").toString() );
			  	int iJTNETGap = iJTNETSendCnt - iJTNETCnt;
			  	vanMap.put( "JTNET_GAP", iJTNETGap );
			  	resultMap.put( "etcMap", etcMap );
			  	resultMap.put( "canMap", canMap );
				resultMap.put( "reMap", reMap );
			  	resultMap.put( "listMap", listMap );
			  	resultMap.put( "vanMap", vanMap );
			}
		}
		catch(Exception e)
		{
			log.error( "Exception error " ,e  );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Fail " );
			return resultMap;
		}

		resultMap.put( "resultCd", "0000" );
		resultMap.put( "resultMsg", "success" );

        return resultMap;
    }
	//매입검증 차이건 리스트 조회
	@Override
    public  List<Map<String, Object>> selectAcqGap(Map<String,Object> paramMap) throws Exception {
		List<Map<String, Object>>  dataList = new ArrayList<Map<String,Object>>();
		// 매입 대상일 가져오기
		dataList = purchaseMgmtDAO.selectAcqTransDay(paramMap);
		Map<String, Object> dayMap = dataList.get( 0 );
		paramMap.put( "frDt", dayMap.get( "FR_DT" )==null?"":dayMap.get( "FR_DT" ));
		paramMap.put( "toDt", dayMap.get( "TO_DT" )==null?"":dayMap.get( "TO_DT" ));

		return purchaseMgmtDAO.selectAcqGap(paramMap);
	}
	public  int selectAcqGapTotal(Map<String,Object> paramMap) throws Exception {
		return purchaseMgmtDAO.selectAcqGapTotal(paramMap);
	}
	//매입결과  tid별 리스트 조회
	@Override
    public  List<Map<String, Object>> selectAcqTidRsltList(Map<String,Object> paramMap) throws Exception {
		return purchaseMgmtDAO.selectAcqTidRsltList(paramMap);
	}
	public  int selectAcqTidRsltListTotal(Map<String,Object> paramMap) throws Exception {
		return purchaseMgmtDAO.selectAcqTidRsltListTotal(paramMap);
	}
	//매입결과 정보 조회
	@Override
    public  Map<String, Object> selectAcqTidRsltInfo(Map<String,Object> paramMap) throws Exception {
		List<Map<String,Object>> dataList = new ArrayList<Map<String,Object>>();
		Map<String, Object> dataMap = new HashMap<String,Object>();

		dataList = purchaseMgmtDAO.selectAcqTidRsltInfo(paramMap);

		dataMap = dataList.get( 0 );

		int totCnt = ((BigDecimal)dataMap.get( "APPCNT" )).intValue() + ((BigDecimal)dataMap.get( "CCCNT" )).intValue();
		int totAmt = ((BigDecimal)dataMap.get( "APPAMT" )).intValue() + ((BigDecimal)dataMap.get( "CCAMT" )).intValue();
		dataMap.put( "TOTCNT", totCnt );
		dataMap.put( "TOTAMT", totAmt );
		return dataMap;
	}
	//매입결과  결과 리스트 조회
	@Override
    public  List<Map<String, Object>> selectAcqRsltList(Map<String,Object> paramMap) throws Exception {
		return purchaseMgmtDAO.selectAcqRsltList(paramMap);
	}
	public  int selectAcqRsltListTotal(Map<String,Object> paramMap) throws Exception {
		return purchaseMgmtDAO.selectAcqRsltListTotal(paramMap);
	}
	//반송조회/처리 리스트 조회
	@Override
    public  List<Map<String, Object>> selectAcqRetList(Map<String,Object> paramMap) throws Exception {
		return purchaseMgmtDAO.selectAcqRetList(paramMap);
	}
	public  int selectAcqRetListTotal(Map<String,Object> paramMap) throws Exception {
		return purchaseMgmtDAO.selectAcqRetListTotal(paramMap);
	}
	//반송조회/처리 update
	@Override
    public  Map<String, Object> updateRetProc(Map<String,Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		List<Map<String, Object> > dataList = new ArrayList<Map<String, Object> >();
		int cnt = 0;
		int totCnt = 0;
		try
		{
			String [] strChkProc = ( String[] ) paramMap.get( "chkProc" );
			if(strChkProc == null)
			{
				resultMap.put( "resultCd", "9999" );
				resultMap.put( "resultMsg", "선택된 항목이 없습니다." );
				return resultMap;
			}
			else
			{
				for(int i=0; i<strChkProc.length;i++)
				{
					Map<String,Object> dataMap = new HashMap<String,Object>();
					dataMap.put( "seq", strChkProc[i] );
					dataMap.put( "procCd", paramMap.get( "procCd" ) );
					dataMap.put( "procDesc", paramMap.get( "procDesc" ));
					dataMap.put( "appDepReport", paramMap.get( "appDepReport" ) );
					dataMap.put( "worker", paramMap.get( "worker" ) );

					cnt = purchaseMgmtDAO.updateRetProc(paramMap);

					if(dataMap.get( "procCd" ).equals( "01" ))
					{
						// 재매입일 경우 재매입 처리
						purchaseMgmtDAO.insertProcRetReAcq(paramMap);
					}

					totCnt = totCnt+cnt;
					resultMap.put( "totCnt", totCnt );
				}

			}

		}
		catch(Exception e)
		{
			log.error( "Exception error : " , e );
			resultMap.put( "resultCd", "9999" );
			resultMap.put( "resultMsg", "Exception Fail." );
			return resultMap;
		}

		resultMap.put( "resultCd", "0000" );

		return resultMap;
	}
}
