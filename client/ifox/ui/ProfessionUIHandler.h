//
//  ProfessionUIHandler.h
//  sc
//
//  Created by fox on 13-11-17.
//
//

#import "UIHandlerZoom.h"
#import "CreatureScrollView.h"
#import "ProfessionListScrollView.h"


@interface ProfessionUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    CreatureScrollView* creatureScrollView;
    UILabel* creaturePageLabel;
    
    ProfessionListScrollView* proScrollView;
    UILabel* proPageLabel;
    
    ProfessionListItem* selectPro;
    CreatureListItem* selectCreature;
    
    
    UILabel* nameLabel;
    UILabel* conLabel;
    UITextView* desLabel;
    UILabel* con1Label;
    UILabel* goldLabel;
}

+ ( ProfessionUIHandler* ) instance;

@end


