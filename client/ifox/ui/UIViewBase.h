//
//  UIViewBase.h
//  sc
//
//  Created by fox1 on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClientDefine.h"

@interface UIViewBase : UIView
{
    NSObject* handler;
    
}



@property (nonatomic , assign) NSObject* Handler;

- ( void ) initUIViewBase:( NSObject* )obj;

@end

