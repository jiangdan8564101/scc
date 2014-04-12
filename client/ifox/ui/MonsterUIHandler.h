//
//  MonsterUIHandler.h
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "UIHandlerZoom.h"

@interface MonsterUIHandler : UIHandlerZoom
{
    
}

+ ( MonsterUIHandler* ) instance;

- ( void ) setBG:( NSString* )name;

@end
