//
//  MapGridPos.h
//  sc
//
//  Created by fox1 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MapGrid.h"


@interface MapGridPos : NSObject
{
    int mapID;
    
    MapGrid* mapGrid;
    MapGrid* startGrid;
    MapGrid* desGrid;
    
    BOOL moving;
    float time;
    
    int direction;
    
    float speed;
}


@property ( nonatomic ) int Direction , MapID;
@property ( nonatomic ) float Speed;
@property ( nonatomic , readonly ) MapGrid* Grid;
@property ( nonatomic , readonly ) MapGrid* StartGrid;
@property ( nonatomic , readonly ) MapGrid* DesGrid;



-( BOOL ) isMoving;

-( void ) initGridPos;
-( void ) releaseGridPos;


+ ( int ) getDirect: ( MapGrid* )grid1 :( MapGrid* )grid2;

- ( void ) updateSpeed;

- ( void ) startMove: ( MapGrid* )des;
- ( void ) endMove;

- ( void ) move:( float )delay;




@end
