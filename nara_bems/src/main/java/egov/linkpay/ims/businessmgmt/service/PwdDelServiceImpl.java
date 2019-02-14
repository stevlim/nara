package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.businessmgmt.dao.PwdDelDAO;
import egov.linkpay.ims.common.common.CommonEncrypt;

@Service("pwdDelService")
public class PwdDelServiceImpl implements PwdDelService
{
	 Logger log = Logger.getLogger(this.getClass());
	 
	 @Resource(name="pwdDelDAO")
	 private PwdDelDAO  pwdDelDAO;
	 
	 @Override
    public List<Map<String, Object>> selectPWDList(Map<String, Object> objMap) throws Exception {
        return pwdDelDAO.selectPWDList(objMap);
    }
    
    @Override
    public Object selectPWDListTotal(Map<String, Object> objMap) throws Exception {
        return pwdDelDAO.selectPWDListTotal(objMap);
    }
    
    public void updatePwdInit(Map<String, Object> objMap) throws Exception {
    	log.info( "updatePwdInit - pw 생성 " );
    	String uid = (String)objMap.get( "uid" );
    	
    	log.info( "updatePwdInit - pw 생성 uid : " + uid );
    	String pw  = CommonEncrypt.Base64EncodedMD5( uid);
    	
    	log.info( "updatePwdInit - pw 생성 pw : " + pw );
    	objMap.put( "pw", pw );
    	
        pwdDelDAO.updatePwdInit(objMap);
    }
    public void updateChangeCcPw(Map<String, Object> objMap) throws Exception {
        pwdDelDAO.updateChangeCcPw(objMap);
    }
}
