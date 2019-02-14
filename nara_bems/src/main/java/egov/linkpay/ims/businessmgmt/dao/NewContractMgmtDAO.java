package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.dao
 * File Name      : NewContractMgmtDAO.java
 * Description    : 영업관리 - 신규계약관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("newContractMgmtDAO")
public class NewContractMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());

    public int insertCoInfo(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
    	 cnt = (Integer)insert("newContractMgmt.insertCoInfo", objMap);
    	return cnt;
    }
    public int updateCoInfo(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
    	 cnt = (Integer)insert("newContractMgmt.updateCoInfo", objMap);
    	return cnt;
    }
    
    public Object chkPayStatus(Map<String, Object> objMap) throws Exception {
        return selectOne("newContractMgmt.selectPayStatus", objMap);
    }
    
    public int paymentUpdate(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
    	 cnt = (Integer)update("newContractMgmt.updatePayment", objMap);
    	return cnt;
    }
    
    public int paymentUpDel(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
    	 cnt = (Integer)update("newContractMgmt.updatePaymentDel", objMap);
    	return cnt;
    }

    public int insertPayment(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
    	cnt = (Integer)insert("newContractMgmt.insertPayment", objMap);
    	return cnt;
    }
    public int insertMemo(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
    	cnt = (Integer)insert("newContractMgmt.insertMemo", objMap);
    	return cnt;
    }
    public int insertCardSub(Map<String, Object> objMap) throws Exception {
    	int cnt = 0;
    	cnt = (Integer)insert("newContractMgmt.insertCardSub", objMap);
    	return cnt;
    }
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoInfoList(Map<String, Object> objMap) throws Exception {
        return selectList("newContractMgmt.selectCoInfoList", objMap);
    }
	public Object selectCoInfoListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("newContractMgmt.selectCoInfoListTotal", objMap);
    }
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoNo(Map<String, Object> objMap) throws Exception {
        return selectList("newContractMgmt.selectCoNo", objMap);
    }
    @SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectEmplList(Map<String, Object> paramMap) throws Exception {
		return selectList("common.selectEmplList" ,paramMap);
    }
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, String>> selectCodeCl(String codeCl) throws Exception {
		return selectList("common.selectCodeCl" ,codeCl);
    }
    
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoFeeInfo(Map<String, Object> paramMap) throws Exception {
		return selectList("newContractMgmt.selectCoFeeInfo" ,paramMap);
    }
    
    public int selectFee(Map<String, Object> objMap) throws Exception {
    	return (Integer)selectOne("newContractMgmt.selectFee", objMap);
    }
    
    public int updateFee(Map<String, Object> objMap) throws Exception {
    	int cnt =0;
		cnt = (Integer)insert("newContractMgmt.updateFee", objMap);
    	return cnt;
    }
    public int insertFee(Map<String, Object> objMap) throws Exception {
    	int cnt =0;
		cnt = (Integer)insert("newContractMgmt.insertFee", objMap);
    	return cnt;
    }
    @SuppressWarnings( "unchecked" )
	public List<String> selectCardSubmallDupChkLst(String coNo) throws Exception {
        return selectList("newContractMgmt.getCardSubmallDupChkLst", coNo);
    }
    //img list
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectContImgList(Map<String, Object> paramMap) throws Exception {
        return selectList("newContractMgmt.selectContImgList", paramMap);
    }
	public Object selectContImgListTotal(Map<String, Object> paramMap) throws Exception {
        return selectOne("newContractMgmt.selectContImgListTotal", paramMap);
    }
    //신규계약 진행현황 리스트 조회
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoApprInfoList(Map<String, Object> paramMap) throws Exception {
        return selectList("newContractMgmt.selectCoApprInfoList", paramMap);
    }
	public Object selectCoApprInfoListTotal(Map<String, Object> paramMap) throws Exception {
        return selectOne("newContractMgmt.selectCoApprInfoListTotal", paramMap);
    }
	
	 //신규계약 진행현황 리스트 조회 구분 mid
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoApprMInfoList(Map<String, Object> paramMap) throws Exception {
        return selectList("newContractMgmt.selectCoApprMInfoList", paramMap);
    }
	public Object selectCoApprMInfoListTotal(Map<String, Object> paramMap) throws Exception {
        return selectOne("newContractMgmt.selectCoApprMInfoListTotal", paramMap);
    }
	 
	 //신규계약 진행현황 리스트 조회 구분 vid
    @SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCoApprVInfoList(Map<String, Object> paramMap) throws Exception {
        return selectList("newContractMgmt.selectCoApprVInfoList", paramMap);
    }
	public Object selectCoApprVInfoListTotal(Map<String, Object> paramMap) throws Exception {
        return selectOne("newContractMgmt.selectCoApprVInfoListTotal", paramMap);
    }
	public Object getCompAverageFee(String coNo) throws Exception {
        return selectOne("newContractMgmt.getCompAverageFee", coNo);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>>  getCompPay(String coNo) throws Exception {
        return selectList("newContractMgmt.getCompPay", coNo);
    }
	
	public int updateCoApp(Map<String, Object> objMap) throws Exception {
    	int cnt =0;
		cnt = (Integer)update("newContractMgmt.updateCoApp", objMap);
    	return cnt;
    }
	public Object selectCoView(Map<String, Object> objMap) throws Exception {
        return selectOne("newContractMgmt.selectCoView", objMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>>  selectCoFee(Map<String, Object> objMap) throws Exception {
        return selectList("newContractMgmt.selectCoFee", objMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>>  selectCoMemoList(Map<String, Object> objMap) throws Exception {
        return selectList("newContractMgmt.selectCoMemoList", objMap);
    }
	public Object  selectContPayInfo(Map<String, Object> objMap) throws Exception {
        return selectOne("newContractMgmt.selectContPayInfo", objMap);
    }
	public Object  selectContFeeAllInfo(Map<String, Object> objMap) throws Exception {
        return selectOne("newContractMgmt.selectContFeeAllInfo", objMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>>  selectFeeViewCardLst(Map<String, Object> objMap) throws Exception {
        return selectList("newContractMgmt.selectFeeViewCardLst", objMap);
    }
	public int selectContDocCnt(Map<String, Object> objMap) throws Exception {
    	int cnt =0;
		cnt = (Integer)insert("newContractMgmt.selectContDocCnt", objMap);
    	return cnt;
    }
	
	public int uploadContImg(Map<String, Object> objMap) throws Exception {
    	int cnt =0;
		cnt = (Integer)insert("newContractMgmt.insertContDoc", objMap);
    	return cnt;
    }
}
