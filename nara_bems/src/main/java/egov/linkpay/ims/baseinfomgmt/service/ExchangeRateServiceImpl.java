package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.ExchangeRateDAO;

@Service("exchangeRateService")
public class ExchangeRateServiceImpl implements ExchangeRateService
{
	@Resource(name="exchangeRateDAO")
	private ExchangeRateDAO exchangeRateDAO;
	
	public void insertExRate(Map<String, Object> changeMap) throws Exception{
		exchangeRateDAO.insertExRate(changeMap);
    }
	@Override
    public List<Map<String,Object>> selectExRate(Map< String, Object > paramMap) throws Exception {
    	return exchangeRateDAO.selectExRate( paramMap );
    }
	@Override
    public Object selectExRateTotal(Map< String, Object > paramMap) throws Exception {
    	return exchangeRateDAO.selectExRateTotal( paramMap );
    }
}
