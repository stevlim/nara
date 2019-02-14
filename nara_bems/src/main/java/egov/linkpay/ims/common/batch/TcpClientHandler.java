package egov.linkpay.ims.common.batch;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.handler.timeout.ReadTimeoutException;

public class TcpClientHandler extends ChannelInboundHandlerAdapter{

	// SLF4J를 이용한 Logger 오브젝트 생성
//	private static final Logger LOGGER = LoggerFactory.getLogger(TcpClientHandler.class);
	
	private final ByteBuf message;
	private final String sendMsg;
	private String recvMsg;
	
	byte[] recvBytes = new byte[0];
	
	
	boolean isRequested = false;
	StringBuffer sb = new StringBuffer();
	
	
	// 초기화
	public TcpClientHandler(){
		message = Unpooled.buffer(TcpClient.MESSAGE_SIZE);
		sendMsg = "";
		recvMsg = "";
	}
	
	// 초기화
	public TcpClientHandler(String msg){
		message = Unpooled.buffer(msg.getBytes().length);
		sendMsg = msg;
		recvMsg = "";
//		LOGGER.debug("EchoClientHandler writeBytes*****");
	}
	
	public void sendMsg(String msg){
		byte[] str = msg.getBytes();
//		LOGGER.debug("sendMsg writeBytes*****");
		// 예제 바이트 배열을 메시지에 씁니다.
		message.writeBytes(str);
	}

	// 채널이 활성화 되면 동작할 코드를 정의합니다.
	@Override
	public void channelActive(ChannelHandlerContext ctx) throws Exception {
//		LOGGER.debug("view channelActive*****");
		message.writeBytes(sendMsg.getBytes());
		
		// 메시지를 쓴 후 플러쉬합니다.
		ctx.writeAndFlush(message);
	}

	@Override
	public void channelRead(ChannelHandlerContext ctx, Object msg)throws Exception {
		ByteBuf buf = (ByteBuf) msg;
//		LOGGER.debug("CardServerHandler channelRead:[{}]",buf.readableBytes());
		try {
			int currentPosition = recvBytes.length;
			byte[] tmpByte = new byte[currentPosition];
			
			System.arraycopy(recvBytes, 0, tmpByte, 0, recvBytes.length);
			recvBytes = new byte[currentPosition+buf.readableBytes()];
			System.arraycopy(tmpByte, 0, recvBytes, 0, tmpByte.length);
			
			while (buf.isReadable()) {  
				recvBytes[currentPosition] = buf.readByte();
				currentPosition++;
	        }
			
		} finally {
			
	    }

	}

	@Override
	public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
//		LOGGER.debug("EchoClientHandler Receive Data<--[]");
//		LOGGER.debug("[{}]", sb.toString());
		if(!isRequested){
			isRequested = true;
			String test = new String (recvBytes, "UTF-8");//			LinkPayVO rcvLPV = sm.makeReceiveMessage(sb.toString(), xmlConverter);
			
//			LOGGER.debug("Recv Result : {}",  test);
			recvMsg = test;
			ctx.flush(); // 컨텍스트의 내용을 플러쉬합니다.
			ctx.close();	
		}
	}

	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
		if(cause instanceof ReadTimeoutException){
//			LOGGER.debug("소켓 시간이 초과 되었습니다.");
			System.out.println("소켓 시간이 초과 되었습니다.");
		}
		
		cause.printStackTrace();
		ctx.close();	
	}

	public String receiveMessage() {
		// TODO Auto-generated method stub
		return recvMsg;
	}
	

}
