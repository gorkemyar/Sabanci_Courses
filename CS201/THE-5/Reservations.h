#include <iostream>
#include <string>
#include <vector>
#include "date.h"
using namespace std;

class Boat{
	public:
		int boatid() const;
		string boatname() const;
		string boatcolor() const;
        Boat(); //constructor
		Boat(int id, string color, string name);
	private:
		int boatidx;
		string boatnamex;
		string boatcolorx;
};
bool operator == (const Boat & lhs, const Boat & rhs);
class Sailor{
	public:
		int sailorid() const;
		string sailorname() const;
		double sailorrating() const;
		double sailorage() const;
		Sailor(); //constructor
		Sailor(int id, string name, double rating, double age);
	private:
		int sailoridx;
		string sailornamex;
		double sailorratingx;
		double sailoragex;
};
bool operator == (const Sailor & lhs, const Sailor & rhs);
class Reservation{
	public:
		Reservation(Boat boat,Sailor sailor,Date date); //constructor
		Reservation();
		Sailor returnsailor() const;
		Boat returnboat() const;
		Date returndate() const;
		int Print(vector<Reservation> finded);
	private:
		Sailor mysailor;
		Boat myboat;
		Date mydate;
		void numchecker(double&num);
};
class Reservations{
	public:
		Reservation reserve;
		void AddReservation(Boat boat,Sailor sailor, Date date); //add a reservation
		int DeleteReservations(Boat boat); 
		int DeleteReservations(Sailor sailor);
		int DeleteReservations(Boat boat, Sailor sailor, Date date); //Delete a reservation of specific date;
		vector<Reservation> FindReservations(Date date1, Date date2);
		vector<Reservation> FindReservations(Boat boat, Date date);
		vector<Reservation> FindReservations(Sailor sailor, Date date);
		void FindReservations() const;
		vector<Reservation> returnvector();
	private:
		Sailor mysailor;
		Boat myboat;
		Date mydate;
		vector<Reservation> myreservations;
};
