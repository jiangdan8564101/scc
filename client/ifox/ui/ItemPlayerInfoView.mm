//
//  ItemPlayerInfoView.m
//  sc
//
//  Created by fox on 13-12-2.
//
//

#import "ItemPlayerInfoView.h"
#import "ProfessionConfig.h"

@implementation ItemPlayerInfoView


- ( void ) initView
{
    
}


- ( void ) setData:( CreatureCommonData* )c
{
    UILabel* label = (UILabel*)[ self viewWithTag:3600 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.PAtk ] ];
    label = (UILabel*)[ self viewWithTag:3601 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.PDef ] ];
    label = (UILabel*)[ self viewWithTag:3602 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.MAtk ] ];
    label = (UILabel*)[ self viewWithTag:3603 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.MDef ] ];
    label = (UILabel*)[ self viewWithTag:3604 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.Agile ] ];
    label = (UILabel*)[ self viewWithTag:3605 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.Lucky ] ];
    label = (UILabel*)[ self viewWithTag:3606 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)(c.RealBaseData.Hit * 100.0f)] ];
    label = (UILabel*)[ self viewWithTag:3607 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)(c.RealBaseData.Miss * 100.0f) ] ];
    label = (UILabel*)[ self viewWithTag:3608 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.Move ] ];
    
    
    label = (UILabel*)[ self viewWithTag:3500 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.HP , (int)c.RealBaseData.MaxHP ] ];
    label = (UILabel*)[ self viewWithTag:3501 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.SP , (int)c.RealBaseData.MaxSP ] ];
    label = (UILabel*)[ self viewWithTag:3502 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.FS , (int)c.RealBaseData.MaxFS ] ];
    
    
    label = (UILabel*)[ self viewWithTag:3700 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.Command ] ];
    label = (UILabel*)[ self viewWithTag:3701 ];
    [ label setText:[ NSString stringWithFormat:@"%d" , (int)c.RealBaseData.Guest ] ];
    
    for ( int i = 0 ; i < GCA_COUNT - 1 ; ++i )
    {
        label = (UILabel*)[ self viewWithTag:3702 + i ];
        
        NSString* str = [ NSString stringWithFormat:@"%0.1f%%" , c.RealAttrDefence[ i ] * 100.0f ];
        //NSString* str1 = NSLocalizedString( str , nil );
        [ label setText:str ];
    }
    
    
    label = (UILabel*)[ self viewWithTag:3203 ];
    [ label setText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.CP , (int)c.RealBaseData.MaxCP ] ];
    
    label = (UILabel*)[ self viewWithTag:3503 ];
    
    
    ProfessionConfigData* data = [ [ ProfessionConfig instance ] getProfessionConfig:c.ProfessionID ];
    
    NSString* str = [ NSString stringWithFormat:@"WeaponType%d" , data.WeaponType ];
    NSString* str1 = NSLocalizedString( str , nil );
    [ label setText:NSLocalizedString( str1 , nil ) ];
    
}

//
//- ( void ) setOtherData:( CreatureCommonData* )c :( int )tab :( int )itm
//{
//    for ( int i = 0 ; i < MAX_EQUIP ; ++i )
//    {
//        [ equip[ i ] setHidden:YES ];
//        [ equipCancel[ i ] setHidden:YES ];
//        [ equipLabel[ i ] setText:@"" ];
//    }
//    
//    if ( c.Equip0 != INVALID_ID && c.Equip0 )
//    {
//        ItemConfigData* item0 = [ [ ItemConfig instance ] getData:c.Equip0 ];
//        [ equipLabel[ 0 ] setText:item0.Name ];
//        [ equipCancel[ 0 ] setHidden:NO ];
//    }
//    
//    if ( c.Equip1 != INVALID_ID && c.Equip1 )
//    {
//        ItemConfigData* item1 = [ [ ItemConfig instance ] getData:c.Equip1 ];
//        [ equipLabel[ 1 ] setText:item1.Name ];
//        [ equipCancel[ 1 ] setHidden:NO ];
//    }
//    if ( c.Equip2 != INVALID_ID && c.Equip2 )
//    {
//        ItemConfigData* item2 = [ [ ItemConfig instance ] getData:c.Equip2 ];
//        [ equipLabel[ 2 ] setText:item2.Name ];
//        [ equipCancel[ 2 ] setHidden:NO ];
//    }
//    
//    
//    for ( int i = 0 ; i < MAX_SKILL ; ++i )
//    {
//        int skillID = c.EquipSkill[ i ];
//        
//        if ( skillID != INVALID_ID && skillID > 0 )
//        {
//            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
//            
//            [ skillLabel[ i ] setText:skill.Name ];
//            [ skillEquip[ i ] setHidden:YES ];
//            [ skillCancelEquip[ i ] setHidden:NO ];
//        }
//        else
//        {
//            [ skillLabel[ i ] setText:@"" ];
//            [ skillEquip[ i ] setHidden:YES ];
//            [ skillCancelEquip[ i ] setHidden:YES ];
//        }
//    }
//    
//    
//    if ( tab != ICDT_SKILL )
//    {
//        ItemConfigData* item = [ [ ItemConfig instance ] getData:itm ];
//        
//        if ( item.Type == ICDT_ARMOR )
//        {
//            if ( c.Equip1 != item.ID )
//            {
//                [ equip[ 1 ] setHidden:NO ];
//                [ equipCancel[ 1 ] setHidden:YES ];
//            }
//            if ( c.Equip2 != item.ID )
//            {
//                [ equip[ 2 ] setHidden:NO ];
//                [ equipCancel[ 2 ] setHidden:YES ];
//            }
//        }
//        else if ( item.Type == ICDT_WEAPON )
//        {
//            ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:c.ProfessionType ];
//            
//            if ( item.WeaponType == pro.WeaponType )
//            {
//                if ( c.Equip0 != item.ID )
//                {
//                    [ equip[ 0 ] setHidden:NO ];
//                    [ equipCancel[ 0 ] setHidden:YES ];
//                }
//            }
//        }
//        else
//        {
//            
//        }
//    }
//    else
//    {
//        for ( int i = 0 ; i < MAX_SKILL ; ++i )
//        {
//            if ( c.EquipSkill[ i ] == itm )
//            {
//                return;
//            }
//        }
//        
//        for ( int i = 0 ; i < MAX_SKILL ; ++i )
//        {
//            if ( c.EquipSkill[ i ] != itm )
//            {
//                [ skillEquip[ i ] setHidden:NO ];
//                [ skillCancelEquip[ i ] setHidden:YES ];
//            }
//        }
//    }
//    
//}


- ( void ) onEquipClick:( UIButton* )button
{
    
}


- ( void ) onEquipCancelClick:( UIButton* )button
{
    
}



@end




