/**------------------------------------------------------------
 * File Name      : IONPay.js 
 * Description    : IONPay Custom Javascript Library
 * Author         : ymjo, 2015. 10. 2.
 * Modify History : Just Created.
 ------------------------------------------------------------*/

/**------------------------------------------------------------
 * IONPay Global Variable
 ------------------------------------------------------------*/
var arrParameter  = {};
var strCallUrl    = "";
var strCallBack   = "";
var strCallBackFN = "";
var strDateFormat = "dd-mm-yyyy";

var strPreModalId   = "";
var isPreModalOpen  = false;
var gisGetCSRFToken = false;
var gValidate;

/**------------------------------------------------------------
 * IONPay Global Constants
 ------------------------------------------------------------*/
var IONPay = {
	CSRFID                 : "MMSRequestVerificationToken",
	BLOCKDIVID             : "divPageBlock",
	COMMONERRORMSG         : "",
	AJAXERRORMSG           : "",
	FROMDATEERRORMSG       : "",
	SAVESUCCESSMSG         : "",
	MERCHANTSEARCHERRORMSG : "",
	EXCELLIMITCNT          : 50000,
	LOGINURL               : "/logIn.do",
	ISEMPTYSESSIONURL      : "/logInCheckIsEmptySession.do",
	PAGES                  : 1,
	PAGELENGTH             : 50
}

/**------------------------------------------------------------
 * IONPay.Init
 ------------------------------------------------------------*/
IONPay.Init = {
	/**------------------------------------------------------------
	 * Function Name  : fnLoadPageEvent
	 * Description    : Load Js
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnLoadPageEvent: function () {
        IONPay.COMMONERRORMSG         = gMessage("MMS_JS_0001");
        IONPay.AJAXERRORMSG           = gMessage("MMS_JS_0002");
        IONPay.FROMDATEERRORMSG       = gMessage("MMS_JS_0003");
        IONPay.SAVESUCCESSMSG         = gMessage("MMS_JS_0004");
        IONPay.MERCHANTSEARCHERRORMSG = gMessage("IMS_JS_0007");
	}
}

/**------------------------------------------------------------
 * IONPay.Ajax
 ------------------------------------------------------------*/
IONPay.Ajax = {
	/**------------------------------------------------------------
	 * Function Name  : fnRequest
	 * Description    : Ajax Process
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnRequest: function(arrParameter, strCallUrl, strCallBack, isaSync) {
		var intErrCnt = 0;

		$.ajax({
			cache: false,
			async: (typeof (isaSync) == "undefined" ? true : IONPay.Utils.fnGetBoolean(isaSync)),
			type: "POST",
			data: JSON.stringify(arrParameter),
			url: strCallUrl,
			dataType: "JSON",
			contentType: "application/json; charset=utf-8",
			headers: { "MMSRequestVerificationToken": IONPay.AntiCSRF.getVerificationToken() },
			beforeSend: function () {			    
			    if (arrParameter.ISLOADING == undefined) {
			        IONPay.Ajax.fnAjaxBlock();
			    }
			},
			complete: function () {
			    if (arrParameter.ISLOADING == undefined) {
			        $.unblockUI();
			    }
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
			    intErrCnt++;
			    if (XMLHttpRequest.status == 901) {
			        location.href = IONPay.LOGINURL;
			        return;
			    }

				if (intErrCnt == 3 && XMLHttpRequest.readyState == 4 && textStatus == "parsererror") {
				    alert(IONPay.COMMONERRORMSG);
				} else if (intErrCnt == 3 && XMLHttpRequest.readyState == 0 && textStatus == "error") {
				    alert(IONPay.COMMONERRORMSG);
				}
			}
		}).retry({ times: 3, timeout: 1000 }).then(function(objJson) {
			try {
				if (typeof (objJson) === "object") {
					eval(strCallBack)(objJson);
				} else if (typeof (objJson) === "string") {
					eval(strCallBack)(jQuery.parseJSON(objJson));
				} else {
					if (intErrCnt == 3) {
					    alert(IONPay.COMMONERRORMSG);
					}
				}
			} catch(ex) {			    
			    alert(ex.message);
			}
		});
	},

    /**------------------------------------------------------------
	 * Function Name  : fnRequestFile
	 * Description    : Ajax Process For File Upload
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnRequestFile: function ($objFormData, strCallUrl, strCallBack) {
	    $.ajax({
	        cache: false,
	        type: 'POST',
	        data: $objFormData,
	        url: strCallUrl,
	        contentType: false,
	        processData: false,	        
	        headers: { "MMSRequestVerificationToken": IONPay.AntiCSRF.getVerificationToken() },	        
	        beforeSend: function () {
	            IONPay.Ajax.fnAjaxBlock();	            
	        },
	        complete: function () {
	            $.unblockUI();	            
	        },
	        success: function (objJson) {
	            eval(strCallBack)(objJson);
	        },
	        error: function (XMLHttpRequest, textStatus, errorThrown) {
	            if (XMLHttpRequest.status == 901) {
	                location.href = IONPay.LOGINURL;
	                return;
	            }

	            alert(IONPay.COMMONERRORMSG);
	        }
	    });
	},

    /**------------------------------------------------------------
	 * Function Name  : fnRequestPost
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnRequestPost: function (url, params, modalId, successCallback, failCallback) {
	    $.post(url, params).done(function (objJson) {
	        // ajax 호출된 프로시저 결과에 따른 분기
	        if (parseInt(objJson.resultCode) == 0) {
	            isPreModalOpen = false;
	        } else {
	            isPreModalOpen = true;
	            alert(IONPay.COMMONERRORMSG + " (" + objJson.resultCode + "," + objJson.resultMessage + ")", modalId);
	        }

	        if (typeof successCallback == "function" && successCallback !== null) {
	            successCallback(objJson, null);
	        }
	    }).fail(function (XMLHttpRequest) {
	        if (XMLHttpRequest.status == 901) {
	            location.href = IONPay.LOGINURL;
	            return;
	        }

	        // 실패했을때의 처리 로직
	        if (typeof failCallback == "function" && failCallback !== null) {
	            failCallback();
	        }
	        isPreModalOpen = true;
	        alert(IONPay.AJAXERRORMSG);
	    });
	},

    /**------------------------------------------------------------
	 * Function Name  : fnRequestExcel
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnRequestExcel: function(arrParameter, strCallUrl, strCallBack) {    
	    arrParameter["MMSRequestVerificationToken"] = IONPay.AntiCSRF.getVerificationToken();

	    $.fileDownload(strCallUrl, {
            httpMethod: "POST",
            data: $.param(arrParameter),
            prepareCallback: function () {            
                IONPay.Ajax.fnAjaxBlock();
            },
            successCallback: function (url) {                
                $.unblockUI();
				if(strCallBack != undefined){
					eval(strCallBack);
				}
            },
            failCallback: function (html, url) {
                var objParam = {};
                var strUrl   = IONPay.ISEMPTYSESSIONURL;

                $.post(strUrl, objParam).done(function (objJson) {
                    if (objJson.IsEmptySession) {
                        location.href = IONPay.LOGINURL;
                    }
                }).fail(function (XMLHttpRequest) {
                    $.unblockUI();
                });

                $.unblockUI();
            } 
        });
	},

    /**------------------------------------------------------------
	 * Function Name  : fnRequestJsonp
	 * Description    : 
	 * Author         : ymjo, 2015. 10. 26.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnRequestJsonp: function (strParameter, strCallUrl, strCallBack) {
	    try{
	        $.ajax({
	            data: strParameter,
	            url: strCallUrl,
	            dataType: "JSONP",
	            beforeSend: function () {
	                IONPay.Ajax.fnAjaxBlock();
	            },
	            complete: function () {
	                $.unblockUI();
	            },
	            success: function (objJson) {
	                eval(strCallBack)(objJson)
	            },
	            error: function (XMLHttpRequest, textStatus, errorThrown) {
	                alert(IONPay.COMMONERRORMSG);
	            }
	        });
	    }catch(e){
	        alert(IONPay.COMMONERRORMSG);
	    }
	},
	
	/**------------------------------------------------------------
	 * Function Name  : fnAjaxBlock
	 * Description    : Ajax Block
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnAjaxBlock: function() {
		try {
			$.blockUI({
			    message: $("#" + IONPay.BLOCKDIVID),
				css: {
					top: '50%',
					left: '50%',
					padding: 0,
					margin: 0,
					width: '24px',
					height: '24px',
					border: 'none',
					backgroundColor: 'transparent',
					'-webkit-border-radius': '10px',
					'-moz-border-radius': '10px',
					opacity: 1,
					"z-index":"999999999999999",
					color: '#000'
				}, overlayCSS: {
					backgroundColor: '#FFFFFF',
					opacity: 0.0,
					cursor: 'wait'
				}
			});
		} catch(ex) { }
	},

    /**------------------------------------------------------------
	 * Function Name  : GetAjaxLoadingWithCallback
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	GetAjaxLoadingWithCallback: function(id, fnCallback) {
	    $(document).bind({
	        ajaxStart: function (event, xhr, setup) {
	            IONPay.Ajax.fnAjaxBlock();
	        },
	        ajaxStop: function () {
	            $.unblockUI();
	            fnCallback();
	        }
	    });
	},
	
    /**------------------------------------------------------------
	 * Function Name  : CreateConfirm
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	CreateConfirm: function(msg, url, params, successCallback, failCallback) {
	    IONPay.Msg.fnConfirm(msg, function () {
	        $.post(url, params).done(function (objJson) {
                // ajax 호출된 프로시저 결과에 따른 분기
                if (parseInt(objJson.resultCode) == 0) {

                } else {
                    alert(IONPay.COMMONERRORMSG + " (" + objJson.resultCode + "," + objJson.resultMessage + ")");
                }

                if (typeof successCallback == "function" && successCallback !== null) {
                    successCallback(objJson,null);
                }
	        }).fail(function (XMLHttpRequest) {
	            if (XMLHttpRequest.status == 901) {
	                location.href = IONPay.LOGINURL;
	                return;
	            }

                // 실패했을때의 처리 로직
	            if (typeof failCallback == "function" && failCallback !== null) {
                    failCallback();
                }
               
                alert(IONPay.AJAXERRORMSG);
            });
        });
  },
	
    /**------------------------------------------------------------
	 * Function Name  : CreateDataTable
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	CreateDataTable: function(strLocation, isPartial, opts, isResponsive) {
	    // 테이블아이디, 부분조회여부, DataTables옵션
	    // 기본옵션 상속받기 (옵션 우선순위 : 고정옵션 > 호출옵션 > 기본옵션)

	    var blnResponsive = typeof (isResponsive) == "undefined" ? false : true;

        var conf = $.extend({
            pages: IONPay.PAGES,
            pageLength: IONPay.PAGELENGTH,
            method: 'POST',            
            dom: '<"top"l>frtip',                        
            resizable: true,
            lengthChange: true,
            searching: true,
            pagingType: "simple_numbers",   
            responsive: isResponsive
        }, opts);
        
        var fnOrgDrawCallback = conf.fnDrawCallback;

        // Callback 구현
        conf.fnDrawCallback = function (settings) {
            IONPay.Auth.Refresh();
            if (typeof (fnOrgDrawCallback) == "function") {
                fnOrgDrawCallback(settings);
            }
        }

        if (isResponsive) {
            conf.responsive = {
                details: {
                    renderer: function (api, rowIdx, columns) {
                        var data = $.map(columns, function (col, i) {
                            return col.hidden ?
                                "<tr>" +
                                    "<td style='border:1px solid #ddd; background-color:#ecf0f2; text-align:center;'>" + col.title + "</td>" +
                                    "<td style='border:1px solid #ddd; text-align:center;'>" + col.data + "</td>" +
                                "</tr>" :
                                "";
                        }).join("");

                        return data ? $("<table width='100%'/>").append(data) : false;
                    }
                }
            };
        }
                
        if (isPartial == true) {
            //부분조회시 고정 옵션 - 수정금지
        	conf.processing = false;
            conf.serverSide = true;
            conf.sort = false;
            conf.order = [];
            conf.searching = false;
            conf.ajax = IONPay.Ajax.Pipeline({
                url: conf.url,
                data: conf.data,
                pages: conf.pages
            });        
        } else {
            //전체조회시 고정 옵션- 수정금지
            conf.processing = false;
            conf.serverSide = false;
            conf.sort = true;
            conf.order = [];
            conf.ajax = function (data, callback, settings) {
                $.ajax({
                    type: conf.method,
                    url: conf.url,
                    dataType: "JSON",
                    data: JSON.stringify(conf.data()),
                    contentType: "application/json; charset=utf-8",
                    headers: { "MMSRequestVerificationToken": IONPay.AntiCSRF.getVerificationToken() },
                    beforeSend: function() {
                        IONPay.Ajax.fnAjaxBlock();
					},
                    complete: function() {
                        $.unblockUI();
					},
                    success: function(json) {
                        if (json.resultCode != 0) {
                            IONPay.Msg.fnAlert(json.resultMessage);
                        } else {
                            settings.json = json;
                            callback(json);
                        }
                    },                    
                    error: function(xhr, error, thrown) {
                        var log = settings.oApi._fnLog;

                        if (xhr.status == 901) {
                            location.href = IONPay.LOGINURL;
                            return;
                        }

                        if (error == "parsererror") {
                            log(settings, 0, 'Invalid JSON response', 1);
                        } else if (xhr.readyState === 4) {
                            log(settings, 0, 'Ajax error', 7);
                        }
                    }
                });
            };
        }

        return $(strLocation).DataTable(conf);
    },
    
    /**------------------------------------------------------------
	 * Function Name  : Pipeline
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    Pipeline: function(opts) {
        var conf = $.extend({
            method: 'POST'
        }, opts);

        var cacheLower = -1;
        var cacheUpper = null;
        var cacheLastRequest = null;
        var cacheLastJson = null;

        return function (request, drawCallback, settings) {
            var ajax = false;
            var requestStart = request.start;
            var drawStart = request.start;
            var requestLength = request.length;
            var requestEnd = requestStart + requestLength;
                        
            if (settings.clearCache) {                
                ajax = true;
                settings.clearCache = false;            
            } else if (cacheLower < 0 || requestStart < cacheLower || requestEnd > cacheUpper) {                
                ajax = true;            
            } else if (JSON.stringify(request.order) !== JSON.stringify(cacheLastRequest.order) ||
                              JSON.stringify(request.columns) !== JSON.stringify(cacheLastRequest.columns) ||
                              JSON.stringify(request.search) !== JSON.stringify(cacheLastRequest.search)) {       
                ajax = true;
            }

            cacheLastRequest = $.extend(true, {}, request);

            if (ajax) {
                if (requestStart < cacheLower) {
                    requestStart = requestStart - (requestLength * (conf.pages - 1));

                    if (requestStart < 0) {
                        requestStart = 0;
                    }
                }

                cacheLower = requestStart;
                cacheUpper = requestStart + (requestLength * conf.pages);

                request.start = requestStart;
                request.length = requestLength * conf.pages;
                
                if ($.isFunction(conf.data)) {
                    var d = conf.data(request);

                    if (d) {
                        $.extend(request, d);
                    }
                } else if ($.isPlainObject(conf.data)) {                    
                    $.extend(request, conf.data);
                }
                
                delete request.columns;
                delete request.search;
                delete request.order;

                settings.jqXHR = $.ajax({
                    "type": conf.method,
                    "url": conf.url,
                    "data": JSON.stringify(request),
                    "dataType": "json",
                    "contentType" : "application/json; charset=utf-8",
					"headers": { "MMSRequestVerificationToken": IONPay.AntiCSRF.getVerificationToken() },
                    "cache": false,
                    "success": function(json) {
                        if (json.resultCode != 0) {
                            IONPay.Msg.fnAlert(json.resultMessage);
                        }
                        
                        cacheLastJson = $.extend(true, {}, json);

                        if (cacheLower != drawStart) {
                            json.data.splice(0, drawStart - cacheLower);
                        }

                        json.data.splice(requestLength, json.data.length);

                        settings.json = json;

                        drawCallback(json);
                    },
                    beforeSend: function() {
                        IONPay.Ajax.fnAjaxBlock();
                    },
                    complete: function() {
                        $.unblockUI();
                    },
                    error: function(xhr, error, thrown) {
                        var log = settings.oApi._fnLog;

                        if (xhr.status == 901) {
                            location.href = IONPay.LOGINURL;
                            return;
                        }

                        if (error == "parsererror") {
                            log(settings, 0, 'Invalid JSON response', 1);
                        } else if (xhr.readyState === 4) {
                            log(settings, 0, 'Ajax error', 7);
                        }
                    }
                });
            } else {

                json = $.extend(true, {}, cacheLastJson);
          
                json.draw = request.draw;
                json.data.splice(0, requestStart - cacheLower);
                json.data.splice(requestLength, json.data.length);

                drawCallback(json);
            }
        }
    }
}

/**------------------------------------------------------------
 * IONPay.AntiCSRF
 ------------------------------------------------------------*/
IONPay.AntiCSRF = {
	/**------------------------------------------------------------
	 * Function Name  : getVerificationToken
	 * Description    : Get CSRF Token
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	getVerificationToken: function() {
		var strCSRFValue = "";

        if (!gisGetCSRFToken) {
            $.ajax({
	            cache : false,
	            type  : 'POST',
	            url   : "/logInGetSessionCsrfToken.do",
                async : false,
	            success: function (objJson) {
	                strCSRFValue = $.trim(objJson.CSRFToken);
                    $("#" + IONPay.CSRFID).val(strCSRFValue);
	            },
	            error: function (XMLHttpRequest, textStatus, errorThrown) {
	                alert(IONPay.COMMONERRORMSG);
	            }
	        });

            gisGetCSRFToken = true;
        } else {
            strCSRFValue = $("#" + IONPay.CSRFID).val();
        }

        return strCSRFValue;
	}
}

/**------------------------------------------------------------
 * IONPay.Utils
 ------------------------------------------------------------*/
IONPay.Utils = {
	/**------------------------------------------------------------
	 * Function Name  : fnGetBoolean
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnGetBoolean : function(val) {
		var strRegx = /^(?:f(?:alse)?|no?|0+)$/i;

		return !strRegx.test(val) && !!val;
	}, 
	
	/**------------------------------------------------------------
	 * Function Name  : fnDatePicker
	 * Description    : Set Date Time
	 * Author         : yangjeongmo, 2015-10-06
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnDatePicker : function(strType, intDiff, strID, strBaseID) {
		var arrDate  = $("#" + strBaseID).val().split("-");
		var intYear  = Number(arrDate[2]);
		var intMonth = Number(arrDate[1]) - 1;
		var intDay   = Number(arrDate[0]);
		var objDate  = new Date(intYear, intMonth, intDay);

        if (strType == "Day") {
            objDate.setDate(objDate.getDate() + intDiff);
        } else if (strType == "Month") {
            objDate.setMonth(objDate.getMonth() + intDiff);
        } else if (strType == "Year") {
            objDate.setYear(objDate.getFullYear() + intDiff);
        }
    
        $("#" + strID).parent().datepicker({
            format: strDateFormat,
            autoclose: true,
            todayHighlight: true
        }).datepicker("update", objDate);
        
        if(intDiff == 0){
	        $("#" + strBaseID).parent().datepicker({
	            format: strDateFormat,
	            autoclose: true,
	            todayHighlight: true
	        }).datepicker("update", objDate);
        }
	},
	
	/**------------------------------------------------------------
	 * Function Name  : fnConvertDateFormat
	 * Description    : Convert Date Format
	 * Author         : yangjeongmo, 2015-10-06
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnConvertDateFormat: function (strDate) {
	    var strReturnValue = "";

	    try {
	        var arrValue = strDate.split('-');
	        strReturnValue = arrValue[2] + arrValue[1] + arrValue[0];		
	    } catch (ex) {
	        strReturnValue = "";
	    }

	    return strReturnValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnConvertMonthFormat
	 * Description    : Convert Month Format
	 * Author         : yangjeongmo, 2015-10-06
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnConvertMonthFormat: function (strDate) {
	    var strReturnValue = "";

	    try {
	        var arrValue = strDate.split('-');
	        strReturnValue = arrValue[1] + arrValue[0];
	    } catch (ex) {
	        strReturnValue = "";
	    }

	    return strReturnValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnStringToMonthDateFormat
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 28.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnStringToMonthDateFormat: function (strValue) {
	    var strReturnValue = "";

	    try {
	        strReturnValue = strValue.substring(4, 6) + "-" + strValue.substring(0, 4);
	    } catch (ex) {
	        strReturnValue = "";
	    }

	    return strReturnValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnStringToDateFormat
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnStringToDateFormat: function(strValue) {
	    var strReturnValue = "";

	    try {
	        if (strValue.length == 8) {
	            strReturnValue = strValue.substring(6, 8) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(0, 4);
	        } else if(strValue.length == 14){
	        	  strReturnValue = strValue.substring(6, 8) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(0, 4) + " "
	        	  							 + strValue.substring(8, 10) + ":" + strValue.substring(10, 12) + ":" + strValue.substring(12, 14);
	        }
	    } catch (ex) {
	        strReturnValue = "";
	    }

	    return strReturnValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnStringToDateTimeFormat
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnStringToDateTimeFormat: function(strValue) {
	    var strReturnValue = "";

	    try {
	        if (strValue.length == 14) {
	            strReturnValue = strValue.substring(6, 8) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(0, 4) + " " + strValue.substring(8, 10) + ":" + strValue.substring(10, 12) + ":" + strValue.substring(12, 14);
	        }
	    } catch (ex) {
	        strReturnValue = "";
	    }

	    return strReturnValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnStringToDatePickerFormat
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnStringToDatePickerFormat: function(strValue) {
	    var strReturnValue = "";

	    try {
	        var dateValue = strValue.substring(0, 4) + "-" + strValue.substring(4, 6) + "-" + strValue.substring(6, 8)
			
	        var arrValue = dateValue.split('-');
	        strReturnValue = arrValue[2] + "-" + arrValue[1] + "-" + arrValue[0];			        
	    } catch (ex) {
	        strReturnValue = "";
	    }

	    return strReturnValue;
	},

    /**------------------------------------------------------------
    * Function Name  : fnTodayCompareToFromDate
    * Description    : 오늘날짜와 적용일 비교
    * Author         : kwjang, 2015. 10. 29.
    * Modify History : Just Created.
    ------------------------------------------------------------*/
	fnTodayCompareToFromDate: function (strValue,isModal) {
	    var strToday = $.datepicker.formatDate('dd-mm-yy', new Date());
	    var intToday = Number(IONPay.Utils.fnConvertDateFormat(strToday)); 
	    var intFR_DT = Number(IONPay.Utils.fnConvertDateFormat(strValue));
        
	    if(intToday > intFR_DT) {
	        return false;
	    }

	    return true;
	},

    /**------------------------------------------------------------
   * Function Name  : fnLastFromDateCompareToCurFromDate
   * Description    : 마지막 적용일(99991231을 가진 row의 FR_DT)와 현재 적용일 비교
   * Author         : kwjang, 2015. 11. 01.
   * Modify History : Just Created.
   ------------------------------------------------------------*/
	fnLastFromDateCompareToCurFromDate: function (strLastFromDate, strCurFromDate) {
	    var intLastFromDate = Number(strLastFromDate);
	    var intCurFromDate  = Number(IONPay.Utils.fnConvertDateFormat(strCurFromDate));

	    if (intLastFromDate >= intCurFromDate) {
	        return false;
	    }

	    return true;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnClearForm
	 * Description    : Form Clear
	 * Author         : ymjo, 2015-10-07
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnClearForm: function (formID) {
	    if (formID == undefined || formID == "") {
	        $("#div_frm .collapse").parents(".grid").children(".grid-body").find("input, select, checkbox, radio").each(function () {
	            var nodeName = $(this)[0].nodeName;
	            switch (nodeName) {
	                case "SELECT":
	                    if ($(this).attr("data-disabled") == "true") {
	                        $(this).attr("disabled", true);
	                    } else {
	                        $(this).attr("disabled", false);
	                    }

	                    if ($(this).children("option").prop("selected") == undefined) {
	                        $(this).select2("val", $(this).children("option:eq(0)").val());
	                    } else {
	                        $(this).select2("val", $("#" + this.id + " option[selected]").val());
	                    }

	                case "INPUT":
	                    var type = $(this).attr("type");

	                    if (type == "text") {
	                        if ($(this).attr("id") != "WORKER") {
	                            $(this).val("");
	                        }
	                    } else if (type == "radio") {
	                        $(this).attr("checked", false);
	                    } else if (type == "checkbox") {
	                        $(this).attr("checked", false);
	                    }
	            }
	        });
	    } else {
	        // input 값 초기화 및 활성화
	        $("#" + formID + " input[type='text']").val("").prop("disabled", false);

	        // select 값 초기화 
	        $("#" + formID + " select").each(function (index) {
	            $(this).select2("val", "").prop("selected", true);
	        });
	    }
	},

    /**------------------------------------------------------------
	 * Function Name  : fnClearModal
	 * Description    : Modal Clear
	 * Author         : kwjang, 2015-10-29
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnClearModal: function() {
	    $("div[id^='modal").find("input, select, checkbox, radio").each(function () {
	        var nodeName = $(this)[0].nodeName;

	        switch (nodeName) {
	            case "INPUT":
	                var type = $(this).attr("type");

	                if (type == "text") {
	                    if (!$(this).attr("readonly")) {
	                        $(this).val("");
	                    }
	                } else if (type == "radio") {
	                    $(this).attr("checked", false);
	                } else if (type == "checkbox") {
	                    $(this).attr("checked", false);
	                }
	            case "SELECT": {
	                if ($(this).attr("data-disabled") == "true") {
	                    $(this).attr("disabled", true);
	                } else {
	                    $(this).attr("disabled", false);
	                }

	                if ($(this).children("option").prop("selected") == undefined) {
	                    $(this).select2("val", $(this).children("option:eq(0)").val());
	                } else {
	                    $(this).select2("val", $("#" + this.id + " option[selected]").val());
	                }
	            }
	        }
	        
	        
	    });
	},

    /**------------------------------------------------------------
	 * Function Name  : fnClearHideForm
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnClearHideForm: function() {
	    IONPay.Utils.fnClearForm();
	    $("#spn_frm_title").text("Regist");	    
	    $("#editMode").val("insert");
	    $("#div_frm").hide(200);
	},

    /**------------------------------------------------------------
	 * Function Name  : fnClearShowForm
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnClearShowForm: function () {
	    el = jQuery("#div_frm .grid .tools").parents(".grid").children(".grid-body").not($("[id^='div_']"));

	    jQuery("#div_frm .grid .tools .expand").removeClass().addClass("collapse");

	    IONPay.Utils.fnClearForm();
	    el.slideUp(200).slideDown(200);
	    $("#spn_frm_title").text("Modify");
	    $("#editMode").val("modify");
	    $("#div_frm").show(200);
	},

    /**------------------------------------------------------------
	 * Function Name  : fnClearWithoutShow
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnShowView: function () {
	    el = jQuery("#div_view .grid .tools").parents(".grid").children(".grid-body").not($("[id^='div_']"));

	    jQuery("#div_view .grid .tools .expand").removeClass().addClass("collapse");

	    el.slideUp(200).slideDown(200);
	},

    /**------------------------------------------------------------
	 * Function Name  : fnShowSearchArea
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnShowSearchArea: function() {
	    el = jQuery("#div_search .grid .tools").parents(".grid").children(".grid-body");
	    jQuery("#div_search .grid .tools .expand").removeClass().addClass("collapse");
	    el.slideDown(200);
	    $("#div_searchResult").show(200);
	},

    /**------------------------------------------------------------
	 * Function Name  : fnFrmReset
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnFrmReset: function(frmId) {
	    $("form").each(function() {
	        if(this.id == frmId) this.reset();
	    });

	    try {
	        var icon = $('.input-with-icon').children('i');
	        var parent = $('.input-with-icon');
	        var span = $('.input-with-icon').children('span');

	        icon.removeClass("fa fa-exclamation").removeClass('fa fa-check');
	        parent.removeClass('error-control').removeClass('success-control');
	        span.html("");
	    } catch(ex) { }
	},

    fnValidateStyleClear:function() {
        try {
	        var icon = $('.input-with-icon').children('i');
	        var parent = $('.input-with-icon');
	        var span = $('.input-with-icon').children('span');

	        icon.removeClass("fa fa-exclamation").removeClass('fa fa-check');
	        parent.removeClass('error-control').removeClass('success-control');
	        span.html("");
	    } catch(ex) { }
    },

    /**------------------------------------------------------------
	 * Function Name  : fnJumpToPageTop
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnJumpToPageTop: function() {
	    $('html, body').animate({
	        scrollTop: '0px'
	    }, 100);
	},

    /**------------------------------------------------------------
	 * Function Name  : fnSetValidate
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/    
	fnSetValidate: function(arrValidate) {	    
	    gValidate = $('#' + arrValidate["FORMID"]).validate({
	        focusInvalid: false,
	        ignore: "",
	        rules: arrValidate["VARIABLE"],

	        invalidHandler: function (event, validator) {
	            // display error alert on form submit    
	        },

	        errorPlacement: function (label, element) { // render error placement for each input type   	            	            
	            var icon = $(element).parent('.input-with-icon').children('i');
	            var parent = $(element).parent('.input-with-icon');
	            var span = $(element).parent('.input-with-icon').children('span');
	            icon.removeClass('fa fa-check').addClass('fa fa-exclamation');
	            parent.removeClass('success-control').addClass('error-control');
	            span.html("");
	            $('<span class="error">' + label[0].textContent + '</span>').insertAfter(element);
	        },

	        highlight: function (element) { // hightlight error inputs
	            var parent = $(element).parent();
	            parent.removeClass('success-control').addClass('error-control');
	        },

	        unhighlight: function (element) { // revert the change done by hightlight

	        },

	        success: function (label, element) {	            	            
	            var icon = $(element).parent('.input-with-icon').children('i');
	            var parent = $(element).parent('.input-with-icon');
	            var span = $(element).parent('.input-with-icon').children('span');
	            icon.removeClass("fa fa-exclamation").addClass('fa fa-check');
	            parent.removeClass('error-control').addClass('success-control');
	            span.html("");
	        },

	        submitHandler: function (form) {

	        }
	    });

	    $('.select2', "#" + arrValidate["FORMID"]).change(function () {
	        $('#' + arrValidate["FORMID"]).validate().element($(this));
	    });
	},
    
    /**------------------------------------------------------------
	 * Function Name  : fnFrmCreate
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnFrmCreate: function(frmNM, strMethod, strAction, strTarget) {
	    var objFrm = document.createElement("form");

	    objFrm.name   = frmNM;
	    objFrm.method = strMethod;
	    objFrm.action = strAction;
	    objFrm.target = strTarget ? strTarget : "";

	    return objFrm;
    },

    /**------------------------------------------------------------
	 * Function Name  : fnFrmInputCreate
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnFrmInputCreate: function(objFrm, strNm, strValue) {
        var objInput = document.createElement("input");

        objInput.type  = "hidden";
        objInput.name  = strNm;
        objInput.value = strValue;
        
        objFrm.insertBefore(objInput, null);
        
        return objFrm;
    },

    /**------------------------------------------------------------
	 * Function Name  : fnFrmSubmit
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnFrmSubmit: function(objFrm) {
	    IONPay.Utils.fnFrmInputCreate(objFrm, IONPay.CSRFID, IONPay.AntiCSRF.getVerificationToken());	    
	    document.body.appendChild(objFrm);
	    objFrm.submit();
	},

    /**------------------------------------------------------------
	 * Function Name  : fnStripTags
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 17.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnStripTags: function(strHtml, allowTag) {
	    // allowTag = "<b>" or "<b><i>"...
	    allowTag = (((allowTag || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('');

	    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi;
	    var commentsAndJspTags = /<!--[\s\S]*?-->|<\?(?:jsp)?[\s\S]*?\?>/gi;

	    return strHtml.replace(commentsAndJspTags, '').replace(tags, function ($0, $1) {
	        return allowTag.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
        });
	},

    /**------------------------------------------------------------
	 * Function Name  : fnCutString
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 17.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnCutString: function(strValue, intCutLen) {	    
	    intLen = 0;

	    for (var i = 0; i < strValue.length; i++) {
	        intLen += (strValue.charCodeAt(i) > 128) ? 2 : 1;

	        if (intLen > intCutLen) {
	            return strValue.substring(0, i) + "...";
	        }
	    }

	    return strValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnStrLength
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 17.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnStrLength: function(strValue) {
	    var intLen = 0;

	    for (var i = 0; i < strValue.length; i++) {
	        intLen += (strValue.charCodeAt(i) > 128) ? 2 : 1;
	    }

	    return intLens;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnReplaceAll
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 17.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnReplaceAll: function (strValue, strOrgChar, strChgChar) {
	    return strValue.split(strOrgChar).join(strChgChar);
	},

    /**------------------------------------------------------------
	 * Function Name  : fnNumber
	 * Description    : -
	 * Author         : yangjeongmo, 2015. 10. 21.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnNumber: function (intPrecision) {
	    var thousands = ",";
	    var decimal = ".";
	    var precision = (intPrecision != "undefined") ? intPrecision : 0;
	    var prefix = "";

	    return {
	        display: function (d) {
	            var negative = d < 0 ? '-' : '';
	            d = Math.abs(parseFloat(d));

	            var intPart = parseInt(d, 10);
	            var floatPart = precision ?
                    decimal + (d - intPart).toFixed(precision).substring(2) :
                    '';

	            return negative + (prefix || '') +
                    intPart.toString().replace(
                        /\B(?=(\d{3})+(?!\d))/g, thousands
                    ) +
                    floatPart;
	        }
	    };
	},

    /**------------------------------------------------------------
	 * Function Name  : fnAddComma
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 17.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnAddComma: function (strValue) {
	    var strRetValue = "";
	    strRetValue += strValue;

	    var pattern = /(-?[0-9]+)([0-9]{3})/;

	    while (pattern.test(strRetValue)) {
	        strRetValue = strRetValue.replace(pattern, "$1,$2");
	    }

	    return strRetValue;
	},

    /**------------------------------------------------------------
	 * Function Name  : fnDelComma
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 17.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnDelComma: function (strValue) {
	    var strRetValue = "";
	    strRetValue += strValue;

	    return (strRetValue.replace(/\,/g, ""));
	},

    /**------------------------------------------------------------
	 * Function Name  : fnDelComma
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 17.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnDelColon: function (strValue) {
	    var strRetValue = "";
	    strRetValue += strValue;

	    return (strRetValue.replace(/\:/g, ""));
	},

    /**------------------------------------------------------------
	 * Function Name  : fnCheckSearchRange
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 05.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
	fnCheckSearchRange: function ($startDT, $endDT, strRange) {
	    var startDT = IONPay.Utils.fnReplaceAll($startDT.val(), "-", "");
	    var endDT   = IONPay.Utils.fnReplaceAll($endDT.val(), "-", "");

	    var startDTYear  = startDT.substring(4, 8);
	    var startDTMonth = Number(startDT.substring(2, 4)) - 1;
	    var startDTDay   = startDT.substring(0, 2);

	    var endDTYear  = endDT.substring(4, 8);
	    var endDTMonth = Number(endDT.substring(2, 4)) - 1;
	    var endDTDay   = endDT.substring(0, 2);

        var objStartDT = new Date(startDTYear, startDTMonth, startDTDay);
        var objEndDT   = new Date(endDTYear, endDTMonth, endDTDay);
        
        var diffDay = Math.floor((objEndDT - objStartDT) / (24 * 3600 * 1000));

        if (diffDay > (strRange * 31)) {
            IONPay.Msg.fnAlert(gMessage("MMS_JS_0005") + " " + strRange + gMessage("MMS_JS_0006"));

            $startDT.parent().datepicker({
                format: strDateFormat,
                autoclose: true,
                todayHighlight: true
            }).datepicker("update", new Date());

            $endDT.parent().datepicker({
                format: strDateFormat,
                autoclose: true,
                todayHighlight: true
            }).datepicker("update", new Date());

            return false;
        }

        return true;
	},

    fnSetEditor:function(selId) {
        $("#" + selId).wysihtml5();
    },

    fnReadonlyEditor:function(selId) {
        $("#" + selId).wysihtml5({"font-styles":  false,
					      "color":        false,
					      "emphasis":     false,
					      "textAlign":    false,
					      "lists":        false,
					      "blockquote":   false,
					      "link":         false,
					      "table":        false,
					      "image":        false,
					      "video":        false,
					      "html":         false});
    },
    
    /**------------------------------------------------------------
	 * Function Name  : fnHideSearchOptionArea
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 27.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnHideSearchOptionArea: function() {
        if ($("#searchCollapse").attr("class") == "collapse") {
            $("#searchCollapse").click();
        }
    },
    
    /**------------------------------------------------------------
	 * Function Name  : fnSetCookie
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 27.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnSetCookie: function (strCookieName, strValue, exdays) {
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + exdays);
        var strCookieValue = escape(strValue) + ((exdays==null) ? "" : "; expires=" + exdate.toUTCString());
        document.cookie = strCookieName + strCookieValue;
    },
    
    /**------------------------------------------------------------
	 * Function Name  : fnGetCookie
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 27.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnGetCookie: function (strValue) {
        var strName = strValue;
        var strCa = document.cookie.split(';');
        for (var i = 0; i < strCa.length; i++) {
            var c = strCa[i];
            while (c.charAt(0) == ' ') c = c.substring(1);
            if (c.indexOf(strName) == 0) return c.substring(strName.length, c.length);
        }

        return "";
    }
}

/**------------------------------------------------------------
 * IONPay.Msg
 ------------------------------------------------------------*/
IONPay.Msg = {
    /**------------------------------------------------------------
	 * Function Name  : fnAlert
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/    
    fnAlert: function (strMsg) {
        $("body").addClass("breakpoint-1024 pace-done modal-open ");
        $("#modalMsg").text(strMsg);
        $("#btnModalMsg").click();
    },

    /**------------------------------------------------------------
	 * Function Name  : fnAlertWithModal
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnAlertWithModal: function (strMsg, preModalId, preModalOpen) {
        strPreModalId  = preModalId;
        isPreModalOpen = preModalOpen;
        $("#" + preModalId).modal("hide");

        $("body").addClass("breakpoint-1024 pace-done modal-open ");
        $("#modalMsg").text(strMsg);
        $("#btnModalMsg").click();
    },

    /**------------------------------------------------------------
	 * Function Name  : fnConfirm
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnConfirm: function (strMsg, callBackFN) {
        $("body").addClass("breakpoint-1024 pace-done modal-open ");
        strCallBackFN = callBackFN;
        $("#modalConfirm").text(strMsg);
        $("#btnModalConfirm").click();
    },

    /**------------------------------------------------------------
	 * Function Name  : fnConfirm
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnConfirmWithModal: function (strMsg, callBackFN, preModalId, preModalOpen) {
        strPreModalId = preModalId;
        isPreModalOpen = preModalOpen;
        $("#" + preModalId).modal("hide");

        $("body").addClass("breakpoint-1024 pace-done modal-open ");
        strCallBackFN = callBackFN;
        $("#modalConfirm").text(strMsg);
        $("#btnModalConfirm").click();
    },

    /**------------------------------------------------------------
	 * Function Name  : fnResetBodyClass
	 * Description    : -
	 * Author         : ymjo, 2015. 10. 2.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnResetBodyClass: function () {
        $("body").removeClass();
        $("body").addClass("breakpoint-1024 pace-done ");
    },

    /**------------------------------------------------------------
	 * Function Name  : fnGetMessage
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 27.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnGetMessage: function (strMessageCode) {
        if (typeof (strMessageCode) != "string" || $.trim(strMessageCode) == "") {
            return;
        }
        
        var strMessage = "";
        
        try {
            strMessage = $.trim(MessageData[strMessageCode]);
            strMessage = (strMessage == "" ? "Empty" : strMessage);
        } catch (ex) {
            strMessage = "Empty";
        }

        return strMessage;
    },

    /**------------------------------------------------------------
	 * Function Name  : fnWriteMessage
	 * Description    : -
	 * Author         : ymjo, 2015. 11. 27.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    fnWriteMessage: function (strMessageCode) {
        if (typeof (strMessageCode) != "string" || $.trim(strMessageCode) == "") {
            return;
        }
        
        var strMessage = "";
        
        try {
            strMessage = $.trim(MessageData[strMessageCode]);
            strMessage = (strMessage == "" ? "Empty" : strMessage);
        } catch (ex) {
            strMessage = "Empty";
        }

        document.write(strMessage);
    }
}

/**------------------------------------------------------------
 * IONPay.Msg
 ------------------------------------------------------------*/
IONPay.Auth = {
    AuthCode: null,

    /**------------------------------------------------------------
	 * Function Name  : Init
	 * Description    :
	 * Author         : yangjeongmo, 2015. 10. 19.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    Init: function (pageAuthCode) {
        this.AuthCode = pageAuthCode;
        this.ShowAndHideButtons();
    },

    /**------------------------------------------------------------
	 * Function Name  : Refresh
	 * Description    :
	 * Author         : yangjeongmo, 2015. 10. 19.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    Refresh: function () {
        this.ShowAndHideButtons();
    },

    /**------------------------------------------------------------
	 * Function Name  : ShowAndHideButtons
	 * Description    : 1: all, 2: read only
	 * Author         : yangjeongmo, 2015. 10. 19.
	 * Modify History : Just Created.
	 ------------------------------------------------------------*/
    ShowAndHideButtons: function () {
        if (this.AuthCode == 1) {
            $(".auth-all").show();
            $(".auth-readonly").hide();
        } else if (this.AuthCode == 2) {
            $(".auth-readonly").show();
            $(".auth-all").hide();
        }
    }
}

/**------------------------------------------------------------
 * IONPay.Menu
 ------------------------------------------------------------*/
IONPay.Menu = {
    fnExpandMenuMaintain:function() {
	    $("#main-menu-wrapper").children("ul").each(function() {        
	        $(this).children("li").each(function() {
	            if ($(this).attr("class") == "active open") {
	                $(this).children("a").children("i").each(function(){
	                    if ($(this).attr("class") == "fa fa-folder-o") {
	                        $(this).attr("class", "fa fa-folder-open-o");
	                    }
	                });

	                $(this).children("a").children("span").each(function () {
	                    if ($(this).attr("class") == "arrow") {
	                        $(this).attr("class", "arrow open");
	                    }
	                });
	                
	                $(this).attr("class", "open");

	                $(this).children("ul").each(function () {
	                    $(this).show();
	                });

	                $(this).children("ul").children("li").each(function () {	                    
	                    if ($(this).attr("class") == "active") {
	                        $(this).children("ul").each(function () {
	                            $(this).show();
	                        });
	                    }
	                });
	            }
	        });     
	    });
    },

    fnExpandMenu:function(selId) {
        $("[id^='menu_i_']").each(function () {
            var id = IONPay.Utils.fnReplaceAll(this.id, "menu_i_", "");

            if (id == selId) {
                if ($("#menu_span_" + selId).attr("class") == "arrow") {
                    $("#" + this.id).attr("class", "fa fa-folder-open-o");
                } else {
                    $("#" + this.id).attr("class", "fa fa-folder-o");
                }
            } else {
                $("#" + this.id).attr("class", "fa fa-folder-o");                
            }            
        });
    }
}

/**------------------------------------------------------------
 * Document Ready
 ------------------------------------------------------------*/
$(document).ready(function () {    
    IONPay.Init.fnLoadPageEvent();

    //IONPay.Menu.fnExpandMenuMaintain();

    $("body .table thead tr th").attr("style", "font-weight:bold; border:1px solid #ddd; background-color:#ecf0f2; text-align:center;");

    try {
        $(".select2").select2();
    } catch(ex) { }

    try {
        $('.input-append.date').datepicker({
            format: strDateFormat,
            autoclose: true,
            todayHighlight: true
        }).datepicker("setDate", new Date());
    } catch(ex) { }

    $("#btnAlertModalTop, #btnAlertModalBottom").on("click", function () {
        $('#alertModal').modal('hide');
        
        if (strPreModalId != "" && strPreModalId != undefined && isPreModalOpen == true) {
            $('#' + strPreModalId).modal('show');
            strPreModalId = "";
        } else {
            IONPay.Msg.fnResetBodyClass();
        }
    });

    $("#btnConfirmModalTop, #btnConfirmModalBottm").on("click", function () {
        $('#confirmModal').modal('hide');

        try {
            if (strPreModalId != "" && strPreModalId != undefined && isPreModalOpen == true) {
                $('#' + strPreModalId).modal('show');
                strPreModalId = "";
            } else {
                IONPay.Msg.fnResetBodyClass();
            }
        } catch (ex) {
            IONPay.Msg.fnResetBodyClass();
        }
    });

    try {
        $('.auto').autoNumeric('init');
    } catch(ex) { }

    try {
        $('.clockpicker ').clockpicker({
            autoclose: true
        });
    } catch(ex) { }

    try {
        $('#MEMO_EDITOR').wysihtml5();
    } catch(ex) { }
    
    try {
        $('.panel-group').collapse({
            toggle: false
        });
    } catch(ex) { }

    try {
        $('#tab-01 a, #tab-02 a').click(function (e) {            
            e.preventDefault();
            $(this).tab('show');
        });
    } catch(ex) { }

    try {
        $("[id^=btnEditCancel").each(function () {
            $(this).on("click", function () {
                $(".grid .tools .remove").click();
            });
        });
    } catch (ex) { }

    $.validator.addMethod("notEqualTo", function (value, element, param) {
        return this.optional(element) || value != $(param).val();
    }, "Please specify a different value.");

    $.validator.addMethod("dupId", function (value, element, param) {
        return this.optional(element) || "N" != $(param).val();
    }, "Please specify a different Id.");

    $.validator.addMethod("alphaNumeric", function (value, element, param) {
        return this.optional(element) || /^[a-zA-Z0-9]+$/.test(value);
    }, "Please input alphanumeric characters only for Id.");
    
    $.validator.addMethod("passwordCheck", function (value, element) {
        return this.optional(element) || /^.*(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/.test(value);
    }, "Please enter a valid password value.(character + number + special character)");
    
    $.validator.addMethod("pwCheckConsecChars", function (value, element, param) {
        return this.optional(element) || !/(.)\1{2,}/.test(value);
    }, "The password must not contain 3 consecutive identical characters.");
    
    try {
        $("#divSearchDateType1 > button").on("click", function (e) {
            if ($(this).attr("id") == "btnToday") {
                IONPay.Utils.fnDatePicker("Day", 0, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn1Week") {
                IONPay.Utils.fnDatePicker("Day", -6, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn1Month") {
                IONPay.Utils.fnDatePicker("Month", -1, "txtFromDate", "txtToDate");
            }
        });
    } catch(ex) { }

    try {
        $("#divSearchDateType2 > button").on("click", function (e) {
            if ($(this).attr("id") == "btnToday") {
                IONPay.Utils.fnDatePicker("Day", 0, "txtFromDate2", "txtToDate2");
            } else if ($(this).attr("id") == "btn1Week") {
                IONPay.Utils.fnDatePicker("Day", -6, "txtFromDate2", "txtToDate2");
            } else if ($(this).attr("id") == "btn1Month") {
                IONPay.Utils.fnDatePicker("Month", -1, "txtFromDate2", "txtToDate2");
            }
        });
    } catch(ex) { }

    try {
        $("#divSearchDateType3 > button").on("click", function (e) {
            if ($(this).attr("id") == "btn1Month") {
                IONPay.Utils.fnDatePicker("Month", -1, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn2Month") {
                IONPay.Utils.fnDatePicker("Month", -2, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn3Month") {
                IONPay.Utils.fnDatePicker("Month", -3, "txtFromDate", "txtToDate");
            }
        });
    } catch(ex) { }

    try {
        $("#divSearchDateType4 > button").on("click", function (e) {
            if ($(this).attr("id") == "btnToday") {
                IONPay.Utils.fnDatePicker("Day", 0, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn1Week") {
                IONPay.Utils.fnDatePicker("Day", -6, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn1Month") {
                IONPay.Utils.fnDatePicker("Month", -1, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn2Month") {
                IONPay.Utils.fnDatePicker("Month", -2, "txtFromDate", "txtToDate");
            } else if ($(this).attr("id") == "btn3Month") {
                IONPay.Utils.fnDatePicker("Month", -3, "txtFromDate", "txtToDate");
            }
        });
    } catch (ex) { }

    try {
        $("#divSearchDateType5 > button").on("click", function (e) {
            if ($(this).attr("id") == "btnToday") {
                IONPay.Utils.fnDatePicker("Day", 0, "txtToDate", "txtFromDate");
            } else if ($(this).attr("id") == "btn1Week") {
                IONPay.Utils.fnDatePicker("Day", 6, "txtToDate", "txtFromDate");
            } else if ($(this).attr("id") == "btn1Month") {
                IONPay.Utils.fnDatePicker("Month", 1, "txtToDate", "txtFromDate");
            } else if ($(this).attr("id") == "btn2Month") {
                IONPay.Utils.fnDatePicker("Month", 2, "txtToDate", "txtFromDate");
            } else if ($(this).attr("id") == "btn3Month") {
                IONPay.Utils.fnDatePicker("Month", 3, "txtToDate", "txtFromDate");
            }
        });

        if (isAutoSetMonth) {
            IONPay.Utils.fnDatePicker("Month", 1, "txtToDate", "txtFromDate");
        }
    } catch (ex) { }  

	try {
        $("#divSearchDateType6 > button").on("click", function (e) {
            if ($(this).attr("id") == "btnToday") {
                IONPay.Utils.fnDatePicker("Day", 0, "txtFromDate6", "txtToDate6");
            } else if ($(this).attr("id") == "btn1Week") {
                IONPay.Utils.fnDatePicker("Day", -6, "txtFromDate6", "txtToDate6");
            } else if ($(this).attr("id") == "btn1Month") {
                IONPay.Utils.fnDatePicker("Month", -1, "txtFromDate6", "txtToDate6");
            }
        });
    } catch(ex) { }		
}).on("keydown", function (e) {
	// Prevnt Refresh
	var allowPageList = new Array('/sample/index');
	var bBlockF5Key   = true;

	for (number in allowPageList) {
		var regExp = new RegExp('^' + allowPageList[number] + '.*', 'i');

		if (regExp.test(document.location.pathname)) {
			bBlockF5Key = false;
			break;
		}
	}

	if (bBlockF5Key) {
		if (e.which === 116) {
			if (typeof event == "object") {
				event.keyCode = 0;
			}

			return false;
		} else if (e.which === 82 && e.ctrlKey) {
			return false;
		} else if (e.which === 78 && e.ctrlKey) {
			return false;
		}
	}
}).on("hide.bs.modal", "div[id^='modal']", function () {
    IONPay.Msg.fnResetBodyClass();
});