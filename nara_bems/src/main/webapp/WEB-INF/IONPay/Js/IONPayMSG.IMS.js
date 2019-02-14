var gMessage;

var IONPayMSG = {
    MESSAGEPROPERTIESPATH: "/IONPay/Language/"
}

/**------------------------------------------------------------
 * IONPayMSG.Language
 ------------------------------------------------------------*/
IONPayMSG.Language = {
    fnSetLanguage: function () {

        jQuery.i18n.properties({
            name: 'message',
            path: IONPayMSG.MESSAGEPROPERTIESPATH,
            mode: 'both',
            language: IONPayMSG.Language.fnGetCookie(),
            callback: function () { }
        });

        gMessage = jQuery.i18n.prop;
    },

    fnGetCookie: function () {
        var strName = "IMSLanguage=";
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
 * Document Ready
 ------------------------------------------------------------*/
$(document).ready(function () {
    IONPayMSG.Language.fnSetLanguage();
})