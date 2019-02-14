package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("baseInfoMgmtDAO")
public class BaseInfoMgmtDAO extends BaseDAO
{
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectMidInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectMidInfo", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSettleFee(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectSettleFee", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCompFee(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectCompFee", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectCardInfo", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardBillInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectCardBillInfo", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSettleCycle(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectSettleCycle", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectPayType(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectPayType", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSCate(String bsKindCd) throws Exception {
		return selectList( "baseInfoMgmt.selectSCate", bsKindCd);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectSettlmntService(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectSettlmntService", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectBaseInfoList(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectBaseInfoList", paramMap);
    }
	public Object selectBaseInfoListTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne( "baseInfoMgmt.selectBaseInfoListTotal", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectEmpAuthSearch(Map< String, Object > paramMap) throws Exception {
		return selectList( "adminMng.selectSessionIDInfo", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVMid(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectVMid", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectGMid(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectGMid", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectBankCd(Map< String, Object > paramMap) throws Exception {
		return selectList( "common.selectBankCd", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectUseCard(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectUseCard", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardCd(Map< String, Object > paramMap) throws Exception {
		return selectList( "common.selectCardCd", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCodeCl(Map< String, Object > paramMap) throws Exception {
		return selectList( "common.selectCodeCl", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> insertMultiRegist(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.insertMultiRegist", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoInfo(String coNo) throws Exception {
		return selectList( "baseInfoMgmt.selectCoInfo", coNo);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> getTermLst2(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.getTermLst2", paramMap);
    }
	
	public int delMassMerSvc(String mid) throws Exception {
		int cnt = 0;
		cnt = (Integer)delete("baseInfoMgmt.delMassMerSvc", mid);
		return  cnt;
    }
	public int delMassSettlmntCycle(String mid) throws Exception {
		int cnt = 0;
		cnt = (Integer)delete("baseInfoMgmt.delMassSettlmntCycle", mid);
		return  cnt;
    }
	public int delMassJoinInfo(String mid) throws Exception {
		int cnt = 0;
		cnt = (Integer)delete("baseInfoMgmt.delMassJoinInfo", mid);
		return  cnt;
    }
	public int delMassSettlmntFee(String mid) throws Exception {
		int cnt = 0;
		cnt = (Integer)delete("baseInfoMgmt.delMassSettlmntFee", mid);
		return  cnt;
    }
	public int delMassSettlmntSvc(String mid) throws Exception {
		int cnt = 0;
		cnt = (Integer)delete("baseInfoMgmt.delMassSettlmntSvc", mid);
		return  cnt;
    }
	
	//가맹점 key 조회
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectMerchantKeyInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectMerchantKeyInfo", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectSettleReqList(Map<String, Object> objMap) throws Exception {
        return selectList("baseInfoMgmt.selectSettleReqList", objMap);
    }
	public Object selectSettleReqListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("baseInfoMgmt.selectSettleReqListTotal", objMap);
    }
	
	public int updateSettleReqStatus(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoMgmt.updateSettleReqStatus", paramMap);
		
		return cnt;
    }
	
	public int updateNormalInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoMgmt.updateNormalInfo", paramMap);
		
		return cnt;
    }
	
	public int updateNormalGidInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoMgmt.updateNormalGidInfo", paramMap);
		
		return cnt;
    }
	
	public int updateNormalVidInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoMgmt.updateNormalVidInfo", paramMap);
		
		return cnt;
    }
	
	public int updateCancelTransPw(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoMgmt.updateCancelTransPw", paramMap);
		
		return cnt;
    }
	
	public int updateNormalTelInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoMgmt.updateNormalTelInfo", paramMap);
		
		return cnt;
    }
	
	public int updateNotiTransInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoMgmt.updateNotiTransInfo", paramMap);
		
		return cnt;
    }
	
	public int insertNotiTransInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)insert("baseInfoMgmt.insertNotiTransInfo", paramMap);
		
		return cnt;
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectNotiTransInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectNotiTransInfo", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectNormalInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectNormalInfo", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectNormalGidInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectNormalGidInfo", paramMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectNormalVidInfo(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoMgmt.selectNormalVidInfo", paramMap);
    }
	
	
}

