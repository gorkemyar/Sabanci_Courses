gb=float(input("Please enter your internet quota (GB): "))
videoView=float(input("Please enter your total video viewing time in minutes: "))
messagesSent=float(input("Please enter the number of messages you send: "))
videoMb=videoView*7.7
messagesKb=messagesSent*1.7
gbLast= gb-(videoMb/1024)-messagesKb/(1024**2)
videoKbsecond= 7.7*1024/60
videoRemaining=gbLast*1024**2/videoKbsecond
print("Your remaining internet quota is", format(gbLast,"0.2f"),"GB(s).")
print("You can watch video for", format(videoRemaining//3600,".0f"), "hour(s),", format((videoRemaining%3600)//60,".0f"), "minute(s) and", format((videoRemaining%60),".2f"),"second(s).")
