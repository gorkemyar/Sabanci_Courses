// Gorkem Yar

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>

using namespace std;

int main(){
	cout<<"Hello and welcome to the Hogwarts house sorting hat program!"<<endl;
	cout<<"When I call your name, you'll come forth, I shall place the sorting hat on your head, and you will be sorted into your houses."<<endl;
	cout<<"Enter the name of the key file: ";
	string keyname="answerKey.txt";
	cin>>keyname;
	ifstream keyinput;
	keyinput.open(keyname.c_str());
	while (keyinput.fail()){
		cout<<"Error: Cannot open file "<<keyname<<endl;
		cout<<"Enter the name of the key file: ";
		cin>>keyname;
		keyinput.open(keyname.c_str());
	}
	cout<<"Enter the name of the answer file: ";
	string answername="answers2.txt";
	cin>>answername;
	ifstream answerinput;
	answerinput.open(answername.c_str());
	while (answerinput.fail()){
		cout<<"Error: Cannot open file "<<answername<<endl;
		cout<<"Enter the name of the answer file: ";
		cin>>answername;
		answerinput.open(answername.c_str());
	}
	string lines;
	while (getline(answerinput,lines)){
		if ((lines!="\r")&&(lines!="")){
			istringstream studentline(lines);
			string characteristic;
			int count=0, studentsum=0;
			string name="";
			while (studentline>>characteristic){
				count++;
				if ((count==1)||(count==2)){
					name+=characteristic+" ";
				}
				else{
					string keyline;
					int answercountline=0;
					while (getline(keyinput,keyline)){
						answercountline++;
						if (answercountline==count-2){
							istringstream keyinput(keyline);
							int positioncount=1;
							string key;
							while (keyinput>>key)
							{
								if (key==characteristic){
									studentsum+=positioncount;
								}
								positioncount++;
							}	
						}
					}
					keyinput.clear();
					keyinput.seekg(0);	
				}
			}
			string firstname= name.substr(0,name.find(" "));
			name=name.substr(0,name.length()-1);
			string temp;
			if (studentsum<10){
				temp="Hufflepuff";
			}
			else if ((10<=studentsum)&&(studentsum<15)){
				temp="Ravenclaw";
			}
			else if ((15<=studentsum)&&(studentsum<21)){
				temp="Gryffindor";
			}
			else if (21<=studentsum){
				temp="Slytherin";
			}
			cout<<"Oh! we have "<<name <<" under the sorting hat. "<<firstname<<", you scored "<<studentsum<<" points, you are a "<<temp<<"!"<<endl;
		}
	}
	keyinput.close();
	answerinput.close();
	return 0;
}