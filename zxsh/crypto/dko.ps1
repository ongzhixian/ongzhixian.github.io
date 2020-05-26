$s = @{
    "GoDaddy" = @{
        "ote" = @{
            "zhixian" = "asddsa";
            "account2" = "asdad";
        };
        "production" = @{

        };
    };
    "Google" = @{
        "Dummy"= "dummy-value";
    };

    "Status" = "Done";
}

# Print original $s
# $s

# OK, we only want to work with PSCustomObject
# So lets transform $s from HashTable to PSCustomObject
$po = ConvertFrom-Json (ConvertTo-Json $s)
#$po

# OK, maybe PSCustomObject is not that great after all.
# Convert it back to a HashTable
$s = @{}
foreach( $property in $po.psobject.properties.name )
{
    $s[$property] = $po.$property
}


function Add-NodeX {
    param (
        $location,
        $key,
        $value
    )

    Write-Host "In Add-Node"
    Write-host "Add-Node[location]  $location"
    Write-host "Add-Node[key]       $key"
    Write-host "Add-Node[value]     $value"

    # Add to root if location is $null
    if ($location -eq $null)
    {
        $s.Add($key, $value)
        return
    }

    if ($s["Google"] -eq $null) 
    {
        return
    }
}

# function Add-Node { # this for working with PSCustomObject; but we decide to give up on that
#     param (
#         $location,
#         $key,
#         $value
#     )

#     if ($null -eq $location)
#     {
#         $s | Add-Member -NotePropertyName $key -NotePropertyValue $value
#     }

#     $s.$location 

# }

# Main script

# Add-Node $null "Yahoo" @{}

# Add-Node "Google" "zhixian" @{ "UserName" = "zhixian"; "Password" = "password"; }


$x = @{"gb" = @{"ote" = @{"zhixian" = "asddsa";"account2" = "asdad";};"production" = @{};};"Google" = @{"Dummy"= "dummy-value";};"Status" = "Done";}

function Get-Node {
    param (
        [object[]] $location
    )

    $result = $null

    Write-Host "location is $location, $($location.GetType().ToString()), length is $($location.Length)"

    if ($location.Length -le 0)
    {
        return $null
    }

    if ($x.ContainsKey($location[0]))
    {
        $result = $x[$location[0]]

        for ($i = 1; $i -lt $location.Length; $i++) 
        {
            if ($result.ContainsKey($location[$i]))
            {
                $result = $result[$location[$i]]
            }
            else 
            {
                return $null
            }
        }
    }
    
    
    return $result
}

function Add-Node {
    param (
        [object[]] $location,
        $key,
        $value
    )

    Write-Host "In Add-Node"
    Write-host "Add-Node[location]  $location"
    Write-host "Add-Node[key]       $key"
    Write-host "Add-Node[value]     $value"

    $node = Get-Node $location
    if ($null -eq $node)
    {
        return
    }
    $node[$key] = $value

}

function Update-Node {
    param (
        [object[]] $location,
        $key,
        $value
    )

    Write-Host "In Add-Node"
    Write-host "Add-Node[location]  $location"
    Write-host "Add-Node[key]       $key"
    Write-host "Add-Node[value]     $value"

    $node = Get-Node $location
    if ($null -eq $node)
    {
        return
    }

    # TODO: Checking of key here
    $node[$key] = $value

}


function Remove-Node {
    param (
        [object[]] $location,
        $key,
        $value
    )

    Write-Host "In Add-Node"
    Write-host "Add-Node[location]  $location"
    Write-host "Add-Node[key]       $key"

    $node = Get-Node $location
    if ($null -eq $node)
    {
        return
    }

    # TODO: Checking of key here
    $node.Remove($key)

}


#Get-Node "gb"

# $r = Get-Node
# $r

Add-Node @("gb", "ote") "NewNode" "NewNodeValue"

# $r = Get-Node @("gb", "ote")
# $r -eq $null
# $r
# $r["zhixian"] = "zxpass"
# $r["newNode"] = "newNodevalue"
# $r
# Write-Host "======"
# $x["gb"]["ote"]

Write-Host "After add node"
ConvertTo-Json $x

Update-Node @("gb", "ote")  "NewNode" "YaooNewNodeValue"

Write-Host "After update node"
ConvertTo-Json $x

Remove-Node @("gb", "ote")  "NewNode"

Write-Host "After remove node"
ConvertTo-Json $x


# Add-Node $null "Yahoo" @{}

# Get-Node "Google"

#Get-Node @("gb", "ote")


#ConvertTo-Json $s

Write-Host "`nEnd-of-script"
