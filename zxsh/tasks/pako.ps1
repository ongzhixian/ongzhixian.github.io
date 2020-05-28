# Script to parse urls into data warehouse table
param (
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

$connectionString = "Data Source=C:\src\github.io\zxsh\sq\url_kb.sqlite3;Version=3;Pooling=True;Max Pool Size=100;"

# Main script



# Clean up before we exit the script

# Close does not free up file handle for SQLite
# See: https://stackoverflow.com/questions/8511901/system-data-sqlite-close-not-releasing-database-file
# The original recommendation of freeing up the file handle is to do GC
# [GC]::Collect()
# [GC]::WaitForPendingFinalizers();
# Later, someone suggest using ClearAllPools from the SQLite API.
#[System.Data.SQLite.SQLiteConnection]::ClearAllPools()

Write-Host "End-of-script"
