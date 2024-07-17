previousTerm=input("Please enter the courses you have taken previously with letter grades: ").upper()
if previousTerm.count(":")==previousTerm.count(";")+1:
  currentTerm=input("Please enter the courses you have taken this semester with letter grades: ").upper()
  if currentTerm.count(":")==currentTerm.count(";")+1:
    course=input("Please enter the course you want to check: ").upper()
    currentTerm=currentTerm.replace(";","!")
    currentTerm=currentTerm.replace(":","!")
    mylist=currentTerm.split("!")
    if course in mylist:
      courseIdx=mylist.index(course)
      letterGrade=mylist[courseIdx+1]
      if letterGrade=="F":
        previousTerm=previousTerm.replace(";","!")
        previousTerm=previousTerm.replace(":","!")
        mylist2=previousTerm.split("!")
        if course in mylist2:
          temp=mylist2.index(course)
          if mylist2[temp+1]=="U":
            print("Your grade for", course ,"is U.")
          else:
            print("Your grade for", course ,"is F.")
        else:
          print("Your grade for", course ,"is U.")
      else:
        print("You can choose between S and ", letterGrade," for ",course,".", sep="")
    else:
      print("You didn't take",course,"this semester.")
  else:
    print("Invalid input")
else:
  print("Invalid input")
