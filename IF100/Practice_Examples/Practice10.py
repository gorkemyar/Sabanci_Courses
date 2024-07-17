#unfortunately, I could not find the .txt file. This practice example aims to deepen students' knowledge in reading files and dictionaries 

grade={"A":4.00,"A-":3.70,"B+":3.30,"B":3.00,"B-":2.70,"C+":2.30,"C":2.00,"C-":1.70,"D+":1.30,"D":1.00,"F":0.00}
myfile=open("studentGrades.txt","r")
lines=myfile.readlines()
myfile.close()
mydict={}
for line in lines[1:]:
  line=line.strip()
  line=line.split("\t")
  total=0
  for items in line[1:]:
    total+=grade[items]
  gpa=format(total/len(line[1:]),".2f")
  mydict[line[0].strip()]=gpa
print(mydict)
for person in mydict:
  maxi=0.00
  idea=""
  for key,value in mydict.items():
    if float(value) >= maxi:
      if float(value) > maxi:
        maxi=float(value)
        idea=key
      elif float(value) == maxi:
        if key< idea:
          idea=key
  print(idea, maxi)
  mydict[idea]=-1
