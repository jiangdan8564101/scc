//
//  logManager.h
//  test
//
//  Created by fox on 13-1-9.
//
//

#ifndef logManager_h
#define logManager_h

#include "baseDefine.h"

namespace FOXSDK
{
    enum logLevel
    {
        LOGLEVEL0 = 0,
        LOGLEVEL1,
        LOGLEVEL2,
        LOGLEVEL3,
        LOGLEVEL4
    };
    
    extern fint32 gLogLevel;
    
    fvoid log( fint32 level , const fbyte* str , ... );
    fvoid logFile( fint32 level , const fbyte* str , ... );
    
#ifdef F_USE_PRINT
	#ifdef WIN32
		#define FLOG( level , fmt , arg ,... ) log( level , fmt  "\n%s %s() line:%d" , ##arg __VA_ARGS__ , __FILE__ , __FUNCTION__ , __LINE__ );
	#else
		#define FLOG( level , fmt , a... ) log( level , fmt  "\n%s %s() line:%d" , ##a , __FILE__ , __FUNCTION__ , __LINE__ );
        
        #define FLOG0( fmt , a... ) log( LOGLEVEL0 , fmt , ##a );
        #define FLOG1( fmt , a... ) log( LOGLEVEL1 , fmt  "\n%s %s() line:%d" , ##a , __FILE__ , __FUNCTION__ , __LINE__ );
        #define FLOG2( fmt , a... ) log( LOGLEVEL2 , fmt  "\n%s %s() line:%d" , ##a , __FILE__ , __FUNCTION__ , __LINE__ );
        #define FLOG3( fmt , a... ) log( LOGLEVEL3 , fmt  "\n%s %s() line:%d" , ##a , __FILE__ , __FUNCTION__ , __LINE__ );
        #define FLOG4( fmt , a... ) log( LOGLEVEL4 , fmt  "\n%s %s() line:%d" , ##a , __FILE__ , __FUNCTION__ , __LINE__ );
	#endif

#else
	#ifdef WIN32
	#define FLOG( level , fmt , arg ,... ) logFile( level , fmt  "\n%s %s() line:%d" , ##arg __VA_ARGS__ , __FILE__ , __FUNCTION__ , __LINE__ );
	#else
	#define FLOG( level , fmt , a... ) logFile( level , fmt  "\n%s %s() line:%d" , ##a , __FILE__ , __FUNCTION__ , __LINE__ );
	#endif
    
#endif
    
}






#endif
