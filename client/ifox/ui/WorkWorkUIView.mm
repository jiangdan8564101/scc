//
//  WorkWorkUIView.m
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import "WorkWorkUIView.h"
#import "WorkWorkFloor.h"
#import "UICreatureAction.h"
#import "WorkWorkUpUIHandler.h"
#import "WorkMapUIHandler.h"


@implementation WorkWorkUIView
@synthesize EditMode;


- ( void ) initUIViewBase:( NSObject* )obj
{
    [ super initUIViewBase:obj ];
    
//    WorkWorkFloor* floor = (WorkWorkFloor*)[ self viewWithTag:100 ];
//    [ floor setCreatureAction:@"CP002A" ];
//        
    editButton = (UIButton*)[ self viewWithTag:1200 ];
    cancelButton = (UIButton*)[ self viewWithTag:1201 ];
    
    [ editButton addTarget:self action:@selector(onEdit) forControlEvents:UIControlEventTouchUpInside ];
    [ cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside ];
    
    
    workButton0 = (UIButton*)[ self viewWithTag:200 ];
    workButton1 = (UIButton*)[ self viewWithTag:201 ];
    workButton2 = (UIButton*)[ self viewWithTag:202 ];
    workButton3 = (UIButton*)[ self viewWithTag:203 ];
    
    [ workButton0 addTarget:self action:@selector(onWorkButton:) forControlEvents:UIControlEventTouchUpInside ];
    [ workButton1 addTarget:self action:@selector(onWorkButton:) forControlEvents:UIControlEventTouchUpInside ];
    [ workButton2 addTarget:self action:@selector(onWorkButton:) forControlEvents:UIControlEventTouchUpInside ];
    [ workButton3 addTarget:self action:@selector(onWorkButton:) forControlEvents:UIControlEventTouchUpInside ];
    
    [ self setEdit:NO ];
}


- ( void ) onWorkButton:( UIButton* )button
{
    [ [ WorkWorkUpUIHandler instance ] visible:YES ];
    [ [ WorkWorkUpUIHandler instance ] setData:button.tag - 200 ];
    
    playSound( PST_OK );
}

- ( void ) onEdit
{
    [ self setEdit:YES ];
    
    playSound( PST_OK );
}


- ( void ) onCancel
{
    [ self setEdit:NO ];
    
    playSound( PST_CANCEL );
}

- ( void ) setEdit:( BOOL )b
{
    EditMode = b;
    
    [ editButton setHidden:b ];
    [ cancelButton setHidden:!b ];
    
    [ workButton0 setHidden:!b ];
    [ workButton1 setHidden:!b ];
    [ workButton2 setHidden:!b ];
    [ workButton3 setHidden:!b ];
    
    [ [ WorkMapUIHandler instance ] visible:!b ];
}


- ( void ) setLevel:( int )l
{
    
}

@end
