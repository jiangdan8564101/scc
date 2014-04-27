//
//  GameUIManager.h
//  ixyhz
//
//  Created by fox1 on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewBase.h"


@interface GameUIManager : NSObject
{
    UIView* rootView;
    
    NSArray* uiArray;
    
    
}



+ (GameUIManager*)instance;

@property ( assign ) dispatch_queue_t LoadingQueue;
@property( nonatomic , assign )UIView *rootView;

- ( void ) update:( float ) delay;

- ( UIView* ) getUI:( int )tag;

- ( void ) addUI:( UIViewBase* )ui;
- ( void ) removeAllUI;
- ( void ) removeAllUI:(UIViewBase*)exceptView;
- ( void ) removeAllUI:(UIViewBase*)exceptView includeAlways:(BOOL)includeAlways;

- ( void ) releaseAllUI;

- ( void ) initGameUIManager;
- ( void ) releaseGameUIManager;


@end
