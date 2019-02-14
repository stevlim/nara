function fnSetFeeValue(objForm, part, spmCd, fee){
 	var fName;
	if (spmCd == '01') {
		fName = 'on';
	}else if (spmCd == '02') {
		fName = 'mo';
	}else if (spmCd == '03') {
		fName = 'sm';
	}else{
		fName = 'ms';
	}	
	
	switch(part){
		case  '01' : fName = fName +'Card';	break; // 카드
		case  '02' : fName = fName +'Acct';	break; // 계좌이체
		case  '03' : fName = fName +'VAcct';	break; // 가상계좌		
		case  '05' : fName = fName +'CP';    break; // 휴대폰 
		case  '06' : fName = fName +'CPAuto';    break; // 휴대폰빌링
	}

	objForm[fName].value= fee;
};

function dateLMaskOn(myValue){
	var maskedDate = "";
	
	myValue = getOnlyDigit(myValue);
	
	for (i = 0 ; i < myValue.length ; i++)
	{
		maskedDate += myValue.charAt(i);

		if ( i != myValue.length - 1 && (i == 3 || i == 5))
			maskedDate += "/";
	}
	myValue = maskedDate;
	
	return myValue;
};

function js_IsEmpty(cStr){
	//alert('_'+cStr+'_');
 if(cStr == null || js_Trim(cStr) == "")
   return true;
 else
   return false;
};

function js_Trim(cStr){
	 if(cStr == null)  {
	   return "";
	 }
	 var rcStr = cStr.replace(/^\s*/, "").replace(/\s*$/, "");

	 return rcStr;
};
/* yyyy/mm/dd => yyyymmdd */
function dateLMaskOff(myValue){
	var unmaskedDate = "";

	for (i = 0 ; i < myValue.length ; i++)
	{
		if (myValue.charAt(i) != "/")							
			unmaskedDate += myValue.charAt(i);
	}
	myValue = unmaskedDate;
	
	return myValue;
};
/* 문자열에 천단위 콤마 및 Minus부호, Dot 표시 */
function setSignalMaskOn(form)
{				
	var reverseMaskedNumber = "", maskedNumber = "";
	var integerCount = 0, maskCount = 0, isPoint = 0;
	var integerIndex ;
	var tmpValue = "" + form.value;
	
	tmpValue = getSignalDigit(tmpValue);
	
	integerIndex = tmpValue.length;
	
	for (i = tmpValue.length - 1 ; i >= 0 ; i--)
	{
		reverseMaskedNumber += tmpValue.charAt(i);
		if (tmpValue.charAt(i) == ".")							
		{
			integerIndex = i - 1;
			isPoint = 1;
			break;
		}
	}
		
	if (isPoint == 0)
	{
		reverseMaskedNumber = "";
		integerIndex -= 1;
	}
	
	for ( i = integerIndex ; i >= 0 ; i--)
	{
		integerCount++;
		reverseMaskedNumber += tmpValue.charAt(i);
	
		if (integerCount % 3 == 0 && i != 0 && tmpValue.charAt(i-1) != "-")
		{
			reverseMaskedNumber += ",";
			maskCount++;
		}
	}
	
	for ( i = maskCount + tmpValue.length ; i >= 0 ; i--)
	{
		maskedNumber += reverseMaskedNumber.charAt(i);
	}
	
	form.value = maskedNumber;
};

/* 천단위 콤마 표시 */
function numberMaskOn(myForm)
{				
	var reverseMaskedNumber = "", maskedNumber = "";
	var integerCount = 0, maskCount = 0, isPoint = 0;
	var integerIndex ;
	var tmpValue;

	myForm.value = getOnlyDigit(myForm.value);
	
	integerIndex = myForm.value.length;
	
	for (i = myForm.value.length - 1 ; i >= 0 ; i--)
	{
		reverseMaskedNumber += myForm.value.charAt(i);
		if (myForm.value.charAt(i) == ".")							
		{
			integerIndex = i - 1;
			isPoint = 1;
			break;
		}
	}

	if (isPoint == 0)
	{
		reverseMaskedNumber = "";
		integerIndex -= 1;
	}
	
	for ( i = integerIndex ; i >= 0 ; i--)
	{
		integerCount++;
		reverseMaskedNumber += myForm.value.charAt(i);
		if (integerCount % 3 == 0 && i != 0 && myForm.value.charAt(i-1) != "-")
		{
			reverseMaskedNumber += ",";
			maskCount++;
		}
	}

	for ( i = maskCount + myForm.value.length ; i >= 0 ; i--)
	{
		maskedNumber += reverseMaskedNumber.charAt(i);
	}

	myForm.value = maskedNumber;
};

/* 문자열에서 숫자와 기호만 추출 */
function getSignalDigit(number)
{
	var i;
	var result = "";

	for(i=0; i<number.length; i++)
	{
		if( (number.charAt(i)>='0' && number.charAt(i)<='9') || number.charAt(i) == '-' || number.charAt(i) == '.' ) {
			result += number.charAt(i);		
		}
	}

	return result;
};


/* 날짜 확인 */
function dateChecked(YMD){
	var year  = YMD.substring(0,4);
	var month = YMD.substring(4,6);
	var day   = YMD.substring(6,8);
	var endDay;

	if (month > 12 || month < 01 || YMD.length < 08 || isNaN(YMD) || day <= 00)
		return false;
	else if (month == 01 || month == 03 || month == 05 || month == 07 || month == 08 || month == 10 || month == 12)
		endDay = 31;
	else if (month == 04 || month == 06 || month == 09 || month == 11)
		endDay = 30;
	else if (month == 02)
	{
		if (year % 400 == 0) 
			endDay = 29;
		else if (year % 100 == 0) 
			endDay = 28;
		else if (year % 4   == 0) 
			endDay = 29;
		else 
			endDay = 28;
	}

	if (day > endDay) 
		return false;	
		
	return true;
};
/* 이벌달 가져오기 */
function getToMon(){	
	
	var now = new Date();		 
	var year 	= now.getFullYear()+"";
	var month = now.getMonth()+1;	
	
	var tomm;	
	
	if (month < 10){
  		tomm = year + "0" + month;			
	}else{
		tomm = year + month;			
	}
		
	return tomm;	
};
/* 현재 연,월,일중 한가지 가져오기 */
function getToDate(type){	
	
	var now = new Date();		 
	var year 	= now.getFullYear()+"";
	var month = now.getMonth()+1;	
	var day = now.getDate()+"";
		
	if(type == 'Y') {
		return year;
	} else if(type == 'M') {
		if (month < 10){
	  		month = "0" + month;			
		}		
		return month;
	} else {
		return day;
	}
		
};