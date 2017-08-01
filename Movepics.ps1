Remove-Variable directoryInfo
Remove-Variable directoryObject
Remove-Variable directoryObject
Remove-Variable loopobject
Remove-Variable sortedObject
Remove-Variable uniqueDays
Remove-Variable tableCreationError
Clear-Host

$testPath = "C:\Users\joshp\test\" #this is the folder where the dated folders will be created
$path = "C:\Users\joshp\Pictures\Unsorted\" #this is the path we will be grabbing objects to sort and move will be coming from
$directoryInfo = Get-ChildItem -Path $path -Recurse -file #the actual act of gathing info on all the pbjects in the directory, not recursive
$directoryObject = @() #instansiating the hashtable we will be storing file info in
$dateTime = Get-Date 
$runTime = $dateTime.ToShortTimeString()
$runDate = $dateTime.ToShortDateString() 
$tableCreationError
$uniqueDirectoryCollector = @()
[boolean]$displayLogs = $TRUE


#creating a hastable with data, this will be saved as a CSV for each time this runs and is used to find the copy commands
Foreach($line in $directoryInfo) 
	{
	  	$linedate = $line.CreationTime.ToShortDateString()
		$lineDateFormatted = $linedate.Replace('/','-')
		$MovePath = Join-Path $testPath $lineDateFormatted 
		$MovePath = Join-Path $MovePath $line.Name
		$formatedDate = $line.CreationTime.ToShortDateString() 
		$formatedDate = $formatedDate.Replace('/','-')
		$LoopObject = New-Object PSObject @()            
	  	$LoopObject | Add-Member -MemberType NoteProperty -Name "CreationDate" -Value $formatedDate -ErrorVariable $tableCreationError
		$LoopObject | Add-Member -MemberType NoteProperty -Name "FileName" -Value $line.Name -ErrorVariable $tableCreationError
		$LoopObject | Add-Member -MemberType NoteProperty -Name "Length" -Value $line.Length -ErrorVariable $tableCreationError
		$LoopObject | Add-Member -MemberType NoteProperty -Name "FileType" -Value $line.Extension -ErrorVariable $tableCreationError
		$LoopObject	| Add-Member -MemberType NoteProperty -Name "FullPath" -Value $line.FullName -ErrorVariable $tableCreationError
		$LoopObject	| Add-Member -MemberType NoteProperty -Name "MovePath" -Value $MovePath -ErrorVariable $tableCreationError
		$LoopObject | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $runDate -ErrorVariable $tableCreationError
		$LoopObject | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $runTime -ErrorVariable $tableCreationError
		#$LoopObject
		$script:directoryObject += $LoopObject
	}

#this section creates an array of unique dates from the hashtable
$sortedObject = $directoryObject | Sort-Object CreationDate
$sortedObject = $sortedObject|Select-Object CreationDate | Sort-Object -Unique CreationDate
$uniqueDays = $sortedObject.CreationDate.Replace('/','-')


# This section Tests if a Particular date path already exists. if true it outputs a message, if false it creates the path 
foreach($Date in $uniquedays) {
	
	$loopDirectoryName = Join-Path $testPath $Date -ErrorAction Inquire -ErrorVariable $directoryCreationError
		If( Test-Path -Path $loopDirectoryName ) 
			{ 	
				$directoryLoopCollector = New-Object PSObject @()
				Write-Host $loopDirectoryName " Path Exists" -BackgroundColor Black -ForegroundColor Red
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "Path" -Value $loopDirectoryname -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryExists" -Value "Yes" -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryCreated" -Value "No" -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $runDate -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $runTime -ErrorVariable $directoryCreationError
				$uniqueDirectoryCollector += $directoryLoopCollector
			} 
		else 
			{
				$directoryLoopCollector = New-Object PSObject @()
				New-Item -Path $loopDirectoryName -ItemType Directory -ErrorAction Inquire -ErrorVariable $directoryCreationError -
				Write-Host $loopDirectoryname " Created Path " $loopDirectoryname -BackgroundColor Black -ForegroundColor Green
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "Path" -Value $loopDirectoryname -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryExists" -Value "No" -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "DirectoryCreated" -Value "Yes" -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunDate" -Value $runDate -ErrorVariable $directoryCreationError
				$directoryLoopCollector | Add-Member -MemberType NoteProperty -Name "RunTime" -Value $runTime -ErrorVariable $directoryCreationError
				$uniqueDirectoryCollector += $directoryLoopCollector
			}
								}
If ($displayLogs = $TRUE) 
			{
				$directoryLog = $uniqueDirectoryCollector | Out-GridView
				$infoObject = $directoryObject | Out-GridView
				$infologObject = $directoryObject 
				$infologObject > c:\Users\joshp\Desktop\MovePiclog-Info.txt 
				$directoryLog = $uniqueDirectoryCollector
				$directoryLog > c:\Users\joshp\Desktop\MovePiclog-Directory.txt 
			}
Else
			{
				$infologObject = $directoryObject 
				$infologObject > c:\Users\joshp\Desktop\MovePiclog-Info.txt 
				$directoryLog = $uniqueDirectoryCollector
				$directoryLog > c:\Users\joshp\Desktop\MovePiclog-Directory.txt
			}

<#from final object I plug the string in "MovePath" into the Copy or move command
Foreach ($lineitem in $directoryObject)
	{
		Write-Host "I am going to attempt to copy from " $lineitem.FullPath " to " $lineitem.MovePath 
		Move-Item -Path $lineitem.FullPath -Destination $lineitem.MovePath -ErrorAction Inquire 
	}
	#>