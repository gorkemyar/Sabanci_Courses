//Gorkem Yar

#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <sstream>
#include "strutils.h"

using namespace std;

struct reserve{
	string sailorid;
	string boatid;
	string date;
	string sailorname;
	string boatname;
};
struct finalprint{
	string date;
	string sailorname;
	string boatname;
};
void funcreserve(ifstream &reserveinput, vector<reserve> &reservevector){
		string line,word;
		int count=0;
		while (getline(reserveinput,line)){
			if (count!=0){
				istringstream lineinput(line);
				reserve newreserve;
				int position=0;
				while (lineinput>>word){
					position++;
					if (position==1){
						newreserve.sailorid=word;
					}
					else if (position==2){
						newreserve.boatid=word;
					}
					else if (position==3){
						newreserve.date=word;
					}
				}
				reservevector.push_back(newreserve);
			}
			count++;
		}
}
void vectorsort(vector<finalprint> &sort_final){
	for (int i=0;i<sort_final.size();i++){
		for(int k=i+1;k<sort_final.size();k++){
			if(sort_final[i].date>sort_final[k].date){
				finalprint temp=sort_final[i];
				sort_final[i]=sort_final[k];
				sort_final[k]=temp;
			}
			else if(sort_final[i].date==sort_final[k].date){
				if(sort_final[i].sailorname>sort_final[k].sailorname){
					finalprint temp=sort_final[i];
					sort_final[i]=sort_final[k];
					sort_final[k]=temp;
				}
			}
		}
	}
}
void numchecker(double &num){
	if(num==((int)num)){
		num=(int)num;
	}
}


void toprint(vector<finalprint> &sort_final){
	for (int i=0;i<sort_final.size();i++){
		cout<<sort_final[i].date<<" -> "<<sort_final[i].sailorname<<" has reserved "<<sort_final[i].boatname<<endl;
	}
}
int main(){
	string boatfile="Boats.txt",sailorfile="Sailors.txt",reservefile;
	ifstream boatinput,sailorinput,reserveinput;
	cout<<"Enter filename for reservation database: ";
	cin>>reservefile;
	reserveinput.open(reservefile.c_str());
	boatinput.open(boatfile.c_str());
	sailorinput.open(sailorfile.c_str());
	if ((!reserveinput.fail())&&(!sailorinput.fail())&&(!boatinput.fail())){
		vector<reserve> reservevector;
		funcreserve(reserveinput,reservevector);
		string boatline;
		vector<finalprint> sort_final;
		for (int i=0;i<reservevector.size();i++){
			finalprint newitem;
			newitem.date=reservevector[i].date;
			while(getline(boatinput,boatline)){
				istringstream line(boatline);
				string boatid1,boatname1,boatcolor1;
				line>>boatid1>>boatname1>>boatcolor1;
				if (boatid1==reservevector[i].boatid){
					newitem.boatname=boatname1+"("+boatcolor1+")";
					reservevector[i].boatname=boatname1+"("+boatcolor1+")";
				}
			}
			boatinput.clear();
			boatinput.seekg(0);
			string sailorline;
			while (getline(sailorinput,sailorline)){
				if (reservevector[i].sailorid==sailorline.substr(0,sailorline.find("\t"))){
					sailorline=sailorline.substr(sailorline.find("\t")+1);
					istringstream newline(sailorline);
					string name;
					double rating,age;
					newline>>name>>rating>>age;
					numchecker(age);
					numchecker(rating);
					string agestr=tostring(age),ratingstr=tostring(rating);
					newitem.sailorname=name+"("+agestr+","+ratingstr+")";
					reservevector[i].sailorname=name+"("+agestr+","+ratingstr+")";
				}

			}
			sailorinput.clear();
			sailorinput.seekg(0);
			sort_final.push_back(newitem);
		}
		sailorinput.close();
		boatinput.close();
		reserveinput.close();
		vectorsort(sort_final);
		toprint(sort_final);
	}
	else{
		cout<<"Cannot open the files. Exiting..."<<endl;
	}
	return 0;
}