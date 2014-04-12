//
//  BattleLogUIHandler2.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "BattleLogUIHandler2.h"

@implementation BattleLogUIHandler2


static BattleLogUIHandler2* gBattleLogUIHandler2;
+ ( BattleLogUIHandler2* ) instance
{
    if ( !gBattleLogUIHandler2 )
    {
        gBattleLogUIHandler2 = [ [ BattleLogUIHandler2 alloc ] init ];
        [ gBattleLogUIHandler2 initUIHandler:@"BattleLogUIView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleLogUIHandler2;
}

@end
