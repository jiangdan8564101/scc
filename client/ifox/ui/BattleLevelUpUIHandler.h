//
//  BattleLevelUpUIHandler.h
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "UIHandler.h"
#import "CreatureConfig.h"

@interface BattleLevelUpUIHandler : UIHandler
{
    UIImageView* upView[ 15 ];
    UILabel* label[ 15 ];
    UILabel* upLabel[ 15 ];
}

- ( void ) setData:( CreatureCommonData* )c1 :( CreatureCommonData* )c2;

+ ( BattleLevelUpUIHandler* ) instance;

@end
