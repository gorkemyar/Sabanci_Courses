def import_inventory():
  myfile=open("products.txt","r")
  lines=myfile.readlines()
  myfile.close()
  products={}
  for line in lines:
    if "-" in line: 
      little=line.split("-")
      for item in little:
        temp=item.split("_")
        flag=temp[0].lower()
        if flag in products:
          products[flag]+=int(temp[1])
        else:
          products[flag]=int(temp[1])
    else:
      new=line.split("_")
      flag=new[0].lower()
      if flag in products:
        products[flag]+=int(new[1])
      else:
        products[flag]=int(new[1])
  return products

def sell_product(products):
  user=input("Please enter products to sell: ")
  userlist=user.split("-")
  for pro in userlist:
    temp=pro.split("_")
    flag=temp[0].lower()
    if flag in products:
      if products[flag]>= int(temp[1]):
        print(int(temp[1]), flag ,"sold.")
        products[flag]-= int(temp[1])
        if products[flag]==0:
          products.pop(flag)
      else:
        print("There is not enough", flag ,"in inventory.")
    else: 
      print(flag,"does not exist in inventory.")
  
def show_remaining(products):  
  if products!={}:
    big=sorted(products)
    for item in big:
      for key, values in products.items():
        if key==item:
          print(key,":",values) 
  else:
    print("Inventory is empty!")
    
    
products = import_inventory()
decision = ""
while decision != "3":
  print("*---------------------------")
  print("[1] Sell products")
  print("[2] Show remaining inventory")
  print("[3] Terminate")
  products1= import_inventory()
  decision = input("Please enter your decision: ")
  print("____________________________")
  if decision == "1":
    sell_product(products)
  elif decision == "2":
    show_remaining(products)
  elif decision == "3":
    print("Terminating...")
  else:
    print("Invalid input!")
