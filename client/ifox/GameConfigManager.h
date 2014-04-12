//
//  GameConfigManager.h
//  sc
//
//  Created by fox1 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameConfigManager : NSObject
{
    
}


+ ( GameConfigManager* ) instance;

- ( void ) initConfig;
- ( void ) releaseConfig;

@end
