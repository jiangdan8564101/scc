//
//  AppDelegate.h
//  ixyhz
//
//  Created by fox1 on 12-7-10.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"
#import "AppViewController.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	AppViewController *navController_;
    
	CCDirectorIOS	*director_;							// weak ref
}


@property ( nonatomic , retain ) UIWindow *window;
@property ( nonatomic , readonly ) UINavigationController *navController;
@property ( nonatomic , readonly ) CCDirectorIOS *director;

@end
