//
//  MapGridPos.m
//  sc
//
//  Created by fox1 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapGridPos.h"
#import "GameManager.h"


@implementation MapGridPos


@synthesize Direction = direction , MapID = mapID;
@synthesize Speed = speed;
@synthesize Grid = mapGrid;
@synthesize StartGrid = startGrid;
@synthesize DesGrid = desGrid;


-( BOOL ) isMoving
{
    return moving;
}


-( void ) initGridPos
{
    mapGrid = [ [ MapGrid alloc ] init ];
    startGrid = [ [ MapGrid alloc ] init ];
    desGrid = [ [ MapGrid alloc ] init ];
    
}

- ( void ) updateSpeed
{
    speed = 150 * GAME_SPEED;
}


-( void ) releaseGridPos
{
    [ mapGrid release ];
    [ startGrid release ];
    [ desGrid release ];
}


+ ( int ) getDirect: ( MapGrid* )grid1 :( MapGrid* )grid2
{
    int x = grid1.PosX - grid2.PosX;
    int y = grid1.PosY - grid2.PosY;
    
    int d = MG_DIRECT_COUNT;
    
    if ( x > 0 && y == 0 )
    {
        d = MG_EAST;
    }
    else if ( x == 0 && y < 0 )
    {
        d = MG_NORTH;
    }
    else if ( x < 0 && y == 0 )
    {
        d = MG_WEST;
    }
    else if ( x == 0 && y > 0 )
    {
        d = MG_SOUTH;
    }
    
    return d;
}


- ( void ) startMove: ( MapGrid* )des
{
    [ startGrid copyGrid:mapGrid ];
    [ desGrid copyGrid:des ];
    
    moving = YES;
    time = 0.0;
    
    direction = [ MapGridPos getDirect:desGrid :startGrid ]; 
}


- ( void ) endMove
{
    moving = NO;
    
    [ mapGrid copyGrid:desGrid ];
}


- ( void ) move:( float )delay
{
    if ( !moving ) 
    {
        return;
    }
    
    time += delay;
    float dis = time * speed;
    
    
    if ( direction == MG_NORTH ) 
    {
        if ( dis > MG_GRID_Y ) 
        {
            [ self endMove ];
            return;
        }
        
        mapGrid.RealPosY = startGrid.RealPosY - dis;
        mapGrid.PosY = dis < MG_GRID_Y_HALF ? startGrid.PosY : startGrid.PosY - 1;
    }
    else if ( direction == MG_SOUTH ) 
    {
        if ( dis > MG_GRID_Y ) 
        {
            [ self endMove ];
            return;
        }
        
        mapGrid.RealPosY = startGrid.RealPosY + dis;
        mapGrid.PosY = dis < MG_GRID_Y_HALF ? startGrid.PosY : startGrid.PosY + 1;
    }
    else if ( direction == MG_WEST ) 
    {
        if ( dis > MG_GRID_X ) 
        {
            [ self endMove ];
            return;
        }
        
        mapGrid.RealPosX = startGrid.RealPosX - dis;
        mapGrid.PosX = dis < MG_GRID_X_HALF ? startGrid.PosX : startGrid.PosX - 1;
    }
    else if ( direction == MG_EAST ) 
    {
        if ( dis > MG_GRID_X ) 
        {
            [ self endMove ];
            return;
        }
        
        mapGrid.RealPosX = startGrid.RealPosX + dis;
        mapGrid.PosX = dis < MG_GRID_X_HALF ? startGrid.PosX : startGrid.PosX + 1;
    }
    else 
    {
        [ self endMove ];
        return;
    }
    
    
    
    
}



@end




