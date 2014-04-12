
//
//  WorkWorkFloor.h
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import <UIKit/UIKit.h>
#import "UICreatureAction.h"
#import "UIEffectAction.h"

@interface WorkWorkFloor : UIButton
{
    UICreatureAction* creatureAction;
    UIEffectAction* effect;
    
    UIImageView* imageView;
}

@property ( nonatomic ) int ItemID , Type;

- ( void ) setCreatureAction:( NSString* )a;
- ( void ) clearCreatureAction;

- ( void ) setItem:( int )item;
- ( void ) clearItem;
- ( void ) removeItem;
- ( void ) update:( float )d;

@end
