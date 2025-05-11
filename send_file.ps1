Add-Type -AssemblyName System.Windows.Forms
$File = New-Object System.Windows.Forms.OpenFileDialog
$File.Title = "Choisissez un fichier à envoyer"
$null = $File.ShowDialog()
$Path = $File.FileName

$EmailFrom = "tonadresse@gmail.com"
$EmailTo = "destinataire@example.com"
$Subject = "Fichier envoyé via PowerShell"
$Body = "Voici le fichier demandé."
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587
$Password = "ton_mot_de_passe_application"

$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo, $Subject, $Body
$Attachment = New-Object System.Net.Mail.Attachment $Path
$Message.Attachments.Add($Attachment)

$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
$SMTP.EnableSsl = $true
$SMTP.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $Password)
$SMTP.Send($Message)
