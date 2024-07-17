movieStr=input("Please enter movie names and remaining quota: ").lower()
userDemand=input("Please enter the movie you want to watch: ").lower()
fullList=movieStr.replace(",",":").split(":")
genreList=[]
movieList=[]
chairList=[]
idx1=0
for idx in range(len(fullList[0::3])):
  movie=fullList[idx1]
  if movie in movieList:
    idx=movieList.index(movie)
    chairList[idx]+=int(fullList[idx1+1])
  else:
    movieList.append(movie)
    chairList.append(int(fullList[idx1+1]))
    genreList.append(fullList[idx1+2])
  idx1+=3
if userDemand in movieList:
  count=int(input("Please enter the number of tickets you want to buy: "))
  idxUser=movieList.index(userDemand)
  chairCount=chairList[idxUser]
  if chairCount>=count:
    print("The reservation is done!")
  else:
    genre=genreList[idxUser]
    for x in range(len(genreList)):
      if genreList[x]!=genre:
        chairList[x]=-10000
    if max(chairList)>=count:
      print("There are not enough seats for ",userDemand ,"! But you can watch one of the following movies from the genre ",genreList[idxUser] ,":",sep="")
      lastList=[]
      for num in range(len(chairList)):
        if chairList[num]>=count:
          lastList.append(movieList[num])
      length=len(lastList)
      for x in range(length):
        print("*",min(lastList))
        lastList.remove(min(lastList))
        
    else:
      print("There are not enough seats for ",userDemand ," and any other movie with the genre ", genreList[idxUser],"!",sep="")
else:
  print("There is no such movie in the theater.")
