package egov.linkpay.ims.operMgmt.dao;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("operMgmtDAO")
public class OperMgmtDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	public Object selectCntRcptOrgTid(Map<String, Object> objMap) throws Exception {
        return selectOne("operMgmt.selectCntRcptOrgTid", objMap);
    }
	public Object insertFailCashReReq(Map<String, Object> objMap) throws Exception {
        return insert("operMgmt.insertFailCashReReq", objMap);
    }
}
