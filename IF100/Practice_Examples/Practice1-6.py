#practice-1

speed1=float(input("Please enter the first cars velocity(km/h): "))
speed2=float(input("Please enter the seconds cars velocity(km/h): "))
distance=float(input("Please enter the distance: "))
distance=distance/1000
totalspeed=speed1+speed2
time=distance/totalspeed
print("Initial distance between the vehicles is",format(distance,".2f"),"km(s).")
print("They will meet after", format(time,".2f") ,"hour(s).")

#practice-2

suCredits=int(input("Please enter the SU Credits for the student: "))
if 0<=suCredits<=200:
  ectsCredits=int(input("Please enter the ECTS Credits for the student: "))
  if 0<=ectsCredits<=400:
    sps303=input("Please enter the SPS303 passing situation for the student: ")
    if sps303=="Yes":
      gpa=float(input("Please enter the GPA for the student: "))
      if 0.00<=gpa<=4.00:
        if suCredits>=125 and ectsCredits>=256 and gpa>=2.00:
          print("This student can graduate.")
        else:
          print("This student cannot graduate.")
      else:
        print("Incorrect GPA!") 
    else:
      print("Incorrect SPS303 passing situation!")
  else:
    print("Incorrect ECTS Credits!")
else:
  print("Incorrect SU Credits!")
  
#practice-3

name=input("Please enter your name: ").capitalize()
segment=input(name+", please enter the segment of the vehicle: ").lower()
segmentList=["economic","comfort","prestige","premium","luxury"]
segmentValue=[250,400,600,750,1150]
day=int(input(name+", please enter the number of rental days: ").lower())
gear=input(name+", please enter the gear type: ").lower()
gearList=["automatic","manual"]
gearValue=[150,50]
fuel=input(name+", please enter the fuel type: ").lower()
fuelList=["petrol","diesel"]
fuelValue=[100,200]
if segment in segmentList:
  s_value=segmentValue[segmentList.index(segment)]
if day>0:
  d_value=day
if gear in gearList:
  g_value=gearValue[gearList.index(gear)]
if fuel in fuelList:
  f_value=fuelValue[fuelList.index(fuel)]
if str(s_value).isdigit() and str(d_value).isdigit() and str(g_value).isdigit() and str(f_value).isdigit():
  total=d_value*(s_value+g_value+f_value)
  print(name, total ,"TL is charged for your vehicle rental.")

if not segment in segmentList:
  print("Incorrect vehicle segment!")
if day<0:
  print("Incorrect number of rental days!")
if not gear in gearList:
  print("Incorrect gear type!")
if not fuel in fuelList:
  print("Incorrect fuel type!")

#practice-4

myList = [16, 1, 10, 31, 15, 11, 47, 23, 47, 3, 29, 23, 44, 27, 10, 14, 17, 15, 1, 38,\
          7, 7, 25, 1, 8, 15, 16, 20, 12, 14, 6, 10, 39, 42, 33, 26, 30, 27, 25, 13, 11,\
          26, 39, 19, 15, 21, 22, 13, 3, 29, 6, 26, 48, 3, 1, 8, 46, 1, 17, 48, 29, 32, 17, \
          43, 9, 50, 49, 2, 40, 24, 32, 38, 1, 5, 41, 37, 31, 39, 36, 14, 22, 9, 44, 26, 7, \
          17, 18, 28, 45, 20, 35, 38, 23, 31, 32, 26, 29, 41, 42, 13, 33, 27, 15, 38, 11, 9, \
          20, 23, 23, 12, 18, 45, 4, 1, 13, 36, 49, 9, 32, 29, 35, 17, 13, 10, 10, 40, 9, 26,\
          12, 39, 43, 34, 49, 33, 11, 38, 11, 48, 30, 38, 48, 7, 44, 2, 32, 3, 7, 23, 16, 46]
startIdx=int(input("Please enter starting index: "))
if 0<=startIdx<len(myList):
  stopIdx=int(input("Please enter stopping index: "))
  if startIdx<=stopIdx<len(myList):
    step=int(input("Please enter step size: "))
    if step>0 and step<=(stopIdx-startIdx):
      print("The values between indices ", startIdx, " and ", stopIdx, " that are ", step, " apart from each other are ",myList[startIdx:stopIdx:step],".",sep="")
    else:
      print("Invalid step size!")
  else:
    print("Invalid stopping index!")
else:
  print("Invalid starting index!")

 #practice-5

stopNum=input("Please enter the stop number: ")
if stopNum.isdigit():
  stopNum=int(stopNum)
  num1=input("Please enter the first multiple: ")
  num2=input("Please enter the second multiple: ")
  if num1.isdigit() and num2.isdigit():
    num1=int(num1)
    num2=int(num2)
    if 1<=num1 and 1<=num2:
      if num1!=num2:
        top1=0
        top2=0
        top3=0
      else:
        print("Multipliers cannot be equal to each other!") 
        for x in range(stopNum):
          if x%num1==0:
            top1+=x
          if x%num2==0:
            top2+=x
          if x%num1==0 and x%num2==0:
            top3+=x
        total=top1+top2-top3
        print("Sum of all multiples of ",  num1, " or ", num2, " below ", stopNum, " is ", total,".", sep="")
  elif num1[0]=="-" and num2[0]=="-":
    if num1[1:].isdigit() and num2[1:].isdigit():
      print("Multipliers cannot be less than 1!")
    else:
      print("Multipliers must be integers!") 
  else:
    print("Multipliers must be integers!")
elif stopNum[0]=="-":
  if stopNum[1:].isdigit():
    print("Stop number cannot be less than 1!")   
  else:
    print("Stop number must be an integer!")
else:
  print("Stop number must be an integer!")
  
#practice-6

print("Welcome to the New Year's night fun(!)")
ma=input("Please enter the Tombala card for Grandma: ")
me=input("Please enter the Tombala card for You: ")
total=input("Please enter the numbers drawn in the order: ")
maList=ma.split("-")
meList=me.split("-")
totalList=total.split("-")
for item in totalList:
  print("Number", item, "is drawn.", end=" ")
  if item in maList:
    print("Grandma has it.",end=" ")
    maList.remove(item)
  if item in meList:
    print("You have it.",end=" ")
    meList.remove(item)
  print()
  if len(maList)==0 and len(meList)==0:
    print("Grandma and You finish at the same round. It's a tie!")
    break
  elif len(maList)==0:
    print("Grandma wins.")
    newList=[]
    for item in meList:
      item=int(item)
      newList.append(item)
    newList=sorted(newList)
    last=str(newList[0])
    for item in newList[1:]:
      last+="-"+str(item)
      
    print("Remaining numbers of You:",last)
    break
  elif len(meList)==0:
    newList=[]
    for item in maList:
      item=int(item)
      newList.append(item)
    newList=sorted(newList)
    last=str(newList[0])
    for item in newList[1:]:
      last+="-"+str(item)
    print("Remaining numbers of Grandma:",last)
    break
