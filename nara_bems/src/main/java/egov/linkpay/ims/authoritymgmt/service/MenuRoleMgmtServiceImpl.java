package egov.linkpay.ims.authoritymgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.authoritymgmt.dao.MenuRoleMgmtDAO;
import egov.linkpay.ims.common.common.CommonMessageDic;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : MenuRoleMgmtServiceImpl.java
 * Description    : 권한관리 - 메뉴역할관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("menuRoleMgmtService")
public class MenuRoleMgmtServiceImpl implements MenuRoleMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="menuRoleMgmtDAO")
    private MenuRoleMgmtDAO menuRoleMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectMenuRoleMgmtList(Map<String, Object> objMap) throws Exception {
        return menuRoleMgmtDAO.selectMenuRoleMgmtList(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectMenuRoleMgmtDtl(Map<String, Object> objMap) throws Exception {
        return menuRoleMgmtDAO.selectMenuRoleMgmtDtl(objMap);
    }
    
    @Override
    public void insertMenuRoleMgmt(Map<String, Object> objMap) throws Exception {
        int intMerAuthType    = 0;
        int intMerAuthTypeCnt = 0;
        
        intMerAuthType = Integer.parseInt(objMap.get("MER_AUTH_TYPE").toString());
        
        if(intMerAuthType == 1){
            intMerAuthTypeCnt = Integer.parseInt(menuRoleMgmtDAO.selectMenuRoleMerAuthTypeCnt().toString());
            
            if(intMerAuthTypeCnt > 0){
                throw new Exception(CommonMessageDic.getMessage("IMS_AM_MRM_0001"));
            }
        }
    
        menuRoleMgmtDAO.insertMenuRoleMgmt(objMap);
        menuRoleMgmtDAO.insertMenuRoleDtl(objMap);
    }
    
    @Override
    public void updateMenuRoleMgmt(Map<String, Object> objMap) throws Exception {
        menuRoleMgmtDAO.updateMenuRoleMgmt(objMap);
        menuRoleMgmtDAO.insertMenuRoleDtl(objMap);
        menuRoleMgmtDAO.deleteMenuRoleDtl(objMap);
        menuRoleMgmtDAO.updateAllMenuRoleDtl(objMap);
        menuRoleMgmtDAO.updateReadMenuRoleDtl(objMap);
    }
    
    
    @Override
    public List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception {
        return menuRoleMgmtDAO.selectUserAccountMgmtList(objMap);
    }



    @Override
    public Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception {
        return menuRoleMgmtDAO.selectUserAccountMgmtListCnt(objMap);
    }
}
