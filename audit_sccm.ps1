# Obtient le nom de la machine
$machineName = $env:COMPUTERNAME

# Obtient la configuration réseau de la machine
$networkConfig = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }

# Obtient l'adresse IP de la machine
$ipAddress = $networkConfig.IPAddress

# Obtient le masque de sous-réseau
$subnetMask = $networkConfig.IPSubnet

# Obtient la passerelle par défaut
$gateway = $networkConfig.DefaultIPGateway

# Obtient les adresses DNS
$dnsAddresses = $networkConfig.DNSServerSearchOrder

# Obtient la version de l'OS
$osversion = Get-WmiObject Win32_OperatingSystem | Select-Object Caption

# Obtient la ram 
$ram = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb

# Affiche les résultats
Write-Host "----------------------------------------"
Write-Host "|               Informations Machine               "
Write-Host "----------------------------------------"
Write-Host "|Nom de la machine             : $machineName"
Write-Host "|Systeme d'exploitation        : $($osversion.Caption)"
write-host "|Ram                           : $ram Go"
Write-Host "|Adresse IP                    : $ipAddress"
Write-Host "|Masque de sous-réseau         : $subnetMask"
Write-Host "|Passerelle par défaut         : $gateway"
Write-Host "|Adresses DNS                  : $($dnsAddresses -join ', ')"
Write-Host "----------------------------------------"
Write-Host "########################################"

# Obtient la liste des partitions
$partitions = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

foreach ($partition in $partitions) {
    $cheminFichier = "$($partition.DeviceID)\nosmsondrive.sms"
    $fichierPresent = Test-Path $cheminFichier

    # Calcule le pourcentage d'espace utilisé
    $pourcentageUtilise = ($partition.Size - $partition.FreeSpace) / $partition.Size * 100

    Write-Host "----------------------------------------"
    Write-Host "|           Informations Partition            "
    Write-Host "----------------------------------------"
    Write-Host "|Lettre de la partition   : $($partition.DeviceID)"
    Write-Host "|Espace libre             : $($partition.FreeSpace / 1GB) Go"
    Write-Host "|Espace utilisé           : $($partition.Size - $partition.FreeSpace / 1GB) Go"
    Write-Host "|Pourcentage utilisé      : $($pourcentageUtilise) %"
    Write-Host "|Fichier présent          : $($fichierPresent)"
    Write-Host "----------------------------------------"
    Write-Host "########################################"
}

# Obtient la liste des applications installées
$applications = Get-WmiObject -Class Win32_Product

# Affiche les résultats
Write-Host "----------------------------------------"
Write-Host "|          Applications Installées             "
Write-Host "----------------------------------------"

foreach ($application in $applications) {
    Write-Host "|Nom de l'application : $($application.Name)"
    Write-Host "|Version                    : $($application.Version)"
    Write-Host "----------------------------------------"
}
