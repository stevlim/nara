package egov.linkpay.ims.settlementviews.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : net.nicepay.dashboard.settlementmgmt.dao
 * File Name      : SettlementCalenderDAO.java
 * Description    : 정산 조회 - 정산 달력
 * Author         : yangjeongmo, 2015. 11. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("settlementCalenderDAO")
public class SettlementCalenderDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectSettlementCalenderList(Map<String, Object> objMap) throws Exception {
        return selectList("settlementCalender.selectSettlementCalenderList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectSettlementSettCalenderList(Map<String, Object> objMap) throws Exception {
        return selectList("settlementCalender.selectSettlementSettCalenderList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectSettlementDetailList(Map<String, Object> objMap) throws Exception {
        return selectList("settlementCalender.selectSettlementDetailList", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMerchantIDList(String strUserID) throws Exception {
        return selectList("common.selectMerchantIDList", strUserID);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectPerMerchantReportExcelList(Map<String, Object> objMap) throws Exception {
        return selectList("settlementCalender.selectPerMerchantReportExcelList", objMap);
    }
    
    public Object selectPerMerchantReportExcelCnt(Map<String, Object> objMap) throws Exception {
        return selectOne("settlementCalender.selectPerMerchantReportExcelCnt", objMap);
    }

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectTaxInvoiceList(Map<String, Object> objMap) throws Exception {
		// TODO Auto-generated method stub
		return selectList("settlementCalender.selectTaxInvoiceList", objMap);
	}

	public Integer selectTaxInvoiceListTotal(Map<String, Object> objMap) throws Exception {
		// TODO Auto-generated method stub
		return (Integer)selectOne("settlementCalender.selectTaxInvoiceListTotal", objMap);
	}
}
