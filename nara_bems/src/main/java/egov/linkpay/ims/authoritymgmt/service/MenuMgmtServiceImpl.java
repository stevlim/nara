package egov.linkpay.ims.authoritymgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.authoritymgmt.dao.MenuMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : MenuMgmtServiceImpl.java
 * Description    : 권한관리 - 메뉴관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("menuMgmtService")
public class MenuMgmtServiceImpl implements MenuMgmtService {
    Logger logger = Logger.getLogger(this.getClass());
    
    @Resource(name="menuMgmtDAO")
    private MenuMgmtDAO menuMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectMenuGroupList(Map<String, Object> objMap) throws Exception {
        return menuMgmtDAO.selectMenuGroupList(objMap);
    }
    
    @Override
    public List<Map<String, Object>> selectMenuMgmtList(Map<String, Object> objMap) throws Exception {
        return menuMgmtDAO.selectMenuMgmtList(objMap);
    }
    
    @Override
    public void updateMenuList(Map<String, Object> objMap) throws Exception {
        String arrMenuNo[];
        String arrMenuSort[];
        String arrStatus[];
        
        arrMenuNo   = objMap.get("menunos").toString().split(",");
        arrMenuSort = objMap.get("menusorts").toString().split(",");
        arrStatus   = objMap.get("status").toString().split(",");
        
        for(int intIndex=0; intIndex<arrMenuNo.length; intIndex++){
            Map<String,Object> objParamMap = new HashMap<String, Object>();
            objParamMap.put("MENU_NO",   arrMenuNo[intIndex]);
            objParamMap.put("MENU_SEQ",  arrMenuSort[intIndex]);
            objParamMap.put("STATUS",    arrStatus[intIndex]);
            objParamMap.put("WORKER",    objMap.get("WORKER"));
            objParamMap.put("WORKER_IP", objMap.get("WORKER_IP"));
            
            menuMgmtDAO.updateMenuList(objParamMap);
            objParamMap.clear();
        }
    }
    
    @Override
    public void insertMenuMgmt(Map<String, Object> objMap) throws Exception {
        menuMgmtDAO.insertMenuMgmt(objMap);
    }
    
    @Override
    public void updateMenuMgmt(Map<String, Object> objMap) throws Exception {
        menuMgmtDAO.updateMenuMgmt(objMap);
    }
    
    @Override
    public void deleteMenuMgmt(Map<String, Object> objMap) throws Exception {
        menuMgmtDAO.deleteMenu(objMap);
        menuMgmtDAO.updateMenuSort(objMap);
    }
}
