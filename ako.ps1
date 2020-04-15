
# Apparently, tts ok to add multiple times in a session.
# PowerShell will cache the first time its being added and reuse it.
Add-Type -Path "C:\src\github.io\bin\System.Data.SQLite.dll" 

try {
    $db = [System.Data.SQLite.SQLiteConnection]::new("Data Source=C:\src\github.io\mydb.db;Version=3;")

    Write-Host "Open db"
    $db.Open()

    
}
catch {
    
}
finally {

    if ($db.State -eq "Open")
    {
        Write-Host "Close db"
        $db.Close()
    }
}

