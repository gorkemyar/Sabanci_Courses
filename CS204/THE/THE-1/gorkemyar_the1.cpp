// by Gorkem Yar

#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <string>
#include <iomanip>

using namespace std;

void printGame(vector<vector<char> > &toShowPlayer, const int rowsize, const int columnsize){
    // this function is printing the game
    for (int i=0; i<rowsize;i++){
        for (int j=0;j<columnsize;j++){
            cout<<setw(4)<<toShowPlayer[i][j];
        }
        cout<<endl;
    }
    cout<<"\n\n";
}
int toCheckSurroundings(const vector<vector<char> > &dataFromTxt, const vector<vector<char> > &toShowPlayer,int rowPlace, int columnPlace,const int rowsize, const int columnsize){
    // check the surroundings of the place when entered -o and a coordinate find the bomb count near that point
    //used in BombCountZero function
    int bombcount=0;
    for (int i=rowPlace-1;i<=rowPlace+1;i++){
        if ((0<=i)&&i<rowsize){
            for (int j=columnPlace-1;j<=columnPlace+1;j++){
                if(0<=j&&j<columnsize){
                    if(dataFromTxt[i][j]=='x'){
                        bombcount++;
                    }
                }
            }
        }
    }
    return bombcount;
}
void BombCountZero(const vector<vector<char> > &dataFromTxt, vector<vector<char> > &toShowPlayer,int rowPlace, int columnPlace,const int rowsize, const int columnsize){
    //takes toShowPlayer matrix as a reference parameter to return changes in the matrix
    // changes the matrix when -o command entered
    int bombcount=toCheckSurroundings(dataFromTxt, toShowPlayer,rowPlace, columnPlace, rowsize, columnsize);
    if (bombcount==0){
        toShowPlayer[rowPlace][columnPlace]='0';
        for (int i=rowPlace-1;i<=rowPlace+1;i++){
            if ((0<=i)&&i<rowsize){
                for (int j=columnPlace-1;j<=columnPlace+1;j++){
                    if(0<=j&&j<columnsize){
                        toShowPlayer[i][j]=((char)'0'+toCheckSurroundings(dataFromTxt,toShowPlayer ,i ,j ,rowsize ,columnsize));
                    }
                }
            }
        }
    }
    else{
        toShowPlayer[rowPlace][columnPlace]=((char)bombcount+'0');
    }
}
int surroundingNumbers(const vector<vector<char> > &toShowPlayer, int rowPlace, int columnPlace, const int rowsize, const int columnsize){
    // to check the surrounding Numbers of a point
    // used in help function
    int surroundingsOfPoint=0;
    for (int i=rowPlace-1;i<=rowPlace+1;i++){
        if ((0<=i)&&i<rowsize){
            for (int j=columnPlace-1;j<=columnPlace+1;j++){
                if(0<=j&&j<columnsize){
                    if(toShowPlayer[i][j]!='.'&&toShowPlayer[i][j]!='0'&&toShowPlayer[i][j]!='x'&&toShowPlayer[i][j]!='B'){
                        surroundingsOfPoint++; //if there is a number point around a bomb than we can give a hint that is why we are checking numbers
                    }
                }
            }
        }
    }
    return surroundingsOfPoint;
}
bool help(vector<vector<char> > &dataFromTxt, vector<vector<char> > &toShowPlayer, const int rowsize, const int columnsize){
    bool flag=true;
    int positionI=rowsize, positionJ=columnsize; // to hold the closest point to upper left corner
    for (int i=0; i<rowsize;i++){
        for (int j=0;j<columnsize;j++){
            if ((dataFromTxt[i][j]=='x')&&(toShowPlayer[i][j]=='.')){
                if (surroundingNumbers(toShowPlayer,i ,j, rowsize, columnsize)>=1){
                    if (i<=positionI){
                        positionI=i; // find the closest column
                        if (j<positionJ){
                            positionJ=j; //find the closest row
                        }
                    }
                }
            }
        }
    }
    if (positionI!=rowsize&&positionJ!=columnsize){
        toShowPlayer[positionI][positionJ]='x';
    }
    else{
        flag=false; //no help
    }
    return flag;
}
bool dotcheck(const vector<vector<char> > &toShowPlayer,const int rowsize, const int columnsize){
    // this function is checking whether the all places have opened or not in the whole game //if no place is dot game ends
    bool flag=false;
    for (int i=0; i<rowsize;i++){
        for (int j=0;j<columnsize;j++){
            if (toShowPlayer[i][j]=='.'){
                flag=true;
            }
        }
    }
    return flag;
}

bool winLoseGame(const vector<vector<char> > &toShowPlayer,const vector<vector<char> > &dataFromTxt, const int rowsize, const int columnsize){
// last function determines if the player won the game or not
    bool flag=true;
    for (int i=0; i<rowsize;i++){
        for (int j=0;j<columnsize;j++){
            if (!(dataFromTxt[i][j]=='x')&&((toShowPlayer[i][j]=='x')||(toShowPlayer[i][j]=='B'))){
                flag=false;
            }
        }
    }
    return flag;
}

int main() {
    
    // reading txt file from user
    ifstream input;
    string filename;
    cout<<"Enter the input file name: ";
    cin>>filename;
    input.open(filename.c_str());
    while (input.fail()){
        cout<<"Problem occurred while reading the file!!!"<<endl;
        cout<<"Enter the input file name: ";
        cin>>filename;
        input.open(filename.c_str());
    }
    
    // to initialize the vector size and the vector
    string firstline;
    getline(input,firstline);
    istringstream firstLineStream(firstline);
    int xaxis, yaxis;
    firstLineStream>>xaxis>>yaxis;
    const int ROW_SIZE=xaxis;
    const int COLUMN_SIZE=yaxis;
    vector<vector<char> > dataFromTxt(ROW_SIZE, vector<char> (COLUMN_SIZE)); //this one will keep the data of txt file
    vector<vector<char> > toShowPlayer(ROW_SIZE, vector<char> (COLUMN_SIZE)); // this one will be consist of '.' and change them each time when the user enters a valid choice
    
    // to fill the vectors
    
    string line;
    char ch;
    for (int i=0; i<ROW_SIZE;i++){
        getline(input,line);
        istringstream lineStream(line);
        for (int j=0;j<COLUMN_SIZE;j++){
            lineStream>>ch;
            dataFromTxt[i][j]=ch; //filled with data
            toShowPlayer[i][j]='.'; // filled with '.'
        }
    }
    input.clear();
    input.close();
    
    // prompt part for the output
    cout<<"Welcome to the Minesweeper Game!"<<endl;
    cout<<"You may choose a cell to open (-o), get help (-h) or mark/unmark bomb (-b)!!"<<endl;
    printGame(toShowPlayer, ROW_SIZE, COLUMN_SIZE);
    int helpcount=0;
    bool breakflag=true;
    while (dotcheck(toShowPlayer, ROW_SIZE, COLUMN_SIZE)&&breakflag){
        
        string choiceFirstPart;
        
        cin.clear();
        cout<<"Please enter your choice: ";
        cin>>choiceFirstPart;
        
        // this part for input validation ı do not know it is necessary or not but ı did it anyway
        bool inputsCorrect=true;
        int rowPlace=-1, columnPlace=-1; //to initialize but it is not doing anything actually
        if (choiceFirstPart=="-o"||choiceFirstPart=="-b"){
            
            string linecontinue;
            getline(cin,linecontinue);
            istringstream tempStream(linecontinue);
            string first, second;
            tempStream>>first>>second;
            for (int i=0;i<first.length();i++){
                if (!('0'<=first[i]&&first[i]<'9')){
                    inputsCorrect=false;
                }
            }
            for (int j=0;j<second.length();j++){
                if (!('0'<=second[j]&&second[j]<'9')){
                    inputsCorrect=false;
                }
            }
            if (inputsCorrect){
                tempStream.clear();
                tempStream.seekg(0);
                tempStream>>rowPlace>>columnPlace;
            }
        }
    
        //open
        if (choiceFirstPart=="-o"&&inputsCorrect){
            if ((0<=rowPlace)&&(rowPlace<=ROW_SIZE)&&(0<=columnPlace)&&(columnPlace<=COLUMN_SIZE)){
                if (toShowPlayer[rowPlace][columnPlace]=='.'){
                    if (dataFromTxt[rowPlace][columnPlace]=='x'){
                        // if a bomb is selected by player
                        cout<<"You opened a mine! Game over:("<<endl;
                        breakflag=false;
                    }
                    else{
                        BombCountZero(dataFromTxt,toShowPlayer, rowPlace, columnPlace, ROW_SIZE, COLUMN_SIZE); //any other square
                        printGame(toShowPlayer, ROW_SIZE, COLUMN_SIZE);
                    }
                }
                else if(toShowPlayer[rowPlace][columnPlace]=='B'||toShowPlayer[rowPlace][columnPlace]=='x'){
                    cout<<"It seems like this cell is a bomb."<<endl;
                }
                
                else{
                    cout<<"Already opened."<<endl;
                }
            }
            else{
                cout<<"Please enter a valid coordinate! "<<endl;
            }
        }
        //bomb
        else if (choiceFirstPart=="-b"&&inputsCorrect){
            if ((0<=rowPlace)&&(rowPlace<ROW_SIZE)&&(0<=columnPlace)&&(columnPlace<COLUMN_SIZE)){
                if (toShowPlayer[rowPlace][columnPlace]=='.'){
                    toShowPlayer[rowPlace][columnPlace]='B';
                    printGame(toShowPlayer, ROW_SIZE, COLUMN_SIZE);
                }
                else if (toShowPlayer[rowPlace][columnPlace]=='B'){
                    toShowPlayer[rowPlace][columnPlace]='.';
                    printGame(toShowPlayer, ROW_SIZE, COLUMN_SIZE);
                }
                else {
                    cout<<"Can't mark that cell as a bomb."<<endl;
                }
            }
            else{
                cout<<"Please enter a valid coordinate! "<<endl;
            }
        }
        
        //help
        else if (choiceFirstPart=="-h"){
            helpcount++;
            if (helpcount<=3){
                if (help(dataFromTxt, toShowPlayer, ROW_SIZE, COLUMN_SIZE)){
                    printGame(toShowPlayer, ROW_SIZE, COLUMN_SIZE);
                }
                else{
                    cout<<"I can't help you."<<endl;
                }
            }
            else{
                cout<<"Your help chances are over. :("<<endl;
            }
        }
        
        // no valid choice
        else {
            cout<<"Invalid choice!!"<<endl;
        }
    }
    // end of while loop end game part
    
    if (breakflag){
        //if bomb did not blasted
        if (winLoseGame(toShowPlayer,dataFromTxt, ROW_SIZE, COLUMN_SIZE)){
            cout<<"Congrats! You won!"<<endl;
        }
        else{
            cout<<"You put bombs in the wrong places! Game over:("<<endl;
        }
    }
    return 0;
}
