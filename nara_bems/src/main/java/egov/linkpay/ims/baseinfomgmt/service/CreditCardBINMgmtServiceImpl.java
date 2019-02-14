package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.CreditCardBINMgmtDAO;


@Service("creditCardBINMgmtService")
public class CreditCardBINMgmtServiceImpl implements CreditCardBINMgmtService
{
	@Resource(name="creditCardBINMgmtDAO")
    private CreditCardBINMgmtDAO creditCardBINMgmtDAO;	
	
	
	@Override
    public List<Map<String, Object>> selectAppLmtList(Map< String, Object > paramMap) throws Exception {
        return creditCardBINMgmtDAO.selectAppLmtList(paramMap);
    }
	@Override
    public Object selectAppLmtListTotal(Map< String, Object > paramMap) throws Exception {
        return creditCardBINMgmtDAO.selectAppLmtListTotal(paramMap);
    }
	
	@Override
    public List<Map<String, Object>> selectCreditCardBINSearch(Map< String, Object > paramMap) throws Exception {
        return creditCardBINMgmtDAO.selectCreditCardBINSearch(paramMap);
    }
	@Override
    public Object selectCreditCardBINSearchTotal(Map< String, Object > paramMap) throws Exception {
        return creditCardBINMgmtDAO.selectCreditCardBINSearchTotal(paramMap);
    }
}
