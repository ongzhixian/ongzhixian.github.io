

/*
    The base service provides the following 4 objects:
    1.  Browser     dialog boxes specific to Google Sheets. var name = Browser.inputBox('Enter your name');
    2.  Logger      write out text to the debugging logs, Logger.getLog(); Logger.log(files.next().getName()); Logger.log('You are a member of %s Google Groups.', groups.length);
                    -- https://developers.google.com/apps-script/reference/base/logger
    3.  MimeType    MimeType.GOOGLE_DOCS 
                    -- See: https://developers.google.com/apps-script/reference/base/mime-type
    4.  Session     Access to session information Session.getActiveUser().getEmail();
                    -- See: https://developers.google.com/apps-script/reference/base/session
    5.  console     logs to the GCP Stackdriver Logging service.   console.log(parameters); log/error/info/warn

    See: https://developers.google.com/apps-script/reference/base
    
*/
function myFunction() {
    var files = DriveApp.getFiles();
  while (files.hasNext()) {
    var file = files.next();
    
    
}




oauthScopes": [
    "https://www.googleapis.com/auth/spreadsheets.readonly",
    "https://www.googleapis.com/auth/userinfo.email"
    
    
oauthScopes": [
    "https://mail.google.com/",
    "https://www.googleapis.com/auth/documents",
    "https://www.googleapis.com/auth/drive.readonly",
    "https://www.googleapis.com/auth/spreadsheets",
  ],
  