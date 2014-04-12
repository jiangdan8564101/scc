//
//  BattleUnit.h
//  sc
//
//  Created by fox on 13-4-17.
//
//

#import "cocos2d.h"

@interface GameUnit : CCSprite< CCTargetedTouchDelegate >
{

}

- (BOOL)containsTouchLocation:(UITouch *)touch;

@property ( nonatomic ) int Group , BOSS , Event;

@end
