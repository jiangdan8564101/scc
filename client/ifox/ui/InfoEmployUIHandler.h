//
//  InfoEmployUIHandler.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "UIHandlerZoom.h"
#import "InfoEmployScrollView.h"


@interface InfoEmployUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    InfoEmployScrollView* scrollView;
    UILabel* pageLabel;
    
    InfoEmployItem* selectEmploy;
    
    CGPoint centerPoint;
    UIImageView* imageView;
}

+ ( InfoEmployUIHandler* ) instance;


@end
