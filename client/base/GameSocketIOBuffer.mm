//
//  IOBuffer.m
//  ixyhz
//
//  Created by fox1 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "GameSocketIOBuffer.h"



GameSocketIOBuffer::GameSocketIOBuffer()
{
}

GameSocketIOBuffer::~GameSocketIOBuffer()
{
}


fvoid   GameSocketIOBuffer::clearBuffer()
{
    begin = 0;
    len = 0;
}


fvoid   GameSocketIOBuffer::initBuffer( int m )
{
    max = m;
    
    if ( buffer ) 
    {
        free( buffer );
        buffer = NULL;
    }
    
    buffer = malloc( m );
}


fvoid   GameSocketIOBuffer::releaseBuffer()
{
    if ( buffer ) 
    {
        free( buffer );
        buffer = NULL;
    }
}

fvoid   GameSocketIOBuffer::write( int l )
{
    len += l;
}


fbool   GameSocketIOBuffer::read( fvoid* b , int l , int offset )
{
    if ( l > len - offset )
    {
        return F_FALSE;
    }
    
    memcpy( b , (void*)( (int)buffer + begin + offset ) , l );
    
    return F_TRUE;
}


fvoid   GameSocketIOBuffer::removeBuffer( int l )
{
    begin += l;
    len -= l;
    
    if ( len == 0 ) 
    {
        begin = 0;
    }
}


fvoid   GameSocketIOBuffer::write( fvoid* b , fint32 l )
{
    if ( !buffer )
    {
        return;
    }
    
    if ( getSpace() < l )
    {
        return;
    }
    
    memcpy( getBufferEnd() , b , l );
    len += l;
}


fint32  GameSocketIOBuffer::getLen()
{
    return len;
}

fint32  GameSocketIOBuffer::getSpace()
{
    return max - begin - len;
}

fvoid*  GameSocketIOBuffer::getBuffer()
{
    return buffer;
}
fvoid*  GameSocketIOBuffer::getStart()
{
    return (fvoid*)( (fint32)buffer + begin );
}
fvoid*  GameSocketIOBuffer::getBufferEnd()
{
    return (fvoid*)( (fint32)buffer + begin + len );
}


