//
//  MapGrid.h
//  sc
//
//  Created by fox1 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClientDefine.h"


#define MG_NORTH 2
#define MG_SOUTH 0
#define MG_WEST 1
#define MG_EAST 3

#define MG_DIRECT_COUNT 4


#define MG_GRID_X 100.0f
#define MG_GRID_Y 100.0f

#define MG_GRID_X_HALF 50.0f
#define MG_GRID_Y_HALF 50.0f


@interface MapGrid : NSObject
{
    int posX;
    int posY;
    
    float realPosX;
    float realPosY;
    
    
}


@property ( nonatomic ) int PosX , PosY;
@property ( nonatomic ) float RealPosX , RealPosY;



-( void ) setGrid:( int )x :( int )y;

-( void ) copyGrid:( MapGrid* ) grid;
-( BOOL ) check;

-( BOOL ) equalsReal:( MapGrid* )grid;
-( BOOL ) equals:(MapGrid *)grid;

-( void ) move:( int )direct;
-( BOOL ) isAround:( MapGrid* )grid;




@end






