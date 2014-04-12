//
//  BattleTopUIHandler.h
//  sc
//
//  Created by fox on 13-2-13.
//
//

#import "UIHandler.h"
#import <iAd/iAd.h>

@interface BattleTopUIHandler : UIHandler< ADBannerViewDelegate >
{
    UIImageView* imageView;
    float width;
    
    ADBannerView* ADBView;
}

+ ( BattleTopUIHandler* ) instance;

- ( void ) updateData;
- ( void ) setPer:( float )p;
- ( void ) setSendData:( int )c;

@end
