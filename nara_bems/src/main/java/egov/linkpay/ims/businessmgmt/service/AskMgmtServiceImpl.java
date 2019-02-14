package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.businessmgmt.dao.QnaMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.service
 * File Name      : QnaMgmtServiceImpl.java
 * Description    : 영업관리 - 가맹점관리 - QnA
 * Author         : ymjo, 2015. 10. 13.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("QnaMgmtService")
public class AskMgmtServiceImpl implements AskMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="qnaMgmtDAO")
    private QnaMgmtDAO qnaMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectQnaMgmtList(Map<String, Object> objMap) throws Exception {
        return qnaMgmtDAO.selectQnaMgmtList(objMap);
    }
    
    @Override
    public Object selectQnaMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return qnaMgmtDAO.selectQnaMgmtListTotal(objMap);
    }
    
    @Override
    public Map<String, Object> selectQnaMgmt(Map<String, Object> objMap) throws Exception {
        return qnaMgmtDAO.selectQnaMgmt(objMap);
    }
    
    @Override
    public void insertQnaMgmt(Map<String, Object> objMap) throws Exception {
        qnaMgmtDAO.insertQnaMgmt(objMap);
    }
    
    @Override
    public void updateQnaMgmt(Map<String, Object> objMap) throws Exception {
        qnaMgmtDAO.updateQnaMgmt(objMap);
    }
}