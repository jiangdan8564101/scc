//
//  AlarmUIHandler.m
//  sc
//
//  Created by fox on 13-12-15.
//
//

#import "AlarmUIHandler.h"

@implementation AlarmUIHandler

static AlarmUIHandler* gAlarmUIHandler;
+ (AlarmUIHandler*) instance
{
    if ( !gAlarmUIHandler )
    {
        gAlarmUIHandler = [ [ AlarmUIHandler alloc] init ];
        [ gAlarmUIHandler initUIHandler:@"AlarmUIView" isAlways:YES isSingle:NO ];
    }
    
    return gAlarmUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];

    view.tag = 12300001;
    
    UIButton* button = (UIButton*)[ view viewWithTag:100 ];
    [ button addTarget:self action:@selector(onYes) forControlEvents:UIControlEventTouchUpInside ];
    button = (UIButton*)[ view viewWithTag:200 ];
    [ button addTarget:self action:@selector(onNo) forControlEvents:UIControlEventTouchUpInside ];
}



- ( void ) alarm:( NSString* )str :(NSObject*)obj0 :( SEL )s0 :( NSObject* )obj1 :( SEL )s1
{
    [ self visible:YES ];
    
    UILabel* label = (UILabel*)[ view viewWithTag:1000 ];
    [ label setText:str ];
    
    okObject = obj0;
    okSel = s0;
    
    noObject = obj1;
    noSel = s1;
}


- ( void ) onYes
{
    [ self visible:NO ];
    [ okObject performSelector:okSel withObject:nil ];
}


- ( void ) onNo
{
    [ self visible:NO ];
    [ noObject performSelector:noSel withObject:nil ];
}


@end
