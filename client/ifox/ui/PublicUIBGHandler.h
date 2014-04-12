//
//  PublicUIBGHandler.h
//  sc
//
//  Created by fox on 13-12-1.
//
//

#import "UIHandlerZoom.h"

@interface PublicUIBGHandler : UIHandlerZoom

- ( void ) setImage:( UIImageView* )image;

+ ( PublicUIBGHandler* ) instance;

@end
