//Gorkem Yar

#include <iostream>
#include <string>
using namespace std;
void getInput(string exercise, int &reps,double& minute,double &liftedWeight){
	if (exercise=="Weight Lifting"){
		cout<<exercise<<": ";
		cin>>minute>>reps>>liftedWeight;
	}
	else{
	cout<<exercise<<": ";
	cin>>minute>>reps;
	}


}
bool inputCheck(double weight, double liftedWeight,int reps, double minute)
{
	if (weight<30){
		cout<<"Weight out of range!"<<endl;
		return false;
	}
	else{
		if ((0>=liftedWeight)||(liftedWeight>35)){
			cout<<"Lifted weight out of range!"<<endl;
			return false;
		}
		else{
			if ((0>reps)||(reps>50))
			{
				cout<<"Reps out of range!"<<endl;
				return false;
			}
			else{
				if ((0>minute)||(minute>2000)){
					cout<<"Minute out of range!"<<endl;
					return false;
				}
				else{
					return true;
				}
			}
		}
	}

}
void calculateMET(string exercise, int reps,double & MET){
	if(exercise=="Lunges"){
		if(reps<15){
			MET=3;
		}
		else if(reps<30){
			MET=6.5;
		}
			
		else{
			MET=10.5;
		}
	}
	else if(exercise=="Push-ups"){
		if(reps<15){
			MET=4;
		}
		else{
			MET=7.5;
		}
	}
	else if(exercise=="Pull-ups"){
		if(reps<25){
			MET=5;
		}
		else{
			MET=9;
		}
	}
}
void calculateWeightLiftMET(int reps,double liftedWeight, double & MET){
	if ((liftedWeight<5)&(reps<20)){
		MET=3;
	}
	else if ((liftedWeight<5)&(reps<40)){
		MET=5.5;
	}
	else if ((liftedWeight<5)&(reps>=40)){
		MET=10;
	}
	if ((liftedWeight<15)&(reps<20)){
		MET=4;
	}
	else if ((liftedWeight<15)&(reps<40)){
		MET=7.5;
	}
	else if ((liftedWeight<15)&(reps>=40)){
		MET=12;
	}
	if ((liftedWeight>=15)&(reps<20)){
		MET=5;
	}
	else if ((liftedWeight>=15)&(reps<40)){
		MET=9;
	}
	else if ((liftedWeight>=15)&(reps>=40)){
		MET=13.5;
	}
}
void displayResults(double difference, double total, double weight, double lungeMET, 
					double pushupMET, double pullupMET, double weightliftMET, double lungeCalorie, double pushupCalorie, 
					double pullupCalorie, double weightliftCalorie)
{		
	cout<<"From lunges, you burned "<<lungeCalorie<<" calories."<<endl;
	cout<<"From push ups, you burned "<<pushupCalorie<<" calories."<<endl;
	cout<<"From pull ups, you burned "<<pullupCalorie<<" calories."<<endl;
	cout<<"From weight lifting, you burned "<<weightliftCalorie<<" calories."<<endl;
	cout<<"You burned "<<total<<" calories."<<endl;
	cout<<endl;
	if (difference==0){
		cout<<"Congratulations! You have reached your goal!"<<endl;
	}
	else if (difference<0){
		cout<<"You have surpassed your goal! You can eat something worth "<< difference*-1 <<" calories :)"<<endl;
	}
	
	else{
		double remainlung=difference/((lungeMET*3.5*weight)/200), remainpush=difference/((pushupMET*3.5*weight)/200),
			remainpull=difference/((pullupMET*3.5*weight)/200),remainweight=difference/((weightliftMET*3.5*weight)/200);
		cout<<"You did not reach your goal by "<<difference <<" calories."<<endl;
		cout<<"You need to do lunges "<< remainlung <<" minutes more to reach your goal or,"<<endl;
		cout<<"You need to do push ups "<< remainpush <<" minutes more to reach your goal or,"<<endl;
		cout<<"You need to do pull ups "<< remainpull <<" minutes more to reach your goal or,"<<endl;
		cout<<"You need to do weight lifting "<< remainweight <<" minutes more to reach your goal."<<endl;
	}
}
void computeResults(double weight, double goal, int repsLunge,
					double minLunge, int repsPushUp, double minPushUp,
					int repsPullUp, double minPullUp, int repsWeightLift,
					double minWeightLift, double liftedWeight)
{
	double lungeMET=0,pushupMET=0,pullupMET=0,weightliftMET=0;
	calculateMET("Lunges",repsLunge,lungeMET);
	calculateMET("Push-ups",repsPushUp,pushupMET);
	calculateMET("Pull-ups",repsPullUp,pullupMET);
	calculateWeightLiftMET(repsWeightLift,liftedWeight,weightliftMET);
	double lungeCalorie, pushupCalorie, pullupCalorie, weightliftCalorie;
	lungeCalorie=minLunge*(lungeMET*3.5*weight)/200;
	pushupCalorie=minPushUp*(pushupMET*3.5*weight)/200;
	pullupCalorie=minPullUp*(pullupMET*3.5*weight)/200;
	weightliftCalorie=minWeightLift*(weightliftMET*3.5*weight)/200;
	double total=pushupCalorie+pullupCalorie+lungeCalorie+weightliftCalorie;
	double difference=goal-total;
	
	
	displayResults(difference, total, weight, lungeMET, pushupMET, pullupMET, weightliftMET, lungeCalorie, pushupCalorie, pullupCalorie, weightliftCalorie);
}

int main(){
	double  weight=0, minLunge=0, minPushUp=0,minPullUp=0, minWeightLift=0, liftedWeight=0, goal=0;
	int repsPushUp=0, repsLunge=0, repsPullUp=0,repsWeightLift=0;
	string name;
	cout<<"Please enter your name: ";
	cin>>name;
	cout<<"Welcome "<<name<<", please enter your weight(kg): ";
	cin>>weight;
	cout<<name<<", please enter minutes and repetitions in a week for the activities below."<<endl;
	getInput("Lunges",repsLunge,minLunge,liftedWeight);
	getInput("Push Ups",repsPushUp,minPushUp,liftedWeight);
	getInput("Pull Ups",repsPullUp,minPullUp,liftedWeight);
	cout<<name<<", please enter minutes, repetitions and lifted weight in a week for the activities below."<<endl;
	getInput("Weight Lifting",repsWeightLift,minWeightLift,liftedWeight);
	cout<<name<<", please enter your weekly calorie burn goal: ";
	cin>>goal;

	if (inputCheck(weight,1,repsLunge, minLunge)){
		if (inputCheck(weight,1,repsPushUp, minPushUp)){
			if (inputCheck(weight,1,repsPullUp, minPullUp)){
				if (inputCheck(weight,liftedWeight,repsWeightLift, minWeightLift)){
					computeResults(weight, goal, repsLunge, minLunge,  repsPushUp,
						minPushUp, repsPullUp, minPullUp, repsWeightLift, minWeightLift, liftedWeight);
				}
			}
		}
	}
	return 0;
}
