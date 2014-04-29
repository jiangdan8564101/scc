//
//  ProDiffConfig.h
//  sc
//
//  Created by YW-01D-0020 on 14-4-29.
//
//

#import "GameConfig.h"

@interface ProDiffConfigData : NSObject
@property( nonatomic ) float HP , SP , PAtk , PDef , MAtk , MDef , Agile , Lucky;
@end

@interface ProDiffConfig : GameConfig

@property ( nonatomic , assign ) NSMutableDictionary* Dic;

- ( ProDiffConfigData* ) getData:( int )pro;

+ ( ProDiffConfig* ) instance;

@end
