//
//  BattleMovie.m
//  sc
//
//  Created by fox on 13-4-20.
//
//

#import "BattleMovie.h"
#import "BattleMapScene.h"
#import "BattleSpriteAction.h"

@implementation BattleMovie


BattleMovie* gBattleMovie = NULL;
+ ( BattleMovie* )instance
{
    if ( !gBattleMovie )
    {
        gBattleMovie = [ [ BattleMovie alloc ] init ];
    }
    
    return gBattleMovie;
}


- ( void ) playAttack:( BattleCreature* )c
{
    
}


@end
