//
//  IOBuffer.h
//  ixyhz
//
//  Created by fox1 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef _GameSocketIOBuffer_h
#define _GameSocketIOBuffer_h



#include "clientDefine.h"



class GameSocketIOBuffer
{
public:
    
    GameSocketIOBuffer();
    ~GameSocketIOBuffer();
    
    
    fvoid initBuffer( int m );
    fvoid releaseBuffer();
    
    fvoid write( fint32 l );
    fbool read( fvoid* b , fint32 l , fint32 offset );
    fvoid removeBuffer( fint32 l );
    
    fvoid write( fvoid* b , fint32 l );
    
    fint32 getLen();
    fint32 getSpace();
    fvoid* getBuffer();
    fvoid* getStart();
    fvoid* getBufferEnd();
    
    fvoid clearBuffer();
    
private:
    
    fint32 begin;
    fint32 len;
    
    fvoid* buffer;
    fint32 max;
    
};


#endif





