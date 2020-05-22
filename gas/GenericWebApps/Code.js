function doGet(e) {

    // Run the following link to view dev version (it supports hot-reload). So you don't have to keep publishing. Just need to save.
    // https://script.google.com/macros/s/AKfycbzUD1buA-9AKZzXxTc9HXIzfbBSZj7TmZkFx4Zgalc/dev

    if (e.queryString == "") {
        return ContentService.createTextOutput("OK - no query string");
    }

    return ContentService.createTextOutput("OK" + e.queryString + "]");
    // 
    return HtmlService.createHtmlOutputFromFile('counter');
}

// https://github.com/gsuitedevs/apps-script-samples