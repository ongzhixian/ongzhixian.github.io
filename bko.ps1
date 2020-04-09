
$yahoo = "some yahoo garbage"

$wwwroot = "C:\\src\\github.io\\TestSite\\"

$tmpl = Get-Content .\TestSite\test.phtm -Encoding UTF8 -ReadCount 0 -Raw
$text = $ExecutionContext.InvokeCommand.ExpandString($tmpl)
$text | Out-File .\test-out.html




# $a = "./dum"
# $b = "./dum.html"
# $c = "./dum/"

# "$a `t`t`t- $([System.IO.Path]::GetFileName($a))"
# "$b `t`t- $([System.IO.Path]::GetFileName($b))"
# "$c `t`t`t- $([System.IO.Path]::GetFileName($c))"

# $x = [System.IO.Path]::GetFileName($c)

# $x -eq $null
# $x.Length
# [System.String]::IsNullOrWhiteSpace($x)