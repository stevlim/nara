package egov.linkpay.ims.common.pg;

public class RequestCancelAPI
{
	private String tXid;
	private String iMid;
	private String payMethod;
	private String amt;
	private String fee;
	private String vat;
	private String notaxAmt;
	private String cancelType;
	private String cancelMsg;
	private String cancelServerIp;
	private String cancelUserId;
	private String cancelUserIp;
	private String cancelUserInfo;
	private String cancelRetryCnt;
	private String worker;
	private String merchantToken; 
	
	
	public String gettXid()
	{
		return tXid;
	}
	public void settXid( String tXid )
	{
		this.tXid = tXid;
	}
	public String getiMid()
	{
		return iMid;
	}
	public void setiMid( String iMid )
	{
		this.iMid = iMid;
	}
	public String getPayMethod()
	{
		return payMethod;
	}
	public void setPayMethod( String payMethod )
	{
		this.payMethod = payMethod;
	}
	public String getAmt()
	{
		return amt;
	}
	public void setAmt( String amt )
	{
		this.amt = amt;
	}
	public String getCancelType()
	{
		return cancelType;
	}
	public void setCancelType( String cancelType )
	{
		this.cancelType = cancelType;
	}
	public String getCancelMsg()
	{
		return cancelMsg;
	}
	public void setCancelMsg( String cancelMsg )
	{
		this.cancelMsg = cancelMsg;
	}
	public String getCancelServerIp()
	{
		return cancelServerIp;
	}
	public void setCancelServerIp( String cancelServerIp )
	{
		this.cancelServerIp = cancelServerIp;
	}
	public String getCancelUserId()
	{
		return cancelUserId;
	}
	public void setCancelUserId( String cancelUserId )
	{
		this.cancelUserId = cancelUserId;
	}
	public String getCancelUserIp()
	{
		return cancelUserIp;
	}
	public void setCancelUserIp( String cancelUserIp )
	{
		this.cancelUserIp = cancelUserIp;
	}
	public String getCancelUserInfo()
	{
		return cancelUserInfo;
	}
	public void setCancelUserInfo( String cancelUserInfo )
	{
		this.cancelUserInfo = cancelUserInfo;
	}
	public String getCancelRetryCnt()
	{
		return cancelRetryCnt;
	}
	public void setCancelRetryCnt( String cancelRetryCnt )
	{
		this.cancelRetryCnt = cancelRetryCnt;
	}
	public String getWorker()
	{
		return worker;
	}
	public void setWorker( String worker )
	{
		this.worker = worker;
	}
	public String getFee()
	{
		return fee;
	}
	public void setFee( String fee )
	{
		this.fee = fee;
	}
	public String getVat()
	{
		return vat;
	}
	public void setVat( String vat )
	{
		this.vat = vat;
	}
	public String getNotaxAmt()
	{
		return notaxAmt;
	}
	public void setNotaxAmt( String notaxAmt )
	{
		this.notaxAmt = notaxAmt;
	}
	public String getMerchantToken() {
		return merchantToken;
	}
	public void setMerchantToken(String merchantToken) {
		this.merchantToken = merchantToken;
	}
}
