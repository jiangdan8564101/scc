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
    
}

@property( nonatomic ) int AlchemyID , Num;

- ( void ) updateCanAlchemy;

@end
