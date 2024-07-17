// Gorkem Yar

#include <iostream>
#include <string>
#include <fstream>
#include "Queue.h"
#include "strutils.h"
using namespace std;

// this function takes all the proccesses and enqueues them at the highest priority.
void start(Queue<char>* & mlfq, const int & q_num, const int& pro_num, fstream *& all_process){
	int i=1;
	string name;
	char ch_name, first;
	for (;i<=pro_num;i++){
		name="PC";
		ch_name='0'+i;
		name+=itoa(i);
		all_process[i-1]>>first; // reads the first character from the file
		mlfq[q_num-1].enqueue(first, name); // enqueues the first character and the process name of the file
	}	
}

int main(){
	cout<<"Please enter the process folder name: ";
	string head;
	cin>>head;
	//head="sample_run_1";
	cout<<"When all processes are completed, you can find execution sequence in \""<<head<<"/output.txt\"."<<endl;
	head+="\\";

	// openining the configuration.txt 
    ifstream con_input;
    string con_filename="configuration.txt";
    con_input.open(head+con_filename.c_str());
    int q_num, pro_num, s_size;
    con_input>>q_num>>pro_num>>s_size;
    con_input.close();
 
	fstream *all_process=new fstream[pro_num]; //creating a dynamic fstream array to store files
	//opens all the files
	char ch;
	int i=0;
	for (;i<pro_num;i++){
		ch='0'+i+1;
		all_process[i].open((head+"p"+itoa(i+1)+".txt").c_str());
	}
	Queue<char>* mlfq=new Queue<char>[q_num]; // creating a dynamic queue list which is our multi-level feedback queue
	

	ofstream output;
	output.open(head.substr(0,head.length()-1)+"\\output.txt"); //creating an output.txt

	// initialization of the processes in the mlfq
	start(mlfq, q_num, pro_num, all_process);


	char queue_char;
	string pro_name; //these are initialized in here to reduce initilization amount

	// pre_condition decides whether there is any queue left in the mlfq or not
	int condition_size=0, pre_condition=1;
	while (pre_condition-condition_size!=0){ // outter while loop will continue till the termination.
		pre_condition=condition_size;

		if (condition_size!=s_size){
			int i=1;
			for (; i<=q_num&& condition_size!=s_size; i++){  // this one checking all of the priorities from highest to lowest
				while(!mlfq[q_num-i].isEmpty()&&condition_size!=s_size){ // this one checking all of the queues at a given queue
					condition_size++;
					mlfq[q_num-i].dequeue(queue_char, pro_name);

					int pro_position=atoi(pro_name.substr(2));
					char new_char;
					all_process[pro_position-1]>>new_char;

					if (new_char=='-'){ // check the new character whether all done or continue
						//cout<<"E, "<<pro_name<<", QX"<<endl;
						output<<"E, "<<pro_name<<", QX"<<endl;
						all_process[pro_position-1].close(); // all processed are done and file is closed
					}
					else if(queue_char=='1'){
						if (q_num-i>0){
							//cout<<"1, "<<pro_name<<", Q"<<q_num-i<<endl;
							output<<"1, "<<pro_name<<", Q"<<q_num-i<<endl;
							mlfq[q_num-i-1].enqueue(new_char, pro_name);

						}
						else{
							//cout<<"1, "<<pro_name<<", Q"<<q_num-i+1<<endl;
							output<<"1, "<<pro_name<<", Q"<<q_num-i+1<<endl;
							mlfq[q_num-i].enqueue(new_char , pro_name);
						}
					}
					else if(queue_char=='0'){
						//cout<<"0, "<<pro_name<<", Q"<<q_num-i+1<<endl;
						output<<"0, "<<pro_name<<", Q"<<q_num-i+1<<endl;
						mlfq[q_num-i].enqueue(new_char,pro_name);
					}
				}
			}
		}
		else{ // when condition size breached, everyone goes to top
			condition_size=0;
			pre_condition=1;
			int m=2;
			for (;m<q_num;m++){
				while(!mlfq[q_num-m].isEmpty()){
					string pro_name, input;
					mlfq[q_num-m].dequeue(queue_char, pro_name);
					//cout<<"B, "<<pro_name<<", Q"<<q_num<<endl;
					output<<"B, "<<pro_name<<", Q"<<q_num<<endl;
					mlfq[q_num-1].enqueue(queue_char, pro_name);
				}
			}
		}
	}
	output.close();
	delete[] mlfq; // no need to worry about enqueued queues because all of them is dequeued and deleted.
	delete[] all_process;
    return 0;
}