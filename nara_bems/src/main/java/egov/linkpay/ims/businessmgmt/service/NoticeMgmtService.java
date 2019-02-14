package egov.linkpay.ims.businessmgmt.service;

import java.util.List;
import java.util.Map;

/**------------------------------------------------------------
 * Package Name   : net.ionpay.dashboard.businessmgmt.service
 * File Name      : NoticeMgmtService.java
 * Description    : 영업관리 - 가맹점관리 - 공지사항
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public interface NoticeMgmtService {    
    List<Map<String, Object>> selectNoticeMgmtList(Map<String, Object> objMap) throws Exception;
    
    Object selectNoticeMgmtListTotal(Map<String, Object> objMap) throws Exception;

    Map<String, Object> selectNoticeMgmt(Map<String, Object> objMap) throws Exception;
    
    Map<String, Object> insertNoticeMgmt(Map<String, Object> objMap) throws Exception;

    Map<String, Object> updateNoticeMgmt(Map<String, Object> objMap) throws Exception;
}