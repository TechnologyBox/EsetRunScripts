#Get Storage Key parameter
#param([string]$storagekey)

#Trust NuGet
Set-PackageSource -Name "https://www.powershellgallery.com/api/v2" -Trusted
#Install NuGet
Install-PackageProvider -Name NuGet -Force -MinimumVersion 2.8.5.201
#Install Azure AZ Module
Install-Module -Name Az -AllowClobber
#Enable AZ aliases
Enable-AzureRmAlias

#Set Parameters for storage account/blob/filenames
$storageaccount ="esetcustomerdata"
$containername = "policecpidata"
$ComputerName = Hostname
$TodaysDate = get-date -UFormat "%d-%m-%Y"
$FileName = "ChocoResults-$ComputerName-$TodaysDate.txt"
$blobname = "$FileName"
$filepath = "c:\programdata\$FileName"
$context = New-AzureStorageContext -StorageAccountName $storageaccount -StorageAccountKey $storagekey

#Get Choco data
$ChocoOutput = choco list -localonly
#Get Bitlocker data
$BitLockerOutput = manage-bde -status
#Concatenate
$ChocoOutput + " - " + $BitLockerOutput | Out-File "c:\programdata\$FileName"

#Upload to Azure
Set-AzureStorageBlobContent -context $context -Container $containername -File $filepath -Blob $blobname -Force
