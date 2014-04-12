//
//  BattleReadyAttackUIHandler.m
//  sc
//
//  Created by fox on 13-4-30.
//
//

#import "BattleReadyAttackUIHandler.h"
#import "BattleCreatureInfoUIHandler.h"
#import "BattleCommandUIHandler.h"
#import "BattleStage.h"

@implementation BattleReadyAttackUIHandler

static BattleReadyAttackUIHandler* gBattleReadyAttackUIHandler;
+ (BattleReadyAttackUIHandler*) instance
{
    if ( !gBattleReadyAttackUIHandler )
    {
        gBattleReadyAttackUIHandler = [ [ BattleReadyAttackUIHandler alloc] init ];
        [ gBattleReadyAttackUIHandler initUIHandler:@"BattleReadyAttackView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleReadyAttackUIHandler;
}



- ( void ) onInited
{
    UIButton* button = (UIButton*)[ view viewWithTag:1000 ];
    [ button addTarget:self action:@selector(onAttack) forControlEvents:UIControlEventTouchUpInside ];
    
    UIButton* button1 = (UIButton*)[ view viewWithTag:1001 ];
    [ button1 addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside ];
    
}


- ( void ) onAttack
{
    [ self visible:NO ];
    [ [ BattleStage instance ] fight ];
}

- ( void ) onOpened
{
    [ [ BattleCommandUIHandler instance ] visible:NO ];
    [ [ BattleCreatureInfoUIHandler instance ] visible:NO ];
}

- ( void ) onCancel
{
    [ [ BattleCreatureInfoUIHandler instance ] visible:YES ];
    [ [ BattleCommandUIHandler instance ] visible:YES ];
    
    [ self visible:NO ];
}


@end





