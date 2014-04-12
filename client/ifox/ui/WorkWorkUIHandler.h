//
//  WorkWorkUIHandler.h
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import "UIHandlerZoom.h"
#import "WorkWorkFloor.h"

@interface WorkWorkUIHandler : UIHandlerZoom
{
    WorkWorkFloor* workButton[ WUT_COUNT ][ 32 ];
}

+ ( WorkWorkUIHandler* ) instance;


@property ( nonatomic , assign ) WorkWorkFloor* SelectFloor;

- ( void ) updateData;

- ( void ) update:(float)delay;

@end
