//
//  BattleCreatureInfoUIHandler.h
//  sc
//
//  Created by fox on 13-5-1.
//
//

#import "UIHandler.h"
#import "BattleCreature.h"

@interface BattleCreatureInfoUIHandler : UIHandler
{
    
}

+ ( BattleCreatureInfoUIHandler* ) instance;

- ( void ) setData:( BattleCreature* )c;

@end





