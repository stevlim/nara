package egov.linkpay.ims.common.batch;

import java.math.BigInteger;
import java.util.List;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageDecoder;
import io.netty.handler.codec.CorruptedFrameException;

public class TimeDecoder extends ByteToMessageDecoder { // (1)
	private ByteBuf buff ;
	 
	@Override
	protected void decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out) throws Exception {
//		if (in.readableBytes() < 1024) {
//			System.out.println("1111111");
//            return; // (3)
//        }
//        System.out.println("22222");
//        out.add(in.readBytes(1024)); // (4)
		
//		if (in.readableBytes() > 500) {
//			System.out.println("111111");
//			in.markReaderIndex();
//			return;
//        }
//		System.out.println("22222221");
//		out.add(in.readBytes(in.readableBytes()));
		
		 // Wait until the length prefix is available.
//        if (in.readableBytes() < 1024) {
//            return;
//        }
//
//        in.markReaderIndex();
//
//       
//
//        // Wait until the whole data is available.
//        int dataLength = in.readInt();
//       
//
//        // Convert the received data into a new BigInteger.
//        byte[] decoded = new byte[dataLength];
//        in.readBytes(decoded);
//
//        out.add(new BigInteger(decoded));
		
//		if (in.readableBytes() < 1) {
//			buff.setBytes(buff.readableBytes(), in);
//			out.add(buff.readBytes(buff.readableBytes())); // (4)
//            return; // (3)
//        }
//        
//		ByteBuf test  = buff.alloc().buffer(buff.readableBytes() + in.readableBytes());
//		test.setBytes(buff.readableBytes(), in);
//		buff = test;
		
		
//		System.out.println("*********************************start");
//		System.out.println(in.readableBytes());
//		
//		if (in.readableBytes() < 2) {
//			out.add(in.readBytes(in.readableBytes()));	
//        }
//		
//		System.out.println("test1:");
//		if(buff == null){
//			buff = ctx.alloc().buffer(in.readableBytes());	
//		}else{
//			buff = ctx.alloc().buffer(buff.readableBytes() +  in.readableBytes());
//		}
//		
//		buff.writeBytes(in);
//		System.out.println("*********************************end");
//        return; // (3)
			
		out.add(in.readBytes(in.readableBytes()));
		
	}
}