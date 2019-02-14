package egov.linkpay.ims.loginout;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationListener;
import org.springframework.security.core.session.SessionDestroyedEvent;
import org.springframework.stereotype.Component;

import egov.linkpay.ims.common.common.CommonConstants;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.loginout.service.LogInOutService;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.loginout
 * File Name      : SessionEndedListener.java
 * Description    : session taimeout Listener
 * Author         : jjho, 2017. 02. 22.
 * Modify History : for PCI
 ------------------------------------------------------------*/

@Component
public class SessionEndedListener implements ApplicationListener<SessionDestroyedEvent>{
	
	@Resource(name="logInOutService")
    private LogInOutService logInOutService;
	
	@Override
	public void onApplicationEvent(SessionDestroyedEvent sessionDestroyedEvent) {
		
		Logger logger = Logger.getLogger(this.getClass());
		
		Map<String, Object> objMap = new HashMap<String, Object>();
		
		HttpSession session = (HttpSession)sessionDestroyedEvent.getSource();
		String usr_id = "";
		String worker_ip = ""; 
		
		if(session.getAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY) != null){
			usr_id = CommonUtils.getSessionInfo(session, "USR_ID");
			worker_ip = CommonUtils.getSessionInfo(session, "WORKER_IP");
			
			objMap.put("USR_ID", usr_id);
			objMap.put("WORKER_IP", worker_ip);
			
			try {
				logInOutService.insertLogoutLog(objMap);
			} catch (Exception e) {
				logger.debug("SessionEndedListener exception : " + e.getMessage());
			}
			
			logger.debug("logout : " + usr_id + ", worker_ip : " + worker_ip);
		}
		
		session.removeAttribute(CommonConstants.IMS_SESSION_LOGIN_KEY);
        session.removeAttribute(CommonConstants.IMS_SESSION_MENU_KEY);
        session.removeAttribute(CommonConstants.IMS_SESSION_PREV_PAGE_KEY);
		
		
	}

}

