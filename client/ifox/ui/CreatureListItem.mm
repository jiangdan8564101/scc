//
//  CreatureListItem.m
//  sc
//
//  Created by fox on 13-6-2.
//
//

#import "CreatureListItem.h"
#import "UILabelStroke.h"
#import "ProfessionConfig.h"

@implementation CreatureListItem

@synthesize CreatureID;

- ( void ) setData:( NSObject* ) d
{
    CreatureCommonData* data = ( CreatureCommonData* )d;
    
    NSString* str = [ NSString stringWithFormat:@"CA%@A" , data.Action ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:HEAD_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    UIButton* button = (UIButton*)[ self viewWithTag:200 ];
    UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    [ iv setHidden:YES ];
    
    
    UILabelStroke* label = ( UILabelStroke* )[ self viewWithTag:201 ];
    [ label setLabelText:data.Name ];
    
    label = ( UILabelStroke* )[ self viewWithTag:202 ];
    [ label setLabelText:[ NSString stringWithFormat:@"LV %d" , data.Level ] ];
    
    label = ( UILabelStroke* )[ self viewWithTag:203 ];
    
    ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:data.ProfessionID ];
    
    [ label setLabelText:[ NSString stringWithFormat:@"%@LV %d" , pro.Name , [ data getProfessionLevel ] ] ];
    
    [ button setImage:image forState:UIControlStateNormal ];
    //[ button setImage:image forState:UIControlStateSelected ];
    
    //UIImageView* iv = (UIImageView*)[ self viewWithTag:100 ];
    //[ iv setImage:image ];
    
    CreatureID = data.cID;
}


- ( void ) setSelect:( BOOL )b
{
    UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    [ iv setHidden:!b ];
}


- ( void ) clear
{
    UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    [ iv setHidden:YES ];
    
    UIButton* button = ( UIButton* )[ self viewWithTag:200 ];
    [ button setImage:NULL forState:UIControlStateNormal ];
}


@end
