//
//  ItemListUIHandler.m
//  sc
//
//  Created by fox on 13-6-2.
//
//

#import "ItemListUIHandler.h"
#import "ItemConfig.h"
#import "PlayerCreatureData.h"
#import "ItemData.h"
#import "SkillConfig.h"
#import "ProfessionConfig.h"
#import "PlayerInfoUIHandler.h"
#import "GameSceneManager.h"


@implementation ItemListUIHandler



static ItemListUIHandler* gItemListUIHandler;
+ ( ItemListUIHandler* ) instance
{
    if ( !gItemListUIHandler )
    {
        gItemListUIHandler = [ [ ItemListUIHandler alloc] init ];
        [ gItemListUIHandler initUIHandler:@"ItemListView" isAlways:YES isSingle:NO ];
    }
    
    return gItemListUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    creatureScrollView = (CreatureScrollView*)[ view viewWithTag:1000 ];
    creatureScrollView.delegate = self;
    creaturePageLabel = ( UILabel* )[ view viewWithTag:1001 ];
    [ creatureScrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onCreatureClick: ) ];
    creatureScrollView.UseSelect = YES;
    
    
    itemScrollView = (ItemListScrollView*)[ view viewWithTag:2000 ];
    itemScrollView.delegate = self;
    itemPageLabel = (UILabel*)[ view viewWithTag:2001 ];
    
    [ itemScrollView initItemScrollView:[ uiArray objectAtIndex:2 ] :self :@selector( onItemClick: ) ];
    
    for ( int i = 0 ; i < ICDT_COUNT ; ++i )
    {
        UIButton* button = ( UIButton* )[ view viewWithTag:2100 + i ];
        [ button addTarget:self action:@selector(onItemTabClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
    UIButton* button = (UIButton*)[ view viewWithTag:1010 ];
    [ button addTarget:self action:@selector(onInfo) forControlEvents:UIControlEventTouchUpInside ];
    
    button = (UIButton*)[ view viewWithTag:1200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
    
    imageView = ( UIImageView* )[ view viewWithTag:1201 ];
    centerPoint = imageView.center;
    
    deslabel = ( UITextView* )[ view viewWithTag:2011 ];
    deslabelPro = ( UILabel* )[ view viewWithTag:2012 ];
    namelabel = ( UILabel* )[ view viewWithTag:2010 ];
    
    skillView[ 0 ] = ( ItemSkillView* )[ view viewWithTag:2021 ];
    skillView[ 1 ] = ( ItemSkillView* )[ view viewWithTag:2022 ];
    
    infoView = (ItemPlayerInfoView*)[ view viewWithTag:3000 ];
    [ infoView initView ];
    
    for ( int i = 0 ; i < MAX_EQUIP ; ++i )
    {
        equip[ i ] = ( UIButton* )[ view viewWithTag:3100 + i ];
        equipCancel[ i ] = ( UIButton* )[ view viewWithTag:3105 + i ];
        equipLabel[ i ] = (UILabel*)[ view viewWithTag:3200 + i ];
        
        [ equip[ i ] addTarget:self action:@selector(onEquipClick:) forControlEvents:UIControlEventTouchUpInside ];
        [ equipCancel[ i ] addTarget:self action:@selector(onEquipCancelClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
    
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        skillLabel[ i ] = ( UILabel* )[ view viewWithTag:3400 + i ];
        skillEquip[ i ] = ( UIButton* )[ view viewWithTag:3300 + i ];
        skillCancelEquip[ i ] = ( UIButton* )[ view viewWithTag:3310 + i ];
        
        [ skillEquip[ i ] addTarget:self action:@selector(onEquipSkillClick:) forControlEvents:UIControlEventTouchUpInside ];
        
        [ skillCancelEquip[ i ] addTarget:self action:@selector(onCancelEquipSkillClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    for ( int i = 0 ; i < ICDT_COUNT ; ++i )
    {
        itemPage[ i ] = 0;
    }
    
    selectTab = 0;
    
    [ self updateCreatureList ];
    [ self updateItemList ];
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    if ( sv == creatureScrollView )
    {
        [ creaturePageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ creatureScrollView getPageCount ] ] ];
    }
    else
    {
        itemPage[ selectTab ] = index;
        
        [ itemPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , itemPage[ selectTab ] + 1 , [ itemScrollView getPageCount ] ] ];
    }

}


- ( void ) onEquipClick:( UIButton* )button
{
    PackItemData* data = [ [ ItemData instance ] getItem:selectItem.ItemID ];
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    int index = button.tag - 3100;
    int equipi = INVALID_ID;
    switch ( index )
    {
        case 0:
            equipi = comm.Equip0;
            break;
        case 1:
            equipi = comm.Equip1;
            break;
        case 2:
            equipi = comm.Equip2;
            break;
    }
    
    
    
    if ( !data.Number )
    {
        playSound( PST_ERROR );
        return;
    }
    
    if ( equipi != INVALID_ID && equipi )
    {
        [ [ ItemData instance ] addItem:equipi :1 ];
        [ self updateItemStateNum:equipi ];
        
        switch ( index )
        {
            case 0:
                comm.Equip0 = INVALID_ID;
                break;
            case 1:
                comm.Equip1 = INVALID_ID;
                break;
            case 2:
                comm.Equip2 = INVALID_ID;
                break;
        }
    }
    
    [ [ ItemData instance ] removeItem:selectItem.ItemID :1 ];
    
    ItemConfigData* item = [ [ ItemConfig instance ] getData:data.ItemID ];
    
    switch ( index )
    {
        case 0:
            comm.Equip0 = data.ItemID;
            break;
        case 1:
            comm.Equip1 = data.ItemID;
            break;
        case 2:
            comm.Equip2 = data.ItemID;
            break;
    }
    [ comm updateProfessionSkillAndEquip ];
    [ infoView setData:comm ];
    
    [ equipLabel[ index ] setText:item.Name ];
    [ selectItem setNumber:data.Number ];
    
    [ equip[ index ] setHidden:NO ];
    [ equipCancel[ index ] setHidden:NO ];
    
    [ selectItem setEquip:ILIT_EQUIP ];
    [ self updateSelectItem ];
    
    playSound( PST_OK );
}

- ( void ) onEquipCancelClick:( UIButton* )button
{
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    int index = button.tag - 3105;
    int equipi = INVALID_ID;
    switch ( index )
    {
        case 0:
            equipi = comm.Equip0;
            break;
        case 1:
            equipi = comm.Equip1;
            break;
        case 2:
            equipi = comm.Equip2;
            break;
    }
    
    
    if ( equipi != INVALID_ID && equipi )
    {
        [ [ ItemData instance ] addItem:equipi :1 ];
        [ self updateItemStateNum:equipi ];
        
        switch ( index )
        {
            case 0:
                comm.Equip0 = INVALID_ID;
                break;
            case 1:
                comm.Equip1 = INVALID_ID;
                break;
            case 2:
                comm.Equip2 = INVALID_ID;
                break;
        }
    }
    
    [ comm updateProfessionSkillAndEquip ];
    [ infoView setData:comm ];
    
    [ equipLabel[ index ] setText:@"" ];
    [ equipCancel[ index ] setHidden:YES ];
    
    [ self updateSelectItem ];
}

- ( void ) onEquipSkillClick:( UIButton* )button
{
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    int index = button.tag - 3300;
    
    if ( ![ comm canEquipProfessionSkill:selectItem.SkillID ] )
    {
        return;
    }

    [ comm equipProfessionSkill:index :selectItem.SkillID ];
    [ comm updateProfessionSkillAndEquip ];
    
    [ selectItem setEquip:ILIT_EQUIP ];
    
    SkillConfigData* data = [ [ SkillConfig instance ] getSkill:selectItem.SkillID ];
    
    [ skillLabel[ index ] setText:data.Name ];
    [ skillEquip[ index ] setHidden:YES ];
    [ skillCancelEquip[ index ] setHidden:NO ];
    
    
    [ self updateSelectItem ];
    [ infoView setData:comm ];
}

- ( void ) onCancelEquipSkillClick:( UIButton* )button
{
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    int index = button.tag - 3310;
    
    [ self updateSkillItemState:comm.EquipSkill[ index ] ];
    [ comm cancelEquipProfessionSkill:index ];
    [ comm updateProfessionSkillAndEquip ];
    
    [ skillLabel[ index ] setText:@"" ];
    [ skillEquip[ index ] setHidden:YES ];
    [ skillCancelEquip[ index ] setHidden:YES ];
    
    [ self updateSelectItem ];
    [ infoView setData:comm ];
}


- ( void ) onCloseClick
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


- ( void ) onInfo
{
    [ [ PlayerInfoUIHandler instance ] visible:YES ];
    [ [ PlayerInfoUIHandler instance ] setMode:PlayerInfoUIItem ];
    [ [ PlayerInfoUIHandler instance ] setPos:selectCreature.Index ];
    [ [ PlayerInfoUIHandler instance ] setFireMode ];
    
    playSound( PST_OK );
    
    [ self visible:NO ];
}

- ( void ) onClosed
{
    [ super onClosed ];
    
    selectCreature = NULL;
}


- ( void ) onItemTabClick:( UIButton* )button
{
    if ( selectTab == button.tag - 2100 )
    {
        return;
    }
    
    selectTab = button.tag - 2100;
    
    [ self updateItemList ];
    
    playSound( PST_OK );
}


- ( void ) updateItemStateNum:( int )item
{
    NSMutableDictionary* dic = [ [ ItemData instance ] getType:selectTab ];
    NSArray* allkeys = getSortKeys( dic );
    int i = 0;
    ItemListItem* item1 = [ itemScrollView getItem:i ];
    
    while ( item1 )
    {
        PackItemData* data = [ dic objectForKey:[ allkeys objectAtIndex:item1.Index ] ];
        
        if ( data.ItemID == item )
        {
            [ item1 setNumber:data.Number ];
            
            if ( data.Number )
            {
                [ item1 setEquip:ILIT_CANEQUIP ];
            }
            else
            {
                [ item1 setEquip:ILIT_NOTEQUIP ];
            }
            
            return;
        }
        
        i++;
        item1 = [ itemScrollView getItem:i ];
    }
}


- ( void ) updateSkillItemState:( int )skill
{
    int i = 0;
    ItemListItem* item1 = [ itemScrollView getItem:i ];
    
    while ( item1 )
    {
        if ( item1.SkillID == skill )
        {
            [ item1 setEquip:ILIT_CANEQUIP ];
            return;
        }
        
        i++;
        item1 = [ itemScrollView getItem:i ];
    }
}


- ( void ) updateSelectItem
{
    for ( int i = 0 ; i < MAX_ITEM_SKILL ; ++i )
    {
        [ skillView[ i ] setHidden:YES ];
    }
    
    [ namelabel setText:@"" ];
    [ deslabel setText:@"" ];
    [ deslabelPro setText:@"" ];
    
    [ equip[ 0 ] setHidden:YES ];
    [ equip[ 1 ] setHidden:YES ];
    [ equip[ 2 ] setHidden:YES ];
    
    [ equipCancel[ 0 ] setHidden:YES ];
    [ equipCancel[ 1 ] setHidden:YES ];
    [ equipCancel[ 2 ] setHidden:YES ];
    
    [ equipLabel[ 0 ] setText:@"" ];
    [ equipLabel[ 1 ] setText:@"" ];
    [ equipLabel[ 2 ] setText:@"" ];
    
    
    if ( !selectCreature )
    {
        return;
    }
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    if ( comm.Equip0 != INVALID_ID && comm.Equip0 )
    {
        ItemConfigData* item1 = [ [ ItemConfig instance ] getData:comm.Equip0 ];
        [ equipLabel[ 0 ] setText:item1.Name ];
        [ equipCancel[ 0 ] setHidden:NO ];
    }
    
    if ( comm.Equip1 != INVALID_ID && comm.Equip1 )
    {
        ItemConfigData* item1 = [ [ ItemConfig instance ] getData:comm.Equip1 ];
        [ equipLabel[ 1 ] setText:item1.Name ];
        [ equipCancel[ 1 ] setHidden:NO ];
    }
    if ( comm.Equip2 != INVALID_ID && comm.Equip2 )
    {
        ItemConfigData* item1 = [ [ ItemConfig instance ] getData:comm.Equip2 ];
        [ equipLabel[ 2 ] setText:item1.Name ];
        [ equipCancel[ 2 ] setHidden:NO ];
    }
    
    
    for ( int i = 0 ; i < MAX_SKILL ; ++i )
    {
        int skillID = comm.EquipSkill[ i ];
        
        if ( skillID != INVALID_ID && skillID > 0 )
        {
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
            
            [ skillLabel[ i ] setText:skill.Name ];
            [ skillEquip[ i ] setHidden:YES ];
            [ skillCancelEquip[ i ] setHidden:NO ];
        }
        else
        {
            [ skillLabel[ i ] setText:@"" ];
            [ skillEquip[ i ] setHidden:YES ];
            [ skillCancelEquip[ i ] setHidden:YES ];
        }
    }
    
    
    if ( !selectItem )
    {
        return;
    }
    
    if ( selectTab != ICDT_SKILL )
    {
        ItemConfigData* item = [ [ ItemConfig instance ] getData:selectItem.ItemID ];
        
        if ( gActualResource.type >= RESPAD2 )
        {
            if ( item.Skill.count )
            {
                UIFont* font = deslabel.font;
                [ deslabel setFont:[ font fontWithSize:13 ] ];
            }
            else
            {
                UIFont* font = deslabel.font;
                [ deslabel setFont:[ font fontWithSize:17 ] ];
            }
        }
        else
        {
            if ( item.Skill.count )
            {
                UIFont* font = deslabel.font;
                [ deslabel setFont:[ font fontWithSize:9 ] ];
            }
            else
            {
                UIFont* font = deslabel.font;
                [ deslabel setFont:[ font fontWithSize:12 ] ];
            }
        }
        
        NSString* str2 = item.Des1;
        
        [ namelabel setText:[ NSString stringWithFormat:@"【 %@ 】", item.Name ] ];
        [ deslabel setText:str2 ];
        
        for ( int i = 0 ; i < item.Skill.count ; ++i )
        {
            SkillConfigData* config = [ [ SkillConfig instance ] getSkill:[ [ item.Skill objectAtIndex:i ] intValue ] ];
            
            [ skillView[ i ] setHidden:NO ];
            
            ProfessionSkillData* sd = [ comm getProfessionSkillData:config.SkillID ];
            
            [ skillView[ i ] setData:config.Name :config.ProfessionID :comm.ProfessionID :sd? sd.AP :0 :config.AP ];
        }
        
        if ( item.Type == ICDT_ARMOR )
        {
            if ( comm.Equip1 != item.ID )
            {
                [ equip[ 1 ] setHidden:NO ];
                [ equipCancel[ 1 ] setHidden:YES ];
            }
            if ( comm.Equip2 != item.ID )
            {
                [ equip[ 2 ] setHidden:NO ];
                [ equipCancel[ 2 ] setHidden:YES ];
            }
        }
        else if ( item.Type == ICDT_WEAPON )
        {
            ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:comm.ProfessionID ];
            
            if ( item.WeaponType == pro.WeaponType )
            {
                if ( comm.Equip0 != item.ID )
                {
                    [ equip[ 0 ] setHidden:NO ];
                    [ equipCancel[ 0 ] setHidden:YES ];
                }
                
                if ( item.ProLevel )
                {
                    NSString* str1 = [ NSString stringWithFormat:NSLocalizedString( @"SkillLVNeed", nil ) , item.ProLevel ];
                    
                    [ deslabelPro setText:str1 ];
                    [ deslabelPro setTextColor:[ comm getProfessionLevel ] >= item.ProLevel ? [ UIColor whiteColor ] : [ UIColor redColor ] ];
                }
            }
            else
            {
                NSMutableArray* arr = [ [ ProfessionConfig instance ] getWeaponProfessionConfig:item.WeaponType ];
                
                NSMutableString* string1 = [ NSMutableString string ];
                
                for ( int i = 0 ; i < arr.count ; ++i )
                {
                    ProfessionConfigData* pro = [ arr objectAtIndex:i ];
                    
                    if ( [ pro.Name length ] >= 4 )
                    {
                        NSMutableString* str = [ NSMutableString string ];
                        [ str appendString:[ pro.Name substringToIndex:2 ] ];
                        
                        [ string1 appendString:str ];
                    }
                    else
                    {
                        [ string1 appendString:pro.Name ];
                    }
                    
                    if ( i < arr.count - 1 )
                    {
                        [ string1 appendString:@"/" ];
                    }
                }
                
                [ deslabelPro setText:string1 ];
                
                //[ deslabelPro setText:NSLocalizedString( @"SkillCanNot" , nil ) ];
                [ deslabelPro setTextColor:[ UIColor redColor ] ];
            }
        }
        else
        {
            
        }
    }
    else
    {
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:selectItem.SkillID ];
        
        ProfessionSkillData* skillData = [ comm getProfessionSkillData:skill.SkillID ];
        NSString* str = NULL;
        
        UIFont* font = deslabel.font;
        
        if ( gActualResource.type >= RESPAD2 )
        {
            UIFont* font = deslabel.font;
            [ deslabel setFont:[ font fontWithSize:17 ] ];
        }
        else
        {
            [ deslabel setFont:[ font fontWithSize:9 ] ];
        }
        
//        if ( ![ skillData isLearned ] )
//        {
//            str = [ NSString stringWithFormat:@"【 %@ : %@ 】" , skill.Name , NSLocalizedString( @"SkillNotLearned", nil ) ];
//            //[ namelabel setTextColor:[ UIColor redColor ] ];
//        }
//        else
//        {
            str = [ NSString stringWithFormat:@"【 %@ 】" , skill.Name , NSLocalizedString( @"SkillNotLearned", nil ) ];
            [ namelabel setTextColor:[ UIColor greenColor ] ];
//        }
        
        NSString* des = [ NSString stringWithFormat:@"%@\n%@" , skill.Des1 , skill.Des2 ];
        [ namelabel setText:str ];
        [ deslabel setText:des ];
        
        for ( int i = 0 ; i < MAX_SKILL ; ++i )
        {
            if ( comm.EquipSkill[ i ] == selectItem.SkillID )
            {
                return;
            }
        }
        
        for ( int i = 0 ; i < MAX_SKILL ; ++i )
        {
            if ( comm.EquipSkill[ i ] == INVALID_ID )
            {
                if ( ![ skillData isLearned ] )
                {
                    [ skillEquip[ i ] setHidden:YES ];
                    [ skillCancelEquip[ i ] setHidden:YES ];
                }
                else
                {
                    [ skillEquip[ i ] setHidden:NO ];
                    [ skillCancelEquip[ i ] setHidden:YES ];
                }
            }
        }
    }
    
}


- ( void ) updateItemState
{
    if ( !selectCreature )
    {
        return;
    }
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    
    int i = 0;
    ItemListItem* item1 = [ itemScrollView getItem:i ];
    
    
    while ( item1 )
    {
        if ( selectTab != ICDT_SKILL )
        {
            ItemConfigData* item = [ [ ItemConfig instance ] getData:item1.ItemID ];
            
            if ( item.Type == ICDT_ARMOR )
            {
                if ( comm.Equip0 == item.ID )
                {
                    [ item1 setEquip:ILIT_EQUIP ];
                }
                else
                {
                    PackItemData* item11 = [[ ItemData instance ] getItem:item.ID ];
                    
                    if ( item11.Number )
                    {
                        [ item1 setEquip:ILIT_CANEQUIP ];
                    }
                    else
                    {
                        [ item1 setEquip:ILIT_NOTEQUIP ];
                    }
                    
                }
            }
            else if ( item.Type == ICDT_WEAPON )
            {
                ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:comm.ProfessionID ];
                
                PackItemData* item11 = [[ ItemData instance ] getItem:item.ID ];
                
                if ( comm.Equip0 == item.ID )
                {
                    [ item1 setEquip:ILIT_EQUIP ];
                }
                else
                {
                    if ( pro.WeaponType ==  item.WeaponType && item.ProLevel <= [ comm getProfessionLevel ] && item11.Number )
                    {
                        [ item1 setEquip:ILIT_CANEQUIP ];
                    }
                    else
                    {
                        [ item1 setEquip:ILIT_NOTEQUIP ];
                    }
                }
            }
            else
            {
                //[ item1 setEquip:ILIT_CLEAR ];
            }
        }
        else
        {
            ProfessionSkillData* data = [ comm getProfessionSkillData:item1.SkillID ];
            
            if ( [ comm isEquipSkill:item1.SkillID ] )
            {
                [ item1 setEquip:ILIT_EQUIP ];
            }
            else
            {
                if ( ![ data isLearned ] )
                {
                    [ item1 setEquip:ILIT_NOTEQUIP ];
                }
                else if ( [ comm canEquipProfessionSkill:data.SkillID ]  )
                {
                    [ item1 setEquip:ILIT_CANEQUIP ];
                }
                else
                {
                    [ item1 setEquip:ILIT_NOTEQUIP ];
                }
            }
        }
        
        
        i++;
        item1 = [ itemScrollView getItem:i ];
    }
    
}


- ( void ) updateItemList
{
    if ( !view )
    {
        return;
    }
    
    [ itemScrollView clear ];
    
    selectItem = NULL;
    
    if ( selectTab != ICDT_SKILL )
    {
        NSMutableDictionary* dic = [ [ ItemData instance ] getType:selectTab ];
        
        NSArray* allkeys = getSortKeys( dic );
        
        for ( fint32 i = 0 ; i < allkeys.count ; ++i )
        {
            PackItemData* data = [ dic objectForKey:[ allkeys objectAtIndex:i ] ];
            
            if ( data.Number )
            {
                [ itemScrollView addItem:data ];
            }
        }
    }
    else
    {
        CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
        
        NSArray* allkeys = getSortKeys( comm.Skill );
        int size = 0;
        
        for ( int i = 0 ; i < allkeys.count ; ++i )
        {
            ProfessionSkillData* data = [ comm.Skill objectForKey: [ allkeys objectAtIndex:i ] ];
            
            if ( data.Active && [ data isLearned ] )
            {
                size++;
                [ itemScrollView addSkillItem:data ];
            }
        }
    }
    
    [ itemScrollView updaContentSize ];
    
    int count = itemScrollView.DataCount / 18;
    count += ( itemScrollView.DataCount % 18 ) ? 1 : 0;
    [ itemScrollView setPos:itemPage[ selectTab ] ];
    
    [ itemPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , itemPage[ selectTab ] + 1 , count ] ];
    [ itemPageLabel setHidden:!count ];
    [ itemScrollView setNeedsLayout ];
    
    [ self updateSelectItem ];
    [ self updateItemState ];
}


- ( void ) updateCreatureList
{
    if ( !view )
    {
        return;
    }
    
    [ creatureScrollView clear ];
    
    NSMutableDictionary* dic = [ PlayerCreatureData instance ].PlayerDic;
    
    NSArray* ks = getSortKeys( dic );
    
    for ( fint32 i = 0 ; i < ks.count ; ++i )
    {
        CreatureCommonData* data = [ dic objectForKey:[ ks objectAtIndex:i ] ];
        
        [ creatureScrollView addItem:data ];
    }
    
    int count = [ creatureScrollView getPageCount ];
    [ creatureScrollView updateContentSize ];
    [ creatureScrollView setNeedsLayout ];
    
    [ creaturePageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ creaturePageLabel setHidden:!count ];
    
    [ self updateSelectCreature ];
}


- ( void ) onItemClick:( ItemListItem* )item
{
    if ( !item )
    {
        [ self updateItemState ];
        [ self updateSelectItem ];
        return;
    }
    
    if ( selectItem == item )
    {
        return;
    }
    
    selectItem = item;
    
    [ self updateSelectItem ];
}


- ( void ) updateImageData:( CreatureCommonData* )com
{
    NSString* str = [ NSString stringWithFormat:@"CS%@AA" , com.Action ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:CREATURE_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    CGSize sz = image.size;
    [ imageView setImage:image ];
    CGRect rect = imageView.frame;
    
    if ( gActualResource.type >= RESPAD2 )
    {
        
    }
    else
    {
        sz.width *= 0.5f;
        sz.height *= 0.5f;
    }
    
    rect.size = sz;
    
    
    CGPoint point = centerPoint;
    if ( com.ImageOffsetX )
    {
        point.x += -sz.width * 0.5f + com.ImageOffsetX;
    }
    else
    {
        point.x += -sz.width * 0.5f;
    }
    
    if ( com.ImageOffsetY )
    {
        point.y += -sz.height + com.ImageOffsetY;
    }
    else
    {
        point.y += -sz.height;
    }
    
    rect.origin = point;
    
    [ imageView setFrame:rect ];
}


- ( void ) updateSelectCreature
{
    if ( !selectCreature )
    {
        return;
    }
    
    CreatureCommonData* comm = [ [ PlayerCreatureData instance ] getCommonData:selectCreature.CreatureID ];
    
    [ self updateImageData:comm ];
    [ infoView setData:comm ];
}


- ( void ) onCreatureClick:( CreatureListItem* )item
{
    if ( !item )
    {
        [ self updateSelectItem ];
        return;
    }
    
    if ( selectCreature == item )
    {
        return;
    }
    
    selectCreature = item;
    
    if ( selectTab == ICDT_SKILL )
    {
        [ self updateItemList ];
    }
    
    [ self updateSelectCreature ];
    [ self updateItemState ];
    [ self updateSelectItem ];
}




@end


