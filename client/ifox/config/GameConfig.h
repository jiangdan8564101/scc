//
//  GameConfig.h
//  sc
//
//  Created by fox on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClientDefine.h"

@interface GameConfig : NSObject< NSXMLParserDelegate >

- ( void ) initConfig;
- ( void ) releaseConfig;


@end
