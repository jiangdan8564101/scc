//
//  GameManager.h
//  sc
//
//  Created by fox1 on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameManager : NSObject
{
    NSTimer* timer;
    
    double nowTime;
    double lastTime;
    
    float delay;
    
    float spTime;
    float employTime;
}

+ ( GameManager* ) instance;

- ( void ) getError;

- ( void ) initGameManager;
- ( void ) releaseGameManager;

- ( void ) start;
- ( void ) stop;



@end
