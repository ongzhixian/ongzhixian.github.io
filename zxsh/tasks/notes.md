# Notes

In Google's RESTful APIs, the client specifies an action using an HTTP verb such as POST, GET, PUT, or DELETE. It specifies a resource by a globally-unique URI of the following form:


https://www.googleapis.com/tasks/v1/lists/taskListID/tasks?parameters
https://www.googleapis.com/tasks/v1/users/userID/lists?parameters


CLIENT_ID = '123456789.apps.googleusercontent.com'
CLIENT_SECRET = 'abc123'  # Read from a file or environmental variable in a real app
SCOPE = 'https://www.googleapis.com/auth/drive.metadata.readonly'
REDIRECT_URI = 'http://example.com/oauth2callback'


AIzaSyC6b-oazYBSDilbJ_WcPmmS1g5xran4Ugk