//
//  PlayerInfoView.m
//  sc
//
//  Created by fox on 13-9-15.
//
//

#import "PlayerInfoView.h"
#import "ProfessionConfig.h"
#import "SkillConfig.h"

@implementation PlayerInfoView
@synthesize CreatureID;

- ( void ) setData:( NSObject* )dd
{
    CreatureCommonData* d = ( CreatureCommonData* )dd;
    
    CreatureID = d.ID;
    
    if ( !imageWidth )
    {
        UIImageView* imageView = (UIImageView*)[ self viewWithTag:27 ];
        imageWidth = imageView.frame.size.width;
    }
    
    UILabel* label = (UILabel*)[ self viewWithTag:10 ];
    [ label setText:d.Name ];
    
    ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:d.ProfessionID ];
    ProfessionLevelData* proL = [ d getProLevelData ];
    
    int proTime = [ pro getLevelTime:proL.Level ];
    
    
    label = (UILabel*)[ self viewWithTag:11 ];
    [ label setText:pro.Name ];
    //label = (UILabel*)[ self viewWithTag:12 ];
    //[ label setText:pro.Des ];
    label = (UILabel*)[ self viewWithTag:13 ];
    
    NSString* str = [ NSString stringWithFormat:@"characterType%d" , d.CharacterType ];
    NSString* str1 = NSLocalizedString( str , nil );
    [ label setText:NSLocalizedString( str1 , nil ) ];
    
    
    
    label = (UILabel*)[ self viewWithTag:20 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , d.Level ] ];
    label = (UILabel*)[ self viewWithTag:21 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , d.EXP ] ];
    label = (UILabel*)[ self viewWithTag:22 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)d.RealBaseData.HP , (int)d.RealBaseData.MaxHP ] ];
    label = (UILabel*)[ self viewWithTag:23 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)d.RealBaseData.SP , (int)d.RealBaseData.MaxSP ] ];
    label = (UILabel*)[ self viewWithTag:24 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)d.RealBaseData.FS , (int)d.RealBaseData.MaxFS ] ];
    label = (UILabel*)[ self viewWithTag:25 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)proL.Level ] ];
    
    label = (UILabel*)[ self viewWithTag:26 ];
    
    
    UIImageView* imageView = (UIImageView*)[ self viewWithTag:27 ];
    CGRect rect = imageView.frame;
    rect.size.width = imageWidth * ( (float)d.EXP / 100.0f );
    imageView.frame = rect;
    
    
    imageView = (UIImageView*)[ self viewWithTag:28 ];
    rect = imageView.frame;
    
    if ( proTime )
    {
        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"PlayerProTime" , nil ) , proTime - proL.Time ];
        
        [ label setText:str ];
        
        rect.size.width = imageWidth * ( (float)proL.Time / (float)proTime );
        imageView.frame = rect;
    }
    else
    {
        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"PlayerProMax" , nil ) ];
        
        [ label setText:str ];
        
        rect.size.width = imageWidth;
        imageView.frame = rect;
    }
    
    
    
    label = (UILabel*)[ self viewWithTag:40 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.PAtk ] ];
    label = (UILabel*)[ self viewWithTag:41 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.PDef ] ];
    label = (UILabel*)[ self viewWithTag:42 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.MAtk ] ];
    label = (UILabel*)[ self viewWithTag:43 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.MDef ] ];
    label = (UILabel*)[ self viewWithTag:44 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.Agile ] ];
    label = (UILabel*)[ self viewWithTag:45 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.Lucky ] ];
    label = (UILabel*)[ self viewWithTag:46 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)(d.RealBaseData.Hit * 100.0f) ] ];
    label = (UILabel*)[ self viewWithTag:47 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)(d.RealBaseData.Miss * 100.0f) ] ];
    label = (UILabel*)[ self viewWithTag:48 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)( d.RealBaseData.Critical * 100.0f ) ] ];
    label = (UILabel*)[ self viewWithTag:49 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.Move ] ];
    
    label = (UILabel*)[ self viewWithTag:50 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)d.RealBaseData.CP , (int)d.RealBaseData.MaxCP ] ];
    label = (UILabel*)[ self viewWithTag:51 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.Guest ] ];
    label = (UILabel*)[ self viewWithTag:52 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.Command ] ];
    label = (UILabel*)[ self viewWithTag:53 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)d.RealBaseData.Kill ] ];
    
    
    NSString* str2 = [ NSString stringWithFormat:@"type%d" , d.Type ];
    NSString* str22 = NSLocalizedString( str2 , nil );
    label = (UILabel*)[ self viewWithTag:54 ];
    [ label setText:str22 ];
    
    for ( int i = 0 ; i < GCA_COUNT - 1 ; ++i )
    {
        label = (UILabel*)[ self viewWithTag:60 + i ];
        
        NSString* str = [ NSString stringWithFormat:@"%0.1f%%" , d.RealAttrDefence[ i ] * 100.0f ];
        //NSString* str1 = NSLocalizedString( str , nil );
        [ label setText:str ];
    }
    
    
    for ( int i = 0 ; i < MAX_SKILL ; i++ )
    {
        label = (UILabel*)[ self viewWithTag:70 + i ];
        
        if ( d.EquipSkill[ i ] != INVALID_ID )
        {
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:d.EquipSkill[ i ] ];
            [ label setText:skill.Name ];
        }
        else
        {
            [ label setText:@"" ];
        }
        
    }
    
}


@end
