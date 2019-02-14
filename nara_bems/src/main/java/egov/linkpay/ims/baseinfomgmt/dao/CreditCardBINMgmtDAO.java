package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("creditCardBINMgmtDAO")
public class CreditCardBINMgmtDAO extends BaseDAO
{
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectAppLmtList(Map< String, Object > paramMap) throws Exception {
		return selectList("creditCardBINMgmt.selectAppLmtList", paramMap);
    }
	public Object selectAppLmtListTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("creditCardBINMgmt.selectAppLmtListTotal", paramMap);
    }
	
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectCreditCardBINSearch(Map< String, Object > paramMap) throws Exception {
		return selectList("creditCardBINMgmt.selectCreditCardBINSearch", paramMap);
    }
	public Object selectCreditCardBINSearchTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne("creditCardBINMgmt.selectCreditCardBINSearchTotal", paramMap);
    }
}
