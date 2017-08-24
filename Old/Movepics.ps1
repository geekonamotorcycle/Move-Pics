<# Are you a business?
Copyright 2017, Joshua Porrata
If you are then you should consider contacting me fr a license to use this simpe little script. 
It's nt actually free for businesses, it just has no copy protection. 
Contact me at my email address localbeautytampabay@gmail.com for details on very low business rates. 
Copyright 2017, Joshua Porrata
I put Lydia's name in here #>

#Just making sure there isnt any old data hanging around, I dont trust.
Function copyright {
    Write-Host "`n***********************************************" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***Copyright 2017, Joshua Porrata**************" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***This program is not free for business use***" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***Contact me at localbeautytampabay@gmail.com*" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***for a cheap business license****************" -BackgroundColor Black -ForegroundColor DarkGreen
    Write-Host "***Donations are wholeheartedly accepted ******" -BackgroundColor Black -ForegroundColor Red
    Write-Host "***accepted @ www.paypal.me/lbtpa**************" -BackgroundColor Black -ForegroundColor Red
    Write-Host "***********************************************`n" -BackgroundColor Black -ForegroundColor DarkGreen
}
Clear-Host
Start-Sleep -Seconds 2
Function clearOldVar {
    Remove-Variable copyloopobject -ErrorAction SilentlyContinue
    Remove-Variable datetime -ErrorAction SilentlyContinue
    Remove-Variable directoryInfo -ErrorAction SilentlyContinue
    Remove-Variable directorylog -ErrorAction SilentlyContinue
    Remove-Variable directoryloopcollector -ErrorAction SilentlyContinue
    Remove-Variable directoryObject -ErrorAction SilentlyContinue
    Remove-Variable displaylogs -ErrorAction SilentlyContinue
    Remove-Variable formateddate -ErrorAction SilentlyContinue
    Remove-Variable infologobject -ErrorAction SilentlyContinue
    Remove-Variable infoobject -ErrorAction SilentlyContinue
    Remove-Variable line -ErrorAction SilentlyContinue
    Remove-Variable linedate -ErrorAction SilentlyContinue
    Remove-Variable linedateformatted -ErrorAction SilentlyContinue
    Remove-Variable lineitem -ErrorAction SilentlyContinue
    Remove-Variable logobject -ErrorAction SilentlyContinue
    Remove-Variable loopcollector -ErrorAction SilentlyContinue
    Remove-Variable loopdirectoryname -ErrorAction SilentlyContinue
    Remove-Variable loopobject -ErrorAction SilentlyContinue
    Remove-Variable movepath -ErrorAction SilentlyContinue
    Remove-Variable Moveloopcollector -ErrorAction SilentlyContinue
    Remove-Variable Moveloopobject -ErrorAction SilentlyContinue
    #Copyright 2017, Joshua Porrata
    Remove-Variable Movepicsdirectorylog -ErrorAction SilentlyContinue
    Remove-Variable movepicslog -ErrorAction SilentlyContinue
    Remove-Variable path -ErrorAction SilentlyContinue
    Remove-Variable rundate -ErrorAction SilentlyContinue
    Remove-Variable runtime -ErrorAction SilentlyContinue
    Remove-Variable sortedObject -ErrorAction SilentlyContinue
    Remove-Variable testpath -ErrorAction SilentlyContinue
    Remove-Variable uniquedays -ErrorAction SilentlyContinue
    Remove-Variable uniquedirectorycollector -ErrorAction SilentlyContinue
    Remove-Variable copyormove -ErrorAction SilentlyContinue
    Remove-Variable errorlog -ErrorAction SilentlyContinue
    Remove-Variable movelogobject -ErrorAction SilentlyContinue
    Remove-Variable i -ErrorAction SilentlyContinue	
}
	

clearOldVar
copyright

[boolean]$ReadPaths = $true
$testReadPath = $false
$testReadDestPath = $false

# 0 Does not show logs, but saves them to the desktop, 1 Makes a popup grid view of the logs and saves them to the desktop
[boolean]$displayLogs = 1
# 1 moves the files from the source directory, 0 copies them
[boolean]$copyOrMove = 1
#After a move/copy is performed a message will be displayed showing the original path and the new path 1= show 0 = dont show
[boolean]$watchWork = 1
#Test mode, 1 means It will not execute the actual move/copy but will do everything else, 0 will perform the code like normal
[boolean]$testMode = 0
#Future feature, will dump logs after each step.
[Boolean]$debugMode = 0
#I am either going to include a feature to find and isolate duplicates in this script or I am going to break it out to another script
[Boolean]$findDuplicates = 0


function readPaths {
    if ($ReadPaths -eq $true) {	
        $inputcount = 1
        while (-not ($testReadPath -and $testReadDestPath)) {
            #enter source path
            $sourcePath = Read-Host "`nEnter the Source Path[attempt #$inputcount] " 
            $testReadPath = Test-Path $sourcepath 
            #varies output based on whether the path exists or not 
            if ($testReadPath) {
                Write-Host "You entered: $sourcepath  Does the path exist? $testReadPath" -ForegroundColor Green
                
            }
            else {
                Write-Host "You entered: $sourcepath  Does the path exist? $testReadPath"	-ForegroundColor Red
            }
            #Enter Destination Path
            $destPath = Read-Host "`nEnter the Destination Path[attempt #$inputcount] " 
            $testReadDestPath = Test-Path $destPath
            if ($testReadDestPath) {	
                Write-Host "You entered: $destPath  Does the path exist? $testReadDestPath" -ForegroundColor Green
                
            }
            else {
                Write-Host "You entered: $destPath  Does the path exist? $testReadDestPath" -ForegroundColor Red
            }
            Write-Host "`nThe script will pause for 2 seconds now.`nif you are caught in a loop, take this opportunity to `nsend a break command`n" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            $inputcount++
        }
        if ($sourcePath -ne $null) {
            $directoryInfo = Get-ChildItem -Path $sourcePath -Recurse -file
            $fileCount = $directoryInfo.Count
            Write-Host "I found $fileCount files." -ForegroundColor Green
            If ($directoryInfo -eq $null) {
                Write-Host "The Source Directory is empty. `nThe source directory you entered was `n"
                Write-Host "$sourcePath `n" -ForegroundColor Red
                Write-Host "I will break the script; check the directory and ensure there are files for me to sort."
                Break
            }
        }
        $script:destpath =  $destPath
        $script:sourcepath =  $sourcePath
        $script:directoryInfo = $directoryInfo
    }

}

Write-Host "The following paramaters are set:" -BackgroundColor Black -ForegroundColor Green
Write-Host "Test mode: $testMode" -BackgroundColor Black -ForegroundColor Green
Write-Host "Watch Work: $watchWork" -BackgroundColor Black -ForegroundColor Green
Write-Host "Copy (False) or Move (True): $copyOrMove" -BackgroundColor Black -ForegroundColor Green
Write-Host "Display Logs at the end of run: $displayLogs" -BackgroundColor Black -ForegroundColor Green
readPaths

#Future use
$ErrorAction = 'Continue'
#Getting some run dates and times, there is likely a beter way to do this...
$dateTime = Get-Date 
$runTime = $dateTime.ToShortTimeString()
$runDate = $dateTime.ToShortDateString() 
#Creating some hashtables 
$directoryObject = @() 
$uniqueDirectoryCollector = @()
$moveLoopCollector = @()

#creating a hastable with data, this will be saved as a CSV for each time this runs and is used to find the copy commands
Foreach ($line in $directoryInfo) {
	$icount1 = 0
    $linedate = $line.CreationTime.ToShortDateString()
    $lineDateFormatted = $linedate.Replace('/', '-')
    $MovePath = Join-Path $destPath $lineDateFormatted 
    $MovePath = Join-Path $MovePath $line.Name
    $formatedDate = $line.CreationTime.ToShortDateString() 
    $formatedDate = $formatedDate.Replace('/', '-')
	$dirCount = 	$directoryInfo.Count
    #Array Block
    $LoopObject = New-Object PSObject @()            
	$LoopObject | Add-Member -MemberType NoteProperty -Name "CreationDate" -Value $formatedDate -ErrorVariable $tableCreationError
    $LoopObject | Add-Member -MemberType NoteProperty -Name "FileName" -Value $line.Name -ErrorVariable $tableCreationError
    $LoopObject | Add-Member -MemberType NoteProperty -Name "Length" -Value $line.Length -ErrorVariable $tableCreationError
    $LoopObject | Add-Member -MemberType NoteProperty -Name "FileType" -Value $line.Extension -ErrorVariable $tableCreationError
    $LoopObject	| Add-Member -MemberType NoteProperty -Name "FullPath" -Value $line.FullName -ErrorVariable $tableCreationError
    $LoopObject	| Add-Member -MemberType NoteProperty -Name "MovePath" -Value $MovePath -ErrorVariable $tableCreationError
    $LoopObject | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $runDate -ErrorVariable $tableCreationError
    $LoopObject | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $runTime -ErrorVariable $tableCreationError
    #$LoopObject #re-enable this line if you like to see things scroll
    #Copyright 2017, Joshua Porrata
    $script:directoryObject += $LoopObject
    Write-Progress -Activity "Scanning Objects " -status "Scanned $icount1 of $dirCount "  -percentComplete ($icount1 / $dircount * 100) -ErrorAction SilentlyContinue
    $icount1++
}

#this section creates an array of unique dates from the hashtable
if ($watchWork) {
    Write-Host "Organizing by date 1/4"
    Start-Sleep -Seconds 1
}

$sortedObject = $directoryObject | Sort-Object CreationDate

if ($watchWork) {
    Write-Host "Organizing by date 2/4"
    Start-Sleep -Seconds 1
}
$sortedObject = $sortedObject|Select-Object CreationDate | Sort-Object -Unique CreationDate
if ($watchWork) {
    Write-Host "Organizing by date 3/4"
    Start-Sleep -Seconds 1
}

$uniqueDays = $sortedObject.CreationDate.Replace('/', '-')

if ($watchWork) {
    Write-Host "Organizing by date 4/4"
    Write-Host "A total of " $uniqueDays.count " unique dates was found"
    Start-Sleep -Seconds 1
}

# This section Tests if a Particular date path already exists. if true it outputs a message, if false it creates the path 
foreach ($Date in $uniquedays) {
	
    $loopDirectoryName = Join-Path $DestPath $Date -ErrorAction Continue -ErrorVariable $directoryCreationError
    If ( Test-Path -Path $loopDirectoryName ) { 	
        Write-Host $loopDirectoryName " Path Exists" -BackgroundColor Black -ForegroundColor Cyan
					
        #Array Block
        $directoryLoopCollector = New-Object PSObject @()
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "Path" -Value $loopDirectoryname -ErrorVariable $directoryCreationError
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryExists" -Value "Yes" -ErrorVariable $directoryCreationError
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryCreated" -Value "No" -ErrorVariable $directoryCreationError
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $runDate -ErrorVariable $directoryCreationError
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $runTime -ErrorVariable $directoryCreationError
        $uniqueDirectoryCollector += $directoryLoopCollector
				} 
    else {
        if ($testMode -eq 0) {
            New-Item -Path $loopDirectoryName -ItemType Directory -ErrorAction $ErrorAction -ErrorVariable $directoryCreationError 
            $loopPathTest = Test-Path -Path $loopDirectoryName
            if ($watchWork) {
                Write-Host " Created Path " $loopDirectoryname -BackgroundColor Black -ForegroundColor Green
            }
        }
        #Array Block
        $directoryLoopCollector = New-Object PSObject @()
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "Path" -Value $loopDirectoryname -ErrorVariable $directoryCreationError
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryExists" -Value "No" -ErrorVariable $directoryCreationError
        if ($loopPathTest) {
            $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryCreated" -Value "Yes" -ErrorVariable $directoryCreationError
        }
        else {
            $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryCreated" -Value "Fail" -ErrorVariable $directoryCreationError
        }
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $runDate -ErrorVariable $directoryCreationError
        $directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $runTime -ErrorVariable $directoryCreationError
        $uniqueDirectoryCollector += $directoryLoopCollector
				}
}


# from directory object I plug the string in "MovePath" into the Copy or move command
if ($copyOrMove -eq $False) {
    $i = 1
    Foreach ($lineitem in $directoryObject) {
        If ($watchWork) {
            Write-Host $i " of " $directoryObject.Count  " I am going to attempt to COPY from " $lineitem.FullPath " to " $lineitem.MovePath 
        }
        if ($testMode -eq 0) {
            #Write-Host "Copy logic is good" -BackgroundColor Black -ForegroundColor Green
            Copy-Item -Path $lineitem.FullPath -Destination $lineitem.MovePath -ErrorAction $ErrorAction 
        }					
        #Array Block #Copyright 2017, Joshua Porrata
        $CopyloopObject = New-Object PSObject @()            
        $CopyloopObject | Add-Member -MemberType NoteProperty -Name "CreationDate" -Value $lineitem.CreationDate -ErrorVariable $tableCreationError
        $CopyloopObject | Add-Member -MemberType NoteProperty -Name "FileName" -Value $lineitem.FileName -ErrorVariable $tableCreationError
        $CopyloopObject  | Add-Member -MemberType NoteProperty -Name "Length" -Value $lineitem.Length -ErrorVariable $tableCreationError
        $CopyloopObject | Add-Member -MemberType NoteProperty -Name "FileType" -Value $lineitem.FileType -ErrorVariable $tableCreationError
        $CopyloopObject | Add-Member -MemberType NoteProperty -Name "FullPath" -Value $lineitem.FullPath -ErrorVariable $tableCreationError
        $CopyloopObject	| Add-Member -MemberType NoteProperty -Name "MovePath" -Value $lineitem.MovePath -ErrorVariable $tableCreationError
			
        #Checking to see if the copy worked
        if (Test-Path -Path $lineitem.MovePath) {
            $CopyloopObject | Add-Member -MemberType NoteProperty -Name "CopySuccess" -Value "Yes" -ErrorVariable $tableCreationError
        }
        else {
            $CopyloopObject | Add-Member -MemberType NoteProperty -Name "CopySuccess" -Value "No" -ErrorVariable $tableCreationError
        }
				
        $CopyloopObject | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $lineitem.runDate -ErrorVariable $tableCreationError
        $CopyloopObject | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $lineitem.runTime -ErrorVariable $tableCreationError
        #collect the harsh table data 
        $moveLoopCollector += $CopyloopObject
        $count = $directoryObject.Count
        Write-Progress -Activity "Copying files... " -status "Copied $i of $Count "  -percentComplete ($i / $directoryObject.Count * 100) 
        $i++
    }
}
else {
    $i = 1
    Foreach ($lineitem in $directoryObject) {	
        If ($watchWork) {
            Write-Host $i " of " $directoryObject.Count "  " $lineitem.FullPath " to " $lineitem.MovePath 
        }
        if ($testMode -eq 0) {
            #Write-Host "Move logic is good" -BackgroundColor Black -ForegroundColor Green
            Move-Item -Path $lineitem.FullPath -Destination $lineitem.MovePath -ErrorAction $ErrorAction 
        }						
        #Array Block
        $MoveloopObject = New-Object PSObject @()            
        $MoveloopObject | Add-Member -MemberType NoteProperty -Name "CreationDate" -Value $lineitem.CreationDate -ErrorVariable $tableCreationError
        $MoveloopObject | Add-Member -MemberType NoteProperty -Name "FileName" -Value $lineitem.FileName -ErrorVariable $tableCreationError
        $MoveloopObject  | Add-Member -MemberType NoteProperty -Name "Length" -Value $lineitem.Length -ErrorVariable $tableCreationError
        $MoveloopObject | Add-Member -MemberType NoteProperty -Name "FileType" -Value $lineitem.FileType -ErrorVariable $tableCreationError
        $MoveloopObject | Add-Member -MemberType NoteProperty -Name "FullPath" -Value $lineitem.FullPath -ErrorVariable $tableCreationError
        $MoveloopObject	| Add-Member -MemberType NoteProperty -Name "MovePath" -Value $lineitem.MovePath -ErrorVariable $tableCreationError
		
        #Checking to see if the copy worked
        if (Test-Path -Path $lineitem.MovePath) {
            $MoveloopObject | Add-Member -MemberType NoteProperty -Name "MoveSuccess" -Value "Yes" -ErrorVariable $tableCreationError
        }
        else {
            $MoveloopObject | Add-Member -MemberType NoteProperty -Name "MoveSuccess" -Value "No" -ErrorVariable $tableCreationError
        }
        $MoveloopObject | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $lineitem.runDate -ErrorVariable $tableCreationError
        $MoveloopObject | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $lineitem.runTime -ErrorVariable $tableCreationError
        #collect the harsh table data 
        $moveLoopCollector += $MoveloopObject
        $count = $directoryObject.Count
        Write-Progress -Activity "Moving files... " -status "Moved $i of $count"  -percentComplete ($i / $directoryObject.Count * 100)
        $i++
    }
}

#Log creation and display 
If ($displayLogs -eq $true) {
    #Displaying Moving Log
    $moveLogObject = $moveLoopCollector | Out-GridView -ErrorAction $ErrorAction
    #creating the Move logs
    $moveLogObject = $moveLoopCollector
    #Creating the Move Log text
    $MovePicsLog = "MP-MoveLog.txt"
    $logpath = Join-Path $destPath $MovePicsLog
    $moveLogObject | Out-File -filepath  $logpath -Force -ErrorAction $ErrorAction
    $directoryLog = $uniqueDirectoryCollector 
	
	
    #Displaying Directory Log
    $directoryLog = $uniqueDirectoryCollector | Out-GridView -ErrorAction $ErrorAction	
    #creating the Directory logs
    $directoryLog = $uniqueDirectoryCollector 
    #Directory Creation Log #Copyright 2017, Joshua Porrata
    $MovePicsDirectoryLog = "MP-DirectoryLog.txt"
    $logpath = Join-Path $destPath $MovePicsDirectoryLog
    $directoryLog | Out-File -FilePath $logpath -Force -ErrorAction $ErrorAction
}
Else {
    #File Move Log
    $MovePicsLog = "MP-MoveLog.txt"
    $logpath = Join-Path $destPath $MovePicsLog
    $moveLogObject | Out-File -filepath  $logpath -Force -ErrorAction $ErrorAction
    $directoryLog = $uniqueDirectoryCollector 
	
    #Directory Creation Log
    $MovePicsDirectoryLog = "MP-DirectoryLog.txt"
    $logpath = Join-Path $destPath $MovePicsDirectoryLog
    #Copyright 2017, Joshua Porrata
    $directoryLog | Out-File -FilePath $logpath -Force -ErrorAction $ErrorAction
}	
copyright
clearOldVar


#Copyright 2017, Joshua Porrata
