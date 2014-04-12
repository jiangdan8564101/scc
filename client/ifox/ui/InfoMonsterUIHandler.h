//
//  InfoMonsterUIHandler.h
//  sc
//
//  Created by fox on 13-12-31.
//
//

#import "UIHandlerZoom.h"
#import "InfoMonsterScrollView.h"
#import "UICreatureAction.h"


@interface InfoMonsterUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    InfoMonsterScrollView* scrollView;
    UILabel* pageLabel;
    
    InfoMonsterItem* selectMonster;
    
    CGPoint centerPoint;    
    UICreatureAction* creatureAction;
}

+ ( InfoMonsterUIHandler* ) instance;


@end
