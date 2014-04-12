//
//  ItemSkillView.m
//  sc
//
//  Created by fox on 13-10-1.
//
//

#import "ItemSkillView.h"
#import "ProfessionConfig.h"

@implementation ItemSkillView



- ( void ) setData:( NSString* )str :( int )p1 :( int )p2 :( int )e :( int )me
{
    UIImageView* iv1 = ( UIImageView* )[ self viewWithTag:1 ];
    UIImageView* iv2 = ( UIImageView* )[ self viewWithTag:2 ];
    
    CGRect rect = iv1.frame;
    rect.size.width = (float)e / ( float )me * iv1.frame.size.width;
    [ iv2 setFrame:rect ];
    
    UILabel* name = ( UILabel* )[ self viewWithTag:3 ];
    [ name setText:str ];
    
    UILabel* exp = ( UILabel* )[ self viewWithTag:4 ];
    
    if ( p1 == p2 || p1 == 0 )
    {
        if ( e == me )
        {
            [ exp setText:NSLocalizedString( @"SkillLearned", nil ) ];
            [ exp setTextColor:[ UIColor greenColor ] ];
        }
        else
        {
            [ exp setText:[ NSString stringWithFormat:@"%d/%d" , e , me ] ];
            [ exp setTextColor:[ UIColor whiteColor ] ];
        }
    }
    else
    {
        ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:p1 ];
        
        [ exp setText:pro.Name ];
        [ exp setTextColor:[ UIColor redColor ] ];
    }
    
}

@end
