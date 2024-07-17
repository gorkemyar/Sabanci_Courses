operator=["+","-","*","/"]
user=input("Please enter an arithmetic operation: ")
while user!="stop":
  flag=True
  for item in operator:
    if item in user:
      flag=False
      ide=user.split(item)
      if ide[0].isdigit() and ide[1].isdigit():
        if item=="+":
         print(user,"=",int(ide[1])+int(ide[0]))
        elif item=="-":
         print(user,"=",int(ide[0])-int(ide[1]))
        elif item=="*":
         print(user,"=",int(ide[1])*int(ide[0]))
        elif item=="/":
         print(user,"=",int(ide[0])/int(ide[1]))
         fl
      else:
        print("Invalid arithmetic operation!") 
  if flag:
    print("Invalid arithmetic operation!")

  user=input("Please enter an arithmetic operation: ")
