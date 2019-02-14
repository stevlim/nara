package egov.linkpay.ims.businessmgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("pwdDelDAO")
public class PwdDelDAO extends BaseDAO
{
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectPWDList(Map<String, Object> objMap) throws Exception {
        return selectList("pwdDel.selectPWDList", objMap);
    }
	public Object selectPWDListTotal(Map<String, Object> objMap) throws Exception {
        return selectOne("pwdDel.selectPWDListTotal", objMap);
    }
	public void updatePwdInit(Map<String, Object> objMap) throws Exception {
        update("pwdDel.updatePwdInit", objMap);
    }
	public void updateChangeCcPw(Map<String, Object> objMap) throws Exception {
        update("pwdDel.updateChangeCcPw", objMap);
    }
}
