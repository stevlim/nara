
//js slide Banks
$(document).ready(function() {
	"use strict";
	$('#slide_banks').lightSlider({
		item:1,
		slideMargin:0,
		loop:false,
		auto:false,
        enableDrag: true,
		controls:true,
		pager:true,
		pauseOnHover: true,
	});
});

//accordion left menu
$(document).ready(function() {
	"use strict";
	var acc = document.getElementsByClassName("accmms");
	var i;

	for (i = 0; i < acc.length; i++) {
	  acc[i].addEventListener("click", function() {
		this.classList.toggle("active");
		var pnl = this.nextElementSibling;
		if (pnl.style.maxHeight){
		  pnl.style.maxHeight = null;
		} else {
		  pnl.style.maxHeight = pnl.scrollHeight + "px";
		} 
	  });
	}
});


//accordion boxpaymoney
$(document).ready(function() {
	"use strict";
	var pm = document.getElementsByClassName("adevent");
	var i;

	for (i = 0; i < pm.length; i++) {
	  pm[i].addEventListener("click", function() {
		this.classList.toggle("active");
	  });
	}
});


//accordion notifications
$(document).ready(function() {
	"use strict";
	var pm = document.getElementsByClassName("accnoti");
	var i;

	for (i = 0; i < pm.length; i++) {
	  pm[i].addEventListener("click", function() {
		this.classList.toggle("active");
		var inf = this.nextElementSibling;
		if (inf.style.maxHeight){
		  inf.style.maxHeight = null;
		} else {
		  inf.style.maxHeight = inf.scrollHeight + "px";
		} 
	  });
	}
});


//js slide Merchant
$(document).ready(function() {
	"use strict";
	$('#slide_merchant').lightSlider({
		item:1,
		slideMargin:0,
		loop:false,
		auto:false,
        enableDrag: false,
		controls:true,
		pager:true,
		pauseOnHover: true,
		prevHtml:['<i class="icon-farr-left"></i>'],
		nextHtml:['<i class="icon-farr-right"></i>'], 
	});
});

//js slide Sett
$(document).ready(function() {
	"use strict";
	$('#slide_month').lightSlider({
		item:1,
		slideMargin:0,
		loop:false,
		auto:false,
        enableDrag: false,
		controls:true,
		pager:false,
		pauseOnHover: true,
		prevHtml:['<span class="spnarr">Prev<br />month</span><i class="icon-tarr-left"></i>'],
		nextHtml:['<span class="spnarr">Next<br />month</span><i class="icon-tarr-right"></i>'], 
	});
});

//js slide Sett
$(document).ready(function() {
	"use strict";
	$('#slide_except').lightSlider({
		item:1,
		slideMargin:0,
		loop:false,
		auto:false,
        enableDrag: false,
		controls:true,
		pager:false,
		pauseOnHover: true,
		prevHtml:['<span class="spnarr">Prev<br />month</span><i class="icon-tarr-left"></i>'],
		nextHtml:['<span class="spnarr">Next<br />month</span><i class="icon-tarr-right"></i>'], 
	});
});


//js show/hide left menu
$(document).ready(function() {
	"use strict";
    $('.btnmenu').click(function() {
		 $('.main_nav').show().animate({left: 0});
    });
	$('.btnclosenav').click(function() {
		 $('.main_nav').show().animate({left: -335});
    });
});

//js tab sett
$(document).ready(function() {
	"use strict";
  $('.subtabsett > li').on('click', function() {
    show_content($(this).index());
  });
  
  show_content(0);

  function show_content(index) {
    // Make the content visible
    $('.tab_content_sett .subcontentsett.visible').removeClass('visible');
    $('.tab_content_sett .subcontentsett:nth-of-type(' + (index + 1) + ')').addClass('visible');

    // Set the tab to selected
    $('.subtabsett > li.selected').removeClass('selected');
    $('.subtabsett > li:nth-of-type(' + (index + 1) + ')').addClass('selected');
  }
});


//js select transaction type
$(document).ready(function() {
	"use strict";
    $(document).on('click', '.choisetype > li',function () {
        $('.choisetype > li').removeClass("active");
        $(this).addClass("active");
    });
});

//js select preriod
$(document).ready(function() {
	"use strict";
    $(document).on('click', '.listdate > li',function () {
        $('.listdate > li').removeClass("active");
        $(this).addClass("active");
		if ($(".lifromto").hasClass('active')) {
			$("input.txtdaytoday").prop('disabled', false);
		} else {
			$("input.txtdaytoday").prop('disabled', true);
		}
    });
});


$(document).ready(function() {
	"use strict";
    $(document).on('click', '.listchoise_searchby > li',function () {
        $('.listchoise_searchby > li').removeClass("active");
        $(this).addClass("active");
    });
});


//select dropdownlist
$(document).ready(function() {
	"use strict";
  $('select:not(.ignore)').niceSelect();
//  FastClick.attach(document.body);
});



$(document).ready(function(){
	"use strict";
	$(".title_resulttrans").click(function() {
	  $(".resultcontenttrans").slideToggle("fast");
	  $(this).toggleClass("down");
	});
});



$(document).ready(function(){
	"use strict";
	$(".arrshowhide").click(function() {
	  $(".boxrefund_pop").slideToggle("fast");
	  $(this).toggleClass("active");
	});
});


$(document).ready(function(){
	"use strict";
	$(".arrshowhide").click(function() {
	  $(".insersearch").slideToggle("fast");
	  $(this).toggleClass("active");
	});
});


$(document).ready(function(){
	"use strict";
	$(".showhidemethod").click(function() {
	  $(".listmethod").slideToggle("fast");
	  $(this).toggleClass("active");
	});
});


//js select imoticon
$(document).ready(function() {
	"use strict";
    $(document).on('click', '.rowimoticon > span',function () {
        $('.rowimoticon > span').removeClass("active");
        $(this).addClass("active");
    });
});




//js show/hide dialog
$(document).ready(function() {
	"use strict";
    $('.btnpop').click(function() {
		 $('#dialog-1').slideToggle("fast");
		$('body').addClass("bodyoverflow");
    });
	$('.btnclose1').click(function() {
		 $('#dialog-1').slideToggle("fast");
		$('body').removeClass("bodyoverflow");
    });
});

$(document).ready(function() {
	"use strict";
    $('.btnarrpop').click(function() {
		 $('#dialog-2').slideToggle("fast");
		$('body').addClass("bodyoverflow");
    });
	$('.btnclose2').click(function() {
		 $('#dialog-2').slideToggle("fast");
		$('body').removeClass("bodyoverflow");
    });
});






