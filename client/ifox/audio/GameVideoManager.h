//
//  GameVideoManager.h
//  ixyhz
//
//  Created by fox on 12-12-14.
//
//

#import <Foundation/Foundation.h>

#import "GameVideoPlayer.h"

@interface GameVideoManager : NSObject
{
    
}

- ( GameVideoPlayer* ) Play:( NSString* )path :(UIView*)view;
- ( GameVideoPlayer* ) PlayURL:( NSString* )path :(UIView*)view;

- ( void ) PlayOne:( NSString* )path :(UIView*)view :( NSObject* )obj :(SEL)sel;
- ( void ) PlayOneURL:( NSString* )path :(UIView*)view :( NSObject* )obj :(SEL)sel;

+ ( GameVideoManager* ) instance;

@end
