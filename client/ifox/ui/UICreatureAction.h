//
//  UICreatureAction.h
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import <UIKit/UIKit.h>
#import "GameCreatureAction.h"

@interface UICreatureAction : UIImageView
{
    BOOL inited;
    
    float scale;
    
    BOOL loop;
    
    UIImage* image;
    UIImage* imageEnd;
    NSString* imagePath;

    
    NSString* actionID;
    NSString* action;
    int direction;
    
    CGPoint position;
}

- ( void ) setPos:( CGPoint )point;

- ( void ) initCreatureActionView:( NSString* )i;
- ( void ) releaseCreatureActionView;

- ( void ) setLoop:( BOOL )b;
- ( void ) setScale:( float )s;
- ( void ) setAction:( NSString* )a :( int )d;

@end

