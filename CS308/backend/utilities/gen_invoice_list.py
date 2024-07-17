import bs4
import json
import uuid


def trChar(text):
    tr_chars = ["ç", "ğ", "ı", "ö", "ü", "ş", "Ç", "Ğ", "İ", "Ö", "Ş", "Ü"]
    en_chars = ["c", "g", "i", "o", "u", "s", "C", "G", "I", "O", "S", "U"]
    for i in text:
        if i in tr_chars:
            text = text.replace(i, en_chars[tr_chars.index(i)])
    return text


def get_file_dir(username, fileType):
    return "./media/invoices/" + fileType + "/" + username + "." + fileType


def gen_invoice_list(orders_json, username):
    """Modify the invoice html file to include the invoice data"""

  
    # load the file
    with open("./assets/file.html") as inf:
        txt = inf.read()
        soup = bs4.BeautifulSoup(txt, "html.parser")
        invoice = soup.find(class_="invoice")
        pi = invoice.find(id="personal_info")

        t = soup.new_tag("p")
        t.string = "personal_name"
        pi.append(t)
        t = soup.new_tag("p")
        t.string = "phone_number"
        pi.append(t)

        t = soup.new_tag("p")
        t.string = "full_address"
        pi.append(t)

        t = soup.new_tag("p")
        t.string = ("postal_code"
            + " "
            + "province"
            + " "
            +"city"
            + " "
            + "country"
        )
        pi.append(t)

        t = soup.new_tag("p")

        t.string = "09-05-2022"
        pi.append(t)
        invoice_items = invoice.find(class_="invoice-items").find("tbody")
        total_price = 0
        for order in orders_json["data"]:
            product = order["order_details"][0]["product"]
            quantity = order["order_details"][0]["quantity"]
            price = order["order_details"][0]["price"]
            title = trChar(product["title"])
            photo = None
            if len(product["photos"]) != 0:
                photo = product["photos"][0]["photo_url"]
            subtotal = quantity * price
            total_price += subtotal
            new_tag = soup.new_tag("tr")

            if photo:
                t1 = soup.new_tag("td")
                img = soup.new_tag("img")
                img["src"] = photo
                img["width"] = "100"
                t1.append(img)
                new_tag.append(t1)

            t = soup.new_tag("td")
            t.string = title
            new_tag.append(t)

            k = soup.new_tag("td", class_="alignright")
            k.string = (
                str(quantity) + " x " + str(price) + "$" + " = " + str(subtotal) + "$"
            )
            new_tag.append(k)
            invoice_items.append(new_tag)

        new_tag = soup.new_tag("tr", class_="total")
        t1 = soup.new_tag("td", class_="alignright")
        t1.string = "Total Revenue" + " = " + str(total_price) + "$"
        t1["width"] = "80%"
        new_tag.append(t1)

        invoice.append(new_tag)

    # save the file again
    with open(get_file_dir(username, "html"), "w", encoding="utf-8") as outf:
        outf.write(str(soup))

    return_url = get_file_dir(username, "html")
    return return_url