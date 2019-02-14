package egov.linkpay.ims.common.pg;

public class ResponseCancelAPI
{
	private String tXid;
	private String referenceNo;
	private String canceltXid;
	private String resultCd;
	private String resultMsg;
	private String transDt;
	private String transTm;
	private String description;
	private String amount;
	
	public String gettXid()
	{
		return tXid;
	}
	public void settXid( String tXid )
	{
		this.tXid = tXid;
	}
	public String getCanceltXid()
	{
		return canceltXid;
	}
	public void setCanceltXid( String canceltXid )
	{
		this.canceltXid = canceltXid;
	}
	public String getResultCd()
	{
		return resultCd;
	}
	public void setResultCd( String resultCd )
	{
		this.resultCd = resultCd;
	}
	public String getResultMsg()
	{
		return resultMsg;
	}
	public void setResultMsg( String resultMsg )
	{
		this.resultMsg = resultMsg;
	}
	public String getReferenceNo() {
		return referenceNo;
	}
	public void setReferenceNo(String referenceNo) {
		this.referenceNo = referenceNo;
	}
	public String getTransDt() {
		return transDt;
	}
	public void setTransDt(String transDt) {
		this.transDt = transDt;
	}
	public String getTransTm() {
		return transTm;
	}
	public void setTransTm(String transTm) {
		this.transTm = transTm;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
}
