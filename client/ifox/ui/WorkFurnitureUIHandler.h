//
//  WorkFurnitureUIHandler.h
//  sc
//
//  Created by fox on 13-11-18.
//
//

#import "UIHandler.h"
#import "ItemListScrollView.h"

#import "WorkWorkFloor.h"

@interface WorkFurnitureUIHandler : UIHandler< UIScrollViewDelegate >
{
    ItemListScrollView* itemScrollView;
    UILabel* itemPageLabel;
    
    ItemListItem* selectItem;
    
    UILabel* namelabel;
    UITextView* des1label;
    
}

+ ( WorkFurnitureUIHandler* ) instance;

- ( void ) update:( float ) delay;

@end




