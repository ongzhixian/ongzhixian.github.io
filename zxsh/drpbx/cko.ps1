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

Incr-Version "0.0.3"    # returns 0.0.4
Incr-Version "3.1.30.1" # returns 3.1.30.2
Incr-Version "4"        # returns 5



