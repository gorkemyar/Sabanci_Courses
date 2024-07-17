#include "ctimer.h"
#include <time.h>

void CTimer::Reset()
// postcondition: all history of timer use erased
//                (cumulative will return 0)     
{
    myCumulative = 0.0;
}
void CTimer::Start()
// postcondition: timer started     
{
    myStartTime = clock();
}

void CTimer::Stop()
// postcondition: timer stopped     
{
    myEndTime = clock();
    myElapsed = myEndTime - myStartTime;   // time since last start
    myCumulative += myElapsed;             // add to cumulative time
}
    
double CTimer::ElapsedTime()
// postcondition: returns time between last stop and start     
{
    return myElapsed/CLOCKS_PER_SEC;
}

double CTimer::CumulativeTime()
// postcondition: returns time timer has been active (last stop)     
{
    return myCumulative/CLOCKS_PER_SEC;
}


CTimer::CTimer() : myElapsed(0.0), myCumulative(0.0)
{
    static int firstTime = 0;
    if (firstTime == 0){
	(void) clock();       // start up clock first time
	firstTime = 1;
    }
}
