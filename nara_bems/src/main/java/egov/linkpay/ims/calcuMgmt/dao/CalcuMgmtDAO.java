package egov.linkpay.ims.calcuMgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("calcuMgmtDAO")
public class CalcuMgmtDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	@SuppressWarnings( "unchecked" )
	public Map<String, Object> getCardSettlmntLstCnt(Map<String, Object> params) throws Exception {
		return (Map<String, Object>) selectOne("calcuMgmt.getCardSettlmntLstCnt", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> getCardSettlmntLst(Map<String, Object> params) throws Exception {
		return selectList("calcuMgmt.getCardSettlmntLst", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public Map<String, Object> getReceiveDeferLstCnt(Map<String, Object> params) throws Exception {
		return (Map<String, Object>) selectOne("calcuMgmt.getReceiveDeferLstCnt", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> getReceiveDeferLst(Map<String, Object> params) throws Exception {
		return selectList("calcuMgmt.getReceiveDeferLst", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int delAcqSettExp(Map<String, Object> params) throws Exception {
		return (int)update("calcuMgmt.delAcqSettExp", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public Map<String, Object> getCardSettlmntExpLstCnt(Map<String, Object> params) throws Exception {
		return (Map<String, Object>) selectOne("calcuMgmt.getCardSettlmntExpLstCnt", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> getCardSettlmntExpLst(Map<String, Object> params) throws Exception {
		return selectList("calcuMgmt.getCardSettlmntExpLst", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int insCardSettlmntRD(Map<String, Object> params) throws Exception {
		return (int)insert("calcuMgmt.insCardSettlmntRD", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public int insCardSettlmntExp(Map<String, Object> params) throws Exception {
		return (int)insert("calcuMgmt.insCardSettlmntExp", params);
    }
	
	@SuppressWarnings( "unchecked" )
	public Map<String, Object> getReceiveDeferGetTIDData(String params) throws Exception {
		return (Map<String, Object>) selectOne("calcuMgmt.getReceiveDeferGetTIDData", params);
    }
	
	
	
	
	
	//입금보고서
	
	@SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("calcuMgmt.selectUserAccountMgmtList", objMap);
    }
	
	public Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception {
        return selectOne("calcuMgmt.selectUserAccountMgmtListCnt", objMap);
    }
	
	@SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectUserAccountMgmtListDetail(Map<String, Object> objMap) throws Exception {
        return selectList("calcuMgmt.selectUserAccountMgmtListDetail", objMap);
    }
	
	public Object selectUserAccountMgmtListCntDetail(Map<String, Object> objMap) throws Exception {
        return selectOne("calcuMgmt.selectUserAccountMgmtListCntDetail", objMap);
    }
	
	@SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectDepositSum(Map<String, Object> objMap) throws Exception {
    	return selectList("calcuMgmt.selectDepositSum", objMap);
    }
	
	@SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectTidDetail(Map<String, Object> objMap) throws Exception {
    	return selectList("calcuMgmt.selectTidDetail", objMap);
    }
	
	
	//입금보류/해제/별도가감
	
	@SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectEtcDepositList(Map<String, Object> objMap) throws Exception {
        return selectList("calcuMgmt.selectEtcDepositList", objMap);
    }
    
    public Object selectEtcDepositListCnt(Map<String, Object> objMap) throws Exception {
        return selectOne("calcuMgmt.selectEtcDepositListCnt", objMap);
    }
	
}
