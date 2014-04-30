//
//  AlchemyUIItem.h
//  sc
//
//  Created by fox on 13-11-2.
//
//

#import <UIKit/UIKit.h>
#import "AlchemyConfig.h"
#import "UIFastScrollViewItem.h"

@interface AlchemyUIItem : UIFastScrollViewItem
{
    UIButton* touchDonw;
    float timeTouch;
}

@property( nonatomic ) int AlchemyID , Num;

- ( void ) updateCanAlchemy;
- ( void ) update:( float )delay;

@end
