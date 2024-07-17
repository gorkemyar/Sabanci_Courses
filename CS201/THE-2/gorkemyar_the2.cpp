// Gorkem Yar

#include <iostream>
#include <string>
#include "strutils.h"
using namespace std;
// check word if it is valid
bool wordchecker(string word){
	int len=word.length();
	ToLower(word);
		for (int i=0; i<len;i++){
			if (('a'>word.at(i))||(word.at(i)>'z'))
			{
				return false;
			}
		}
	return true;
}
// creates dash with the length of the word
void dashcreator(string word, string &dash){
	for (int i=0; i<word.length();i++)
	{
		dash+="-";
	}
}
// checks option and if its wrong gives error message and asks again with while loop
string optionchecker(string name2,string dash){
	string option;
	cout<<name2<<", do you want to guess the word(1) or guess a letter(2)? ";
	cin>>option;
	while ((option!="1")&&(option!="2"))
	{
		cout<<"Invalid option!"<<endl;
		cout<<"The word is: "<<dash<<endl;
		cout<<name2<<", do you want to guess the word(1) or guess a letter(2)? ";
		cin>>option;
	}
	return option;
}
// lettercheck checks the letter whether in the word or not
bool lettercheck(string word, string letter)
{
	for (int i=0; i<word.length();i++)
	{
		if (word.substr(i,1)==letter)
		{
			return true;
		}
	}
	return false;
}

int main(){

	string name1, name2;
	string word;
	cout<<"Welcome to the HANGMAN GAME"<<endl;
	cout<<"---------------------------"<<endl;
	cout<<"Player one, please enter your name: ";
	cin>>name1;
	cout<<"Player two, please enter your name: ";
	cin>>name2;
	cout<<"OK "<<name1<<" and "<<name2<<". Let's start the game!"<<endl;
	cout<<name1<<", please input the word you want "<<name2<<" to guess: ";
	cin>>word;
	ToLower(word);
	while (wordchecker(word)==0)
	{
		cout<<"Invalid word! Try again."<<endl;
		cout<<name1<<", please input the word you want "<<name2<<" to guess: ";
	    cin>>word;
	}
	cout<<name2<<", you have 1 free guess, after that you will lose limbs!"<<endl;
	string dash="";
	dashcreator(word, dash);
	
	string option;
	string secondOptionString="";

	int wrongcount=0;
	while (wrongcount<6)
	{
	   cout<<"The word is: "<<dash<<endl;
	   bool	flag= true; // to know when to we make a wrong guess
	   option = optionchecker(name2,dash);
	   // option 1
	   if (option=="1")
	   {
		   	string guess;
			cout<<"Your guess: ";
			cin>>guess;
			ToLower(guess);
			if (wordchecker(guess)==0)
			{
				cout<<"Invalid entry! Try again."<<endl;
			}
			else
			{
				if (guess==word)
				{
					cout<<"The word is: "<<word<<endl;
					cout<<"Congratulations "<<name2<<", you won!"<<endl;
					cout<<name2<<" won the game!";
					wrongcount=10;
				}
				
				else
				{
					wrongcount++;
					flag=false; // flag become false since we made a wrong guess
				}
			}
	   }
	   // option 2 
	   else
	   {
		   string letter;
		   cout<<"Your guess: ";
		   cin>>letter;
		   ToLower(letter);
		   if ((wordchecker(letter)==0)||(letter.length()!=1))
		   {
			   cout<<"Invalid entry! Try again."<<endl;
		   }
		   else
		   {
			   bool guessEnteredBefore=lettercheck(secondOptionString,letter); //checks the letter whether it exists in entered letter string or not
			   
			   if (guessEnteredBefore==1)
			   {
				   cout<<"Guess entered before! Try again."<<endl;
			   }
			   else
			   {
				   secondOptionString+=letter; // update letter string
				   bool temp=lettercheck(word,letter); //lettercheck looks for whether letter in the word or not
				   if (temp==0)
				   {
					   wrongcount++;
				       flag=false; // since we made a wrong guess  
				   }
				   else 
				   {
					   int len=word.length();
					   int num=0;
					   int idx=word.find(letter,num);
					   while (idx!=string::npos)
					   {
						   dash=dash.substr(0,idx)+word.substr(idx,1)+dash.substr(idx+1,len);
						   num=idx+1;
						   idx=word.find(letter,num);
					   }
					   if (dash==word)
					   {
							cout<<"The word is: "<<word<<endl;
							cout<<"Congratulations "<<name2<<", you won!"<<endl;
							cout<<name2<<" won the game!";
							wrongcount=10;
					   }
				   }
			   }
		   }	   
	   }

	   //flag part
	   if (flag==false){
		   if (wrongcount==1){
			   cout<<"You have no free guess left."<<endl;
		   }
		   else if (wrongcount==2){
			   cout<<"You have lost a leg!"<<endl;
		   }
		   else if (wrongcount==3){
			   cout<<"You have lost a leg!"<<endl;
		   }
		   else if (wrongcount==4){
			   cout<<"You have lost an arm!"<<endl;
		   }
		   else if (wrongcount==5){
			   cout<<"You have lost an arm!"<<endl;
		   }
		   else if (wrongcount==6){
			   cout<<"You have lost a head! GAME OVER!"<<endl;
			   cout<<name2<<" lost the game :(";
		   }
	   }
	}
return 0;
}	