//
//  CityOutMapScene.m
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "CityOutMapScene.h"
#import "CityOutUIHandler.h"



@implementation CityOutMapScene

CityOutMapScene* gCityOutMapScene = NULL;
+ ( CityOutMapScene* )instance
{
    if ( !gCityOutMapScene )
    {
        gCityOutMapScene = [ [ CityOutMapScene alloc ] init ];
    }
    
    return gCityOutMapScene;
}

- ( void ) setBG:( NSString* )name1
{
    [ [ CityOutUIHandler instance ] setBG:name1 ];
}
- ( void ) fade:( float )f
{
    [ [ CityOutUIHandler instance ] fade:f ];
}
- ( void ) fadeRight:( float )f
{
    [ [ CityOutUIHandler instance ] fadeRight:f ];
}
- ( void ) fadeLeft:( float )f
{
    [ [ CityOutUIHandler instance ] fadeLeft:f ];
}
- ( void ) onEnterMap
{
    [ [ CityOutUIHandler instance ] visible:YES ];
    
    //[ [ GameAudioManager instance ] playMusic:@"BGM040" ];
}

- ( void ) onExitMap
{
    [ [ CityOutUIHandler instance ] visible:NO ];
}

@end
