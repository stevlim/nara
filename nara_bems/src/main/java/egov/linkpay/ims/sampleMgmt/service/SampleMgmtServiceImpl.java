package egov.linkpay.ims.sampleMgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.businessmgmt.dao.FaqMgmtDAO;
import egov.linkpay.ims.sampleMgmt.dao.SampleMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.service
 * File Name      : FaqMgmtServiceImpl.java
 * Description    : 영업관리 - 가맹점관리 - FAQ
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
//@Service("faqMgmtService")
@Service("sampleMgmtService")
public class SampleMgmtServiceImpl implements SampleMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    /*@Resource(name="faqMgmtDAO")
    private FaqMgmtDAO faqMgmtDAO;*/
    
    @Resource(name="sampleMgmtDAO")
    private SampleMgmtDAO sampleMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectFaqMgmtList(Map<String, Object> objMap) throws Exception {
        return sampleMgmtDAO.selectFaqMgmtList(objMap);
    }
    
    @Override
    public Object selectFaqMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return sampleMgmtDAO.selectFaqMgmtListTotal(objMap);
    }
    
    @Override
    public Map<String, Object> selectFaqMgmt(Map<String, Object> objMap) throws Exception {
        return sampleMgmtDAO.selectFaqMgmt(objMap);
    }
    
    @Override
    public void insertFaqMgmt(Map<String, Object> objMap) throws Exception {
    	sampleMgmtDAO.insertFaqMgmt(objMap);
    }
    
    @Override
    public void updateFaqMgmt(Map<String, Object> objMap) throws Exception {
    	sampleMgmtDAO.updateFaqMgmt(objMap);
    }
}