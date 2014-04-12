//
//  PublicMapScene.m
//  sc
//
//  Created by fox on 13-9-8.
//
//

#import "PublicMapScene.h"
#import "PublicUIHandler.h"
#import "PublicUIBGHandler.h"
#import "TalkUIHandler.h"
#import "PlayerData.h"
#import "InfoQuestUIHandler.h"
#import "InfoQuestReportUIHandler.h"


@implementation PublicMapScene


PublicMapScene* gPublicMapScene = NULL;
+ ( PublicMapScene* )instance
{
    if ( !gPublicMapScene )
    {
        gPublicMapScene = [ [ PublicMapScene alloc ] init ];
    }
    
    return gPublicMapScene;
}


- ( void ) onEnterMap
{
    [ [ PublicUIBGHandler instance ] visible:YES ];
    
    [ [ GameAudioManager instance ] playMusic:@"BGM003" :0 ];
    
    if ( [ [ PlayerData instance ] checkStory ] )
    {
        return;
    }
    
    
    
    [ [ TalkUIHandler instance ] visible:YES ];
    [ [ TalkUIHandler instance ] setData:1100 ];
    [ [ TalkUIHandler instance ] setSel:self :@selector( onOver ) ];
}


- ( void ) onOver
{
    [ [ PublicUIBGHandler instance ] setImage:[ [ TalkUIHandler instance ] getImageRight ] ];
    [ [ PublicUIHandler instance ] visible:YES ];
    
    [ [ TalkUIHandler instance ] clearImage ];
}


- ( void ) onExitMap
{
    [ [ PublicUIBGHandler instance ] visible:NO ];
    [ [ PublicUIHandler instance ] visible:NO ];
    
    [ [ InfoQuestReportUIHandler instance ] visible:NO ];
    [ [ InfoQuestUIHandler instance ] visible:NO ];
}




@end
