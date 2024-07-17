#include "Reservations.h"
Boat::Boat(){
	boatidx=0;
	boatnamex="";
	boatcolorx="";
}
Boat::Boat(int id,string color,string name){
	boatnamex=name;
	boatidx=id;
	boatcolorx=color;
}
int Boat::boatid() const{
	return boatidx;
}
string Boat::boatname() const{
	return boatnamex;
}
string Boat::boatcolor() const{
	return boatcolorx;
}

bool operator == (const Boat & boat1, const Boat & boat2){
	return ((boat1.boatcolor()==boat2.boatcolor())&&(boat1.boatname()==boat2.boatname())&&(boat1.boatid()==boat2.boatid()));
}
Sailor::Sailor(){
	sailoridx=0;
	sailornamex="";
	sailorratingx=0.0;
	sailoragex=0.0;
}
Sailor::Sailor(int id, string name, double rating, double age){
	sailoridx=id;
	sailornamex=name;
	sailoragex=age;
	sailorratingx=rating;
}
int Sailor::sailorid() const{
	return sailoridx;
}
string Sailor::sailorname() const{
	return sailornamex;
}
double Sailor::sailorrating() const{
	return sailorratingx;
}
double Sailor::sailorage() const{
	return sailoragex;
}
bool operator == (const Sailor & sailor1, const Sailor & sailor2){
	return ((sailor1.sailorid()==sailor2.sailorid())&&(sailor1.sailorage()==sailor2.sailorage())&&(sailor1.sailorrating()==sailor2.sailorrating())&&(sailor1.sailorname()==sailor2.sailorname()));
}
Reservation::Reservation(Boat boat,Sailor sailor,Date date){
	myboat=boat;
	mysailor=sailor;
	mydate=date;
}
Reservation::Reservation(){
	Sailor temp1;
	Boat temp2;
	myboat=temp2;
	mysailor=temp1;
	mydate= Date();
}
Boat Reservation::returnboat() const{
	return myboat;
}
Sailor Reservation::returnsailor() const{
	return mysailor;
}
Date Reservation::returndate() const{
	return mydate;
}
void Reservation::numchecker(double &num){
	if(num==((int)num)){
		num=(int)num;
	}
}
int Reservation::Print(vector<Reservation> finded){
	for (int i=0;i<finded.size();i++){
		Reservation temporary=finded[i];
		double rating=temporary.returnsailor().sailorrating(), age=temporary.returnsailor().sailorage();
		numchecker(age);
		numchecker(rating);
		cout<<temporary.returndate().MonthName()<<" "<<temporary.returndate().Day()<<" "<<temporary.returndate().Year()
			<<" -> "<<temporary.returnsailor().sailorname()<<"("<<age<<","<<rating<<") has reserved "
			<<temporary.returnboat().boatname()<<"("<<temporary.returnboat().boatcolor()<<")"<<endl;
	}
	return  finded.size();
}
void Reservations::AddReservation(Boat boat, Sailor sailor, Date date){
	Reservation res1(boat, sailor ,date);
	myreservations.push_back(res1);
	for (int i=0;i<myreservations.size();i++){
		Reservation res2=myreservations[i];
		for (int j=i+1;j<myreservations.size();j++){
			Reservation res3=myreservations[j];
			if ((res2.returndate()>res3.returndate())||((res2.returndate()==res3.returndate())&&(res2.returnsailor().sailorname()>res3.returnsailor().sailorname()))){
				myreservations[i]=res3;
				myreservations[j]=res2;
			}
		}
	}
}
int Reservations::DeleteReservations(Boat boatname){
	int count=0;
	for (int i=0;i<myreservations.size();){
		Reservation temporary =myreservations[i];
		if ( temporary.returnboat()==boatname){
            count++;
			for(int k=i+1; k<myreservations.size();k++){
				myreservations[k-1]=myreservations[k];
			}
			myreservations.pop_back();
		}
		else{
			i++;
		}
	}
	return count;
}
int Reservations::DeleteReservations(Sailor sailorname){
	int count=0;
	for (int i=0;i<myreservations.size();){
		Reservation temporary=myreservations[i];
		if (temporary.returnsailor()==sailorname){
			count++;
			for(int k=i+1; k<myreservations.size();k++){
				myreservations[k-1]=myreservations[k];
			}
			myreservations.pop_back();
		}
		else{
			i++;
		}
	}
	return count;
}
int Reservations::DeleteReservations(Boat boatname, Sailor sailorname, Date date){
	int count=0;
	for (int i=0;i<myreservations.size();){
		Reservation temporary=myreservations[i];
		if ((temporary.returnsailor()==sailorname)&&(temporary.returnboat()==boatname)&&(temporary.returndate()==date)){
			count++;
			for(int k=i+1; k<myreservations.size();k++){
				myreservations[k-1]=myreservations[k];
			}
			myreservations.pop_back();	
		}
		else{
			i++;
		}
	}
	return count;
}
vector<Reservation> Reservations::FindReservations(Date date1, Date date2){
	vector<Reservation> finded;
	if (date1>date2){
		Date a=date1;
		date1=date2;
		date2=a;
	}
	for(int i=0;i<myreservations.size();i++){
		Reservation temp=myreservations[i];
		if ((date1<=temp.returndate())&&(temp.returndate()<=date2)){
			finded.push_back(temp);
		}
	}
	return finded;
}
vector<Reservation> Reservations::FindReservations(Boat boat, Date date){
	vector<Reservation> finded;
	for(int i=0;i<myreservations.size();i++){
		Reservation temp=myreservations[i];
		if ((date==temp.returndate())&&(temp.returnboat()==boat)){
			finded.push_back(temp);
		}
	}
	return finded;
}

vector<Reservation> Reservations::FindReservations(Sailor sailor, Date date){
	vector<Reservation> finded;
	for(int i=0;i<myreservations.size();i++){
		Reservation temp=myreservations[i];
		if ((date==temp.returndate())&&(temp.returnsailor()==sailor)){
			finded.push_back(temp);
		}
	}
	return finded;
}
vector<Reservation> Reservations::returnvector(){
	return myreservations;
}
