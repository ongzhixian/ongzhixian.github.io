# Neocities

The Neocities API is a REST API, which uses query parameters for input, and returns data in the JSON format (except for file downloads). 
It uses client-side HTTP AUTH to authenticate, using your user/site name and password as the credentials. 
It is designed to play nicely with the most common HTTP libraries available in programming languages, and can be easily used with cURL 
(a command-line tool for making HTTP requests you can use by opening a terminal on your computer).

That's a lot of buzz words if you're new to programming. Don't worry, it's easier than it sounds! We'll walk you through some working examples you can get started with.

POST /api/upload
Upload a single local file (local.html), which will be named hello.html on your site:
curl -F "hello.html=@local.html" "https://USER:PASS@neocities.org/api/upload"



Invoke-RestMethod -Method 'Post' -Uri https://zhixian:pwd@neocities.org/api/upload


$Form = @{ resume = Get-Item 'c:\Users\jdoe\Documents\John Doe.pdf' }


POST /api/delete
curl -d "filenames[]=img1.jpg" -d "filenames[]=img2.jpg" "https://YOURUSER:YOURPASS@neocities.org/api/delete"

GET /api/list
curl "https://USER:PASS@neocities.org/api/list"
curl "https://USER:PASS@neocities.org/api/list?path=images"
curl "https://neocities.org/api/info?sitename=youpi"
curl "https://YOURUSER:YOURPASS@neocities.org/api/info"

curl "https://USER:PASS@neocities.org/api/key"
curl -H "Authorization: Bearer da77c3530c30593663bf7b797323e48c" https://neocities.org/api/info


zhixian.neocities.org
290

https://neocities.org/api/info?sitename=zhixian

Invoke-RestMethod


Invoke-RestMethod https://neocities.org/api/info?sitename=zhixian

------
Working

$Cred = Get-Credential
<Some manual process to fill in username and password>
Invoke-RestMethod -Uri https://neocities.org/api/key -Authentication Basic -Credential $Cred


Same as above but combined into a single step
Invoke-RestMethod -Uri https://neocities.org/api/key -Authentication Basic -Credential $(Get-Credential)

Invoke-RestMethod -Uri https://neocities.org/api/list -Authentication Basic -Credential $(Get-Credential)

Invoke-RestMethod -Uri https://neocities.org/api/upload -Authentication Basic -Credential $(Get-Credential) -Method Post -Form  @{ "resume.txt" = Get-Item 'C:\src\github.io\res\file1.txt' }




