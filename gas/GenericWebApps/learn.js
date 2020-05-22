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
function listFiles() {

    console.log("In listFiles()");

    try {

        var folders = DriveApp.getFolders();

        console.log(folders);
        
        if (folders == null) {
            console.log("folders is null");
            return;
        }

        console.log("Before call");
        if (folders.hasNext())
        {
            console.log("folders hasNext");
        }
        console.log("After call");

        while (folders.hasNext()) {
            
            var folder = folders.next();
            
            console.log(folder.getName());
        }

        // var files = DriveApp.getFiles();
        // if (files == null) {
        //     console.log("Yep files is null");
        //     return;
        // } 
        // // Else
        // console.log("files is an object");

        // if (files.hasNext()) {
        //     console.log("files has next");
        // }

        console.log("End of listFiles()");
            
        // while (files.hasNext()) 
        // {
        //     var file = files.next();
        // }
    }
    catch(err) {
        console.error(err);
    }

}

function testLogging() {
    var msg = "Hellow login";

    // log
    // info
    // warn
    // error

    Logger.log(msg);    // Logs to "local" Google Apps Script logger
    console.log(msg);   // Logs to StackDriver


}


/**
 * Creates a Google Doc and sends an email to the current user with a link to the doc.
 */
function createAndSendDocument() {
    // Create a new Google Doc named 'Hello, world!'
    var doc = DocumentApp.create('Hello, world!');
    
    // Access the body of the document, then add a paragraph.
    doc.getBody().appendParagraph('This document was created by Google Apps Script.');
    
    // Get the URL of the document.
    var url = doc.getUrl();
    
    // Get the email address of the active user - that's you.
    var email = Session.getActiveUser().getEmail();
    
    // Get the name of the document to use as an email subject line.
    var subject = doc.getName();
    
    // Append a new string to the "url" variable to use as an email body.
    var body = 'Link to your doc: ' + url;
    
    // Send yourself an email with a link to the document.
    GmailApp.sendEmail(email, subject, body);
  }
  
  function testEmail() {
      GmailApp.sendEmail('zhixian@hotmail.com', 'Subject line', 'This is the body.');
      
  }

function testDriveApp() {

    console.log("In testDriveApp2");

    // Log the name of every file in the user's Drive.
    var files = DriveApp.getFiles();
    
    console.log("Access", DriveApp.Access);
    console.log("Permission", DriveApp.Permission);
    
    console.log("BEFORE next");
    try {

        // files.next();
        while (files.hasNext()) {
         var file = files.next();
         console.log(file.getName());
      }



    } catch (error) {
        console.error(error);
    }
    
    console.log("AFTER next");
    // while (files.hasNext()) {
    //     var file = files.next();
    //     Logger.log(file.getName());
    // }
}

  


function testSites() {
    var sites = SitesApp.getSites();
    for(var i in sites) {
        console.log(sites[i].getUrl());
    }
}