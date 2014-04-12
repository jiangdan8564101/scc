//
//  ProfessionListItem.h
//  sc
//
//  Created by fox on 13-11-17.
//
//

#import <UIKit/UIKit.h>
#import "ProfessionConfig.h"
#import "UIFastScrollViewItem.h"


enum ProfessionListItemType
{
    PLIT_CLEAR = 0,
    PLIT_EQUIP,
    PLIT_CANEQUIP,
    PLIT_NOTEQUIP,
};


@interface ProfessionListItem : UIFastScrollViewItem
{

}

@property ( nonatomic ) int ProID;

- ( void ) setNumber;
- ( void ) setLevel:( int )l;
- ( void ) setEquip:( int )e;

@end
