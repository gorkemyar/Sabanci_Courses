option=1
while option!="3":
  print("Please select one of the options below: "," \n","1-Encrypt the text","\n","2-Decrypt the text","\n","3-Exit",sep="")
  option=input("Enter your choice: ")
  if option=="1":
    p=input("Please enter the plaintext: ")
    new=""
    for x in p:
      if "a"<=x<="z": 
        new+=chr(ord("z")-ord(x)+ord("a"))
      elif "A"<=x<="Z": 
        new+=chr(ord("Z")-ord(x)+ord("A"))
      else: 
        new+=x
    print("")
    print("Encryption of ",p,"i s ",new,".",sep="")
  elif option=="2":
    p=input("Please enter the plaintext: ")
    new=""
    for x in p:
      if "a"<=x<="z": 
        new+=chr(ord("z")-ord(x)+ord("a"))
      elif "A"<=x<="Z": 
        new+=chr(ord("Z")-ord(x)+ord("A"))
      else:
        new+=x

    print("")
    print("Decryption of ",p," is ",new,".",sep="")
  elif option=="3" :
    print("")
    print("Bye...")
  else:
    print("")
    print("Invalid input!")
