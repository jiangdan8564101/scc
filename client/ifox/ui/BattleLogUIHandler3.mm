//
//  BattleLogUIHandler3.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "BattleLogUIHandler3.h"

@implementation BattleLogUIHandler3


static BattleLogUIHandler3* gBattleLogUIHandler3;
+ ( BattleLogUIHandler3* ) instance
{
    if ( !gBattleLogUIHandler3 )
    {
        gBattleLogUIHandler3 = [ [ BattleLogUIHandler3 alloc ] init ];
        [ gBattleLogUIHandler3 initUIHandler:@"BattleLogUIView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleLogUIHandler3;
}

@end
