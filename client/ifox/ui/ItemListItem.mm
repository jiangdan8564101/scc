//
//  ItemListItem.m
//  sc
//
//  Created by fox on 13-6-2.
//
//

#import "ItemListItem.h"
#import "ItemConfig.h"
#import "SkillConfig.h"


@implementation ItemListItem
@synthesize Index , SkillID , ItemID;

- ( void ) setData:( PackItemData* )data
{
    ItemConfigData* ic = [ [ ItemConfig instance ] getData:data.ItemID ];
    
    NSString* str = [ NSString stringWithFormat:@"%@" , ic.Img ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    UIButton* button = (UIButton*)[ self viewWithTag:200 ];
    [ button setImage:image forState:UIControlStateNormal ];
    
    UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:100 ];
    [ label setLabelText:[ NSString stringWithFormat:@"%d" , data.Number ] ];
    
    label = (UILabelStroke*)[ self viewWithTag:101 ];
    [ label setText:@"" ];
    
    if ( ic.Quality )
    {
        //NSString* str = [ NSString stringWithFormat:@"Quality%d" , ic.Quality ];
        //NSString* str1 = NSLocalizedString( str , nil );
        
        switch ( ic.Color )
        {
            case 2:
                [ label setTextColor:[ UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f ] ];
                break;
            case 3:
                [ label setTextColor:[ UIColor colorWithRed:0.6f green:1.0f blue:1.0f alpha:1.0f ] ];
                break;
            case 4:
                [ label setTextColor:[ UIColor colorWithRed:0.8f green:0.0f blue:1.0f alpha:1.0f ] ];
                break;
            default:
                [ label setTextColor:[ UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f ] ];
                break;
        }
        //[ label setLabelText:str1 ];
    }
    
    UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:301 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:302 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:303 ];
    [ iv setHidden:YES ];
    
    ItemID = data.ItemID;
    SkillID = INVALID_ID;
}


- ( void ) setSkillData:( ProfessionSkillData* )d
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:d.SkillID ];
    
    NSString* str = [ NSString stringWithFormat:@"%@" , skill.Icon ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    UIButton* button = (UIButton*)[ self viewWithTag:200 ];
    [ button setImage:image forState:UIControlStateNormal ];
    
    UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:100 ];
    [ label setLabelText:@"" ];
    
    UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:301 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:302 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:303 ];
    [ iv setHidden:YES ];
    
    SkillID = d.SkillID;
    ItemID = INVALID_ID;
}

- ( void ) setNumber:( int )n
{
    UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:100 ];
    [ label setLabelText:[ NSString stringWithFormat:@"%d" , n ] ];
}


- ( void ) setEquip:( int )e
{
    switch ( e )
    {
        case ILIT_CLEAR:
        {
            UIImageView* iv = ( UIImageView* )[ self viewWithTag:301 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:302 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:303 ];
            [ iv setHidden:YES ];
        }
            break;
        case ILIT_EQUIP:
        {
            UIImageView* iv = ( UIImageView* )[ self viewWithTag:301 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:302 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:303 ];
            [ iv setHidden:NO ];
        }
            break;
        case ILIT_CANEQUIP:
        {
            UIImageView* iv = ( UIImageView* )[ self viewWithTag:301 ];
            [ iv setHidden:NO ];
            
            iv = ( UIImageView* )[ self viewWithTag:302 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:303 ];
            [ iv setHidden:YES ];
        }
            break;
        case ILIT_NOTEQUIP:
        {
            UIImageView* iv = ( UIImageView* )[ self viewWithTag:301 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:302 ];
            [ iv setHidden:NO ];
            
            iv = ( UIImageView* )[ self viewWithTag:303 ];
            [ iv setHidden:YES ];
        }
            break;
        default:
            break;
    }
    
}


- ( void ) setSelect:( BOOL )b
{
    UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    [ iv setHidden:!b ];
}

@end
