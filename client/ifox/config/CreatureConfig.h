//
//  CreatureConfig.h
//  sc
//
//  Created by fox on 13-2-12.
//
//

#import "GameConfig.h"
#import "ProfessionConfig.h"
//#import "SkillConfig.h"


enum CreatureCommonDataProfession
{
    
};


@interface CreatureBaseIDPerNum : NSObject

@property ( nonatomic ) int ID , Per , Num;
@end

@interface CreatureBaseData : NSObject


@property ( nonatomic ) float HP , MaxHP , SP , MaxSP , FS , MaxFS , PAtk , PDef , MAtk , MDef , Agile , Lucky , Hit , Miss , Critical , Move , CP , MaxCP , Guest , Command , Kill;

- ( void ) addRandomData:( CreatureBaseData* )data;

@end



@interface CreatureCommonData : NSObject
{
    int equipSkill[ MAX_SKILL ];
    
    float attrDefence[ GCA_COUNT ];
    float monsterDamage[ GCT_COUNT ];
    
    float realAttrDefence[ GCA_COUNT ];
    float realMonsterDamage[ GCT_COUNT ];
}

@property ( nonatomic , assign ) CreatureBaseData* BaseData;
@property ( nonatomic , assign ) CreatureBaseData* RealBaseData;

@property ( nonatomic , assign ) float* AttrDefence;
@property ( nonatomic , assign ) float* RealAttrDefence;

@property ( nonatomic , assign ) float* MonsterDamage;
@property ( nonatomic , assign ) float* RealMonsterDamage;

@property ( nonatomic , assign ) int MainAttrType;
@property ( nonatomic ) float MainAttr;

@property ( nonatomic , assign ) NSMutableString* Name;
@property ( nonatomic , assign ) NSMutableString* Des;
@property ( nonatomic , assign ) NSMutableString* Action;
@property ( nonatomic , assign ) NSMutableString* BattleAction;

@property ( nonatomic ) short Type , LevelUpType , CharacterType , ProfessionID , BattleType;
@property ( nonatomic ) short Level , EXP , MaxEXP;

@property ( nonatomic ) float EmployPrice;
@property ( nonatomic ) int cID , ID , Team;
@property ( nonatomic ) int Equip0 , Equip1 , Equip2;

@property ( nonatomic , assign ) int* EquipSkill;

@property ( nonatomic , assign ) NSMutableDictionary* Profession;
@property ( nonatomic , assign ) NSMutableDictionary* Skill;
@property ( nonatomic , assign ) NSMutableArray* Drop;
@property ( nonatomic , assign ) NSMutableArray* Zone;
@property ( nonatomic , assign ) int FirstDrop , FirstDropNum;

@property ( nonatomic ) BOOL Dead;
@property ( nonatomic ) short Group , Index;
@property ( nonatomic ) short ImageOffsetX , ImageOffsetY;
@property ( nonatomic ) int EnemyIndex;
@property ( nonatomic ) int Event;

- ( void ) resetData;

- ( void ) initProfession:( int )p :( int )l;
- ( void ) changeProfession:( int )p;
- ( BOOL ) addProfessionTime;

- ( void ) addProfessionSkillAP:( int )e;
- ( void ) activeProfessionSkill:( int )s :( BOOL )b;
- ( BOOL ) canEquipProfessionSkill:( int )s;
- ( void ) equipProfessionSkill:(int)index :( int )s;
- ( void ) cancelEquipProfessionSkill:(int)index;
- ( void ) updateProfessionSkillAndEquip;

- ( BOOL ) isEquipSkill:( int )s;
- ( BOOL ) isEquipSkillTriggerEffectB:( int )t;
- ( int ) isEquipSkillTriggerEffect:( int )t;
- ( BOOL ) isEquipSkillMoveType:( int )t;


- ( int ) getProfessionLevel;
- ( int ) getEmployPrice;



- ( ProfessionLevelData* ) getProLevelData:( int )t;
- ( ProfessionLevelData* ) getProLevelData;
- ( ProfessionSkillData* ) getProfessionSkillData:( int )s;
- ( ProfessionSkillData* ) createProfessionSkillData:( int )s;

@end





@interface CreatureConfig : GameConfig
{
    BOOL bNpc;
}

@property( nonatomic , assign )NSMutableDictionary* CreatureDic;
@property( nonatomic , assign )NSMutableDictionary* NpcDic;
@property( nonatomic , assign )NSMutableDictionary* EnemyDic;

- ( CreatureCommonData* ) getCommonData:( int )i;

+ ( CreatureConfig* ) instance;


@end


