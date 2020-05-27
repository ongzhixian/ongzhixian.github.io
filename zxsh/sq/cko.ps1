# Script to add tag
#$d = Invoke-WebRequest -Uri "https://medium.com/@ozgurgul/asp-net-core-2-0-webapi-jwt-authentication-with-identity-mysql-3698eeba6ff8"

param (
    [string] $dbFileName = "url_kb.sqlite3"
)

# Import SQLite DLLs

Add-Type -Path "C:\src\github.io\bin\System.Data.SQLite.dll"

# Local variables

[string]                                $connectionString   = $null
[System.Data.SQLite.SQLiteConnection]   $conn               = $null

# Parameters checking (if any)

# N/A

# Functions

# N/A

# Initialize local variables (if any needed)

$connectionString = "Data Source=$(Join-Path (Get-Location).Path $dbFileName);Version=3;Pooling=True;Max Pool Size=100;"
Write-Debug "ConnectionString: $connectionString"

# Main script
function Run-Statements()
{
    param (
        [System.Collections.ArrayList] $updateStatements = $null
    )

    if ($updateStatements -eq $null) {
        return
    }

    try {
        [System.Data.SQLite.SQLiteConnection]   $conn = [System.Data.SQLite.SQLiteConnection]::new($connectionString)
        [System.Data.SQLite.SQLiteCommand]      $cmd = $conn.CreateCommand()
    
        $cmd.CommandType = [System.Data.CommandType]::Text

        $conn.Open()
        $execCount = 0

        foreach ($sql in $updateStatements) {
            $cmd.CommandText = $sql
            $rowsAffected = $cmd.ExecuteNonQuery()

            $execCount = $execCount + 1
            if (($execCount % 100) -eq 0) {
                $msg = "$execCount records processed"
                
                Write-Host "$execCount records processed"
                title $msg
            }
            
        }
        title ps7
    
        $cmd.Dispose()

    }
    catch {
    }
    finally {
        $conn.Close()
    }
}


function Invoke-SQLiteStatement
{
    param (
        [string] $sql = $null
    )

    if ($sql -eq $null) {
        return
    }

    [int] $rowsAffected = 0
    
    try {
        [System.Data.SQLite.SQLiteConnection]   $conn = [System.Data.SQLite.SQLiteConnection]::new($connectionString)
        [System.Data.SQLite.SQLiteCommand]      $cmd = $conn.CreateCommand()
        $cmd.CommandType = [System.Data.CommandType]::Text

        $conn.Open()

        $cmd.CommandText = $sql
        $rowsAffected = $cmd.ExecuteNonQuery()
    
        $cmd.Dispose()

    }
    catch [System.Management.Automation.MethodInvocationException] {
        $e = $_.Exception
        if ($e.InnerException -is [System.Data.SQLite.SQLiteException]) {
            [System.Data.SQLite.SQLiteException] $sqEx = $e.InnerException
            
            Write-Host "$($sqEx.Message) (ErrorCode=$($sqEx.ErrorCode), ResultCode=$($sqEx.ResultCode)) "

        } else {
            Write-Host "Dont know $($e.InnerException.GetType().ToString())"
        }
    }
    catch {
        Write-Host $_.Exception
    }
    finally {
        $conn.Close()
    }

    return $rowsAffected
}


function Invoke-SQLiteScalar
{
    param (
        [string] $sql = $null
    )

    if ($sql -eq $null) {
        return
    }

    $result = $null

    try {
        [System.Data.SQLite.SQLiteConnection]   $conn = [System.Data.SQLite.SQLiteConnection]::new($connectionString)
        [System.Data.SQLite.SQLiteCommand]      $cmd = $conn.CreateCommand()
        $cmd.CommandType = [System.Data.CommandType]::Text

        $conn.Open()

        $cmd.CommandText = $sql
        $result = $cmd.ExecuteScalar()
    
        $cmd.Dispose()

    }
    catch [System.Management.Automation.MethodInvocationException] {
        $e = $_.Exception
        if ($e.InnerException -is [System.Data.SQLite.SQLiteException]) {
            [System.Data.SQLite.SQLiteException] $sqEx = $e.InnerException
            
            Write-Host "$($sqEx.Message) (ErrorCode=$($sqEx.ErrorCode), ResultCode=$($sqEx.ResultCode)) "

        } else {
            Write-Host "Dont know $($e.InnerException.GetType().ToString())"
        }
    }
    catch {
        Write-Host $_.Exception
    }
    finally {
        $conn.Close()
    }

    return $result
}



function Get-NormalizedTag
{
    param (
        [string] $tag = $null
    )

    if ($tag -eq $null) {
        return $tag
    }

    [string] $result = $null
    $result = $tag

    # Process
    $result = $result.ToLowerInvariant()    # Change to casing to lower-case (invariant)
    $result = $result.Replace(" ", "_")     # Replace white-space with underscores

    return $result
}

function Add-Tag
{
    [bool] $continue = $true

    Write-Host "Add tag"
    while ($continue)
    {
        $newTag = Read-Host "Tag"
        if ([string]::IsNullOrEmpty($newTag.Trim()))
        {
            break
            Write-Host "end"
        }

        # trim tag
        $newTag = $newTag.Trim()

        # get normalized tag
        [string] $norm = Get-NormalizedTag $newTag

        try {
            [int]$rowsAffected = Invoke-SQLiteStatement "INSERT INTO tag (text, norm) VALUES ('$newTag', '$norm');"
            if ($rowsAffected -gt 0) {
                Write-Host "Tag added."
            } else {
                Write-Host "Tag skipped."
                # Write-Host "Skipped; Rows affected: $rowsAffected"
            }
        }
        catch {
            Write-Host $_.Exception
        }


    }
}

function Get-TagId
{
    param (
        [string] $tagText = $null
    )

    if ($tagText -eq $null) {
        return $null
    }

    # get normalized tag
    [string] $norm = Get-NormalizedTag $tagText

    # Write-Host "SELECT id FROM tag WHERE norm = '$norm';"
    $result = $null

    try {
        $result = Invoke-SQLiteScalar "SELECT id FROM tag WHERE norm = '$norm';"
        
        Write-Debug "TagId is $result"
        
        # if ($rowsAffected -gt 0) {
        #     Write-Host "Tag added."
        # } else {
        #     Write-Host "Tag skipped."
        #     # Write-Host "Skipped; Rows affected: $rowsAffected"
        # }
        
    }
    catch {
        Write-Host $_.Exception
    }

    return $result
}

function Display-Menu
{
    param (
        [string] $menuTitle = "Menu"
    )
    # $Host.UI.RawUI.WindowSize.Width
    # $Host.UI.RawUI.WindowSize.Height
    # $winMid = [Math]::Floor($Host.UI.RawUI.WindowSize.Width / 2)
    # $titleText = "==================== Start menu ===================="
    # $titleText = "Menu123"
    # $titleMid = [Math]::Floor($titleText.Length / 2)

    # Write-Host $winMid
    # Write-Host $titleMid
    # Write-Host ($winMid - $titleMid)

    # # starting point
    # $title = "$("=" * ($winMid - $titleMid - 1)) $titleText $("=" * ($winMid - $titleMid - 1))"


    Clear-Host
    Write-Host "   [$menuTitle]"
    Write-Host "   $("=" * $($menuTitle.Length + 2))" 
    Write-Host "1) Add tags"
    Write-Host "2) Associate tags"
    Write-Host "3) Find tags"
    Write-Host "X) Exit"
    return (Read-Host "Action").ToLowerInvariant()
}

function Link-Tag
{
    param (
        [int] $hostId,
        [string] $hostTag
    )

    [bool] $continue = $true

    Write-Host "Linking tag [$hostTag] ($hostId) with:"
    while ($continue)
    {
        $newTag = Read-Host "Tag"
        if ([string]::IsNullOrEmpty($newTag.Trim()))
        {
            break
        }

        # trim tag
        $newTag = $newTag.Trim()

        # get normalized tag
        [string] $norm = Get-NormalizedTag $newTag

        try {

            $assocTagId = Get-TagId $newTag

            if ($null -eq $assocTagId) {
                Write-Host "Do add new tag"
                $assocTagId = Invoke-SQLiteScalar "INSERT INTO tag (text, norm) VALUES ('$newTag', '$norm'); SELECT last_insert_rowid() AS 'id';"
            }

            [string] $sql = @"
INSERT INTO tag_assoc (tag_id, assoc_tag_id)
SELECT $hostId, $assocTagId WHERE NOT EXISTS 
(SELECT 1 FROM tag_assoc WHERE tag_id = $hostId AND assoc_tag_id = $assocTagId);
"@

            $sql

            [int]$rowsAffected = Invoke-SQLiteStatement $sql

            Write-Host "hostId=$hostId , assocTagId=$assocTagId"

            if ($rowsAffected -gt 0) {
                Write-Host "Association added."
            } else {
                Write-Host "Association skipped."
                # Write-Host "Skipped; Rows affected: $rowsAffected"
            }
        }
        catch {
            Write-Host $_.Exception
        }
    } # End-while
    
}

function Assoc-Tag
{
    $hostTag = Read-Host -Prompt "Key tag"
    $hostTag

    # Find tag id
    $id = Get-TagId $hostTag
    Write-Host "Id is $id"
    # Get-NormalizedTag $hostTag

    Link-Tag $id $hostTag



}

# Main script


do {
    $action = Display-Menu
    switch ($action) {
        "1" {
            #Write-Host "Add-Tag"
            Add-Tag
        }

        "2" {
            Write-Host "TODO: associate tag"
            Assoc-Tag
        }

        "3" {
            Write-Host "TODO: find tag"
        }

        default {
            # Do nothing, and let it loop
        }
    }

} while ($action -ne "X")
Write-Host "End-of-script"