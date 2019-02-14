function chkCoNo(vencod){
	sum = 0;
	vencod = vencod.replace("-","");
	getlist =new Array(10);
	chkvalue =new Array("1","3","7","1","3","7","1","3","5");
	for(var i=0; i<10; i++) { getlist[i] = vencod.substring(i, i+1); }
	for(var i=0; i<9; i++) { sum += getlist[i]*chkvalue[i]; }
	sum = sum + parseInt((getlist[8]*5)/10);
	sidliy = sum % 10;
	sidchk = 0;
	if(sidliy != 0) { sidchk = 10 - sidliy; }
	else { sidchk = 0; }
	if(sidchk != getlist[9]) { return false; }
	return true;	
}

function chkSpeChar(strChar){
	if( strChar.val().search(/\W|\s/g) > -1 ){
	    strChar.focus();
	    return false;
	}else{
		return true;
	}
}

/* 문자열에서 숫자만 추출 */
function getOnlyDigit( number )
{
	var i;
	var result = "";

	for(i=0; i<number.length; i++)
	{
		if( number.charAt(i)>='0' && number.charAt(i)<='9' )
			result += number.charAt(i);
	}

	return result;
};

function fnReplaceDate(date){
	var maskedDate = "";
	
	date.value = getOnlyDigit(date.value);
	
	for (i = 0 ; i < date.value.length ; i++)
	{
		maskedDate += date.value.charAt(i);

		if ( i != date.value.length - 1 && (i == 3 || i == 5))
			maskedDate += "/";
	}
	date.value = maskedDate;
}

/* 오늘의 날짜 가져오기 */
function fnToDay(){	
	
	var now = new Date();		 
	var year 	= now.getFullYear()+"";
	var month = now.getMonth()+1;	
	var day = now.getDate()+"";
	
	var today;	
	
	if (day < 10) {
	  day = "0" + day;
	}
	
	if (month < 10){
  		today = year + "0" + month + day;			
	}else{
		today = year + month + day;			
	}
		
	return today;	
};
//이메일 주소 유효성 검사
function fnChkEmail(mail){

	var check = 1;
	var check1 = 1;
	var cont = 0;
	var c;

	if( mail == "" ){
		return true;
	}
		
	c = mail.charAt(0);
	if( !( (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c == '-') ) ){
		return false;
	}
	
	c = mail.charAt(mail.length-1 );
	if( !( (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) ){
		return false;
	}
						
	for(i=1; i<mail.length; i++){
		c = mail.charAt(i);			
		if( !((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) ){
			if(c == '.' || c == '-' || c == '_' ){
				if(cont==1){
					return false;
				}else{
					check++ ;
				}
			}else if( c == '@'){
				if( check1 == 5 ){
					return false;
				}else{
					check1 =5;
					cont=1;
				}
			}else{
				return false;
			}
		}else{
			cont = 0;
		}
	}

	if( check == 1 ||  check1 == 1){
		return false;
	}
	return true;
}