Add-Type -AssemblyName System.Windows.Forms
$File = New-Object System.Windows.Forms.OpenFileDialog
$File.Title = "Choisissez un fichier à envoyer"
$null = $File.ShowDialog()
$Path = $File.FileName

$EmailFrom = "picoduckyraspberry@gmail.com"
$EmailTo = "clement14bs@icloud.com"
$Subject = "Fichier envoyé via PowerShell"
$Body = "Voici le fichier demandé."
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587
$Password = "derr olzd bjte tupv"

$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo, $Subject, $Body
$Attachment = New-Object System.Net.Mail.Attachment $Path
$Message.Attachments.Add($Attachment)

$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
$SMTP.EnableSsl = $true
$SMTP.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $Password)
$SMTP.Send($Message)
