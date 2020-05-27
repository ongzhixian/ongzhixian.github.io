param (
)

# Import SQLite DLLs

Add-Type -Path "C:\src\github.io\bin\System.Data.SQLite.dll"

# Local variables

[string]                                $connectionString   = $null
[System.Data.SQLite.SQLiteConnection]   $conn               = $null



# Parameters checking (if any)

# N/A
# if (-not [System.Net.IPAddress]::TryParse($ipString, [ref] $ipAddr))
# {
#     Write-Host "Invalid IP Address"
#     return
# }

# Functions

function Create-Table {
    try {
        [System.Data.SQLite.SQLiteConnection]   $conn = [System.Data.SQLite.SQLiteConnection]::new($connectionString)
        [System.Data.SQLite.SQLiteCommand]      $cmd = $conn.CreateCommand()

        $cmd.CommandType = [System.Data.CommandType]::Text
        $cmd.CommandText = @"
CREATE TABLE "topic" (
    "id"	INTEGER,
    "title"	TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);
"@
    
        $conn.Open()
        $cmd.ExecuteNonQuery()
        $cmd.Dispose()
    
    }
    catch {
    
    }
    finally {
        $conn.Close()
    }
}

# Main script

Write-Host "Script start"

# Get connection string (connection string needs to be an absolute path!)
# For example: "Data Source=C:\src\github.io\zxsh\sq\mydb.db;Version=3;Pooling=True;Max Pool Size=100;"

$connectionString = "Data Source=$(Join-Path (Get-Location).Path "test.db");Version=3;Pooling=True;Max Pool Size=100;"
#$connectionString

# 




# Clean up before we exit the script

# Close does not free up file handle for SQLite
# See: https://stackoverflow.com/questions/8511901/system-data-sqlite-close-not-releasing-database-file
# The original recommendation of freeing up the file handle is to do GC
# [GC]::Collect()
# [GC]::WaitForPendingFinalizers();
# Later, someone suggest using ClearAllPools from the SQLite API.
[System.Data.SQLite.SQLiteConnection]::ClearAllPools()

Write-Host "End-of-script"

