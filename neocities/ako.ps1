param (
    [string]$application = $null
)

# Function Build-CoverageSnapshot {
# 	dotcover dotnet .\code-coverage\Impulse.Common.Tests.xml
# }

########################################
# Variable declarations
########################################

$site_name = "zhixian"
$user_pwd = "$($site_name):29085002883526"
$basic_cred = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($user_pwd))
$root_url = "https://neocities.org"

$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Basic $basic_cred"
}

# $body = @{
#     asd = "zxc"
#     "message_type" = "username:password"
#     "message" = @{
#         "username" = "some_username"
#         "password" = "some_password"
#     }
# } | ConvertTo-Json

########################################
# Remote functions
########################################
function Get-MimeType {
    param (
        [parameter(Mandatory)][string]$extension
    )

    $ext = $extension.ToLower()
    switch ($ext) {
        ".asc"      { "text/plain"; Break }   #
        ".atom"     { "application/atom+xml"; Break }   #
        ".bin"      { "application/octet-stream"; Break }   #
        ".css"      { "text/css"; Break }   # OK
        ".csv"      { "text/csv"; Break }   # OK
        ".dae"      { "application/collada+xml"; Break }   #
        ".eot"      { "application/vnd.ms-fontobject"; Break }   #
        ".epub"     { "application/epub+zip"; Break }   #
        ".geojson"  { "application/geo+json"; Break }   #
        ".gif"      { [System.Net.Mime.MediaTypeNames+Image]::Gif; Break }   #
        ".gltf"     { "model/gltf+json"; Break }   #
        ".gz"       { "application/gzip"; Break }
        ".htm"      { [System.Net.Mime.MediaTypeNames+Text]::Html; Break }   #
        ".html"     { [System.Net.Mime.MediaTypeNames+Text]::Html; Break }   #
        ".ico"      { "image/vnd.microsoft.icon"; Break }   #
        ".jpeg"     { [System.Net.Mime.MediaTypeNames+Image]::Jpeg; Break }   #
        ".jpg"      { [System.Net.Mime.MediaTypeNames+Image]::Jpeg; Break }   #
        ".js"       { "text/javascript"; Break }   # OK
        ".json"     { "application/json"; Break }   #
        ".key"      { "application/pkcs8"; Break }   #
        ".kml"      { "application/vnd.google-earth.kml+xml"; Break }   #
        ".knowl"    { "text/plain"; Break }   #
        ".less"     { "text/plain"; Break }   #
        ".map"      { "text/plain"; Break }   #
        ".manifest" { "text/plain"; Break }   #
        ".markdown" { "text/markdown"; Break }   #
        ".md"       { "text/markdown"; Break }   #
        ".mf"       { "application/metafont"; Break }   #
        ".mid"      { "audio/midi audio/x-midi"; Break }   #
        ".midi"     { "audio/midi audio/x-midi"; Break }   #
        ".mtl"      { "text/plain"; Break }   #
        ".obj"      { "text/plain"; Break }   #
        ".opml"     { "application/xml+opml"; Break }   #
        ".otf"      { "font/otf"; Break }   #
        ".pdf"      { "application/pdf"; Break }   #
        ".pgp"      { "application/pgp"; Break }   #
        ".png"      { "image/png"; Break }   #
        ".rdf"      { "application/rdf+xml"; Break }   #
        ".rss"      { "application/rss+xml"; Break }   #
        ".rtf"      { [System.Net.Mime.MediaTypeNames+Text]::RichText; Break }
        ".sass"     { "text/plain"; Break }   #
        ".scss"     { "text/plain"; Break }   #
        ".svg"      { "image/svg+xml"; Break }   #
        ".text"     { [System.Net.Mime.MediaTypeNames+Text]::Plain; Break }   #
        ".tiff"     { [System.Net.Mime.MediaTypeNames+Image]::Tiff; Break }
        ".tif"      { [System.Net.Mime.MediaTypeNames+Image]::Tiff; Break }
        ".tsv"      { "text/tab-separated-values"; Break }   #
        ".ttf"      { "font/ttf"; Break }   #
        ".txt"      { "text/plain"; Break }   #
        ".webmanifest" { "application/manifest+json"; Break }   #
        ".webp"     { "image/webp"; Break }   #
        ".woff"     { "font/woff"; Break }   #
        ".woff2"    { "font/woff2"; Break }   #
        ".xcf"      { "image/x-xcf"; Break }   #
        ".xhtml"    { "application/xhtml+xml"; Break }
        ".xml"      { [System.Net.Mime.MediaTypeNames+Text]::Xml; Break }   #
        ".zip"      { [System.Net.Mime.MediaTypeNames+Application]::Zip; Break }

        default     { [System.Net.Mime.MediaTypeNames+Application]::Octet; Break }
    }
}

function Get-LocalFileListAsJson {
    
    $cur_pwd_length = (Get-Location).Path.Length + 1

    Get-ChildItem -Recurse -File -Exclude @(".gitignore","ako.ps1","sync-*.json") | Select-Object -Property `
        @{Name = 'FullFilePath' ; Expression = {$_.FullName.Remove(0, $cur_pwd_length).Replace("\", "/")} }, `
        @{Name = 'Bytes'        ; Expression = {$_.Length} }, `
        @{Name = 'Timestamp'    ; Expression = {$_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss zzz")} } `
        | Sort-Object {$_.FullFilePath} | ConvertTo-Json | Out-File sync-local.json

    Write-Host "File [sync-local.json] generated."
}

function Get-RemoteFileListAsJson {
    
    $url = "$root_url/api/list"
    
    $result = Invoke-RestMethod -Method Get -Uri $url -Headers $headers
    
    Write-Host "GET /api/list [$($result.result)]"

    # $result.files | Select-Object -Property is_directory,path,size,updated_at
    $result.files | Where-Object { -not $_.is_directory } | Select-Object -Property `
        @{Name = 'FullFilePath' ; Expression = {$_.path} }, `
        @{Name = 'Bytes'        ; Expression = {$_.size} }, `
        @{Name = 'Timestamp'    ; Expression = {[DateTime]::Parse($_.updated_at).ToString("yyyy-MM-dd HH:mm:ss zzz")} } `
        | Sort-Object {$_.FullFilePath} | ConvertTo-Json | Out-File sync-remote.json
    
    Write-Host "File [sync-remote.json] generated."
}

function Get-FileContent {
    param (
        $f
    )

    $localFile = Get-ChildItem $f.FullFilePath
    $localFile
    
    [System.Net.Http.Headers.ContentDispositionHeaderValue]$fileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
    $fileHeader.Name        = "./$($f.FullFilePath)"    # "./html/credits.html"
    $fileHeader.FileName    = $localFile.Name           # "credits.html"
    
    Write-Host "Full file path: [$($localFile.FullName)]"

    $mimeType = (Get-MimeType $localFile.Extension)

    [System.Net.Http.StreamContent]$fileContent = [System.Net.Http.StreamContent]::new([System.IO.FileStream]::new($localFile.FullName, [System.IO.FileMode]::Open))
    $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse($mimeType)
    $fileContent.Headers.ContentDisposition = $fileHeader

    return $fileContent
}

function Publish-File {
    param (
        $f
    )

    Write-Host "We want to publish [$($f.FullFilePath)]"

    $url = "$root_url/api/upload"

    $multipartContent = [System.Net.Http.MultipartFormDataContent]::new()

    $localFile = Get-ChildItem $f.FullFilePath
    
    [System.Net.Http.Headers.ContentDispositionHeaderValue]$fileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
    $fileHeader.Name        = "./$($f.FullFilePath)"    # "./html/credits.html"
    $fileHeader.FileName    = $localFile.Name           # "credits.html"
    
    Write-Host "Full file path: [$($localFile.FullName)]"

    $mimeType = (Get-MimeType $localFile.Extension)
    
    $fileContent = [System.Net.Http.StreamContent]::new([System.IO.FileStream]::new($localFile.FullName, [System.IO.FileMode]::Open))
    $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse($mimeType)
    $fileContent.Headers.ContentDisposition = $fileHeader
    
    $multipartContent.Add($fileContent)

    $result = Invoke-WebRequest -Method Post -Uri $url -Headers $headers -Body $multipartContent

    $result
}


########################################
# Main script
########################################

switch ($application)
{
	########################################
	# TODO: Generic
	########################################

    "info" {
        $url = "$root_url/api/info?sitename=$site_name"
        $result = Invoke-RestMethod -Method Get -Uri $url
        Write-Host "GET /api/info [$($result.result)]"
        $result.info
    }

    "key" {
        $url = "$root_url/api/key"
        $result = Invoke-RestMethod -Method Get -Uri $url -Headers $headers
        Write-Host "GET /api/key [$($result.result)]"
        Write-Host "API KEY: [$($result.api_key)]"
    }

    "list" {
        $url = "$root_url/api/list"
        $result = Invoke-RestMethod -Method Get -Uri $url -Headers $headers
        Write-Host "GET /api/list [$($result.result)]"
        # $result.files | Select-Object -Property is_directory,path,size,updated_at
        $result.files | Select-Object -Property `
            @{Name = 'D'            ; Expression = {if ($_.is_directory) {"d"}} }, `
            @{Name = 'File Path'    ; Expression = {$_.path} }, `
            @{Name = 'Size (bytes)' ; Expression = {$_.size} }, `
            @{Name = 'updated_at'   ; Expression = {[DateTime]::Parse($_.updated_at).ToString("yyyy-MM-dd HH:mm:ss zzz")} }
    }

    "sync" {
        #$localFileList = Get-LocalFileListAsJson
        #$remoteFileList = Get-RemoteFileListAsJson

        $localFileList  = Get-Content .\sync-local.json     | ConvertFrom-Json
        $remoteFileList = Get-Content .\sync-remote.json    | ConvertFrom-Json

        #$c = Compare-Object $localFileList $remoteFileList -Property @('FullFilePath', 'Bytes', 'Timestamp')
        # is the same as:
        #$c = Compare-Object $localFileList $remoteFileList 

        # We only want to sync based on FullFilePath and Bytes properties
        # $c = Compare-Object $localFileList $remoteFileList -Property @('FullFilePath', 'Bytes')
        # Ind   -- Meaning
        # =>    -- In remote but not in local
        # <=    -- In local  but not in remote
        $c = Compare-Object $localFileList $remoteFileList -Property @('FullFilePath', 'Bytes') `
            | Where-Object { $_.SideIndicator -eq "<=" }
        $c | ConvertTo-Json | Out-File sync-push.json
    }

    "push" {
        $d = Get-Content sync-push.json | ConvertFrom-Json
        # $d | ForEach-Object {
        #     Publish-File $_
        # }

        $url = "$root_url/api/upload"

        #$multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
    
        #Publish-File $d[0]

        #$result = Invoke-WebRequest -Method Post -Uri $url -Headers $headers -Body $multipartContent


        $d | ForEach-Object {
            #$fileContent = Get-FileContent $f
            #$multipartContent.Add((Get-FileContent $_))
            Publish-File $_
        }
    
    
        $result
    }

    # "listAsJson" {
    #     $url = "$root_url/api/list"
    #     $result = Invoke-RestMethod -Method Get -Uri $url -Headers $headers
    #     Write-Host "GET /api/list [$($result.result)]"
    #     # $result.files | Select-Object -Property is_directory,path,size,updated_at
    #     $result.files | Where-Object { -not $_.is_directory } | Select-Object -Property `
    #         @{Name = 'FullFilePath' ; Expression = {$_.path} }, `
    #         @{Name = 'Bytes'        ; Expression = {$_.size} }, `
    #         @{Name = 'Timestamp'    ; Expression = {[DateTime]::Parse($_.updated_at).ToString("yyyy-MM-dd HH:mm:ss zzz")} } `
    #         | Sort-Object {$_.FullFilePath}
        
    #     # $w | ConvertTo-Json | Out-File remoteList.txt
    # }

    # "localAsJson" {
    #     # $q[0].FullName.Remove(0, 51).Replace("\", "/")
    #     # $_.FullName.Remove(0, (Get-Location).Path.Length + 1).Replace("\", "/")
    #     $cur_pwd_length = (Get-Location).Path.Length + 1

    #     Get-ChildItem -Recurse -File | Select-Object -Property `
    #         @{Name = 'FullFilePath' ; Expression = {$_.FullName.Remove(0, $cur_pwd_length).Replace("\", "/")} }, `
    #         @{Name = 'Bytes'        ; Expression = {$_.Length} }, `
    #         @{Name = 'Timestamp'    ; Expression = {$_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss zzz")} } `
    #         | Sort-Object {$_.FullFilePath}
    # }

    "upload" {
        $url = "$root_url/api/upload"
        # $result = Invoke-RestMethod -Method Get -Uri $url -Headers $headers
        # Write-Host "GET /api/key [$($result.result)]"
        # Write-Host "API KEY: [$($result.api_key)]"

        #$Uri = 'https://server/api/';
        #$Headers = @{'Auth_token'=$AUTH_TOKEN};
        # $fileContent = [IO.File]::ReadAllText('D:\src\github.com\ongzhixian\zhixian.neocities.org\credits.html')
        # $fields = @{
        #     "name" = 'credits.html'
        #     "files" = $fileContent
        # };

        # Invoke-RestMethod -Uri $Uri -ContentType 'multipart/form-data' -Method Post -Headers $Headers -Body $Fields;
        # Invoke-RestMethod -Method Post -Uri $url -Headers $headers -ContentType 'multipart/form-data'
        #$headers["Content-Type"] = "multipart/form-data"
        #Invoke-RestMethod -Method Post -Uri $url -Headers $headers -ContentType 'multipart/form-data'  -Body $fields
        #$Result = Invoke-RestMethod -Uri $Uri -Method Post -Form $Form
        #Invoke-RestMethod -Method Post -Uri $url -Headers $headers -Form $fields


        $multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
        
        $multipartFile = 'D:\src\github.com\ongzhixian\zhixian.neocities.org\credits.html'
        $FileStream = [System.IO.FileStream]::new($multipartFile, [System.IO.FileMode]::Open)
        
        
        $fileContent = [System.Net.Http.StreamContent]::new($FileStream)

        $fileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
        $fileHeader.Name = "./html/credits.html"
        $fileHeader.FileName = "credits.html"
        $fileContent.Headers.ContentDisposition = $fileHeader
        
        $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("text/html")
        
        $multipartContent.Add($fileContent)

        Invoke-WebRequest -Method Post -Uri $url -Headers $headers -Body $multipartContent
        
        #curl -F "cred.html=@credits.html" "https://zhixian:29085002883526@neocities.org/api/upload"

        $q = ls -Recurse -File -Exclude *.gitignore

        ls -Recurse -File | select { $_.FullName }
        $a | Sort-Object -Descending {$_.D}
    }

	# "cover" { 
	# 	Write-Host "Code coverage using dotCover"

	# 	# This is for .net Framework
	# 	#dotcover cover .\code-coverage\Impulse.Common.Tests.xml

	# 	# This is for .NET Core
	# 	Build-CoverageSnapshot

	# }

	# "merge" {
	# 	dotcover merge .\code-coverage\_merge.xml
	# }

	# "report" {
	# 	dotcover report .\code-coverage\_report.xml
	# }

	# "all" {
	# 	Build-CoverageSnapshot
	# 	dotcover merge .\code-coverage\_merge.xml
	# 	dotcover report .\code-coverage\_report.xml
	# }


	# "seq" {
	# 	# Working
    #     # java -jar plantuml.jar -verbose sequenceDiagram.txt
    #     java -jar D:\Apps\JARs\plantuml.jar sample-sequence.uml
	# }

    # "start" {
    #     Write-Host "START NGINX"
    # }

    # "stop" {
    #     Write-Host "START NGINX"
    # }

    default {
        #java -jar D:\Apps\JARs\plantuml.jar $application
        # if (Test-Path $application)
		# {
        #     java -jar D:\Apps\JARs\plantuml.jar $application
		# 	return
		# }
		Write-Host "Unsupported option $application $Args"
	}
}
