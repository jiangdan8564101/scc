//
//  PlayerInfoUIHandler.h
//  sc
//
//  Created by fox on 13-9-8.
//
//

#import "UIHandlerZoom.h"
#import "PlayerInfoScrollView.h"

enum
{
    PlayerInfoUINormal = 0,
    PlayerInfoUIEmploy = 1,
    PlayerInfoUIItem = 2,
};


@interface PlayerInfoUIHandler : UIHandlerZoom< UIScrollViewDelegate >
{
    PlayerInfoScrollView* scrollView;
    
    UILabel* scrollPageLabel;
    
    UIImageView* imageView;
    
    NSMutableArray* itemArray;
    CGPoint centerPoint;
    
    UIButton* employButton;
    UIButton* fireButton;

    int mode;
    
    UILabel* employLabel;
    UILabel* goldLabel;
}


- ( void ) setMode:( int )m;
- ( void ) setFireMode;
- ( void ) setPos:( int )p;

+ ( PlayerInfoUIHandler* ) instance;

@end
