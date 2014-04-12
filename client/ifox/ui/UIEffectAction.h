//
//  UICreatureAction.h
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import <UIKit/UIKit.h>
#import "GameCreatureAction.h"

@interface UIEffectAction : UIImageView
{
    BOOL inited;
    BOOL started;

    NSString* actionID;
    
    NSObject* object;
    SEL sel;
    
    CGPoint position;
    
    float time;
    float duration;
    int index;
    
    NSMutableArray* imageNames;
}

@property( nonatomic ) BOOL PlaySound;

- ( void ) initUIEffect:( NSObject* )obj :( SEL )s;
- ( void ) releaseUIEffect;

- ( void ) playEffect:( NSString* )i;
- ( void ) update:( float )d;

@end

