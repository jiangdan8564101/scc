//
//  GameEffect.h
//  sc
//
//  Created by fox on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "ClientDefine.h"


@interface GameEffect : CCSprite
{
    NSMutableDictionary* effectDic;
}


- ( void ) addEffect:( NSString* )i;
- ( void ) removeEffect:( NSString* )i;
- ( void ) setEffectPos:( NSString* )i :( float )x :( float )y;

- ( void ) removeAllEffect;


- ( void ) initEffect;
- ( void ) releaseEffect;

@end

