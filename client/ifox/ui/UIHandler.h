//
//  UIHandler.h
//  sc
//
//  Created by fox1 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameNetManager.h"
#import "UIViewBase.h"


@interface UIHandler : NSObject
{    
    UIViewBase* view;
    NSMutableString* viewName;
    
    BOOL isSingle;
    BOOL isAlways;
    BOOL isOpened;
    
    UIActivityIndicatorView* aiView;
    NSTimer* aiTimer;
    
    NSArray* uiArray;
}

@property ( readonly ) UIViewBase* View;
@property ( readonly ) BOOL IsSingle, IsAlways , isOpened;
@property ( assign , nonatomic ) NSArray* uiArray;

- ( void ) initUIHandler:(NSString*)sViewName isAlways:( BOOL )bIsAlways isSingle:( BOOL )bIsSingle;

- ( void ) visible :( BOOL )bVisible;

- ( void ) loadingStart;
- ( void ) loadingStop;

- ( void ) onInited;
- ( void ) onRelease;
- ( void ) onOpened;
- ( void ) onClosed;

- ( void ) close;

- ( void ) update:( float ) delay;

@end
