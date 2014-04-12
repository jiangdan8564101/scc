//
//  BattleSpriteAction.m
//  sc
//
//  Created by fox on 13-2-13.
//
//



#import "BattleSpriteAction.h"
#import "ClientDefine.h"
#import "ActionConfig.h"

@implementation BattleSpriteAction


@synthesize ActionID = actionID , Owner = owner , UseAgain , UseAsync , NoClear , UseDefault , Texture;
@synthesize ActionIndex;

- ( CGRect ) getRect
{
    return textureRect;
}



- ( void ) setLoop:( BOOL )l
{
    loop = l;
}

- ( void ) clearAction
{
    ActionIndex = 0;
}


- ( BOOL ) playEffect:(NSObject *)t :(SEL)s
{
    if ( !inited )
    {
        return NO;
    }
    
    ActionIndex = 0;
    
    if ( !texture )
    {
        return NO;
    }
    
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
    
    animation = [ CCAnimation animationWithSpriteFrames:frameArray delay:spd / fc / GAME_SPEED ];
    animate = [ CCAnimate actionWithAnimation:animation ];
    
    [ owner runAction:[ CCSequence actionOne:animate two:[ CCCallFunc actionWithTarget:self selector:@selector(onEffectOver) ] ] ];
    
    return YES;
}

- ( BOOL ) setAction:( int )i
{
    if ( !inited )
    {
        return NO;
    }
    
    if ( ActionIndex == i && !UseAgain )
    {
        return NO;
    }
    
    ActionIndex = i;
    
    if ( !texture )
    {
        return NO;
    }
    
    int w = texture.pixelsWide;
    int h = texture.pixelsHigh;
    
    int xa = 0;
    int ya = 0;
    
    int xs = 0;
    int ys = 0;

    xa = w / width;
    ya = h / height;
    
    xs = 0;
    ys = i;
    
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
    }
    
    [ owner stopAllActions ];
    [ owner setDisplayFrame:[ frameArray objectAtIndex:0 ] ];
    
    animation = [ CCAnimation animationWithSpriteFrames:frameArray delay:spd / fc / GAME_SPEED ];
    animate = [ CCAnimate actionWithAnimation:animation ];
    
    [ owner runAction:[ CCRepeatForever actionWithAction:animate ] ];
    
    return YES;
}


- ( void ) onEffectOver
{
    if ( !NoClear )
    {
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
    width = [ [ actionDic objectForKey:@"w" ] intValue ];
    height = [ [ actionDic objectForKey:@"h" ] intValue ];
    fc = [ [ actionDic objectForKey:@"c" ] intValue ];
    spd = [ [ actionDic objectForKey:@"s" ] intValue ];
    
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
    
    onLoad = YES;
    int i = ActionIndex;
    ActionIndex = INVALID_ID;
    [ self setAction:i ];
    onLoad = NO;
}


- ( void ) initAction:( CCSprite* )o
{
    if ( inited )
    {
        return;
    }
    
    owner = o;
    
    ActionIndex = 0;
    
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
    actionID = NULL;
    
    target = NULL;
    sel = NULL;
    
    ActionIndex = 0;
    
    onLoad = NO;
    UseDefault = YES;
}


@end



