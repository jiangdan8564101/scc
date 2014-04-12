//
//  WorkOutlayUIHandler.h
//  sc
//
//  Created by fox on 13-12-4.
//
//

#import "UIHandlerZoom.h"
#import "UILabelStroke.h"


@interface WorkOutlayUIHandler : UIHandlerZoom
{
    BOOL isShowPay;
}

- ( void ) updateData:( int )d;
- ( void ) showPay;

+ ( WorkOutlayUIHandler* ) instance;

@end
