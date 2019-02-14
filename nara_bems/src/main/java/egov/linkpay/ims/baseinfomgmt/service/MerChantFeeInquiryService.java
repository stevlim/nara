package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface MerChantFeeInquiryService
{
	//기본정보조회-승인대기리스트조회
	List<Map<String,Object>> selectMerFeeList(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-승인대기리스트count
	Object selectMerFeeListTotal(Map< String, Object > paramMap) throws Exception;
}
