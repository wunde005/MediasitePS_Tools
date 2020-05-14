
if (-not (get-module  | Where-Object { $_.name -like "mediasiteps"})){
  Write-Warning "module mediasiteps not loaded.  Please load before running. https://github.com/wunde005/MediasitePS"
  throw "module mediasiteps not loaded"
}

#Get all folders inside of a folder and return array of the folders and subfolders
#path is just for display purposes 
#quiet suppresses output
function gfolders{ 
  param([string]$parentid,[string]$parentname,[string]$path,[switch]$quiet,[switch]$readmediasiteusers)
  $local:folderarray = @{name=$parentname;id=$parentid;folders=@()}
  $local:folders = Folders -s -all -filter "ParentFolderId+eq+'$parentid'" #mrestfolderfolder($parentid)
  $local:fpath = $path
  #return if no subfolders are found
  if($local:folders.length -eq 0){
      return $local:folderarray 
  }
  #check for subfolders for each folder
  foreach($f in $local:folders){
    #by default skip mediasite users folders
    if(($f.name -ne "Mediasite Users") -or $readmediasiteusers){
      if(-NOT $quiet) {
          write-host "path: $($local:fpath)/$($f.name)"
      }
      $local:folderarray.folders += gfolders -parentid $f.id -parentname $f.name -path "$($fpath)/$($f.name)" -quiet:$quiet -readmediasiteusers:$readmediasiteusers
    }
  }
  return $local:folderarray
}




function p2folders{ 
    param([Object[]]$folders,[string]$parentfolderid,[string]$path)
    
    foreach($f in $folders){
      if($f.name -ne $null){
          $res = cfolder -foldername $f.name -parentfolderid $parentfolderid -id $f.id
          write-host "$($path)\$($f.name)  "# -NoNewline
  
          if($res -ne $null){
              p2folders -folders $f.folders -parentfolderid $res.id -path $($path+"\"+$f.name)
          }     
      }
    }
}
#cfolder: creates folder in parentfolder
#folder id isn't required, but is used to check for folders existance in recycle bin
function cfolder{
    param([string]$foldername,  #name of new folder
          [string]$parentfolderid, #parent folder id
          [string]$id)  #not required, used to check for folders existance in recycle bin
    $feedback = ""
    $local:postdata = @{"Name"=$foldername;"ParentFolderId"=$parentfolderid}
    
    #$fcmd = $(rtnuri)+"Folders"

    try {
        $r = Folders -post -data $local:postdata 
        #$r =  Invoke-RestMethod -Headers $(rtnheader) -uri $fcmd -method post -ContentType 'application/json' -Body $local:postdata
        
    } catch {
        if($_.Exception.Response.StatusCode.value__ -eq 500){
            $feedback += "found existing folder: " 
            $r = Folders -s -full -filter "(ParentFolderId+eq+'$parentfolderid')+and+(Name+eq+'$foldername')"
            #return $r
            #$r = mrestget("Folders?`$select=full&`$filter=(ParentFolderId+eq+'$($parentfolderid)')+and+(Name+eq+'$($foldername)')")
            #if folder is not returned check to see if it is in the recycle bin
            
            
            if(-not $r -and $id){
                #write-host "checking recycle"
                $r = folders -s -id $id
                #$r = mrestget("Folders('$($id)')")
                if($r.recycled){
                    write-host $feedback + "ERROR: Folder named $($foldername) with id $($id) is in recycle bin!: "
                    return #$r
                }
                else{
                    write-host $feedback + "ERROR: Unable to create Folder named $($foldername): " -NoNewline
                    return
                }
            }
            write-host $feedback -NoNewline
            return $r
        }
    }
    write-host $feedback + "Created folder       : " -NoNewline
    return $r
}

