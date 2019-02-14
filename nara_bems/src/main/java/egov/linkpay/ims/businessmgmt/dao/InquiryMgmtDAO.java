package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.dao
 * File Name      : InquiryMgmtDAO.java
 * Description    : 영업관리 - 가맹점관리 - 문의
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Repository("inquiryMgmtDAO")
public class InquiryMgmtDAO extends BaseDAO {
    Logger logger = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectInquiryMgmtList(Map<String, Object> objMap) throws Exception {
        return selectList("inquiryMgmt.selectInquiryMgmtList", objMap);
    }

    public Object selectInquiryMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("inquiryMgmt.selectInquiryMgmtListTotal", objMap);
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> selectInquiryMgmt(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("inquiryMgmt.selectInquiryMgmt", objMap);
    }
        
    public void updateInquiryMgmt(Map<String, Object> objMap) throws Exception {
        update("inquiryMgmt.updateInquiryMgmt", objMap); 
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectMerchantInfo(Map<String, Object> objMap) throws Exception {
        return (Map<String, Object>) selectOne("common.selectMerchantInfo", objMap);
    }
}