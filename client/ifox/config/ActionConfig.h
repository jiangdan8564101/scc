//
//  ActionConfig.h
//  sc
//
//  Created by fox on 13-4-29.
//
//

#import "GameConfig.h"

@interface ActionConfig : GameConfig
{
    NSMutableDictionary* actionDic;
}


+ ( ActionConfig* ) instance;

- ( NSDictionary* ) getAction:( NSString* )str;




@end
