package egov.linkpay.ims.common.common;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
 
/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.common.common
 * File Name      : CommonMap.java
 * Description    : 
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class CommonMap {
    Map<String,Object> objMap = new HashMap<String,Object>();
     
    /**--------------------------------------------------
     * Method Name    : get
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Object get(String strKey) {
        return objMap.get(strKey);
    }
     
    /**--------------------------------------------------
     * Method Name    : put
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public void put(String strKey, Object objValue) {
        objMap.put(strKey, objValue);
    }
     
    /**--------------------------------------------------
     * Method Name    : remove
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Object remove(String strKey) {
        return objMap.remove(strKey);
    }
     
    /**--------------------------------------------------
     * Method Name    : containsKey
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public boolean containsKey(String strKey) {
        return objMap.containsKey(strKey);
    }
     
    /**--------------------------------------------------
     * Method Name    : containsValue
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public boolean containsValue(Object objValue) {
        return objMap.containsValue(objValue);
    }

    /**--------------------------------------------------
     * Method Name    : clear
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public void clear() {
        objMap.clear();
    }
     
    /**--------------------------------------------------
     * Method Name    : entrySet
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Set<Entry<String, Object>> entrySet() {
        return objMap.entrySet();
    }
     
    /**--------------------------------------------------
     * Method Name    : keySet
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Set<String> keySet() {
        return objMap.keySet();
    }
     
    /**--------------------------------------------------
     * Method Name    : isEmpty
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public boolean isEmpty() {
        return objMap.isEmpty();
    }
     
    /**--------------------------------------------------
     * Method Name    : putAll
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public void putAll(Map<? extends String, ?extends Object> m) {
        objMap.putAll(m);
    }
     
    /**--------------------------------------------------
     * Method Name    : getMap
     * Description    : 
     * Author         : ymjo, 2015. 10. 8.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    public Map<String,Object> getMap() {
        return objMap;
    }
}