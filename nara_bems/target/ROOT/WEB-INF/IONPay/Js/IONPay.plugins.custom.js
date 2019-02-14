/**------------------------------------------------------------
 * File Name      : IONPay.plugins.custom.js 
 * Author         : yangjeongmo, 2015-10-02
 * Modify History : Just Created.
 ------------------------------------------------------------*/

 /**------------------------------------------------------------
 * Function Name  : serializeObject
 * Description    : Get Serialize Object
 * Author         : yangjeongmo, 2015-10-02
 * Modify History : Just Created.
 ------------------------------------------------------------*/
 $.fn.serializeObject = function () {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function () {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

 /**------------------------------------------------------------
 * Function Name  : dataTable.Api.register
 * Description    : Data Table Pipeline
 * Author         : yangjeongmo, 2015-10-02
 * Modify History : Just Created.
 ------------------------------------------------------------*/
$.fn.dataTable.Api.register('clearPipeline()', function () {
    return this.iterator('table', function (settings) {
        settings.clearCache = true;
    });
});

 /**------------------------------------------------------------
 * Function Name  : forceNumeric
 * Description    : Only Numeric
 * Author         : yangjeongmo, 2015-10-02
 * Modify History : Just Created.
 ------------------------------------------------------------*/
$.fn.forceNumeric = function () {

     return this.each(function () {
         $(this).keydown(function (e) {
             var key = e.which || e.keyCode;

             if (!e.shiftKey && !e.altKey && !e.ctrlKey &&
                 // numbers   
                 key >= 48 && key <= 57 ||
                 // Numeric keypad
                 key >= 96 && key <= 105 ||
                 // comma, period and minus, . on keypad
                key == 190 || key == 188 || key == 109 || key == 110 ||
                 // Backspace and Tab and Enter
                key == 8 || key == 9 || key == 13 ||
                 // Home and End
                key == 35 || key == 36 ||
                 // left and right arrows
                key == 37 || key == 39 ||
                 // Del and Ins
                 key == 46 || key == 45) {

                 return true;
             } else if (e.ctrlKey){
                 //ctrl-c       ctrl-v       ctrl-x
                 if (key==67 || key==86  || key==88) {
                     return true;
                 }
             }
             return false;
         });

        $(this).on("keyup change paste", function (e) {
            if ( new RegExp(/[^0-9]+/).test(this.value) ){
                this.value = this.value.replace(/[^0-9]+/g, "");
            }
         });
 
     });
 }

 /**------------------------------------------------------------
 * Function Name  : forceNumeric
 * Description    : Only IP
 * Author         : yangjeongmo, 2015-10-02
 * Modify History : Just Created.
 ------------------------------------------------------------*/
 $.fn.forceIPMask = function () {

     return this.each(function () {
         $(this).keydown(function (e) {
             var key = e.which || e.keyCode;

             console.log(e);
             console.log(key);

             if (!e.shiftKey && !e.altKey && !e.ctrlKey &&
                 //decimal point
                 key == 110 ||
                 // numbers   
                 key >= 48 && key <= 57 ||
                 // Numeric keypad
                 key >= 96 && key <= 105 ||
                 // comma, period and minus, . on keypad
                 key == 190 || key == 188 || key == 109 || key == 110 ||
                 // Backspace and Tab and Enter
                 key == 8 || key == 9 || key == 13 ||
                 // Home and End
                 key == 35 || key == 36 ||
                 // left and right arrows
                 key == 37 || key == 39 ||
                 // Del and Ins
                 key == 46 || key == 45) {

                 return true;
             } else if (e.ctrlKey) {
                 //ctrl-c       ctrl-v       ctrl-x
                 if (key == 67 || key == 86 || key == 88) {
                     return true;
                 }
             }
             return false;
         });

        $(this).on("keyup change paste", function (e) {
             if (new RegExp(/[^0-9|.]+/).test(this.value)) {
                 this.value = this.value.replace(/[^0-9|.]+/g, "");
             }             
         });

     });
 }

/**------------------------------------------------------------
* Function Name  : Date Format(yyyymmdd)
* Description    : yyyy mm dd
* Author         : yangjeongmo, 2015-10-02
* Modify History : Just Created.
------------------------------------------------------------*/
 Date.prototype.yyyymmdd = function () {
     var yyyy = this.getFullYear().toString();
     var mm = (this.getMonth() + 1).toString();
     var dd = this.getDate().toString();
     return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]);
 };

/**------------------------------------------------------------
* Function Name  : Date Format
* Description    : 
* Author         : yangjeongmo, 2015-10-02
* Modify History : Just Created.
------------------------------------------------------------*/
 Date.prototype.format = function (f) {
     if (!this.valueOf()) return " ";

     var weekName = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
     var d = this;

     return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
         switch ($1) {
             case "yyyy": return d.getFullYear();
             case "yy": return (d.getFullYear() % 1000).zf(2);
             case "MM": return (d.getMonth() + 1).zf(2);
             case "dd": return d.getDate().zf(2);
             case "E": return weekName[d.getDay()];
             case "HH": return d.getHours().zf(2);
             case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
             case "mm": return d.getMinutes().zf(2);
             case "ss": return d.getSeconds().zf(2);
             case "a/p": return d.getHours() < 12 ? "AM" : "PM";
             default: return $1;
         }
     });
 };

 String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
 String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
 Number.prototype.zf = function (len) { return this.toString().zf(len); };
