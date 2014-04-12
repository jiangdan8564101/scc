//
//  BattleLogUIHandler.h
//  sc
//
//  Created by fox on 13-9-1.
//
//

#import "UIHandler.h"
#import "ChatUIWebView.h"
#import "BattleNumberView.h"
#import "BattleCreatureView.h"
#import "BattleEnemyView.h"

@interface BattleLogUIHandler : UIHandler
{
    ChatUIWebView* webView;
    UIView* battleView;
    
    BattleEnemyView* enemyView[ MAX_BATTLE_ENEMY ];
    BattleCreatureView* selfView[ MAX_BATTLE_ENEMY ];
    
    UIView* whiteView;
    
    
    NSObject* object;
    SEL sel;
    
    int fadeTime;
}


- ( void ) startFightMovie:( NSObject* )obj :( SEL )s;

- ( void ) appandMsg:( NSString* )str;
- ( void ) clearMsg;

- ( void ) start:( NSArray* )arr;
- ( void ) startFight:( NSArray* )arr :( BOOL )b :( BOOL )sp;

- ( void ) startSelfFight:( int )index;
- ( void ) startEnemyFight:( int )index;

- ( void ) updateSelf:( NSArray* )arr;

- ( void ) fightSelf:( NSArray* )arr :( NSString* )eff :( int )hit;
- ( void ) fightEnemy:( NSArray* )arr :( NSString* )eff :( int )hit;

- ( void ) fightSelfF:( NSArray* )arr :( NSString* )eff;
- ( void ) fightEnemyF:( NSArray* )arr :( NSString* )eff;

- ( void ) deadSelf:( NSArray* )arr;
- ( void ) dead:( NSArray* )arr;
- ( void ) endFight;

- ( void ) fightEffectCritical;

+ ( BattleLogUIHandler* ) instance;

//#define BATTLELOG( str ) [ [ BattleLogUIHandler instance ] appandMsg:str ]

@end
