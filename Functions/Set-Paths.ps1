function Set-Paths {
    Param(
        #testMode = Not Mandatory - default is True - actually makes the paths
        [Parameter(Mandatory = $false)]
        [boolean]
        $testMode = $true,
        #Uniquedays = Mandatory - a string opbject of unique dates, passed in from find-uniquedays
        [Parameter(Mandatory = $true)]
        $uniqueDays,
        #DestPath = Mandatory - A String, root path that subfolders will be created in
        [Parameter(Mandatory = $true)]
        [string]
        $destinationpath

    )
    $time = Get-Date
    $MadePaths = @()
    If ($testMode) {
        #Write-Host "TestMode is $testMode"
        foreach ($date in $UniqueDays) {
            #join DestPath and uniuedate
            $newDestPath = Join-Path $destinationpath $date
            Write-Host "`nRunning in Test Mode, Calculated path is $newDestPath" -ForegroundColor Green
        }
    }
    else {
        #Write-Host "`nI am Not in Test mode!" -ForegroundColor Red
        #Write-Host "$destinationpath" -ForegroundColor Green
        #Write-Host "$uniquedays`n" -ForegroundColor Green
        foreach ($date in $uniquedays) {
            $loopobject = New-Object PSObject @()
            #join DestPath and uniuedate
            $newDestPath = Join-Path $destinationpath $date
            #Checking if the path exists.
            $testDestPath = Test-Path $newDestPath
            #if exists then write to log
            if ($testDestPath) {
                #Include: Fullpath, existence(Yes), was not create (Already exists), Time
                $loopobject | Add-Member -MemberType NoteProperty -Name "Path" -Value $newDestPath
                $loopobject | Add-Member -MemberType NoteProperty -Name "Exists" -Value "Yes"
                $loopobject | Add-Member -MemberType NoteProperty -Name "Created" -Value "No"
                $loopobject | Add-Member -MemberType NoteProperty -Name "Time" -Value $time
                #$loopobject | Add-Member -MemberType NoteProperty -Name "" -Value AAAA
                $MadePaths += $loopobject
            }
            else {
                New-Item -Path $newDestPath -ItemType Directory -InformationAction 'silent'
                $newPathTest = Test-Path -Path $newDestPath
                #Include: Fullpath
                $loopobject | Add-Member -MemberType NoteProperty -Name "Path" -Value $newDestPath
                
                If ($newPathTest) {
                    #include: If creation was successful
                    $loopobject | Add-Member -MemberType NoteProperty -Name "Exists" -Value "Yes"            
                }
                else {
                    $loopobject | Add-Member -MemberType NoteProperty -Name "Exists" -Value "No"
                }

                if ($newPathTest) {
                    $loopobject | Add-Member -MemberType NoteProperty -Name "Created" -Value "Yes"            
                }
                else {
                    $loopobject | Add-Member -MemberType NoteProperty -Name "Created" -Value "Fail"
                }
                $loopobject | Add-Member -MemberType NoteProperty -Name "Time" -Value $time
                $MadePaths += $loopobject
            }
        }
    }
    #Pay no mind to this thing below here, will be useful later
    #$script:newPaths = $MadePaths
}

#Testing Stuff below here
$destpath = "c:\tes"
$uniquedays = "01-01-2017"
set-Paths -destpath $destpath -uniqueDays 
$newPaths | Out-GridView
