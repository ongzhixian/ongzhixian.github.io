# Import
import json
import requests

# Main
if __name__ == "__main__":
    print("[START]")
    #url = 'http://ES_search_demo.com/document/record/_search?pretty=true'
    #response = requests.post(url, data=data)

    url = "https://accounts.google.com/o/oauth2/v2/auth"
    data = {
        "access_type" : "offline",
        "response_type" : "code",
        "include_granted_scopes":"true",
        "redirect_uri":"oob",
        "client_id":"980914380422-67950b9niqj855smjd5jgk61e5770e82.apps.googleusercontent.com",
        "scope":"https://www.googleapis.com/auth/tasks https://www.googleapis.com/auth/tasks.readonly",
        "state":"123"
    }
    print("[END]")

    from urllib.parse import urlencode
    
    final = "{0}?{1}".format(url, urlencode(data)) 
    print("{0}?{1}".format(url, urlencode(data)))
        
    import webbrowser
    webbrowser.open(final)

    api_token = 'your_api_token'
api_url_base = 'https://api.digitalocean.com/v2/'
headers = {'Content-Type': 'application/json',
           'Authorization': 'Bearer {0}'.format(api_token)}
           