//
//  BuyItemConfig.h
//  sc
//
//  Created by fox on 13-12-1.
//
//

#import "GameConfig.h"

@interface BuyItemConfig : GameConfig
{
    
}

@property ( nonatomic , assign ) NSMutableArray* Array;

+ ( BuyItemConfig* ) instance;

@end
