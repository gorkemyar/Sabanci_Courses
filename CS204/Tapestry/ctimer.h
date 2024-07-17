#ifndef _CTIMER_H
#define _CTIMER_H

// a class that can be used to "time" parts of programs
// or as a general timer
//
// operations are:
//
//     Start() : starts the timer 
//     Stop()  : stops the timer
//     ElapsedTime() : returns the elapsed time between 
//                     start and the last stop
//     CumulativeTime(): returns cumulative total of all
//                      "laps" (timed intervals), i.e., sum of
//                      calls to ElapsedTime
//     Reset()    : resets cumulative time to 0
//                  so "removes" history of timer
//
//

class CTimer{
  public:
    CTimer();                         // constructor
    void Reset();                     // reset timer to 0
    void Start();                     // begin timing
    void Stop();                      // stop timing
    double ElapsedTime();             // between last start/stop
    double CumulativeTime();          // total of all times since reset
  private:
    long myStartTime,myEndTime;
    double myElapsed;                 // time since start and last stop
    double myCumulative;              // cumulative of all "lap" times
};

#endif      // _CTIMER_H not defined
