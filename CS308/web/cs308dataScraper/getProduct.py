import requests
import random

import json
from bs4 import BeautifulSoup

def getProduct(url, fileName, category, subCategory, model, number):
    r = requests.get(url)
    result = r.text
    soup = BeautifulSoup(result, "lxml")

    title = soup.find(class_="product-title").text
    stock = random.randint(0, 10)
    price = int(soup.find(class_="price new-price").attrs["data-value"])
    description = ""
    warrantyStatus = str(random.randint(1, 5)) + "year(s)"
    distributor = "Voidture Inc."
    description += description + "Warranty Status: " + warrantyStatus
    for i in soup.find(class_="desctab").findAll(name="tr"):
        description += ": ".join([j.text for j in i])
        description += " "

    data_file = open(fileName, "a", encoding="UTF-8")

    data = {'title': title,  "description": description, "distributor": distributor, "stock": stock, "price": price, "model": model, "number": number,  "category_id": category, "subcategory_id": subCategory}
    json.dump(data, data_file, ensure_ascii=False)
    data_file.write(",\n")
