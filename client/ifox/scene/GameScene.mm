//
//  GameScene.m
//  sc
//
//  Created by fox1 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameManager.h"

@implementation GameScene

@synthesize Name = name;

-( void )onEnter
{
    [ [ [ CCDirector sharedDirector ] touchDispatcher ]addTargetedDelegate:self priority:100 swallowsTouches:YES ];
    [ super onEnter ];
}


-( void )onExit
{
    [ [ [ CCDirector sharedDirector ] touchDispatcher ] removeDelegate:self ];
    [ super onExit ];
}


- ( BOOL )ccTouchBegan:( UITouch* )touch withEvent:( UIEvent* )event   
{   
    return YES; 
}   


- ( void )ccTouchEnded:( UITouch* )touch withEvent:( UIEvent* )event
{
    
}

- ( void ) onInited
{
    
}

- ( void ) onEnterMap
{

}
- ( void ) onExitMap
{

}

- ( void ) setBG:( NSString* )name
{
}
- ( void ) fade:( float )f
{
}
- ( void ) fadeRight:( float )f
{
}
- ( void ) fadeLeft:( float )f
{
}

- ( void ) initScene:( NSString* )n
{
    if ( inited ) 
    {
        return;
    }
    
    name = n.retain;
    
    inited = YES;
    
    [ self onInited ];
}


- ( void ) releaseScene
{
    if ( !inited ) 
    {
        return;
    }
    
    [ name release ];
    name = NULL;
    
    inited = NO;
    
    [ self removeAllChildrenWithCleanup:YES ];
}




- ( void ) update:( float )delay
{
    
}





@end


