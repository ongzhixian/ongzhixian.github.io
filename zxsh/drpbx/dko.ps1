# Increment version
<#

Major:  Assemblies with the same name but different major versions are not interchangeable. 
        A higher version number might indicate a major rewrite of a product where backward compatibility cannot be assumed.
Minor:  If the name and major version number on two assemblies are the same, but the minor version number is different, 
        this indicates significant enhancement with the intention of backward compatibility. 
        This higher minor version number might indicate a point release of a product or a fully backward-compatible new version of a product.
Revision: 
        Assemblies with the same name, major, and minor version numbers but different revisions are intended to be fully interchangeable. 
        A higher revision number might be used in a build that fixes a security hole in a previously released assembly.
Build:  A difference in build number represents a recompilation of the same source. 
        Different build numbers might be used when the processor, platform, or compiler changes.

ZX Note:
    .NET's Version class uses Major : Minor : Build : Revision
    I disagree with this order. I prefer:
    I uses Major : Minor : Revision : Build
    Rationale:
    I feel that Major : Minor : Revision should refer to intent of development goals.
    Whereas Build representing compilation of same source should be last
    (after all, you can multiple builds of the same code)
#>

$file = 'C:\Users\zong\Documents\PowerShell\zxsh.psd1'
# (Get-Content $file) -replace $regex, 'https://newurl.com' | Set-Content $file

# Get content of file
# If we do not cast, it give System.Object[] instead of System.String[]
#$a = [string](Get-Content $file)
$a = (Get-Content $file)

if ($a -eq $null) 
{
    # Empty file; do nothing
    return
}

# Get line that goes something like "ModuleVersion = '0.0.3.2'" in that file
$b = $a -match "^ModuleVersion.*$"


if ($b -eq $null) 
{
    # Do nothing; this file does not have a ModuleVersion attribute that we can update
    return
}

# Parse for version number

#$b.GetType().ToString()
# $a -replace "^ModuleVersion.*$","AAA" | more

$m = [regex]::Match($b, "ModuleVersion.*[`'|`"](?<ver>\d+(\.\d+)*)[`'|`"]")

if (-not ($m.Success))
{
    Write-Error "Version number does not exists."
}

Write-Host "Version number exists."

# function Incr-Version
# {
#     param (
#         [string] $versionNum
#     )

#     # Local variables
#     [System.Text.RegularExpressions.Match] $m = $null

#     $m = [regex]::Match($versionNum, "(?<mj>\d+)(?:\.(?<mn>\d+))?(?:\.(?<rv>\d+))?(?:\.(?<bd>\d+))?")
#     if (-not ($m.Success))
#     {
#         Write-Error "Version number $versionNum is not a 4-part version number."
#         return $versionNum
#     }

#     # "mj $($m.Groups["mj"].Success) - $($m.Groups["mj"].Value)"
#     # "mn $($m.Groups["mn"].Success) - $($m.Groups["mn"].Value)"
#     # "rv $($m.Groups["rv"].Success) - $($m.Groups["rv"].Value)"
#     # "bd $($m.Groups["bd"].Success) - $($m.Groups["bd"].Value)"

#     $mj = [int]$m.Groups["mj"].Value
#     $mn = [int]$m.Groups["mn"].Value
#     $rv = [int]$m.Groups["rv"].Value
#     $bd = [int]$m.Groups["bd"].Value

#     # By default, we only want to increment build
#     $bd = $bd + 1

#     $newVersion = "ModuleVersion = '$mj.$mn.$rv.$bd'"
#     return $newVersion
# }
function Incr-Version
{
    param (
        [string] $versionNum
    )

    # Local variables
    [System.Text.RegularExpressions.Match] $m = $null

    $m = [regex]::Match($versionNum, "(?<mj>\d+)(?:\.(?<mn>\d+))?(?:\.(?<rv>\d+))?(?:\.(?<bd>\d+))?")
    if (-not ($m.Success))
    {
        Write-Error "Version number $versionNum is not a 4-part version number."
        return $versionNum
    }

    # "mj $($m.Groups["mj"].Success) - $($m.Groups["mj"].Value)"
    # "mn $($m.Groups["mn"].Success) - $($m.Groups["mn"].Value)"
    # "rv $($m.Groups["rv"].Success) - $($m.Groups["rv"].Value)"
    # "bd $($m.Groups["bd"].Success) - $($m.Groups["bd"].Value)"

    $mj = [int]$m.Groups["mj"].Value
    $mn = [int]$m.Groups["mn"].Value
    $rv = [int]$m.Groups["rv"].Value
    $bd = [int]$m.Groups["bd"].Value

    # By default, we only want to increment build of last digit
    if ($m.Groups["bd"].Success) {
        $bd = $bd + 1
    } elseif ($m.Groups["rv"].Success) {
        $rv = $rv + 1
    } elseif ($m.Groups["mn"].Success) {
        $mn = $mn + 1
    } else {
        $mj = $mj + 1
    }
    
    # Build new version string
    # $newVersion = "ModuleVersion = '$mj.$mn.$rv.$bd'"
    $newVersion = "$mj"

    if ($m.Groups["mn"].Success) {
        $newVersion = $newVersion + ".$mn"
    }
    if ($m.Groups["rv"].Success) {
        $newVersion = $newVersion + ".$rv"
    }
    if ($m.Groups["bd"].Success) {
        $newVersion = $newVersion + ".$bd"
    }
    #$newVersion = $newVersion + "'"

    return $newVersion
}



$newVersion = Incr-Version $m.Groups["ver"].Value
$newVersion




# Finally do the replacement here
(Get-Content $file) -replace "^ModuleVersion.*$", "ModuleVersion = '$newVersion'" | Set-Content $file


# $a = (Get-Content $file)

# if ($a -eq $null) 
# {
#     # Empty file; do nothing
#     return
# }

# # Get line that goes something like "ModuleVersion = '0.0.3.2'" in that file
# $b = $a -match "^ModuleVersion.*$"


# # Incr-Version 
# # $newVersion = "ModuleVersion = '$mj.$mn.$rv.$bd'"
# # $newVersion


# # (Get-Content $file) -match "^ModuleVersion.*=.*(?<ver>\d(\.\d+)*)$"
# # (Get-Content $file) -match "^ModuleVersion.*$"