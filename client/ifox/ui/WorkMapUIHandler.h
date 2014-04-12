//
//  WorkMapUIHandler.h
//  sc
//
//  Created by fox on 13-1-15.
//
//

#import "UIHandlerZoom.h"

@interface WorkMapUIHandler : UIHandlerZoom
{
    UIButton* mainbutton[ 5 ];
    UIButton* workButton[ 5 ];
    UIButton* infoButton[ 5 ];
}


+ ( WorkMapUIHandler* ) instance;

@end
