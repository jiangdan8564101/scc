//
//  MapGrid.m
//  sc
//
//  Created by fox1 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapGrid.h"






@implementation MapGrid
{
    
}

@synthesize PosX = posX , PosY = posY , RealPosX = realPosX , RealPosY = realPosY;


-( void ) setGrid:( int )x :( int )y
{
    posX = x;
    posY = y;
    
    realPosX = x * MG_GRID_X + MG_GRID_X_HALF;
    realPosY = y * MG_GRID_Y + MG_GRID_Y_HALF;
}


-( void ) copyGrid:( MapGrid* ) grid
{
    posX = grid.PosX;
    posY = grid.PosY;
    
    realPosX = grid.RealPosX;
    realPosY = grid.RealPosY;
}


-( BOOL ) check
{
    return realPosX == posX * MG_GRID_X && realPosY == posY * MG_GRID_Y;
}


-( BOOL ) equalsReal:( MapGrid* )grid
{
    return realPosX == grid.RealPosX && realPosY == grid.RealPosY;
}


-( BOOL ) equals:(MapGrid *)grid
{
    return posX == grid.PosX && posY == grid.PosY;
}


-( void ) move:( int )direct
{
    switch ( direct ) 
    {
        case MG_EAST:
            posX++;
            break;
        case MG_SOUTH:
            posY++;
            break;
        case MG_WEST:
            posX--;
            break;
        case MG_NORTH:
            posY--;
            break;
         
        default:
            return;
            break;
    }
    
    [ self setGrid:posX :posY ];

}


-( BOOL ) isAround:( MapGrid* )grid
{
    if ( grid.PosX == posX + 1 && grid.PosY == posY ) 
    {
        return YES;
    }
    
    if ( grid.PosX == posX - 1 && grid.PosY == posY ) 
    {
        return YES;
    }
    
    if ( grid.PosX == posX && grid.PosY == posY + 1 ) 
    {
        return YES;
    }
    
    if ( grid.PosX == posX && grid.PosY == posY - 1 ) 
    {
        return YES;
    }
    
    
    if ( grid.PosX == posX - 1 && grid.PosY == posY - 1 ) 
    {
        return YES;
    }
    
    if ( grid.PosX == posX + 1 && grid.PosY == posY - 1 ) 
    {
        return YES;
    }
    
    if ( grid.PosX == posX - 1 && grid.PosY == posY + 1 ) 
    {
        return YES;
    }
   
    if ( grid.PosX == posX + 1 && grid.PosY == posY + 1 ) 
    {
        return YES;
    }
    
    
    return NO;
}


@end
