//
//  CreatureConfig.m
//  sc
//
//  Created by fox on 13-2-12.
//
//

#import "CreatureConfig.h"
#import "SkillConfig.h"
#import "ItemConfig.h"
#import "PlayerData.h"
#import "LevelUpPriceConfig.h"
#import "ItemData.h"
#import "ProDiffConfig.h"

@implementation CreatureBaseIDPerNum

- (id)copyWithZone:(NSZone *)zone
{
    CreatureBaseIDPerNum *copy = [ [ self class] allocWithZone: zone ];
    
    copy.ID = ID;
    copy.Per = Per;
    copy.Num = Num;
    
    return copy;
};


@synthesize ID , Per , Num;
@end

@implementation CreatureBaseData

- ( float ) getRand
{
    return getRand( 70 , 110 ) / 100.0f;
}

- ( void ) addRandomData:( CreatureBaseData* )data
{
    HP += data.HP * [ self getRand ];
    MaxHP += data.MaxHP * [ self getRand ];
    SP += data.SP * [ self getRand ];
    MaxSP += data.MaxSP * [ self getRand ];
    FS += data.FS * [ self getRand ];
    MaxFS += data.MaxFS * [ self getRand ];
    PAtk += data.PAtk * [ self getRand ];
    PDef += data.PDef * [ self getRand ];
    MAtk += data.MAtk * [ self getRand ];
    MDef += data.MDef * [ self getRand ];
    Agile += data.Agile * [ self getRand ];
    Lucky += data.Lucky * [ self getRand ];
    Hit += data.Hit * [ self getRand ];
    Miss += data.Miss * [ self getRand ];
    Critical += data.Critical * [ self getRand ];
    Move += data.Move * [ self getRand ];
    CP += data.CP * [ self getRand ];
    MaxCP += data.MaxCP * [ self getRand ];
    Guest += data.Guest * [ self getRand ];
    Command += data.Command * [ self getRand ];
    Kill += data.Kill * [ self getRand ];
}

- ( id ) copyWithZone:( NSZone* )zone
{
    CreatureBaseData *copy = [ [ self class] allocWithZone: zone ];
    
    copy.HP = HP;
    copy.MaxHP = MaxHP;
    copy.SP = SP;
    copy.MaxSP = MaxSP;
    copy.FS = FS;
    copy.MaxFS = MaxFS;
    copy.PAtk = PAtk;
    copy.PDef = PDef;
    copy.MAtk = MAtk;
    copy.MDef = MDef;
    copy.Agile = Agile;
    copy.Lucky = Lucky;
    copy.Hit = Hit;
    copy.Miss = Miss;
    copy.Critical = Critical;
    copy.Move = Move;
    copy.CP = CP;
    copy.MaxCP = MaxCP;
    copy.Guest = Guest;
    copy.Command = Command;
    copy.Kill = Kill;
    
    return copy;
};


@synthesize HP , MaxHP , SP , MaxSP , FS , MaxFS , PAtk , PDef , MAtk , MDef , Agile , Lucky , Hit , Miss , Critical , Move , CP , MaxCP , Guest , Command , Kill;

@end


@implementation CreatureCommonData


@synthesize BaseData , RealBaseData;
@synthesize AttrDefence , RealAttrDefence;
@synthesize MonsterDamage , RealMonsterDamage;
@synthesize MainAttrType , MainAttr;
@synthesize Name , Des , Action , BattleAction;
@synthesize cID , Team , ID ;
@synthesize Type , LevelUpType , CharacterType , ProfessionID , BattleType;
@synthesize Level , EXP ,MaxEXP;
@synthesize Equip0 , Equip1 , Equip2;
@synthesize Skill;
@synthesize Profession;
@synthesize Drop , Zone , FirstDrop , FirstDropNum;
@synthesize EquipSkill;
@synthesize EmployPrice;
@synthesize EnemyIndex;
@synthesize Event;
@synthesize Dead , Group , Index;
@synthesize ImageOffsetX , ImageOffsetY;


- ( void ) resetData
{
    RealBaseData.HP = RealBaseData.MaxHP;
    //RealBaseData.SP = RealBaseData.MaxSP;
    RealBaseData.FS = RealBaseData.MaxFS;
    
    BaseData.HP = BaseData.MaxHP;
    //BaseData.SP = BaseData.MaxSP;
    BaseData.FS = BaseData.MaxFS;
    
    
    Dead = NO;
}

- ( void ) initProfession:( int )p :( int )l
{
    ProfessionLevelData* data = [ [ ProfessionLevelData alloc ] init ];
    data.ID = p;
    data.Level = l;
    
    [ Profession setObject:data forKey:[ NSNumber numberWithInt:p ] ];
    [ data release ];
    
    ProfessionID = p;
}

- ( void ) changeProfession:( int )p
{
    ProfessionLevelData* data = [ Profession objectForKey:[ NSNumber numberWithInt:p ] ];
    
    if ( !data )
    {
        [ self initProfession:p :1 ];
    }
    
    ProfessionID = p;
    
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
         EquipSkill[ i ] = INVALID_ID;
    }
    
    if ( Equip0 != INVALID_ID )
    {
        [ [ ItemData instance ] addItem:Equip0 :1 ];
    }
    Equip0 = INVALID_ID;
    
    [ self updateProfessionSkillAndEquip ];
}


- ( BOOL ) addProfessionTime
{
    ProfessionLevelData* data = [ Profession objectForKey:[ NSNumber numberWithInt:ProfessionID ] ];
    
    if ( !data )
    {
        return NO;
    }
    
    ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:ProfessionID ];
    
    int proTime = [ pro getLevelTime:data.Level ];
    if ( proTime )
    {
        data.Time++;
        
        if ( data.Time == proTime )
        {
            data.Level++;
            return YES;
        }
    }
    
    return NO;
}


- ( ProfessionSkillData* ) createProfessionSkillData:( int )s
{
    ProfessionSkillData* data = [ [ ProfessionSkillData alloc ] init ];
    data.Active = NO;
    data.SkillID = s;
    data.AP = 0;
    
    [ Skill setObject:data forKey:[ NSNumber numberWithInt:s ] ];
    
    [ data release ];
    return data;
}

- ( ProfessionSkillData* ) getProfessionSkillData:( int )s
{
    ProfessionSkillData* data = [ Skill objectForKey:[ NSNumber numberWithInt:s ] ];
    
    return data;
}

- ( void ) activeProfessionSkill:( int )s :( BOOL )b
{
    ProfessionSkillData* data = [ self getProfessionSkillData:s ];
    
    if ( !data )
    {
        data = [ self createProfessionSkillData:s ];
    }
    
    [ data setActive:b ];
}

- ( BOOL ) canEquipProfessionSkill:( int )s
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:s ];
    
    return BaseData.MaxCP - skill.CP >= 0;
}

- ( void ) equipProfessionSkill:( int )index :( int )s
{
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        if ( EquipSkill[ i ] == s )
        {
            EquipSkill[ i ] = INVALID_ID;
        }
    }
    
    EquipSkill[ index ] = s;
}

- ( void ) cancelEquipProfessionSkill:( int )index
{
    EquipSkill[ index ] = INVALID_ID;
}

- ( int ) getEmployPrice
{
    ProfessionConfigData* data = [ [ ProfessionConfig instance ] getProfessionConfig:ProfessionID ];

    float p = [ [ LevelUpPriceConfig instance ] getPrice:Level ];
    
    float pp = 1.0f - [ PlayerData instance ].WorkItemEffect[ ICDET_PRO1 + data.Type ];
    
    return EmployPrice * p * pp;
}

- ( int ) getProfessionLevel
{
    ProfessionLevelData* level = [ Profession objectForKey:[ NSNumber numberWithInt:ProfessionID ] ];
    
    return level.Level;
}

- ( ProfessionLevelData* ) getProLevelData:( int )t
{
    ProfessionLevelData* level = [ Profession objectForKey:[ NSNumber numberWithInt:t ] ];
    
    return level;
}

- ( ProfessionLevelData* ) getProLevelData;
{
    ProfessionLevelData* level = [ Profession objectForKey:[ NSNumber numberWithInt:ProfessionID ] ];
    
    return level;
}

- ( void ) updateProfessionSkillEquip:( int )e
{
    ItemConfigData* item = [ [ ItemConfig instance ] getData:e ];
    
    if ( item )
    {
        for ( int i = 0 ; i < item.Skill.count ; ++i )
        {
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:[ [ item.Skill objectAtIndex:i ] intValue ] ];
            
            if ( skill )
            {
                if ( !skill.ProfessionID || skill.ProfessionID == ProfessionID )
                {
                    ProfessionSkillData* data = [ self getProfessionSkillData:skill.SkillID ];
                    
                    if ( !data )
                    {
                        data = [ self createProfessionSkillData:skill.SkillID ];
                    }
                    
                    data.Active = YES;
                }
            }
        }
        
        RealBaseData.HP += item.MaxHP;
        RealBaseData.MaxHP += item.MaxHP;
        RealBaseData.SP += item.MaxSP;
        RealBaseData.MaxSP += item.MaxSP;
        RealBaseData.FS += item.MaxFS;
        RealBaseData.MaxFS += item.MaxFS;
        RealBaseData.PAtk += item.PAtk;
        RealBaseData.PDef += item.PDef;
        RealBaseData.MAtk += item.MAtk;
        RealBaseData.MDef += item.MDef;
        RealBaseData.Agile += item.Agile;
        RealBaseData.Lucky += item.Lucky;
        RealBaseData.Hit += item.Hit;
        RealBaseData.Miss += item.Miss;
        RealBaseData.Critical += item.Critical;
        RealBaseData.Move += item.Move;
        RealBaseData.Guest += item.Guest;
        RealBaseData.Command += item.Command;
        
        MainAttrType = item.MainAttrType;
        MainAttr = item.MainAttr;
        
        for ( int i = 0 ; i < GCA_COUNT ; ++i )
        {
            realAttrDefence[ i ] += item.AttrDefence[ i ];
        }
        for ( int i = 0 ; i < GCT_COUNT ; ++i )
        {
            realMonsterDamage[ i ] += item.MonsterDamage[ i ];
        }
        
    }
}


- ( void ) updateProfessionSkillAndEquip
{
    [ RealBaseData release ];
    
    ProDiffConfigData* proDiffData = [ [ ProDiffConfig instance ] getData:ProfessionID ];
    
    RealBaseData = BaseData.copy;
    
    CreatureCommonData* commBase = [ [ CreatureConfig instance ] getCommonData:ID ];
    if ( commBase )
    {
        RealBaseData.HP -= commBase.BaseData.HP;
        RealBaseData.MaxHP -= commBase.BaseData.MaxHP;
        RealBaseData.SP -= commBase.BaseData.SP;
        RealBaseData.MaxSP -= commBase.BaseData.MaxSP;
        RealBaseData.PAtk -= commBase.BaseData.PAtk;
        RealBaseData.PDef -= commBase.BaseData.PDef;
        RealBaseData.MAtk -= commBase.BaseData.MAtk;
        RealBaseData.MDef -= commBase.BaseData.MDef;
        RealBaseData.Agile -= commBase.BaseData.Agile;
        RealBaseData.Lucky -= commBase.BaseData.Lucky;
        
        RealBaseData.HP *= proDiffData.HP;
        RealBaseData.MaxHP *= proDiffData.HP;
        RealBaseData.SP *= proDiffData.SP;
        RealBaseData.MaxSP *= proDiffData.SP;
        RealBaseData.PAtk *= proDiffData.PAtk;
        RealBaseData.PDef *= proDiffData.PDef;
        RealBaseData.MAtk *= proDiffData.MAtk;
        RealBaseData.MDef *= proDiffData.MDef;
        RealBaseData.Agile *= proDiffData.Agile;
        RealBaseData.Lucky *= proDiffData.Lucky;
        
        RealBaseData.HP += commBase.BaseData.HP;
        RealBaseData.MaxHP += commBase.BaseData.MaxHP;
        RealBaseData.SP += commBase.BaseData.SP;
        RealBaseData.MaxSP += commBase.BaseData.MaxSP;
        RealBaseData.PAtk += commBase.BaseData.PAtk;
        RealBaseData.PDef += commBase.BaseData.PDef;
        RealBaseData.MAtk += commBase.BaseData.MAtk;
        RealBaseData.MDef += commBase.BaseData.MDef;
        RealBaseData.Agile += commBase.BaseData.Agile;
        RealBaseData.Lucky += commBase.BaseData.Lucky;
    }
    
//    RealBaseData.HP *= proDiffData.HP;
//    RealBaseData.MaxHP *= proDiffData.HP;
//    RealBaseData.SP *= proDiffData.SP;
//    RealBaseData.MaxSP *= proDiffData.SP;
//    RealBaseData.PAtk *= proDiffData.PAtk;
//    RealBaseData.PDef *= proDiffData.PDef;
//    RealBaseData.MAtk *= proDiffData.MAtk;
//    RealBaseData.MDef *= proDiffData.MDef;
//    RealBaseData.Agile *= proDiffData.Agile;
//    RealBaseData.Lucky *= proDiffData.Lucky;
    
    RealBaseData.CP = 0;
    
    RealBaseData.Miss += RealBaseData.Agile / 500.0f;
    RealBaseData.Hit += RealBaseData.Lucky / 500.0f;
    RealBaseData.Critical += RealBaseData.Lucky / 5000.0f;
    
    
    MainAttrType = 0;
    MainAttr = 0.0f;
    
    for ( int i = 0 ; i < GCA_COUNT ; ++i )
    {
        realAttrDefence[ i ] = attrDefence[ i ];
    }
    for ( int i = 0 ; i < GCT_COUNT ; ++i )
    {
        realMonsterDamage[ i ] = monsterDamage[ i ];
    }
    
    NSArray* all = [ Skill allValues ];
    for ( int i = 0 ; i < all.count ; ++i )
    {
        ProfessionSkillData* data = [ all objectAtIndex:i ];
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:data.SkillID ];
        
        data.Active = ( !skill.ProfessionID || skill.ProfessionID == ProfessionID );
    }
    
    [ self updateProfessionSkillEquip:Equip0 ];
    [ self updateProfessionSkillEquip:Equip1 ];
    [ self updateProfessionSkillEquip:Equip2 ];
    
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:equipSkill[ i ] ];
        
        RealBaseData.CP += skill.CP;
        
        if ( skill.Trigger == STG_NORMAL )
        {
            switch ( skill.TriggerEffect )
            {
                case STGE_MAXHP:
                    RealBaseData.HP *= ( 1.0f + skill.Power );
                    RealBaseData.MaxHP *= ( 1.0f + skill.Power );
                    break;
                case STGE_MAXSP:
                    RealBaseData.SP *= ( 1.0f + skill.Power );
                    RealBaseData.MaxSP *= ( 1.0f + skill.Power );
                    break;
                case STGE_DEFATTR:
                    realAttrDefence[ skill.Attribute ] += skill.Power;
                    break;
                case STGE_SPEED:
                    RealBaseData.Agile *= ( 1.0f + skill.Power );
                    break;
                case STGE_MISS:
                    RealBaseData.Miss += skill.Power;
                    break;
                case STGE_HIT:
                    RealBaseData.Hit += skill.Power;
                    break;
                case STGE_PATK:
                    RealBaseData.PAtk *= ( 1.0f + skill.Power );
                    break;
                case STGE_MATK:
                    RealBaseData.MAtk *= ( 1.0f + skill.Power );
                    break;
                case STGE_PDEF:
                    RealBaseData.PDef *= ( 1.0f + skill.Power );
                    break;
                case STGE_MDEF:
                    RealBaseData.MDef *= ( 1.0f + skill.Power );
                    break;
                case STGE_CT:
                    RealBaseData.Critical += skill.Power;
                    break;
            }
            
            for ( int i = 0 ; i < GCT_COUNT ; ++i )
            {
                realMonsterDamage[ i ] += skill.MonsterDamage[ i ];
            }
        }
    }
}

- ( BOOL ) isEquipSkill:( int )s
{
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        if ( s == EquipSkill[ i ] )
        {
            return YES;
        }
    }
    
    return NO;
}

- ( BOOL ) isEquipSkillTriggerEffectB:( int )t
{
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:EquipSkill[ i ] ];
        
        if ( skill.TriggerEffect == t )
        {
            return YES;
        }
    }
    
    return NO;
}

- ( int ) isEquipSkillTriggerEffect:( int )t
{
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:EquipSkill[ i ] ];
        
        if ( skill.TriggerEffect == t )
        {
            return skill.Power;
        }
    }
    
    return 1.0f;
}

- ( BOOL ) isEquipSkillMoveType:( int )t
{
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:EquipSkill[ i ] ];
        
        if ( skill.MoveType == t )
        {
            return YES;
        }
    }
    
    return NO;
}

- ( void ) addProfessionSkillAP:(int)e
{
    NSArray* all = [ Skill allValues ];
    
    for ( int i = 0 ; i < all.count ; ++i )
    {
        ProfessionSkillData* data = [ all objectAtIndex:i ];
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:data.SkillID ];
        
        if ( data.Active && data.AP < skill.AP )
        {
            data.AP += e;
            
            if ( data.AP > skill.AP )
            {
                data.AP = skill.AP;
            }
        }
    }
}



-( void ) encodeWithCoder:( NSCoder* )coder
{
    //[ coder encodeObject:BaseData forKey:@"BaseData" ];
    
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.HP ] forKey:@"HP" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.MaxHP ] forKey:@"MaxHP" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.SP ] forKey:@"SP" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.MaxSP ] forKey:@"MaxSP" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.FS ] forKey:@"FS" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.MaxFS ] forKey:@"MaxFS" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.PAtk ] forKey:@"PAtk" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.PDef ] forKey:@"PDef" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.MAtk ] forKey:@"MAtk" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.MDef ] forKey:@"MDef" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Agile ] forKey:@"Agile" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Lucky ] forKey:@"Lucky" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Hit ] forKey:@"Hit" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Miss ] forKey:@"Miss" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Critical ] forKey:@"Critical" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Move ] forKey:@"Move" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.MaxCP ] forKey:@"MaxCP" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.CP ] forKey:@"CP" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Guest ] forKey:@"Guest" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Command ] forKey:@"Command" ];
    [ coder encodeObject:[ NSNumber numberWithFloat:BaseData.Kill ] forKey:@"Kill" ];
    
    
    
    [ coder encodeObject:[ NSNumber numberWithInt:cID ] forKey:@"cID" ];
    [ coder encodeObject:[ NSNumber numberWithInt:ID ] forKey:@"ID" ];
    [ coder encodeObject:[ NSNumber numberWithInt:Team ] forKey:@"Team" ];
    
    [ coder encodeObject:[ NSNumber numberWithShort:Type ] forKey:@"Type" ];
    [ coder encodeObject:[ NSNumber numberWithShort:BattleType ] forKey:@"BattleType" ];
    [ coder encodeObject:[ NSNumber numberWithShort:LevelUpType ] forKey:@"LevelUpType" ];
    [ coder encodeObject:[ NSNumber numberWithShort:CharacterType ] forKey:@"CharacterType" ];
    [ coder encodeObject:[ NSNumber numberWithShort:ProfessionID ] forKey:@"ProfessionID" ];
    
    [ coder encodeObject:[ NSNumber numberWithShort:Level ] forKey:@"Level" ];
    [ coder encodeObject:[ NSNumber numberWithShort:EXP ] forKey:@"EXP" ];
    [ coder encodeObject:[ NSNumber numberWithShort:MaxEXP ] forKey:@"MaxEXP" ];
    
    [ coder encodeObject:[ NSNumber numberWithInt:Equip0 ] forKey:@"Equip0" ];
    [ coder encodeObject:[ NSNumber numberWithInt:Equip1 ] forKey:@"Equip1" ];
    [ coder encodeObject:[ NSNumber numberWithInt:Equip2 ] forKey:@"Equip2" ];
    
    
    [ coder encodeObject:[ NSNumber numberWithInt:Skill.count ] forKey:@"Skill" ];
    NSArray* allValues = Skill.allValues;
    
    for ( int i = 0 ; i < Skill.count ; i++ )
    {
        ProfessionSkillData* scd = [ allValues objectAtIndex:i ];
        
        [ coder encodeObject:[ NSNumber numberWithInt:scd.Active ] forKey:[ NSString stringWithFormat:@"Skill%da" , i ] ];
        
        [ coder encodeObject:[ NSNumber numberWithInt:scd.SkillID ] forKey:[ NSString stringWithFormat:@"Skill%di" , i ] ];
        [ coder encodeObject:[ NSNumber numberWithInt:scd.AP ] forKey:[ NSString stringWithFormat:@"Skill%dp" , i ] ];
    }
    
    allValues = Profession.allValues;
    [ coder encodeObject:[ NSNumber numberWithInt:Profession.count ] forKey:@"Profession" ];
    for ( int i = 0 ; i < Profession.count ; i++ )
    {
        ProfessionLevelData* scd = [ allValues objectAtIndex:i ];
        
        [ coder encodeObject:[ NSNumber numberWithInt:scd.ID ] forKey:[ NSString stringWithFormat:@"Profession%dt" , i ] ];
        [ coder encodeObject:[ NSNumber numberWithInt:scd.Level ] forKey:[ NSString stringWithFormat:@"Profession%dl" , i ] ];
        [ coder encodeObject:[ NSNumber numberWithInt:scd.Time ] forKey:[ NSString stringWithFormat:@"Profession%dm" , i ] ];
    }

    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        [ coder encodeObject:[ NSNumber numberWithInt:EquipSkill[ i ] ] forKey:[ NSString stringWithFormat:@"EquipSkill%d" , i ] ];
    }
    for ( int i = 0 ; i < GCA_COUNT ; ++i )
    {
        [ coder encodeObject:[ NSNumber numberWithFloat:attrDefence[ i ] ] forKey:[ NSString stringWithFormat:@"AttrDefence%d" , i ] ];
    }
    for ( int i = 0 ; i < GCT_COUNT ; ++i )
    {
        [ coder encodeObject:[ NSNumber numberWithFloat:monsterDamage[ i ] ] forKey:[ NSString stringWithFormat:@"MonsterDamage%d" , i ] ];
    }
    
}

-( id ) initWithCoder:( NSCoder* )coder
{
    self = [ self init ];
    
    BaseData.HP = [ [ coder decodeObjectForKey:@"HP"] floatValue ];
    BaseData.MaxHP = [ [ coder decodeObjectForKey:@"MaxHP"] floatValue ];
    BaseData.SP = [ [ coder decodeObjectForKey:@"SP"] floatValue ];
    BaseData.MaxSP = [ [ coder decodeObjectForKey:@"MaxSP"] floatValue ];
    BaseData.FS = [ [ coder decodeObjectForKey:@"FS"] floatValue ];
    BaseData.MaxFS = [ [ coder decodeObjectForKey:@"MaxFS"] floatValue ];
    BaseData.PAtk = [ [ coder decodeObjectForKey:@"PAtk"] floatValue ];
    BaseData.PDef = [ [ coder decodeObjectForKey:@"PDef"] floatValue ];
    BaseData.MAtk = [ [ coder decodeObjectForKey:@"MAtk"] floatValue ];
    BaseData.MDef = [ [ coder decodeObjectForKey:@"MDef"] floatValue ];
    BaseData.Agile = [ [ coder decodeObjectForKey:@"Agile"] floatValue ];
    BaseData.Lucky = [ [ coder decodeObjectForKey:@"Lucky"] floatValue ];
    BaseData.Hit = [ [ coder decodeObjectForKey:@"Hit"] floatValue ];
    BaseData.Miss = [ [ coder decodeObjectForKey:@"Miss"] floatValue ];
    BaseData.Critical = [ [ coder decodeObjectForKey:@"Critical"] floatValue ];
    BaseData.Move = [ [ coder decodeObjectForKey:@"Move"] floatValue ];
    BaseData.CP = [ [ coder decodeObjectForKey:@"CP"] floatValue ];
    BaseData.MaxCP = [ [ coder decodeObjectForKey:@"MaxCP"] floatValue ];
    BaseData.Guest = [ [ coder decodeObjectForKey:@"Guest"] floatValue ];
    BaseData.Command = [ [ coder decodeObjectForKey:@"Command"] floatValue ];
    BaseData.Kill = [ [ coder decodeObjectForKey:@"Kill"] floatValue ];
    
    
    cID = [ [ coder decodeObjectForKey:@"cID" ] intValue ];
    ID = [ [ coder decodeObjectForKey:@"ID" ] intValue ];
    Team = [ [ coder decodeObjectForKey:@"Team" ] intValue ];
    
    Type = [ [ coder decodeObjectForKey:@"Type" ] shortValue ];
    BattleType = [ [ coder decodeObjectForKey:@"BattleType" ] shortValue ];
    LevelUpType = [ [ coder decodeObjectForKey:@"LevelUpType" ] shortValue ];
    CharacterType = [ [ coder decodeObjectForKey:@"CharacterType" ] shortValue ];
    ProfessionID = [ [ coder decodeObjectForKey:@"ProfessionID" ] shortValue ];
    
    Level = [ [ coder decodeObjectForKey:@"Level" ] shortValue ];
    EXP = [ [ coder decodeObjectForKey:@"EXP" ] shortValue ];
    MaxEXP = [ [ coder decodeObjectForKey:@"MaxEXP" ] shortValue ];
    
    Equip0 = [ [ coder decodeObjectForKey:@"Equip0" ] intValue ];
    Equip1 = [ [ coder decodeObjectForKey:@"Equip1" ] intValue ];
    Equip2 = [ [ coder decodeObjectForKey:@"Equip2" ] intValue ];

    CreatureCommonData* comm = [ [ CreatureConfig instance ] getCommonData:ID ];
    ImageOffsetX = comm.ImageOffsetX;
    ImageOffsetY = comm.ImageOffsetY;
    [ Name release ]; Name = comm.Name.copy;
    [ Des release ]; Des = comm.Des.copy;
    [ Action release ]; Action = comm.Action.copy;
    [ BattleAction release ]; BattleAction = comm.BattleAction.copy;
    
    EmployPrice = comm.EmployPrice;
    
    int c = [ [ coder decodeObjectForKey:@"Skill" ] intValue ];
    
    [ Skill release ]; Skill = NULL;
    Skill = [ [ NSMutableDictionary alloc ] init ];
    
#ifdef DEBUG
    // 测试技能

//    for ( int i = 0 ; i < 200 ; ++i )
//    {
//        BaseData.MaxSP = 100;
//        BaseData.SP = 100;
//        
//        SkillConfigData* skill131 = [ [ SkillConfig instance ] getSkill:i ];
//        
//        if ( skill131 )
//        {
//            ProfessionSkillData* data34 = [ self getProfessionSkillData:i ];
//            
//            if ( !data34 )
//            {
//                data34 = [ self createProfessionSkillData:i ];
//                data34.Active = YES;
//            }
//            data34.AP = skill131.AP;
//            [ Skill setObject:data34 forKey:[ NSNumber numberWithInt:i ] ];
//        }
//        
//    }
    
#endif
    
    for ( int i = 0 ; i < c ; i++ )
    {
        ProfessionSkillData* scd = [ [ ProfessionSkillData alloc ] init ];
        
        scd.SkillID = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"Skill%di" , i ] ] intValue ];
        
        scd.Active = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"Skill%da" , i ] ] intValue ];
        scd.AP = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"Skill%dp" , i ] ] intValue ];
        
        [ Skill setObject:scd forKey:[ NSNumber numberWithInt:scd.SkillID ] ];
        [ scd release ];
    }
    
    c = [ [ coder decodeObjectForKey:@"Profession"] intValue ];
    
    [ Profession removeAllObjects ];[ Profession release ]; Profession = NULL;
    Profession = [ [ NSMutableDictionary alloc ] init ];
    
    for ( int i = 0 ; i < c ; i++ )
    {
        ProfessionLevelData* scd = [ [ ProfessionLevelData alloc ] init ];
        
        scd.ID = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"Profession%dt" , i ] ] intValue ];
        scd.Level = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"Profession%dl" , i ] ] intValue ];
        scd.Time = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"Profession%dm" , i ] ] intValue ];
        
        [ Profession setObject:scd forKey:[ NSNumber numberWithInt:scd.ID ] ];
        [ scd release ];
    }
    
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
       EquipSkill[ i ] = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"EquipSkill%d" , i ] ] intValue ];
    }
    
    for ( int i = 0 ; i < GCA_COUNT ; ++i )
    {
        attrDefence[ i ] = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"AttrDefence%d" , i ] ] floatValue ];
    }
    
    for ( int i = 0 ; i < GCT_COUNT ; ++i )
    {
        monsterDamage[ i ] = [ [ coder decodeObjectForKey:[ NSString stringWithFormat:@"MonsterDamage%d" , i ] ] floatValue ];
    }
    
    [ self updateProfessionSkillAndEquip ];
    
    return self;
}


- ( void ) initCreatureData
{
    EquipSkill = equipSkill;
    
    AttrDefence = attrDefence;
    MonsterDamage = monsterDamage;
    
    RealAttrDefence = realAttrDefence;
    RealMonsterDamage = realMonsterDamage;
}


- ( id ) init
{
    self = [ super init ];
    
    if ( self )
    {
        BaseData = [ [ CreatureBaseData alloc ] init ];
        
        Name = [ [ NSMutableString alloc ] init ];
        Des = [ [ NSMutableString alloc ] init ];
        Action = [ [ NSMutableString alloc ] init ];
        BattleAction = [ [ NSMutableString alloc ] init ];
        
        Skill = [ [ NSMutableDictionary alloc ] init ];
        
        Drop = [ [ NSMutableArray alloc ] init ];
        Zone = [ [ NSMutableArray alloc ] init ];
        
        Profession = [ [ NSMutableDictionary alloc ] init ];
        
        
        Team = INVALID_ID;
        
        Equip0 = INVALID_ID;
        Equip1 = INVALID_ID;
        Equip2 = INVALID_ID;
        
        [ self initCreatureData ];
        
        for ( int i = 0 ; i < MAX_SKILL ; ++i )
        {
            EquipSkill[ i ] = INVALID_ID;
        }
        
    }
    
    return self;
}


- ( id ) copyWithZone:( NSZone* )zone
{
    CreatureCommonData* copy = [ [ self class] allocWithZone: zone ];
    copy.BaseData = BaseData.copy;
    
    copy.Name = [ [ NSMutableString alloc ] initWithString:Name ];
    copy.Des = [ [ NSMutableString alloc ] initWithString:Des ];
    copy.Action = [ [ NSMutableString alloc ] initWithString:Action ];
    copy.BattleAction = [ [ NSMutableString alloc ] initWithString:BattleAction ];
    
    copy.Zone = [ [ NSMutableArray alloc ] init ];
    for ( int i = 0 ; i < Zone.count ; ++i )
    {
        NSNumber* zone1 = [ Zone objectAtIndex:i ];
        zone1 = zone1.copy;
        [ copy.Zone addObject:zone1 ];
        [ zone1 release ];
    }
    
    copy.Drop = [ [ NSMutableArray alloc ] init ];
    for ( int i = 0 ; i < Drop.count ; ++i )
    {
        CreatureBaseIDPerNum* drop = [ Drop objectAtIndex:i ];
        drop = drop.copy;
        [ copy.Drop addObject:drop ];
        [ drop release ];
    }
    copy.FirstDrop = FirstDrop;
    copy.FirstDropNum = FirstDropNum;
    
    copy.Skill = [ [ NSMutableDictionary alloc ] init ];
    for ( int i = 0 ; i < Skill.allValues.count ; i++ )
    {
        ProfessionSkillData* data = [ Skill.allValues objectAtIndex:i ];
        data = data.copy;
        [ copy.Skill setObject:data forKey:[ NSNumber numberWithInt:data.SkillID ] ];
        [ data release ];
    }
    
    copy.Profession = [ [ NSMutableDictionary alloc ] init ];
    for ( int i = 0 ; i < Profession.allValues.count ; i++ )
    {
        ProfessionLevelData* data = [ Profession.allValues objectAtIndex:i ];
        data = data.copy;
        [ copy.Profession setObject:data forKey:[ NSNumber numberWithInt:data.ID ] ];
        [ data release ];
    }
    
    [ copy initCreatureData ];
    
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        copy.EquipSkill[ i ] = EquipSkill[ i ];
    }
    for ( int i = 0 ; i < GCA_COUNT ; ++i )
    {
        copy.AttrDefence[ i ] = AttrDefence[ i ];
    }
    for ( int i = 0 ; i < GCT_COUNT ; ++i )
    {
        copy.MonsterDamage[ i ] = MonsterDamage[ i ];
    }
    
    copy.MainAttr = copy.MainAttr;
    copy.MainAttrType = copy.MainAttrType;
    
    copy.Event = Event;
    
    copy.ID = ID;
    copy.cID = cID;
    copy.Team = Team;
    
    copy.Type = Type;
    copy.CharacterType = CharacterType;
    copy.ProfessionID = ProfessionID;
    copy.BattleType = BattleType;
    copy.LevelUpType = LevelUpType;
    
    copy.Level = Level;
    copy.EXP = EXP;
    copy.MaxEXP = MaxEXP;
    
    copy.Equip0 = Equip0;
    copy.Equip1 = Equip1;
    copy.Equip2 = Equip2;
    
    copy.ImageOffsetX = ImageOffsetX;
    copy.ImageOffsetY = ImageOffsetY;
    
    copy.EmployPrice = EmployPrice;
    
    copy.Group = Group;
    
    
    copy.Dead = Dead;
    
    [ copy updateProfessionSkillAndEquip ];

    return copy;
}

- (void) dealloc
{
    [ BaseData release ];
    BaseData = NULL;
    
    [ RealBaseData release ];
    RealBaseData = NULL;
    
    [ Des release ];
    Des = NULL;
    [ Name release ];
    Name = NULL;
    [ Action release ];
    Action = NULL;
    [ BattleAction release ];
    BattleAction = NULL;
    
    [ Skill removeAllObjects ];
    [ Skill release ];
    Skill = NULL;
    
    [ Drop removeAllObjects ];
    [ Drop release ];
    Drop = NULL;
    
    [ Zone removeAllObjects ];
    [ Zone release];
    Zone = NULL;
    
    [ Profession removeAllObjects ];
    [ Profession release ];
    Profession = NULL;
    
    [ super dealloc ];
}

@end



@implementation CreatureConfig
@synthesize CreatureDic , NpcDic , EnemyDic;

CreatureConfig* gCreatureConfig = NULL;
+ ( CreatureConfig* ) instance
{
    if ( !gCreatureConfig )
    {
        gCreatureConfig = [ [ CreatureConfig alloc ] init ];
    }
    
    return gCreatureConfig;
}


- ( void ) initConfig
{
    CreatureDic = [ [ NSMutableDictionary alloc ] init ];
    NpcDic = [ [ NSMutableDictionary alloc ] init ];
    EnemyDic = [ [ NSMutableDictionary alloc ] init ];
    
    bNpc = YES;
    
    NSData* data = loadXML( @"npc" );
    NSXMLParser* parser = [ [ NSXMLParser alloc ] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
    
    bNpc = NO;
    
    data = loadXML( @"monster" );
    parser = [ [ NSXMLParser alloc ] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}


- ( void ) releaseConfig
{
    [ CreatureDic removeAllObjects ];
    [ CreatureDic release ];
    CreatureDic = NULL;
}


- ( CreatureCommonData* ) getCommonData:( int )i
{
    return [ CreatureDic objectForKey:[ NSNumber numberWithInt:i ] ];
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    static CreatureCommonData* commonDataLast = NULL;
    
    if ( [ elementName isEqualToString:@"n" ] || [ elementName isEqualToString:@"m" ] )
    {
        CreatureCommonData* commonData = [ [ CreatureCommonData alloc ] init ];
        
        commonData.Event = [ [ attributeDict objectForKey:@"event" ] intValue ];
        commonData.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        commonData.Type = [ [ attributeDict objectForKey:@"type" ] intValue ];
        commonData.BattleType = [ [ attributeDict objectForKey:@"battleType" ] intValue ];
        commonData.CharacterType = [ [ attributeDict objectForKey:@"characterType" ] intValue ];
        commonData.LevelUpType = [ [ attributeDict objectForKey:@"levelUpType" ] intValue ];
        
        commonData.ProfessionID = [ [ attributeDict objectForKey:@"ProID" ] intValue ];
        int level = [ [ attributeDict objectForKey:@"ProLevel" ] intValue ];
        [ commonData initProfession:commonData.ProfessionID :level ];
        
        commonData.Level = [ [ attributeDict objectForKey:@"level" ] intValue ];
        
        commonData.EXP = [ [ attributeDict objectForKey:@"exp" ] intValue ];
        
        [ commonData.Name setString:[ attributeDict objectForKey:@"name" ] ];
        
        if ( [ attributeDict objectForKey:@"des" ] )
        {
            [ commonData.Des setString:[ attributeDict objectForKey:@"des" ] ];
        }
        if ( [ attributeDict objectForKey:@"action" ] )
        {
            [ commonData.Action setString:[ attributeDict objectForKey:@"action" ] ];
        }
        
        if ( [ attributeDict objectForKey:@"battleAction" ] )
        {
            [ commonData.BattleAction setString:[ attributeDict objectForKey:@"battleAction" ] ];
        }
        
        commonData.BaseData.MaxHP = [ [ attributeDict objectForKey:@"maxHP" ] intValue ];
        commonData.BaseData.HP = commonData.BaseData.MaxHP;
        commonData.BaseData.MaxSP = [ [ attributeDict objectForKey:@"maxSP" ] intValue ];
        commonData.BaseData.SP = commonData.BaseData.MaxSP;
        commonData.BaseData.MaxFS = [ [ attributeDict objectForKey:@"maxFS" ] intValue ];
        commonData.BaseData.FS = commonData.BaseData.MaxFS;
        commonData.BaseData.PAtk = [ [ attributeDict objectForKey:@"pAtk" ] intValue ];
        commonData.BaseData.PDef = [ [ attributeDict objectForKey:@"pDef" ] intValue ];
        commonData.BaseData.MAtk = [ [ attributeDict objectForKey:@"mAtk" ] intValue ];
        commonData.BaseData.MDef = [ [ attributeDict objectForKey:@"mDef" ] intValue ];
        commonData.BaseData.Agile = [ [ attributeDict objectForKey:@"agile" ] intValue ];
        commonData.BaseData.Lucky = [ [ attributeDict objectForKey:@"lucky" ] intValue ];
        commonData.BaseData.Hit = [ [ attributeDict objectForKey:@"hit" ] floatValue ];
        commonData.BaseData.Miss = [ [ attributeDict objectForKey:@"miss" ] floatValue ];
        commonData.BaseData.Critical = [ [ attributeDict objectForKey:@"critical" ] floatValue ];
        commonData.BaseData.Move = [ [ attributeDict objectForKey:@"move" ] intValue ];
        commonData.BaseData.MaxCP = [ [ attributeDict objectForKey:@"cp" ] intValue ];
        commonData.BaseData.CP = 0;
        commonData.BaseData.Guest = [ [ attributeDict objectForKey:@"guest" ] intValue ];
        commonData.BaseData.Command = [ [ attributeDict objectForKey:@"command" ] intValue ];
        
        commonData.EmployPrice = [ [ attributeDict objectForKey:@"employPrice" ] floatValue ];
        
        commonData.ImageOffsetX = [ [ attributeDict objectForKey:@"imageOffsetX" ] intValue ];
        commonData.ImageOffsetY = [ [ attributeDict objectForKey:@"imageOffsetY" ] intValue ];
        
        commonData.AttrDefence[ GCA_PHYSICAL ] = [ [ attributeDict objectForKey:@"aP" ] floatValue ];
        commonData.AttrDefence[ GCA_EARTH ] = [ [ attributeDict objectForKey:@"aE" ] floatValue ];
        commonData.AttrDefence[ GCA_ICE ] = [ [ attributeDict objectForKey:@"aI" ] floatValue ];
        commonData.AttrDefence[ GCA_FIRE ] = [ [ attributeDict objectForKey:@"aF" ] floatValue ];
        commonData.AttrDefence[ GCA_ELECTRICAL ] = [ [ attributeDict objectForKey:@"aEl" ] floatValue ];
        commonData.AttrDefence[ GCA_HOLY ] = [ [ attributeDict objectForKey:@"aH" ] floatValue ];
        commonData.AttrDefence[ GCA_DARK ] = [ [ attributeDict objectForKey:@"aD" ] floatValue ];
        commonData.AttrDefence[ GCA_NULL ] = [ [ attributeDict objectForKey:@"aN" ] floatValue ];
        
        commonData.MonsterDamage[ GCT_FLY ] = [ [ attributeDict objectForKey:@"bFly" ] floatValue ];
        commonData.MonsterDamage[ GCT_DRAGON ] = [ [ attributeDict objectForKey:@"bDragon" ] floatValue ];
        commonData.MonsterDamage[ GCT_DEAD ] = [ [ attributeDict objectForKey:@"bDead" ] floatValue ];
        commonData.MonsterDamage[ GCT_EARTH ] = [ [ attributeDict objectForKey:@"bEarth" ] floatValue ];
        commonData.MonsterDamage[ GCT_METAL ] = [ [ attributeDict objectForKey:@"bMetal" ] floatValue ];
        
        [ commonData updateProfessionSkillAndEquip ];
        
        [ CreatureDic setObject:commonData forKey:[ NSNumber numberWithInt:commonData.ID ] ];
        if ( bNpc )
        {
            static int nnn1 = 1;
            commonData.EnemyIndex = nnn1; nnn1++;
            [ NpcDic setObject:commonData forKey:[ NSNumber numberWithInt:commonData.ID ] ];
        }
        else
        {
            static int nnn = 1;
            commonData.EnemyIndex = nnn; nnn++;
            [ EnemyDic setObject:commonData forKey:[ NSNumber numberWithInt:commonData.ID ] ];
        }
        
        [ commonData release ];
        
        commonDataLast = commonData;
    }
    
    if ( [ elementName isEqualToString:@"i" ] )
    {
        CreatureBaseIDPerNum* drop = [ [ CreatureBaseIDPerNum alloc ] init ];
        drop.ID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        drop.Per = [ [ attributeDict objectForKey:@"per" ] intValue ];
        drop.Num = [ [ attributeDict objectForKey:@"num" ] intValue ];
        
        if ( [ attributeDict objectForKey:@"first" ] )
        {
            commonDataLast.FirstDrop = drop.ID;
            commonDataLast.FirstDropNum = drop.Num;
        }
        
        if ( drop.Per )
        {
            [ commonDataLast.Drop addObject:drop ];
        }
        
        [ drop release ];
    }
    
    if ( [ elementName isEqualToString:@"z" ] )
    {
        int zone1 = [ [ attributeDict objectForKey:@"id" ] intValue ];
        [ commonDataLast.Zone addObject:[ NSNumber numberWithInt:zone1 ] ];
    }
    
    if ( [ elementName isEqualToString:@"s" ] )
    {
        int s = [ [ attributeDict objectForKey:@"id" ] intValue ];
        
        ProfessionSkillData* data = [ commonDataLast.Skill objectForKey:[ NSNumber numberWithInt:s ] ];
        
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:s ];
        
        if ( !data )
        {
            data = [ [ ProfessionSkillData alloc ] init ];
            data.Active = YES;
            data.SkillID = s;
            data.AP = skill.AP;
            
            [ commonDataLast.Skill setObject:data forKey:[ NSNumber numberWithInt:s ] ];
        }
        
    }
}



@end








