package egov.linkpay.ims.common.batch;

import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;

public class TcpClient{

	// 메시지 사이즈를 결정합니다.
	static final int MESSAGE_SIZE = 256;
	private TcpClientHandler viewTcpClientHandler;
	
	public TcpClient(String msg, String host, int port) throws Exception {	
		EventLoopGroup group = new NioEventLoopGroup();
		final String sendMsg = msg;
		System.out.println("TcpClient Send:[" + msg + "]");
		viewTcpClientHandler = new TcpClientHandler(sendMsg);
		try{
			Bootstrap b = new Bootstrap();
			b.group(group)
			.channel(NioSocketChannel.class)
			.option(ChannelOption.TCP_NODELAY, true)
			.option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 1000)
			.handler(new ChannelInitializer<SocketChannel>() {
				@Override
				protected void initChannel(SocketChannel sc) throws Exception {
					ChannelPipeline cp = sc.pipeline();
					cp.addLast(new TimeDecoder(), viewTcpClientHandler);
				}
			});

			ChannelFuture cf = b.connect(host, port).sync();
			cf.channel().closeFuture().sync();
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			group.shutdownGracefully();
		
		}
	}

	public String getResult() {
		return viewTcpClientHandler.receiveMessage();
	}

}
