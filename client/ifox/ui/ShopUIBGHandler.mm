//
//  ShopUIBGView.m
//  sc
//
//  Created by fox on 13-11-29.
//
//

#import "ShopUIBGHandler.h"

@implementation ShopUIBGHandler

static ShopUIBGHandler* gShopUIBGHandler;
+ (ShopUIBGHandler*) instance
{
    if ( !gShopUIBGHandler )
    {
        gShopUIBGHandler = [ [ ShopUIBGHandler alloc] init ];
        [ gShopUIBGHandler initUIHandler:@"ShopUIBGView" isAlways:YES isSingle:NO ];
    }
    
    return gShopUIBGHandler;
}


- ( void ) onClosed
{
    [ super onClosed ];
    
    UIImageView* imageView = (UIImageView*)[ view viewWithTag:1200 ];
    [ imageView setImage:NULL ];
}


- ( void ) setImage:( UIImageView* )image
{
    UIImageView* imageView = (UIImageView*)[ view viewWithTag:1200 ];
    [ imageView setImage:image.image ];
    [ imageView setFrame:image.frame ];
}


@end
