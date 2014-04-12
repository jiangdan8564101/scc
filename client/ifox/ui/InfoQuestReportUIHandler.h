//
//  InfoQuestReportUIHandler.h
//  sc
//
//  Created by fox on 13-12-6.
//
//

#import "UIHandlerZoom.h"

@interface InfoQuestReportUIHandler : UIHandlerZoom
{
    int dataCount;
    
    NSMutableArray* array;
}

+ ( InfoQuestReportUIHandler* ) instance;

- ( void ) setData:( NSArray* )array;

@end
