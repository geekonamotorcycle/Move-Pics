function Find-UniqueDates {   
    Param
    (
        #This function is expecting to see a variable come in, the variable shoudl have been created using get-childitem
        #it will organize the creation dates and select just the unique dates and spit them out with the variable $uniquedays
        #if -watchwork is set to true then a gridview will be sent along with infomration on each step of the process as they happen
        #error action is silent so you willl need to change  erroractionpreference if you want to see errors. 
        #Copyright 2017 Joshua Porrata
        #Not for business use without a license
        #if you would like a license or a custom script message me; localbeautytampabay@gmail.com
        #donations are welcomed at www.paypal.me/lbtpa
        [Parameter(Mandatory = $true)]
        $directoryObject,
        [boolean]$watchwork
    )
    $ErrorActionPreference = 'silentlycontinue'
    
    #first, create an object that is just composed of the creation time property
    $creationTimesObject = $directoryObject0.CreationTime
    Write-Host "Selecting files by creation time 1/4" -ForegroundColor Green
    #Second, Create an object using the to short date sting method
    $shortDateString = $creationTimesObject.ToShortDateString()
    Write-Host "Converting to String 2/4" -ForegroundColor Green
    #third, select the unique objects
    $uniqueStrings = $shortDateString | Select-Object -Unique
    Write-Host "Selecting only unique Dates 3/4" -ForegroundColor Green
    #finally, replace the / with - and send the unique dates arrray back to the script
    #from here $uniquedays will get plugged into Create-Folders
    $script:uniquedays = $uniqueStrings.replace('/', '-')
    Write-Host "Creating names compatible with Windows File system 4/4 " -ForegroundColor Green
    $uniquedays | Out-GridView -Title "Unique dates"
    
}

$object = Get-ChildItem -path "C:\unsorte" -Recurse
Find-UniqueDates -directoryObject $object -watchwork $false
$uniquedays | Out-GridView
#$uniquedays 
