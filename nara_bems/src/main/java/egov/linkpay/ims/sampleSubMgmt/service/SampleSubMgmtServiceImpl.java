package egov.linkpay.ims.sampleSubMgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.sampleSubMgmt.dao.SampleSubMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.sampleSubMgmt.service
 * File Name      : SampleSubMgmtServiceImpl.java
 * Description    : SampleSubMgmtServiceImpl
 * Author         : st.lim, 2019. 02. 18.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("sampleSubMgmtService")
public class SampleSubMgmtServiceImpl implements SampleSubMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="sampleSubMgmtDAO")
    private SampleSubMgmtDAO sampleSubMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectFaqMgmtList(Map<String, Object> objMap) throws Exception {
        return sampleSubMgmtDAO.selectFaqMgmtList(objMap);
    }
    
    @Override
    public Object selectFaqMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return sampleSubMgmtDAO.selectFaqMgmtListTotal(objMap);
    }
    
    @Override
    public Map<String, Object> selectFaqMgmt(Map<String, Object> objMap) throws Exception {
        return sampleSubMgmtDAO.selectFaqMgmt(objMap);
    }
    
    @Override
    public void insertFaqMgmt(Map<String, Object> objMap) throws Exception {
    	sampleSubMgmtDAO.insertFaqMgmt(objMap);
    }
    
    @Override
    public void updateFaqMgmt(Map<String, Object> objMap) throws Exception {
    	sampleSubMgmtDAO.updateFaqMgmt(objMap);
    }
}