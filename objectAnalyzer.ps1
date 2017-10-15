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

[objectAnalyzer]$test = [objectAnalyzer]::new

$test.gettargetDirectory() - this is the path to the directory the file will be moved to with the creation date included
$test.getTargetPath() - This is the path that the item will be sent to: 
$test.targetFolderExists() - Does the target folder exist 
$test.testDestinationPath() - Can the target folder be written to: 
$test.createfolder() - When this test is on, it created the directory including the date.
$test.testObjectPath() - Does the Object path Exist(can the file be found)
$test.toString() - outputs the full target path including date and filename
$test.resetObject() - clears all stored variables. 
$test.setObjectPath("c:\path\to\object.object". "Path to root of the new destinaiton directory", "created" or "modified") - performes a reset and then sets the object path and destinaiton 
path and calculates new values for the destinaiton.
$This.dumpState() - dumps object state into a csv

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

class ObjectAnalyzer {
    [string]$originPath;
    [string]$fileName;
    [string]$destinationPath;
    [string]$dateType;
    $targetPath;
    $targetDirectory; 
    [bool]$finalState;
    [string]$Hash;
    [array]$Messages;

    objectAnalyzer() {
        $This.originPath = "Default";
        $This.destinationPath = "Default";
        $This.datetype = "created";
        $This.Hash = "Default"
        $This.Messages = @("The destination directory cannot be written to. You may not have permission or it may not exist. Contact a system administrator",
        "The test of the path to the object failed. Check the source path and try again. `n",
        "The test of the path to the object failed. Check the source path and try again.`n ");
    }

    [bool] testObjectPath () {
        if (Test-Path -Path $This.originPath) {
            return $true;
        }
        else {
            return $false;
        }
    }
    [void] setObjectPath([String]$newObjectPath, [String]$destinationPath, [String]$dateType) {
        $This.resetObject();
        $This.originPath = $newObjectPath;
        $This.destinationPath = $destinationPath;
        $This.dateType = $dateType;
        $This.getTargetPath();
    }

    [void]resetObject() {
        [string]$This.originPath = "Default";
        [string]$This.fileName = "Default";
        [string]$This.destinationPath = "Default";
        [string]$This.dateType = "Default";
        $This.targetPath = "Default";
        $This.targetDirectory = "Default"; 
        [bool]$This.finalState = $false;
        $This.datetype = "created";
    }

    [bool] testDestinationPath() {
        $testFile = Join-Path -Path $This.getTargetDirectory() -ChildPath "testFile.TXT"
        if (! $This.targetFolderExists()) {
            return $false;
        }
        if (New-Item -ItemType File -Path $testFile -Force) {
            Remove-Item -Path $testFile;
            return $true;
        }
        else {
            throw $This.Messages[0];
            return $false; 
        }
    }
    
    [string] getTargetDirectory() {
        $This.targetDirectory = Get-ChildItem -Path $This.originPath;
        $This.fileName = $This.targetDirectory.name

        if ($This.datetype.Equals("modified")) {
            $This.targetDirectory = $This.targetDirectory.LastWriteTime;
        }
        else {
            $This.targetDirectory = $This.targetDirectory.CreationTime;
        }
        $This.targetDirectory = $This.targetDirectory.ToShortDateString();
        $This.targetDirectory = $This.targetDirectory.Replace('/', '-');
        $This.targetDirectory = Join-Path -Path $This.destinationPath -ChildPath $This.targetDirectory
        return $This.targetDirectory;
    }

    [string[]] getTargetPath () {
        $This.targetPath = Get-ChildItem -Path $This.originPath;
        $This.fileName = $This.targetPath.name
        if ($This.datetype.Equals("modified")) {
            $This.targetPath = $This.targetPath.LastWriteTime;
        }
        else {
            $This.targetPath = $This.targetPath.CreationTime; 
        }
        $This.targetPath = $This.targetPath.ToShortDateString();
        $This.targetPath = $This.targetPath.Replace('/', '-');
        $This.targetPath = Join-Path -Path $This.destinationPath -ChildPath $This.targetPath
        $This.targetPath = Join-Path -Path $This.targetPath -ChildPath $This.fileName
        return $This.targetPath;
    }
    
    [bool] targetFolderExists() {
        if (Test-Path $This.getTargetDirectory()) {
            return $true;
        }
        else {
            return $false; 
        }
    }

    createFolder() {
        if ($This.targetFolderExists()) {

        }
        else {
            New-Item -ItemType Directory -Path $This.targetDirectory;
        }
    }

    [void] copyObject() {
        if ($This.testObjectPath()) {
            $This.createFolder();
            Copy-Item -Path $This.originPath -Destination $This.targetPath;
            $This.dumpState();
        }
        else {
            $This.finalState = $false;
            $This.dumpState();
            throw $This.Messages[1]; 
        }
    }
    [string] getHash (){
        if ($this.testObjectPath()) {
            return $This.hash = Get-FileHash -Path $This.originPath -Algorithm SHA1;    
        }else{
            return throw $This.Messages[1]; 
        }
    }

    [void] moveObject() {
        if ($This.testObjectPath()) {
            $This.createFolder();
            Move-Item -Path $This.originPath -Destination $This.targetPath;    
            $This.dumpState();
        }
        else {
            $This.finalState = $false;
            $This.dumpState();
            throw $This.Messages[1];
        }
    }

    [void] dumpState() {
        $This | ConvertTo-Csv >> ObjectAnalyzertest.csv -NoTypeInformation -ErrorAction SilentlyContinue
    }

    [string] toString () {
        if ($This.originPath.Equals("Default")) {
            return $This.Messages[1];
        }
        else {
            return $This.getTargetPath(); 
        }
    }
}

class ObjectCollector {
    [String]$sourceDirectory; #The path to the directory that we will be going through looking for filenames
    [array]$ObjectPaths; #This is an array holding the paths to files that were found. This is returned in some methods.
    hidden [array]$Messages;

    ObjectCollector() {
        $This.sourceDirectory = "Default" # this class cant be instansiated with arguments
        $This.ObjectPaths = "Default"
        $This.Messages = @("The Path you entered`n Does not appear to be a valid path. Try the`n.setSourceDirectory method again with a valid path",
        "The variable that holds the source diretory path is set to 'Default'`n You will need to use the .setSourceDirectory method to set a source directory");
    }
    #this is how you set the path to the rooth directory, You must pass in a string path, it will be checked!
    [void] setSourceDirectory([string]$newPath) { 
        if (Test-Path -Path $newPath) {
            $This.sourceDirectory = $newPath;
        }
        else {throw $this.Messages[0]}
    }
    [void] resetObject() {
        $This.sourceDirectory = "Default"
        $This.ObjectPaths = "Default"
    }
    #returns a string array containing 
    [array] getObjectsFlat () {
        if ($This.sourceDirectory.Equals("Default")) {
            Throw $This.Messages[1];
        }
        else {
            $This.ObjectPaths = Get-ChildItem -Path $This.sourceDirectory | Select-Object FullName
            return $This.ObjectPaths;
        }
    }

    [array] getObjectsRecurse () {
        if ($This.sourceDirectory.Equals("Default")) {
            Throw $This.Messages[1];
        }
        else {
            $This.ObjectPaths = Get-ChildItem -Path $This.sourceDirectory -Recurse | Select-Object FullName
            return $This.ObjectPaths;
        }
    }

    [string] toString() {
        if ($This.sourceDirectory.Equals("Default")) {
            Throw $This.Messages[1];
        }
        else {
            return $This.sourceDirectory;
        }
    }
}

Clear-Host

[objectAnalyzer]$test = [objectAnalyzer]::new();
$test.setObjectPath("E:\Users\joshp\Pictures\2017\10-2017\10-12-2017\IMG_20171012_165945.dng", "C:\test\testdest", "created")
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

$test.setObjectPath("E:\Users\joshp\Pictures\2017\10-2017\10-12-2017\IMG_20171012_165945.dng", "C:\test\testdest", "created")
$test.ToString();

write-host "`nThis is the directory that the item will be sent to: " $test.gettargetDirectory() -ForegroundColor Gray
write-host "This is the path that the item will be sent to: " $test.getTargetPath() -ForegroundColor Gray
write-host "Does the target folder exist " $test.targetFolderExists()  -ForegroundColor Gray
Write-Host "Can the target folder be written to: " $test.testDestinationPath() -ForegroundColor Gray
Write-Host "When this test is on, it created the path: " $test.createfolder() -ForegroundColor Gray
Write-Host "Does the Object path Exist(can the file be found)   "$test.testObjectPath() "`n" -ForegroundColor Gray

$test.copyObject();
$test | Out-GridView;

Write-Host "Instansiating Object Collector"
[ObjectCollector]$testCollector = [ObjectCollector]::new();
Write-Host "Setting Source Directory"
$testCollector.setSourceDirectory("E:\Users\joshp\Documents");
Write-Host "Testing toString Method"
$testCollector.toString();

$arraycoll = $testCollector.getObjectsFlat();
$arraycoll | Get-Member
$arraycoll = $testCollector.getObjectsRecurse();
$arraycoll | Get-Member