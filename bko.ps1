
$a = "./dum"
$b = "./dum.html"
$c = "./dum/"

"$a `t`t`t- $([System.IO.Path]::GetFileName($a))"
"$b `t`t- $([System.IO.Path]::GetFileName($b))"
"$c `t`t`t- $([System.IO.Path]::GetFileName($c))"

$x = [System.IO.Path]::GetFileName($c)

$x -eq $null
$x.Length
[System.String]::IsNullOrWhiteSpace($x)