//
//  ProfessionUIBGHandler.m
//  sc
//
//  Created by fox on 13-12-1.
//
//

#import "ProfessionUIBGHandler.h"

@implementation ProfessionUIBGHandler


static ProfessionUIBGHandler* gProfessionUIBGHandler;
+ ( ProfessionUIBGHandler* ) instance
{
    if ( !gProfessionUIBGHandler )
    {
        gProfessionUIBGHandler = [ [ ProfessionUIBGHandler alloc] init ];
        [ gProfessionUIBGHandler initUIHandler:@"ProfessionUIBGView" isAlways:YES isSingle:NO ];
    }
    
    return gProfessionUIBGHandler;
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
