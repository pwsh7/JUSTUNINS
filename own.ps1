# A basic script for uninstalling app packages in Windows 10/11, including those pre-installed with Windows
#
# Note: If you get an error about the script not being allowed to run, the below command will change the execution polciy temporarily for one session only:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
#
# To execute the script, open a Powershell window to the directory with the script and run the following command using your scripts file name (and don't forget the .\ )


# Release note: Microsoft adds new stupid apps, guess what, baby? WE SENDING THEM TO TRASH!!


#script starts here

Get-AppxPackage | Select Name, PackageFullName | Out-Host


Write-Host "Please create a text file called list.txt, then copy the names of the packages you want to uninstall into it, one per line."
Write-Host "NOTE: Some of the packages listed above are important. Do not uninstall any packages if you're unsure about their function!"
Write-Host ""
Write-Host "Then press any key to continue ..."
Read-Host

if (-not (Test-Path -Path 'list.txt')) {
    Write-Host "Error: list.txt 404 not found. Please create it in the same directory as this script, and add the packages you want to uninstall."
    return
}


$lines = Get-Content -Path 'list.txt'

$notFound = @()


foreach ($line in $lines) {
   
    $line = $line.Trim()


    if (-not [string]::IsNullOrWhiteSpace($line)) {

        $package = Get-AppxPackage | Where-Object { $_.Name -eq $line -or $_.PackageFullName -eq $line }
		

        if ($package) {

            try {
                $package | Remove-AppxPackage -ErrorAction Stop
            } 
            catch {
                Write-Host "Error while trying to uninstall $($line): $_"
                $notFound += $line
            }
        } 
        else {
            $notFound += $line
        }
    }
}


if ($notFound) {
    Write-Host "[!!!] WARNING: The following packages were not found and could not be uninstalled:"
    Write-Host ""

 
    foreach ($package in $notFound) {
        Write-Host "`t$package"
    }
    Write-Host ""
    Write-Host "Please re-check the names to ensure they exactly match a package's 'Name' or 'PackageFullName'."
    Write-Host "(Also check if the Full Name was truncated with '...', and if so try the shorter 'Name' string.)"
    Write-Host ""
}

# script end
