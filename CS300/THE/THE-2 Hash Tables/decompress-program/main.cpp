#include <iostream>
#include <vector>
#include <string>
#include "hashtable.h"
#include "strutils.h"
#include <fstream>
#include <sstream>

using namespace std;

int main(){
	 //decompress
    const string ITEM_NOT_FOUND="kabovvvvvv";

    fstream in_todeCompress("compout");
    ofstream out_todeCompress("decompout");
    
    vector<string> code_values(4096, ITEM_NOT_FOUND); // ITEM_NOT_FOUND used in the initialization of the vector
    Hashtable<string, int> decomp(ITEM_NOT_FOUND,4096);
    int k=0;
    int code_de=0;
    for (;k<256;k++){
        string chr(1, char(k));
        if (decomp.insert(chr,code_de)){
            code_values[code_de]=chr;
            code_de++;
            
        }
    }

    int previousIdx, currentIdx;
    string previous, current, newItem;
    
    in_todeCompress>>previousIdx; //the first one
    previous=code_values[previousIdx];
    out_todeCompress<<previous;
	//cout<<current;
    
    while (!in_todeCompress.eof()){
        cin.clear();
        in_todeCompress>>currentIdx;
		//cout<<code_de<<endl;
        if (currentIdx==-1){
            break;
        }
        current=code_values[currentIdx];
        if (current!=ITEM_NOT_FOUND){ // current found in code-value pairs
            out_todeCompress<<current;
			//cout<<current;
			if (code_de<4096){
				newItem=previous+current[0]; // create a new code-value
				if (newItem!=decomp.find(newItem)){ // check new
					decomp.insert(newItem, code_de);
					code_values[code_de]=newItem; //update it
					code_de++;
				}
			}
        }
        else { // not existing code
            current=previous+previous[0];
            if (current!=decomp.find(current)){ // unncessary check but in case ı checked it
                decomp.insert(current, code_de);
                code_values[code_de]=current;
                code_de++;
                out_todeCompress<<current;
				//cout<<current;
            }
        }
        previous=current;
        currentIdx=-1; // this one is for breaking the loop
    }
    in_todeCompress.close();
    out_todeCompress.close();
    return 0;
}
