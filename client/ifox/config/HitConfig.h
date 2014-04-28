//
//  HitConfig.h
//  sc
//
//  Created by fox on 14-1-17.
//
//

#import "GameConfig.h"

@interface HitConfigData : NSObject
@property( nonatomic ) int ProLevel , ID , Per;
@property( nonatomic ) float Value;
@end

@interface HitConfig : GameConfig
{
    HitConfigData* data[ MAX_PROFESSION_LEVEL + 5 ][ BRHS_HIT5 + 1 ];
}

- ( HitConfigData** ) getHit:( int )p;

+ ( HitConfig* ) instance;


@end
