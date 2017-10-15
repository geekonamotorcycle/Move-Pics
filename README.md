```
***********************************************
***Copyright 2017, Joshua Porrata**************
***This program is not free for business use***
***Contact me at localbeautytampabay@gmail.com*
***for a cheap business license****************
***Donations are wholeheartedly accepted ******
***accepted @ www.paypal.me/lbtpa**************
***********************************************

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
```
