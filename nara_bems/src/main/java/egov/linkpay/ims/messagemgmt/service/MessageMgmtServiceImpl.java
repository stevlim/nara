package egov.linkpay.ims.messagemgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.messagemgmt.dao.MessageMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.messagemgmt.service
 * File Name      : MessageMgmtServiceImpl.java
 * Description    : 다국어관리 - 메시지관리
 * Author         : kwjang, 2015. 11. 27.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("messageMgmtService")
public class MessageMgmtServiceImpl implements MessageMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="messageMgmtDAO")
    private MessageMgmtDAO messageMgmtDAO;

    @Override
    public List<Map<String, Object>> selectMessageMgmtList(Map<String, Object> objMap) throws Exception {
        return messageMgmtDAO.selectMessageMgmtList(objMap);
    }

    @Override
    public Object selectMessageMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return messageMgmtDAO.selectMessageMgmtListTotal(objMap);
    }

    @Override
    public void insertMessageMgmt(Map<String, Object> objMap) throws Exception {
        Map<String, Object> objRow = new HashMap<String, Object>();

        objRow = messageMgmtDAO.selectMessageMgmtInfo(objMap);
        
        if(objRow != null) {
            objMap.put("ResultMessage", CommonMessageDic.getMessage("IMS_MM_MM_0001"));
            throw new Exception(CommonMessageDic.getMessage("IMS_MM_MM_0001"));
        } else {
            messageMgmtDAO.insertMessageMgmt(objMap);
        }
    }

    @Override
    public void updateMessageMgmt(Map<String, Object> objMap) throws Exception {
        messageMgmtDAO.updateMessageMgmt(objMap);
    }

    @Override
    public Map<String, Object> selectMessageMgmtInfo(Map<String, Object> objMap) throws Exception {
        return messageMgmtDAO.selectMessageMgmtInfo(objMap);
    }

    @Override
    public List<Map<String, Object>> selectLanguage(Map<String, Object> objMap) throws Exception {
        return messageMgmtDAO.selectLanguage(objMap); 
    }
}