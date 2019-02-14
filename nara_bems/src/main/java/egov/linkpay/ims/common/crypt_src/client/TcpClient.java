package egov.linkpay.ims.common.crypt_src.client;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ConnectException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.SocketException;
import java.net.SocketTimeoutException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;


@Service("TcpClient")
public class TcpClient {
	private final Logger logger = LoggerFactory.getLogger("KMS");
	
	public String send(String address, int port, String message, int timeout) throws Exception {
		String responseMessage = null;
		Socket socket = null;
		PrintWriter oos = null;
		BufferedInputStream ois = null;
		BufferedReader br = null;
		InputStreamReader isr = null;
		boolean isException = false;
		// it declare that Object Variables use into Mutex
		Object lock = new Object();
		//
		// Create a connection to the server socket on the server application
		//
		synchronized (lock) {
			try {
				SocketAddress socketAddress = new InetSocketAddress(address, port);
				socket = new Socket();
				socket.setReceiveBufferSize(4098);
				socket.setSendBufferSize(message.length());
				socket.setKeepAlive(true);
				socket.setSoLinger(true, 0);
				socket.connect(socketAddress,
						timeout); /* socket connection timeout */
				socket.setSoTimeout(timeout);
				// socket = new Socket( address, port );

				//
				// Send a message to the client application
				//
				oos = new PrintWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"));
				oos.write(message);
				oos.flush();
				/*
				 * while(oos.checkError()){ logger.info(
				 * "Client Request checkError : " + oos.checkError() );
				 * oos.write( message + "\r\n" ); oos.flush(); }
				 */
				// logger.info("[RESULT|CLIENT|START] Client Request : "
				// + (message != null ? Util.cardInfoMasking(message) :
				// message));

				isr = new InputStreamReader(socket.getInputStream(), "UTF-8");
				br = new BufferedReader(isr);
				String str = "";
				responseMessage = "";
				/*
				 * int count = 0; while(!br.ready()){ //15초 loop out if(count >=
				 * 150) break; Thread.sleep(100); logger.info(
				 * "Client Response ready : " + count + " " + br.ready() );
				 * count++; }
				 */

				while ((str = br.readLine()) != null) {
					responseMessage += str;
				}

				/*
				 * while(br.ready()){ while ((str = br.readLine()) != null) {
				 * responseMessage += str; } }
				 */

				/*
				 * ois = new BufferedInputStream( socket.getInputStream() );
				 * byte[] buff = new byte[ 8192 ]; ois.read( buff );
				 * responseMessage += "\r\n"; responseMessage = new String(
				 * buff, "UTF-8" ).trim();
				 */
				// logger.info("[RESULT|CLIENT|END] Client Response : "
				// + (responseMessage != null ?
				// Util.cardInfoMasking(responseMessage) : message));
			} catch (SocketTimeoutException socketEx) {
				logger.error("TCPSocketClient SocketTimeoutException", socketEx);
				throw socketEx;
			} catch (ConnectException connectEx) {
				logger.error("TCPSocketClient ConnectException", connectEx);
				// isException = true;
				throw connectEx;
			} catch (SocketException socketEx) {
				logger.error("TCPSocketClient SocketException", socketEx);
			} catch (Exception e) {
				logger.error("TCPSocketClient Exception", e);
				// isException = true;
				throw e;
			} finally {
				if (isr != null)
					isr.close();
				if (br != null)
					br.close();
				/*
				 * if ( ois != null ) ois.close();
				 */
				if (oos != null)
					oos.close();
				if (socket != null)
					socket.close();

				if ("Message Cracked.".equals(responseMessage) || isException == true) {
					for (int i = 0; i < 3; i++) {
						Thread.sleep(1000);

						responseMessage = retrySend(address, port, message);

						if (!"Message Cracked.".equals(responseMessage)) {
							return responseMessage;
						}
					}

					logger.info("[RESULT|RETRY|DONE] Retry Failed... ");
				}
			}
		}

		return responseMessage;
	}
	

	public String retrySend(String address, int port, String message) throws Exception {
		String responseMessage = null;
		Socket socket = null;
		PrintWriter oos = null;
		OutputStreamWriter osr = null;
		// BufferedInputStream ois = null;
		BufferedReader br = null;
		InputStreamReader isr = null;
		boolean isException = false;
		// it declare that Object Variables use into Mutex
		Object lock = new Object();
		synchronized (lock) {
			try {
				//
				// Create a connection to the server socket on the server
				// application
				//
				SocketAddress socketAddress = new InetSocketAddress(address, port);
				socket = new Socket();
				socket.setReceiveBufferSize(4098);
				socket.setSendBufferSize(message.length());
				socket.setKeepAlive(true);
				socket.setSoLinger(true, 0);
				socket.connect(socketAddress,
						30000); /* socket connection timeout */
				socket.setSoTimeout(30000);
				// socket = new Socket( address, port );
				// socket.setKeepAlive(true);

				//
				// Send a message to the client application
				//
				osr = new OutputStreamWriter(socket.getOutputStream(), "UTF-8");
				oos = new PrintWriter(osr);
				oos.write(message);
				oos.flush();
				/*
				 * while(oos.checkError()){ logger.info(
				 * "Client Request checkError : " + oos.checkError() );
				 * oos.close(); osr = new OutputStreamWriter(
				 * socket.getOutputStream(), "UTF-8" ); oos = new PrintWriter(
				 * osr ); oos.write( message + "\r\n" ); } oos.flush();
				 */
				logger.info("[RESULT|RETRY|START] Client Request : " + message);
				//
				// Read and display the response message sent by server
				// application
				//
				isr = new InputStreamReader(socket.getInputStream(), "UTF-8");
				br = new BufferedReader(isr);
				String str = "";
				responseMessage = "";

				/*
				 * int count = 0; while(!br.ready()){ //15초 loop out if(count >=
				 * 300) break; Thread.sleep(100); logger.info(
				 * "Client Response ready : " + count + " " + br.ready() );
				 * count++; }
				 */
				while ((str = br.readLine()) != null) {
					responseMessage += str;
				}

				/*
				 * ois = new BufferedInputStream( socket.getInputStream() );
				 * byte[] buff = new byte[ 8192 ]; ois.read( buff );
				 * responseMessage += "\r\n"; responseMessage = new String(
				 * buff, "UTF-8" ).trim();
				 */
				// responseMessage = new String( buff, "UTF-8" ).trim();
				logger.info("[RESULT|RETRY|END] Client Response : " + responseMessage);
			} catch (SocketTimeoutException socketEx) {
				logger.error("TCPSocketClient Retry SocketTimeoutException", socketEx);
				// throw socketEx;
				isException = true;
			} catch (ConnectException connectEx) {
				logger.error("TCPSocketClient Retry ConnectException", connectEx);
				// throw connectEx;
				isException = true;
			} catch (Exception e) {
				logger.error("TCPSocketClient Retry Exception", e);
				// throw e;
				isException = true;
			} finally {
				if (isr != null)
					isr.close();
				if (br != null)
					br.close();
				/*
				 * if ( ois != null ) ois.close();
				 */
				if (oos != null)
					oos.close();
				if (socket != null)
					socket.close();

				if (isException == true) {
					return "Message Cracked.";
				}
			}
		}

		return responseMessage;
	}
	
}