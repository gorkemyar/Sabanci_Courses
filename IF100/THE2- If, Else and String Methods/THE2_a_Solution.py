previousTerm=input("Please enter the courses you have taken previously with letter grades: ").upper()
if previousTerm.count(":")==previousTerm.count(";")+1:
  previousTerm=";"+previousTerm
  currentTerm=input("Please enter the courses you have taken this semester with letter grades: ").upper()
  if currentTerm.count(":")==currentTerm.count(";")+1:
    course=input("Please enter the course you want to check: ").upper()
    course=";"+course
    currentTerm=";"+currentTerm
    if course in currentTerm:
      courseIdx=currentTerm.index(course)
      semicolonIdx=currentTerm.find(";",courseIdx+len(course))
      if semicolonIdx==-1:
        semicolonIdx=len(currentTerm)                      
      letterGrade=currentTerm[courseIdx+len(course)+1:semicolonIdx]
      if letterGrade=="F":
        if course in previousTerm:
          temp=previousTerm.index(course)+len(course)+1
          if previousTerm[temp]=="U":
            print("Your grade for", course[1:] ,"is U.")
          else:
            print("Your grade for", course[1:] ,"is F.")
        else:
          print("Your grade for", course[1:] ,"is U.")
      else:
        print("You can choose between S and ", letterGrade," for ",course[1:],".", sep="")
    else:
      print("You didn't take",course[1:] ,"this semester.")
  else:
    print("Invalid input")
else:
  print("Invalid input")
