//
//  ShopUIBGHandler.h
//  sc
//
//  Created by fox on 13-11-29.
//
//

#import "UIHandlerZoom.h"

@interface ShopUIBGHandler : UIHandlerZoom
{
}

- ( void ) setImage:( UIImageView* )image;

+ ( ShopUIBGHandler* ) instance;

@end
