package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.businessmgmt.dao.InquiryMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.service
 * File Name      : InquiryMgmtServiceImpl.java
 * Description    : 영업관리 - 가맹점관리 - 문의
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("inquiryMgmtService")
public class InquiryMgmtServiceImpl implements InquiryMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="inquiryMgmtDAO")
    private InquiryMgmtDAO inquiryMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectInquiryMgmtList(Map<String, Object> objMap) throws Exception {
        return inquiryMgmtDAO.selectInquiryMgmtList(objMap);
    }
    
    @Override
    public Object selectInquiryMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return inquiryMgmtDAO.selectInquiryMgmtListTotal(objMap);
    }
    
    @Override
    public Map<String, Object> selectInquiryMgmt(Map<String, Object> objMap) throws Exception {
        return inquiryMgmtDAO.selectInquiryMgmt(objMap);
    }
    
    @Override
    public void updateInquiryMgmt(Map<String, Object> objMap) throws Exception {
        inquiryMgmtDAO.updateInquiryMgmt(objMap);
    }

    @Override
    public Map<String, Object> selectMerchantInfo(Map<String, Object> objMap) throws Exception {
        return inquiryMgmtDAO.selectMerchantInfo(objMap);
    }
}