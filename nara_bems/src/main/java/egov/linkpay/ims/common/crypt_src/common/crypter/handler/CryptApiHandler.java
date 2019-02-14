package egov.linkpay.ims.common.crypt_src.common.crypter.handler;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import egov.linkpay.ims.common.common.PayProp;
import egov.linkpay.ims.common.crypt_src.client.TcpClient;


@Component
@Qualifier("CryptApiHandler")
public class CryptApiHandler {

	String cryptServerIp;
	int cryptServerPort;
	int cryptServerTimeout;
	
	// Front Handler
	public HashMap doProcess(HashMap request) throws Exception {
		String response = "";
//		NiceApiMessageUtil parser = new NiceApiMessageUtil();
		TcpClient tcpClient = new TcpClient();

		ObjectMapper mapper = new ObjectMapper();
		String req = mapper.writeValueAsString(request);

		response = tcpClient.send((String)request.get("kms_ip"), Integer.parseInt((String)request.get("kms_port")), req, Integer.parseInt((String)request.get("kms_timeout")));
//		response = tcpClient.send("192.168.0.7", 22022, req, 5000);

		return mapper.readValue(response, HashMap.class);

	}
}