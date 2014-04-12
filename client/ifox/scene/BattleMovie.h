//
//  BattleMovie.h
//  sc
//
//  Created by fox on 13-4-20.
//
//

#import <Foundation/Foundation.h>
#import "BattleCreature.h"

@interface BattleMovie : NSObject
{

}

- ( void ) playAttack:( BattleCreature* )c;

+ ( BattleMovie* )instance;

@end




