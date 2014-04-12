//
//  BattleEXPUIHandler.m
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "BattleEXPUIHandler.h"

@implementation BattleEXPUIHandler




static BattleEXPUIHandler* gBattleEXPUIHandler;
+ (BattleEXPUIHandler*) instance
{
    if ( !gBattleEXPUIHandler )
    {
        gBattleEXPUIHandler = [ [ BattleEXPUIHandler alloc] init ];
        [ gBattleEXPUIHandler initUIHandler:@"BattleEXPView" isAlways:NO isSingle:NO ];
    }
    
    return gBattleEXPUIHandler;
}


- ( void ) onInited
{
    
}



@end
