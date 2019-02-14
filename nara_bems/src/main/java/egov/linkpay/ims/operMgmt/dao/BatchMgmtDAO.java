package egov.linkpay.ims.operMgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("batchMgmtDAO")
public class BatchMgmtDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectBatchJobList(Map<String, Object> objMap) throws Exception {
        return selectList("batchMgmt.selectBatchJobList", objMap);
    }
	public int selectBatchJobListTotal(Map<String, Object> objMap) throws Exception {
        return (Integer)selectOne("batchMgmt.selectBatchJobListTotal", objMap);
    }
	//batch job insert
	public int insertBatchJob(Map<String, Object> objMap) throws Exception {
        return (Integer)insert("batchMgmt.insertBatchJob", objMap);
    }
	//batch job update
	public int updateBatchJob(Map<String, Object> objMap) throws Exception {
        return (Integer)update("batchMgmt.updateBatchJob", objMap);
    }
	//batch job useType update
	public int updateUseType(Map<String, Object> objMap) throws Exception {
        return (Integer)update("batchMgmt.updateUseType", objMap);
    }
	//batch job Info
	public Object selectBatchJobInfo(Map<String, Object> objMap) throws Exception {
        return selectOne("batchMgmt.selectBatchJobInfo", objMap);
    }
	
	//BATCH JOB HIST
	@SuppressWarnings( "unchecked" )
	public List<Map<String,Object>> selectBatchJobHistList(Map<String, Object> objMap) throws Exception {
        return selectList("batchMgmt.selectBatchJobHistList", objMap);
    }
	public int selectBatchJobHistListTotal(Map<String, Object> objMap) throws Exception {
        return (Integer)selectOne("batchMgmt.selectBatchJobHistListTotal", objMap);
    }
	
	public int updateRetryCnt(Map<String, Object> objMap) throws Exception {
        return (Integer)update("batchMgmt.updateRetryCnt", objMap);
    }
}
