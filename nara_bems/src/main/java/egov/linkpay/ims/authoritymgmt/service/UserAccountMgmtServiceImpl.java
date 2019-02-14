package egov.linkpay.ims.authoritymgmt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.authoritymgmt.dao.UserAccountMgmtDAO;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.authoritymgmt.service
 * File Name      : UserAccountMgmtServiceImpl.java
 * Description    : 권한관리 - 사용자관리
 * Author         : ymjo, 2015. 10. 8.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Service("userAccountMgmtService")
public class UserAccountMgmtServiceImpl implements UserAccountMgmtService{
    Logger logger = Logger.getLogger(this.getClass());

    @Resource(name="userAccountMgmtDAO")
    private UserAccountMgmtDAO userAccountMgmtDAO;

    @Autowired
    private JavaMailSender mailSender;

    @Override
    public List<Map<String, Object>> selectUserAccountMgmtList(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectUserAccountMgmtList(objMap);
    }

    @Override
    public List<Map<String, Object>> selectMenuAuthList(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectMenuAuthList(objMap);
    }

    @Override
    public List<Map<String, Object>> selectMerchantMgmtList() throws Exception {
        return userAccountMgmtDAO.selectMerchantMgmtList();
    }

    @Override
    public Object selectUserID(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectUserID(objMap);
    }

    @Override
    public void insertUserAccountMgmt(Map<String, Object> objMap) throws Exception {
        int intUserType = 0;

        //intUserType = Integer.parseInt(objMap.get("USR_TYPE").toString());
       
        userAccountMgmtDAO.insertUserAccountMgmt(objMap);
        userAccountMgmtDAO.insertUserIMID(objMap);

    }

    @Override
    public void updateUserPSWD(Map<String, Object> objMap) throws Exception {
    	/*String fromMail = "parkDev153@gmail.com";
    	String toMail = objMap.get("EMAIL").toString();
    	String title = "초기화 비밀번호입니다.";
    	String rndPwd = objMap.get("DE_PSWD").toString();

    	MimeMessage message = mailSender.createMimeMessage();
    	MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
    	messageHelper.setFrom(fromMail);
    	messageHelper.setTo(toMail);
    	messageHelper.setSubject(title);
    	messageHelper.setText(rndPwd);

    	mailSender.send(message);*/
        userAccountMgmtDAO.updateUserPSWD(objMap);
    }

    @Override
    public Object selectUserAccount(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectUserAccount(objMap);
    }

    @Override
    public Object selectUserIMIDs(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectUserIMIDs(objMap);
    }

    @Override
    public Object selectUserMERNMs(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectUserMERNMs(objMap);
    }

    @Override
    public void updateUserAccountMgmt(Map<String, Object> objMap) throws Exception {
        int intUserType = 0;
        String[] strArrMerchantList = null;
        //등록된 가맹점 리스트가 존재할때
        if(objMap.get("MERCHANTIDLIST").toString().length() > 0){
        	strArrMerchantList = objMap.get("MERCHANTIDLIST").toString().split(",");
        }
        
        //intUserType = Integer.parseInt(objMap.get("USR_TYPE").toString());
              
        userAccountMgmtDAO.updateUserAccountMgmt(objMap);
        //userAccountMgmtDAO.deleteUsrAuthDtl(objMap);
     
        if(objMap.get("MERCHANTIDLIST").toString().length() > 0){   
            for(String str : strArrMerchantList){
            	objMap.put("MERCHANTIDLIST", str);
            	userAccountMgmtDAO.insertUserIMID(objMap);
            }
     	}
        
    }

    @Override
    public Object selectUserIMIDsCount(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectUserIMIDsCount(objMap);
    }

    @Override
    public Object selectUserAccountMgmtListCnt(Map<String, Object> objMap) throws Exception {
        return userAccountMgmtDAO.selectUserAccountMgmtListCnt(objMap);
    }
    
    @Override
	public void insertPwInitSendMail(Map< String, Object > objMap) throws Exception{
		userAccountMgmtDAO.insertPwInitSendMail(objMap);
	}

}
