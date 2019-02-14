package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.MerchantFeeInquiryDAO;

@Service("merchantFeeInquiryService")
public class MerchantFeeInquiryServiceImpl implements MerChantFeeInquiryService
{
	@Resource(name="merchantFeeInquiryDAO")
	MerchantFeeInquiryDAO merchantFeeInquiryDAO;
	
	@Override
    public List<Map<String,Object>> selectMerFeeList(Map< String, Object > paramMap) throws Exception {
    	return merchantFeeInquiryDAO.selectMerFeeList( paramMap );
    }
    @Override
    public Object selectMerFeeListTotal(Map< String, Object > paramMap) throws Exception {
    	return merchantFeeInquiryDAO.selectMerFeeListTotal( paramMap );
    }
}
