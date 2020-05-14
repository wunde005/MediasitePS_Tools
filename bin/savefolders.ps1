#function savefolders{
<#
.SYNOPSIS
    reads folder list from mediasite server and outputs it as an object or saves it to a file.
.DESCRIPTION
    Reads folder list from mediasite server.  
    If no rootfolderid is specified it will find the root of the server and start from there.
    If the "-filename" isn't specified it will output a object with folder name, it's id and all sub folders
    If a file is specifed it will save the folder structure to a json file
    quiet will supress output
#>

param([string]$filename,
      [string]$rootfolderid,
      [switch]$quiet,
      [switch]$readmediasiteusers)

if (-not (get-module  | Where-Object { $_.name -like "mediasiteps"})){
    Write-Warning "module mediasiteps not loaded.  Please load before running. https://github.com/wunde005/MediasitePS"
    throw "module mediasiteps not loaded"
}
     

. $PSScriptRoot\foldertools.ps1




$usingHome = $false
#get mediasite root folder id 
if([string]::IsNullOrEmpty($rootfolderid)){
    write-host "No root id specified. Using mediasite root folder"
    $usingHome = $true
    $rootfolder = Home #mrestget("Home")
    $rootfolderid = $rootfolder.RootFolderId
    $rootfoldername = $rootfolder.SiteName
    $ParentFolderId = ""
}
#get info on specified folder id
else{
    try{
        $rootfolder = Folders -s -id $rootfolderid
        #$rootfolder = mrestget("Folders('$($rootfolderid)')")
    }
    catch{
        if($psitem.ErrorDetails -match "The resource could not be found."){
            write-host "folder not found for id:$rootfolderid"
        }
        else{
            Write-host $PSItem.ToString()
        }
        return
    }
    $ParentFolderId = $rootfolder.ParentFolderId
    $rootfolderid = $rootfolder.Id
    $rootfoldername = $rootfolder.Name
}
if(-NOT $quiet){
    write-host "Root folder: $($rootfoldername) $($rootfolderid)"
}
$a = gfolders -parentid $rootfolderid -parentname $rootfoldername -path $rootfoldername -quiet:$quiet -readmediasiteusers:$readmediasiteusers

$depth = 100
#$depth = 1
#while ($a | convertto-json -depth $depth | select-string -pattern "System.Collections.Hashtable" -list) { $depth++ }
$a.ParentFolderId = $ParentFolderId
if([string]::IsNullOrEmpty($filename)){
    return $a
}
else{        
    ($a | convertto-json -depth $depth) | out-file $filename
}
#}

