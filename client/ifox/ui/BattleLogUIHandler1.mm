//
//  BattleLogUIHandler1.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "BattleLogUIHandler1.h"

@implementation BattleLogUIHandler1



static BattleLogUIHandler1* gBattleLogUIHandler1;
+ ( BattleLogUIHandler1* ) instance
{
    if ( !gBattleLogUIHandler1 )
    {
        gBattleLogUIHandler1 = [ [ BattleLogUIHandler1 alloc ] init ];
        [ gBattleLogUIHandler1 initUIHandler:@"BattleLogUIView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleLogUIHandler1;
}


@end
