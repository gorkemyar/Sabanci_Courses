import utilities.sendMail as sendMail
import reportlab
import pdfkit
import json
import utilities.gen_invoice as gen_invoice
path_wkthmltopdf = b'C:\Program Files\wkhtmltopdf\\bin\wkhtmltopdf.exe'

# Load the json data file
order_example = "example_previous_orders.json"
usermail = "rebahozkoc@sabanciuniv.edu"
username = usermail.split("@")[0]

# Create the invoice pdf
gen_invoice.gen_invoice(order_example, username)

css = 'example.css'
config = pdfkit.configuration(wkhtmltopdf=path_wkthmltopdf)
options = {'enable-local-file-access': True}
pdfkit.from_file(username + "invoice.html", username + "invoice.pdf", css=css, configuration=config, options=options)


files = [username + "invoice.pdf"]
content = "Hello Dear user, \n This is an invoice for your recent purchase. \n Thank you for your business."

sendMail.send_mail(usermail, "Your Invoice from Voidture Inc.", content, files)
