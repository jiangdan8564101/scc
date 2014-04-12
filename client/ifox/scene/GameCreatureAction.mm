//
//  GamePlayerAction.m
//  ixyhz
//
//  Created by fox1 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameCreatureAction.h"
#import "ActionConfig.h"

@implementation GameCreatureAction



@synthesize Action = action , ActionID = actionID , Owner = owner , UseAgain , UseAsync , NoClear , UseDefault , Texture;

- ( CGRect ) getRect
{
    return textureRect;
}


- ( BOOL ) checkPointIn:( float )x :( float )y
{
    CCSpriteFrame* frame = [ owner displayFrame ];
    
    if ( frame )
    {
        [ frame texture ];
    }
    
    return NO;
}


- ( void ) setLoop:( BOOL )l
{
    loop = l;
}

- ( void ) clearAction
{
    [ action release ];
    action = NULL;
    direction = MG_DIRECT_COUNT;
}


- ( BOOL ) playEffect:(NSObject *)t :(SEL)s
{
    if ( !inited )
    {
        return NO;
    }
    
    if ( !texture )
    {
        return NO;
    }
    
    int fc = [ [ actionDic objectForKey:@"c" ] intValue ];
    int width = [ [ actionDic objectForKey:@"w" ] intValue ];
    int height = [ [ actionDic objectForKey:@"h" ] intValue ];
    float spd = [ [ actionDic objectForKey:@"s" ] intValue ];
    
    target = t;
    sel = s;
    
    int w = texture.pixelsWide;
    int h = texture.pixelsHigh;
    
    int xa = 0;
    int ya = 0;
    
    int xs = 0;
    int ys = 0;
    
    xa = w / width;
    ya = h / height;
    
    xs = 0;
    ys = 0;
    
    int xo = xa / 2;
    int yo = ya / 2;
    
    if ( fc != frameArray.count )
    {
        for ( int i = 0 ; i < frameArray.count ; i++ )
        {
            [ [ frameArray objectAtIndex:i ] release ];
        }
        
        [ frameArray removeAllObjects ];
        
        for ( int i = 0 ; i < fc ; i++ )
        {
            CCSpriteFrame* frame = [ [ CCSpriteFrame alloc ] init ];
            [ frameArray addObject:frame ];
        }
        
        if ( animation )
        {
            animation = NULL;
            animate = NULL;
        }
    }
    
    
    for ( int i = 0 ; i < frameArray.count ; i++ )
    {
        [ [ frameArray objectAtIndex:i ] setTexture:texture ];
    }
    
    textureRect = CGRectMake( -xo , -yo , xa , ya );
    
    CGRect rect = CGRectMake( xs , ys * ya , xa , ya );
    
    
    for ( int i = 0 ; i < frameArray.count ; i++ )
    {
        CCSpriteFrame* frame = [ frameArray objectAtIndex:i ];
        
        CGPoint point = CGPointMake( xa * 0.5f - xo , - ya * 0.5f + yo );
        
        [ frame setRect:rect ];
        [ frame setOffset:point ];
        
        rect.origin.x += xa;
        
        if ( rect.origin.x + xa > texture.pixelsWide )
        {
            rect.origin.x = 0;
            rect.origin.y += ya;
        }
    }
    
    [ owner stopAllActions ];
    [ owner setDisplayFrame:[ frameArray objectAtIndex:0 ] ];
    
    animation = [ CCAnimation animationWithSpriteFrames:frameArray delay:spd / fc ];
    animate = [ CCAnimate actionWithAnimation:animation ];
    
    [ owner runAction:[ CCSequence actionOne:animate two:[ CCCallFunc actionWithTarget:self selector:@selector(onEffectOver) ] ] ];
    
    return YES;
}


- ( BOOL ) setAction:( NSString* )a :(int)d
{
    if ( !inited )
    {
        return NO;
    }
    
    if ( [ action isEqualToString:a ] && direction == d && !UseAgain ) 
    {
        return NO;
    }
    
    [ action release ];
    action = [ [ NSString alloc ] initWithString:a ];
    direction = d;
    
    if ( !texture )
    {
        return NO;
    }
    
    int w = texture.pixelsWide;
    int h = texture.pixelsHigh;
    
    int fc = 4;
    float spd = 0.2f;
    
    int xa = 0;
    int ya = 0;
    
    int xs = 0;
    int ys = 0;
    
    if ( [ action isEqualToString:CAT_MOVE ] )
    {
        xa = w / 4;
        ya = h / 4;
        
        xs = 0;
        ys = d;
    }
    else if( [ action isEqualToString:CAT_STAND ] )
    {
        xa = w / 2;
        ya = h / 2;
    }
    
    int xo = xa / 2;
    int yo = ya / 2;
    
    if ( fc != frameArray.count )
    {
        for ( int i = 0 ; i < frameArray.count ; i++ )
        {
            [ [ frameArray objectAtIndex:i ] release ];
        }
        
        [ frameArray removeAllObjects ];
        
        for ( int i = 0 ; i < fc ; i++ )
        {
            CCSpriteFrame* frame = [ [ CCSpriteFrame alloc ] init ];
            [ frameArray addObject:frame ];
        }
        
        if ( animation )
        {
            animation = NULL;
            animate = NULL;
        }
    }

    
    for ( int i = 0 ; i < frameArray.count ; i++ ) 
    {
        [ [ frameArray objectAtIndex:i ] setTexture:texture ];
    }

    textureRect = CGRectMake( -xo , -yo , xa , ya );
    
    CGRect rect = CGRectMake( xs , ys * ya , xa , ya );
    
    
    for ( int i = 0 ; i < frameArray.count ; i++ )
    {
        CCSpriteFrame* frame = [ frameArray objectAtIndex:i ];
        
        CGPoint point = CGPointMake( xa * 0.5f - xo , - ya * 0.5f + yo );
        [ frame setRect:rect ];
        [ frame setOffset:point ];
        
        rect.origin.x += xa;
        
        while ( rect.origin.x + rect.size.width > w )
        {
            rect.origin.x = 0;
            rect.origin.y += ya;
        }
    }
    
    [ owner stopAllActions ];
    [ owner setDisplayFrame:[ frameArray objectAtIndex:0 ] ];
    
    animation = [ CCAnimation animationWithSpriteFrames:frameArray delay:spd ];
    animate = [ CCAnimate actionWithAnimation:animation ];
    
    [ owner runAction:[ CCRepeatForever actionWithAction:animate ] ];
    
    return YES;
}


- ( void ) onEffectOver
{
    if ( !NoClear ) 
    {
        [ owner stopAllActions ];
        [ owner setTexture:NULL ];
        [ owner setTextureRect:CGRectMake(0.0f,0.0f,0.0f,0.0f) ];
        [ owner setContentSize:CGSizeMake(0.0f,0.0f) ];
        [ owner removeAllChildrenWithCleanup:YES ];
        [ owner cleanup ];
    }
    
    [ target performSelector:sel ];
    target = NULL;
    sel = NULL;
}


- ( void ) setActionID:( NSString* )i
{
    if ( !inited )
    {
        return;
    }
    
    actionDic = [ [ ActionConfig instance ] getAction:i ];
    
    if ( ![ actionID isEqualToString:i ]  )
    {
        [ self clearAction ];
        
        if ( UseAsync )
        {
            loading = YES;
            
            NSString* path = [ [ NSBundle mainBundle ] pathForResource:i ofType:@"png" inDirectory:ACTION_PATH ];
            
            if ( !path )
            {
                DEBUGLOG( @"path not found %@.png" , i );
                assert( 0 );
            }
            
            [ [ CCTextureCache sharedTextureCache ] addImageAsync:path target:self selector:@selector( onLoadTexture: ) ];
        }
        else 
        {
            NSString* path = [ [ NSBundle mainBundle ] pathForResource:i ofType:@"png" inDirectory:ACTION_PATH ];
            
            if ( !path )
            {
                DEBUGLOG( @"path not found %@.png" , i );
                assert( 0 );
            }
            
            texture = [ [ CCTextureCache sharedTextureCache ] addImage:path ];
        }
        
    }
    
    [ actionID release ];
    actionID = [ [ NSString alloc ] initWithString:i ];
}


- ( void ) onLoadTexture:( CCTexture2D* )t
{
    if ( !owner ) 
    {
        return;
    }
    
    if ( !t ) 
    {
        return;
    }
    
    if ( texture && !UseDefault )
    {
        //reload,,,bug,
        return;
    }
    
    texture = t;
    
    loading = NO;
    
    if ( action )
    {
        NSString* str = action;
        [ action release ];
        action = NULL;
        
        onLoad = YES;
        [ self setAction:str :direction ];
        onLoad = NO;
    }
    
}


- ( void ) initAction:( CCSprite* )o
{
    if ( inited )
    {
        return;
    }
    
    owner = o;
    
    direction = MG_DIRECT_COUNT;
    
    frameArray = [ [ NSMutableArray alloc ] init ];
        
    inited = YES;
    
    UseAgain = NO;
    UseAsync = YES;
    NoClear = NO;
    onLoad = NO;
    
    UseDefault = YES;
}


- ( void ) releaseAction
{
    if ( !inited )
    {
        return;
    }
    
    inited = NO;
    
    if ( frameArray ) 
    {
        for ( int i = 0 ; i < frameArray.count ; i++ ) 
        {
            [ [ frameArray objectAtIndex:i ] release ];
        }
        
        [ frameArray removeAllObjects ];
        [ frameArray release ];
        frameArray = NULL;
    }
       
    actionDic = NULL;
    
    [ owner cleanup ];
    owner = NULL;
    loop = NO;
    
    [ actionID release ];
    [ action release ];
    actionID = NULL;
    action = NULL;
    
    target = NULL;
    sel = NULL;
    
    direction = MG_DIRECT_COUNT;
    
    onLoad = NO;
    UseDefault = YES;
}


@end



