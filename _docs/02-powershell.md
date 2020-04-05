# PowerShell


Create new objects

    $server = New-Object -TypeName System.Version -ArgumentList "1.2.3.4"

Shorten prompt

    Function prompt {}

    Function prompt {"My Prompt "}

    Function prompt {"PS [$Env:username]$PWD`n> "}

    Function prompt {"[$env:USERDOMAIN\$env:USERNAME] $PWD`nPS> "}

    Function prompt {"[$env:USERDOMAIN\$env:USERNAME] $PWD `e[36m($(git branch --show-current))`e[39m`nPS> "}

    Function prompt {"`e[32;1m$env:USERDOMAIN>$env:USERNAME`e[39m $PWD `e[36m($(git branch --show-current))`e[39m`nPS> "}

    Function prompt {"`e[32m$env:USERDOMAIN>$env:USERNAME`e[39m $PWD `e[36m($(git branch --show-current))`e[39m`nPS> "}

    PS C:\src\github.com\ongzhixian\ongzhixian.github.io>

    `e[32;1m vs `e[32m 
    The ";1" is "bright" attribute. So it means bright green compared to just green.

Window Title

    (Get-Host).UI.RawUI.WindowTitle = "PS"

    (Get-Host).UI.RawUI.WindowTitle = $myinvocation.Line
    
Redirect all streams to file

    .\script.ps1 *> script.log

    n   Desc                Availability
    1	Success Stream	    PowerShell 2.0
    2	Error Stream	    PowerShell 2.0
    3	Warning Stream	    PowerShell 3.0
    4	Verbose Stream	    PowerShell 3.0
    5	Debug Stream	    PowerShell 3.0
    6	Information Stream  PowerShell 5.0
    *	All Streams	        PowerShell 3.0

    Op  Desc                                                    Syntax
    >	Send specified stream to a file.	                    n>
    >>	Append specified stream to a file.	                    n>>
    >&1	Redirects the specified stream to the Success stream.	n>&1

Get .NET Object Details

    [System.Console] | Get-Member -Static

    [System.Console] | Get-Member

Call .NET static class method that is in another static class

    [System.Net.Mime.MediaTypeNames+Text]::Html



Reference:

https://docs.microsoft.com/en-us/powershell/scripting/developer/help/examples-of-comment-based-help?view=powershell-7#example-2-comment-based-help-for-a-script

https://docs.microsoft.com/en-us/archive/msdn-magazine/2016/may/windows-powershell-writing-windows-services-in-powershell

https://docs.microsoft.com/en-us/powershell/scripting/developer/windows-powershell?view=powershell-7

https://docs.microsoft.com/en-us/powershell/scripting/samples/sample-scripts-for-administration?view=powershell-7

https://docs.microsoft.com/en-us/?view=pscore-6.2.0

https://docs.microsoft.com/en-us/openspecs/main/ms-openspeclp/3589baea-5b22-48f2-9d43-f5bea4960ddb

https://docs.microsoft.com/en-us/adaptive-cards/sdk/authoring-cards/net

https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences

https://www.ecma-international.org/publications/standards/Ecma-048.htm
