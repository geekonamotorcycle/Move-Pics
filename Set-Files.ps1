function Set-Files {
    Param(
        # Specifies a path to one or more locations.
        [Parameter(Mandatory = $true,
            ParameterSetName = "Array Object for Directory Information",
            HelpMessage = "This needs to be an array with a bunch of information")]
        [Alias("Directory Input Array")]
        [ValidateNotNullOrEmpty()]
        $directoryObject,
        $testmode = $true,
        $showResults = $true,
        $copyMove = $true
    )
    class loopObject {
        [String]$Filename
        [string]$Filetype
        [String]$Fullpath
        [string]$NewPath
        [string]$copyMove
        [string]$Success
        [string]$Time
        [String]$Size
        [string]$Hash
    }
    
    $time = Get-Date
    $time = $time.ToShortDateString()

    if ($testmode) {
        $i = 1
        $liveObject = @()
        $objectCount = $directoryObject.Count
        foreach ($file in $directoryObject) {
            $newPath = Join-Path $destPath $file.cdate 
            $properties = @{FileName = $file.filename; Size = $file.size; Filetype = $file.filetype; Fullpath = $file.FullPath; NewPath = $newPath; Time = $time; Hash = $file.hash}
            $properties += @{CopyMove = "TestMode"; Success = "TestMode"; }
            $loopObject = New-Object loopObject -Property $properties
            $liveObject += $loopObject
            Write-Progress -Activity "Creating Table" -Status "Working" -percentComplete ($i / $objectCount * 100)
            $i++
        }
        if ($showResults) {
            $liveObject | Out-GridView -Title "test Object"
            $liveObject | ConvertTo-Csv -NoTypeInformation > Oraganize_Files_Test.csv 
        }
    }
    else {
        Write-Host "Attempting to Move or Copy Files`n" -ForegroundColor Green
        $i = 1
        $liveObject = @()
        $objectCount = $directoryObject.Count
        foreach ($file in $directoryObject) {
            $newPath = Join-Path $destPath $file.cdate 
            $newPath = Join-Path $newPath $file.fileName
            $properties = @{FileName = $file.filename; Size = $file.size; Filetype = $file.filetype; Fullpath = $file.FullPath; NewPath = $newPath; Time = $time; Hash = $file.hash}
            if ($copyMove) {
                $properties += @{CopyMove = "Copy"}
                Copy-Item -Path $file.Fullpath -Destination $newPath -Force -InformationAction 'silent'
                $copytest = Test-Path -Path $newPath
                if ($copytest) {
                    $properties += @{Success = "Yes"}
                }
                else {
                    $properties += @{Success = "No"}
                }
            }
            else {
                $properties += @{CopyMove = "Move"}
                Move-Item -Path $file.Fullpath -Destination $newPath -Force -InformationAction 'silent'
                $copytest = Test-Path -Path $newPath
                if ($copytest) {
                    $properties += @{Success = "Yes"}
                }
                else {
                    $properties += @{Success = "No"}
                }
            }
            $loopObject = New-Object loopObject -Property $properties
            $liveObject += $loopObject
            Write-Progress -Activity "Copying or moving Files" -Status "Working" -PercentComplete ($i / $objectCount * 100 )
            $i++
        }
        if ($showResults) {
            $liveObject | Out-GridView -Title "Live Object Output"
            $liveObject | ConvertTo-Csv -NoTypeInformation > Organize_Files_Results.csv
        }
    } 
}