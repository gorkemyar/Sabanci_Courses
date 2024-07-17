#unfortunately, I could not find the .txt file. This practice example aims to deepen students' knowledge in reading files and dictionaries 

f1=open("race_results.txt","r")
mylines=f1.readlines()
f1.close()
racer={}
little={1:10,2:8,3:6,4:5,5:4,6:3,7:2,8:1}
position=0
for myline in mylines:
  myline=myline.strip()
  if myline!="***Race***":
    position+=1
    if position in little:
      point=little[position]
      if myline in racer:
        racer[myline]+=point
      else:
        racer[myline]=point
  else:
    position=0
print("RANK - NAME - POINTS")
i=0
for company in racer:
  i+=1
  maxim=0
  id=""
  for keys,values in racer.items():
    if values >= maxim:
      if values > maxim:
        maxim=values
        id=keys
      elif values == maxim:
        if keys< id:
          id=keys
  print(i,"-",id,"-", maxim)
  racer[id]=-1
