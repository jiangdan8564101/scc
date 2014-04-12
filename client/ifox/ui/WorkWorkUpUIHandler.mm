//
//  WorkWorkUpUIHandler.m
//  sc
//
//  Created by fox on 13-11-21.
//
//

#import "WorkWorkUpUIHandler.h"
#import "WorkUpConfig.h"
#import "ItemConfig.h"
#import "ItemData.h"
#import "PlayerData.h"
#import "WorkWorkUIHandler.h"
#import "AlertUIHandler.h"
#import "GameAudioManager.h"

@implementation WorkWorkUpUIHandler

static WorkWorkUpUIHandler* gWorkWorkUpUIHandler;
+ (WorkWorkUpUIHandler*) instance
{
    if ( !gWorkWorkUpUIHandler )
    {
        gWorkWorkUpUIHandler = [ [ WorkWorkUpUIHandler alloc] init ];
        [ gWorkWorkUpUIHandler initUIHandler:@"WorkWorkUpView" isAlways:YES isSingle:NO ];
    }
    
    return gWorkWorkUpUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button1 = (UIButton*)[ view viewWithTag:301 ];
    UIButton* button2 = (UIButton*)[ view viewWithTag:302 ];
    
    [ button1 addTarget:self action:@selector(onOK) forControlEvents:UIControlEventTouchUpInside ];
    [ button2 addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside ];
    
    
    ivItem0 = (UIImageView*)[ view viewWithTag:320 ];
    ivItem1 = (UIImageView*)[ view viewWithTag:330 ];
    nameItem0 = (UILabel*)[ view viewWithTag:321 ];
    nameItem1 = (UILabel*)[ view viewWithTag:331 ];
    needItem0 = (UILabel*)[ view viewWithTag:322 ];
    needItem1 = (UILabel*)[ view viewWithTag:332 ];
    numItem0 = (UILabel*)[ view viewWithTag:323 ];
    numItem1 = (UILabel*)[ view viewWithTag:333 ];
}

- ( void ) setData:( int )t
{
    type = t;
    int l = [ PlayerData instance ].WorkLevel[ t ];
    
    WorkUpConfigItemData* data = [ [ [ WorkUpConfig instance ] getWorkUp:l ].Array objectAtIndex:t ];
    ItemConfigData* itemData = [ [ ItemConfig instance ] getData:data.Item0 ];
    PackItemData* packData = [ [ ItemData instance ] getItem:data.Item0 ];
    
    NSString* str = [ NSString stringWithFormat:@"%@" , itemData.Img ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
    
    [ ivItem0 setImage:[ UIImage imageWithContentsOfFile:path ] ];
    [ nameItem0 setText:itemData.Name ];
    [ needItem0 setText:[ NSString stringWithFormat:@"%d" , data.Num0 ] ];
    [ numItem0 setText:[ NSString stringWithFormat:@"%d" , packData.Number ] ];
    
    
    itemData = [ [ ItemConfig instance ] getData:data.Item1 ];
    packData = [ [ ItemData instance ] getItem:data.Item1 ];
    
    str = [ NSString stringWithFormat:@"%@" , itemData.Img ];
    path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
    
    [ ivItem1 setImage:[ UIImage imageWithContentsOfFile:path ] ];
    [ nameItem1 setText:itemData.Name ];
    [ needItem1 setText:[ NSString stringWithFormat:@"%d" , data.Num1 ] ];
    [ numItem1 setText:[ NSString stringWithFormat:@"%d" , packData.Number ] ];
    
    UILabel* goldNum = (UILabel*)[ view viewWithTag:310 ];
    [ goldNum setText:[ NSString stringWithFormat:@"%d" , data.Gold ] ];
    
}

- ( void ) onOK
{
    if ( [ [ PlayerData instance ] canWorkLevelUp:type ] )
    {
        [ [ PlayerData instance ] workLevelUp:type ];
        [ self visible:NO ];
        
        [ [ WorkWorkUIHandler instance ] updateData ];
        
        playSound( PST_OK );
    }
    else
    {
        playSound( PST_ERROR );
    }
}

- ( void ) onCancel
{
    [ self visible:NO ];
    
    playSound( PST_CANCEL );
}

- ( void ) onOpened
{
    type = INVALID_ID;
    
    
}
- ( void ) onClosed
{
    
}


@end
