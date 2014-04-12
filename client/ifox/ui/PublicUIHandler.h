//
//  PublicUIHandler.h
//  sc
//
//  Created by fox on 13-9-8.
//
//

#import "UIHandler.h"
#import "UIHandlerZoom.h"

@interface PublicUIHandler : UIHandlerZoom
{
    UILabel* goldLabel;
}


+ ( PublicUIHandler* ) instance;

- ( void ) updateGold;

@end
