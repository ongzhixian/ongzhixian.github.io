# Script to parse urls into data warehouse table
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

function Get-DataSet()
{
    param (
        [string] $sql = $null
    )
    try {
        [System.Data.SQLite.SQLiteConnection]   $conn = [System.Data.SQLite.SQLiteConnection]::new($connectionString)
        [System.Data.SQLite.SQLiteCommand]      $cmd = $conn.CreateCommand()
    
        $cmd.CommandType = [System.Data.CommandType]::Text
        $cmd.CommandText = $sql
    
        [System.Data.DataSet] $ds = [System.Data.DataSet]::new("result")
        [System.Data.SQLite.SQLiteDataAdapter] $da = [System.Data.SQLite.SQLiteDataAdapter]::new($cmd);
        $da.Fill($ds);
        
        $cmd.Dispose()
    
        return [System.Data.DataSet]$ds
    }
    catch {
    
    }
    finally {
    }
}


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


# Initialize local variables (if any needed)

$connectionString = "Data Source=$(Join-Path (Get-Location).Path $dbFileName);Version=3;Pooling=True;Max Pool Size=100;"
$connectionString

# Main script


# $s1 = "www.softwarepreservation.org/projects/apl/Papers/ElementaryAlgebra"
# [Uri]$uri = [Uri]$s1
# $uri.Host -eq $null
$sql = @"
SELECT 	id, url 
FROM 	topic
WHERE 	status = 0
ORDER BY 
        id
LIMIT   1000;
"@

# Test code
# $dsx = Get-DataSet $sql
# ($dsx.Tables[0].Rows.Count)
# ($dsx.Tables[0].Rows.Count -gt 0)
# $rows = $dsx.Tables[0].Rows # System.Data.DataRowCollection
# $rows.GetType().ToString()
# return



while ($true)
{
    Write-Host "Fetch 1000 unprocessed records."
    $dsx = Get-DataSet $sql
    if ($dsx.Tables[0].Rows.Count -le 0)
    {
        break
    }

    # Process records here
    $rows = $dsx.Tables[0].Rows # System.Data.DataRowCollection
    [System.Collections.ArrayList] $updateStatements = New-Object System.Collections.ArrayList
    [Uri]$uri = $null

    foreach ($row in $rows) {
        $id = $row["id"]
        $url = $row["url"]
        $uri = $null
        $status = 255
        
        $uri = [Uri]$url
        if ($null -ne $uri.Host) {
            $status = 1
        }

        $null = $updateStatements.Add(
            "UPDATE topic SET status = $status, host = '$($uri.Host)' WHERE id = $id;"
        )
    }

    # Run update statements
    Write-Host "To process $($updateStatements.Count) update statements."
    Run-Statements $updateStatements
    
}





# Clean up before we exit the script

# Close does not free up file handle for SQLite
# See: https://stackoverflow.com/questions/8511901/system-data-sqlite-close-not-releasing-database-file
# The original recommendation of freeing up the file handle is to do GC
# [GC]::Collect()
# [GC]::WaitForPendingFinalizers();
# Later, someone suggest using ClearAllPools from the SQLite API.
[System.Data.SQLite.SQLiteConnection]::ClearAllPools()

Write-Host "End-of-script"
