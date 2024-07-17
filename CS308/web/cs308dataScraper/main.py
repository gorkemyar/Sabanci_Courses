import os
from time import sleep

import requests

import getImg
from getProduct import getProduct

categoryURL = "https://www.vivense.com/calisma-masalari.html?ref=menu_text"
fileName = "Study Desk 9-44.json"
category_id = 9
subcategory_id = 44
model = "Living Room"
number = "Corner Chairs"
import json
from bs4 import BeautifulSoup

r = requests.get(categoryURL)
result = r.text
soup = BeautifulSoup(result, "lxml")
product_list = soup.find_all(class_="product-card product-content parent")
data_file = open(fileName, "a", encoding="UTF-8")

productId = 0
imageFolder = str(category_id) + "-" + str(subcategory_id)

try:
    os.mkdir(str(imageFolder))
except OSError as error:
    print(error)
for i in product_list:
    product_name = i.find(class_="product-name").get_text()
    productUrl = "https://www.vivense.com/" + i.find(class_="product-link").findChild(class_="product-link").attrs["href"]
    try:
        getProduct(productUrl, fileName, category_id, subcategory_id, model, number)
    except Exception as e:
        print(e)
        continue
    sleep(0.1)
    getImg.getImg(productUrl, productId, imageFolder)
    print(product_name)
    productId += 1
    if productId == 30:
        break
    """
    product_name = i.attrs["data-product-name"]
    price = i.attrs["data-product-price"]
    image = i.find(class_="product_img").findChild().attrs["data-main-img"]
    data = {'productName': product_name, "price": price, "image": image}
    json.dump(data, data_file, ensure_ascii=False)
    data_file.write(",\n")
    """
