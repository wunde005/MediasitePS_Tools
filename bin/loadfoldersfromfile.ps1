param(
  [parameter(Mandatory=$true)]
  [string]$filename
  )

if (-not (get-module  | Where-Object { $_.name -like "mediasiteps"})){
  Write-Warning "module mediasiteps not loaded.  Please load before running. https://github.com/wunde005/MediasitePS"
  throw "module mediasiteps not loaded"
}
 
. $PSScriptRoot\foldertools.ps1
#load folder from file
#function loadfoldersfromfile{
<#
.SYNOPSIS
    Reads folder list from json file and recreates it on the mediasite server.
.DESCRIPTION
    Reads folder list from a json file.
    Uses "ParentFolderId" from json file to specify starting folder on mediasite server.  Empty value means mediasite root folder.
    The "id" value for the folders in json file is only used if an error is thrown on creation to see if the folder is in the recycle bin.
#>
  $folderstructure = (Get-Content $filename | Out-String | ConvertFrom-Json)
  if($folderstructure.parentfolderid -ne ""){
      $res = cfolder -foldername $folderstructure.name -parentfolderid $folderstructure.parentfolderid -id $folderstructure.id
      write-host "$($folderstructure.name)  "
      p2folders -folders $folderstructure.folders -parentfolderid $res.id -path $folderstructure.name
  }
  else{
      p2folders -parentfolderid $folderstructure.id -folders $folderstructure.folders -path $folderstructure.name
  }    
