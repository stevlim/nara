package egov.linkpay.ims.rmApproval.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.HistorySearchDAO;
import egov.linkpay.ims.rmApproval.dao.RmApprovalDAO;

@Service("rmApprovalService")
public class RmApprovalServiceImpl implements RmApprovalService
{
	Logger log = Logger.getLogger(this.getClass());
    
    @Resource(name="rmApprovalDAO")
    private RmApprovalDAO rmApprovalDAO;	
    
    @Resource(name="historySearchDAO")
    private HistorySearchDAO historySearchDAO;
    
    
    /* -----  newContComp controller  -------*/ 
    @Override
	public List<Map<String, Object>> selectContCompList(Map<String, Object> params) throws Exception{
    	return rmApprovalDAO.selectContCompList(params);
    };
	
    @Override
	public Object selectContCompListCnt(Map<String, Object> params) throws Exception{
    	return rmApprovalDAO.selectContCompListCnt(params);
    };
    
    /* -----  ApproveLimit  controller  -------*/
    @Override
    public List<Map<String, Object>> getContLimitList(Map<String, Object> params) throws Exception {
        return rmApprovalDAO.getContLimitList(params);
    }
    
    @Override
	public Map<String, Object> getContLimitDetail(Map<String, Object> params) throws Exception {
    	return rmApprovalDAO.getContLimitDetail(params);
    }
    
    @Override
    public List<Map<String, String>> getCateCodeList(Map<String, Object> params) throws Exception {
        return rmApprovalDAO.getCateCodeList(params);
    }
    
    @Override
    public List<Map<String, String>> getSubCateCodeList(Map<String, Object> params) throws Exception {
        return rmApprovalDAO.getSubCateCodeList(params);
    }
    
    @Override
	public int getContLimitDulicateCnt(Map<String, Object> params) throws Exception {
    	return rmApprovalDAO.getContLimitDulicateCnt(params);
    }
    
    @Override
	public int insContLimit(Map<String, Object> params) throws Exception {
		return rmApprovalDAO.insContLimit(params);
    }
    
    @Override
	public int insLimitNotiConfig(Map<String, Object> params) throws Exception {
		return rmApprovalDAO.insLimitNotiConfig(params);
    }
    
    @Override
	public int updateContLimit(Map<String, Object> params) throws Exception {
		return rmApprovalDAO.updateContLimit(params);
    }
    
    @Override
	public int upLimitNotiConfig(Map<String, Object> params) throws Exception {
		return rmApprovalDAO.upLimitNotiConfig(params);
    }
    
}
