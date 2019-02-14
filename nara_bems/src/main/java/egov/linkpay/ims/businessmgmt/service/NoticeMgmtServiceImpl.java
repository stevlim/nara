package egov.linkpay.ims.businessmgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.businessmgmt.dao.NoticeMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.businessmgmt.service
 * File Name      : NoticeMgmtServiceImpl.java
 * Description    : 영업관리 - 가맹점관리 - 공지사항
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("noticeMgmtService")
public class NoticeMgmtServiceImpl implements NoticeMgmtService {
    Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="noticeMgmtDAO")
    private NoticeMgmtDAO noticeMgmtDAO;
    
    @Override
    public List<Map<String, Object>> selectNoticeMgmtList(Map<String, Object> objMap) throws Exception {
        return noticeMgmtDAO.selectNoticeMgmtList(objMap);
    }
    
    @Override
    public Object selectNoticeMgmtListTotal(Map<String, Object> objMap) throws Exception {
        return noticeMgmtDAO.selectNoticeMgmtListTotal(objMap);
    }
    
    @Override
    public Map<String, Object> selectNoticeMgmt(Map<String, Object> objMap) throws Exception {
        return noticeMgmtDAO.selectNoticeMgmt(objMap);
    }
    
    @Override
    public Map<String, Object> insertNoticeMgmt(Map<String, Object> objMap) throws Exception {
    	Map<String, Object> dataMap = new HashMap< String, Object >();
    	int result = 0 ;
    	String seq = "";
    	try
    	{
    		result = noticeMgmtDAO.insertNoticeMgmt(objMap);
    		if(result > 0)
    		{
    			seq = String.valueOf( objMap.get( "seq" ) );
    			log.info( "success - seq"  + seq);
    			log.info( "success" );		
    			dataMap.put( "seq", seq );
    		}else{
    			log.info( "fail" );
    		}
    	}
    	catch(Exception e)
    	{
    		log.error( "Excpetion - " ,e );
    		result = -1;
    	}
    	dataMap.put( "result", result );
    	return dataMap;
    }
    
    @Override
    public Map<String, Object> updateNoticeMgmt(Map<String, Object> objMap) throws Exception {
    	Map<String, Object> dataMap = new HashMap< String, Object >();
    	int result = 0 ;
    	String seq = (String)objMap.get( "seq" );
    	try
    	{
	    	result = noticeMgmtDAO.updateNoticeMgmt(objMap);
	    	if(result > 0)
			{
				seq = String.valueOf( objMap.get( "seq" ) );
				log.info( "success - seq"  + seq);
				log.info( "success" );		
				dataMap.put( "seq", seq );
			}else{
				log.info( "fail" );
			}
    	}
    	catch(Exception e)
    	{
    		log.error( "Excpetion - " ,e );
    		result = -1;
    	}
    	dataMap.put( "result", result );
    	return dataMap;
    }
}