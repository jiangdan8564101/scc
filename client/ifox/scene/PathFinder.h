//
//  PathFinder.h
//  sc
//
//  Created by fox1 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientDefine.h"

class PathFinder;

@interface PathFinderO :  NSObject
{
    NSMutableArray* pathArray;
    PathFinder* finder;
}

- ( int ) getX:( int )index;
- ( int ) getY:( int )index;
- ( int ) getIndex:( int ) x :( int )y;

- ( void ) releaseFinder;
- ( void ) initFinder;

- ( NSMutableArray* ) compressePath:( NSMutableArray* )array;
- ( NSMutableArray* ) uncompressePath:( NSArray* )array;

- ( void ) setMapMaxXY:( int )x :( int )y;
- ( void ) initMap:( const char* )val :( int )x : ( int ) y;
- ( void ) setMap:( const char)v :( int )x :( int )y;
- ( int ) findPath:(int*)outBuffer :( int ) sX : ( int ) sY : ( int ) eX :( int )eY;


@end


