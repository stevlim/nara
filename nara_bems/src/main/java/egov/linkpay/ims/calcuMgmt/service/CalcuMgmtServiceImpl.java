package egov.linkpay.ims.calcuMgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;
import egov.linkpay.ims.calcuMgmt.dao.CalcuMgmtDAO;

@Service("calcuMgmtService")
public class CalcuMgmtServiceImpl implements CalcuMgmtService
{
	Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="calcuMgmtDAO")
    private CalcuMgmtDAO calcuMgmtDAO;	
    
    @Resource(name="historySearchDAO")
    private HistorySearchDAO historySearchDAO;
    
    @Override
    public Map<String, Object> getCardSettlmntLstCnt(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.getCardSettlmntLstCnt(params);
    }
    
    @Override
    public List<Map<String, Object>> getCardSettlmntLst(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.getCardSettlmntLst(params);
    }
    
    @Override
    public Map<String, Object> getReceiveDeferLstCnt(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.getReceiveDeferLstCnt(params);
    }
    
    @Override
    public List<Map<String, Object>> getReceiveDeferLst(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.getReceiveDeferLst(params);
    }
    
    @Override
    public int delAcqSettExp(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.delAcqSettExp(params);
    }
    
    @Override
    public Map<String, Object> getCardSettlmntExpLstCnt(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.getCardSettlmntExpLstCnt(params);
    }
    
    @Override
    public List<Map<String, Object>> getCardSettlmntExpLst(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.getCardSettlmntExpLst(params);
    }
    
    @Override
    public int insCardSettlmntRD(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.insCardSettlmntRD(params);
    }
    
    @Override
    public int insCardSettlmntExp(Map<String, Object> params) throws Exception {
        return calcuMgmtDAO.insCardSettlmntExp(params);
    }
    
    @Override
    public Map<String, Object> getReceiveDeferGetTIDData(String params) throws Exception {
        return calcuMgmtDAO.getReceiveDeferGetTIDData(params);
    }
    
    
    
    
    
    //입금보고서
    
    @Override
    public List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectUserAccountMgmtList(objMap);
    }
    
    @Override
    public Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectUserAccountMgmtListCnt(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectUserAccountMgmtListDetail(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectUserAccountMgmtListDetail(objMap);
    }
    
    @Override
    public Object selectUserAccountMgmtListCntDetail(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectUserAccountMgmtListCntDetail(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectDepositSum(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectDepositSum(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectTidDetail(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectTidDetail(objMap);
    }
    
    
    //입금보류/해제/별도가감
    
    @Override
    public List<Map<String, Object>> selectEtcDepositList(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectEtcDepositList(objMap);
    }

    @Override
    public Object selectEtcDepositListCnt(Map<String, Object> objMap) throws Exception {
        return calcuMgmtDAO.selectEtcDepositListCnt(objMap);
    }
}
