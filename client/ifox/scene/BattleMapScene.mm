//
//  BattleMapScene.m
//  sc
//
//  Created by fox on 13-1-19.
//
//

#import "BattleMapScene.h"
#import "SceneUIHandler.h"
#import "CreatureConfig.h"
#import "BattleCreature.h"
#import "PathFinder.h"
#import "BattleSprite.h"
#import "BattleSpriteAction.h"
#import "BattleTopUIHandler.h"
#import "BattleLogUIHandler1.h"
#import "BattleLogUIHandler2.h"
#import "BattleLogUIHandler3.h"
#import "BattleLogUIHandler4.h"

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


@implementation BattleMapScene
@synthesize SPMap;

BattleMapScene* gBattleMapScene = NULL;
+ ( BattleMapScene* )instance
{
    if ( !gBattleMapScene )
    {
        gBattleMapScene = [ [ BattleMapScene alloc ] init ];
    }
    
    return gBattleMapScene;
}


- ( BOOL ) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        [ mapLayer[ i ] ccTouchBegan:touch withEvent:event ];
    }
    
    return [ super ccTouchBegan:touch withEvent:event ];
}


- ( void ) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        [ mapLayer[ i ] ccTouchMoved:touch withEvent:event ];
    }
}


- ( void ) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        [ mapLayer[ i ] ccTouchEnded:touch withEvent:event ];
    }
}


- ( void ) onInited
{
    self.anchorPoint = ccp( 0 , 1.0 );
    
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        mapLayer[ i ] = [ BattleMapLayer node ];
    }
    
    mapLayer[ 0 ].LogUI = [ BattleLogUIHandler instance ];
    mapLayer[ 1 ].LogUI = [ BattleLogUIHandler1 instance ];
    mapLayer[ 2 ].LogUI = [ BattleLogUIHandler2 instance ];
    mapLayer[ 3 ].LogUI = [ BattleLogUIHandler3 instance ];
    mapLayer[ 4 ].LogUI = [ BattleLogUIHandler4 instance ];
    
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        [ mapLayer[ i ] initLayer ];
        [ self addChild:mapLayer[ i ] ];
        [ mapLayer[ i ] setVisible:false ];
        
        mapLayer[ i ].LayerIndex = i;
    }
    
}

- ( BattleMapLayer* ) getActiveMapLayer
{
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        if ( mapLayer[ i ].Active )
        {
            return mapLayer[ i ];
        }
    }
    
    return NULL;
}

- ( BattleLogUIHandler* ) getActiveLogUI
{
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        if ( mapLayer[ i ].Active )
        {
            return mapLayer[ i ].LogUI;
        }
    }
    
    return NULL;
}


- ( void ) activeLayer:( int )l
{
    if ( mapLayer[ l ].Active )
    {
        return;
    }
    
    [ [ BattleLogUIHandler instance ] visible:YES ];
    [ [ BattleLogUIHandler1 instance ] visible:YES ];
    [ [ BattleLogUIHandler2 instance ] visible:YES ];
    [ [ BattleLogUIHandler3 instance ] visible:YES ];
    [ [ BattleLogUIHandler4 instance ] visible:YES ];
    
    [ [ BattleLogUIHandler instance ] visible:NO ];
    [ [ BattleLogUIHandler1 instance ] visible:NO ];
    [ [ BattleLogUIHandler2 instance ] visible:NO ];
    [ [ BattleLogUIHandler3 instance ] visible:NO ];
    [ [ BattleLogUIHandler4 instance ] visible:NO ];
    
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        mapLayer[ i ].Active = NO;
        [ mapLayer[ i ] setVisible:NO ];
    }
    
    [ mapLayer[ l ] setVisible:YES ];
    mapLayer[ l ].Active = YES;

    switch ( l )
    {
        case 0:
            [ [ BattleLogUIHandler instance ] visible:YES ];
            break;
        case 1:
            [ [ BattleLogUIHandler1 instance ] visible:YES ];
            break;
        case 2:
            [ [ BattleLogUIHandler2 instance ] visible:YES ];
            break;
        case 3:
            [ [ BattleLogUIHandler3 instance ] visible:YES ];
            break;
        case 4:
            [ [ BattleLogUIHandler4 instance ] visible:YES ];
            break;
        default:
            break;
    }
    
    [ mapLayer[ l ] showEndItemUI ];
    
    
    if ( [ TalkUIHandler instance ].isOpened )
    {
        [ [ TalkUIHandler instance ] visible:YES ];
    }
}


- ( BOOL ) checkEnd
{
    for ( int i = 0 ; i < layerCount ; ++i )
    {
        BOOL b = [ mapLayer[ i ] BattleEnd ];
        
        if ( !b )
        {
            return NO;
        }
    }
    
    return YES;
}

- ( void ) loadSP
{
    GAME_SPEED = [ PlayerData instance ].BattleSpeed;

    [ mapLayer[ 0 ] loadSP ];
    
    layerCount = 1;
    
    [ [ BattleTopUIHandler instance ] visible:YES ];
    [ [ BattleTopUIHandler instance ] setSendData:layerCount ];
    
    [ self activeLayer:0 ];
    
    [ [ PlayerData instance ] goDate:1 ];
    
    SPMap = YES;
}

- ( void ) load:( int )i :( int )t
{
    GAME_SPEED = [ PlayerData instance ].BattleSpeed;

    [ mapLayer[ 0 ] load:i :t ];
    
    NSDictionary* dic = [ PlayerCreatureData instance ].PlayerSendDic;
    
    int c = 0;
    for ( int i = 0 ; i < dic.count ; ++ i )
    {
        int k = [ [ dic.allKeys objectAtIndex:i ] intValue ];
        int v = [ [ dic objectForKey:[ dic.allKeys objectAtIndex:i ] ] intValue ];
        
        if ( [ [ PlayerCreatureData instance ] getTeam:k ][ 0 ] > 0 )
        {
            c++;

            [ mapLayer[ c ] load:v :k ];
        }
    }
    
    layerCount = c + 1;
    
    [ [ BattleTopUIHandler instance ] visible:YES ];
    [ [ BattleTopUIHandler instance ] setSendData:layerCount ];
    
    [ self activeLayer:0 ];
    
    [ [ PlayerData instance ] goDate:1 ];
    
    SPMap = NO;
}


- ( void ) onEnterMap
{
    
    [ [ PlayerData instance ] checkStory ];
}


- ( void ) onExitMap
{
    layerCount = 0;
    
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        [ mapLayer[ i ] clear ];
    }
    
    for ( int j = 0 ; j < MAX_TEAM ; ++j )
    {
        for ( int i = 0 ; i < MAX_BATTLE_PLAYER ; ++i )
        {
            int* team1 = [ [ PlayerCreatureData instance ] getTeam:j ];
            
            if ( team1[ i ] )
            {
                CreatureCommonData* commonData1 = [ [ PlayerCreatureData instance ] getCommonData:team1[ i ] ];
                [ commonData1 resetData ];
            }
        }
    }
    
    [ [ BattleTopUIHandler instance ] visible:NO ];
    
    [ [ BattleLogUIHandler instance ] endFight ];
    [ [ BattleLogUIHandler1 instance ] endFight ];
    [ [ BattleLogUIHandler2 instance ] endFight ];
    [ [ BattleLogUIHandler3 instance ] endFight ];
    [ [ BattleLogUIHandler4 instance ] endFight ];
    
    [ [ BattleLogUIHandler instance ] visible:NO ];
    [ [ BattleLogUIHandler1 instance ] visible:NO ];
    [ [ BattleLogUIHandler2 instance ] visible:NO ];
    [ [ BattleLogUIHandler3 instance ] visible:NO ];
    [ [ BattleLogUIHandler4 instance ] visible:NO ];
    
    [ [ SceneData instance ] checkComplete ];
    [ [ SceneData instance ] randomSPEnemy ];
    
    GAME_SPEED = 1.0f;
}


- ( void ) update:(float)delay
{
    for ( int i = 0 ; i < MAX_BATTLE_LAYER ; ++i )
    {
        [ mapLayer[ i ] update:delay ];
    }
}


@end



