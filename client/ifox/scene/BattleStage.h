//
//  BattleStage.h
//  sc
//
//  Created by fox on 13-4-29.
//
//

#import <Foundation/Foundation.h>
#import "BattleCreature.h"
#import "netMsgDefine.h"
#import "BattleLogUIHandler.h"

@class BattleMapScene;

@interface BattleStage : NSObject
{
    NSMutableArray* selfCreatures;
    NSMutableArray* enemyCreatures;
    
    
    NSMutableArray* hpArrayAtk;
    NSMutableArray* hpArrayDef;
    
    NSMutableArray* atkArray;
    NSMutableArray* defArray;
    
    NSMutableArray* targetsSelf;
    NSMutableArray* targets;
    NSMutableArray* creatures;
    
    NSMutableArray* buffArray;
    
    int turn;
    float time;
    float nextTime;
    int timeStep;
    
    int bossEnemy;
    int bossNum;
    int bossCID;
    
    BattleMapLayer* mapLayer;
    
    NSString* playingMusic;
    NSTimeInterval musicTime;
    
    BOOL end;
    BOOL spEnemy;
}


@property ( nonatomic ) BOOL StartFight;
@property ( nonatomic , assign ) BattleLogUIHandler* LogUI;


- ( void ) initBattleStage:( BattleMapLayer* )layer;
- ( void ) clearBattleStage;

- ( void ) startLog;

- ( void ) start:( BOOL )sp;
- ( void ) startBoss:( int )i :( int )num :( int )e;

- ( void ) update:( freal32 )d;

- ( void ) moveCreature;
- ( BOOL ) canMoveCreature;

- ( void ) addSelfCreature:( CreatureCommonData* )c;

@end







