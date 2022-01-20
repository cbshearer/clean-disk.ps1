## script to remove files from $growthFolder that are over 15 days old if disk is over 80% in use
$size         = Get-Volume -DriveLetter c
$pctFree      = ($size.SizeRemaining/$size.Size) * 100
$date         = get-date
$outfile      = "c:\temp\DiskReport.csv"
$growthFolder = "c:\temp\XXXXXreportsXXXXX"
$minimumFree  = "20"

$diskreport = new-object PSCustomobject
$diskreport | add-member -memberType NoteProperty -name CurrentDate   -value $date
$diskreport | add-member -memberType NoteProperty -name Size          -value $size.size
$diskreport | add-member -memberType NoteProperty -name SizeRemaining -value $size.SizeRemaining
$diskreport | add-member -memberType NoteProperty -name PercentFree   -value $pctFree

$diskreport | Export-CSV $outfile -Append -NoTypeInformation

if ($pctFree -le $minimumFree) ## if the percentage of disk available is less than or equal to $minimumFree
    {   
        ## display the % free
        Write-Host $pctFree

        ## get all of the sample folders
        $sampleFolders = get-childitem $growthFolder | Where-Object {$_.PSIsContainer}

            foreach ($folder in $samplefolders)
                {
                    ## if the folder matches the naming format and the folder is over 15 days old, then delete it
                    if (($folder.name -like "*-*-*") -and ($folder.lastwritetime -le $date.adddays(-15))) 
                    {
                        Write-Host "Removing:" $folder.name
                        remove-item $folder -Force -Recurse -Confirm:$false

                        ## add another row to disk report
                        $size    = Get-Volume -DriveLetter c
                        $pctFree = ($size.SizeRemaining/$size.Size) * 100
                        $date   = get-date

                        $diskreport = new-object PSCustomobject
                        $diskreport | add-member -memberType NoteProperty -name CurrentDate   -value $date
                        $diskreport | add-member -memberType NoteProperty -name Size          -value $size.size
                        $diskreport | add-member -memberType NoteProperty -name SizeRemaining -value $size.SizeRemaining
                        $diskreport | add-member -memberType NoteProperty -name PercentFree   -value $pctFree

                        $diskreport | Export-CSV $outfile -Append -NoTypeInformation

                    }
                }   
            }
else {Write-Host -f Green "Disk Free is more than" $minimumFree"%"}

## display the disk statistics
    Write-Host "Disk Size :" ([math]::Round(($size.Size /1GB),2)) "GB"
    Write-Host "Disk Free :" ([math]::Round(($size.SizeRemaining /1GB),2)) "GB"
    Write-Host "Disk Free :" ([math]::Round($pctFree,2)) "%"
        
