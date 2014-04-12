//
//  LevelUpPriceConfig.h
//  sc
//
//  Created by fox on 14-1-15.
//
//

#import "GameConfig.h"


@interface LevelUpPriceConfig : GameConfig
{

}

@property ( nonatomic , assign ) NSMutableDictionary* Dic;

+ ( LevelUpPriceConfig* ) instance;

- ( float ) getPrice:( int )l;

@end
