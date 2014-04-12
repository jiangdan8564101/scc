//
//  SkillConfig.h
//  sc
//
//  Created by fox on 13-9-3.
//
//

#import "GameConfig.h"
#import "CreatureConfig.h"

@interface SkillConfigData : NSObject
{
    float monsterDamage[ GCT_COUNT ];
}

@property ( nonatomic , assign ) NSMutableString* Name;
@property ( nonatomic , assign ) NSMutableString* Des1;
@property ( nonatomic , assign ) NSMutableString* Des2;
@property ( nonatomic , assign ) NSMutableString* Des3;
@property ( nonatomic , assign ) NSMutableString* Icon;
@property ( nonatomic , assign ) NSMutableString* Effect;

@property ( nonatomic ) int SkillID;

@property ( nonatomic ) int ProfessionID;
@property ( nonatomic ) int Type;
@property ( nonatomic ) int Trigger;
@property ( nonatomic ) int TriggerEffect;
@property ( nonatomic ) int MoveType;
@property ( nonatomic ) int Attribute;
@property ( nonatomic ) int Target;
@property ( nonatomic ) int SP;
@property ( nonatomic ) int MinDamage;
@property ( nonatomic ) int CP;
@property ( nonatomic ) int AP;
@property ( nonatomic ) int Turn;
@property ( nonatomic ) int Dig;


@property ( nonatomic ) float* MonsterDamage;

@property ( nonatomic ) float Hit;
@property ( nonatomic ) float Power;
@property ( nonatomic ) float Power1;
@property ( nonatomic ) float Power2;

@end


@interface SkillBuff : NSObject
{
    
}

@property ( nonatomic ) int Turn;
@property ( nonatomic ) int SkillID;
@property ( nonatomic , assign ) CreatureCommonData* Target;
@property ( nonatomic ) float Power;
@property ( nonatomic ) float Power1;
@property ( nonatomic ) float Power2;

@end

@interface SkillConfig : GameConfig
{
    NSMutableDictionary* dic;
}

- ( SkillConfigData* ) getSkill:( int )i;

+ ( SkillConfig* ) instance;

@end
