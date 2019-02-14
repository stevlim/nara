package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("merchantFeeInquiryDAO")
public class MerchantFeeInquiryDAO extends BaseDAO
{
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectMerFeeList(Map< String, Object > paramMap) throws Exception {
		return selectList("merchantFeeInquiry.selectMerFeeList", paramMap);
    }
	public Object selectMerFeeListTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne( "merchantFeeInquiry.selectMerFeeListTotal", paramMap);
    }
}
