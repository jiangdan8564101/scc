//
//  BattleCreatureInfoUIHandler.m
//  sc
//
//  Created by fox on 13-5-1.
//
//

#import "BattleCreatureInfoUIHandler.h"

@implementation BattleCreatureInfoUIHandler

static BattleCreatureInfoUIHandler* gBattleCreatureInfoUIHandler;
+ (BattleCreatureInfoUIHandler*) instance
{
    if ( !gBattleCreatureInfoUIHandler )
    {
        gBattleCreatureInfoUIHandler = [ [ BattleCreatureInfoUIHandler alloc] init ];
        [ gBattleCreatureInfoUIHandler initUIHandler:@"BattleCreatureInfoView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleCreatureInfoUIHandler;
}


- ( void ) onInited
{
    [ view setCenter:CGPointMake( SCENE_WIDTH * 0.5f , SCENE_HEIGHT - view.frame.size.height * 0.5f ) ];
}


- ( void ) setData:( BattleCreature* )c
{
    CreatureCommonData* data = c.CommonData;
    
    UILabel* label = (UILabel*)[ view viewWithTag:1000 ];
    [label setText:[ NSString stringWithFormat:@"%d" , data.Level ] ];
    
    label = (UILabel*)[ view viewWithTag:1001 ];
    [label setText:[ NSString stringWithFormat:@"%d" , data.EXP ] ];
    
    label = (UILabel*)[ view viewWithTag:1002 ];
    [label setText:[ NSString stringWithFormat:@"%d/%d" , data.BaseData.HP , data.BaseData.MaxHP ] ];
    label = (UILabel*)[ view viewWithTag:1003 ];
    [label setText:[ NSString stringWithFormat:@"%d/%d" , data.BaseData.SP , data.BaseData.MaxSP ] ];
    label = (UILabel*)[ view viewWithTag:1004 ];
    [label setText:[ NSString stringWithFormat:@"%d/%d" , data.BaseData.FS , data.BaseData.MaxFS ] ];

}

@end






