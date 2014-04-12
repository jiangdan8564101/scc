//
//  PublicUIBGHandler.m
//  sc
//
//  Created by fox on 13-12-1.
//
//

#import "PublicUIBGHandler.h"

@implementation PublicUIBGHandler


static PublicUIBGHandler* gPublicUIBGHandler;
+ (PublicUIBGHandler*) instance
{
    if ( !gPublicUIBGHandler )
    {
        gPublicUIBGHandler = [ [ PublicUIBGHandler alloc] init ];
        [ gPublicUIBGHandler initUIHandler:@"PublicUIBGView" isAlways:YES isSingle:NO ];
    }
    
    return gPublicUIBGHandler;
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
