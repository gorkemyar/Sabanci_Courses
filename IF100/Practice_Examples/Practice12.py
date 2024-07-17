#unfortunately, I could not find the .txt file. This practice example aims to deepen students' knowledge in reading files and dictionaries 

hotel=open("hotels.txt","r")
hot=hotel.readlines()
hotel.close()
hoteldict={}
for linear in hot:
  linear=linear.strip().split("\t")
  hoteldict[linear[0]]=linear[1]

review=open("reviews.txt","r")
re=review.readlines()
review.close()
totalpointdict={}
revieverdict={}
userdict={}
for linem in re:
  linem=linem.strip().split("\t")
  if linem[0] in userdict:
    userdict[linem[0]]+=1
  else:
    userdict[linem[0]]=1
  if not hoteldict[linem[1]] in totalpointdict:
    totalpointdict[hoteldict[linem[1]]]=int(linem[2])
    revieverdict[hoteldict[linem[1]]]=1
  else:
    totalpointdict[hoteldict[linem[1]]]+=int(linem[2]) 
    revieverdict[hoteldict[linem[1]]]+=1
for ke,it in totalpointdict.items():
  totalpointdict[ke]=int(it)/int(revieverdict[ke])

m=0
p=""
for k,i in userdict.items():
  if i>m:
    m=i
    p=k
print("The user who posted the most reviews is", p)
u=0
v=""
for a,b in totalpointdict.items():
  if b>u:
    u=b
    v=a
print("The best hotel:",v)
name=input("Please enter a hotel name: ")
while name!="quit":
  if name in totalpointdict:
    print("The average rating of the hotel:",totalpointdict[name])
  else: 
    print("Nobody has rated for this hotel yet.")
  name=input("Please enter a hotel name: ")
