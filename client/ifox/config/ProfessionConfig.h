//
//  ProfessionConfig.h
//  sc
//
//  Created by fox on 13-9-3.
//
//

#import "GameConfig.h"



@interface ProfessionSkillData : NSObject
{
    
}

@property ( nonatomic ) BOOL Active;
@property ( nonatomic ) int SkillID , AP;

- ( BOOL ) isLearned;

@end

@interface ProfessionLevelData : NSObject
{
    
}

@property ( nonatomic ) int ID , Level , Time;

@end

@interface ProfessionConfigData : NSObject
{
    
}

- ( int ) getLevelTime:( int )l;

@property ( nonatomic , assign ) NSMutableDictionary* Conditions;
@property ( nonatomic , assign ) NSMutableArray* LevelTime;
@property ( nonatomic ) int ID , Type , WeaponType , ArmorType;
@property ( nonatomic , assign ) NSMutableString* Img;
@property ( nonatomic , assign ) NSMutableString* Name;
@property ( nonatomic , assign ) NSMutableString* Effect;
@property ( nonatomic , assign ) NSMutableString* Des;

@end


@interface ProfessionConfig : GameConfig
{
    
}

@property ( nonatomic , assign ) NSMutableDictionary* Dic;
@property ( nonatomic , assign ) NSMutableDictionary* WDic;

+ ( ProfessionConfig* ) instance;

-( ProfessionConfigData* ) getProfessionConfig:( int )t;
-( NSMutableArray* ) getWeaponProfessionConfig:( int )t;

@end
