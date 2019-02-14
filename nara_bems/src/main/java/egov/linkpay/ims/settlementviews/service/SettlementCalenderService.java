package egov.linkpay.ims.settlementviews.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : net.nicepay.dashboard.settlementmgmt.service
 * File Name      : SettlementCalenderService.java
 * Description    : 정산 조회 - 정산 달력
 * Author         : yangjeongmo, 2015. 11. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface SettlementCalenderService {
    List<Map<String, Object>> selectSettlementCalenderList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectSettlementSettCalenderList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectSettlementDetailList(Map<String, Object> objMap) throws Exception;
    
    List<Map<String, Object>> selectMerchantIDList(String strUserID) throws Exception;
    
    List<Map<String, Object>> selectPerMerchantReportExcelList(Map<String, Object> objMap) throws Exception;
    
    Object selectPerMerchantReportExcelCnt(Map<String, Object> objMap) throws Exception;

	List<Map<String, Object>> selectTaxInvoiceList(Map<String, Object> objMap) throws Exception;

	Integer selectTaxInvoiceListTotal(Map<String, Object> objMap) throws Exception;
}
