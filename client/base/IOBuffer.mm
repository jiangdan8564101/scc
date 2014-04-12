//
//  IOBuffer.m
//  sc
//
//  Created by fox1 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IOBuffer.h"

@implementation IOBuffer


- ( void ) clearBuffer
{
    begin = 0;
    len = 0;
}


- ( void ) initBuffer:( int )m
{
    max = m;
    
    if ( buffer )
    {
        free( buffer );
        buffer = NULL;
    }
    
    buffer = malloc( m );
}


- ( void ) releaseBuffer
{
    if ( buffer )
    {
        free( buffer );
        buffer = NULL;
    }
}

- ( void ) write:( int )l
{
    len += l;
}


- ( BOOL ) read:(void *)b :(int)l :(int)offset
{
    if ( l > len )
    {
        return NO;
    }
    
    memcpy( b , (void*)( (int)buffer + begin + offset ) , l );
    
    return YES;
}


- ( void ) removeBuffer:( int )l
{
    begin += l;
    len -= l;
    
    if ( len == 0 )
    {
        begin = 0;
    }
}

- ( int ) getLen
{
    return len;
}

- ( int ) getSpace
{
    return max - begin - len;
}

- ( void* ) getBuffer
{
    return buffer;
}
- ( void* ) getStart
{
    return (void*)( (int)buffer + begin );
}
- ( void* ) getBufferEnd
{
    return (void*)( (int)buffer + begin + len );
}



@end
