package egov.linkpay.ims.common.common;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

public class PayProp {
	
	static Logger logger = Logger.getLogger(PayProp.class);
	
	private static PayProp instance;
	private static Properties properties;

	private static final String PROP_LOCAL = "/properties/local.properties";
	private static final String PROP_DEV   = "/properties/dev.properties";
	private static final String PROP_REAL1 = "/properties/real1.properties";

	private PayProp() {
		System.out.println("call EagerInitialization constructor.");
	}

	public static String getProp(String key) {
		if (instance == null) {
			synchronized (PayProp.class) {
				if (instance == null) {
					instance = new PayProp();
				}
			}
		}

		if (properties == null) {
			String system_mode = System.getProperty("system_mode");
			logger.info("system_mode == [" + system_mode + "]");
			String prop_path = "";
			
			if(system_mode == null || "".equals(system_mode) || "LOCAL".equals(system_mode)){
				prop_path = PROP_LOCAL;
			}if("REAL1".equals(system_mode)){
				prop_path = PROP_REAL1;				
			}else if("DEV".equals(system_mode)){
				prop_path = PROP_DEV;
			}
			
			ClassLoader clazzLoader = Thread.currentThread().getContextClassLoader();
			InputStream inputStream = clazzLoader.getResourceAsStream(prop_path);
			properties = new Properties();
			try {
				properties.load(inputStream);
				inputStream.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		String value = (String)properties.get(key);
		
		if(value == null){
			value = "";
		}
		
		return value;
	}

}
