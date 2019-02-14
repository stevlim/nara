package egov.linkpay.ims.settlementviews.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.settlementviews.dao.SettlementCalenderDAO;

/**------------------------------------------------------------
 * Package Name   : net.nicepay.dashboard.settlementmgmt.service
 * File Name      : SettlementCalenderServiceImpl.java
 * Description    : 정산 조회 - 정산 달력
 * Author         : yangjeongmo, 2015. 11. 5.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("settlementCalenderService")
public class SettlementCalenderServiceImpl implements SettlementCalenderService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="settlementCalenderDAO")
    private SettlementCalenderDAO settlementCalenderDAO;
    
    @Override
    public List<Map<String, Object>> selectSettlementCalenderList(Map<String, Object> objMap) throws Exception {
        return settlementCalenderDAO.selectSettlementCalenderList(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectSettlementSettCalenderList(Map<String, Object> objMap) throws Exception {
        return settlementCalenderDAO.selectSettlementSettCalenderList(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectSettlementDetailList(Map<String, Object> objMap) throws Exception {
        return settlementCalenderDAO.selectSettlementDetailList(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectMerchantIDList(String strUserID) throws Exception {
        return settlementCalenderDAO.selectMerchantIDList(strUserID);
    }
    
    @Override
    public List<Map<String, Object>> selectPerMerchantReportExcelList(Map<String, Object> objMap) throws Exception {
        return settlementCalenderDAO.selectPerMerchantReportExcelList(objMap);
    }
    
    @Override
    public Object selectPerMerchantReportExcelCnt(Map<String, Object> objMap) throws Exception {
        return settlementCalenderDAO.selectPerMerchantReportExcelCnt(objMap);
    }

	@Override
	public List<Map<String, Object>> selectTaxInvoiceList(Map<String, Object> objMap) throws Exception {
		List<Map<String, Object>> dataList = new ArrayList<Map<String,Object>>();
    	List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();

    	
    	dataList = settlementCalenderDAO.selectTaxInvoiceList( objMap );
    	if(dataList.size() > 0 ){
    		for(int i=0; i<dataList.size();i++){
    			Map<String, Object > map = dataList.get( i );
    			resultList.add( map );
    		}
    	}
    	return resultList;
	}

	@Override
	public Integer selectTaxInvoiceListTotal(Map<String, Object> objMap) throws Exception {
		// TODO Auto-generated method stub
		return settlementCalenderDAO.selectTaxInvoiceListTotal( objMap );
	}
}

