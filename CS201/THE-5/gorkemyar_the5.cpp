#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include "Reservations.h"
#include "strutils.h"
#include "date.h"

using namespace std;

Date createDate(string date){	
	int year=atoi(date.substr(0,4)), month=atoi(date.substr(5,2)), d=atoi(date.substr(8,2));
	Date day(month, d, year);
	return day;
}
int main(){
	string boatfile="Boats.txt",sailorfile="Sailors.txt",reservefile;
	ifstream boatinput,sailorinput,reserveinput;
	cout<<"Enter filename for reservation database: ";
	cin>>reservefile;
	//reservefile="Reservations2.txt";
	reserveinput.open(reservefile.c_str());
	boatinput.open(boatfile.c_str());
	sailorinput.open(sailorfile.c_str());
	if ((!reserveinput.fail())&&(!sailorinput.fail())&&(!boatinput.fail())){
		//  boat generation of vector
		vector<Boat> boatvector;
		vector<Sailor> sailorvector;
		string boatline, sailorline, reserveline;
		getline(boatinput,boatline);
		getline(sailorinput,sailorline);
		while (getline(boatinput,boatline)){
			istringstream streamboatline(boatline);
			int boatidx;
			string boatnamex, boatcolorx;
			streamboatline>>boatidx>>boatnamex>>boatcolorx;
			Boat boat1(boatidx,boatcolorx, boatnamex);
			boatvector.push_back(boat1);

		}
		boatinput.clear();
		boatinput.close();
		// sailor generation of vector
		while (getline(sailorinput,sailorline)){
			istringstream streamsailorline(sailorline);
			int sailoridy;
			string sailornamey;
			double sailoragey,sailorratingy;
			streamsailorline>>sailoridy>>sailornamey>>sailorratingy>>sailoragey;
			Sailor sailor1(sailoridy, sailornamey, sailorratingy, sailoragey);
			sailorvector.push_back(sailor1);
		}
		sailorinput.clear();
		sailorinput.close();
		Reservations reserve1;
		while (getline(reserveinput,reserveline)){
			istringstream streamreserveline(reserveline);
			int boatid, sailorid;
			string mode, date1, date2;
			streamreserveline>>mode>>sailorid>>boatid>>date1;

			Date newday1=createDate(date1), newday2;
			if (streamreserveline>>date2){
				newday2=createDate(date2);
			}
			streamreserveline.clear();
			Boat boattemp;
			Sailor sailortemp;
			for (int i=0; i<boatvector.size();i++){
				if (boatvector[i].boatid()==boatid){
					boattemp=boatvector[i];
				}
			}
			for (int j=0; j<sailorvector.size();j++){
				if (sailorvector[j].sailorid()==sailorid){
					sailortemp=sailorvector[j];
				}
			}
			
			if (mode=="A"){
				reserve1.AddReservation(boattemp,sailortemp,newday1);
			}
			else if (mode=="D"){
				Sailor lasttemp;
				Boat lasttemp1;
				int count=0;
			
				if ((lasttemp1==boattemp)&&(date1=="0000-00-00")){
					count=reserve1.DeleteReservations(sailortemp);
					if (count==0){
						cout<<"Error: Could not delete reservation for sailor id "<<sailorid<<endl;
						cout<<endl;
					}
				}
				else if ((lasttemp==sailortemp)&&(date1=="0000-00-00")){
					count=reserve1.DeleteReservations(boattemp);
					if (count==0){
						cout<<"Error: Could not delete reservation for boat id "<<boattemp.boatid()<<endl;
						cout<<endl;
					}
				}
				else {
					count=reserve1.DeleteReservations(boattemp,sailortemp,newday1);
					if (count==0){
						cout<<"Error: Could not delete reservation \""<<sailortemp.sailorid()<<" "<<boattemp.boatid()<<" "<<date1<<"\""<<endl;
						cout<<endl;
					}
				}
			}
			else if (mode=="F"){
				Sailor lastemp;
				Boat lastemp1;
				Date today;
				vector<Reservation> toprint;
				if (newday2!=today){
					toprint=reserve1.FindReservations(newday1,newday2);
					cout<<"Find Results:"<<endl;
					Reservation last;
					int num=last.Print(toprint);
					string min=date1, max=date2;
					if (num==0){
						if (date2<min){
							min=date2;
							max=date1;
						}
						cout<<"Error: No matching reservation found between dates "<<min<<" & "<<max<<endl;
					}

				}
				else if ((lastemp1==boattemp)&&!(lastemp==sailortemp)){
					toprint=reserve1.FindReservations(sailortemp,newday1);
					cout<<"Find Results:"<<endl;
					Reservation last;
					int num=last.Print(toprint);
					if (num==0){
						cout<<"Error: No matching reservation found for sailor id "<<sailortemp.sailorid()<<" on "<<date1<<endl;
					}
				}
				else if (!(lastemp1==boattemp)&&(lastemp==sailortemp)){
					toprint=reserve1.FindReservations(boattemp,newday1);
					cout<<"Find Results:"<<endl;
					Reservation last;
					int num=last.Print(toprint);
					if (num==0){
						cout<<"Error: No matching reservation found for boat id "<<boattemp.boatid()<<" on "<<date1<<endl;
					}
				}
				cout<<endl;

			}
			
		}
		reserveinput.clear();
		reserveinput.close();
	}
	else{
		cout<<"Cannot open the files. Exiting...\n"<<endl;
	}
	return 0;
}



