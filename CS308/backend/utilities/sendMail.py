import smtplib
import ssl
import time
import smtplib
from os.path import basename
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import formatdate
COMMASPACE = ', '


def send_mail(send_to, subject, message, files=None):
    assert isinstance(send_to, str)
    assert isinstance(subject, str)
    assert isinstance(message, str)
    assert isinstance(files, list) or files is None
    # https://www.google.com/settings/security/lesssecureapps
    # Go this link and allow less secure apps
    send_to = [send_to]
    port = 465  # For SSL
    smtp_server = "smtp.gmail.com"
    sender_email = "voidture@gmail.com"  # Enter your address
    password = "vysnfnnsodlchrnw"
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
        server.login(sender_email, password)

        msg = MIMEMultipart()
        msg['From'] = sender_email
        msg['To'] = COMMASPACE.join(send_to)
        msg['Date'] = formatdate(localtime=True)
        msg['Subject'] = subject

        msg.attach(MIMEText(message))

        for f in files or []:
            with open(f, "rb") as fil:
                part = MIMEApplication(
                    fil.read(),
                    Name=basename(f)
                )
            # After the file is closed
            part['Content-Disposition'] = 'attachment; filename="%s"' % basename(
                f)
            msg.attach(part)

        server.sendmail(sender_email, send_to, msg.as_string())


