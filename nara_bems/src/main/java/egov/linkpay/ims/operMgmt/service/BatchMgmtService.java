package egov.linkpay.ims.operMgmt.service;

import java.util.List;
import java.util.Map;

public interface BatchMgmtService
{
	List<Map<String,Object> > selectBatchJobList(Map<String,Object> paramMap) throws Exception;
	Integer selectBatchJobListTotal(Map<String,Object> paramMap) throws Exception;
	//batch job insert
	Integer insertBatchJob(Map<String,Object> paramMap) throws Exception;
	//batch job update
	Integer updateBatchJob(Map<String,Object> paramMap) throws Exception;
	Integer updateUseType(Map<String,Object> paramMap) throws Exception;
	Map<String,Object> selectBatchJobInfo(Map<String,Object> paramMap) throws Exception; 
	
	//BATCH JOB HIST]
	List<Map<String,Object> > selectBatchJobHistList(Map<String,Object> paramMap) throws Exception;
	Integer selectBatchJobHistListTotal(Map<String,Object> paramMap) throws Exception;
	
	Integer updateRetryCnt(Map<String,Object> paramMap) throws Exception;
}
