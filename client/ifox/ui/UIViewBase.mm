//
//  UIViewBase.m
//  sc
//
//  Created by fox1 on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewBase.h"
#import "UIHandler.h"
#import "GameUIManager.h"


@implementation UIViewBase
@synthesize Handler = handler;


- ( void ) initUIViewBase:(NSObject *)obj
{
    handler = obj;
}




@end
