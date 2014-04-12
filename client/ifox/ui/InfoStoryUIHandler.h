//
//  InfoStoryUIHandler.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "UIHandlerZoom.h"
#import "InfoStoryItem.h"
#import "InfoStoryScrollView.h"

@interface InfoStoryUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    InfoStoryScrollView* scrollView;
    UIPageControl* pageControl;
    
    InfoStoryItem* selectStory;
}

+ ( InfoStoryUIHandler* ) instance;


@end
