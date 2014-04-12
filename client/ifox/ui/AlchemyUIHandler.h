//
//  AlchemyUIHandler.h
//  sc
//
//  Created by fox on 13-10-7.
//
//

#import "UIHandlerZoom.h"
#import "AlchemyScrollView.h"
#import "UILabelStroke.h"
#import "ItemSkillView.h"

@interface AlchemyUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    NSMutableArray* array;
    
    int selectTab;
    AlchemyUIItem* selectItem;
    
    AlchemyScrollView* scrollView;
    int itemPage[ ICDT_COUNT ];
    UILabel* pageLabel;
    
    
    UIImageView* alchemyItem[ MAX_ALCHEMY_ITEM ];
    UILabel* alchemyItemName[ MAX_ALCHEMY_ITEM ];
    UILabel* alchemyItemNeed[ MAX_ALCHEMY_ITEM ];
    UILabel* alchemyItemGet[ MAX_ALCHEMY_ITEM ];
    
    
    UILabel* namelabel;
    UITextView* des1label;
    UILabel* deslabelPro;
    
    ItemSkillView* skillView[ MAX_ITEM_SKILL ];
    
    NSMutableDictionary* alchemyItemNumDic;
    NSMutableDictionary* alchemyNumDic;
}


+ ( AlchemyUIHandler* ) instance;

- ( void ) updateAlchemyItems;

- ( BOOL ) canAlchemyItem:( int )alchemyID;

- ( int ) getAlchemyNum:( int )item;
- ( void ) setAlchemyNum:( int )item :( int )num;

@end
