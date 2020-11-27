$r = Invoke-WebRequest -Headers $headers -Uri $a.newNonce -Method Head


$headers = @{ 
    Authorization="Bearer ya29.a0AfH6SMCUtakvMCKwuLXt2WurR-vPGXWXJ-WvXYHKSD_5ERBdq-jXNsZ5rlRe7Yu7-I0qwHshkpFlMdC9q5M82eb6BBlduQgKCNjguTgPyOKzx_sN55mwiYHxVS9_9cqUywDRmfyAqTyakUMAaiHgNCvmGapt4zlvt-M" 
}

$r = Invoke-WebRequest -Headers $headers -Uri $a.newNonce -Method Head

$headers = @{}
$url = "https://cdn-cd.akamaized.net/landings/"
$a = Invoke-WebRequest -Headers $headers -Uri $url

$x = [xml]$a.Content
$x.ListBucketResult.Contents



C:\src\test\downloads

$srcUrlPrefix = "https://cdn-cd.akamaized.net/landings/"
$dstFolder = "C:\src\test\downloads\"
$wc = New-Object System.Net.WebClient

$sub = "100027/1494578197/images/button.png"

$wc.DownloadFile($url, $output)

$c | ForEach-Object { $wc.DownloadFile("$srcUrlPrefix$($_.Key)", "$dstFolder$($_.Key)") }

$c | ForEach-Object { "$srcUrlPrefix$($_.Key)", "$dstFolder$($_.Key)" }

mkdir (Split-Path "C:\src\test\downloads\100004/1498809756/css/main.css"))

if (-not Test-Path (Split-Path "C:\src\test\downloads\100004/1498809756/css/main.css")) { mkdir (Split-Path "C:\src\test\downloads\100004/1498809756/css/main.css")) }


$wc.DownloadFile("https://cdn-cd.akamaized.net/landings/100004/1498809756/css/main.css", "C:\src\test\downloads\100004/1498809756/css/main.css")


# Where to get $c? ZX: LOL depends on datasource
$srcUrlPrefix = "https://cdn-cd.akamaized.net/landings/"
$dstFolder = "C:\src\test\downloads\"
$wc = New-Object System.Net.WebClient
$c | ForEach-Object { 
    if (-not (Test-Path (Split-Path "$dstFolder$($_.Key)"))) { mkdir (Split-Path "$dstFolder$($_.Key)") }
    $wc.DownloadFile("$srcUrlPrefix$($_.Key)", "$dstFolder$($_.Key)")
    Write-Host "Downloading $srcUrlPrefix$($_.Key)"
}

