//
//  AlarmUIHandler.h
//  sc
//
//  Created by fox on 13-12-15.
//
//

#import "UIHandlerZoom.h"

@interface AlarmUIHandler : UIHandlerZoom
{
    NSObject* okObject;
    SEL okSel;
    
    NSObject* noObject;
    SEL noSel;
}


+ ( AlarmUIHandler* ) instance;

- ( void ) alarm:( NSString* )str :(NSObject*)obj0 :( SEL )s0 :( NSObject* )obj1 :( SEL )s1;

@end
