package egov.linkpay.ims.common.pg;

import java.io.BufferedInputStream;
import java.io.PrintWriter;
import java.net.Socket;

public class TCPSocketClient {
	
	public static String send(String address, int port, String message) throws Exception{
		String responseMessage = null;
		
		/**
         * Create a connection to the server socket on the server application
         */
        Socket socket = new Socket(address, port);
        socket.setSoTimeout(30000);
        socket.setSendBufferSize(9999);

        /**
         * Send a message to the client application
         */

        PrintWriter oos = new PrintWriter(socket.getOutputStream(), true);
        oos.write(message);
        oos.flush();

        /**
         * Read and display the response message sent by server application
         */
        BufferedInputStream ois = new BufferedInputStream(socket.getInputStream(), 9999);
        byte[] buff = new byte[9999];
        ois.read(buff);
        responseMessage = new String(buff);

        ois.close();
        oos.close();
        socket.close();
		
		return responseMessage;
	}
}
