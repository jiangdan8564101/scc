//
//  BattleMapSprite.h
//  sc
//
//  Created by fox on 13-1-19.
//
//

#import "cocos2d.h"
#import "ClientDefine.h"
#import "BattleCreature.h"
#import "BattleSprite.h"
#import "BattleMapMaskSprite.h"

#define MAX_REGION 64
#define MAX_SPRITE 64

#define MAX_SPRITE_SIZE 100
#define MAX_SPRITE_SIZE_HALF 50

#define ACT_MOVE_MASK @"actMoveMask.png"
#define ACT_MOVE_MASKW @"actMoveMaskW.png"

#define ACT_MOVE_STAY @"actStayMaskW.png"

enum BattleMapSpriteACTType
{
    BMSACTT_MOVE = 0,
    BMSACTT_STAY,
    BMSACTT_ATTACK,
    BMSACTT_ATTACK_SHOT,
    BMSACTT_ATTACK_ALL,
    
    
    BMSACTT_COUNT
};

@class BattleMapLayer;

@interface BattleMapSprite : CCSprite
{
    NSObject* object;
    SEL sel;
    
    CCSprite* ACTMaskSprite;

    NSMutableArray* maskArray;
    
    BattleMapMaskSprite* maskSprite;
}


@property ( nonatomic , assign ) NSString* TextureName;
@property ( nonatomic ) int TexturePosX , TexturePosY;
@property ( nonatomic ) int PosX , PosY;
@property ( nonatomic ) int Type , Door , RegionID;
@property ( nonatomic , assign ) BattleCreature* Creature;
@property ( nonatomic , assign ) BattleSprite* Sprite;
@property ( nonatomic , assign ) BattleMapLayer* MapLayer;

- ( void ) loadMask;
- ( void ) load:( NSObject* )obj :( SEL )s;

- ( void ) addACTMask:( int )t;
- ( void ) removeACTMask;

- ( void ) setMaskGourp:( int )g;

@end
