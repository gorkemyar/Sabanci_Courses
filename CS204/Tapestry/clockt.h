#ifndef _CLOCKTIME_H
#define _CLOCKTIME_H

#include <iostream>
#include <string>
using namespace std;

// class for manipulating "clock time", time given in hours, minutes, seconds
// class supports only construction, addition, Print() and output <<
//
// Owen Astrachan: written May 25, 1994
//                 modified Aug 4, 1994, July 5, 1996, April 29, 1999
//
// ClockTime(int secs, int mins, int hours)
//      -- normalized to <= 60 secs, <= 60 mins
//
//      access functions
//
//      Hours()    -- returns # of hours in ClockTime object
//      Minutes()  -- returns # of minutes in ClockTime object
//      Seconds()  -- returns # of seconds in ClockTime object
//      tostring() -- time in format h:m:s
//                    (with :, no space, zero padding)    
//
//      operators (for addition and output)
//
//      ClockTime & operator +=(const ClockTime & ct)
//      ClockTime operator +(const ClockTime & a, const ClockTime & b)
//
//      ostream & operator <<(ostream & os, const ClockTime & ct)
//           inserts ct into os, returns os, uses Print()

class ClockTime
{
  public:
    ClockTime();
    ClockTime(int secs, int mins, int hours);
    
    int     Hours()        const;        // returns # hours
    int     Minutes()      const;        // returns # minutes
    int     Seconds()      const;        // returns # seconds   
    string  tostring()     const;        // converts to string
    
    bool    Equals(const ClockTime& ct) const; // true if == ct
    bool    Less  (const ClockTime& ct) const; // true if < ct
	
    const ClockTime & operator +=(const ClockTime & ct);
    
  private:
  
    void Normalize();        // < 60 secs, < 60 min
  
    int mySeconds;           // constrained: 0-59    
    int myMinutes;           // constrained: 0-59
    int myHours;
};
// free functions, not member functions

ostream &  operator << (ostream & os, const ClockTime & ct);
ClockTime operator + (const ClockTime & lhs, const ClockTime & rhs);

bool operator ==  (const ClockTime& lhs, const ClockTime& rhs);
bool operator !=  (const ClockTime& lhs, const ClockTime& rhs);
bool operator <   (const ClockTime& lhs, const ClockTime& rhs);
bool operator >   (const ClockTime& lhs, const ClockTime& rhs);
bool operator <=  (const ClockTime& lhs, const ClockTime& rhs);
bool operator >=  (const ClockTime& lhs, const ClockTime& rhs);

#endif
