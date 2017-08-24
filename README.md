#Move-Pics
```
***********************************************
***Copyright 2017, Joshua Porrata**************
***This program is not free for business use***
***Contact me at localbeautytampabay@gmail.com*
***for a cheap business license****************
***Donations are wholeheartedly accepted ******
***accepted @ www.paypal.me/lbtpa**************
***********************************************
```
* What is it actually called?

    The program is now called Organize-Files 

*  What does it do?

    It's duty is to organize files into folders by their creation date. 

*  Why?

    I am a photographer on the side and I will sometimes, after a long day just
    dump a weeks worth of files into a folder to organize later. I use a scheme
    like this to store files

    c:\users\USERNAME\pictures\YEAR\DATEOFPICTURECREATION\FILENAME.DNG
    
    Naturally this is foolish and I wind up with a month of unorganized files.
    This script should organize them according to my scheme.

* What command runs the script? 

    ```.\Organize-Files.ps1```

* What are the defaults?
    1. It will prompt you for the root source path, it will recurse through 
        folders. You can input a permanent Source/Destination, but thats on you.
    2. It will COPY not move files, this can be adjusted using paramaters within 
        The main body of the script. Starting around line 338
    3. It will open an ```out-gridview``` window and dump a CSV in the directory it
        was run in. The CSV will be OVERWRITTEN each time the script runs
    4. It is not in testMode but can be put into testmode. 

* It broke my computer,deleted files, exploded! 
    
    There is no warranty or guarantee that this script will work the way you
    or I think it will. Good Luck.

* Will this run on OSX, Linux, or powershell <Insert verions -ne 5.1>
    
    I have no idea

#Here is what the execution block of the script looks like along with Parameter info.

```powershell
Clear-Host
Copyright
#Readpaths 
#grabs the source and destination root Paths and checks that they 
#exist before Passing them on.
#ReadPaths can be interactive or you can add some parameters here
# -Source will specify a source path Make sure its valid!
# -destination will specify a destination path Make sure its valid!
#Output: $sourcePath - the root of the folder we will be scanning.
#OutPut: $destPath - The root of the folder files will be headed to 
Read-Paths

#Get-objectTable 
#scans a path and gathers the required information.
# -getSourceHash $true will calculate an SHA1 hash for every file
# -scanpath is the path we will be scanning and is mandatory
# -fileTypeFilter is not implimented yet, its there to remind me to impliment it
#Output: $uniquedays - a string array of unique dates in MM-DD-YYYY format
#Output: $directoryObject - an array of data needed for the set-files Function
Get-ObjectTable -ScanPath $sourcePath 

#Set-Paths 
#Firsts takes $uniquedays from Get-ObjectTable and tests if the paths exist if
#They do not exist the function will attampt to create them.
# -TestMode = $true(default) Just runs a test, outputs the unique fodlers
# -destinationPath can be entered manualy or grab from read-paths $destpath
# -uniqueDays should come from Get-ObjectTable $uniquedays
# There is no output, Just action
Set-Paths -destinationpath $destPath -uniqueDays $uniqueDays -testMode $false

#Set-Files
#attempts to copy or move the files 
# -directoryObject Comes from Get-ObjectTable named $directoryObject
# -Testmode($True) No changes are made, but a simulated results table is created
#   Usefule if you want a list to work with manually
# -copyMove($true) $True = Copy; $False = Move
# -showResults ($true) outputs CSV files in the same folder the command is run 
#   from. Also runs out-gridview on the final hoshtables
# There is no output
set-files  -directoryobject $directoryObject -testmode $false -copyMove $true
Copyright
```