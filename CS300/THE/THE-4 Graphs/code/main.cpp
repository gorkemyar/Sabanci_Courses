#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include "Graph.h"
using namespace std;
//Gorkem Yar

int main(){
    
    fstream input;
    string filename;
    filename="words.txt";

    //cout<<"Please enter a file name: ";
    //cin>>filename;
    
    input.open(filename.c_str());
    
    vector<string> temp;
    string word;
    while (!input.eof()){
        input>>word;
        temp.push_back(word);
    }

    const string NOT_A_VERTEX("kabooom");
    int size=(int)temp.size();
    Graph mygraph(NOT_A_VERTEX, size);
    //cout<<size<<endl;
    for (int i=0; i<size;i++){
        //cout<<temp[i]<<endl;

        mygraph.insert(temp[i]);
    }
    
    //mygraph.print();
    
    string word1, word2;
    while (true){
        cin>>word1>>word2;
        if (word1[0]=='*'){
            break;
        }
        mygraph.unweighted(word1,word2);
        
    }
    
    

    return 0;
}
