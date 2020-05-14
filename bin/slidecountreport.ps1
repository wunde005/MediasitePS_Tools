param(
  [int]$days=1,
  [int]$minslides=0,
  [single]$minslidespermin=0
)

if (-not (get-module  | Where-Object { $_.name -like "mediasiteps"})){
   Write-Warning "module mediasiteps not loaded.  Please load before running. https://github.com/wunde005/MediasitePS"
   throw "module mediasiteps not loaded"
}

$fdate = ((get-date ) - (new-timespan -days $days)).tostring("yyyy-MM-dd")
write-host "getting viewable presentations since $fdate"
$presentations = (presentations -all -full -filter "(RecordDate+ge+datetime'$fdate')+and+(Status+eq+'Viewable')")  
$presentations | ForEach-Object { 
   $slidecount = 0
   #$arraycount = ($_.SlideContent()).count
   $duration = $_.duration / 60000
   $ratio = 0
   ($_.SlideContent()) | ForEach-Object { 
	  if($_.StreamType -eq "Slide"){
	     $slidecount = [int]$_.length
	     $ratio = $slidecount / $duration
	  }
	}
   
   $presentation = new-object -typename psobject
   $presentation | Add-Member -MemberType NoteProperty -Name Id -value $_.id
   $presentation | Add-Member -MemberType NoteProperty -Name Title -value $_.title
   $presentation | Add-Member -MemberType NoteProperty -Name SlideCount -value $slidecount
   $presentation | Add-Member -MemberType NoteProperty -Name DurationMin -value $([math]::Round($duration,2))
   $presentation | Add-Member -MemberType NoteProperty -Name SlidesPerMin -value $([math]::Round($ratio,2))
   if($slidecount -ge $minslides -and $ratio -ge $minslidespermin){
      return $presentation
   }
}