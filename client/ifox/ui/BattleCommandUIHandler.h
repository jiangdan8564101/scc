//
//  BattleCommandUIHandler.h
//  sc
//
//  Created by fox on 13-3-1.
//
//

#import "UIHandler.h"
#import "BattleCreature.h"

@interface BattleCommandUIHandler : UIHandler
{
    BattleCreature* creature;
}

- ( void ) setPos:( float ) x :( float )y;
- ( void ) setData:( BattleCreature* )c;

+ ( BattleCommandUIHandler* ) instance;

@end
