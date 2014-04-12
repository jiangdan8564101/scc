//
//  BattleMapLayer.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "GameScene.h"
#import "BattleMapRegion.h"
#import "BattleStage.h"
#import "MapConfig.h"
#import "SceneData.h"
#import "PathFinder.h"

@interface BattleMapLayer : CCLayer
{
    BattleMapRegion* regions[ MAX_REGION ];
    BattleMapSprite* sprites[ MAX_SPRITE ][ MAX_SPRITE ];
    
    int spriteCount;
    
    CCLayer* mapLayer;
    CCLayer* middleLayer;
    CCLayer* creatureLayer;
    
    BOOL isMoving;
    CGPoint beginTouch;
    
    BattleCreature* leader;
    int leaderMove;
    int leaderStep;
    
    BOOL moveOver;
    
    BOOL waitEffect;
    BOOL notMove;
    BOOL battleWin;
       
    SceneDataItem* sceneDataItem;
    SubSceneMap* subSceneMap;
    BattleStage* battleStage;
    
    CCSpriteBatchNode* maskSpriteBatchNode;
    
    int team;
    
    int readRR;
    int readR;
    int readS;
    int readM;
    int readN;
    int readFO;
    int readF;
    
    int moveSmartPer;
    BOOL moveSmartRandom;
    BOOL moveSmart1;
    BOOL moveSmart2;
    BOOL moveSmart3;
    BOOL moveSmart4;
    int moveSmartBattle;
    
    float timeDelay;
    
    CGPoint movePoint;
}

@property ( nonatomic ) int LayerIndex;
@property ( nonatomic ) BOOL Active;
@property ( nonatomic ) int ID , MaxX , MaxY , RegionCount;
@property ( nonatomic ) BOOL BattleStart;
@property ( nonatomic ) BOOL BattleEnd;
@property ( nonatomic , assign ) CCTexture2D* MaskTexture;
@property ( nonatomic , assign ) NSString* Mask;
@property ( nonatomic , assign ) NSMutableArray* BattleSprites;
@property ( nonatomic , assign ) NSMutableArray* MovePath;

@property ( nonatomic ) int DropGold;
@property ( nonatomic , assign ) NSMutableArray* Win;
@property ( nonatomic , assign ) NSMutableArray* Lose;
@property ( nonatomic , assign ) NSMutableArray* Condition;
@property ( nonatomic , assign ) NSMutableArray* Creatures;
@property ( nonatomic , assign ) NSMutableArray* SelfCreatures;
@property ( nonatomic , assign ) NSMutableArray* OtherCreatures;
@property ( nonatomic , assign ) NSMutableArray* EnemyCreatures;
@property ( nonatomic , assign ) NSMutableArray* SPEnemyCreatures;
@property ( nonatomic , assign ) NSMutableDictionary* ItemDic;
@property ( nonatomic , assign ) BattleLogUIHandler* LogUI;
@property ( nonatomic , assign ) PathFinderO* Finder;


- ( BattleMapSprite* ) getSprite:( int ) x :( int ) y;

- ( void ) loadSP;
- ( void ) load:( int )i :( int )t;
- ( void ) clear;


- ( void ) startBattle;

- ( void ) setMapSpriteCreature:( int ) x :( int )y :( BattleCreature* )c;
- ( void ) setMapSpriteSprite:( int ) x :( int )y :( BattleSprite* )s;

- ( void ) clearMovePath;

- ( void ) killOther:( int )i;

- ( void ) removeCreature:( BattleCreature* )c;

- ( void ) getMovePath:( BattleCreature* )c;

- ( void ) setEnemy:( int )e;
- ( BOOL ) getEnemy:( int )e;

- ( void ) addItem:( int )i :( int )n;

- ( void ) showWin:( BOOL )b;

- ( void ) battleLog:( NSString* )str;

- ( void ) update:( float )d;

- ( void ) initLayer;

- ( void ) showEndItemUI;

- ( void ) moveLayerReal:( float ) x :( float )y;

@end
