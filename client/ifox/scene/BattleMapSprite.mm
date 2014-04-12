//
//  BattleMapSprite.m
//  sc
//
//  Created by fox on 13-1-19.
//
//

#import "BattleMapSprite.h"
#import "BattleMapScene.h"
#import "BattleMapLayer.h"

@implementation BattleMapSprite


@synthesize TextureName , TexturePosX , TexturePosY , PosX , PosY , Type , Door , RegionID ;
@synthesize Creature , Sprite , MapLayer;


- ( void ) removeAllChildrenWithCleanup:(BOOL)cleanup
{
    [ maskArray removeAllObjects ];
    [ maskArray release ];
    maskArray = NULL;
    
    [ super removeAllChildrenWithCleanup:cleanup ];
    
    TexturePosX = 0;
    TexturePosY = 0;
    
    Type = 0;
    Door = 0;
    
    RegionID = 0;
    
    [ TextureName release ];
    TextureName = NULL;
    
    ACTMaskSprite = NULL;
    maskSprite = NULL;
    
    Creature = NULL;
    Sprite = NULL;
    
}


- ( void ) loadMask
{
    if ( TextureName )
    {
        if ( !maskArray )
        {
            maskArray = [ [ NSMutableArray alloc ] init ];
        }
        
        
        if ( !RegionID )
        {
            return;
        }
        
        CCTexture2D* texture = MapLayer.MaskTexture;
        
        BattleMapSprite* spriteUp = [ MapLayer getSprite:PosX : PosY - 1 ];
        BattleMapSprite* spriteDown = [ MapLayer getSprite:PosX : PosY + 1 ];
        BattleMapSprite* spriteLeft = [ MapLayer getSprite:PosX - 1 : PosY ];
        BattleMapSprite* spriteRight = [ MapLayer getSprite:PosX + 1 : PosY ];
        
        
        maskSprite = [ BattleMapMaskSprite node ];
        CGRect rect = CGRectMake( 52 , 52 , 100 , 100 );
        maskSprite.anchorPoint = ccp( 0 , 1.0 );
        maskSprite.RectMask = rect;
        [ maskSprite setTexture:NULL ];
        [ maskSprite setTextureRect:rect ];
        [ maskSprite setPosition:ccp( 0 , 100 ) ];
        [ maskSprite setZOrder:111 ];
        [ maskSprite setOpacity:200 ];        
        [ self addChild:maskSprite ];
                
        if ( ( !spriteUp || spriteUp.RegionID != RegionID )  && ( !spriteLeft || spriteLeft.RegionID != RegionID ) )
        {
            // 左上
            CGRect rect = CGRectMake( 2 , 2 , 50 , 50 );
            
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 0 , 100 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
            
            if ( spriteRight && spriteRight.RegionID == RegionID )
            {
                // 上右边
                CGRect rect = CGRectMake( 52 , 2 , 50 , 50 );
                
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 50 , 100 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
            
            
            if ( spriteDown && spriteDown.RegionID == RegionID )
            {
                // 左下边
                CGRect rect = CGRectMake( 2 , 52 , 50 , 50 );
                
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 0 , 50 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
            
        }
        
        if ( ( !spriteUp || spriteUp.RegionID != RegionID )  && ( spriteRight && spriteRight.RegionID == RegionID )  && ( spriteLeft && spriteLeft.RegionID == RegionID ) )
        {
            // 上
            
            CGRect rect = CGRectMake( 52 , 2 , 50 , 50 );

            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 0 , 100 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
            
            rect = CGRectMake( 104 , 2 , 50 , 50 );
            
            mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            mask.anchorPoint = ccp( 0 , 1.0 );
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 50 , 100 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
        }
        
        
        if ( ( !spriteUp || spriteUp.RegionID != RegionID )  && ( !spriteRight || spriteRight.RegionID != RegionID ) )
        {
            // 右上
            CGRect rect = CGRectMake( 154 , 2 , 50 , 50 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 50 , 100 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
            
            if ( spriteLeft && spriteLeft.RegionID == RegionID )
            {
                // 上左边
                CGRect rect = CGRectMake( 104 , 2 , 50 , 50 );
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 0 , 100 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
            
            if ( spriteDown && spriteDown.RegionID == RegionID )
            {
                // 右下边
                CGRect rect = CGRectMake( 154 , 52 , 50 , 50 );
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 50 , 50 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
        }
        
        
        if ( ( !spriteDown || spriteDown.RegionID != RegionID )  && ( !spriteLeft || spriteLeft.RegionID != RegionID ) )
        {
            // 左下
            CGRect rect = CGRectMake( 2 , 154 , 50 , 50 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 0 , 50 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
            
            if ( spriteUp && spriteUp.RegionID == RegionID )
            {
                // 左上边
                
                CGRect rect = CGRectMake( 2 , 104 , 50 , 50 );
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 0 , 100 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
            
            if ( spriteRight && spriteRight.RegionID == RegionID )
            {
                // 左下边
                CGRect rect = CGRectMake( 52 , 154 , 50 , 50 );
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 50 , 50 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
        }
        
        
        if ( ( !spriteDown || spriteDown.RegionID != RegionID )  && ( spriteRight && spriteRight.RegionID == RegionID )  && ( spriteLeft && spriteLeft.RegionID == RegionID ) )
        {
            // 下
            
            CGRect rect = CGRectMake( 52 , 154 , 50 , 50 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 0 , 50 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
            
            rect = CGRectMake( 104 , 154 , 50 , 50 );
            mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 50 , 50 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
        }
        
        
        if ( ( !spriteDown || spriteDown.RegionID != RegionID )  && ( !spriteRight || spriteRight.RegionID != RegionID ) )
        {
            // 右下
            
            CGRect rect = CGRectMake( 154 , 154 , 50 , 50 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 50 , 50 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
            
            if ( spriteLeft && spriteLeft.RegionID == RegionID )
            {
                // 左下边
                
                CGRect rect = CGRectMake( 104 , 154 , 50 , 50 );
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 0 , 50 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
            
            if ( spriteUp && spriteUp.RegionID == RegionID )
            {
                // 右上边
                
                CGRect rect = CGRectMake( 154 , 104 , 50 , 50 );
                BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
                mask.anchorPoint = ccp( 0 , 1.0 );
                mask.RectMask = rect;
                [ mask setTexture:texture ];
                [ mask setTextureRect:rect ];
                [ mask setPosition:ccp( 50 , 100 ) ];
                [ self addChild:mask ];
                [ maskArray addObject:mask ];
            }
            
        }
        
        if ( ( !spriteLeft || spriteLeft.RegionID != RegionID )  && ( spriteUp && spriteUp.RegionID == RegionID )  && ( spriteDown && spriteDown.RegionID == RegionID ) )
        {
            // 左
            CGRect rect = CGRectMake( 2 , 54 , 50 , 100 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 0 , 100 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
        }
        
        if ( ( !spriteRight || spriteRight.RegionID != RegionID )  && ( spriteUp && spriteUp.RegionID == RegionID )  && ( spriteDown && spriteDown.RegionID == RegionID ) )
        {
            // 右
            CGRect rect = CGRectMake( 154 , 54 , 50 , 100 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 50 , 100 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
        }
        
        
        // door
        
        
        if ( ( Door & DOOR_NORTH ) == DOOR_NORTH )
        {
            CGRect rect = CGRectMake( 209 , 59 , 35 , 22 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 33 , 100 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
            
        }
        if ( ( Door & DOOR_SOUTH ) == DOOR_SOUTH )
        {
            CGRect rect = CGRectMake( 209 , 35 , 35 , 20 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 33 , 20 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
        }
        if ( ( Door & DOOR_EAST ) == DOOR_EAST )
        {
            CGRect rect = CGRectMake( 209 , 0 , 22 , 35 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 78 , 67 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
        }
        if ( ( Door & DOOR_WEST ) == DOOR_WEST )
        {
            CGRect rect = CGRectMake( 231 , 0 , 22 , 35 );
            BattleMapMaskSprite* mask = [ BattleMapMaskSprite node ];
            mask.anchorPoint = ccp( 0 , 1.0 );
            mask.RectMask = rect;
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ mask setPosition:ccp( 0 , 67 ) ];
            [ self addChild:mask ];
            [ maskArray addObject:mask ];
        }
        
        ACTMaskSprite = [ CCSprite node ];
        [ self addChild:ACTMaskSprite z:11 ];
        
    }
    
    
}


- ( void ) addACTMask:( int )t
{
    switch ( t )
    {
        case BMSACTT_MOVE:
        {
            CCTexture2D* texture = [ [ CCTextureCache sharedTextureCache ] addImage:ACT_MOVE_MASK ];
            
            CGRect rect = CGRectMake( 0 , 0 , texture.pixelsWide , texture.pixelsHigh );
            
            CCSprite* mask = [ CCSprite node ];
            mask.anchorPoint = ccp( 0 , 0 );
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ ACTMaskSprite addChild:mask ];
            
            texture = [ [ CCTextureCache sharedTextureCache ] addImage:ACT_MOVE_MASKW ];
            
            rect = CGRectMake( 0 , 0 , texture.pixelsWide , texture.pixelsHigh );
            
            mask = [ CCSprite node ];
            mask.anchorPoint = ccp( 0 , 0 );
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ ACTMaskSprite addChild:mask ];
            
        }
            break;
        case BMSACTT_STAY:
        {
            CCTexture2D* texture = [ [ CCTextureCache sharedTextureCache ] addImage:ACT_MOVE_MASK ];
            
            CGRect rect = CGRectMake( 0 , 0 , texture.pixelsWide , texture.pixelsHigh );
            
            CCSprite* mask = [ CCSprite node ];
            mask.anchorPoint = ccp( 0 , 0 );
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ ACTMaskSprite addChild:mask ];
            
            texture = [ [ CCTextureCache sharedTextureCache ] addImage:ACT_MOVE_STAY ];
            
            rect = CGRectMake( 0 , 0 , texture.pixelsWide , texture.pixelsHigh );
            
            mask = [ CCSprite node ];
            mask.anchorPoint = ccp( 0 , 0 );
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ ACTMaskSprite addChild:mask ];
        }
            break;
        case BMSACTT_ATTACK:
        {
            CCTexture2D* texture = [ [ CCTextureCache sharedTextureCache ] addImage:ACT_MOVE_MASK ];
            
            CGRect rect = CGRectMake( 0 , 0 , texture.pixelsWide , texture.pixelsHigh );
            
            CCSprite* mask = [ CCSprite node ];
            mask.anchorPoint = ccp( 0 , 0 );
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ ACTMaskSprite addChild:mask ];
            
            texture = [ [ CCTextureCache sharedTextureCache ] addImage:ACT_MOVE_STAY ];
            
            rect = CGRectMake( 0 , 0 , texture.pixelsWide , texture.pixelsHigh );
            
            mask = [ CCSprite node ];
            mask.anchorPoint = ccp( 0 , 0 );
            [ mask setTexture:texture ];
            [ mask setTextureRect:rect ];
            [ ACTMaskSprite addChild:mask ];
        }
            break;
        case BMSACTT_ATTACK_SHOT:
        {
            
        }
            break;
        default:
            break;
    }
}

- ( void ) removeACTMask
{
    [ ACTMaskSprite removeAllChildrenWithCleanup:YES ];
}


- ( void ) setMaskGourp:( int )g
{
    if ( g )
    {
        [ maskSprite setTexture:NULL ];
        [ maskSprite setVisible:NO ];
    }
    else
    {
        [ maskSprite setTexture:MapLayer.MaskTexture ];
        [ maskSprite setGroup:GROUP_NULL ];
        [ maskSprite setVisible:YES ];
    }
    
    for ( int i = 0 ; i < maskArray.count ; ++i )
    {
        BattleMapMaskSprite* spr = [ maskArray objectAtIndex:i ];
        [ spr setGroup:g ];
    }
    
}

- ( void ) load:( NSObject* )obj :( SEL )s
{
    object = obj;
    sel = s;
    
    if ( TextureName )
    {
        NSString* path = [ NSString stringWithFormat:@"%@%@.png" , MAP_PATH , TextureName ];
        
        [ [ CCTextureCache sharedTextureCache ] addImageAsync:path target:self selector:@selector( onLoadTexture: ) ];
    }
}

- ( void ) onLoadTexture:( CCTexture2D* )t
{
    if ( !RegionID )
    {
        if ( t.pixelsHigh == 256 )
        {
            [ self setTexture:t ];
            [ self setTextureRect:CGRectMake( 50 , 50 , MAX_SPRITE_SIZE , MAX_SPRITE_SIZE ) ];
            self.anchorPoint = ccp( 0 , 1.0 );
            
            CGPoint point = ccp( PosX * MAX_SPRITE_SIZE , PosY * MAX_SPRITE_SIZE );
            point = [ [ CCDirector sharedDirector ] convertToGL:point ];
            [ self setPosition:point ];
            [ self setTextureCoords:CGRectMake( 54 , 54 , MAX_SPRITE_SIZE - 2 , MAX_SPRITE_SIZE - 2 ) ];
            
            [ object performSelectorOnMainThread:sel withObject:nil waitUntilDone:NO ];
        }
        else
        {
            if ( TexturePosX == 2 && TexturePosY == 2 )
            {
                [ self setTexture:t ];
                [ self setTextureRect:CGRectMake( 0 , 0 , MAX_SPRITE_SIZE , MAX_SPRITE_SIZE ) ];
                self.anchorPoint = ccp( 0 , 1.0 );
                
                CGPoint point = ccp( PosX * MAX_SPRITE_SIZE , PosY * MAX_SPRITE_SIZE );
                point = [ [ CCDirector sharedDirector ] convertToGL:point ];
                [ self setPosition:point ];
                [ self setTextureCoords:CGRectMake( 0 , 0 , 10 , 10 ) ];
                [ object performSelectorOnMainThread:sel withObject:nil waitUntilDone:NO ];
            }
            else
            {
                [ self setTexture:t ];
                [ self setTextureRect:CGRectMake( TexturePosX * MAX_SPRITE_SIZE + TexturePosX + 1 , TexturePosY * MAX_SPRITE_SIZE + TexturePosY + 1 , MAX_SPRITE_SIZE , MAX_SPRITE_SIZE ) ];
                self.anchorPoint = ccp( 0 , 1.0 );
                
                CGPoint point = ccp( PosX * MAX_SPRITE_SIZE , PosY * MAX_SPRITE_SIZE );
                point = [ [ CCDirector sharedDirector ] convertToGL:point ];
                [ self setPosition:point ];
                
                [ object performSelectorOnMainThread:sel withObject:nil waitUntilDone:NO ];
            }
            
        }
        return;
    }
    
    
     
    [ self setTexture:t ];
    [ self setTextureRect:CGRectMake( TexturePosX * MAX_SPRITE_SIZE , TexturePosY * MAX_SPRITE_SIZE , MAX_SPRITE_SIZE , MAX_SPRITE_SIZE ) ];
    self.anchorPoint = ccp( 0 , 1.0 );
    
    CGPoint point = ccp( PosX * MAX_SPRITE_SIZE , PosY * MAX_SPRITE_SIZE );
    point = [ [ CCDirector sharedDirector ] convertToGL:point ];
    [ self setPosition:point ];
    
    [ object performSelectorOnMainThread:sel withObject:nil waitUntilDone:NO ];
}

@end



