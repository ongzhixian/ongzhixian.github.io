var generic = {

    scriptProperties: PropertiesService.getScriptProperties(),
    userProperties: PropertiesService.getUserProperties(),
    documentProperties: PropertiesService.getDocumentProperties(),

    counter: function (pj) {
        // Simple website counter
        // https://script.google.com/macros/s/AKfycbzUD1buA-9AKZzXxTc9HXIzfbBSZj7TmZkFx4Zgalc/dev?fn=counter
        count = parseInt(generic.scriptProperties.getProperty('COUNTER'), 10);

        if (isNaN(count)) {
            count = 1;
        } else {
            count = count + 1;
        }
        generic.scriptProperties.setProperty('COUNTER', count);

        return count;
    },

    ok: function OK() {
        // https://script.google.com/macros/s/AKfycbzUD1buA-9AKZzXxTc9HXIzfbBSZj7TmZkFx4Zgalc/dev?fn=ok
        return "OK"; // return ContentService.createTextOutput("OK");
    },

    echo: function Echo(pj) {
        // https://script.google.com/macros/s/AKfycbzUD1buA-9AKZzXxTc9HXIzfbBSZj7TmZkFx4Zgalc/dev?fn=echo&msg=some message
        var msg = undefined;

        if (pj.hasOwnProperty("msg")) {
            msg = pj["msg"];
        } else {
            msg = "parameter [msg] is missing; [msg] is case-sensitive";
        }

        return msg;
    },

    uuid: function UUID() {
        return Utilities.getUuid();
    },

};


// Main script
// Handles routing
function XdoGet(e) {
    var result = undefined,
        output_type = "HTML",
        fn = undefined;

    if (e.queryString == null) {
        return ContentService.createTextOutput("OK");
    }

    // https://script.google.com/macros/s/AKfycbzUD1buA-9AKZzXxTc9HXIzfbBSZj7TmZkFx4Zgalc/dev?fn=ECHO
    if (e.parameter.hasOwnProperty("fn")) {
        fn = e.parameter["fn"].toUpperCase();
    } else {
        return ContentService.createTextOutput("fn is missing; fn is case-sensitive");
    }

    // https://script.google.com/macros/s/AKfycbzUD1buA-9AKZzXxTc9HXIzfbBSZj7TmZkFx4Zgalc/dev?fn=ECHO&output_type=text
    // https://script.google.com/macros/s/AKfycbzUD1buA-9AKZzXxTc9HXIzfbBSZj7TmZkFx4Zgalc/dev?fn=ECHO&output_type=html
    if (e.parameter.hasOwnProperty("output_type")) {
        output_type = e.parameter["output_type"].toUpperCase();
    }
    if ((output_type !== "HTML") || (output_type !== "TEXT")) {
        output_type = "HTML";
    }



    // See https://developers.google.com/apps-script/guides/web
    // e.parameter
    // e.parameters

    switch (fn) {

        case "SAMPLE_PAGE":
            return HtmlService.createHtmlOutputFromFile('counter');
            break;

        case "COUNTER2":
            result = generic.counter(e.parameter);
            return HtmlService.createHtmlOutput(result);
            break;

        case "COUNTER":
            result = generic.counter(e.parameter);
            break;

        case "ECHO":
            result = generic.echo(e.parameter);
            break;

        case "OK":
            result = generic.ok(e.parameter);
            break;

        case "UUID":
            result = generic.uuid(e.parameter);
            break;

        default:
            result = e.parameter["fn"].toUpperCase()
            break;
    }

    return ContentService.createTextOutput(result);
    //return ContentService.createTextOutput(Utilities.getUuid());
}



