//
//  MonsterMapScene.m
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "MonsterMapScene.h"
#import "MonsterUIHandler.h"

@implementation MonsterMapScene

MonsterMapScene* gMonsterMapScene = NULL;
+ ( MonsterMapScene* )instance
{
    if ( !gMonsterMapScene )
    {
        gMonsterMapScene = [ [ MonsterMapScene alloc ] init ];
    }
    
    return gMonsterMapScene;
}


- ( void ) setBG:( NSString* )name1
{
    [ [ MonsterUIHandler instance ] setBG:name1 ];
}


- ( void ) onEnterMap
{
    [ [ MonsterUIHandler instance ] visible:YES ];
    
    //[ [ GameAudioManager instance ] playMusic:@"BGM040" ];
}


- ( void ) onExitMap
{
    [ [ MonsterUIHandler instance ] visible:NO ];
}


@end
