package egov.linkpay.ims.common.batch;

public class clientStart {

	public static void main(String[] args) {
		try {	
			TcpClient tcpClient = new TcpClient("1,STOP", "127.0.0.1", 2211);
			System.out.println(tcpClient.getResult());  //000
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
