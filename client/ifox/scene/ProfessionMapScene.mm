//
//  ProfessionMapScene.m
//  sc
//
//  Created by fox on 13-11-25.
//
//

#import "ProfessionMapScene.h"
#import "ProfessionUIHandler.h"
#import "ProfessionUIBGHandler.h"
#import "TalkUIHandler.h"
#import "PlayerData.h"


@implementation ProfessionMapScene


ProfessionMapScene* gProfessionMapScene = NULL;
+ ( ProfessionMapScene* )instance
{
    if ( !gProfessionMapScene )
    {
        gProfessionMapScene = [ [ ProfessionMapScene alloc ] init ];
    }
    
    return gProfessionMapScene;
}



- ( void ) onEnterMap
{
    [ [ ProfessionUIBGHandler instance ] visible:YES ];
    
    
    if ( [ [ PlayerData instance ] checkStory ] )
    {
        [ [ ProfessionUIHandler instance ] visible:YES ];
        return;
    }
    
    [ [ TalkUIHandler instance ] visible:YES ];
    [ [ TalkUIHandler instance ] setData:1200 ];
    [ [ TalkUIHandler instance ] setSel:self :@selector( onOver ) ];
}


- ( void ) onOver
{
    [ [ ProfessionUIBGHandler instance ] setImage:[ [ TalkUIHandler instance ] getImageRight ] ];
    [ [ ProfessionUIHandler instance ] visible:YES ];
    [ [ TalkUIHandler instance ] clearImage ];
}

- ( void ) onExitMap
{
    [ [ ProfessionUIBGHandler instance ] visible:NO ];
    [ [ ProfessionUIHandler instance ] visible:NO ];
}



@end



