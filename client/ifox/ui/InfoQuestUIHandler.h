//
//  InfoQuestUIHandler.h
//  sc
//
//  Created by fox on 13-12-5.
//
//

#import "UIHandlerZoom.h"
#import "InfoQuestScrollView.h"
#import "InfoQuestItem.h"
#import "UILabelStroke.h"

@interface InfoQuestUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    InfoQuestScrollView* scrollView;
    UILabel* pageLabel;
    
    InfoQuestItem* selectQuest;
}

+ ( InfoQuestUIHandler* ) instance;

@end
