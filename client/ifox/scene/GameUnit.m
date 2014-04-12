//
//  BattleUnit.m
//  sc
//
//  Created by fox on 13-4-17.
//
//

#import "GameUnit.h"

@implementation GameUnit



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    return NO;
}

@synthesize Group , BOSS , Event;

@end
