//
//  GameMain.h
//  sc
//
//  Created by fox1 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameMain : NSObject
{
    BOOL inited;
    
    
}


- ( void ) initGameMain;
- ( void ) releaseGameMain;

+ ( GameMain* ) instance;

@end
