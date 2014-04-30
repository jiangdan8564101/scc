//
//  ItemConfig.h
//  sc
//
//  Created by fox on 13-7-14.
//
//

#import "GameConfig.h"


@interface ItemConfigData : NSObject
{
    float monsterDamage[ GCT_COUNT ];
    float attrDefence[ GCA_COUNT ];
}

- ( void ) initItemConfigData;

@property ( nonatomic ) float HP , MaxHP , SP , MaxSP , FS , MaxFS , PAtk , PDef , MAtk , MDef , Agile , Lucky , Hit , Miss , Critical , Move , CP , Guest , Command;

@property ( nonatomic ) int EffectType;
@property ( nonatomic ) float Effect;

@property ( nonatomic ) int GrowID;
@property ( nonatomic ) float GrowDay;

@property ( nonatomic ) int MainAttrType;
@property ( nonatomic ) float MainAttr;

@property ( nonatomic ) int ID , Type , Type2 , WeaponType , ArmorType;
@property ( nonatomic ) int Sell , Buy , PutPosition , AutoSell;

@property ( nonatomic ) int Key , Rank , Quality;
@property ( nonatomic ) int ProLevel;

@property ( nonatomic ) int Color;

@property ( nonatomic ) float* MonsterDamage;
@property ( nonatomic ) float* AttrDefence;


@property ( nonatomic , assign ) NSMutableArray* Skill;

@property( nonatomic , assign ) NSMutableString* Img;
@property( nonatomic , assign ) NSMutableString* Name;
@property( nonatomic , assign ) NSMutableString* Des1;
@property( nonatomic , assign ) NSMutableString* Des2;

@end



@interface ItemConfig : GameConfig
{
    
}

@property( nonatomic , assign ) NSMutableDictionary* ItemDic;

- ( ItemConfigData* ) getData:( int )i;

+ ( ItemConfig* ) instance;

@end
