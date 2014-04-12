//
//  ProfessionUIBGHandler.h
//  sc
//
//  Created by fox on 13-12-1.
//
//

#import "UIHandlerZoom.h"

@interface ProfessionUIBGHandler : UIHandlerZoom
{

}

- ( void ) setImage:( UIImageView* )image;

+ ( ProfessionUIBGHandler* ) instance;

@end

