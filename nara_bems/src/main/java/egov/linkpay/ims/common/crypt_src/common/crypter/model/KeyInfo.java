package egov.linkpay.ims.common.crypt_src.common.crypter.model;

import java.io.Serializable;

public class KeyInfo implements Serializable
{
	private String index = "";
	private String strDt = "";
	private String endDt = "";
	private String symKey = "";
	private String iv = "";

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getStrDt() {
		return strDt;
	}

	public void setStrDt(String strDt) {
		this.strDt = strDt;
	}

	public String getEndDt() {
		return endDt;
	}

	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}

	public String getSymKey() {
		return symKey;
	}

	public void setSymKey(String symKey) {
		this.symKey = symKey;
	}

	public String getIv() {
		return iv;
	}

	public void setIv(String iv) {
		this.iv = iv;
	}

}
