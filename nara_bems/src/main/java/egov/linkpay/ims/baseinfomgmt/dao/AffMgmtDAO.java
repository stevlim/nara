package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("affMgmtDAO")
public class AffMgmtDAO extends BaseDAO
{
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectCodeCl(String codeCl) throws Exception {
		return selectList("common.selectCodeCl" ,codeCl);
    }
	
	//제휴사 신용카드 조회  
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCreditCardList(Map< String, Object > paramMap) throws Exception {
		return selectList("affMgmt.selectCreditCardList", paramMap);
    }
	public Object selectCreditCardListTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("affMgmt.selectCreditCardListTotal", paramMap);
    }
	
	//insert 제휴사 카드
	public void insertCreditCardInfo(Map< String, Object > dataMap) throws Exception{
		insert("affMgmt.insertCreditCardInfo", dataMap);
	}
	
	//삭제전 데이터 조회
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> cardInfoSettingCnt(Map< String, Object > paramMap) throws Exception {
		return selectList("affMgmt.cardInfoSettingCnt", paramMap);
    }
	
	//가맹점 설정 데이터 조회  
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardSetData(Map< String, Object > paramMap) throws Exception {
		return selectList("affMgmt.selectCardSetData", paramMap);
    }
	public Object selectCardSetDataTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("affMgmt.selectCardSetDataTotal", paramMap);
    }
	
	//카드 HISTORY 조회
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardHistory(Map< String, Object > paramMap) throws Exception {
		return selectList("affMgmt.selectCardHistory", paramMap);
    }
	public Object selectCardHistoryTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("affMgmt.selectCardHistoryTotal", paramMap);
    }
	
	//카드 조회
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCardInfo(Map< String, Object > paramMap) throws Exception {
		return selectList("affMgmt.selectCardInfo", paramMap);
    }
	public Object selectCardInfoTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("affMgmt.selectCardInfoTotal", paramMap);
    }
	
	//van mbs_no 체크 
	public Object mbsNoMatchChk(Map< String, Object > paramMap) throws Exception {
		return selectOne( "affMgmt.mbsNoMatchChk", paramMap);
    }
	
	//van 등록 
	public void insertVanTer(Map< String, Object > dataMap) throws Exception{
		insert("affMgmt.insertVanTer", dataMap);
	}
	
	//van list
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVanTerInfo(Map< String, Object > paramMap) throws Exception {
		return selectList("affMgmt.selectVanTerInfo", paramMap);
    }
	public Object selectVanTerInfoTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("affMgmt.selectVanTerInfoTotal", paramMap);
    }
	
	
	//무이자 시 카드 수수료백업  
	public int insertDeleteCardFeeInfo(Map< String, Object > dataMap) throws Exception{
		int cnt = (Integer)insert("affMgmt.insertDeleteCardFeeInfo", dataMap);
		 return  cnt;
	}
	//무이자 시 카드 수수료 삭제  
	public int deleteNoneUseCardFee(Map< String, Object > dataMap) throws Exception{
		int cnt = (Integer)insert("affMgmt.deleteNoneUseCardFee", dataMap);
		return cnt;
	}
	//카드 정보 삭제 테이블에 저장
	public int insertDelCardInfo(Map< String, Object > dataMap) throws Exception{
		int cnt = (Integer)insert("affMgmt.insertDelCardInfo", dataMap);
		return cnt;
	}
	//카드 정보 테이블에서 삭제ㅔ   
	public int deleteNoneUseCardInfo(Map< String, Object > dataMap) throws Exception{
		int cnt = (Integer)insert("affMgmt.deleteNoneUseCardInfo", dataMap);
		return cnt;
	}
}
