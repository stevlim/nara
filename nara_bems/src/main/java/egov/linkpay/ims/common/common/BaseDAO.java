package egov.linkpay.ims.common.common;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonDAO.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class BaseDAO {
    protected Log logger = LogFactory.getLog(BaseDAO.class);
     
    @Autowired
    private SqlSessionTemplate sqlSession;
     
    /**--------------------------------------------------
     * Method Name    : printQueryId
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    protected void printQueryId(String strQueryId) {
        if(logger.isDebugEnabled()) {
            logger.debug("QueryId \t:  " + strQueryId);
        }
    }

    /**--------------------------------------------------
     * Method Name    : insert
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Object insert(String strQueryId, Object objParams) {
        printQueryId(strQueryId);
        
        return sqlSession.insert(strQueryId, objParams);
    }
     
    /**--------------------------------------------------
     * Method Name    : update
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Object update(String strQueryId, Object objParams) {
        printQueryId(strQueryId);
        
        return sqlSession.update(strQueryId, objParams);
    }
     
    /**--------------------------------------------------
     * Method Name    : delete
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Object delete(String strQueryId, Object objParams) {
        printQueryId(strQueryId);
        
        return sqlSession.delete(strQueryId, objParams);
    }
    
    public Object delete(String strQueryId) {
        printQueryId(strQueryId);
        
        return sqlSession.delete(strQueryId);
    }
     
    /**--------------------------------------------------
     * Method Name    : selectOne
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Object selectOne(String strQueryId) {
        printQueryId(strQueryId);
        
        return sqlSession.selectOne(strQueryId);
    }
     
    /**--------------------------------------------------
     * Method Name    : selectOne
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Object selectOne(String strQueryId, Object objParams) {
        printQueryId(strQueryId);
        
        return sqlSession.selectOne(strQueryId, objParams);
    }
     
    /**--------------------------------------------------
     * Method Name    : selectList
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @SuppressWarnings("rawtypes")
    public List selectList(String strQueryId) {
        printQueryId(strQueryId);
        
        return sqlSession.selectList(strQueryId);
    }
     
    /**--------------------------------------------------
     * Method Name    : selectList
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    @SuppressWarnings("rawtypes")
    public List selectList(String strQueryId, Object objParams) {
        printQueryId(strQueryId);
        
        return sqlSession.selectList(strQueryId, objParams);
    }
}