package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.CreditCardVANMgmtDAO;

@Service("creditCardVANMgmtService")
public class CreditCardVANMgmtServiceImpl implements CreditCardVANMgmtService
{
	@Resource(name="creditCardVANMgmtDAO")
    private CreditCardVANMgmtDAO creditCardVANMgmtDAO;	
	
	@Override
    public List<Map<String, Object>> selectVanList(Map< String, Object > paramMap) throws Exception {
        return creditCardVANMgmtDAO.selectVanList(paramMap);
    }
	@Override
    public List<Map<String, Object>> selectVanInfoList(Map< String, Object > paramMap) throws Exception {
        return creditCardVANMgmtDAO.selectVanInfoList(paramMap);
    }@Override
    public Object selectVanInfoListTotal(Map< String, Object > paramMap) throws Exception {
        return creditCardVANMgmtDAO.selectVanInfoListTotal(paramMap);
    }
}
