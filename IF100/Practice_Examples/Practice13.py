#unfortunately, I could not find the .txt file. This practice example aims to deepen students' knowledge in reading files and dictionaries 

mifile=open("friendship.txt","r")
linx=mifile.readlines()
mifile.close()
frienddict={}
for lin in linx:
  lin=lin.strip().split("\t")
  if lin[0] in frienddict:
    frienddict[lin[0]].append(lin[1])
  else:
    frienddict[lin[0]]=[lin[1]]
  if lin[1] in frienddict:
    frienddict[lin[1]].append(lin[0])
  else:
    frienddict[lin[1]]=[lin[0]]

id=input("Enter a user id to suggest some friends: ")

if id in frienddict:
  last={}
  for friend in frienddict[id]:
    for second in frienddict[friend]:
      if second!=id: 
        if not second in frienddict[id]:
          if second in last:
            last[second]+=1
          else:
            last[second]=1
        
  if len(last)==0:
    print("There is no friend to suggest")
  else:
    allmax=[]
    tomax=0
    for valuel in last.values():
      if valuel>tomax:
        tomax=valuel
    for keyler,valuelar in last.items():
      if valuelar==tomax:
        allmax.append(int(keyler))
    allmax.sort()
    for suggestion in allmax[:-1]:
      print(suggestion,end=", ")
    print(allmax[-1])
else: 
  print("There is no such user")
