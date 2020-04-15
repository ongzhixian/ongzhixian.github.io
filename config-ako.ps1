#

$j = Get-Content .\config.json -Raw
$a = ConvertFrom-Json $j


$a

# Server                        WaitTime    Name
# ------                        --------    ----
# @{Port=123; IP=127.0.0.1}     1678        xxx yyy zzz

# How to get values
$a.Server.Port
$a.WaitTime
