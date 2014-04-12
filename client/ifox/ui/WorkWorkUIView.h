//
//  WorkWorkUIView.h
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import "UIViewBase.h"

@interface WorkWorkUIView : UIViewBase
{
    UIButton* editButton;
    UIButton* cancelButton;
    
    UIButton* resOKButton;
    UIButton* resCancelButton;
    
    UIButton* workButton0;
    UIButton* workButton1;
    UIButton* workButton2;
    UIButton* workButton3;
    
}

@property ( nonatomic ) BOOL EditMode;


- ( void ) setEdit:( BOOL )b;

- ( void ) setLevel:( int )l;

@end
