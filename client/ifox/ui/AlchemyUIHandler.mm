//
//  AlchemyUIHandler.m
//  sc
//
//  Created by fox on 13-10-7.
//
//

#import "AlchemyUIHandler.h"
#import "ItemData.h"
#import "PlayerData.h"
#import "ProfessionConfig.h"
#import "SkillConfig.h"
#import "AlertUIHandler.h"

@implementation AlchemyUIHandler

static AlchemyUIHandler* gAlchemyUIHandler;
+ ( AlchemyUIHandler* ) instance
{
    if ( !gAlchemyUIHandler )
    {
        gAlchemyUIHandler = [ [ AlchemyUIHandler alloc] init ];
        [ gAlchemyUIHandler initUIHandler:@"AlchemyUIView" isAlways:YES isSingle:NO ];
    }
    
    return gAlchemyUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    if ( !array )
    {
        array = [ [ NSMutableArray alloc ] init ];
    }
    
    alchemyItemNumDic = [ [ NSMutableDictionary alloc ] init ];
    alchemyNumDic = [ [ NSMutableDictionary alloc ] init ];
    
    scrollView = ( AlchemyScrollView* )[ view viewWithTag:2000 ];
    [ scrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onClick:) ];
    scrollView.delegate = self;
    
    
    
    pageLabel = ( UILabel* )[ view viewWithTag:2001 ];
    
    
    
    UIButton* button = (UIButton*)[ view viewWithTag:2108 ];
    [ button addTarget:self action:@selector( onCloseClick ) forControlEvents:UIControlEventTouchUpInside ];
    button = (UIButton*)[ view viewWithTag:2107 ];
    [ button addTarget:self action:@selector( onCreateClick ) forControlEvents:UIControlEventTouchUpInside ];
    
    for ( int i = 0 ; i < ICDT_SKILL ; ++i )
    {
        UIButton* button = ( UIButton* )[ view viewWithTag:2100 + i ];
        [ button addTarget:self action:@selector(onItemTabClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
    [ view setCenter:CGPointMake( SCENE_WIDTH * 0.5f , SCENE_HEIGHT * 0.5f ) ];
    
    
    for ( int i = 0 ; i < MAX_ALCHEMY_ITEM ; ++i )
    {
        alchemyItem[ i ] = (UIImageView*)[ view viewWithTag:i * 10 + 401 ];
        alchemyItemName[ i ] = (UILabel*)[ view viewWithTag:i * 10 + 402 ];
        alchemyItemNeed[ i ] = (UILabel*)[ view viewWithTag:i * 10 + 403 ];
        alchemyItemGet[ i ] = (UILabel*)[ view viewWithTag:i * 10 + 404 ];
    }
    
    des1label = ( UITextView* )[ view viewWithTag:2011 ];
    namelabel = ( UILabel* )[ view viewWithTag:2010 ];
    deslabelPro = (UILabel*)[ view viewWithTag:2012 ];
    
    skillView[ 0 ] = ( ItemSkillView* )[ view viewWithTag:2021 ];
    skillView[ 1 ] = ( ItemSkillView* )[ view viewWithTag:2022 ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    selectTab = 0;
    
    for ( int i = 0 ; i < ICDT_COUNT ; ++i )
    {
        itemPage[ i ] = 0;
    }
    
    [ self updateItemList ];
}


- ( void ) onClosed
{
    [ super onClosed ];
}



- ( void ) onItemTabClick:( UIButton* )button
{
    selectTab = button.tag - 2100;
    
    [ self updateItemList ];
    
    playSound( PST_OK );
}



-( NSArray* ) getSortAlchemyKeys:( NSMutableDictionary* )dic
{
    return [ dic.allKeys sortedArrayUsingComparator:^(id obj1, id obj2)
            {
                AlchemyConfigData* data1 = [ dic objectForKey:obj1 ];
                AlchemyConfigData* data2 = [ dic objectForKey:obj2 ];
                
                ItemConfigData* item1 = [ [ ItemConfig instance ] getData:data1.ItemID ];
                ItemConfigData* item2 = [ [ ItemConfig instance ] getData:data2.ItemID ];
                
                if ( item1.Color < item2.Color )
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ( item1.Color > item2.Color )
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                
                if ( item1.Color == item2.Color )
                {
                    if ( item1.WeaponType < item2.WeaponType )
                    {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    if ( item1.WeaponType > item2.WeaponType )
                    {
                        return (NSComparisonResult)NSOrderedAscending;
                    }

                    if ( item1.PutPosition < item2.PutPosition )
                    {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    if ( item1.PutPosition > item2.PutPosition )
                    {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    
                    if ( item1.Type2 < item2.Type2 )
                    {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    if ( item1.Type2 > item2.Type2 )
                    {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                }
                
                return (NSComparisonResult)NSOrderedSame;
            }];
}


- ( void ) updateItemList
{
    if ( !view )
    {
        return;
    }
    
    [ alchemyNumDic removeAllObjects ];
    [ scrollView clear ];
    
    selectItem = NULL;
    
    NSMutableDictionary* dic = [ AlchemyConfig instance ].Dic;
    
    NSArray* values = [ self getSortAlchemyKeys:dic ];
    
    for ( fint32 i = 0 ; i < values.count ; ++i )
    {
        AlchemyConfigData* data = [ dic objectForKey:[ values objectAtIndex:i ] ];
        
        ItemConfigData* idata = [ [ ItemConfig instance ] getData:data.ItemID ];
        
        if ( data.Rank > [ PlayerData instance ].WorkRank + 1 )
        {
            continue;
        }
        
        if ( selectTab != idata.Type )
        {
            continue;
        }
        
        [ scrollView addItem:data ];
    }
    
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    int count = [ scrollView getPageCount ];
    
    [ scrollView setPos:itemPage[ selectTab ] ];
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , itemPage[ selectTab ] + 1 , count ] ];
    
    [ pageLabel setHidden:!count ];
    
    [ self updateSelectItem ];
    [ self updateAlchemyItems ];
}


- ( void ) updateSelectItem
{
    for ( int i = 0 ; i < MAX_ITEM_SKILL ; ++i )
    {
        [ skillView[ i ] setHidden:YES ];
    }
    
    [ namelabel setText:@"" ];
    [ des1label setText:@"" ];
    [ deslabelPro setText:@"" ];
    
    if ( !selectItem )
    {
        return;
    }
    
    
    AlchemyConfigData* acData = [ [ AlchemyConfig instance ] getAlchemy:selectItem.AlchemyID ];
    ItemConfigData* item = [ [ ItemConfig instance ] getData:acData.ItemID ];
    
    if ( gActualResource.type >= RESPAD2 )
    {
        if ( item.Skill.count )
        {
            UIFont* font = des1label.font;
            [ des1label setFont:[ font fontWithSize:13 ] ];
        }
        else
        {
            UIFont* font = des1label.font;
            [ des1label setFont:[ font fontWithSize:17 ] ];
        }
    }
    else
    {
        if ( item.Skill.count )
        {
            UIFont* font = des1label.font;
            [ des1label setFont:[ font fontWithSize:10 ] ];
        }
        else
        {
            UIFont* font = des1label.font;
            [ des1label setFont:[ font fontWithSize:11 ] ];
        }
    }
    
    if ( item.Type == ICDT_WEAPON )
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
    }
    
    
    NSString* str2 = item.Des1;
//    if ( item.Quality )
//    {
//        NSString* str = [ NSString stringWithFormat:@"Quality%d" , item.Quality ];
//        NSString* str1 = NSLocalizedString( str , nil );
//        
//        str2 = [ NSString stringWithFormat:@"%@ %@" , str1 , item.Des1 ];
//    }
    
    [ namelabel setText:[ NSString stringWithFormat:@"【 %@ 】", item.Name ] ];
    [ des1label setText:str2 ];
    
    switch ( item.Color )
    {
        case 2:
            [ namelabel setTextColor:[ UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f ] ];
            break;
        case 3:
            [ namelabel setTextColor:[ UIColor colorWithRed:0.6f green:1.0f blue:1.0f alpha:1.0f ] ];
            break;
        case 4:
            [ namelabel setTextColor:[ UIColor colorWithRed:0.8f green:0.0f blue:1.0f alpha:1.0f ] ];
            break;
        default:
            [ namelabel setTextColor:[ UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f ] ];
            break;
    }

    
    for ( int i = 0 ; i < item.Skill.count ; ++i )
    {
        SkillConfigData* config = [ [ SkillConfig instance ] getSkill:[ [ item.Skill objectAtIndex:i ] intValue ] ];
        
        [ skillView[ i ] setHidden:NO ];
        [ skillView[ i ] setData:config.Name :config.ProfessionID :INVALID_ID :0 :config.AP ];
    }
}

- ( int ) getAlchemyNum:( int )item
{
    return [ [ alchemyNumDic objectForKey:[ NSNumber numberWithInt:item ] ] intValue ];
}

- ( void ) setAlchemyNum:( int )item :( int )num
{
    [ alchemyNumDic setObject:[ NSNumber numberWithInt:num ] forKey:[ NSNumber numberWithInt:item ] ];
}

- ( BOOL ) canAlchemyItem:( int )alchemyID
{
    AlchemyConfigData* acData = [ [ AlchemyConfig instance ] getAlchemy:alchemyID ];
    
    [ alchemyItemNumDic removeAllObjects ];
    
    NSArray* values = getSortKeys( alchemyNumDic );
    
    for ( int i = 0 ; i < values.count ; ++i )
    {
        int alchemyItemID = [ [ values objectAtIndex:i ] intValue ];
        int itemNum = [ [ alchemyNumDic objectForKey:[ values objectAtIndex:i ] ] intValue ];
        
        if ( itemNum )
        {
            AlchemyConfigData* acData = [ [ AlchemyConfig instance ] getAlchemy:alchemyItemID ];
            
            for ( int i = 0 ; i < acData.Items.count ; ++i )
            {
                AlchemyConfigItemData* ii = [ acData.Items objectAtIndex:i ];
                
                NSNumber* number = [ alchemyItemNumDic objectForKey:[ NSNumber numberWithInt:ii.ItemID ] ];
                
                if ( number )
                {
                    int nn = [number intValue ];
                    nn += ii.Number * itemNum;
                    
                    [ alchemyItemNumDic setObject:[ NSNumber numberWithInt:nn ]  forKey:[ NSNumber numberWithInt:ii.ItemID ] ];
                }
                else
                {
                    [ alchemyItemNumDic setObject:[ NSNumber numberWithInt:ii.Number * itemNum ]  forKey:[ NSNumber numberWithInt:ii.ItemID  ] ];
                }
            }
        }
    }
    
    
    for ( int i = 0 ; i < acData.Items.count ; ++i )
    {
        AlchemyConfigItemData* ii = [ acData.Items objectAtIndex:i ];
        PackItemData* pData = [ [ ItemData instance ] getItem:ii.ItemID ];
        
        NSNumber* number = [ alchemyItemNumDic objectForKey:[ NSNumber numberWithInt:ii.ItemID ] ];
        
        if ( !number )
        {
            number = [ NSNumber numberWithInt:ii.Number ];
        }
        else
        {
            int alchemyNum = [ [ alchemyNumDic objectForKey:[ NSNumber numberWithInt:alchemyID ] ] intValue ];
            
            if ( !alchemyNum )
            {
                number = [ NSNumber numberWithInt:[ number intValue ] +  ii.Number ];
            }
        }
        
        if ( [ number intValue ] > pData.Number || pData.Number == 0 )
        {
            return NO;
        }
    }

    return YES;
}

- ( void ) updateAlchemyItems
{
    [ alchemyItemNumDic removeAllObjects ];
    
    NSArray* values = getSortKeys( alchemyNumDic );
    
    for ( int i = 0 ; i < values.count ; ++i )
    {
        int alchemyItemID = [ [ values objectAtIndex:i ] intValue ];
        int itemNum = [ [ alchemyNumDic objectForKey:[ values objectAtIndex:i ] ] intValue ];
        
        if ( itemNum )
        {
            AlchemyConfigData* acData = [ [ AlchemyConfig instance ] getAlchemy:alchemyItemID ];

            for ( int i = 0 ; i < acData.Items.count ; ++i )
            {
                AlchemyConfigItemData* ii = [ acData.Items objectAtIndex:i ];
                
                NSNumber* number = [ alchemyItemNumDic objectForKey:[ NSNumber numberWithInt:ii.ItemID ] ];
                
                if ( number )
                {
                    int nn = [number intValue ];
                    nn += ii.Number * itemNum;
                    
                    [ alchemyItemNumDic setObject:[ NSNumber numberWithInt:nn ]  forKey:[ NSNumber numberWithInt:ii.ItemID ] ];
                }
                else
                {
                    [ alchemyItemNumDic setObject:[ NSNumber numberWithInt:ii.Number * itemNum ]  forKey:[ NSNumber numberWithInt:ii.ItemID  ] ];
                }
            }
        }
    }
    
    for ( int i = 0 ; i < MAX_ALCHEMY_ITEM ; ++i )
    {
        [ alchemyItem[ i ] setImage:NULL ];
        [ alchemyItemName[ i ] setText:@"" ];
        [ alchemyItemNeed[ i ] setText:@"" ];
        [ alchemyItemGet[ i ] setText:@"" ];
    }
    
    if ( !selectItem )
    {
        return;
    }
    
    AlchemyConfigData* acData = [ [ AlchemyConfig instance ] getAlchemy:selectItem.AlchemyID ];
    
    for ( int i = 0 ; i < acData.Items.count ; ++i )
    {
        AlchemyConfigItemData* ii = [ acData.Items objectAtIndex:i ];
        ItemConfigData* item = [ [ ItemConfig instance ] getData:ii.ItemID ];
        PackItemData* pData = [ [ ItemData instance ] getItem:ii.ItemID ];
        
        NSString* str = [ NSString stringWithFormat:@"%@" , item.Img ];
        NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
        UIImage* image = [ UIImage imageWithContentsOfFile:path ];
        
        [ alchemyItem[ i ] setImage:image ];
        [ alchemyItemName[ i ] setText:item.Name ];
        [ alchemyItemNeed[ i ] setText:[ NSString stringWithFormat:@"%d(%d)" , ii.Number * selectItem.Num , ii.Number ] ];
        
        NSNumber* number = [ alchemyItemNumDic objectForKey:[ NSNumber numberWithInt:ii.ItemID ] ];
        
        if ( !number )
        {
            number = [ NSNumber numberWithInt:ii.Number ];
        }
        else
        {
            if ( !selectItem.Num )
            {
                number = [ NSNumber numberWithInt:[ number intValue ] +  ii.Number ];
            }
        }
        
        
        if ( [ number intValue ] > pData.Number || pData.Number == 0 )
        {
            [ alchemyItemNeed[ i ] setTextColor:[ UIColor redColor ] ];
        }
        else
        {
            [ alchemyItemNeed[ i ] setTextColor:[ UIColor whiteColor ] ];
        }
        
        [ alchemyItemGet[ i ] setText:[ NSString stringWithFormat:@"%d" , pData.Number ] ];
    }
    
    for ( int i = 0 ; i < scrollView.DataCount ; ++i )
    {
        AlchemyUIItem* uiItem = (AlchemyUIItem*)[ scrollView getItem:i ];
        
        [ uiItem updateCanAlchemy ];
    }
}


- ( void ) scrollViewDidEndDecelerating:( UIScrollView* )sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    itemPage[ selectTab ] = index;
    
    [ pageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ scrollView getPageCount ] ] ];
}


- ( void ) onCloseClick
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}


- ( void ) onCreateClick
{
    for ( int i = 0 ; i < alchemyNumDic.count ; ++i )
    {
        int al = [ [ alchemyNumDic.allKeys objectAtIndex: i ] intValue ];
        int num = [ [ alchemyNumDic objectForKey: [ alchemyNumDic.allKeys objectAtIndex: i ] ] intValue ];
        
        if ( num )
        {
            BOOL b = [ [ ItemData instance ] canAlchemy:al :num ];
            
            if ( !b )
            {
                playSound( PST_ERROR );
                
                [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"WorkUpError3", nil )  ];
                
                return;
            }
        }
    }
    
    BOOL b = NO;
    
    for ( int i = 0 ; i < alchemyNumDic.count ; ++i )
    {
        int al = [ [ alchemyNumDic.allKeys objectAtIndex: i ] intValue ];
        int num = [ [ alchemyNumDic objectForKey: [ alchemyNumDic.allKeys objectAtIndex: i ] ] intValue ];
        
        if ( num )
        {
            b = YES;
            [ [ ItemData instance ] alchemyItem:al :num ];
        }
    }
    
    if ( b )
    {
        [ self updateItemList ];
        
        playSound( PST_ALCHEMY );
        
        [ [ AlertUIHandler instance ] alert:NSLocalizedString( @"Alchemy", nil )  ];
    }
}


- ( void ) onClick:( AlchemyUIItem* )item
{
    if ( !item )
    {
        return;
    }
    
    selectItem = item;
    
    [ item setNew:NO ];
    
    [ self updateSelectItem ];
    [ self updateAlchemyItems ];
}


- ( void ) update:(float)delay
{
    [ scrollView update:delay ];
}


@end

