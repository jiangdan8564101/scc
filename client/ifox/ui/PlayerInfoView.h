//
//  PlayerInfoView.h
//  sc
//
//  Created by fox on 13-9-15.
//
//

#import <UIKit/UIKit.h>
#import "CreatureConfig.h"
#import "UIFastScrollViewItem.h"

@interface PlayerInfoView : UIFastScrollViewItem
{
    float imageWidth;
}

@property( nonatomic ) int CreatureID;


@end
