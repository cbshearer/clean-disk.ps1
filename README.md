# clean-disk.ps1
Check disk space available and cleanup a known growth folder based on folder last write time and folder name.

## Story time
I sometimes come across files that pile up in a certain location until disk fills up and causes an outage. I created this script to run as a scheduled task to address.

This could be extended to send email or other alerts or to match other patterns.

## Use the script

- Set your variables
  - CSV report destination ($outfile)
  - Growth folder ($growthFolder)
  - Minimum disk free percentage ($minimumFree)
- Report data to $outfile
  - Date
  - Disk size in bytes
  - Disk free in bytes
  - Percent disk free
- Find available disk space and size, calculate the % free.
- If there is less than $minimumFree then evaluate a specifically identified 
  - Get all of the folders within the $growthFolder
  - Identify those older than 15 days that also match the pattern \*\-\*\-\* (for a date format ex 01-02-2022)
  - Delete the olders and their contents recursively
  - Gather disk usage again and report to $outfile
- Display information on screen:
  - Disk size in GB
  - Disk free in GB
  - Disk free in percent