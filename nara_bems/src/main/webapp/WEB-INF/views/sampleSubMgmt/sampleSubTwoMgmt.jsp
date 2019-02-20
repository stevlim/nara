<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<script type="text/javascript">

$(document).ready(function(){
	
	$("#hdingpgNm").text("Energy Inquiry (Sample Sub 02)");
	
    //fnInitEvent();
    //fnSetDDLB();
    //fnEditFaqMgmt();
});

/**------------------------------------------------------------
* FAQ 등록/수정
------------------------------------------------------------*/
function fnEditFaqMgmt() {
    alert("123123213123777777");
        var editMode = "insert";
        
		// 구분 - CTGR : division
		// 표시 - NOTI_TYPE : flag
		// Question - TITLE : TITLE 
		// Ask - BODY : $("#MEMO_EDITOR").data("wysihtml5").editor.getValue();
		arrParameter = {
	        "CTGR" 		 : "26",
	        "NOTI_TYPE"  : "26",
	        "TITLE"      : "26",
	        "BODY"       : "23",
	        "SEQ_NO"     : "23",
        };
		//"STATUS"	 : $.trim($("#STATUS").val()),
        strCallUrl  = (editMode == "insert" ? "/sampleMgmt/sampleOneMgmt/insertFaqMgmt.do" : "/sampleMgmt/sampleOneMgmt/updateFaqMgmt.do");
        strCallBack = "fnEditFaqMgmtRet";
         
        IONPay.Ajax.fnRequest(arrParameter, strCallUrl, strCallBack);
    
}

function fnEditFaqMgmtRet(objJson) {
    if (objJson.resultCode == 0) {
        IONPay.Utils.fnClearHideForm();
        fnFaqMgmtListDT();
    } else {
        IONPay.Msg.fnAlert(objJson.resultMessage);      
    }
}

</script>

<!-- Sample Sub 02 -->
<div class="transpg">
	<ul class="tabtrans">
		<li class="selected"><a href="#0" class="titletabs">Total transaction history</a></li>
		<li><a href="#0" class="titletabs">Failure transaction history</a></li>
	</ul>
	<div class="tab_content">
		<div class="transcontent" style="margin-top: 5px;">
			<div class="rowtype">
				<div class="tbltitlerow">
					<span class="titlerow">Charge type</span>
				</div>
				<ul class="choisetype">
					<li class="active"><a class="itemtype">All</a></li>
					<li><a class="itemtype">Charge</a></li>
					<li><a class="itemtype">Discharge</a></li>
				</ul>
			</div>
			<div class="rowtype">
				<div class="wd35 tbltitlerow">
					<span class="titlerow">Energy Inquiry</span>
				</div>
				<div class="wd65 choisemethod">
					<select class="sl_statistic">
						<option value="1">All</option>
						<option value="2">Area 01</option>
						<option value="3">Area 02</option>
						<option value="4">Area 03</option>
					</select>
				</div>
			</div>
			<ul class="listmethod">
				<li>
					<div class="tbltitlerow">
						<span class="titlerow">Order number</span>
					</div>
					<div class="choisemethod">
						<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="" value="">
					</div>
				</li>
				<li>
					<div class="tbltitlerow">
						<span class="titlerow">Charge total value</span>
					</div>
					<div class="choisemethod">
						<div class="rowsmethod">
							<div class="colmethod">
								<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="From" value="">
								<label class="lblpriceinput">kW</label>
							</div>
							<div class="colmethod">
								<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="To" value="">
								<label class="lblpriceinput">kW</label>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="tbltitlerow">
						<span class="titlerow">Manager name</span>
					</div>
					<div class="choisemethod">
						<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="" value="">
					</div>
				</li>
				<li>
					<div class="tbltitlerow">
						<span class="titlerow">Zone type</span>
					</div>
					<div class="choisebank choisemethod">
						<select class="sl_statistic">
							<option value="1">zone 01</option>
							<option value="2">zone 02</option>
							<option value="3">zone 03</option>
							<option value="4">zone 04</option>
						</select>
					</div>
				</li>
			</ul>
			<div class="showhidetotal value">
				<span class="showhidemethod"></span>
			</div>
			
			<div class="filtersearch">
				<ul class="listdate">
					<li class="active"><a class="achoisedate">Today</a></li>
					<li><a class="achoisedate">1 Week</a></li>
					<li><a class="achoisedate">2 Weeks</a></li>
					<li class="lifromto"><a class="achoisedate">Select Preriod</a></li>
				</ul>
				<ul class="listdaytoday">
					<li>
						<input type="text" id="datetimepicker2" class="txtdaytoday" name="id" autocomplete="on" placeholder="From" disabled style="min-height: 30px;">
					</li>
					<li>
						<input type="text" id="datetimepicker3" class="txtdaytoday" name="id" autocomplete="on" placeholder="To" disabled style="min-height: 30px;">
					</li>
				</ul>
				<div class="filterbtnsearch">
					<button class="filterbtn">Search</button>
				</div>
			</div>
			<div class="resutltrans">
				<h3 class="title_resulttrans">Result of the period DD/MM/YYYY ~ DD/MM/YYYY: Building Charge</h3>
				<div class="resultcontenttrans">
					<table class="tblresulttrans">
						<tbody>
							<tr>
								<td>
									<span class="titleth">Total</span>
								</td>
								<td>
									<div class="coltransnumber">300<span class="txttrans">total value(s)</span></div>
								</td>
								<td>
									<div class="coltransprice">10,000,000<span class="unitprice">kW</span></div>
								</td>
							</tr>
							<tr>
								<td>
									<a class="succ_color astatustrans">Charge</a>
								</td>
								<td>
									<div class="colsmsize coltransnumber">298<span class="txttrans">total value(s)</span></div>
								</td>
								<td>
									<div class="colsmsize coltransprice">10,700,000<span class="unitprice">kW</span></div>
								</td>
							</tr>
							<tr>
								<td>
									<a class="ref_color astatustrans">Discharge</a>
								</td>
								<td>
									<div class="colsmsize coltransnumber">3<span class="txttrans">total value(s)</span></div>
								</td>
								<td>
									<div class="colsmsize coltransprice">(700,000)<span class="unitprice">kW</span></div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<ul class="producrefund">
				<li>
					<div class="rowproductprice">
						<div class="leftproductorder">
							<h3>Product: xyz</h3>
							<p>Charge number: 666777</p>
						</div>
						<div class="rightpricerefund">
							<h3>(200,000) kW</h3>
							<button class="btnrefund btnpop">Charge</button>
						</div>
					</div>
					<div class="titletime_refund sgraybg">
						<span class="lableicon">a</span>
						<p class="ptime_rf">
							<span class="daterf">14/12/2018</span>
							<span class="timerf">09:00:00</span>
							<span class="lblrf">Area 01</span>
						</p>
					</div>
					<div class="titletime_refund rredbg">
						<span class="lableicon">z</span>
						<p class="ptime_rf">
							<span class="daterf">14/12/2018</span>
							<span class="timerf">09:00:00</span>
							<span class="lblrf">Zone 02</span>
						</p>
					</div>
					<span class="btnarrpop"></span>
					<span class="arrli"></span>
				</li>
				<li>
					<div class="rowproductprice">
						<div class="leftproductorder">
							<h3>Product: xyz</h3>
							<p>Charge number: 666777</p>
						</div>
						<div class="rightpricerefund">
							<h3>(200,000) kW</h3>
							<button class="btnrefund btnpop deactive">Discharge</button>
						</div>
					</div>
					<div class="titletime_refund sgraybg">
						<span class="lableicon">a</span>
						<p class="ptime_rf">
							<span class="daterf">14/12/2018</span>
							<span class="timerf">09:00:00</span>
							<span class="lblrf">Area 03</span>
						</p>
					</div>
					<div class="titletime_refund rredbg">
						<span class="lableicon">z</span>
						<p class="ptime_rf">
							<span class="daterf">14/12/2018</span>
							<span class="timerf">09:00:00</span>
							<span class="lblrf">zone 02</span>
						</p>
					</div>
					<span class="btnarrpop"></span>
					<span class="arrli"></span>
				</li>
				<li>
					<div class="rowproductprice">
						<div class="leftproductorder">
							<h3>Product: xyz</h3>
							<p>Charge number: 666777</p>
						</div>
						<div class="rightpricerefund">
							<h3>(200,000) kW</h3>
							<button class="btnrefund">Charge</button>
						</div>
					</div>
					<div class="titletime_refund sorangebg">
						<span class="lableicon">z</span>
						<p class="ptime_rf">
							<span class="daterf">14/12/2018</span>
							<span class="timerf">09:00:00</span>
							<span class="lblrf">zone 01</span>
						</p>
					</div>
				</li>
				<li>
					<div class="rowproductprice">
						<div class="leftproductorder">
							<h3>Product: xyz</h3>
							<p>Charge number: 666777</p>
						</div>
						<div class="rightpricerefund">
							<h3>(200,000) kW</h3>
							<button class="btnrefund deactive">Discharge</button>
						</div>
					</div>
					<div class="titletime_refund sgraybg">
						<span class="lableicon">a</span>
						<p class="ptime_rf">
							<span class="daterf">14/12/2018</span>
							<span class="timerf">09:00:00</span>
							<span class="lblrf">area 03</span>
							<span class="pricelblrf">200,000 kW</span>
						</p>
					</div>
					<div class="titletime_refund rredbg">
						<span class="lableicon">z</span>
						<p class="ptime_rf">
							<span class="daterf">14/12/2018</span>
							<span class="timerf">09:00:00</span>
							<span class="lblrf">zone 01</span>
						</p>
					</div>
				</li>
			</ul>
			
		</div>
	</div>
</div>


<div id="dialog-1" class="boxdialog">
	<div class="contentdialog">
		<div class="headerdialog">
			Charge rquest
			<a class="btncloserequest btnclose1"><span class="icon-close"></span></a>
		</div>
		<div class="containerdialog">
			<h2 class="titledialog">Charge history</h2>
			<div class="boxrefund_pop">
				<div class="leftproductorder">
					<h3>Product: xyz</h3>
					<p>Order number: 666777</p>
				</div>
				<div class="titletime_refund sgraybg">
					<span class="lableicon">a</span>
					<p class="ptime_rf">
						<span class="daterf">14/12/2018</span>
						<span class="timerf">09:00:00</span>
						<span class="lblrf">Area 02</span>
						<span class="pricelblrf">300,000 kW</span>
					</p>
				</div>
				<div class="titletime_refund rredbg">
					<span class="lableicon">r</span>
					<p class="ptime_rf">
						<span class="daterf">14/12/2018</span>
						<span class="timerf">09:00:00</span>
						<span class="lblrf">Area 02</span>
						<span class="pricelblrf">(200,000) kW</span>
					</p>
				</div>
				<div class="amountrefund">
					Amount after Charge
					<span class="priceamount">100,000 kW</span>
				</div>
			</div>
			<div class="showhideamount">
				<span class="arrshowhide"></span>
			</div>
			<h2 class="titledialog">Charge request</h2>
			<div class="boxinputrefund">
				<ul class="listmethod">
					<li>
						<div class="tbltitlerow">
							<span class="titlerow">Manager</span>
						</div>
						<div class="choisemethod">
							<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="Dang Thi Kim ngan" disabled>
						</div>
					</li>
					<li>
						<div class="tbltitlerow">
							<span class="titlerow">Requester</span>
						</div>
						<div class="choisemethod">
							<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="">
						</div>
					</li>
					<li>
						<div class="tbltitlerow">
							<span class="titlerow">Reason for Charge</span>
						</div>
						<div class="choisemethod">
							<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="">
						</div>
					</li>
					<li>
						<div class="tbltitlerow">
							<span class="titlerow">Charge amount</span>
						</div>
						<div class="choisemethod">
							<input type="text" class="txtboxtrans" name="id" autocomplete="on" placeholder="100,000 VND">
						</div>
					</li>
				</ul>
			</div>
			<div class="noterefund">
				The Charge is clicked on SENT Charge REQUEST. After sending the Charge successfully, please inquiry the Charge status again. In the case that the Charge request is sent after the successful Charge over 1 day, the requested amount for Charge would be Charged within the time regulated by the issuing FOM.
			</div>
			<div class="rowbtnrequest">
				<button class="btnrequest">Send Charge request</button>
			</div>
		</div>
		
	</div>
</div>

<div id="dialog-2" class="boxdialog">
	<div class="contentdialog">
		<div class="headerdialog">
			Discharge details
			<a class="btncloserequest btnclose2"><span class="icon-close"></span></a>
		</div>
		<div class="containerdialog">
			<h2 class="titledialog">Discharge history</h2>
			<div class="boxrefund_pop">
				<div class="leftproductorder">
					<h3>Product: xyz</h3>
					<p>Discharge number: 666777</p>
					<p>User: Dang Thi Kim Ngan</p>
					<p>Discharge type: BIDV</p>
				</div>
				<div class="titletime_refund sgraybg">
					<span class="lableicon">r</span>
					<p class="ptime_rf">
						<span class="daterf">14/12/2018</span>
						<span class="timerf">09:00:00</span>
						<span class="lblrf">Area 01</span>
						<span class="pricelblrf">300,000 kW</span>
					</p>
				</div>
				<div class="titletime_refund rredbg">
					<span class="lableicon">a</span>
					<p class="ptime_rf">
						<span class="daterf">14/12/2018</span>
						<span class="timerf">09:00:00</span>
						<span class="lblrf">Discharge</span>
						<span class="pricelblrf">(200,000) kW</span>
					</p>
				</div>
				<div class="amountrefund">
					Amount after Discharge
					<span class="priceamount">100,000 kW</span>
				</div>
			</div>
			<div class="showhideamount">
				<span class="arrshowhide"></span>
			</div>
			<h2 class="titledialog">Charge request</h2>
			<div class="boxinputrefund">
				<ul class="list_transhistory">
					<li>
						<span class="labeltranshistory">User</span>
						<span class="infotranshistory">Dang Thi Kim Ngan</span>
					</li>
					<li>
						<span class="labeltranshistory">Requester</span>
						<span class="infotranshistory">222333</span>
					</li>
					<li>
						<span class="labeltranshistory">Charge type</span>
						<span class="infotranshistory">BIDV</span>
					</li>
					<li>
						<span class="labeltranshistory">Reason for Charge</span>
						<span class="infotranshistory">abc</span>
					</li>
				</ul>
			</div>
		</div>
		
	</div>
</div>