//
//  ShopUIHandler.h
//  sc
//
//  Created by fox on 13-11-5.
//
//

#import "UIHandlerZoom.h"
#import "ShopSellScrollView.h"
#import "UILabelStroke.h"





@interface ShopUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    ShopSellScrollView* scrollView;
    UILabel* scrollPageLabel;
    int page;
    
    ShopListItem* selectItem;
    
    UILabel* namelabel;
    UITextView* des1label;
    
    UILabelStroke* goldLabel;
    UILabelStroke* sellLabel;
    UILabelStroke* userGoldLabel;
    
    
    UIButton* buyButton;
    UIButton* sellButton;
    
    UIImageView* buyImageView;
    UIImageView* sellImageView;
    
    NSMutableDictionary* shopItemNum;
    
    BOOL canBuy;
}

@property ( nonatomic ) BOOL BuyMode;

+ ( ShopUIHandler* ) instance;

- ( void ) updateData;

- ( void ) setShopItemNum:( int )item :( int )num;
- ( int ) getShopItemNum:( int )item;

@end
