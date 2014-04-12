//
//  EffectConfig.h
//  sc
//
//  Created by fox on 14-1-29.
//
//

#import "GameConfig.h"


@interface EffectConfigData : NSObject
@property( nonatomic ) int PosX , PosY;
@end

@interface EffectConfig : GameConfig
{
    
}

@property ( nonatomic , assign ) NSMutableDictionary* Dic;

- ( EffectConfigData* ) getData:( NSString* )str;

+ ( EffectConfig* ) instance;

@end
