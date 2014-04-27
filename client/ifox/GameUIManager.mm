//
//  GameUIManager.m
//  ixyhz
//
//  Created by fox1 on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameUIManager.h"
#import "GameDefine.h"
#import "cocos2d.h"
#import "AlarmUIHandler.h"
#import "AlertUIHandler.h"

@implementation GameUIManager

@synthesize rootView , LoadingQueue;
- ( void ) initGameUIManager
{
    rootView = [ [ CCDirector sharedDirector ] view ];
    
    LoadingQueue = dispatch_queue_create("game ui loading queue", NULL);
    
}

- ( void ) releaseGameUIManager
{
    dispatch_release( LoadingQueue );
    
}



GameUIManager* gGameUIManager = NULL;
+(GameUIManager *)instance
{
    if ( !gGameUIManager )
    {
        gGameUIManager = [ [ GameUIManager alloc ] init ];
        
    }
    
    return  gGameUIManager;
}


- ( UIView* ) getUI:( int )tag
{
    return [ [ [ CCDirector sharedDirector ] view ] viewWithTag:tag ];
}


- ( void ) addUI:( UIViewBase * )ui
{
    [ [ [ CCDirector sharedDirector ] view ] addSubview:ui ];
    
    UIView* view = [ [ [ CCDirector sharedDirector ] view ] viewWithTag:12300000 ];
    [ [ [ CCDirector sharedDirector ] view ] addSubview:view ];
    
    view = [ [ [ CCDirector sharedDirector ] view ] viewWithTag:12300001 ];
    [ [ [ CCDirector sharedDirector ] view ] addSubview:view ];
}


- ( void ) update:( float ) delay
{
    for ( UIViewBase* v in rootView.subviews )
    {
        UIHandler* handler = (UIHandler*)v.Handler;
        
        [ handler update:delay ];
    }
}

- ( void ) releaseAllUI
{
    
}

- ( void ) removeAllUI
{
    [self removeAllUI:NULL];
}

- ( void ) removeAllUI:(UIViewBase*)exceptView
{
    [self removeAllUI:exceptView includeAlways:NO];
}

- ( void ) removeAllUI:(UIViewBase*)exceptView includeAlways:(BOOL)includeAlways
{
    for ( int i = 0 ; i < rootView.subviews.count ;  )
    {
        UIViewBase* v = [ rootView.subviews objectAtIndex:i ];
        
        if ( ![ v isKindOfClass:[ UIViewBase class ] ] )
        {
            DEBUGLOG( @"not UIViewBase" );
            assert( 0 );
        }
        
        if (exceptView == v)
        {
            i++;
            continue;
        }
        
        UIHandler* handler = (UIHandler*)v.Handler;
        
        if (!handler.isOpened)
        {
            i++;
            continue;
        }
        
        if ( !handler.IsAlways || includeAlways )
        {
            [ handler visible:NO ];
        }
        else
        {
            i++;
        }
    }
}



@end
