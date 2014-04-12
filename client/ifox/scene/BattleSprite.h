//
//  BattleSprite.h
//  sc
//
//  Created by fox on 13-2-13.
//
//

#import "CCSprite.h"
#import "GameUnit.h"

@class BattleSpriteAction;

@interface BattleSprite : GameUnit
{
    BattleSpriteAction* battleSpriteAction;
    
    NSObject* object;
    SEL sel;
}

@property ( nonatomic ) int Type , PosX , PosY;

- ( void ) setPos:( int ) x :( int )y;

- ( void ) update:( float )delay;

- ( void ) playEffect:( NSString* )e :(NSObject*)o :(SEL)s;

- ( void ) setAction:( int )i;
- ( void ) setActionID:( NSString* )i ;
- ( int ) getActionIndex;

- ( void ) initBattleSprite;
- ( void ) releaseBattleSprite;

@end
