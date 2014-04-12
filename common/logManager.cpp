//
//  logManager.cpp
//  test
//
//  Created by fox on 13-1-9.
//
//

#include "logManager.h"

using namespace FOXSDK;

fint32  FOXSDK::gLogLevel = (fint32)LOGLEVEL0;

//mutex   gMutex;

fvoid   FOXSDK::log( fint32 level , const fbyte* str , ... )
{
#ifdef DEBUG
    //mutex::scoped_lock lock( gMutex );
    
    if ( level < gLogLevel )
    {
        return;
    }
    
    va_list va;
    static char sstr[255];
    static char sbuf[255];
    memset( sstr , 0 , 255 );
    memset( sbuf , 0 , 255 );
    
    va_start( va , str );
    vsprintf( sstr , str , va );
    va_end(va);
    
    printf( "log:level %d %s \n" , level , sstr );
    
#endif
    //lock.unlock();
}


fvoid   FOXSDK::logFile( fint32 level , const fbyte* str , ... )
{
    
}



