package egov.linkpay.ims.operMgmt.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.BaseInfoRegistrationDAO;
import egov.linkpay.ims.calcuMgmt.dao.AgentMgmtDAO;
import egov.linkpay.ims.operMgmt.dao.BatchMgmtDAO;

@Service("batchMgmtService")
public class BatchMgmtServiceImpl implements BatchMgmtService
{
	Logger log = Logger.getLogger(this.getClass());
    
	@Resource(name="batchMgmtDAO")
    private BatchMgmtDAO batchMgmtDAO;
	
	public List<Map<String,Object> > selectBatchJobList(Map<String,Object> paramMap) throws Exception{
		return batchMgmtDAO.selectBatchJobList(paramMap);
	}
	public Integer selectBatchJobListTotal(Map<String,Object> paramMap) throws Exception{
		return batchMgmtDAO.selectBatchJobListTotal(paramMap);
	}
	//batch job insert
	public Integer insertBatchJob(Map<String,Object> paramMap) throws Exception{
		return batchMgmtDAO.insertBatchJob(paramMap);
	}
	//batch job update
	public Integer updateBatchJob(Map<String,Object> paramMap) throws Exception{
		return batchMgmtDAO.updateBatchJob(paramMap);
	}
	//batch job useType update
	public Integer updateUseType(Map<String,Object> paramMap) throws Exception{
		return batchMgmtDAO.updateUseType(paramMap);
	}
	//batch job info 
	public Map<String,Object> selectBatchJobInfo(Map<String,Object> paramMap) throws Exception{
		return (Map<String,Object>)batchMgmtDAO.selectBatchJobInfo(paramMap);
	}
	
	//BATCH JOB HIST
	public List<Map<String,Object> > selectBatchJobHistList(Map<String,Object> paramMap) throws Exception{
		return batchMgmtDAO.selectBatchJobHistList(paramMap);
	}
	public Integer selectBatchJobHistListTotal(Map<String,Object> paramMap) throws Exception{
		return batchMgmtDAO.selectBatchJobHistListTotal(paramMap);
	}
	
	public Integer updateRetryCnt(Map<String,Object> paramMap) throws Exception{
		int cnt = Integer.parseInt( paramMap.get( "retryCnt" ).toString() ) + 1;
		paramMap.put( "retryCnt", cnt );
		return batchMgmtDAO.updateRetryCnt(paramMap);
	}
}
