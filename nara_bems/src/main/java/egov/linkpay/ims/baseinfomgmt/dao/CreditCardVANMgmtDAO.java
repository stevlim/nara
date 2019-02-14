package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("creditCardVANMgmtDAO")
public class CreditCardVANMgmtDAO extends BaseDAO
{
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVanList(Map< String, Object > paramMap) throws Exception {
		return selectList("creditCardVANMgmt.selectVanList", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectVanInfoList(Map< String, Object > paramMap) throws Exception {
		return selectList("creditCardVANMgmt.selectVanInfoList", paramMap);
    }
	public Object selectVanInfoListTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("creditCardVANMgmt.selectVanInfoListTotal", paramMap);
    }
}
