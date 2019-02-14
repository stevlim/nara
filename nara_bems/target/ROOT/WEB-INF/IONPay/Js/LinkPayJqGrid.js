//function fnGrid(tableNm, url, param, colNm, colModel){
//	var template_int = {
//		formatter : 'int',
//		align : 'center',
//		sorttype : 'int'
//	};
//	var template_float = {
//		formatter : 'float',
//		align : 'right',
//		sorttype : 'float'
//	};
//	var template_date = {
//		align : 'center',
//		sorttype : 'date'
//	};
//	jQuery(tableNm).jqGrid({
//		url:url,
//        //로딩중일때 출력시킬 로딩내용
//        loadtext : '로딩중..', //
//     	// 요청방식
//        mtype:"post",
//        datatype : "json",
//        ajaxGridOptions: { contentType: "application/json" },
//        postData:  param,
//        serializeGridData: function (postData) {
//            return JSON.stringify(postData);
//        },
//		height : 500,
//		width : 1250,
//		//date : [{id:"1",invdate:"2007-10-01",name:"test",note:"note",amount:"200.00",tax:"10.00",total:"210.00"}],   //데이터 등록 시 사용.
//		colNames : colNm,
//		colModel : colModel,
//		sortname: 'RNUM',
//		sortorder: "desc",
//		viewrecords: true,
//	    loadonce :false,
//		pager : '#pager',
//		shrinkToFit:true,
//		gridview : true,
//		rownumbers : false,
//		rowNum : 10,
//		rowList : [ 5, 10, 20, 30 ],
//		caption : '조회 결과',
//		onSelectRow: function(ids) {    //row 선택시 처리. ids는 선택한 row
//			alert('row 선택시 ids:'+ids);
//        },
////		jsonReader: {
////			page: function () {
////		        return 10;
////		    },
////		    total: function () {
////		        return 10;
////		    },
////			records: function(obj){return obj.rows},
////			repeatitems: false
////		},
//		loadBeforeSend: function(jqXHR) {
//			jqXHR.setRequestHeader("IMSRequestVerificationToken", IONPay.AntiCSRF.getVerificationToken());
//		},
//		gridComplete : function() {
//			// 성공적으로 그리드가 완료 되었을때 실행되는 부분
////    	   console.log(objJson.data);
//		},
//		loadComplete: function (objJson) {
//			//IONPay.Msg.fnAlert("OK");
//			console.log(objJson);
//			for (var i = 0; i <= objJson.data.length; i++) {
//				jQuery(tableNm).jqGrid('addRowData', i + 1, objJson.data[i]);
//			}
//			jQuery(tableNm).jqGrid.rowNum = 10;
//			gridComplete(tableNm);
//		},
//		loadError:function(xhr, status, error) {
//			// 데이터 로드 실패시 실행되는 부분
//			alert(error); 
//		},
//       emptyrecords:"데이터가 존재하지 않습니다.",
//	}).navGrid('#pager',{edit:false,add:false,del:false, search:true})
//	
//	fnHideJqgridRow();
//	 
////	for (var i = 0; i <= mydata.length; i++) {
////		jQuery(tableNm).jqGrid('addRowData', i + 1, mydata[i]);
////	}
////	jQuery(tableNm).jqGrid.rowNum = 10;
////	gridComplete(tableNm);
//}

//function fnAdd(tableNm, url, param, colNm, colModel){
//	fnGrid(tableNm, url, param, colNm, colModel);
//	jQuery(tableNm).trigger("reloadGrid");
//}

var mydata = [
		{
			id : "1",
			invdate : "2007-10-01",
			name : "test",
			note : "note",
			amount : "200.00",
			tax : "10.00",
			total : "210.00"
		},
		{
			id : "2",
			invdate : "2007-10-02",
			name : "test2",
			note : "note2",
			amount : "300.00",
			tax : "20.00",
			total : "320.00"
		},
		{
			id : "3",
			invdate : "2007-09-01",
			name : "test3",
			note : "note3",
			amount : "400.00",
			tax : "30.00",
			total : "430.00"
		},
		{
			id : "4",
			invdate : "2007-10-04",
			name : "test",
			note : "note",
			amount : "200.00",
			tax : "10.00",
			total : "210.00"
		},
		{
			id : "5",
			invdate : "2007-10-05",
			name : "test2",
			note : "note2",
			amount : "300.00",
			tax : "20.00",
			total : "320.00"
		},
		{
			id : "6",
			invdate : "2007-09-06",
			name : "test3",
			note : "note3",
			amount : "400.00",
			tax : "30.00",
			total : "430.00"
		},
		{
			id : "7",
			invdate : "2007-10-04",
			name : "test",
			note : "note",
			amount : "200.00",
			tax : "10.00",
			total : "210.00"
		},
		{
			id : "8",
			invdate : "2007-10-03",
			name : "test2",
			note : "note2",
			amount : "300.00",
			tax : "20.00",
			total : "320.00"
		},
		{
			id : "9",
			invdate : "2007-09-01",
			name : "test3",
			note : "note3",
			amount : "400.00",
			tax : "30.00",
			total : "430.00"
		},
		{
			id : "10",
			invdate : "2007-09-01",
			name : "test3",
			note : "note3",
			amount : "400.00",
			tax : "30.00",
			total : "430.00"
		},
		{
			id : "11",
			invdate : "2007-10-01",
			name : "test",
			note : "note",
			amount : "200.00",
			tax : "10.00",
			total : "210.00"
		},
		{
			id : "12",
			invdate : "2007-10-02",
			name : "test2",
			note : "note2",
			amount : "300.00",
			tax : "20.00",
			total : "320.00"
		},
		{
			id : "13",
			invdate : "2007-09-01",
			name : "test3",
			note : "note3",
			amount : "400.00",
			tax : "30.00",
			total : "430.00"
		},
		{
			id : "14",
			invdate : "2007-10-04",
			name : "test",
			note : "note",
			amount : "200.00",
			tax : "10.00",
			total : "210.00"
		},
		{
			id : "15",
			invdate : "2007-10-05",
			name : "test2",
			note : "note2",
			amount : "300.00",
			tax : "20.00",
			total : "320.00"
		},
		{
			id : "16",
			invdate : "2007-09-06",
			name : "test3",
			note : "note3",
			amount : "400.00",
			tax : "30.00",
			total : "430.00"
		},
		{
			id : "17",
			invdate : "2007-10-04",
			name : "test",
			note : "note",
			amount : "200.00",
			tax : "10.00",
			total : "210.00"
		},
		{
			id : "18",
			invdate : "2007-10-03",
			name : "test2",
			note : "note2",
			amount : "300.00",
			tax : "20.00",
			total : "320.00"
		},
		{
			id : "19",
			invdate : "2007-09-01",
			name : "test3",
			note : "note3",
			amount : "400.00",
			tax : "30.00",
			total : "430.00"
		}
		];


var mybar_data = [
                	{
                		id : "test-1",
                		invdate : "2007-10-01",
                		name : "test-test",
                		note : "note",
                		amount : "200.00",
                		tax : "10.00",
                		total : "210.00"
                	},
                	{
                		id : "test-2",
                		invdate : "2007-10-02",
                		name : "test-test2",
                		note : "note2",
                		amount : "300.00",
                		tax : "20.00",
                		total : "320.00"
                	},
                	{
                		id : "test-3",
                		invdate : "2007-09-01",
                		name : "test-test3",
                		note : "note3",
                		amount : "400.00",
                		tax : "30.00",
                		total : "430.00"
                	},
                	{
                		id : "test-4",
                		invdate : "2007-10-04",
                		name : "test-test4",
                		note : "note",
                		amount : "200.00",
                		tax : "10.00",
                		total : "210.00"
                	},
                	{
                		id : "test-5",
                		invdate : "2007-10-05",
                		name : "test-test5",
                		note : "note2",
                		amount : "300.00",
                		tax : "20.00",
                		total : "320.00"
                	},
                	];



//화면 뿌림 
gridComplete = function(tableNm){
	var rowIDs = jQuery(tableNm).jqGrid('getDataIDs');
	for (var i = 0; i < rowIDs.length; i++) {
		var rowID = rowIDs[i];
		var row = jQuery(tableNm).jqGrid('getRowData', rowID);
	}
}
//첫째줄 숨기기
function fnHideJqgridRow (){
	jQuery(".jqgfirstrow").css("cssText", "width:0px!important;height:0px!important;display:none!important");
}


function fnGrid(){
	var template_int = {
			formatter : 'int',
			align : 'center',
			sorttype : 'int'
		};
		var template_float = {
			formatter : 'float',
			align : 'right',
			sorttype : 'float'
		};
		var template_date = {
			align : 'center',
			sorttype : 'date'
		};
		var col_names = [ 'Inv No', 'Date', 'Client', 'Amount',
				'Tax', 'Total', 'Notes'];
		var col_model = [
	    {
			name : 'id',
			index : 'id',
			width : 80,
			template : template_int
		},
		{
			name : 'invdate',
			index : 'invdate',
			width : 90,
			template : template_date
		},
		{
			name : 'name',
			index : 'name',
			width : 100
		},	
		{
			name : 'amount',
			index : 'amount',
			width : 80,
			template : template_float
		},
		{
			name : 'tax',
			index : 'tax',
			width : 80,
			template : template_float
		},
		{
			name : 'total',
			index : 'total',
			width : 80,
			template : template_float
		},
		{
			name : 'note',
			index : 'note',
			width : 150,
			sortable : false
		}
		];

		jQuery("#list").jqGrid({
			datatype : "local", 			// 데이터 요청방식
			height : 500,					// 그리드 높이 설정
//			width : 'auto',					// 그리드 전체 넓이 조정 (오토 조절 가능) 
			autowidth:true,              // 오토 조절 가능 (width 옵션과 동시 사용 불가!)
			colNames : col_names, 	// 각각의 컬럼에 출력되는 이름
			colModel : col_model, 	// 각 컬럼에 대한 상세 정보
			//loadtext : '로딩중..', 		// 서버연동시 loading 중이라는 표시가 뜨는데 그곳의 문자열 지정
			//emptyrecords : '데이터 없음' ,   		//데이터가 없을경우 보여줄 문자열 지정
			sortname: 'name',			// 처음 그리드를 불러올 때에 정렬 기준 컬럼
			viewrecords: true,			// 그리드가 보여줄 총 페이지 현재 페이지등의 정보를 노출
			//multiselect: true,           // 멀티 셀렉트 박스가 첫번째 컬럼에 생김
		    sortorder: "desc",				// 정렬 기준
		    //sortable: true,               // colmodel 에서 sortable 기능 사용하려면 true!
		    loadonce :false,				// reload 여부이며 true 로 설정하면 한번만 데이터를 받아오고 그 다음부터는 데이터를 받아오지 않는다.
			pager : '#pager',				// 페이징을 처리할 <div> 태그의 #+id값
			//editurl: "URL.action",    // 셀이 수정될 때 수정 요청을 받아서 처리할 URL
	        //cellEdit: true,					// 셀 수정 기능을 사용하려면 true!
			shrinkToFit:true,				// 우측스크롤바 위의 조그만 공간 없애고 거기까지 width채움  default:true
			rownumbers : true,			// 맨앞에 줄번호 보이기 여부
			rowNum : 10, 					// 한화면에 보여줄 row의 수 ,-1하면 무한으로 보여줌
			rowList : [ 5, 10, 15 ],		// 한 화면에서 볼 수 있는 row의 수를 조절 가능
			//rownumbers: true,         // row의 숫자를 표시해준다.
			caption : 'Test Dashboard',		// 그리드 상단에 그리드의 제목을 입력할 수 있음
			//postData : data						//jqGrid 데이터 요청을 위해서 서버 request 시 추가로 넘기고자
			gridComplete : function() {
				//한 row가 뿌려질때마다 수행 됨.
			}
		}).navGrid('#pager',{edit:false,add:false,del:false, search:true});
		
		for (var i = 0; i <= mydata.length; i++) {
			jQuery("#list").jqGrid('addRowData', i + 1, mydata[i]);
		}
		jQuery("#list").jqGrid.rowNum = 10;
		gridComplete();
}
function fnAdd(){
	for (var i = 0; i <= mybar_data.length; i++) {
		jQuery("#list").jqGrid('addRowData', i + 1, mybar_data[i]);
	}
	jQuery("#list").jqGrid.rowNum = 10;
	gridComplete();
	jQuery("#list").trigger("reloadGrid");
}