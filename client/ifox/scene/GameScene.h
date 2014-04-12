//
//  GameScene.h
//  sc
//
//  Created by fox1 on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameAudioManager.h"

@interface GameScene : CCScene< CCTargetedTouchDelegate , NSXMLParserDelegate >
{
    NSString* name;
    
    BOOL inited;
}

@property ( nonatomic , assign ) NSString* Name;

- ( void ) setBG:( NSString* )name;
- ( void ) fade:( float )f;
- ( void ) fadeRight:( float )f;
- ( void ) fadeLeft:( float )f;

- ( void ) releaseScene;
- ( void ) initScene:( NSString* ) name;
- ( void ) onInited;


- ( void ) onEnterMap;
- ( void ) onExitMap;


- ( void ) update:( float )delay;

@end


