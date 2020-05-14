# Some generic functions for working with System.Collections.Hashtable object
# Functions:
# Get-HashtableEntry        : Get a hashtable entry
# Add-HashtableEntry        :
# Update-HashtableEntry     :
# Remove-HashtableEntry     :


# Sample data
# $x = @{
#     "gb" = @{
#         "ote" = @{
#             "zhixian" = "asddsa"
#             ; "account2" = "asdad"
#             ;
#         }
#         ; "production" = @{}
#         ;
#     }
#     ; "Google" = @{
#         "Dummy"= "dummy-value"
#         ;
#     }
#     ; "Status" = "Done";
# }

# The location parameter should refer to a branch
# Based on the sample data above, branches would be:
# gb
# gb->ote
# gb->production
# Google
# Status?

function Get-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch
    )
    $result = $null

    Write-Host "Get-HashtableEntry [location]=[$branch]"

    # Not needed anymore; handled by [Parameter(Mandatory)]
    # if ($branch.Length -le 0)
    # {
    #     return $null
    # }

    if ($ht.ContainsKey($branch[0]))
    {
        $result = $ht[$branch[0]]

        for ($i = 1; $i -lt $branch.Length; $i++) 
        {
            if ($result.ContainsKey($branch[$i]))
            {
                $result = $result[$branch[$i]]
            }
            else 
            {
                return $null
            }
        }
    }
    
    return $result
}

function Add-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch,
        [Parameter(Mandatory)] $key,
        [Parameter(Mandatory)] $value
    )

    Write-Host "Add-HashtableEntry [location]=[$branch] [key]=[$key] [value]=[$value]"

    $node = $null
    if ([string]::IsNullOrEmpty($branch[0]))
    {
        $node = $ht
        
    }
    else
    {
        $node = Get-HashtableEntry $ht $branch
        if ($null -eq $node)
        {
            return
        }
    }
    
    $node[$key] = $value
}


function Update-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch,
        [Parameter(Mandatory)]$key,
        [Parameter(Mandatory)]$value
    )

    Write-Host "Update-HashtableEntry [location]=[$branch] [key]=[$key] [value]=[$value]"

    $node = $null

    if ([string]::IsNullOrEmpty($branch[0]))
    {
        $node = $ht
    }
    else
    {
        $node = Get-HashtableEntry $ht $branch
        if ($null -eq $node)
        {
            return
        }
    }

    if ($node.ContainsKey($key))
    {
        $node[$key] = $value
    }
}


function Remove-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch,
        [Parameter(Mandatory)] $key
    )

    Write-Host "Remove-HashtableEntry [location]=[$branch] [key]=[$key]"

    $node = $null

    if ([string]::IsNullOrEmpty($branch[0]))
    {
        $node = $ht
    }
    else
    {
        $node = Get-HashtableEntry $ht $branch
        if ($null -eq $node)
        {
            return
        }
    }

    if ($node.ContainsKey($key))
    {
        $node.Remove($key)
    }
}




$test = @{"gb" = @{"ote" = @{"zhixian" = "asddsa";"account2" = "asdad";};"production" = @{};};"Google" = @{"Dummy"= "dummy-value";};"Status" = "Done";}

# Test script
# $r = Get-HashtableEntry $test "gb"
# $r


# Add an entry under gb\ote
Add-HashtableEntry $test @("gb", "ote") "NewNode" "NewNodeInitialValue"
Add-HashtableEntry $test @("gb", "production") "Zhixian" "SomeInitialValue"


# Add an entry at root with string value
Add-HashtableEntry $test @("") "Yahoo" "YahooStringValue"
# Add an entry at root with hashtable
Add-HashtableEntry $test @("") "Gmail" @{}

# Update entries at root
Update-HashtableEntry $test @("") "Yahoo" "AllDoneYahoo!"
Update-HashtableEntry $test @("") "Yahoo" @{}

# Update entries under a branch
Update-HashtableEntry $test @("gb", "ote")  "NewNode" "SomeUpdatedNewNodeValue"

# Get-HashtableEntry $test @("gb", "ote", "NewNode") 


Write-Host "Before remove result is:"
ConvertTo-Json $test

# Remove "Yahoo" HashtableEntry
Remove-HashtableEntry $test @("") "Yahoo"

Remove-HashtableEntry $test @("gb", "production") "Zhixian"


Write-Host "End result is:"
ConvertTo-Json $test
