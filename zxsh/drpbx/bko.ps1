# TODO: Add in zxsh
# Because, yeah surprisingly I use this a lot
# https://mcpmag.com/articles/2015/05/20/functions-that-support-the-pipeline.aspx

New-Alias -Name gt Get-Type
function Get-Type
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory, 
            ValueFromPipeLine
        )]
        $a
    )
    
    if ($a -eq $null)
    {
        return $null
    }

    return $a.GetType().ToString()
}

$file = 'C:\Users\zong\Documents\PowerShell\zxsh.psd1'
[string[]]$a = (Get-Content $file)
$b = $a -match "^ModuleVersion1.*$"

"a is $($a.GetType().ToString())"
"b is $($b.GetType().ToString())"

write-host ($b -eq $null)

# Get-Type $b
# $b | Get-Type # This one seems to be more accurate?

#"b is $($b.GetType().ToString())" # b is System.String     when [string]$b = $a -match "^ModuleVersion.*$"
#"b is $($b.GetType().ToString())" # b is System.String[]   when [string[]]$b = $a -match "^ModuleVersion.*$"
#"b is $($b.GetType().ToString())" # b is System.Object[]   when $b = $a -match "^ModuleVersion.*$"
#"b is $($b.GetType().ToString())" # b is System.Object[]   when $b = [string[]]$a -match "^ModuleVersion.*$"
#"b is $($b.GetType().ToString())" # b is System.Boolean    when $b = [string]$a -match "^ModuleVersion.*$""
