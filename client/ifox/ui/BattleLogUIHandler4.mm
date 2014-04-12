//
//  BattleLogUIHandler4.m
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "BattleLogUIHandler4.h"

@implementation BattleLogUIHandler4



static BattleLogUIHandler4* gBattleLogUIHandler4;
+ ( BattleLogUIHandler4* ) instance
{
    if ( !gBattleLogUIHandler4 )
    {
        gBattleLogUIHandler4 = [ [ BattleLogUIHandler4 alloc ] init ];
        [ gBattleLogUIHandler4 initUIHandler:@"BattleLogUIView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleLogUIHandler4;
}

@end
