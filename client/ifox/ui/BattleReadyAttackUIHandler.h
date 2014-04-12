//
//  BattleReadyAttackUIHandler.h
//  sc
//
//  Created by fox on 13-4-30.
//
//

#import "UIHandler.h"
#import "BattleCreature.h"

@interface BattleReadyAttackUIHandler : UIHandler
{
    BattleCreature* attacker;
    BattleCreature* defender;
}

+ ( BattleReadyAttackUIHandler* ) instance;


@end
