//
//  ShopUIHandler.m
//  sc
//
//  Created by fox on 13-11-5.
//
//

#import "ShopUIHandler.h"
#import "ItemData.h"
#import "GameSceneManager.h"
#import "PlayerData.h"
#import "BuyItemConfig.h"
#import "TalkUIHandler.h"

@implementation ShopUIHandler

@synthesize BuyMode;

static ShopUIHandler* gShopUIHandler;
+ (ShopUIHandler*) instance
{
    if ( !gShopUIHandler )
    {
        gShopUIHandler = [ [ ShopUIHandler alloc] init ];
        [ gShopUIHandler initUIHandler:@"ShopUIView" isAlways:YES isSingle:NO ];
    }
    
    return gShopUIHandler;
}


- ( void ) onInited
{
    shopItemNum = [ [ NSMutableDictionary alloc ] init ];
    
    scrollView = (ShopSellScrollView*)[ view viewWithTag:3000 ];
    scrollView.delegate = self;
    scrollPageLabel = ( UILabel* )[ view viewWithTag:3001 ];
    
    [ scrollView initFastScrollView:[ uiArray objectAtIndex:1 ] :self :@selector( onItemClick: ) ];
    
    namelabel = ( UILabel* )[ view viewWithTag:3010 ];
    des1label = ( UITextView* )[ view viewWithTag:3011 ];
    
    
    UIButton* button = (UIButton*)[ view viewWithTag:2131 ];
    [ button addTarget:self action:@selector( onCloseClick ) forControlEvents:UIControlEventTouchUpInside ];
    button = (UIButton*)[ view viewWithTag:2130 ];
    [ button addTarget:self action:@selector( onClearClick ) forControlEvents:UIControlEventTouchUpInside ];
    
    [ super onInited ];
    
    
    [ view setCenter:CGPointMake( SCENE_WIDTH * 0.5f , SCENE_HEIGHT * 0.5f ) ];
    
    
    goldLabel = ( UILabelStroke* )[ view viewWithTag:2132 ];
    sellLabel = ( UILabelStroke* )[ view viewWithTag:2133 ];
    userGoldLabel = ( UILabelStroke* )[ view viewWithTag:2134 ];
    
    buyImageView = (UIImageView*)[ view viewWithTag:3050 ];
    sellImageView = (UIImageView*)[ view viewWithTag:3051 ];
    
    buyButton = ( UIButton* )[ view viewWithTag:2410 ];
    sellButton = ( UIButton* )[ view viewWithTag:2411 ];
    
    [ buyButton addTarget:self action:@selector(onBuyClick) forControlEvents:UIControlEventTouchUpInside ];
    [ sellButton addTarget:self action:@selector(onSellClick) forControlEvents:UIControlEventTouchUpInside ];
}

- ( void ) onBuyClick
{
    [ self changeMode:YES ];
    playSound( PST_OK );
}

- ( void ) onSellClick
{
    [ self changeMode:NO ];
    playSound( PST_OK );
}


- ( void ) changeMode:( BOOL )b
{
    BuyMode = b;
    
    [ buyImageView setHidden:b ];
    [ sellImageView setHidden:!b ];
    
    [ buyButton setEnabled:!b ];
    [ sellButton setEnabled:b ];
    
    if ( BuyMode )
    {
        [ self updateBuyItemData ];
    }
    else
    {
        [ self updateSellItemData ];
    }
    
    [ self updateData ];
}


- ( void ) onItemClick:( ShopListItem* )item
{
    if ( !item )
    {
        [ self updateData ];
    }
    
    if ( selectItem == item )
    {
        return;
    }
    
    selectItem = item;
    
    [ self updateSelectItem ];
}


- ( void ) updateBuyItemData
{
    if ( !view )
    {
        return;
    }
    
    [ shopItemNum removeAllObjects ];
    [ scrollView clear ];
    
    selectItem = NULL;
    
    NSArray* arr = [ BuyItemConfig instance ].Array;
    
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        NSArray* a = [ arr objectAtIndex:i ];
        
        for ( fint32 j = 0 ; j < a.count ; ++j )
        {
            [ scrollView addItem:[ a objectAtIndex:j ]  ];
        }
    }
    
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    int count = [ scrollView getPageCount ];
    
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ scrollPageLabel setHidden:!count ];
    
    [ self updateSelectItem ];
    [ self updateItemState ];
}


- ( void ) updateSellItemData
{
    if ( !view )
    {
        return;
    }
    
    [ shopItemNum removeAllObjects ];
    [ scrollView clear ];
    
    selectItem = NULL;
    
    
    for ( int i = 0 ; i <= ICDT_MATERIAL ; ++i )
    {
        NSMutableDictionary* dic = [ [ ItemData instance ] getType:i ];
        
        NSArray* allkeys = getSortKeys( dic );
        
        for ( fint32 j = 0 ; j < allkeys.count ; ++j )
        {
            PackItemData* data = [ dic objectForKey:[ allkeys objectAtIndex:j ] ];
            ItemConfigData* cdata = [ [ ItemConfig instance ] getData:data.ItemID ];
            
            if ( !data.Number || !cdata.Sell )
            {
                continue;
            }
            
            [ scrollView addItem:[ NSNumber numberWithInt:data.ItemID ] ];
        }
    }
    
    int count = [ scrollView getPageCount ];
    [ scrollView updateContentSize ];
    [ scrollView setNeedsLayout ];
    
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , 1 , count ] ];
    [ scrollPageLabel setHidden:!count ];
    
    [ self updateSelectItem ];
    [ self updateItemState ];
}


- ( void ) updateSelectItem
{
    [ namelabel setText:@"" ];
    [ des1label setText:@"" ];
    
    if ( !selectItem )
    {
        return;
    }
    
    ItemConfigData* item = [ [ ItemConfig instance ] getData:selectItem.ItemID ];
    
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
}


- ( void ) updateItemState
{
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv
{
    int index = fabs( sv.contentOffset.x ) / sv.frame.size.width;
    
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , index + 1 , [ scrollView getPageCount ] ] ];
    page = index;
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    selectItem = NULL;
    page = 0;
    
    [ self changeMode:YES ];
}


- ( void ) setShopItemNum:( int )item :( int )num
{
    [ shopItemNum setObject:[ NSNumber numberWithInt:num ]  forKey:[ NSNumber numberWithInt:item ] ];
}


- ( int ) getShopItemNum:( int )item
{
    return [ [ shopItemNum objectForKey:[ NSNumber numberWithInt:item ] ] intValue ];
}


- ( void ) updateData
{
    if ( !view )
    {
        return;
    }
    
    int gold = 0;
    int count = shopItemNum.count;
    
    for ( int i = 0 ; i < count ; ++i )
    {
        int itemID = [ [ shopItemNum.allKeys objectAtIndex:i ] intValue ];
        int num = [ [ shopItemNum objectForKey:[ shopItemNum.allKeys objectAtIndex:i ] ] intValue ];
        
        if ( !num )
        {
            continue;
        }
        
        ItemConfigData* config = [ [ ItemConfig instance ] getData:itemID ];
        
        int sell = config.Sell;
        if ( config.Type2 )
        {
            sell = sell + sell * [ PlayerData instance ].WorkItemEffect[ config.Type2 + ICDET_SELL1 - 1 ];
        }
        BuyMode ? gold -= config.Buy * num : gold += sell * num;
    }
    
    [ goldLabel setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ].Gold ] ];
    
    if ( BuyMode )
    {
        [ sellLabel setText:[ NSString stringWithFormat:@"%d" , gold ] ];
    }
    else
    {
        if ( gold )
        {
            [ sellLabel setText:[ NSString stringWithFormat:@"+%d" , gold ] ];
        }
        else
        {
            [ sellLabel setText:[ NSString stringWithFormat:@"%d" , gold ] ];
        }
    }
    
    if ( [ PlayerData instance ].Gold + gold < 0 )
    {
        [ userGoldLabel setTextColor:[ UIColor redColor ] ];
        canBuy = NO;
    }
    else
    {
        [ userGoldLabel setTextColor:[ UIColor whiteColor ] ];
        canBuy = YES;
    }
    
    [ userGoldLabel setText:[ NSString stringWithFormat:@"%d" , [ PlayerData instance ].Gold + gold ] ];
}


- ( void ) onCloseClick
{
    [ self onOver ];
    
//    [ [ TalkUIHandler instance ] visible:YES ];
//    [ [ TalkUIHandler instance ] setData:1301 ];
//    [ [ TalkUIHandler instance ] setSel:self :@selector( onOver ) ];
    
    [ self visible:NO ];
    playSound( PST_CANCEL );
}

- ( void ) onOver
{
    [ [ GameSceneManager instance ] activeScene:GS_CITY ];
}


- ( void ) onClearClick
{
    if ( !canBuy && BuyMode )
    {
        return;
    }
    
    int count = shopItemNum.count;
    
    for ( int i = 0 ; i < count ; ++i )
    {
        int itemID = [ [ shopItemNum.allKeys objectAtIndex:i ] intValue ];
        int num = [ [ shopItemNum objectForKey:[ shopItemNum.allKeys objectAtIndex:i ] ] intValue ];
        
        if ( !num )
        {
            continue;
        }
        
        if ( BuyMode )
        {
            [ [ ItemData instance ] buyItem:itemID :num ];
        }
        else
        {
            [ [ ItemData instance ] sellItem:itemID :num ];
        }
    }
    
    [ self changeMode:BuyMode ];
    
    [ scrollView setPos:page ];
    [ scrollPageLabel setText:[ NSString stringWithFormat:@"%d/%d" , page + 1 , [ scrollView getPageCount ] ] ];
    
    [ self updateData ];
    playSound( PST_OK );
}


- ( void ) onClick:( UIButton* )button
{
    
}



@end
