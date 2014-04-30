//
//  gameDefine.h
//  test
//
//  Created by fox on 13-1-9.
//
//

#ifndef gameDefine_h
#define gameDefine_h


#include "baseDefine.h"
using namespace FOXSDK;

const fint32    MAX_SKILL = 7;

const fint32    MAX_EQUIP = 3;

const fint32	MAX_ITEM = 999;

const fint32	DEFAULT_JOINT_ATTACK = 20;

const fint32	MAX_LEVELUP_POINT = 3;

const fint32	MAX_PLAYER_CREATURE = 32;

const fint32    MAX_TEAM = 10;
const fint32	MAX_BATTLE_PLAYER = 5;
const fint32	MAX_BATTLE_ENEMY = 5;
const fint32	MAX_BATTLE_TURN = 5;

const fint32	MAX_BATTLE_ITEM = 5;
const fint32	MAX_ITEM_SKILL = 2;

const fint32	INVALID_ID = -1;

const fint32    MAX_PATH = 256;

const fint32	MAX_RANDOM_ENEMY = 100;

const fint32	MAX_CHAT_MSG = 128;
const fint32	MAX_NAME = 32;
const fint32	MAX_MOVE_PATH = 128;
const fint32	MAX_SYN_PLAYER = 128;
const fint32	MAX_MOVE_ERROR = 3;
const fint32    MAX_EXP = 100;

const fint32	MAX_BATTLE_LAYER = 5;

const fint32    MAX_ALCHEMY_ITEM = 4;

const freal32	DEFAULT_MOVE_SPEED = 300.0f;


//static fint32	GUEST_GUID = 10000000;

const fint32    PLAYER_CACHE_COUNT = 4096;

const fint32    MAX_PROFESSION_LEVEL = 8;

const fint32    FIGHT_MISS = -77777;

const fint32    GROUP_NULL = 0;
const fint32    GROUP_PLAYER = 1;
const fint32    GROUP_ENEMY = 2;
const fint32    GROUP_NPC = 3;

const fint32    MAIN_PLAYER_ID = 100000;
const fint32    MAIN_PLAYER_ID1 = 1;
const fint32    MAIN_PLAYER_ID2 = 2;
const fint32    MAIN_PLAYER_ID3 = 3;
const fint32    MAIN_PLAYER_ID4 = 4;
const fint32    MAIN_PLAYER_ID16 = 16;
const fint32    FREE_MODE_STORY = 21;

const fint32    SPECIAL_ITEM = 99;

const fint32    KEY_ITEM1 = 101;
const fint32    KEY_ITEM2 = 102;
const fint32    KEY_ITEM3 = 103;

const fint32    PRO_ITEM = 300;
const fint32    WORK_RANK_ITEM = 201;
const fint32    MAX_WORK_RANK = 20;
const fint32    HP_ITEM = 60001;
const fint32    GOLD_ITEM = 52000;

const fint32    MAX_HP = 999;
const fint32    MAX_GOLD = 999999999;

enum gameSpriteMapType
{
    GSMT_Null = 0,
    GSMT_Earth, // 地
    GSMT_Ice, // 水
    GSMT_Fire, // 火
    GSMT_Electrical, // 电
    GSMT_Fly, // 飞行
    GSMT_Hide, // 神圣
    GSMT_No,
    

    GSMT_Count
};

enum gameSpriteFLagType
{
    GSFT_ENEMY = -2,
    GSFT_PLAYER = -1,
    
    GSFT_Null = 0,
    GSFT_Home,
    GSFT_Collect,
    GSFT_Dig,
    GSFT_Treasure,
    GSFT_Boss,

    GSFT_Door1,
    GSFT_Door2,
    GSFT_Door3,
    
    GSFT_Trap1,
    GSFT_Trap2,
    GSFT_Trap3,
    GSFT_Trap4,
    GSFT_Trap5,
    GSFT_Trap6,
    
    
    GSFT_SP = 21,
//    GSFT_SP2,
//    GSFT_SP3,
//    GSFT_SP4,
//    GSFT_SP5,
//    GSFT_SP6,
//    GSFT_SP7,
//    GSFT_SP8,
    
    
    GSFT_Count
};


//struct battleCommond
//{
//    fint32  ID;
//    
//    fint16  moveX;
//    fint16  moveY;
//    
//    fint32  FightID;
//    
//    battleCommond()
//    : ID( 0 ) , moveX( 0 ) , moveY( 0 ) , FightID( 0 )
//    {
//    
//    }
//};
//
//struct battleResult
//{
//    fint32  ID;
//    
//    fint16  moveX;
//    fint16  moveY;
//    
//    fint32  FightID;
//    
//    battleResult()
//    : ID( 0 ) , moveX( 0 ) , moveY( 0 ) , FightID( 0 )
//    {
//        
//    }
//};
//
//
//enum gameCreatureGroup
//{
//    GCGEnemy = -1,
//    GCGAlliance = -2,
//    
//};



enum gameCreaturePotentialType
{
    CPOT_LOW = 0,
    CPOT_MIDDLE,
    CPOT_HIGH,
    CPOT_MAX,
    
    CPOT_COUNT
};



enum gameCreatureType
{
    GCT_FLY = 1, // 飞行
    GCT_DRAGON, // 龙
    GCT_DEAD, // 僵尸
    GCT_EARTH, // 土
    GCT_METAL, // 金属
    GCT_ICE, //
    GCT_FIRE, //
    GCT_HOLY, //
    GCT_DARK, //
    GCT_ELECTRICAL, //
    GCT_WIND, //
    
    GCT_HUMAN = 20, // 人类
    GCT_SPIRIT, // 精灵
    GCT_ANGEL, // 天使
    GCT_DEMON, // 恶魔
    GCT_DEFENCER, // 守护者
    GCT_OTHER, // 未知
    
    
    GCT_COUNT
};


enum gameCreatureCharacterType
{
    GCCT_SERIOUS = 0, // 认真
    GCCT_CAUTIOUS, // 谨慎
    GCCT_CALLOUS, // 冷酷
    GCCT_HAUGHTY, // 高傲
    GCCT_STRANGE, // 好奇
    GCCT_ACTIVE, // 积极
    GCCT_FEARLESS, // 无畏
    GCCT_LIVELY, // 活泼
    
    
    GCCT_COUNT
};

enum gameCreatureAttr
{
    GCA_PHYSICAL = 0,  // 物理
    GCA_EARTH = 1, // 地
    GCA_ICE = 2, // 冰
    GCA_FIRE = 3, // 火
    GCA_ELECTRICAL = 4, // 电
    GCA_HOLY = 5, // 神圣
    GCA_DARK = 6, // 黑暗
    GCA_NULL = 7, // 无
    
    GCA_COUNT
};

enum gameCreatureEquip
{
    GCE_WEAPON = 0,
    GCE_ACCESSORY1,
    GCE_ACCESSORY2,
    
    GCE_COUNT
};



enum
{
    BATTLE_RESULT_DAMAGE = 0,
    BATTLE_RESULT_CRITICAL,
    BATTLE_RESULT_MISS,
    BATTLE_RESULT_RECOVERY,
    
    
};



enum 
{
    BST_SELF = 0,
    BST_OTHER,
};

enum 
{
    BSS_LEFT = 0,
    BSS_RIGHT,
};

enum BattleStageWin
{
    BSW_KILLALL = 2,
    BSW_KILLBOSS = 4,
    BSW_TURN = 8,
};

enum BattleStageLose
{
    BSL_KILLHOME = 2,
    BSL_KILLALL = 4,
    BSL_TURN = 8,
};

enum BattleStageCondition
{
    BSC_CAPTURE = 1,
    BSC_CAPTUREALLDOOR,
    BSC_COLLECT,
    BSC_PRECIOUS,
};

enum BattleHitStage
{
    BHS_HIT = 0,
    BHS_MISS,
    BHS_CRITICAL
};

enum BattleRandomHitStage
{
    BRHS_HIT1 = 1,
    BRHS_HIT2 = 2,
    BRHS_HIT3 = 3,
    BRHS_HIT4 = 4,
    BRHS_HIT5 = 5,
    
};

enum ProgressType
{
    PT_NORMAL = 0,
    PT_MIDDLE,
    PT_HIGH,
    
    PT_COUNT
};

enum CreatureProfessionType
{
    CPT_WARRIOR = 1, // 战士
    CPT_MARTIALIST = 2, // 武道家
    //CPT_CHEVALIER,

    CPT_MAGICIAN = 3, // 魔法师
    CPT_MISSIONARY = 4, // 僧侣
    CPT_DANCER = 5, // 舞蹈家
    CPT_THIEF = 6, // 盗贼
    //CPT_SHEEP,
    CPT_BOW = 7, // 弓箭手
    CPT_BARD = 8, // 吟游
    CPT_FUNNY = 9, // 滑稽
    CPT_ALCHEMIST = 10, // 炼金术士
    
    
    CPT_BERSERKER = 11, // 战斗大师
    CPT_MAGICSWORD = 12, // 魔法战士
    CPT_PALADIN = 13, // 圣骑士
    CPT_SAVANT = 14, // 贤者
    CPT_MONSTER = 15, // 魔物猎人
    CPT_TREASURE = 16, // 海贼
    CPT_SUPERSTAR = 17, // 超级明星
    //CPT_EXORCIST,
    //CPT_SAVANT,

    //CPT_STABBER,
    //CPT_TREASURE,
    //CPT_TRAVELER,
    
    
    //CPT_DEATH,
    //CPT_MAID,
    
    CPT_ELEMENT = 18, // 天地雷鳴士
    CPT_GOLDHAND = 19, // 神之手
    
    CPT_BRAVE = 20, // 勇者
};

enum ItemConfigDataColor
{
    ICDC_COLOR1 = 1,
    ICDC_COLOR2,
    ICDC_COLOR3,
    ICDC_COLOR4,
    ICDC_COLOR5
};

enum ItemConfigDataType
{
    ICDT_CON = 0,  // 消费
    ICDT_WEAPON,  //武器
    ICDT_ARMOR,
    ICDT_CLOTH,
    ICDT_FURNITURE,
    ICDT_MATERIAL,
    ICDT_IMPORTANT,
    ICDT_SKILL,
    
    ICDT_COUNT
};


enum ItemConfigDataType2
{
    ICDT2_TYPE1 = 1,
    ICDT2_TYPE2,
    ICDT2_TYPE3,
    ICDT2_TYPE4,
    
    ICDT2_COUNT
};

enum ItemConfigDataEffectType
{
    ICDET_DROP1 = 1,  // type2 1 矿
    ICDET_DROP2 = 2, // type2 2 植物
    ICDET_DROP3 = 3, // type2 3 器官
    ICDET_DROP4 = 4, // type2 4 宝石
    
    ICDET_PRO1 = 5, // 下级
    ICDET_PRO2 = 6, // 高级
    ICDET_PRO3 = 7, // 最终
    
    ICDET_SELL1 = 8, // type2 1 矿
    ICDET_SELL2 = 9, // type2 2 植物
    ICDET_SELL3 = 10, // type2 3 器官
    ICDET_SELL4 = 11, // type2 4 宝石
    
    
    ICDET_COUNT
};


enum ItemWeaponType
{
    IWT_HAMMER = 0, // 锤
    IWT_SWORD = 1, // 剑
    IWT_FIST = 2,  // 拳套
    IWT_SPEAR = 3, // 枪
    IWT_SICKLE = 4, // 镰刀
    IWT_STAFF = 5, // 杖
    IWT_BOW = 6, // 弓箭
    IWT_SMOKE = 7, // 烟斗
    IWT_FAN = 8, // 扇子
    IWT_TEETH = 9, // 牙齿
    IWT_BALL = 10, // 球
    IWT_CLAW = 11, // 爪子
    IWT_SWORD1 = 12, //剑
    
    IWT_COUNT
};



enum QuestDataType
{
    QDT_ACTIVE = 0,
    QDT_COMPLETE,
    
    QDT_COUNT
};


enum ItemArmorType
{
    IAT_RING = 0,
    IAT_SHIELD,
    
    IAT_COUNT
};


struct battleResultTurn
{
    fbyte   type;
    fbyte   side;
    
    fint16  hp;
    fint16  sp;
    fint16  fs;
    
};

struct battleResult
{
    fint32          turn;
    fint32           exp;
    //fint32          ID;
    //fint32          targetID;
    
    battleResultTurn    turns[ MAX_BATTLE_TURN ];
    
    
};


enum StoryOpenType
{
    SOT_WORLD = 1000,
    SOT_HOME = 1001,
    SOT_PROFESSION = 1002,
    SOT_ASSOCIATION = 1003,
    SOT_TIME = 1004,
    SOT_PAY = 1005,
    
    SOT_NOTOPEN0 = 88880,
    SOT_NOTOPEN1 = 88881,
    SOT_NOTOPEN2 = 88882,
    SOT_NOTOPEN3 = 88883,
    SOT_NOTOPEN4 = 88884,
    SOT_NOTOPEN5 = 88885,
    SOT_NOTOPEN6 = 88886,
    SOT_NOTOPEN7 = 88887,
    SOT_NOTOPEN8 = 88888,
    SOT_NOTOPEN9 = 88889,
};



enum WorkUpType
{
    WUT_HOME = 0,
    WUT_GROUND ,
    WUT_WORK,
    WUT_SHOP,
    
    
    WUT_COUNT
};


enum SkillTargetType
{
    STT_TARGET = 1,    // 敌人一体随机
    STT_TARGETALL = 2, // 敌人全体
    
    STT_HEALTH = 3,   // 己方一体
    STT_HEALTHALL = 4, // 己方全体
    
    STT_SELF = 5, // 施法者自己
    
    STT_SPECIAL,
    STT_OVERLOAD
};


enum SkillTrigger
{
    STG_INITIATIVE = 1, // 主动触发
    STG_ATTCK = 2, // 普通攻击时
    STG_NORMAL = 3, // 时常，装备时触发
    STG_DIG = 4, // 挖掘时触发
    STG_HIT = 5, // 受击时触发
    STG_DEAD = 6, // 死亡时触发
    
};

enum SkillTriggerType
{
    STGT_INITIATIVE = 1, // 主动
    STGT_PASSIVE = 2,    // 被动
};

enum SkillTriggerEffect
{
    STGE_NULL = 0, // 无
    STGE_HP = 1,   // 伤害HP（物攻默认attr=0）可持续 type1/2 target1/2 trigger1/2 power attr turn hit
    STGE_HP1 = 2,   // 伤害HP并且自毁 type1/2 target1/2 trigger1/2 power power1（自毁的系数）attr hit
    STGE_HP2 = 3,   // 随机n名敌人伤害HP type1/2 target1/2 trigger1/2 power power1(n) attr hit
    STGE_HP3 = 4,   // 额外目标一定伤害 type1/2 target1/2 trigger1/2 power power1 attr hit
    STGE_HP4 = 5,   // 直接伤害HP type2 trigger1 power
    STGE_HP5 = 6,   // 吸血
    
    STGE_FASTATTACK = 10, // 优先攻击 type1 trigger2
    STGE_FASTATTACK2 = 11, //
    STGE_GIDDINESS = 12, // 眩晕 附带HP 可持续 type1/2 target1/2 trigger1/2 power attr hit turn
    STGE_CHARGE = 13, // 蓄力攻击，经过回合后攻击。type1/2 target1/2 trigger1 attr power turn
    STGE_SP = 14, // 伤害SP type2 target1/2 trigger1/2 power hit turn
    STGE_GOLD = 15, // 炼金 type1/2 target1/2 trigger1/2 power转换金币的倍数 hit
    
    STGE_HEALTH = 20, // 回复数值 可持续 type2 target3/4 trigger1 power turn
    STGE_HEALTH1 = 21, // 回复百分比 可持续 type2 target3/4 trigger1 power turn
    STGE_RELIVE = 22, // 复活 type2 target3/4 trigger1 power
    STGE_DEATH = 23, // 即死 type2 target1/2 trigger1 hit
    STGE_DEATH1 = 24, // 命中降低即死 type1 target1/2 trigger2 triggerType2 hit
    STGE_DEATH2 = 25, // 行动时即死 type2 target1/2 trigger1 hit turn
    STGE_DEATH3 = 26, // HP小于多少即死 type2 target1/2 trigger1 hit power小于系数 turn
    STGE_DEATH4 = 27, // 死亡后复活 type2 trigger6 hit
    STGE_DEATH5 = 28, // 牺牲自己复活己方（只有自己存活时） type2 trigger1
    STGE_HATRED = 29, // 仇恨攻击目标是自己 同时增加物防和HP 可持续 target2 trigger1 power power1 attr hit turn
    STGE_HEALTHSP = 30, // 回复SP值 type2 target3/4 trigger1/2 power hit turn
    STGE_HEALTHSP1 = 31, // 回复SP百分比 type2 target3/4 trigger1/2 power hit turn
    
    
    STGE_MAXHP = 40, // 增加或降低最大HP 可持续 type2 target1/2/3/4 trigger1/3 power attr hit turn
    STGE_MAXSP = 41, // 增加或降低最大SP 可持续 type2 target1/2/3/4 trigger1/3 power attr hit turn
    STGE_DEFATTR = 42, // 增加或降低属性抗性 可持续 type2 target1/2/3/4 trigger1/3 power attr hit turn
    STGE_SPEED = 43, // 增加或降低速度 可持续 type2 target1/2/3/4 target1/3 power hit turn
    STGE_MISS = 44, // 增加或降低闪避 可持续 type2 target1/2/3/4 target1/3 power hit turn
    STGE_HIT = 45, // 增加或降低命中 可持续 type2 target1/2/3/4 target1/3 power hit turn
    STGE_PATK = 46, // 增加或降低物攻 可持续 type2 target1/2/3/4 trigger1/3 power hit turn
    STGE_MATK = 47, // 增加或降低魔攻 可持续 type2 target1/2/3/4 trigger1/3 power hit turn
    STGE_PDEF = 48, // 增加或降低物防 可持续 type2 target1/2/3/4 trigger1/3 power hit turn
    STGE_MDEF = 49, // 增加或降低魔防 可持续 type2 target1/2/3/4 trigger1/3 power hit turn
    STGE_CT = 50, // 增加或降低暴击率 可持续 type2 target1/2/3/4 trigger1/3 power hit turn
    STGE_BUFF = 51, // 移除我方不利buff type2 target/3/4 trigger1 hit
    STGE_BUFF1 = 52, // 免疫所有不利buff trigger3 hit
    
    
    STGE_DIG = 60, // 挖掘或采集时候物品翻倍。dig倍数 trigger4
};

enum SkillType
{
    ST_PHYSICAL = 1,
    ST_MAGIC = 2,
};


//struct gameCreatureBaseData
//{
//    fint16  HP;
//    fint16  maxHP;
//    fint16  SP;
//    fint16  maxSP;
//    fint16  FS;
//    fint16  maxFS;
//    
//    fint16  pAtk;
//    fint16  pDef;
//    
//    fint16  mAtk;
//    fint16  mDef;
//    
//    fint16  agile;
//    fint16  lucky;
//    
//    fint16  hit;
//    fint16  miss;
//    
//    fint16  critical;
//    fint16  move;
//    
//    fint16  cp;
//    fint16  guest;
//    
//    fint16  command;
//    fint16  kill;
//    
//    gameCreatureBaseData()
//    :   HP( 0 ) , maxHP( 0 ) , SP( 0 ) , maxSP( 0 ) , FS( 0 ) , maxFS( 0 ) ,
//    pAtk( 0 ) , pDef( 0 ) ,
//    mAtk( 0 ) , mDef( 0 ) ,
//    agile( 0 ) , lucky( 0 ) ,
//    hit( 0 ) , miss( 0 ) ,
//    critical( 0 ) , move( 0 ) ,
//    cp( 0 ) , guest( 0 ) ,
//    command( 0 ) , kill( 0 )
//    {
//        
//    }
//};
//
//
//struct gameCreatureCommonData
//{
//    fint32  ID;
//    fint32  titleID;
//    
//    fbyte   name[ MAX_NAME ];
//    
//    fint16  type;
//    fint16  battle;
//    
//    fint16  level;
//    fint16  weaponLevel;
//    
//    fint16  EXP;
//    fint16  maxEXP;
//    
//    fbyte   attribute[ GCACount ];
//    
//    fint16  skill[ MAX_SKILL ];
//    
//    fint32  equip[ GCECount ];
//    
//    
//    gameCreatureBaseData baseData;
//    //gameCreatureBaseData advance;
//    
//    
//    gameCreatureCommonData()
//    :   ID( 0 ) , titleID( 0 ) ,
//    type( 0 ) , battle( 0 ) ,
//    level( 0 ) , weaponLevel( 0 ) ,
//    EXP( 0 ) , maxEXP( 0 )
//    {
//        memset( name , 0 , sizeof(fbyte) * MAX_NAME );
//        memset( attribute , 0 , sizeof(fbyte) * GCACount );
//        memset( skill , 0 , sizeof(fint16) * MAX_SKILL );
//        memset( equip , 0 , sizeof(fint32) * GCECount );
//    }
//};
//
//
//typedef map< fint32 , gameCreatureCommonData > gameCreatureCommonDataMap;
//typedef map< fint32 , gameCreatureCommonData >::iterator gameCreatureCommonDataMapIter;
//
//



enum resType
{
    RESPHONE3,
    RESPHONE4,
    RESPHONE5,
    RESPAD2,
    RESPAD3,
};
typedef struct tagResource
{
    CGSize sizeInPixel;
    CGSize sizeDesign;
    freal32 scale;
    fint32 type;
}
Resource;

//static Resource resPhone  =  { CCSizeMake(320,480), CCSizeMake(320,480), 1.0f, RESPHONE3 , "iphone" };
//static Resource resPhoneRetina35 =  { CCSizeMake(640 ,960), CCSizeMake(320,480), 2.0f, RESPHONE4 , "iphone" };
//static Resource resPhoneRetina40 =  { CCSizeMake(640,1136), CCSizeMake(320,568), 2.0f, RESPHONE5 , "iphone5" };
//static Resource resTable =  { CCSizeMake(768,1024), CCSizeMake(768,1024), 1.0f, RESPAD2 , "ipad" };
//static Resource resTableRetina  =  { CCSizeMake(1536,2048), CCSizeMake(768,1024), 2.0f, RESPAD3 , "ipad" };

static Resource resPhone  =  { CGSizeMake(480,320), CGSizeMake(480,320), 1.0f, RESPHONE3 };
static Resource resPhoneRetina35 =  { CGSizeMake(960 ,640), CGSizeMake(480,320), 2.0f, RESPHONE4 };
static Resource resPhoneRetina40 =  { CGSizeMake(1136,640), CGSizeMake(568,320), 2.0f, RESPHONE5 };
static Resource resTable =  { CGSizeMake(1024,768), CGSizeMake(1024,768), 1.0f, RESPAD2 };
static Resource resTableRetina  =  { CGSizeMake(2048,1536), CGSizeMake(1024,768), 2.0f, RESPAD3 };

extern Resource gActualResource;


#endif
