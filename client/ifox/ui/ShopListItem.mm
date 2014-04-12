//
//  ShopItemView.m
//  sc
//
//  Created by fox on 13-11-5.
//
//

#import "ShopListItem.h"
#import "ItemConfig.h"
#import "ItemData.h"
#import "ShopUIHandler.h"
#import "PlayerData.h"

@implementation ShopListItem
@synthesize ItemID , Num;

- ( void ) setData:( NSObject* ) d
{
    NSNumber* nnn = (NSNumber*)d;
    ItemID = [ nnn intValue ];
    
    ItemConfigData* config = [ [ ItemConfig instance ] getData:ItemID ];
    PackItemData* itemdata = [ [ ItemData instance ] getItem:ItemID ];
    
    UILabel* name = (UILabel*)[ self viewWithTag:500 ];
    UILabel* num1 = (UILabel*)[ self viewWithTag:501 ];
    UILabel* num2 = (UILabel*)[ self viewWithTag:502 ];
    UILabel* num3 = (UILabel*)[ self viewWithTag:503 ];
    UILabel* num4 = (UILabel*)[ self viewWithTag:506 ];
    
    int n = itemdata ? itemdata.Number : 0;
    
    int sell = config.Sell;
    if ( config.Type2 )
    {
        sell = sell + sell * [ PlayerData instance ].WorkItemEffect[ ICDET_SELL1 + config.Type2 - 1 ];
    }
    
    Num = [ [ ShopUIHandler instance ] getShopItemNum:ItemID ];
    [ num2 setText:[ NSString stringWithFormat:@"%d" , [ ShopUIHandler instance ].BuyMode ? config.Buy : sell ] ];
    [ num1 setText:[ NSString stringWithFormat:@"%d" , n ] ];
    [ name setText:config.Name ];
    
    [ num3 setText:[ NSString stringWithFormat:@"%d" , Num ] ];
    [ num4 setText:[ NSString stringWithFormat:@"%d" , [ ShopUIHandler instance ].BuyMode ? Num * config.Buy : Num * sell ] ];
    
    UIButton* button1 = (UIButton*)[ self viewWithTag:504 ];
    UIButton* button2 = (UIButton*)[ self viewWithTag:505 ];
    UIButton* button3 = (UIButton*)[ self viewWithTag:507 ];
    
    button3.hidden = [ ShopUIHandler instance ].BuyMode;
    
    [ button1 addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside ];
    [ button2 addTarget:self action:@selector(onDec) forControlEvents:UIControlEventTouchUpInside ];
    [ button3 addTarget:self action:@selector(onAll) forControlEvents:UIControlEventTouchUpInside ];
}


- ( void ) updateData
{
    ItemConfigData* config = [ [ ItemConfig instance ] getData:ItemID ];
    
    int sell = config.Sell;
    if ( config.Type2 )
    {
        sell = sell + sell * [ PlayerData instance ].WorkItemEffect[ ICDET_SELL1 + config.Type2 - 1 ];
    }
    
    UILabel* num1 = (UILabel*)[ self viewWithTag:503 ];
    UILabel* num2 = (UILabel*)[ self viewWithTag:506 ];
    
    [ num1 setText:[ NSString stringWithFormat:@"%d" , Num ] ];
    [ num2 setText:[ NSString stringWithFormat:@"%d" , [ ShopUIHandler instance ].BuyMode ? Num * config.Buy : Num * sell ] ];
    
    [ [ ShopUIHandler instance ] setShopItemNum:ItemID :Num ];
    [ [ ShopUIHandler instance ] updateData ];
}


- ( void ) onAdd
{
    Num++;
    
    PackItemData* itemdata = [ [ ItemData instance ] getItem:ItemID ];
    
    if ( [ ShopUIHandler instance ].BuyMode )
    {
        if ( Num > MAX_ITEM - itemdata.Number )
        {
            Num = MAX_ITEM - itemdata.Number;
        }
    }
    else
    {
        if ( Num > itemdata.Number )
        {
            Num = itemdata.Number;
        }
    }
    
    [ self updateData ];
}


- ( void ) onAll
{
    Num = MAX_ITEM;
    
    PackItemData* itemdata = [ [ ItemData instance ] getItem:ItemID ];
    
    if ( [ ShopUIHandler instance ].BuyMode )
    {
        if ( Num > MAX_ITEM - itemdata.Number )
        {
            Num = MAX_ITEM - itemdata.Number;
        }
    }
    else
    {
        if ( Num > itemdata.Number )
        {
            Num = itemdata.Number;
        }
    }
    
    [ self updateData ];
}


- ( void ) onDec
{
    Num--;
    
    if ( Num < 0 )
    {
        Num = 0;
    }
    
    [ self updateData ];
}


- ( void ) setSelect:( BOOL )b
{
    //UIImageView* iv = ( UIImageView* )[ self viewWithTag:300 ];
    //[ iv setHidden:!b ];
}


- ( void ) clear
{
//    Num = 0;
//    
//    PackItemData* itemdata = [ [ ItemData instance ] getItem:ItemID ];
//
//    
//    UILabel* num1 = (UILabel*)[ self viewWithTag:501 ];
//    UILabel* num3 = (UILabel*)[ self viewWithTag:503 ];
//    UILabel* num4 = (UILabel*)[ self viewWithTag:506 ];
//    
//    [ num4 setText:[ NSString stringWithFormat:@"%d" , 0 ] ];
//    [ num3 setText:[ NSString stringWithFormat:@"%d" , 0 ] ];
//    
//    int n = itemdata ? itemdata.Number : 0;
//    
//    [ num1 setText:[ NSString stringWithFormat:@"%d" , n ] ];
}


@end
