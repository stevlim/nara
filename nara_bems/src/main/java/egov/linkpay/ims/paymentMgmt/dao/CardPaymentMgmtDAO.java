package egov.linkpay.ims.paymentMgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("cardPaymentMgmtDAO")
public class CardPaymentMgmtDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectTransInfoList(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectTransInfoList", objMap);
    }
	public Object selectTransInfoListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectTransInfoListTotal", objMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectTransFailInfoList(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectTransFailInfoList", objMap);
    }
	public Object selectTransFailInfoListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectTransFailInfoListTotal", objMap);
    }
	
	
	
	
	
	
	
	public List<Map<String,Object>> selectCardInfoAmt(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectCardInfoAmt", objMap);
    }
	
	public Object selectDetailCardTid(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectDetailCardTid", objMap);
    }
	public Object selectTransPartRemain(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectTransPartRemain", objMap);
    }
	
	public Object selectTransPartCnt(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectTransPartCnt", objMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectTransPartDetail(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectTransPartDetail", objMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectTransPartOrgDetail(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectTransPartOrgDetail", objMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectTransInfoTotalList(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectCardTotal", objMap);
    }
	public Object selectTransInfoTotalListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectCardTotalCnt", objMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectCardTotAmt(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectCardTotalAmt", objMap);
    }
	
	public Object selectTransCardNo(String tid) throws Exception {
        return selectOne("cardPaymentMgmt.selectCardNoTID", tid);
    }
	public Object chkEmpPW(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.chkEmpPW", objMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectMailSendSearch(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectMailSendSearch", objMap);
    }
	
	@SuppressWarnings( "unchecked" )
	public Object selectRecpt(String tid) throws Exception {
        return selectOne("cardPaymentMgmt.selectRecpt", tid);
    }
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectCheckCardEventList(Map<String, Object> objMap) throws Exception {
        return selectList("cardPaymentMgmt.selectCheckCardEventList", objMap);
    }
	public Object selectCheckCardEventListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectCheckCardEventListTotal", objMap);
    }
	
	public Object selectDetailCardFailTid(Map<String, Object> objMap) throws Exception {
        return selectOne("cardPaymentMgmt.selectDetailCardFailTid", objMap);
    }
}
