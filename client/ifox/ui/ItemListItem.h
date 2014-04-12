//
//  ItemListItem.h
//  sc
//
//  Created by fox on 13-6-2.
//
//

#import <UIKit/UIKit.h>
#import "ItemData.h"
#import "ProfessionConfig.h"
#import "UILabelStroke.h"

enum ItemListItemType
{
    ILIT_CLEAR = 0,
    ILIT_EQUIP,
    ILIT_CANEQUIP,
    ILIT_NOTEQUIP,
};

@interface ItemListItem : UIView
{

}

@property ( nonatomic ) int Index , SkillID , ItemID;

- ( void ) setEquip:( int )e;
- ( void ) setData:( PackItemData* )d;
- ( void ) setSkillData:( ProfessionSkillData* )d;
- ( void ) setNumber:( int )n;
- ( void ) setSelect:( BOOL )b;

@end
