//
//  AlchemyUIItem.m
//  sc
//
//  Created by fox on 13-11-2.
//
//

#import "AlchemyUIItem.h"
#import "AlchemyConfig.h"
#import "ItemConfig.h"
#import "ItemData.h"
#import "AlchemyUIHandler.h"

@implementation AlchemyUIItem
@synthesize AlchemyID , Index , Num;

- ( void ) setData:( NSObject* )d
{
    AlchemyConfigData* data = ( AlchemyConfigData* )d;
    AlchemyID = data.AlchemyID;
    
    AlchemyConfigData* config = [ [ AlchemyConfig instance ] getAlchemy:AlchemyID ];
    PackItemData* itemData = [ [ ItemData instance ] getItem:data.ItemID ];
    ItemConfigData* config1 = [ [ ItemConfig instance ] getData:config.ItemID ];
    
    UILabel* name = (UILabel*)[ self viewWithTag:501 ];
    UILabel* num = (UILabel*)[ self viewWithTag:502 ];
    
    [ name setText:config1.Name ];
    [ num setText:[ NSString stringWithFormat:@"%d" , itemData.Number ] ];

    Num = [ [ AlchemyUIHandler instance ] getAlchemyNum:AlchemyID ];
    [ self updateData ];
    
    UIButton* button1 = (UIButton*)[ self viewWithTag:504 ];
    UIButton* button2 = (UIButton*)[ self viewWithTag:505 ];
    
    [ self updateCanAlchemy ];
    
    if ( !itemData )
    {
        [ self setNever:YES ];
        [ self setNew:YES ];
    }
    else
    {
        [ self setNever:itemData.alchemyItem ];
        [ self setNew:itemData.newItem ];
    }
    
    [ button1 addTarget:self action:@selector( onAdd ) forControlEvents:UIControlEventTouchUpInside ];
    [ button2 addTarget:self action:@selector( onDec ) forControlEvents:UIControlEventTouchUpInside ];
}


- ( void ) updateCanAlchemy
{
    UILabel* name = (UILabel*)[ self viewWithTag:501 ];
    //UILabel* num = (UILabel*)[ self viewWithTag:502 ];
    
    BOOL b = [ [ AlchemyUIHandler instance ] canAlchemyItem:AlchemyID ];
    
    if ( b )
    {
        [ name setTextColor:[ UIColor whiteColor ] ];
    }
    else
    {
        [ name setTextColor:[ UIColor redColor ] ];
    }
}


- ( void ) updateData
{
    UILabel* num1 = (UILabel*)[ self viewWithTag:503 ];
    
    [ num1 setText:[ NSString stringWithFormat:@"%d" , Num ] ];
    
    [ [ AlchemyUIHandler instance ] setAlchemyNum:AlchemyID :Num ];
}


- ( void ) setNew:( BOOL )b
{
    UIImageView* imageViewNever = (UIImageView*)[ self viewWithTag:507 ];
    
    [ imageViewNever setHidden:YES ];
    
    AlchemyConfigData* acData = [ [ AlchemyConfig instance ] getAlchemy:AlchemyID ];
    PackItemData* itemData = [ [ ItemData instance ] getItem:acData.ItemID ];
    
    itemData.newItem = b;
}


- ( void ) setNever:( BOOL ) b
{
    UIImageView* imageViewNever = (UIImageView*)[ self viewWithTag:506 ];
    
    [ imageViewNever setHidden:!b ];
}

- ( void ) onAdd
{
    Num++;
    
    [ self updateData ];
    [ self setNew:NO ];
}

- ( void ) onDec
{
    Num--;
    
    if ( Num < 0 )
    {
        Num = 0;
    }
    
    [ self updateData ];
    [ self setNew:NO ];
}



- ( void ) setSelect:( BOOL )b
{
    
}


- ( void ) clear
{
    
}

@end
