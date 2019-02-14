package egov.linkpay.ims.common.pg;

import java.io.IOException;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

//import org.codehaus.jackson.JsonProcessingException;
//import org.codehaus.jackson.map.ObjectMapper;


/**
 * 응답 API 공통 클래스
 * @author Administrator
 *
 */
public class ResponseApiInfo {
	/**
	 * API 종류
	 * M0 : 주문등록, M1 : 주문확인, A1 : 신용카드결제
	 * C1 : 취소, C2 : 부분취소, T1 : 가상계좌 채번
	 */
	private String apiType;
	/**
	 * TID
	 */
	private String tXid;
	/**
	 * 요청 시간
	 */
	private String requestDate;
	/**
	 * 응답 시간
	 */
	private String responseDate;
	/**
	 * 전문 데이터
	 */
	private Map<Object, Object> data;
	
	/**
	 * json string convert
	 * @return
	 * @throws IOException 
	 */
	public String toJsonString() throws IOException {
		ObjectMapper mapper = new ObjectMapper();
		String json =  mapper.writeValueAsString(this);
		String message = String.format("%04d", json.length());
		message += json;
		return message;
	}
	
	public String getApiType() {
		return apiType;
	}
	public void setApiType(String apiType) {
		this.apiType = apiType;
	}
	public String getRequestDate() {
		return requestDate;
	}
	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}
	public String getResponseDate() {
		return responseDate;
	}
	public void setResponseDate(String responseDate) {
		this.responseDate = responseDate;
	}
	public Map<Object, Object> getData() {
		return data;
	}
	public void setData(Map<Object, Object> data) {
		this.data = data;
	}
	public String gettXid()
	{
		return tXid;
	}
	public void settXid( String tXid )
	{
		this.tXid = tXid;
	}
}
