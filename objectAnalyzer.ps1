# objeactAnalyzer class
# Version 0.5
# Designed for powershell 5.1
# Copyright 2017 - Joshua Porrata
# Not for business use without an inexpensive license, contact 
# Localbeautytampabay@gmail.com for questions about a lisence 
# there is no warranty, this might destroy everything it touches. 

<#

.SYNOPSIS
This is a class whose purpose is to assist in moving files (photos) based on the dates they were created or last modified. This is not the final version and the 
copy/move functionality has not been added

.DESCRIPTION
You should read the source code notes... This will be updated when the class is complete.

# Not for business use without an inexpensive license, contact 
# Localbeautytampabay@gmail.com for questions about a lisence 
# there is no warranty, this might destroy everything it touches. 

.EXAMPLE
Intansiate like this: 
[objectAnalyzer]$test = [objectAnalyzer]::new("E:\Users\joshp\Pictures\2017\10-2017\10-12-2017\IMG_20171012_165945.dng", "C:\test\testdest")
The first parameter is the path to the object you want to analyze/move, the second parameter is the root of the path wher eyou want the file object to be moved to.

$test.gettargetDirectory() - this is the path to the directory the file will be moved to with the creation date included
$test.getTargetPath() - This is the path that the item will be sent to: 
$test.targetFolderExists() - Does the target folder exist 
$test.testDestinationPath() - Can the target folder be written to: 
$test.createfolder() - When this test is on, it created the directory including the date.
$test.testObjectPath() - Does the Object path Exist(can the file be found)
$test.toString() - outputs the full target path including date and filename
$test.resetObject() - clears all stored variables. 
$test.setObjectPath("c:\path\to\object.object". "Path to root of the new destinaiton directory") - performes a reset and then sets the object path and destinaiton 
path and calculates new values for the destinaiton.
$this.dumpState() - dumps object state into a csv

Most fo the variables are hidden, You should not mess with them really. 


.NOTES
This is still being written. You can ass more functionality if you please.

.LINK
This class is meant to replace the script found at 
https://github.com/geekonamotorcycle/Organize-Files/blob/master/Organize-Files.ps1

I am
Joshua Porrata
localbeautytampabay@gmail.com

#>

class objectAnalyzer : System.Array{
     [string]$originPath;
     [string]$fileName;
     [string]$destinationPath;
     [string]$dateType;
     $targetPath; # this is the target path including the Date and filename, this will be useful for 
     $targetDirectory; #this is the path to the directory with the modified or created date for the file added
     [bool]$finalState #will be used to mark whether the objects move attempt was succesful or not

    objectAnalyzer(
        [string]$ObjectPath,
        [string]$destinationPath
    ) {
        $this.originPath = $ObjectPath;
        $this.destinationPath = $destinationPath;
        $this.datetype = "created";
        $this.getTargetPath;
    }
    [bool] testObjectPath () {
        if (Test-Path -Path $this.originPath) {
            return $true;
        }
        else {
            return $false;
        }
    }
    [void]resetObject() {
        [string]$this.originPath = "Default";
        [string]$this.fileName = "Default";
        [string]$this.destinationPath = "Default";
        [string]$this.dateType = "Default";
        $this.targetPath = "Default";
        $this.targetDirectory = "Default"; 
        [bool]$this.finalState = $false;
        $this.datetype = "created";
    }

    [void] setObjectPath([string]$newObjectPath, [string]$destinationPath) {
        $this.resetObject();
        $this.originPath = $newObjectPath;
        $this.destinationPath = $destinationPath;
        $this.getTargetPath();
        $this.testDestinationPath();
    }

    [bool] testDestinationPath() {
        $testFile = Join-Path -Path $this.getTargetDirectory() -ChildPath "testFile.TXT"
        if (! $this.targetFolderExists()) {
            return $false;
        }
        if (New-Item -ItemType File -Path $testFile -Force) {
            Remove-Item -Path $testFile;
            return $true;
        }
        else {
            throw "The destination directory cannot be written to. You may not have permission or it may not exist. Contact a system administrator"
            return $false; 
        }
    }
    
    [string] getTargetDirectory() {
        $this.targetDirectory = Get-ChildItem -Path $this.originPath;
        $this.fileName = $this.targetDirectory.name

        if ($this.datetype.Equals("modified")) {
            $this.targetDirectory = $this.targetDirectory.LastWriteTime;
        }
        else {
            $this.targetDirectory = $this.targetDirectory.CreationTime;
        }
        $this.targetDirectory = $this.targetDirectory.ToShortDateString();
        $this.targetDirectory = $this.targetDirectory.Replace('/', '-');
        $this.targetDirectory = Join-Path -Path $this.destinationPath -ChildPath $this.targetDirectory
        return $this.targetDirectory;
    }

    [string[]] getTargetPath () {
        $this.targetPath = Get-ChildItem -Path $this.originPath;
        $this.fileName = $this.targetPath.name
        if ($this.datetype.Equals("modified")) {
            $this.targetPath = $this.targetPath.LastWriteTime;
        }
        else {
            $this.targetPath = $this.targetPath.CreationTime; 
        }
        $this.targetPath = $this.targetPath.ToShortDateString();
        $this.targetPath = $this.targetPath.Replace('/', '-');
        $this.targetPath = Join-Path -Path $this.destinationPath -ChildPath $this.targetPath
        $this.targetPath = Join-Path -Path $this.targetPath -ChildPath $this.fileName
        return $this.targetPath;
    }
    [bool] targetFolderExists() {
        if (Test-Path $this.getTargetDirectory()) {
            return $true;
        }
        else {
            return $false; 
        }
    }
    createFolder() {
        if ($this.targetFolderExists()) {

        }
        else {
            New-Item -ItemType Directory -Path $this.targetDirectory;
        }
    }
    [void] copyObject() {
        if ($this.testObjectPath()) {
            $this.createFolder();
            Copy-Item -Path $This.originPath -Destination $this.targetPath;
            $this.dumpState();
        }
        else {
            $this.finalState = $false;
            $this.dumpState();
            throw "If you are seeing this message, the test of the path to the object failed. Check the source path and try again. "
        }
    }
    
    [void] moveObject() {
        if ($this.testObjectPath()) {
            $this.createFolder();
            Move-Item -Path $This.originPath -Destination $this.targetPath;    
            $this.dumpState();
        }
        else {
            $this.finalState = $false;
            $this.dumpState();
            throw "If you are seeing this message, the test of the path to the object failed. Check the source path and try again. "
        }
    }
    [void] dumpState() {
        $this | ConvertTo-Csv > ObjectAnalyzertest.csv -NoTypeInformation
    }

    [string] toString () {
        if ($this.originPath.Equals("Default")) {
            return "The string that holds the path to the object is empty. You may have reset the object without giving a new path to object";
        }
        else {
            return $this.getTargetPath(); 
        }
        
    }
}


Clear-Host

[objectAnalyzer]$test = [objectAnalyzer]::new("E:\Users\joshp\Pictures\2017\10-2017\10-12-2017\IMG_20171012_165945.dng", "C:\test\testdest")
write-host "`nThis is the directory that the item will be sent to: " $test.gettargetDirectory() -ForegroundColor Gray
write-host "This is the path that the item will be sent to: " $test.getTargetPath() -ForegroundColor Gray
write-host "Does the target folder exist " $test.targetFolderExists()  -ForegroundColor Gray
Write-Host "Can the target folder be written to: " $test.testDestinationPath() -ForegroundColor Gray
Write-Host "When this test is on, it created the path: " $test.createfolder() -ForegroundColor Gray
Write-Host "Does the Object path Exist(can the file be found)   "$test.testObjectPath() -ForegroundColor Gray
Write-Host "`nTesting to string method in the space below " -ForegroundColor Red
$test.ToString();

Write-Host "`nUsing .resetObject"  -ForegroundColor red
$test.resetObject()
$test.ToString();

Write-Host "`nusing .setObjectPath and re running tests"

$test.setObjectPath("E:\Users\joshp\Pictures\2017\10-2017\10-12-2017\IMG_20171012_165945.dng", "C:\test\testdest")
$test.ToString();

write-host "`nThis is the directory that the item will be sent to: " $test.gettargetDirectory() -ForegroundColor Gray
write-host "This is the path that the item will be sent to: " $test.getTargetPath() -ForegroundColor Gray
write-host "Does the target folder exist " $test.targetFolderExists()  -ForegroundColor Gray
Write-Host "Can the target folder be written to: " $test.testDestinationPath() -ForegroundColor Gray
Write-Host "When this test is on, it created the path: " $test.createfolder() -ForegroundColor Gray
Write-Host "Does the Object path Exist(can the file be found)   "$test.testObjectPath() "`n" -ForegroundColor Gray

$test.copyObject();
$test | Out-GridView;