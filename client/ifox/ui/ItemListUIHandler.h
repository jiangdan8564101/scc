//
//  ItemListUIHandler.h
//  sc
//
//  Created by fox on 13-6-2.
//
//

#import "UIHandlerZoom.h"
#import "ItemListItem.h"

#import "CreatureScrollView.h"
#import "ItemListScrollView.h"

#import "ItemSkillView.h"

#import "ItemPlayerInfoView.h"

@interface ItemListUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    CreatureScrollView* creatureScrollView;
    UILabel* creaturePageLabel;
    
    ItemListScrollView* itemScrollView;
    int itemPage[ ICDT_COUNT ];
    UILabel* itemPageLabel;
    
    int selectTab;
    ItemListItem* selectItem;
    CreatureListItem* selectCreature;
    
    UILabel* namelabel;
    UITextView* deslabel;
    UILabel* deslabelPro;
    
    ItemSkillView* skillView[ MAX_ITEM_SKILL ];
    
    UIImageView* imageView;
    CGPoint centerPoint;
    
    ItemPlayerInfoView* infoView;
    
    UIButton* equip[ MAX_EQUIP ];
    UIButton* equipCancel[ MAX_EQUIP ];
    UILabel* equipLabel[ MAX_EQUIP ];
    
    
    UILabel* skillLabel[ MAX_SKILL ];
    UIButton* skillEquip[ MAX_SKILL ];
    UIButton* skillCancelEquip[ MAX_SKILL ];
    
}


+ ( ItemListUIHandler* ) instance;




@end
