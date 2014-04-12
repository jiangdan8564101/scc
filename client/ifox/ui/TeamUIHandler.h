//
//  TeamUIHandler.h
//  sc
//
//  Created by fox on 13-9-15.
//
//

#import "UIHandlerZoom.h"
#import "CreatureScrollView.h"

@interface TeamUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    CreatureScrollView* scrollView;
    UILabel* pageLabel;
    
    CreatureListItem* team[ MAX_BATTLE_PLAYER ];
    UIButton* teamButton[ MAX_TEAM ];
    
    int selectTeam;
    
    UILabel* teamLabel;
}

+ ( TeamUIHandler* ) instance;

@end


