//
//  GameLogin.h
//  sc
//
//  Created by fox1 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLogin : NSObject
{
    BOOL inited;
    
    CCScene* loginScene;
}


- ( void ) initGameLogin;
- ( void ) releaseGameLogin;

+ ( GameLogin* ) instance;

@end


