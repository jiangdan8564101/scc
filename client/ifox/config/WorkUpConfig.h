//
//  WorkUpConfig.h
//  sc
//
//  Created by fox on 13-11-23.
//
//

#import "GameConfig.h"



@interface WorkUpConfigItemData : NSObject
{
}
@property ( nonatomic ) int Item0 , Item1 , Num0 , Num1 , Gold;
@end

@interface WorkUpConfigData : NSObject
{
    
}

@property( nonatomic ) int Level;
@property( nonatomic ) int Employ , Gold , DayGold;
@property( nonatomic , assign ) NSMutableArray* Array;

@end


@interface WorkUpConfig : GameConfig
{
    
}

@property( nonatomic , assign ) NSMutableArray* Array;


- ( WorkUpConfigData* ) getWorkUp:( int )l;

+ ( WorkUpConfig* ) instance;

@end
