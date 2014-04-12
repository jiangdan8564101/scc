//
//  AlchemyConfig.h
//  sc
//
//  Created by fox on 13-10-14.
//
//

#import "GameConfig.h"

@interface AlchemyConfigItemData : NSObject
{
    
}

@property( nonatomic ) int Number , ItemID;
@end



@interface AlchemyConfigData : NSObject
{
    
}

@property( nonatomic , assign ) NSMutableArray* Items;
@property( nonatomic ) int ItemID , Number;
@property( nonatomic ) int AlchemyID , Rank;
@end


@interface AlchemyConfig : GameConfig
{
    
}

@property( nonatomic , assign ) NSMutableDictionary* Dic;
- ( AlchemyConfigData* ) getAlchemy:( int )d;

+ ( AlchemyConfig* ) instance;

@end



