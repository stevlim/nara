package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("exchangeRateDAO")
public class ExchangeRateDAO extends BaseDAO
{
	public void insertExRate(Map< String, Object > dataMap) throws Exception {
		insert("exchangeRate.insertExRate", dataMap);
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectExRate(Map< String, Object > paramMap) throws Exception {
		return selectList( "exchangeRate.selectExRate", paramMap);
    }
	public Object selectExRateTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne( "exchangeRate.selectExRateTotal", paramMap);
    }
}
