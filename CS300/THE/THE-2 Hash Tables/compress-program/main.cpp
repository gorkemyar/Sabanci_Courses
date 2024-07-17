#include <iostream>
#include <vector>
#include <string>
#include "hashtable.h"
#include "strutils.h"
#include <fstream>

using namespace std;

int main(){
    //compress

    fstream in_toCompress("compin");
    ofstream out_toCompress("compout");

    int i=0;
    int code_count=0;
    const string ITEM_NOT_FOUND="kabovvvvvv";
    Hashtable<string, int> hashmap(ITEM_NOT_FOUND,4096);
    for (;i<256;i++){
        string a(1, char(i));
        if (hashmap.insert(a,code_count)){
            code_count++;
        }
    }
    string temp="";
    char ch;
    while (!in_toCompress.eof()){ 

        in_toCompress.get(ch);

        //cout<<ch<<endl;
        temp.push_back(ch);
        while ((ITEM_NOT_FOUND!=hashmap.find(temp))&&(!in_toCompress.eof())){
            in_toCompress.get(ch);
            temp.push_back(ch);
        }
        if (!hashmap.isFull()){
            if (!in_toCompress.eof()){
                hashmap.insert(temp,code_count); // added new element
                code_count++; // updated the code count
                int valuesCode=hashmap.Retrieve(temp.substr(0, temp.length()-1));
                out_toCompress<<valuesCode<<" ";
                temp=temp.substr(temp.length()-1);
                //cout<<valuesCode<<endl;
            }
            else{
				temp=temp.substr(0,temp.length()-1);
                // hashtable is not full we reached end of file
                if(ITEM_NOT_FOUND!=hashmap.find(temp)){ // if last string in the hashtable
                    int valuesCode=hashmap.Retrieve(temp.substr());
                    out_toCompress<<valuesCode<<" ";
                    //cout<<valuesCode<<endl;
                }
                else{ // if last string not in the hashtable
                    hashmap.insert(temp,code_count);
                    code_count++;
                    int valuesCode=hashmap.Retrieve(temp.substr(0, temp.length()-1));
                    out_toCompress<<valuesCode<<" ";
                    //cout<<valuesCode<<endl;
					out_toCompress<<hashmap.Retrieve(temp.substr(temp.length()-1));
                }
            }
        }
        else{ // the hashtable is full
            if (!in_toCompress.eof()){ // not end of file
                int valuesCode=hashmap.Retrieve(temp.substr(0, temp.length()-1));
                //cout<<valuesCode<<endl;
                out_toCompress<<valuesCode<<" ";
                temp=temp.substr(temp.length()-1);
            }
            else{ //eof
				temp=temp.substr(0,temp.length()-1);
                if (ITEM_NOT_FOUND!=hashmap.find(temp)){ //in the hash table
                    int valuesCode=hashmap.Retrieve(temp.substr(0));
					//cout<< "I am here"<<endl;
                    out_toCompress<<valuesCode<<" ";
                    //cout<<valuesCode<<endl;
                }
                else {
					cout<<temp<<endl;
                    int valuesCode=hashmap.Retrieve(temp.substr(0, temp.length()-1));
					cout<<temp.substr(0, temp.length()-1)<<endl;
                    out_toCompress<<valuesCode<<" ";
                    valuesCode=hashmap.Retrieve(temp.substr(temp.length()-1));
					//cout<< "I am here"<<endl;
                    out_toCompress<<valuesCode<<" ";
                    //cout<<valuesCode<<endl;
                }
            }
        }
    }
    in_toCompress.close();
    out_toCompress.close();
    return 0;
}
