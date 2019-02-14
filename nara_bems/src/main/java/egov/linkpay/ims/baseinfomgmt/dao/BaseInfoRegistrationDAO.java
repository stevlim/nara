package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("baseInfoRegistrationDAO")
public class BaseInfoRegistrationDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	public int  insertBaseInfo(Map< String, Object > dataMap) throws Exception {
		int cnt = 0 ;
		cnt = (Integer)insert("baseInfoRegistration.insertBaseInfo", dataMap);
		return cnt;
	}
	public void insertGidRegist(Map< String, Object > dataMap) throws Exception {
		insert("baseInfoRegistration.insertGidRegist", dataMap);
	}
	public void insertVidRegist(Map< String, Object > dataMap) throws Exception {
		insert("baseInfoRegistration.insertVidRegist", dataMap);
	}
	public int insertMidInfo(Map< String, Object > dataMap) throws Exception{
		int cnt = 0 ;
		cnt = (Integer)insert("baseInfoRegistration.insertMidInfo", dataMap);
		return cnt;
	}
	public void updateNormalInfo(Map< String, Object > dataMap) throws Exception{
		insert("baseInfoRegistration.updateNormalInfo", dataMap);
	}
	public void updateEtcInfo(Map< String, Object > dataMap) throws Exception{
		insert("baseInfoRegistration.updateEtcInfo", dataMap);
	}
	public void updateSettleInfo(Map< String, Object > dataMap) throws Exception{
		insert("baseInfoRegistration.updateSettleInfo", dataMap);
	}
	public void updatePayType(Map< String, Object > dataMap) throws Exception{
		insert("baseInfoRegistration.updatePayType", dataMap);
	}
	public void updateGidInfo(Map< String, Object > dataMap) throws Exception{
		insert("baseInfoRegistration.updateGidInfo", dataMap);
	}
	public void updateVidInfo(Map< String, Object > dataMap) throws Exception{
		insert("baseInfoRegistration.updateVidInfo", dataMap);
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectKindCd() throws Exception {
		return selectList("common.selectKindCd");
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectSCateList() throws Exception {
		return selectList("common.selectSCateList");
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectMallTypeCd() throws Exception {
		return selectList("common.selectMallTypeCd");
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectCodeCl(String codeCl) throws Exception {
		return selectList("common.selectCodeCl" ,codeCl);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectCardList(Map<String,Object> paramMap) throws Exception {
		return selectList( "common.selectCardCd", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectCateList(String param) throws Exception {
		return selectList("common.selectCateList" ,param);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectEmplList(Map<String, Object> paramMap) throws Exception {
		return selectList("common.selectEmplList" ,paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoNo(Map< String, Object > paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectCoNo", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectBaseInfo(Map< String, Object > paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectBaseInfo", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectBaseInfoAll(Map< String, Object > paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectBaseInfoAll", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectApproList(Map< String, Object > paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectApproList", paramMap);
    }
	public Object selectApproListTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne( "baseInfoRegistration.selectApproListTotal", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVidApproList(Map< String, Object > paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectVidApproList", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardPay(Map< String, Object > paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectCardPay", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectGidInfo(String param) throws Exception {
		return selectList("baseInfoRegistration.selectGidInfo", param);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVidInfo(String param) throws Exception {
		return selectList("baseInfoRegistration.selectVidInfo", param);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVidFeeInfo(Map< String, Object > paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectVidFeeInfo", paramMap);
    }
	public Object selectSettleCycleCode(Map<String, Object> objMap) throws Exception {
        return selectOne("common.selectSettleCycleCode", objMap);
    }
	public Object dupIdChk(Map<String, Object> objMap) throws Exception {
        return selectOne("baseInfoRegistration.dupIdChk", objMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectInfo(String param) throws Exception {
		return selectList("baseInfoRegistration.selectInfo", param);
    }
	public Object selectTodaySettPmInfo(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectTodaySettPmInfo", paramMap);
    }
	public int updateTodaySettInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 1 ;
		cnt = (Integer)update("baseInfoRegistration.updateTodaySettInfo", paramMap);
		
		return cnt;
    }
	public int updateCardInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 1 ;
		cnt = (Integer)update("baseInfoRegistration.updateCardInfo", paramMap);
		
		return cnt;
    }
	public int updateSettlmntPm(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoRegistration.updateSettlmntPm", paramMap);
		
		return cnt;
    }
	public int insertSettlmntPm(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)insert("baseInfoRegistration.insertSettlmntPm", paramMap);
		
		return cnt;
    }
	public Object selectTodayCardInfoCnt(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectTodayCardInfoCnt", paramMap);
    }
	public Object selectTodayCardInfo(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectTodayCardInfo", paramMap);
    }
	public int updateJoinInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoRegistration.updateJoinInfo", paramMap);
		
		return cnt;
    }
	public int insertJoinInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)insert("baseInfoRegistration.insertJoinInfo", paramMap);
		
		return cnt;
    }
	public Object selectStmtCycleCnt(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectStmtCycleCnt", paramMap);
    }
	public Object selectStmtCycle(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectStmtCycle", paramMap);
    }
	public int updateStmtCycleInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoRegistration.updateStmtCycleInfo", paramMap);
		
		return cnt;
    }
	public int insertStmtCycleInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)insert("baseInfoRegistration.insertStmtCycleInfo", paramMap);
		
		return cnt;
    }
	public int updateMerPmInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update("baseInfoRegistration.updateMerPmInfo", paramMap);
		
		return cnt;
    }
	public int insertMerPmInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)insert("baseInfoRegistration.insertMerPmInfo", paramMap);
		
		return cnt;
    }
	public Object selectMerPmInfo(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectMerPmInfo", paramMap);
    }
	public Object selectExistChk(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectExistChk", paramMap);
    }
	public Object selectGidExistChk(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectGidExistChk", paramMap);
    }
	public Object selectVidExistChk(Map<String, Object> paramMap)  throws Exception {
		return selectOne("baseInfoRegistration.selectVidExistChk", paramMap);
    }
	public void insertMerKey(Map<String, Object> paramMap)  throws Exception {
		insert( "baseInfoRegistration.insertMerKey" , paramMap);
	}
	public void updateVidStmtFeeInfo(Map<String, Object> paramMap)  throws Exception {
		update( "baseInfoRegistration.updateVidStmtFeeInfo" , paramMap);
	}
	public int insertVIDSettlmntFeeInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)insert( "baseInfoRegistration.insertVIDSettlmntFeeInfo" , paramMap);
		return cnt;
	}
	public int updateVIDSettlmntFeeInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update( "baseInfoRegistration.updateVIDSettlmntFeeInfo" , paramMap);
		return cnt;
	}
	public int updateMerchantFeeReg(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update( "baseInfoRegistration.updateMerchantFeeReg" , paramMap);
		return cnt;
	}
	public int updateVidMerchantFeeReg(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update( "baseInfoRegistration.updateVidMerchantFeeReg" , paramMap);
		return cnt;
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectMerchantFeeRegCnt(Map<String, Object> paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectMerchantFeeRegCnt", paramMap);
    }
	public Object selectAfterFeeRegCnt(Map<String, Object> paramMap) throws Exception {
		return selectOne("baseInfoRegistration.selectMerchantFeeRegCnt", paramMap);
    }
	public int updateMerchantFeeRegBefore(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update( "baseInfoRegistration.updateMerchantFeeRegBefore" , paramMap);
		return cnt;
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVIDMerchantFeeRegCnt(Map<String, Object> paramMap) throws Exception {
		return selectList("baseInfoRegistration.selectVIDMerchantFeeRegCnt", paramMap);
    }
	public int updateVIDMerchantFeeRegBefore(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update( "baseInfoRegistration.updateVIDMerchantFeeRegBefore" , paramMap);
		return cnt;
	}
	public int updateVIDMerchantFeeReg(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update( "baseInfoRegistration.updateVIDMerchantFeeReg" , paramMap);
		return cnt;
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardCd(Map< String, Object > paramMap) throws Exception {
		return selectList( "common.selectCardCd", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectFeeRegLst(Map< String, Object > paramMap) throws Exception {
		return selectList( "baseInfoRegistration.selectFeeRegLst", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectGidList() throws Exception {
		return selectList( "baseInfoRegistration.selectGidList");
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectVidList() throws Exception {
		return selectList( "baseInfoRegistration.selectVidList");
    }
	public int updateStmtFeeInfo(Map<String, Object> paramMap)  throws Exception {
		int cnt = 0 ;
		cnt = (Integer)update( "baseInfoRegistration.updateStmtFeeInfo" , paramMap);
		return cnt;
	}
}
