//
//  ProfessionListItem.m
//  sc
//
//  Created by fox on 13-11-17.
//
//

#import "ProfessionListItem.h"
#import "ProfessionConfig.h"
#import "UILabelStroke.h"
#import "ItemData.h"


@implementation ProfessionListItem
@synthesize ProID;

- ( void ) setData:( NSObject* )ddd
{
    ProfessionLevelData* dd = ( ProfessionLevelData* )ddd;
    
    ProfessionConfigData* d = [ [ ProfessionConfig instance ] getProfessionConfig:dd.ID ];
    ProID = d.ID;
    
    NSString* str = [ NSString stringWithFormat:@"%@" , d.Img ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    UIButton* button = (UIButton*)[ self viewWithTag:200 ];
    [ button setImage:image forState:UIControlStateNormal ];
    
    PackItemData* pack = [ [ ItemData instance ] getItem:(d.ID + PRO_ITEM) ];
    
    if ( [ d.Name length ] >= 4 )
    {
        NSMutableString* str = [ NSMutableString string ];
        [ str appendString:[ d.Name substringToIndex:2 ] ];
        
        UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:100 ];
        [ label setLabelText:[ NSString stringWithFormat:@"%@X%d" , str , pack.Number ] ];
    }
    else
    {
        UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:100 ];
        [ label setLabelText:[ NSString stringWithFormat:@"%@X%d" , d.Name , pack.Number ] ];
    }
    
    UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:101 ];
    [ label setLabelText:[ NSString stringWithFormat:@"LV%d" , dd.Level ] ];
    
    UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:301 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:302 ];
    [ iv setHidden:YES ];
    
    iv = ( UIImageView* )[ self viewWithTag:303 ];
    [ iv setHidden:YES ];
}

- ( void ) setNumber
{
    ProfessionConfigData* d = [ [ ProfessionConfig instance ] getProfessionConfig:ProID ];
    
    PackItemData* pack = [ [ ItemData instance ] getItem:(d.ID + PRO_ITEM) ];
    
    if ( [ d.Name length ] >= 4 )
    {
        NSMutableString* str = [ NSMutableString string ];
        [ str appendString:[ d.Name substringToIndex:2 ] ];
        
        UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:100 ];
        [ label setLabelText:[ NSString stringWithFormat:@"%@X%d" , str , pack.Number ] ];
    }
    else
    {
        UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:100 ];
        [ label setLabelText:[ NSString stringWithFormat:@"%@X%d" , d.Name , pack.Number ] ];
    }
}

- ( void ) setLevel:( int )l
{
    UILabelStroke* label = (UILabelStroke*)[ self viewWithTag:101 ];
    [ label setLabelText:[ NSString stringWithFormat:@"LV%d" , l ] ];
}


- ( void ) setEquip:( int )e
{
    switch ( e )
    {
        case PLIT_CLEAR:
        {
            UIImageView* iv = ( UIImageView* )[ self viewWithTag:301 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:302 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:303 ];
            [ iv setHidden:YES ];
        }
            break;
        case PLIT_EQUIP:
        {
            UIImageView* iv = ( UIImageView* )[ self viewWithTag:301 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:302 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:303 ];
            [ iv setHidden:NO ];
        }
            break;
        case PLIT_CANEQUIP:
        {
            UIImageView* iv = ( UIImageView* )[ self viewWithTag:301 ];
            [ iv setHidden:NO ];
            
            iv = ( UIImageView* )[ self viewWithTag:302 ];
            [ iv setHidden:YES ];
            
            iv = ( UIImageView* )[ self viewWithTag:303 ];
            [ iv setHidden:YES ];
        }
            break;
        case PLIT_NOTEQUIP:
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
