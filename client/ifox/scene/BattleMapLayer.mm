//
//  BattleMapLayer.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "BattleMapLayer.h"
#import "SceneUIHandler.h"
#import "CreatureConfig.h"
#import "BattleCreature.h"
#import "PathFinder.h"
#import "BattleSprite.h"
#import "BattleSpriteAction.h"
#import "BattleTopUIHandler.h"
#import "BattleNetHandler.h"
#import "netMsgDefine.h"
#import "GameCreatureAction.h"
#import "PlayerCreatureData.h"
#import "PlayerData.h"
#import "BattleStage.h"
#import "BattleEndItemUIHandler.h"
#import "BattleLogUIHandler.h"
#import "CreatureConfig.h"
#import "TimeUIHandler.h"
#import "ItemConfig.h"
#import "ItemData.h"
#import "PlayerCreatureData.h"
#import "TalkUIHandler.h"
#import "BattleMapScene.h"
#import "GameEventManager.h"

@implementation BattleMapLayer

@synthesize LayerIndex;
@synthesize ID , MaxX , MaxY , Mask , MaskTexture , RegionCount , BattleStart , BattleEnd , Creatures , SelfCreatures , OtherCreatures , EnemyCreatures , SPEnemyCreatures , BattleSprites , MovePath , ItemDic;
@synthesize Condition , Win , Lose , Active , LogUI , Finder;
@synthesize DropGold;

- ( void ) battleLog:( NSString* )str
{
    [ LogUI appandMsg:str ];
}

- ( void ) moveLayerReal:( float ) x :( float )y
{
    CGPoint toPoint = ccp( SCENE_WIDTH * 0.5f - x , y - SCENE_HEIGHT * 0.5f );
    
    if ( toPoint.x > 0 )
    {
        toPoint.x = 0;
    }
    
    if ( toPoint.y < 0 )
    {
        toPoint.y = 0;
    }
    
    
    if ( toPoint.x < SCENE_WIDTH - MaxX * MAX_SPRITE_SIZE )
    {
        toPoint.x = SCENE_WIDTH - MaxX * MAX_SPRITE_SIZE;
    }
    
    if ( toPoint.y > MaxY * MAX_SPRITE_SIZE - SCENE_HEIGHT )
    {
        toPoint.y = MaxY * MAX_SPRITE_SIZE - SCENE_HEIGHT;
    }
    
    [ self setPosition:toPoint ];
}

//- ( void ) moveLayer:( int ) x :( int )y
//{
//    CGPoint toPoint= ccp( SCENE_WIDTH * 0.5f - x * MAX_SPRITE_SIZE , y * MAX_SPRITE_SIZE - SCENE_HEIGHT * 0.5f );
//    
//    if ( toPoint.x > 0 )
//    {
//        toPoint.x = 0;
//    }
//    
//    if ( toPoint.y < 0 )
//    {
//        toPoint.y = 0;
//    }
//    
//    
//    if ( toPoint.x < SCENE_WIDTH - MaxX * MAX_SPRITE_SIZE )
//    {
//        toPoint.x = SCENE_WIDTH - MaxX * MAX_SPRITE_SIZE;
//    }
//    
//    if ( toPoint.y > MaxY * MAX_SPRITE_SIZE - SCENE_HEIGHT )
//    {
//        toPoint.y = MaxY * MAX_SPRITE_SIZE - SCENE_HEIGHT;
//    }
//    
//    [ self setPosition:toPoint ];
//    
//    if ( abs( (int)beginTouch.x - (int)toPoint.x ) + abs( (int)beginTouch.y - (int)toPoint.y ) > 15 )
//    {
//        isMoving = YES;
//    }
//    
//}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( !Active )
    {
        return NO;
    }
    
    beginTouch = [ self position ];
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( !Active )
    {
        return;
    }
    
    CGPoint beginPoint = [ touch locationInView:touch.view ];
    beginPoint = [ [ CCDirector sharedDirector ] convertToGL:beginPoint ];
    
    CGPoint endPoint = [ touch previousLocationInView:touch.view ];
    endPoint = [ [ CCDirector sharedDirector ] convertToGL:endPoint ];
    
    CGPoint offSet = ccpSub( beginPoint , endPoint );
    CGPoint toPoint= ccpAdd( self.position , offSet );
    
    if ( toPoint.x > 0 )
    {
        toPoint.x = 0;
    }
    
    if ( toPoint.y < 0 )
    {
        toPoint.y = 0;
    }
    
    
    if ( toPoint.x < SCENE_WIDTH - MaxX * MAX_SPRITE_SIZE )
    {
        toPoint.x = SCENE_WIDTH - MaxX * MAX_SPRITE_SIZE;
    }
    
    if ( toPoint.y > MaxY * MAX_SPRITE_SIZE - SCENE_HEIGHT )
    {
        toPoint.y = MaxY * MAX_SPRITE_SIZE - SCENE_HEIGHT;
    }
    
    [ self setPosition:toPoint ];
    
    if ( abs( (int)beginTouch.x - (int)toPoint.x ) + abs( (int)beginTouch.y - (int)toPoint.y ) > 15 )
    {
        isMoving = YES;
    }
}


- ( void ) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( !Active )
    {
        return;
    }
    
    if ( !isMoving )
    {
        BOOL b = [ touch.view isKindOfClass:[ CCGLView class ] ];
        
        if ( b )
        {
            CGPoint point1 = [ touch locationInView:touch.view ];
            CGPoint point = point1;
            
            point = [ [ CCDirector sharedDirector ] convertToGL:point ];
            
            point.x = point.x - self.position.x;
            point.y = point.y - self.position.y;
            
            point = [ [ CCDirector sharedDirector ] convertToUI:point ];
            
            point.x = (int)( ( point.x ) / MG_GRID_X );
            point.y = (int)( ( point.y ) / MG_GRID_Y );
            
        }
        
    }
    
    isMoving = NO;
}


- ( void ) initLayer
{
    self.anchorPoint = ccp( 0 , 1.0 );
    
    mapLayer = [ CCLayer node ];
    middleLayer = [ CCLayer node ];
    creatureLayer = [ CCLayer node ];
    
    for ( int i = 0 ; i < MAX_SPRITE ; i++ )
    {
        for ( int j = 0 ; j < MAX_SPRITE ; j++ )
        {
//            sprites[ i ][ j ] = [ BattleMapSprite node ];
//            sprites[ i ][ j ] = sprites[ i ][ j ].retain;
//            sprites[ i ][ j ].MapLayer = self;
//            
//            sprites[ i ][ j ].PosX = j;
//            sprites[ i ][ j ].PosY = i;
//            
//            [ mapLayer addChild:sprites[ i ][ j ] ];
        }
    }
    
    for ( int i = 0 ; i < MAX_REGION ; i++ )
    {
        regions[ i ] = [ [ BattleMapRegion alloc ] init ];
        [ regions[ i ] initBattleMapRegion ];
    }
    
    [ self addChild:mapLayer ];
    [ self addChild:middleLayer ];
    [ self addChild:creatureLayer ];
    
    //creatureLayer.isTouchEnabled = YES;
    
    Condition = [ [ NSMutableArray alloc ] init ];
    Win = [ [ NSMutableArray alloc ] init ];
    Lose = [ [ NSMutableArray alloc ] init ];
    Creatures = [ [ NSMutableArray alloc ] init ];
    SelfCreatures = [ [ NSMutableArray alloc ] init ];
    OtherCreatures = [ [ NSMutableArray alloc ] init ];
    BattleSprites = [ [ NSMutableArray alloc ] init ];
    MovePath = [ [ NSMutableArray alloc] init ];
    ItemDic = [ [ NSMutableDictionary alloc ] init ];
    
    team = INVALID_ID;
    
    battleStage = [ [ BattleStage alloc ] init ];
    [ battleStage initBattleStage:self ];
    battleStage.LogUI = LogUI;
    
    Finder = [ [ PathFinderO alloc ] init ];
    [ Finder initFinder ];
}


- ( BattleMapSprite* ) getSprite:( int ) x :( int ) y
{
    if ( x < 0 || y < 0 )
    {
        return NULL;
    }
    
    if ( x >= MaxX || y >= MaxY )
    {
        return NULL;
    }
    
    return sprites[ y ][ x ];
}

- ( void ) setEnemy:( int )e
{
    [ sceneDataItem setEnemy:e ];
}

- ( BOOL ) getEnemy:( int )e
{
    return [ sceneDataItem getEnemy:e ];
}

- ( void ) loadSP
{
    [ self clear ];
    
    team = INVALID_ID;
    
    subSceneMap = [ [ MapConfig instance ] getSubSceneMap:SPECIAL_ITEM ];
    sceneDataItem = [ SceneData instance ].SPSceneDataItem;
    
    //[ subSceneMap.Enemy removeAllObjects ];
    //[ subSceneMap.SPEnemy removeAllObjects ];
    //[ subSceneMap.Treasure removeAllObjects ];
    
    [ sceneDataItem.TreasureDic removeAllObjects ];
    
    [ subSceneMap.Dig removeAllObjects ];
    [ subSceneMap.Collect removeAllObjects ];
    
    
    
    
    NSMutableDictionary* scenes = [ MapConfig instance ].Scenes;
    for ( int i = 0 ; i < scenes.count ; ++i )
    {
        SceneMap* sceneMap = [ scenes.allValues objectAtIndex:i ];
        
        if ( sceneMap.WorkRank <= [ PlayerData instance ].WorkRank )
        {
            for ( int j = 0 ; j < sceneMap.SubScenes.count ; ++j )
            {
                SubSceneMap* sub = [ sceneMap.SubScenes objectAtIndex:j ];
                
                if ( subSceneMap == sub )
                {
                    continue;
                }
                
                for ( int k = 0 ; k < sub.Dig.count ; k++ )
                {
                    CreatureBaseIDPerNum* drop = [ sub.Dig objectAtIndex:k ];
                    [ subSceneMap.Dig addObject:drop  ];
                }
                
                for ( int k = 0 ; k < sub.Dig.count ; k++ )
                {
                    CreatureBaseIDPerNum* drop = [ sub.Collect objectAtIndex:k ];
                    [ subSceneMap.Collect addObject:drop  ];
                }
                
            }
        }
    }
    
    
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:@"sp" ofType:@"xml" inDirectory:SCENE_PATH ];
    
    if ( !path )
    {
        return;
    }
    
    NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
    
    if ( !file )
    {
        return;
    }
    
    NSData* data = [ file readDataToEndOfFile ];
    [ file closeFile ];
    
    //NSData* data = loadXML( [ NSString stringWithFormat:@"%@%d" , SCENE_PATH , i ] );
    
    if ( !data )
    {
        return;
    }
    
    readRR = 0;
    readM = 0;
    readR = 0;
    readS = 0;
    readF = 0;
    readFO = 0;
    readN = 0;
    
    NSXMLParser* parser = [ [ NSXMLParser alloc ] initWithData:data ];
    [ parser setDelegate:(id <NSXMLParserDelegate>)self];
    [ parser parse ];
    [ parser release ];
    
    
    [ self loadMap ];
    [ self loadPath ];
    
    path = [ NSString stringWithFormat:@"%@/%@.png" , MAP_PATH , Mask ];
    
    [ [ CCTextureCache sharedTextureCache ] addImageAsync:path target:self selector:@selector( onLoadMaskTexture: ) ];
    
    EnemyCreatures = subSceneMap.Enemy;
    SPEnemyCreatures = subSceneMap.SPEnemy;
    
    moveSmartPer = 0;
    moveSmartRandom = NO;
    moveSmart1 = NO;
    moveSmart2 = NO;
    moveSmart3 = NO;
    moveSmart4 = NO;
    
    switch ( leader.CommonData.CharacterType )
    {
        case GCCT_SERIOUS:
            moveSmartPer = 10;
            moveSmart1 = YES;
            moveSmart2 = YES;
            moveSmart3 = YES;
            moveSmart4 = YES;
            break;
        case GCCT_CAUTIOUS:
            moveSmartPer = 0;
            moveSmart1 = YES;
            moveSmart2 = YES;
            moveSmart3 = YES;
            moveSmart4 = YES;
            break;
        case GCCT_CALLOUS:
            moveSmartPer = 30;
            break;
        case GCCT_HAUGHTY:
            moveSmartPer = 30;
            moveSmart2 = YES;
            break;
        case GCCT_STRANGE:
            moveSmartPer = 30;
            moveSmart4 = YES;
            break;
        case GCCT_ACTIVE:
            moveSmartPer = 30;
            moveSmart2 = YES;
            moveSmart4 = YES;
            break;
        case GCCT_FEARLESS:
            moveSmartPer = 50;
            break;
        case GCCT_LIVELY:
            break;
            moveSmartPer = 25;
        default:
            break;
    }

}

- ( void ) load:( int )i :( int )t
{
    [ self clear ];
    
    team = t;
    
    subSceneMap = [ [ MapConfig instance ] getSubSceneMap:i ];
    sceneDataItem = [ [ SceneData instance ] getSceneData:i ];
    
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:[ NSString stringWithFormat:@"%d" , i ] ofType:@"xml" inDirectory:SCENE_PATH ];
    
    if ( !path )
    {
        return;
    }
    
    NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
    
    if ( !file )
    {
        return;
    }
    
    NSData* data = [ file readDataToEndOfFile ];
    [ file closeFile ];
    
    //NSData* data = loadXML( [ NSString stringWithFormat:@"%@%d" , SCENE_PATH , i ] );
    
    if ( !data )
    {
        return;
    }
    
    readRR = 0;
    readM = 0;
    readR = 0;
    readS = 0;
    readF = 0;
    readFO = 0;
    readN = 0;
    
    NSXMLParser* parser = [ [ NSXMLParser alloc ] initWithData:data ];
    [ parser setDelegate:(id <NSXMLParserDelegate>)self];
    [ parser parse ];
    [ parser release ];
    
    
    [ self loadMap ];
    [ self loadPath ];
    
    path = [ NSString stringWithFormat:@"%@/%@.png" , MAP_PATH , Mask ];
    
    [ [ CCTextureCache sharedTextureCache ] addImageAsync:path target:self selector:@selector( onLoadMaskTexture: ) ];
    
    EnemyCreatures = subSceneMap.Enemy;
    SPEnemyCreatures = subSceneMap.SPEnemy;
    
    moveSmartPer = 0;
    moveSmartRandom = NO;
    moveSmart1 = NO;
    moveSmart2 = NO;
    moveSmart3 = NO;
    moveSmart4 = NO;
    
    switch ( leader.CommonData.CharacterType )
    {
        case GCCT_SERIOUS:
            moveSmartPer = 10;
            moveSmart1 = YES;
            moveSmart2 = YES;
            moveSmart3 = YES;
            moveSmart4 = YES;
            break;
        case GCCT_CAUTIOUS:
            moveSmartPer = 0;
            moveSmart1 = YES;
            moveSmart2 = YES;
            moveSmart3 = YES;
            moveSmart4 = YES;
            break;
        case GCCT_CALLOUS:
            moveSmartPer = 30;
            break;
        case GCCT_HAUGHTY:
            moveSmartPer = 30;
            moveSmart2 = YES;
            break;
        case GCCT_STRANGE:
            moveSmartPer = 30;
            moveSmart4 = YES;
            break;
        case GCCT_ACTIVE:
            moveSmartPer = 30;
            moveSmart2 = YES;
            moveSmart4 = YES;
            break;
        case GCCT_FEARLESS:
            moveSmartPer = 50;
            break;
        case GCCT_LIVELY:
            break;
            moveSmartPer = 25;
        default:
            break;
    }
}


- ( void ) onLoadMaskTexture:( CCTexture2D* )t
{
    MaskTexture = t.retain;
    
    [ self loadMaskMap ];
    
    [ self startBattle ];
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ( [ elementName isEqualToString:@"condition" ] )
    {
        int c0 = [ [ attributeDict objectForKey:@"c0" ] intValue ];
        if ( c0 )
        {
            [ Condition addObject:[ NSNumber numberWithInt:c0 ] ];
        }
        int c1 = [ [ attributeDict objectForKey:@"c1" ] intValue ];
        if ( c1 )
        {
            [ Condition addObject:[ NSNumber numberWithInt:c1 ] ];
        }
        int c2 = [ [ attributeDict objectForKey:@"c2" ] intValue ];
        if ( c2 )
        {
            [ Condition addObject:[ NSNumber numberWithInt:c2 ] ];
        }
        int c3 = [ [ attributeDict objectForKey:@"c3" ] intValue ];
        if ( c3 )
        {
            [ Condition addObject:[ NSNumber numberWithInt:c3] ];
        }
        return;
    }
    
    if ( [ elementName isEqualToString:@"win" ] )
    {
        int w0 = [ [ attributeDict objectForKey:@"w0" ] intValue ];
        if ( w0 )
        {
            [ Win addObject:[ NSNumber numberWithInt:w0 ] ];
        }
        int w1 = [ [ attributeDict objectForKey:@"w1" ] intValue ];
        if ( w1 )
        {
            [ Win addObject:[ NSNumber numberWithInt:w1 ] ];
        }
        int w2 = [ [ attributeDict objectForKey:@"w2" ] intValue ];
        if ( w2 )
        {
            [ Win addObject:[ NSNumber numberWithInt:w2 ] ];
        }
        return;
    }
    
    if ( [ elementName isEqualToString:@"lose" ] )
    {
        int l0 = [ [ attributeDict objectForKey:@"l0" ] intValue ];
        if ( l0 )
        {
            [ Lose addObject:[ NSNumber numberWithInt:l0 ] ];
        }
        int l1 = [ [ attributeDict objectForKey:@"l1" ] intValue ];
        if ( l1 )
        {
            [ Lose addObject:[ NSNumber numberWithInt:l1 ] ];
        }
        int l2 = [ [ attributeDict objectForKey:@"l2" ] intValue ];
        if ( l2 )
        {
            [ Lose addObject:[ NSNumber numberWithInt:l2 ] ];
        }
        return;
    }
    
    if ( [ elementName isEqualToString:[ NSString stringWithFormat:@"f%d" , readF ] ]  )
    {
        int t = [ [ attributeDict objectForKey:@"t" ] intValue ];
        int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
        int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
        
        readF++;
        
        switch ( t )
        {
            case GSFT_Home:
            {
                BattleSprite* bs = [ BattleSprite node ];
                [ bs initBattleSprite ];
                bs.Type = t;
                [ BattleSprites addObject:bs ];
                
                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ bs setActionID:@"MO001A" ];
                [ bs setAction:GROUP_PLAYER ];
                [ bs setPos:x :y ];
                [ bs setGroup:GROUP_PLAYER ];
                
                [ middleLayer addChild:bs ];
                
                [ self setMapSpriteSprite:x :y :bs ];
            }
                break;
            case GSFT_Collect:
            {
                BattleSprite* bs = [ BattleSprite node ];
                bs.Type = t;
                [ bs initBattleSprite ];
                [ BattleSprites addObject:bs ];
                
                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ bs setActionID:@"MO032B" ];
                [ bs setAction:GROUP_NULL ];
                [ bs setPos:x :y ];
                [ bs setGroup:GROUP_PLAYER ];
                
                [ middleLayer addChild:bs ];
                
                [ self setMapSpriteSprite:x :y :bs ];
            }
                break;
            case GSFT_Dig:
            {
                BattleSprite* bs = [ BattleSprite node ];
                bs.Type = t;
                [ bs initBattleSprite ];
                [ BattleSprites addObject:bs ];
                
                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ bs setActionID:@"MO033B" ];
                [ bs setAction:GROUP_NULL ];
                [ bs setPos:x :y ];
                [ bs setGroup:GROUP_PLAYER ];
                
                [ middleLayer addChild:bs ];
                
                [ self setMapSpriteSprite:x :y :bs ];
                
            }
                break;
            case GSFT_Treasure:
            {
                if ( !subSceneMap.Treasure.count )
                {
                    break;
                }
                
                BattleSprite* bs = [ BattleSprite node ];
                [ bs initBattleSprite ];
                bs.Type = t;
                [ BattleSprites addObject:bs ];
                
                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ bs setActionID:@"MO053A" ];
                [ bs setAction:[ sceneDataItem getTreasure:[ Finder getIndex:x :y ] ] ? 1 : 0 ];
                
                [ bs setPos:x :y ];
                [ bs setGroup:GROUP_PLAYER ];
                
                [ middleLayer addChild:bs ];
                
                [ self setMapSpriteSprite:x :y :bs ];
            }
                break;
            case GSFT_Door1:
            {
                BattleSprite* bs = [ BattleSprite node ];
                [ bs initBattleSprite ];
                bs.Type = t;
                [ BattleSprites addObject:bs ];
                
                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ bs setActionID:@"MO012A" ];
                [ bs setAction:[ sceneDataItem getDoor:[ Finder getIndex:x :y ] ] ? 1 : 0 ];
                [ bs setPos:x :y ];
                [ bs setGroup:GROUP_PLAYER ];
                
                [ middleLayer addChild:bs ];
                
                [ self setMapSpriteSprite:x :y :bs ];
            }
                break;
            case GSFT_Door2:
            {
                BattleSprite* bs = [ BattleSprite node ];
                [ bs initBattleSprite ];
                bs.Type = t;
                [ BattleSprites addObject:bs ];
                
                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ bs setActionID:@"MO013A" ];
                [ bs setAction:[ sceneDataItem getDoor:[ Finder getIndex:x :y ] ] ? 1 : 0 ];
                [ bs setPos:x :y ];
                [ bs setGroup:GROUP_PLAYER ];
                
                [ middleLayer addChild:bs ];
                
                [ self setMapSpriteSprite:x :y :bs ];
            }
                break;
            case GSFT_Door3:
            {
                BattleSprite* bs = [ BattleSprite node ];
                [ bs initBattleSprite ];
                bs.Type = t;
                [ BattleSprites addObject:bs ];
                
                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ bs setActionID:@"MO014A" ];
                [ bs setAction:[ sceneDataItem getDoor:[ Finder getIndex:x :y ] ] ? 1 : 0 ];
                
                [ bs setPos:x :y ];
                [ bs setGroup:GROUP_PLAYER ];
                
                [ middleLayer addChild:bs ];
                
                [ self setMapSpriteSprite:x :y :bs ];
            }
                break;
//            case GSFT_Trap1:
//            {
//                BattleSprite* bs = [ BattleSprite node ];
//                [ bs initBattleSprite ];
//                bs.Type = t;
//                [ BattleSprites addObject:bs ];
//                
//                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
//                [ bs setActionID:@"MO017A" ];
//                [ bs setAction:GROUP_PLAYER ];
//                [ bs setPos:x :y ];
//                [ bs setGroup:GROUP_PLAYER ];
//                
//                [ middleLayer addChild:bs ];
//                
//                [ self setMapSpriteSprite:x :y :bs ];
//            }
//                break;
//            case GSFT_Trap2:
//            {
//                BattleSprite* bs = [ BattleSprite node ];
//                [ bs initBattleSprite ];
//                bs.Type = t;
//                [ BattleSprites addObject:bs ];
//                
//                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
//                [ bs setActionID:@"MO018A" ];
//                [ bs setAction:GROUP_PLAYER ];
//                [ bs setPos:x :y ];
//                [ bs setGroup:GROUP_PLAYER ];
//                
//                [ middleLayer addChild:bs ];
//                
//                [ self setMapSpriteSprite:x :y :bs ];
//            }
//                break;
//            case GSFT_Trap3:
//            {
//                BattleSprite* bs = [ BattleSprite node ];
//                [ bs initBattleSprite ];
//                bs.Type = t;
//                [ BattleSprites addObject:bs ];
//                
//                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
//                [ bs setActionID:@"MO019A" ];
//                [ bs setAction:GROUP_PLAYER ];
//                [ bs setPos:x :y ];
//                [ bs setGroup:GROUP_PLAYER ];
//                
//                [ middleLayer addChild:bs ];
//                
//                [ self setMapSpriteSprite:x :y :bs ];
//            }
//                break;
//            case GSFT_Trap4:
//            {
//                BattleSprite* bs = [ BattleSprite node ];
//                [ bs initBattleSprite ];
//                bs.Type = t;
//                [ BattleSprites addObject:bs ];
//                
//                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
//                [ bs setActionID:@"MO020A" ];
//                [ bs setAction:GROUP_PLAYER ];
//                [ bs setPos:x :y ];
//                [ bs setGroup:GROUP_PLAYER ];
//                
//                [ middleLayer addChild:bs ];
//                
//                [ self setMapSpriteSprite:x :y :bs ];
//            }
//                break;
//            case GSFT_Trap5:
//            {
//                BattleSprite* bs = [ BattleSprite node ];
//                [ bs initBattleSprite ];
//                bs.Type = t;
//                [ BattleSprites addObject:bs ];
//                
//                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
//                [ bs setActionID:@"MO021A" ];
//                [ bs setAction:GROUP_PLAYER ];
//                [ bs setPos:x :y ];
//                [ bs setGroup:GROUP_PLAYER ];
//                
//                [ middleLayer addChild:bs ];
//                
//                [ self setMapSpriteSprite:x :y :bs ];
//            }
//                break;
//            case GSFT_Trap6:
//            {
//                BattleSprite* bs = [ BattleSprite node ];
//                [ bs initBattleSprite ];
//                bs.Type = t;
//                [ BattleSprites addObject:bs ];
//                
//                [ bs setAnchorPoint:ccp( 0 , 1.0f ) ];
//                [ bs setActionID:@"MO022A" ];
//                [ bs setAction:GROUP_PLAYER ];
//                [ bs setPos:x :y ];
//                [ bs setGroup:GROUP_PLAYER ];
//                
//                [ middleLayer addChild:bs ];
//                
//                [ self setMapSpriteSprite:x :y :bs ];
//            }
//                break;
            case GSFT_Boss:
            {
                int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
                int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
                
                BattleCreature* creature = [ BattleCreature node ];
                creature.MapLayer = self;
                
                [ creature initCreature ];
                
                CreatureCommonData* commonData = [ [ CreatureConfig instance ] getCommonData:subSceneMap.BossID ].copy;
                
                creature.CommonData = commonData.retain;
                [ commonData release ];
                
                if ( !commonData )
                {
                    return;
                    assert( 0 );
                }
                
                
                [ creature setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ creature setActionID:creature.CommonData.Action ];
                [ creature setAction:CAT_STAND :MG_SOUTH ];
                [ creature setPos:x :y ];
                [ creature setOriginalPos:x :y ];
                [ creature setBOSS:subSceneMap.BossID ];
                [ creature setGroup:GROUP_ENEMY ];
                
                
                [ creatureLayer addChild:creature ];
                
                [ self setMapSpriteCreature:x :y :creature ];
                
                [ Creatures addObject:creature ];
                [ OtherCreatures addObject:creature ];
            }
                break;
            case GSFT_SP:
            {
                if ( LayerIndex != 0 )
                {
                    break;
                }
                
                //[ [ GameEventManager instance ] checkBattleEvent:subSceneMap.ID ];
                
                EventConfigData* event = [ GameEventManager instance ].ActiveEvent;
                
                if ( !event )
                {
                    break;
                }
                
                if ( event.StartGuide )
                {
                    [ [ TalkUIHandler instance ] visible:YES ];
                    [ [ TalkUIHandler instance ] setData:event.StartGuide ];
                }
                
                int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
                int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
                
                BattleCreature* creature = [ BattleCreature node ];
                creature.MapLayer = self;
                
                [ creature initCreature ];
                
                CreatureCommonData* commonData = [ [ CreatureConfig instance ] getCommonData:event.BattleMonster ].copy;
                
                creature.CommonData = commonData.retain;
                [ commonData release ];
                
                if ( !commonData )
                {
                    return;
                    assert( 0 );
                }
                
                [ creature setAnchorPoint:ccp( 0 , 1.0f ) ];
                [ creature setActionID:creature.CommonData.Action ];
                [ creature setAction:CAT_STAND :MG_SOUTH ];
                [ creature setPos:x :y ];
                [ creature setOriginalPos:x :y ];
                [ creature setEvent:event.BattleMonster ];
                [ creature setGroup:GROUP_ENEMY ];
                
                [ creatureLayer addChild:creature ];
                
                [ self setMapSpriteCreature:x :y :creature ];
                
                [ Creatures addObject:creature ];
                [ OtherCreatures addObject:creature ];
            }
                break;

            default:
                break;
        }
        return;
    }


    if ( [ elementName isEqualToString:[ NSString stringWithFormat:@"fo%d" , readFO ] ] )
    {
        readFO++;
        
        if ( team == INVALID_ID )
        {
            CreatureCommonData* commonData1 = [ [ PlayerCreatureData instance ] getCommonDataWithID:MAIN_PLAYER_ID16 ];
            
            if ( !commonData1 )
            {
                commonData1 = [ [ CreatureConfig instance ] getCommonData:MAIN_PLAYER_ID16 ];
            }
            
            [ commonData1 resetData ];
            [ battleStage addSelfCreature:commonData1 ];
            
            BattleCreature* creature = [ BattleCreature node ];
            creature.MapLayer = self;
            
            [ creature initCreature ];
            
            int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
            int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
            int g = [ [ attributeDict objectForKey:@"g" ] intValue ];
            
            [ creature setAnchorPoint:ccp( 0 , 1.0f ) ];
            [ creature setActionID:commonData1.Action ];
            [ creature setAction:CAT_STAND :MG_SOUTH ];
            [ creature setPos:x :y ];
            [ creature setOriginalPos:x :y ];
            creature.CommonData = commonData1.retain;
            [ creature setGroup:g ];
            [ creature setBOSS:F_FALSE ];
            
            [ creatureLayer addChild:creature ];
            
            [ Creatures addObject:creature ];
            [ SelfCreatures addObject:creature ];
            
            [ self setMapSpriteCreature:x :y :creature ];
            
            leader = creature;
            
            CGPoint toPoint = ccp( x * MG_GRID_X + MG_GRID_X_HALF , y * MG_GRID_Y + MG_GRID_Y_HALF );
            [ self moveLayerReal:toPoint.x :toPoint.y ];
            isMoving = NO;

            return;
        }
        
        int* team1 = [ [ PlayerCreatureData instance ] getTeam:team ];
        
        for ( int i = 0 ; i < MAX_BATTLE_PLAYER ; ++i )
        {
            if ( team1[ i ] )
            {
                CreatureCommonData* commonData1 = [ [ PlayerCreatureData instance ] getCommonData:team1[ i ] ];
                
                [ battleStage addSelfCreature:commonData1 ];
                
                //[ commonData1 release ];
                
                if ( i == 0 )
                {
                    BattleCreature* creature = [ BattleCreature node ];
                    creature.MapLayer = self;
                    
                    [ creature initCreature ];
                    
                    int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
                    int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
                    int g = [ [ attributeDict objectForKey:@"g" ] intValue ];
                    
                    [ creature setAnchorPoint:ccp( 0 , 1.0f ) ];
                    [ creature setActionID:commonData1.Action ];
                    [ creature setAction:CAT_STAND :MG_SOUTH ];
                    [ creature setPos:x :y ];
                    [ creature setOriginalPos:x :y ];
                    creature.CommonData = commonData1.retain;
                    [ creature setGroup:g ];
                    [ creature setBOSS:F_FALSE ];
                    
                    [ creatureLayer addChild:creature ];
                    
                    [ Creatures addObject:creature ];
                    [ SelfCreatures addObject:creature ];
                    
                    [ self setMapSpriteCreature:x :y :creature ];
                    
                    leader = creature;
                    
                    CGPoint toPoint = ccp( x * MG_GRID_X + MG_GRID_X_HALF , y * MG_GRID_Y + MG_GRID_Y_HALF );
                    [ self moveLayerReal:toPoint.x :toPoint.y ];
                    isMoving = NO;
                }
                
                
            }
            
        }
        
        
        return;
    }
    
    
    if ( [ elementName isEqualToString:@"map" ] )
    {
        if ( LayerIndex == 0 )
        {
            [ [ GameAudioManager instance ] playMusic:[ attributeDict objectForKey:@"bgm" ] :0 ];
        }
        
        
        ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        Mask = [ [ NSString alloc ] initWithFormat:@"SO011%@" , [ attributeDict objectForKey:@"mask" ] ];
        MaxX = [ [ attributeDict objectForKey:@"maxX" ] intValue ];
        MaxY = [ [ attributeDict objectForKey:@"maxY" ] intValue ];
        RegionCount = [ [ attributeDict objectForKey:@"count" ] intValue ];
        
        [ Finder setMapMaxXY:MaxX :MaxY ];
        
        for ( int i = 0 ; i < MaxY ; i++ )
        {
            for ( int j = 0 ; j < MaxX ; j++ )
            {
                sprites[ i ][ j ] = [ BattleMapSprite node ];
                sprites[ i ][ j ].MapLayer = self;
                
                sprites[ i ][ j ].PosX = j;
                sprites[ i ][ j ].PosY = i;
                
                [ mapLayer addChild:sprites[ i ][ j ] ];
            }
        }
        
        readR = 0;
        readS = 0;
        return;
    }
    
    if ( [ elementName isEqualToString:[ NSString stringWithFormat:@"region%d" , readR ] ] )
    {
        int rr = [ [ attributeDict objectForKey:@"id" ] intValue ];
        regions[ rr ].RegionID = rr;
        int SpriteCount = [ [ attributeDict objectForKey:@"count" ] intValue ];
        
        spriteCount += SpriteCount;
        
        readRR = rr;
        
        readS = 0;
        readR++;
        return;
    }
    
    if ( [ elementName isEqualToString:[ NSString stringWithFormat:@"r%d" , readS ] ] )
    {
        int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
        int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
        
        BattleMapSprite* sprite = sprites[ y ][ x ];
        
        sprite.Door = [ [ attributeDict objectForKey:@"d" ] intValue ];
        sprite.Type = [ [ attributeDict objectForKey:@"t" ] intValue ];
        
        sprite.TextureName = [ [ attributeDict objectForKey:@"tid" ] retain ];
        
        sprite.TexturePosX = [ [ attributeDict objectForKey:@"tx" ] intValue ];
        sprite.TexturePosY = [ [ attributeDict objectForKey:@"ty" ] intValue ];
        
        sprite.RegionID = [ [ attributeDict objectForKey:@"r" ] intValue ];
        
        readS++;
        
        [ regions[ readRR ].Sprites addObject:sprite ];
        
        [ MovePath addObject:sprite ];
        
        return;
    }
    
    if ( [ elementName isEqualToString:[ NSString stringWithFormat:@"m%d" , readM ] ] )
    {
        int x = [ [ attributeDict objectForKey:@"x" ] intValue ];
        int y = [ [ attributeDict objectForKey:@"y" ] intValue ];
        
        BattleMapSprite* sprite = sprites[ y ][ x ];
        
        sprite.TextureName = [ [ attributeDict objectForKey:@"tid" ] retain ];
        
        sprite.TexturePosX = [ [ attributeDict objectForKey:@"tx" ] intValue ];
        sprite.TexturePosY = [ [ attributeDict objectForKey:@"ty" ] intValue ];
        
        readM++;
        return;
    }
}


- ( void ) onLoadMap
{
    
}


- ( void ) loadPath
{
    string path;
    
    for ( int i = 0 ; i < MaxY ; i++ )
    {
        for ( int j = 0 ; j < MaxX ; j++ )
        {
            char c = 0;
            BattleMapSprite* sprite = [ self getSprite:j :i ];
            BattleMapSprite* sprite1 = [ self getSprite:j :i - 1 ];
            
            if ( ( sprite1 && sprite.RegionID != 0 && sprite.RegionID == sprite1.RegionID ) || ( sprite.Door & DOOR_NORTH ) == DOOR_NORTH )
            {
                c += DOOR_NORTH;
            }
            
            sprite1 = [ self getSprite:j :i + 1 ];
            
            if ( ( sprite1 && sprite.RegionID != 0 && sprite.RegionID == sprite1.RegionID ) || ( sprite.Door & DOOR_SOUTH ) == DOOR_SOUTH )
            {
                c += DOOR_SOUTH;
            }
            
            sprite1 = [ self getSprite:j - 1 :i  ];
            
            if ( ( sprite1 && sprite.RegionID != 0 && sprite.RegionID == sprite1.RegionID ) || ( sprite.Door & DOOR_WEST ) == DOOR_WEST )
            {
                c += DOOR_WEST;
            }
            
            sprite1 = [ self getSprite:j + 1 :i ];
            
            if ( ( sprite1 && sprite.RegionID != 0 && sprite.RegionID == sprite1.RegionID ) || ( sprite.Door & DOOR_EAST ) == DOOR_EAST )
            {
                c += DOOR_EAST;
            }
            
            
            if ( sprite.Sprite && ( sprite.Sprite.Type == GSFT_Door1 || sprite.Sprite.Type == GSFT_Door2 || sprite.Sprite.Type == GSFT_Door3 ) )
            {
                BOOL b = [ sceneDataItem getDoor:[ Finder getIndex:j :i ] ];
                BOOL bb = [ leader checkDoor:sprite.Sprite.Type ];
                
                if ( !b && !bb )
                {
                    c = DOOR_NOPath;
                }
            }
            
            
            switch ( sprite.Type )
            {
                case GSMT_Null:
                    break;
                case GSMT_No:
                {
                    [ sceneDataItem setData:[ Finder getIndex:j :i ] ];
                    c = DOOR_NOPath;
                }
                    break;
                default:
                {
                    BOOL b = [ leader checkTerrain:sprite.Type ];
                    
                    if ( !b )
                    {
                        c = DOOR_NOPath;
                    }
                }
                    break;
            }
            
            if ( !c )
            {
                c = DOOR_NOPath;
            }
            
            
            path += c;
        }
    }
    
    [ Finder initMap:path.c_str() :MaxX :MaxY ];
    
    //[ PathFinerO setMap:DOOR_NOPath :5 :6 ];
    //[ PathFinerO setMap:DOOR_NOPath :5 :8 ];
}


- ( void ) loadMaskMap
{
    for ( int i = 0 ; i < MAX_SPRITE ; i++ )
    {
        for ( int j = 0 ; j < MAX_SPRITE ; j++ )
        {
            [ sprites[ i ][ j ] loadMask ];
            
            int index = [ Finder getIndex:j :i ];
            BOOL b = [ sceneDataItem getData:index ];
            
            if ( b )
            {
                [ sprites[ i ][ j ] setMaskGourp:GROUP_PLAYER ];
                continue;
            }
            
            if ( !sprites[ i ][ j ].Creature && !sprites[ i ][ j ].Sprite )
            {
                [ sprites[ i ][ j ] setMaskGourp:GROUP_NULL ];
            }
            else
            {
                [ sprites[ i ][ j ] setMaskGourp:GROUP_PLAYER ];
            }
            
        }
    }
    
    [ self updatePer ];
    //BattleMapSprite* spr = [ MovePath objectAtIndex:leaderMove ];
    //[ leader startMove:spr.PosX :spr.PosY :self :@selector(onMoveEnd) ];
}


- ( void ) showWin:( BOOL )b
{
    BattleEnd = YES;
    battleWin = b;
    
    [ self showEndItemUI ];
}


- ( void ) showEndItemUI
{
    if ( ( BattleEnd && Active ) || [ [ BattleMapScene instance ] checkEnd ] )
    {
        [ [ BattleEndItemUIHandler instance ] visible:YES ];
        [ [ BattleEndItemUIHandler instance ] setWin:battleWin :subSceneMap.Name :sceneDataItem.Per ];
        [ [ BattleEndItemUIHandler instance ] setData:ItemDic :DropGold ];
        
        playSound( PST_ALCHEMY );
    }
    else
    {
        [ [ BattleEndItemUIHandler instance ] visible:NO ];
    }
}


- ( void ) startLeaderMove
{
    if ( moveOver )
    {
        [ self showWin:YES ];
        return;
    }
    
    if ( moveSmartBattle )
    {
        moveSmartBattle = 0;
        leaderMove = moveSmartBattle;
        return;
    }
    
    if ( sceneDataItem.Per == 1.0f )
    {
        moveSmartPer = 80;
        moveSmart1 = NO;
        moveSmart2 = NO;
        moveSmart3 = NO;
    }
    
    if ( rand() % 100 < moveSmartPer )
    {
        moveSmartRandom = YES;
    }
    
    BattleMapSprite* spr1 = [ MovePath objectAtIndex:leaderMove ];
    
    if ( !notMove && !spr1.Sprite && leaderStep > 0 && ( rand() % 10 + leaderStep > 10 ) )
    {
        leaderStep = 0;
        
        if ( subSceneMap.Enemy.count )
        {
            [ battleStage start:sceneDataItem.SPEnemy ];
        }
        
        return;
    }
    
    
    leaderMove++;
    
    if ( moveSmart1 )
    {
        if ( leaderMove >= MovePath.count )
        {
            leaderMove = 0;
        }
        
        spr1 = [ MovePath objectAtIndex:leaderMove ];
    }
    
    
    int movePath1[ 256 ];
    
    if ( moveSmart3 )
    {
        MapGrid* grid = [ leader getPos ];
        BattleMapSprite* sprr = [ self getSprite:grid.PosX :grid.PosY ];

        for ( int i = 0 ; i < regions[ sprr.RegionID ].Sprites.count ; ++i )
        {
            BattleMapSprite* spr2 = [ regions[ sprr.RegionID ].Sprites objectAtIndex:i ];
            
            if ( ![ sceneDataItem getData:[ Finder getIndex:spr2.PosX :spr2.PosY ] ] )
            {
                int movePathCount = [ Finder findPath:movePath1 :grid.PosX :grid.PosY :spr2.PosX :spr2.PosY ];
                
                if ( movePathCount )
                {
                    spr1 = spr2;
                    for ( int j = 0 ; j < MovePath.count ; j++ )
                    {
                        if ( spr2 == [ MovePath objectAtIndex:j ] )
                        {
                            leaderMove = j;
                            break;
                        }
                    }
                    break;
                }
            }
        }
        
    }
    
    
    int count = 0;
    
    while ( moveSmart2 && sceneDataItem.Per < 1.0f )
    {
        if ( ![ sceneDataItem getData:[ Finder getIndex:spr1.PosX :spr1.PosY ] ] )
        {
            MapGrid* grid = [ leader getPos ];
            int movePathCount = [ Finder findPath:movePath1 :grid.PosX :grid.PosY :spr1.PosX :spr1.PosY ];
            
            if ( movePathCount )
            {
                break;
            }
        }
        
        
        count++;
        leaderMove++;
        
        if ( leaderMove >= MovePath.count )
        {
            leaderMove = 0;
        }
        
        spr1 = [ MovePath objectAtIndex:leaderMove ];
        if ( count > MovePath.count )
        {
            moveSmart2 = NO;
            break;
        }
    }
    
    
    if ( moveSmartRandom )
    {
        leaderMove = rand() % MovePath.count;
        moveSmartRandom = NO;
    }
    
    if ( !moveSmart2 && moveSmart4 )
    {
        BOOL b = NO;
        for ( int i = 0 ; i < BattleSprites.count ; i++ )
        {
            BattleSprite* spr = [ BattleSprites objectAtIndex:i ];
            
            if ( spr.Type == GSFT_Dig || spr.Type == GSFT_Collect || spr.Type == GSFT_Treasure || spr.Type == GSFT_Door1 || spr.Type == GSFT_Door2 || spr.Type == GSFT_Door3 )
            {
                BattleMapSprite* spr2 = [ self getSprite:spr.PosX :spr.PosY ];
                spr1 = spr2;
                
                for ( int j = 0 ; j < MovePath.count ; j++ )
                {
                    if ( spr2 == [ MovePath objectAtIndex:j ] )
                    {
                        MapGrid* grid = [ leader getPos ];
                        int movePathCount = [ Finder findPath:movePath1 :grid.PosX :grid.PosY :spr2.PosX :spr2.PosY ];
                        
                        if ( !movePathCount )
                        {
                            break;
                        }
                        
                        leaderMove = j;
                        
                        break;
                    }
                }
                
                b = YES;
                break;
            }
        }
        
        moveSmart4 = b;
    }
    
    if ( leaderMove >= MovePath.count )
    {
        leaderMove = 0;
        //BattleEnd = YES;
        //[ [ BattleEndItemUIHandler instance ] visible:YES ];
        return;
    }
    
    
    
    BattleMapSprite* spr = [ MovePath objectAtIndex:leaderMove ];
    
    BOOL b = [ leader startMove:spr.PosX :spr.PosY :self :@selector(onLeaderMovePosition) :self :@selector(onLeaderMovePosition1) ];
    
    notMove = !b;
    
    if ( notMove )
    {
        return;
    }
    
    
    //[ battleStage moveCreature ];
    if ( ![ battleStage canMoveCreature ] )
    {
        // end,
        moveOver = YES;
        return;
    }
}


- ( void ) addCollect
{
    [ [ GameAudioManager instance ] playSound:@"MVS053" ];
    
    NSMutableArray* Collect = subSceneMap.Collect;
    
    int allCount = 0;
    
    for ( int i = 0 ; i < Collect.count ; ++i )
    {
        CreatureBaseIDPerNum* drop = [ Collect objectAtIndex:i ];
        
        allCount += drop.Per;
    }
    
    int r = rand() % allCount;
    
    allCount = 0;
    
    for ( int i = 0 ; i < Collect.count ; ++i )
    {
        CreatureBaseIDPerNum* drop = [ Collect objectAtIndex:i ];
        allCount += drop.Per;
        
        if ( r < allCount )
        {
            int item = drop.ID;
            
            ItemConfigData* data = [ [ ItemConfig instance ] getData:item ];
            
            int c = rand() % drop.Num + 1;
            c = c * [ leader.CommonData isEquipSkillTriggerEffect:STGE_DIG ];
            c += [ PlayerData instance ].WorkItemEffect[ ICDET_DROP2 ];
            
            [ [ ItemData instance ] addItem:item :c ];
            
            [ self addItem:item :c ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightCollect" , nil ) , data.Name , c ];
            
            [ sceneDataItem setCollect:drop.ID ];
            
            [ self battleLog:str ];
            
            return;
        }
    }
    
}


- ( void ) addDig
{
    [ [ GameAudioManager instance ] playSound:@"MVS053" ];
    
    NSMutableArray* Dig = subSceneMap.Dig;
    
    int allCount = 0;
    
    for ( int i = 0 ; i < Dig.count ; ++i )
    {
        CreatureBaseIDPerNum* drop = [ Dig objectAtIndex:i ];
        
        allCount += drop.Per;
    }
    
    int r = rand() % allCount;
    
    allCount = 0;
    
    for ( int i = 0 ; i < Dig.count ; ++i )
    {
        CreatureBaseIDPerNum* drop = [ Dig objectAtIndex:i ];
        allCount += drop.Per;
        
        if ( r < allCount )
        {
            int item = drop.ID;
            
            ItemConfigData* data = [ [ ItemConfig instance ] getData:item ];
            
            int c = rand() % drop.Num + 1;
            c = c * [ leader.CommonData isEquipSkillTriggerEffect:STGE_DIG ];
            c += [ PlayerData instance ].WorkItemEffect[ ICDET_DROP1 ];
            
            [ [ ItemData instance ] addItem:item :c ];
            
            [ self addItem:item :c ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDig" , nil ) , data.Name , c ];
            
            [ sceneDataItem setDig:drop.ID ];
            
            [ self battleLog:str ];
            
            return;
        }
    }
    
    
}

- ( void ) onLeaderMovePosition
{
    
    
//    if ( ![ battleStage canMoveCreature ] )
//    {
//        // end,
//        moveOver = YES;
//        return;
//    }
    
    
    MapGrid* grid = [ leader getPos ];
    BattleMapSprite* spr = sprites[ grid.PosY ][ grid.PosX ];
    [ spr setMaskGourp:GROUP_PLAYER ];
    int index = [ Finder getIndex:spr.PosX :spr.PosY ];
    [ sceneDataItem setData:index ];
    [ self updatePer ];
    
    BattleMapSprite* sprite = [ self getSprite:grid.PosX :grid.PosY ];
    
    if ( sprite.Sprite && ( sprite.Sprite.Type == GSFT_Door1 || sprite.Sprite.Type == GSFT_Door2 || sprite.Sprite.Type == GSFT_Door3 ) )
    {
        if ( [ sprite.Sprite getActionIndex ] == 0 )
        {
            [ sprite.Sprite setAction:1 ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"OpenDoor" , nil ) ];
            
            [ self battleLog:str ];
            
            [ sceneDataItem setDoor:[ Finder getIndex:sprite.PosX :sprite.PosY ] ];
        }
        
        return;
    }
    
    if ( sprite.Sprite && sprite.Sprite.Type == GSFT_Treasure )
    {
        if ( [ sprite.Sprite getActionIndex ] == 0 )
        {
            [ sprite.Sprite setAction:1 ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"OpenTreasure" , nil ) ];
            [ self battleLog:str ];
            
            sprite.Sprite.Type = GSFT_Count;
            
            
            int allCount = 1;
            
            for ( int i = 0 ; i < subSceneMap.Treasure.count ; ++i )
            {
                CreatureBaseIDPerNum* drop = [ subSceneMap.Treasure objectAtIndex:i ];
                
                allCount += drop.Per;
            }
            
            int r = rand() % allCount;
            
            allCount = 0;
            
            for ( int i = 0 ; i < subSceneMap.Treasure.count ; ++i )
            {
                CreatureBaseIDPerNum* drop = [ subSceneMap.Treasure objectAtIndex:i ];
                allCount += drop.Per;
                
                if ( r < allCount )
                {
                    int i = rand() % subSceneMap.Treasure.count;
                    
                    CreatureBaseIDPerNum* drop = [ subSceneMap.Treasure objectAtIndex:i ];
                    
                    ItemConfigData* data = [ [ ItemConfig instance ] getData:drop.ID ];
                    
                    if ( data.AutoSell )
                    {
                        DropGold += data.Sell;
                        [ [ PlayerData instance ] addGold:data.Sell ];
                        
                        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitGold" , nil ) , data.Sell ];
                        
                        [ self battleLog:str ];
                    }
                    else
                    {
                        [ [ ItemData instance ] addItem:drop.ID :drop.Num ];
                        
                        [ self addItem:drop.ID :drop.Num ];
                        
                        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"GetTreasure" , nil ) , data.Name , drop.Num ];
                        
                        [ sceneDataItem setCollect:drop.ID ];
                        
                        [ self battleLog:str ];
                    }
                    
                    
                    break;
                }
            }

            
//            for ( int i = 0 ; i < subSceneMap.Treasure.count ; i++ )
//            {
//                
//            }
            
            
            [ sceneDataItem setTreasure:[ Finder getIndex:sprite.PosX :sprite.PosY ] ];
        }
        
        return;
    }
    
    
    if ( sprite.Sprite && sprite.Sprite.Type == GSFT_Collect )
    {
        sprite.Sprite.Type = GSFT_Count;
        
        [ sprite.Sprite releaseBattleSprite ];
        [ sprite.Sprite initBattleSprite ];
        [ sprite.Sprite playEffect:@"MO032A" :self :@selector(onPlayEffectCollect:) ];
        
        waitEffect = YES;
        
        [ [ GameAudioManager instance ] playSound:@"C1600" ];
        
        leaderStep++;
        [ battleStage moveCreature ];
        
        return;
    }
    
    if ( sprite.Sprite && sprite.Sprite.Type == GSFT_Dig )
    {
        sprite.Sprite.Type = GSFT_Count;
        [ sprite.Sprite releaseBattleSprite ];
        [ sprite.Sprite initBattleSprite ];
        [ sprite.Sprite playEffect:@"MO033A" :self :@selector(onPlayEffectDig:) ];
        
        waitEffect = YES;
        
        [ [ GameAudioManager instance ] playSound:@"C1600" ];
        
        leaderStep++;
        [ battleStage moveCreature ];
        
        return;
    }
    
    for ( int i = 0 ; i < OtherCreatures.count ; i++ )
    {
        BattleCreature* bc = [ OtherCreatures objectAtIndex:i ];
        MapGrid* grid1 = [ bc getPos ];
        
        if ( grid.PosX == grid1.PosX && grid.PosY == grid1.PosY )
        {
            if ( bc.BOSS )
            {
                [ battleStage startBoss:subSceneMap.BossID :subSceneMap.BossNum :i ];
            }
            else if ( bc.Event )
            {
                [ battleStage startBoss:bc.Event :1 :i ];
            }
            
            leaderStep = 0;
            [ leader endMove ];
            [ leader setPos:grid.PosX :grid.PosY ];
            
            
            leaderStep++;
            [ battleStage moveCreature ];
            
            return;
        }
    }
    
    if ( !notMove && leaderStep > 0 && ( rand() % 25 + leaderStep > 25 ) )
    {
        if ( subSceneMap.Enemy.count )
        {
            [ battleStage start:sceneDataItem.SPEnemy ];
        }
        
        leaderStep = 0;
        [ leader endMove ];
        [ leader setPos:grid.PosX :grid.PosY ];
        
        moveSmartBattle = leaderMove;
        
        return;
    }

    leaderStep++;
    [ battleStage moveCreature ];
    
}


- ( void ) onLeaderMovePosition1
{
    MapGrid* grid = [ leader getPos ];
    
    if ( !isMoving )
    {
        [ self moveLayerReal:grid.RealPosX :grid.RealPosY ];
    }
}


- ( void ) loadMap
{
    for ( int i = 0 ; i < MaxY ; i++ )
    {
        for ( int j = 0 ; j < MaxX ; j++ )
        {
            [ sprites[ i ][ j ] load:self :@selector(onLoadMap) ];
        }
    }
}


- ( void ) onPlayEffectCollect:( BattleSprite* )spr
{
    [ BattleSprites removeObject:spr ];
    [ spr releaseBattleSprite ];
    
    [ self addCollect ];
    
    waitEffect = NO;
}


- ( void ) onPlayEffectDig:( BattleSprite* )spr
{
    [ BattleSprites removeObject:spr ];
    [ spr releaseBattleSprite ];
    
    [ self addDig ];
    
    waitEffect = NO;
}


- ( void ) startBattle
{
    timeDelay = -1.0f;
    BattleStart = YES;
    BattleEnd = NO;
    
    [ battleStage startLog ];
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"BattleStart" , nil ) ];
    [ self battleLog:str ];
}


- ( void ) setMapSpriteCreature:( int ) x :( int )y :( BattleCreature* )c
{
    BattleMapSprite* sprite = [ self getSprite:x :y ];
    [ sprite setCreature:c ];
}


- ( void ) setMapSpriteSprite:( int ) x :( int )y :( BattleSprite* )s
{
    BattleMapSprite* sprite = [ self getSprite:x :y ];
    [ sprite setSprite:s ];
}


- ( void ) addItem:( int )i :( int )n
{
    if ( [ ItemDic objectForKey:[ NSNumber numberWithInt:i ] ] )
    {
        int nn = [ [ ItemDic objectForKey:[ NSNumber numberWithInt:i ] ] intValue ];
        n += nn;
    }
    
    [ ItemDic setObject:[ NSNumber numberWithInt:n ] forKey:[ NSNumber numberWithInt:i ] ];
}


- ( void ) getMovePath0:( int )x :( int )y
{
    BattleMapSprite* s = [ self getSprite:x :y ];
    BattleMapSprite* s0 = [ self getSprite:x + 1 :y ];
    
    if ( ( s && s0.RegionID != 0 && s.RegionID == s0.RegionID ) || ( s.Door & DOOR_EAST ) == DOOR_EAST )
    {
        [ self getMovePath1:s0 ];
    }
    
    BattleMapSprite* s1 = [ self getSprite:x - 1 :y ];
    
    if ( ( s && s1.RegionID != 0 && s.RegionID == s1.RegionID ) || ( s.Door & DOOR_WEST ) == DOOR_WEST )
    {
        [ self getMovePath1:s1 ];
    }
    
    BattleMapSprite* s2 = [ self getSprite:x :y + 1 ];
    
    if ( ( s && s2.RegionID != 0 && s.RegionID == s2.RegionID ) || ( s.Door & DOOR_SOUTH ) == DOOR_SOUTH )
    {
        [ self getMovePath1:s2 ];
    }
    
    BattleMapSprite* s3 = [ self getSprite:x :y - 1 ];
    
    if ( ( s && s3.RegionID != 0 && s.RegionID == s3.RegionID ) || ( s.Door & DOOR_NORTH ) == DOOR_NORTH )
    {
        [ self getMovePath1:s3 ];
    }
    
    //    [ self getMovePath1:x + 1 :y ];
    //
    //    [ self getMovePath1:x - 1 :y ];
    //    [ self getMovePath1:x :y + 1 ];
    //    [ self getMovePath1:x :y - 1 ];
}


- ( void ) getMovePath1:( BattleMapSprite* )s
{
    //    for ( int i = 0 ; i < MoveSprites.count ; i++ )
    //    {
    //        if ( s == [ MoveSprites objectAtIndex:i ] )
    //        {
    //            return;
    //        }
    //    }
    //
    //    [ MoveSprites addObject:s ];
}


- ( void ) clearMovePath
{
    
}


- ( void ) killByOther:( int )i
{
    BattleCreature* bc = [ OtherCreatures objectAtIndex:i ];
    [ bc removeFromParentAndCleanup:YES ];
    
    if ( bc.Event )
    {
        [ [ GameEventManager instance ] checkEventComplete ];
    }
    
}


- ( void ) killOther:( int )i
{
    BattleCreature* bc = [ OtherCreatures objectAtIndex:i ];
    [ bc removeFromParentAndCleanup:YES ];
    
    [ OtherCreatures removeObjectAtIndex:i ];
    
    if ( bc.Event )
    {
        [ [ GameEventManager instance ] checkEventComplete ];
    }
}


- ( void ) removeCreature:( BattleCreature* )c
{
    [ c releaseCreature ];
    [ Creatures removeObject:c ];
    [ SelfCreatures removeObject:c ];
    [ OtherCreatures removeObject:c ];
}


- ( void ) getMovePath:( BattleCreature* )c
{
    //    MapGrid* grid = [ c getOriginalPos ];
    //    [ MoveSprites addObject: [ self getSprite:grid.PosX :grid.PosY ] ];
    //
    //    int count = MoveSprites.count;
    //    int start = 0;
    //    for ( int i = 0 ; i < c.CommonData.RealBaseData.Move ; i++ )
    //    {
    //        for ( int j = start ; j < count ; j++ )
    //        {
    //            BattleMapSprite* sprite = [ MoveSprites objectAtIndex:j ];
    //
    //            [ self getMovePath0:sprite.PosX :sprite.PosY ];
    //        }
    //
    //        start = count;
    //        count = MoveSprites.count;
    //    }
    //
    //    for ( int i = 0 ; i < MoveSprites.count ; i++ )
    //    {
    //        BattleMapSprite* sprite = [ MoveSprites objectAtIndex:i ];
    //        if ( sprite.Creature && sprite.Creature.Group == GROUP_ENEMY )
    //        {
    //            [ [ MoveSprites objectAtIndex:i ] addACTMask:BMSACTT_ATTACK ];
    //        }
    //        else
    //        {
    //            [ [ MoveSprites objectAtIndex:i ] addACTMask:BMSACTT_MOVE ];
    //        }
    //
    //    }
}


- ( void ) updatePer
{
    sceneDataItem.Per = (float)sceneDataItem.DataDic.count / (float)spriteCount;
    
    if ( Active )
    {
        [ [ BattleTopUIHandler instance ] setPer:sceneDataItem.Per ];
    }
    
}


- ( void ) clear
{
    Active = NO;
    battleWin = NO;
    
    moveSmart1 = NO;
    moveSmart2 = NO;
    moveSmart3 = NO;
    moveSmart4 = NO;
    moveSmartRandom = NO;
    moveSmartPer = 0;
    
    notMove = YES;
    waitEffect = NO;
    
    [ battleStage clearBattleStage ];
    
    int count = Creatures.count;
    for ( int i = 0 ; i < count ; i++ )
    {
        [ [ Creatures objectAtIndex:i ] releaseCreature ];
    }
    
    count = BattleSprites.count;
    for ( int i = 0 ; i < count ; i++ )
    {
        [ [ BattleSprites objectAtIndex:i ] releaseBattleSprite ];
    }
    
    [ Condition removeAllObjects ];
    [ Win removeAllObjects ];
    [ Lose removeAllObjects ];
    
    [ BattleSprites removeAllObjects ];
    [ Creatures removeAllObjects ];
    [ SelfCreatures removeAllObjects ];
    [ OtherCreatures removeAllObjects ];
    [ MovePath removeAllObjects ];
    [ ItemDic removeAllObjects ];
    
    EnemyCreatures = NULL;
    SPEnemyCreatures = NULL;
    
    leader = NULL;
    leaderMove = 0;
    leaderStep = 0;
    
    subSceneMap = NULL;
    sceneDataItem = NULL;
    
    team = INVALID_ID;
    
    DropGold = 0;
    
    [ [ SceneUIHandler instance ] visible:NO ];
    
    
    for ( int i = 0 ; i < MAX_REGION ; i++ )
    {
        [ regions[ i ] clear ];
    }
    
    for ( int i = 0 ; i < MAX_SPRITE ; i++ )
    {
        for ( int j = 0 ; j < MAX_SPRITE ; j++ )
        {
            [ sprites[ i ][ j ] removeAllChildrenWithCleanup:YES ];
            sprites[ i ][ j ] = NULL;
        }
    }
    
    spriteCount = 0;
    
    [ mapLayer removeAllChildrenWithCleanup:YES ];
    [ middleLayer removeAllChildrenWithCleanup:YES ];
    [ creatureLayer removeAllChildrenWithCleanup:YES ];
    
    MaxX = 0;
    MaxY = 0;
    
    [ Mask release ];
    Mask = NULL;
    
    [ MaskTexture release ];
    MaskTexture = NULL;
    
    isMoving = NO;
    
    BattleStart = NO;
    BattleEnd = NO;
    moveOver = NO;
    
    
    [ [ CCTextureCache sharedTextureCache ] removeUnusedTextures ];
}


- ( void ) update:( float )delay
{
    if ( [ [ TalkUIHandler instance ] isOpened ] )
    {
        return;
    }
    
    if ( waitEffect )
    {
        return;
    }
    
    int count = Creatures.count;
    
    for ( int i = 0 ; i < count ; i++ )
    {
        [ [ Creatures objectAtIndex:i ] update:delay ];
    }
    
    [ battleStage update:delay ];
    
    timeDelay += delay;
    if ( timeDelay > 1.0f )
    {
        timeDelay = 1.0f;
    }
    
    if ( timeDelay > 0.0f && BattleStart && !BattleEnd && !battleStage.StartFight )
    {
        if ( leader && ![ leader isMoving ] )
        {
            [ self startLeaderMove ];
        }
    }
}


@end
