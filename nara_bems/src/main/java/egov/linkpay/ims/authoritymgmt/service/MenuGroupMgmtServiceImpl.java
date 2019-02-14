package egov.linkpay.ims.authoritymgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.authoritymgmt.dao.MenuGroupMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : MenuGroupMgmtServiceImpl.java
 * Description    : 권한관리 - 메뉴그룹관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("menuGroupMgmtService")
public class MenuGroupMgmtServiceImpl implements MenuGroupMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="menuGroupMgmtDAO")
    private MenuGroupMgmtDAO menuGroupMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectMenuGroupMgmtList(Map<String, Object> objMap) throws Exception {
        return menuGroupMgmtDAO.selectMenuGroupMgmtList(objMap);
    }
    
    @Override
    public void updateMenuGroupMgmt(Map<String, Object> objMap) throws Exception {
        String strMenuGroupType = "";
        String arrMenuGroupNo[];
        String arrMenuGroupName[];
        String arrMenuGroupSort[];
        String arrStatus[];
        
        arrMenuGroupNo = objMap.get("menugroupnos").toString().split(",");
        arrMenuGroupName = objMap.get("menugroupnames").toString().split(",");
        arrMenuGroupSort = objMap.get("menugroupsorts").toString().split(",");
        arrStatus = objMap.get("stauts").toString().split(",");
        strMenuGroupType = objMap.get("menugrouptype").toString();
        
        for(int intIndex=0; intIndex<arrMenuGroupName.length; intIndex++){
            Map<String,Object> objParamMap = new HashMap<String, Object>();
            objParamMap.put("MENU_GRP_NO",   arrMenuGroupNo[intIndex]);
            objParamMap.put("MENU_GRP_NM",   arrMenuGroupName[intIndex]);
            objParamMap.put("MENU_GRP_TYPE", strMenuGroupType);
            objParamMap.put("MENU_GRP_SEQ",  arrMenuGroupSort[intIndex]);
            objParamMap.put("STATUS",        arrStatus[intIndex]);
            objParamMap.put("WORKER",        objMap.get("WORKER"));
            objParamMap.put("WORKER_IP",     objMap.get("WORKER_IP"));
            
            menuGroupMgmtDAO.updateMenuGroupMgmt(objParamMap);
            objParamMap.clear();
        }
    }
    
    @Override
    public void deleteMenuGroupMgmt(Map<String, Object> objMap) throws Exception {
        menuGroupMgmtDAO.deleteUserAuthDtl(objMap);
        menuGroupMgmtDAO.deleteMenu(objMap);
        menuGroupMgmtDAO.deleteGroupMenu(objMap);
        menuGroupMgmtDAO.updateGroupMenuSort(objMap);
    }
    
    @Override
    public void insertMenuMgmt(Map<String, Object> objMap) throws Exception {
        menuGroupMgmtDAO.insertMenuMgmt(objMap);
    }
}
