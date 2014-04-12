//
//  IOBuffer.h
//  sc
//
//  Created by fox1 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDefine.h"

@interface IOBuffer : NSObject
{
    int begin;
    int len;
    
    void* buffer;
    int max;
}


- ( void ) initBuffer:( int )m;
- ( void ) releaseBuffer;

- ( void ) write:( int )l;
- ( BOOL ) read:( void* )b :( int )l :( int )offset;
- ( void ) removeBuffer:( int )l;


- ( int ) getLen;
- ( int ) getSpace;
- ( void* ) getBuffer;
- ( void* ) getStart;
- ( void* ) getBufferEnd;

- ( void ) clearBuffer;

@end
